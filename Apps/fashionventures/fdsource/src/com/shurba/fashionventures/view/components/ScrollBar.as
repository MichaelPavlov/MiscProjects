package com.shurba.fashionventures.view.components {
	import com.shurba.fashionventures.view.events.ScrollBarEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import com.greensock.*;
	import com.greensock.plugins.*;

	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	
	 
	 /**
	 Dispatched when a new items has been selected.
	 @eventType	com.shurba.fashionventures.view.events.ScrollBarEvent.POSITION_CHANGED
	 */
	[Event(name="positionChanged", type="com.shurba.fashionventures.view.events.ScrollBarEvent")] 
	 
	 
	public class ScrollBar extends Sprite {
		
		[Embed(source = '../../../../../../assets/scrollbar_handle.gif')]
		private var ScrollBarSlider:Class;
		
		[Embed(source = '../../../../../../assets/scrollbar_left.gif')]
		private var ScrollBarLeftBtn:Class;
		
		[Embed(source = '../../../../../../assets/scrollbar_repeatcenter.gif')]
		private var ScrollBarCenterBack:Class;
		
		[Embed(source = '../../../../../../assets/scrollbar_right.gif')]
		private var ScrollBarRightBtn:Class;
		
		
		private static const INITIAL_WIDTH:int = 100;
		private static const ASSET_TWEEN_TIME:Number = 0.5;
		private static const ASSET_OVER_COLOR:int = 0XFFFFFF;
		private static const SCROLL_DELTA:int = 10; // in percent
		
		public var btnLeft:AssetContainer;
		public var btnRight:AssetContainer;
		public var slider:AssetContainer;
		public var centerBack:AssetContainer;
		
		private var _draging:Boolean = false;
		
		private var sliderMaxPos:int;
		private var sliderMinPos:int;
		
		private var oldPosition:int;
		private var _position:int;
		
		public function ScrollBar() {
			super();
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([ColorTransformPlugin]);
			
			initializeView();
			addListeners();
		}
		
		private function addListeners():void{
			slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDownHandler, false, 0, true);
			btnLeft.addEventListener(MouseEvent.MOUSE_OVER, assetOverHandler, false, 0, true);
			btnRight.addEventListener(MouseEvent.MOUSE_OVER, assetOverHandler, false, 0, true);
			slider.addEventListener(MouseEvent.MOUSE_OVER, assetOverHandler, false, 0, true);
			
			btnLeft.addEventListener(MouseEvent.MOUSE_OUT, assetOutHandler, false, 0, true);
			btnRight.addEventListener(MouseEvent.MOUSE_OUT, assetOutHandler, false, 0, true);
			slider.addEventListener(MouseEvent.MOUSE_OUT, assetOutHandler, false, 0, true);
			
			btnLeft.addEventListener(MouseEvent.CLICK, btnLeftClickHanler, false, 0, true);
			btnRight.addEventListener(MouseEvent.CLICK, btnRightClickHanler, false, 0, true);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, mwheelHandler, false, 0, true);
			centerBack.addEventListener(MouseEvent.CLICK, backClickHandler, false, 0, true);
		}
		
		private function backClickHandler(e:MouseEvent):void {
			var halfSlider:int = slider.width / 2;
			var start:int = halfSlider + sliderMinPos;
			if (this.mouseX < start) {				
				this.position = 0;
				return;
			}
			var end:int = sliderMaxPos + halfSlider;
			if (this.mouseX > end) {
				this.position = 100;
				return;
			}
			var distance:int = end - start;
			var perc:int = Math.round(((this.mouseX - start) / distance) * 100);
			this.position = perc;
		}
		
		private function mwheelHandler(e:MouseEvent):void {
			if (e.delta > 0) 
				btnRightClickHanler(null);
			else 
				btnLeftClickHanler(null);
		}
		
		private function btnRightClickHanler(e:MouseEvent):void {
			var scrollNumber:int = Math.ceil(((centerBack.width - slider.width) / 100) * SCROLL_DELTA);
			var toX:int = slider.x + scrollNumber;			
			if (toX > sliderMaxPos) {
				toX = sliderMaxPos;
			}
			TweenLite.to(slider, 0.2, { x:toX } );
			var perc:int = sliderPositionToPercents(toX);
			changePosition(perc);
		}
		
		private function btnLeftClickHanler(e:MouseEvent):void {
			var scrollNumber:int = Math.ceil(((centerBack.width - slider.width) / 100) * SCROLL_DELTA);
			var toX:int = slider.x - scrollNumber;			
			if (toX < sliderMinPos) {
				toX = sliderMinPos;
			}
			TweenLite.to(slider, 0.2, { x:toX } );
			var perc:int = sliderPositionToPercents(toX);
			changePosition(perc);
		}
		
		private function sliderPositionToPercents(pos:int):int {
			if (pos <= sliderMinPos) {
				return 0;
			} else if (pos >= sliderMaxPos) {
				return 100;
			}
			
			var percents:int = Math.round(( pos / (centerBack.width - slider.width)) * 100);
			
			return percents;
		}
		
		private function percentsToSliderPosition(perc:int):int {
			trace (perc);
			if (perc <= 0) {
				return sliderMinPos;
			} else if (perc >= 100) {
				return sliderMaxPos;
			}
			
			var distance:int = sliderMaxPos - sliderMinPos;
			var sliderPos:int = (distance / 100) * perc + sliderMinPos;
			return sliderPos;
		}
		
		private function assetOutHandler(e:MouseEvent):void {
			if (_draging && e.currentTarget == slider) {
				return;
			}
			TweenLite.to(e.currentTarget, ASSET_TWEEN_TIME, {tint:null});
		}
		
		private function assetOverHandler(e:MouseEvent):void {
			TweenLite.to(e.currentTarget, ASSET_TWEEN_TIME, { colorTransform: { tint:ASSET_OVER_COLOR, tintAmount:0.3 }} );
		}
		
		private function sliderMouseUpHandler(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, sliderMouseUpHandler);
			slider.removeEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler);
			slider.stopDrag();
			_draging = false;
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(slider, ASSET_TWEEN_TIME, {tint:null});
		}
		
		private function sliderMouseDownHandler(e:MouseEvent):void {
			var rect:Rectangle = centerBack.getRect(this);
			rect.height = 0;
			rect.width -= slider.width;
			slider.startDrag(false, rect);
			_draging = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUpHandler, false, 0, true);
			slider.addEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler, false, 0, true);
		}
		
		private function sliderMoveHandler(e:MouseEvent):void {
			var perc:int = sliderPositionToPercents(slider.x);
			changePosition(perc);
		}
		
		private function initializeView():void {
			btnLeft = new AssetContainer(ScrollBarLeftBtn);
			btnRight = new AssetContainer(ScrollBarRightBtn);
			slider = new AssetContainer(ScrollBarSlider);
			centerBack = new AssetContainer(ScrollBarCenterBack);
			
			addChild(btnLeft);
			addChild(btnRight);
			addChild(centerBack);
			addChild(slider);
			
			btnLeft.buttonMode = true;
			btnRight.buttonMode = true;
			slider.buttonMode = true;
			
			this.width = INITIAL_WIDTH;
		}
		
		override public function set width(value:Number):void {
			centerBack.x = btnLeft.width - 5;			
			centerBack.width = value - btnLeft.width - btnRight.width;
			btnRight.x = centerBack.x + centerBack.width;
			slider.x = btnLeft.width - 5;
			
			sliderMaxPos = btnRight.x - slider.width;
			sliderMinPos = centerBack.x;
		}
		
		public function get position():int {
			return _position;
		}
		
		public function set position(value:int):void {
			_position = value;
			TweenLite.to(slider, 0.3, { x:percentsToSliderPosition(value) } );
			changePosition(_position);
		}
		
		public function changePosition(pos:int):void {			
			if (oldPosition == pos) return;
			if (pos > 100) {
				pos = 100;
			} else if (pos < 0) {
				pos = 0;
			}
			oldPosition = pos;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.POSITION_CHANGED, pos));
		}
		
	}

}