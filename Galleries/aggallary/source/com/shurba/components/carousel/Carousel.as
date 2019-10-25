package com.shurba.components.carousel {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import com.greensock.*;
	import com.shurba.components.carousel.CarouselEvent;
	
	
	[Event(name = "itemClick", type = "com.shurba.components.carousel.CarouselEvent")]
	[Event(name = "itemSelect", type = "com.shurba.components.carousel.CarouselEvent")]
	
	public class Carousel extends Sprite {
		private const TWEEN_TIME:Number = 0.5;
		
		public var zone1:int = 150;
		public var zone2:int = 80;
		
		public var mcMask:Sprite;
		public var mcBackground:Sprite;
		public var mcThumbContainer:Sprite;
		//public var mcLeftArrow:Sprite;
		//public var mcRightArrow:Sprite;
		public var nSeparation:Number;	
		public var nSpace:Number;
		public var nThumbWidth:Number;	
		public var nThumbHeight:Number;		
		public var nSpeed:Number;	
		public var nMovement:Number;	
		public var nItemsNum:Number;
		public var nChainWidth:Number;
		
		public var nMaxWidth:Number;	
		public var nMaxHeight:Number;
		public var paddingRight:Number;	
		public var paddingLeft:Number;
		
		public var selectedIndex:int = 0;
		
		private var aItems:Array;		
		public var bShowCurrentFlag:Boolean = false;
		public var bMoveFlag:Boolean = true;
		public var leftArrowShown:Boolean = false;
		public var rightArrowShown:Boolean = false;
		
		public var selectedItem:CarouselThumbnail;
		
		private var _dataProvider:CarouselParameters;
		
		private var timelineTween:TimelineLite = new TimelineLite();
		
		public function Carousel() {
			super();						
		}
		
		private function addListeners():void {
			this.addEventListener(Event.ENTER_FRAME, thisEnterFrameHandler);			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageListener, false, 0, true);
		}
		
		private function addedToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			this.setMovementDelta()
			
		}
		
		private function mouseLeaveHandler(e:Event):void {
			bMoveFlag = true;
			nMovement = -3;
		}
		
		public function selectFirstItem():void {
			selectedItem = aItems[0];
			selectedItem.selected = true;
			this.dispatchItemSelectedEvent();
		}
		
		private function removeListeners():void {		
			this.removeEventListener(Event.ENTER_FRAME, thisEnterFrameHandler);			
		}
		
		private function setVariables():void {
			nMaxWidth = 624;
			nMaxHeight = 432;
			nSpeed = 10;
			nMovement = -3;
			paddingRight = 20;
			paddingLeft = 20;
			nSeparation = _dataProvider.thumbsGap;
			nThumbWidth = _dataProvider.thumbWidth;
			nThumbHeight = _dataProvider.thumbHeight;
			nSpace = nThumbWidth + nSeparation;
		}
		
		public function updateSize():void {
			mcBackground.x = 0;
			mcBackground.y = 0;
			mcBackground.width = mcMask.width;
			mcBackground.height = mcMask.height;			
			mcThumbContainer.x = 0;
			mcThumbContainer.y = 3;			
		}
		
		public function selectNext():void {
			selectedItem.selected = false;
			selectedIndex++;
			if (selectedIndex == aItems.length) {
				selectedIndex = 0;
			}
			selectedItem = aItems[selectedIndex];
			selectedItem.selected = true;
			this.dispatchItemSelectedEvent();
		}
		
		override public function get width():Number { 
			return super.width; 
		}
		
		override public function set width(value:Number):void {
			mcMask.width = value
			this.updateSize();
		}
		
		override public function get height():Number { 
			return super.height; 
		}
		
		override public function set height(value:Number):void {			
			mcMask.height = value;
			this.updateSize();
		}
		
		private function attachThumbs():void {
			var tmpThumb:CarouselThumbnail;
			aItems = [];
			for (var i:int = 0; i < _dataProvider.thumbsData.length; i++) {
				tmpThumb = new CarouselThumbnail();
				mcThumbContainer.addChild(tmpThumb);
				tmpThumb.x = nSpace * i;
				tmpThumb.dataProvider = _dataProvider.thumbsData[i];
				aItems.push(tmpThumb);
				tmpThumb.addEventListener(MouseEvent.CLICK, thumbClickHandler, false, 0, true);
				tmpThumb.index = i;
			}
			
			nChainWidth = i * nSpace;			
			selectedItem = aItems[selectedIndex];
		}
		
		private function thumbClickHandler(e:MouseEvent):void {
			if (!(e.currentTarget as CarouselThumbnail).selected) {
				(e.currentTarget as CarouselThumbnail).selected = true;				
				selectedItem.selected = false;
				selectedItem = (e.currentTarget as CarouselThumbnail);
				selectedIndex = (e.currentTarget as CarouselThumbnail).index;
				this.dispatchItemSelectedEvent();
			}
			
			var carouselEvent:CarouselEvent = new CarouselEvent(CarouselEvent.ITEM_CLICK, (e.currentTarget as CarouselThumbnail).dataProvider);
			this.dispatchEvent(carouselEvent);
		}
		
		private function dispatchItemSelectedEvent():void {
			trace ("dispatch");
			var event:CarouselEvent = new CarouselEvent(CarouselEvent.ITEM_SELECT, selectedItem.dataProvider);
			this.dispatchEvent(event);
		}
		
		private function thisEnterFrameHandler($event:Event):void {			
			if (!bMoveFlag) {
				return;
			}
			
			for (var i:int = 0; i < aItems.length; i++ ) {
				aItems[i].x += nMovement;
				if (aItems[i].x > nChainWidth - nSpace) {
					aItems[i].x -= nChainWidth;
				} else if (aItems[i].x < -nThumbWidth) {
					aItems[i].x += nChainWidth;
				}
			}
		}
		
		private function setMovementDelta():void {
			if (this.mouseX > 0 && this.mouseX < zone1) {				
				nMovement = 3;
				bMoveFlag = true;
			} else {
				bMoveFlag = false;
			}
		}
		
		protected function init():void {
			this.setVariables();
			
			this.addListeners();			
			this.attachThumbs();
			this.updateSize();
		}
		
		public function get dataProvider():CarouselParameters { 
			return _dataProvider;
		}
		
		public function set dataProvider(value:CarouselParameters):void {
			_dataProvider = value;
			this.init();
		}
		
	}
	
}