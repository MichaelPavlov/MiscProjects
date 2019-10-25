package com.shurba.components.carousel {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import com.greensock.*;
	
	public class CarouselThumbnail extends Sprite {
		
		private const TWEEN_TIME:Number = 0.5;
		private const BORDER_THICKNESS:int = 2;
		private const BORDER_COLOR:int = 0x000000;
		private const BACK_COLOR:int = 0x121212;
		
		public var mcThumb:Sprite;
		public var border:Shape;
		public var textBack:Sprite;
		public var tintMask:Sprite;
		public var preloader:MovieClip;
		public var background:Sprite;
		
		public var description:TextField;
		
		public var sImageUrl:String;
		public var sLinkUrl:String;
		public var sTitle:String;
		
		private var thumbLoader:Loader;		
		private var nThumbWidth:Number;
		private var nThumbHeight:Number;
		
		private var _dataProvider:ThumbVO;
		
		private var _selected:Boolean = false;		
		
		public var index:int = -1;
		
		public function CarouselThumbnail() {
			super();
		}
		
		private function init():void {
			thumbLoader = new Loader();
			this.buttonMode = true;
			description.mouseEnabled = false;
			this.setDisplayList();
			
			this.addListeners();			
			this.loadImage();
		}
		
		protected function setDisplayList():void {
			this.addBackground();
			this.addBorder();
			tintMask.width = background.width;
			tintMask.height = background.height;
			tintMask.alpha = 0.3;
			
			preloader.x = background.width / 2;
			preloader.y = background.height / 2;
			
			textBack.width = _dataProvider.width;
			textBack.height = 35;			
			textBack.x = 0;
			textBack.y = _dataProvider.height - textBack.height;
			
			
			description.text = _dataProvider.description;
			
			description.x = 5;
			description.y = this.height - description.height - 15;
		}
		
		protected function addBorder():void {			
			border = new Shape();
			border.graphics.lineStyle(BORDER_THICKNESS, _dataProvider.thumbBorderColor);
			border.graphics.moveTo(0, 0);
			border.graphics.lineTo(_dataProvider.width, 0);
            border.graphics.lineTo(_dataProvider.width, _dataProvider.height);
            border.graphics.lineTo(0, _dataProvider.height);
            border.graphics.lineTo(0, 0);
			var grid:Rectangle = new Rectangle(20, 20, 60, 60);
			border.scale9Grid = grid;
			this.addChild(border);
			border.alpha = 0;
		}
		
		protected function addBackground():void {			
			background = new Sprite();
			background.graphics.beginFill(BACK_COLOR);
			background.graphics.drawRect(0, 0, _dataProvider.width, _dataProvider.height);
			background.graphics.endFill();
			
			
			this.addChildAt(background, 0);
			background.alpha = 1;
		}
		
		protected function setSize($width:int = 0, $height:int = 0) {
			if (!$width || !$height) {
				return;
			}
			
			
		}
		
		private function addListeners():void {
			thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbLoaderCompleteHandler, false, 0, true);
            thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, thisRollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler, false, 0, true);
		}
		
		private function removeListeners():void {
			thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbLoaderCompleteHandler);
			thumbLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, thisRollOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler);			
		}
		
		private function thumbLoaderCompleteHandler($event:Event):void {
			if (thumbLoader.content is Bitmap) {
				var $bitmapHandler:Bitmap = thumbLoader.content as Bitmap;
				$bitmapHandler.smoothing = true;
			}
			
			mcThumb.addChild(thumbLoader);
			this.updateThumbSize();
			mcThumb.mouseEnabled = false;
		}
		private function updateThumbSize():void {
			
			mcThumb.width = nThumbWidth;
			mcThumb.height = nThumbHeight * 2;
			
			
			preloader.visible = false;
			//background.width = nThumbWidth + nThumbWidth * 0.15;
			//background.height = nThumbHeight + nThumbHeight * 0.15;
			background.x = 0 -(background.width - nThumbWidth) / 2;
			background.y = 0 -(background.height - nThumbHeight) / 2;
			background.buttonMode = true;
			background.mouseEnabled = true;
		}
		
		private function loadImage():void {
			var request:URLRequest;
			request = new URLRequest(_dataProvider.thumbUrl);
			thumbLoader.load(request);			
		}
		
        private function ioErrorHandler($event:IOErrorEvent):void {
            trace("ioErrorHandler: " + $event.text);
        }
		
        private function thisRollOverHandler($event:MouseEvent):void {
			if (_selected) {
				return;
			}
			
			TweenLite.to(tintMask, TWEEN_TIME, { alpha:0 } );
        }
		
		private function thisRollOutHandler($event:MouseEvent):void {
			if (!_selected)
				TweenLite.to(tintMask, TWEEN_TIME, { alpha:0.3 } );
        }
		
		public function get dataProvider():ThumbVO { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:ThumbVO):void {
			_dataProvider = value;
			this.init();
		}
		
		public function get selected():Boolean { 
			return _selected; 
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			if (_selected) {
				TweenLite.to(tintMask, TWEEN_TIME, { alpha:0 } );
				TweenLite.to(border, TWEEN_TIME, { alpha:1 } );
			} else {
				TweenLite.to(tintMask, TWEEN_TIME, { alpha:0.3 } );
				TweenLite.to(border, TWEEN_TIME, { alpha:0 } );
			}
			
		}
	}	
}