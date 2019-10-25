package com.shurba.fashionventures.view.components {
	import com.shurba.fashionventures.model.vo.ItemVO;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class Tile extends Sprite {
		
		private var loader:Loader = new Loader();
		private var _data:ItemVO;
		private var loaded:Boolean = false;		
		private var _stretch:Boolean = false;
		
		public var background:Shape;
		
		public function Tile(width:int, height:int, data:ItemVO = null) {
			super();
			initializeBackground(width, height);
			initializeView();
			addListeners();
			if (data) initialize(data);
		}
		
		private function initializeView():void{
			addChild(loader);
			this.width = width;
			this.height = height;
		}
		
		private function initializeBackground():void{
			background = new Shape();
			addChild(background);
		}
		
		private function initialize():void{
			if (loaded) loader.unload();
			
			//TODO show preloader
			
			var request:URLRequest = new URLRequest(_data.imageUrl);
			loader.load(request);
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetLoadCompleteHandler, false, 0, true);
		}
		
		private function assetLoadCompleteHandler(e:Event):void {
			//TODO hide preloader
		}
		
		private function removelisteners():void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, assetLoadCompleteHandler);
		}
		
		public function destroy():void {
			removelisteners();
		}
		
		public function get data():ItemVO { return _data; }
		
		public function set data(value:ItemVO):void {
			_data = value;
			initialize(_data);
		}
		
		public function get stretch():Boolean { return _stretch; }
		
		public function set stretch(value:Boolean):void {
			_stretch = value;
		}
		
		
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void {			
			if (stretch) {
				super.width = value;
				loader.x = 0;
			} else {
				background.graphics.beginFill(0x00000, 0);
				background.graphics.moveTo(0, 0);				
				background.graphics.lineTo(value, 0);
				background.graphics.lineTo(value, background.height);
				background.graphics.lineTo(0, background.height);
				background.graphics.lineTo(0, 0);
				background.graphics.endFill();
				
				loader.x = (background.width - loader.width) / 2;
			}
			
		}
		
		override public function get height():Number { return super.height; }
		
		override public function set height(value:Number):void {
			if (stretch) {
				super.height = value;
			} else {
				background.graphics.beginFill(0x00000, 0);
				background.graphics.moveTo(0, 0);				
				background.graphics.lineTo(value, 0);
				background.graphics.lineTo(value, background.height);
				background.graphics.lineTo(0, background.height);
				background.graphics.lineTo(0, 0);
				background.graphics.endFill();
				
				loader.x = (background.height - loader.height) / 2;
			}
		}
	}

}