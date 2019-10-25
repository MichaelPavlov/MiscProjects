package com.webtako.flash {
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class Slide extends Sprite {
		public static const SLIDE_LOADED:String = "slideLoaded";
		public static const HIGHLIGHT_VALUE:Number = 0;		
		public static const UNHIGHLIGHT_VALUE:Number = -0.35;		
		public static const MAX_FRAME_SIZE:Number = 5;
		
		protected var _index:uint;
		protected var _path:String;
		protected var _extPath:String;
		protected var _caption:String;
		protected var _description:String;		
		protected var _bgColor:uint;
		protected var _color:uint;
		protected var _mouseoverColor:uint;			
		protected var _preloader:MovieClip;		
		protected var _content:DisplayObject;
		protected var _slideWidth:Number;
		protected var _slideHeight:Number;
		protected var _areaWidth:Number;
		protected var _areaHeight:Number;
		protected var _frame:Shape;
		protected var _selected:Boolean;				
		protected var _displayText:Boolean;
		protected var _displayNumber:Boolean;
		protected var _delay:Number;
		protected var _tooltip:Tooltip;
		protected var _background:Sprite;		
		protected var _maskSprite:Sprite;
		
		public function Slide(caption:String, description:String, path:String, extPath:String, 
							  slideWidth:Number, slideHeight:Number,
							  bgColor:uint = 0x000000, color:uint = 0xFFFFFF, mouseoverColor:uint = 0x0066FF, 
							  preloaderColor:uint = 0x0066FF, preloaderSize:Number = 40,
							  frameSize:Number = 0, delay:Number = 5000) {									
			//set properties
			this._caption = caption;
			this._description = description;
			this._path = path;
			this._extPath = extPath;
			this._slideWidth = slideWidth;
			this._slideHeight = slideHeight;
			this._bgColor = bgColor;
			this._color = color;
			this._mouseoverColor = mouseoverColor;
			frameSize = (frameSize >= 0 && frameSize <= MAX_FRAME_SIZE) ? frameSize : 1;			
			this._delay = delay;
			this._selected = false;
			this._displayText = (this._caption && this._caption != "") ? true : false;
			this._displayNumber = false;

			this._areaWidth = this._slideWidth;
			this._areaHeight = this._slideHeight;		
			
			//init frame				
			if (frameSize > 0) {
				this._frame = new Shape();
				this._frame.graphics.beginFill(this._color);
				this._frame.graphics.drawRect(0, 0, this._slideWidth, this._slideHeight);
				this._frame.graphics.endFill();
				this.addChild(this._frame);	
				this._areaWidth -= (2 * frameSize);
				this._areaHeight -= (2 * frameSize);
			}	
			
			//init background
			this.initBackground();
			 					
			//init preloader	
			this.initPreloader(preloaderColor, preloaderSize);
				
			//init mask							
			this.initContentMask(this._background, this._areaWidth, this._areaHeight);
						
			//init mouse behaviors
			this.buttonMode = true;		
			this.mouseEnabled = true;
			this.mouseChildren = true;			
			this.useHandCursor = true;		
			this.addEventListener(MouseEvent.MOUSE_OVER, onSlideOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,  onSlideOut);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onSlideMove);
		}
		
		//init background
		protected function initBackground():void {
			this._background = new Sprite();
			this._background.graphics.beginFill(this._bgColor);
			this._background.graphics.drawRect(0, 0, this._areaWidth, this._areaHeight);
			this._background.graphics.endFill();
			this._background.x = FlashUtil.getCenter(this._slideWidth, this._areaWidth);
			this._background.y = FlashUtil.getCenter(this._slideHeight, this._areaHeight);
			this.addChild(this._background);
		}
		
		//init preloader symbol
		protected function initPreloader(color:uint, size:Number):void {
			this._preloader = new PreloaderArrow();
			this._preloader.height = size;
			this._preloader.scaleX = this._preloader.scaleY;
			
			FlashUtil.setColor(this._preloader, color);

			this._preloader.x = FlashUtil.getCenter(this._areaWidth, size);
			this._preloader.y = FlashUtil.getCenter(this._areaHeight, size);
			this._background.addChild(this._preloader);
		}
		
		//init mask
		protected function initContentMask(obj:Sprite, maskWidth:Number, maskHeight:Number):void {
			this._maskSprite = new Sprite();
			this._maskSprite.graphics.beginFill(0x000000);
			this._maskSprite.graphics.drawRect(0, 0, maskWidth, maskHeight);	
			this._maskSprite.graphics.endFill();
			
			obj.mask = this._maskSprite;
			obj.addChild(this._maskSprite);		
		}
		
		//check if content is loaded
		public function get loaded():Boolean {
			return (this._content != null);
		}
		
		//load content from path
		public function loadContent():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(this._path));	
		}

		//on content load complete handler
		protected function onLoadComplete(event:Event):void {
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			this._content = loaderInfo.content;
			this.dispatchEvent(new Event(SLIDE_LOADED));
			
			this._content.alpha = 0;					
			if (!(this._content is MovieClip)) {
				this._content.x = Math.round((this._areaWidth - this._content.width)/2);
				this._content.y = Math.round((this._areaHeight - this._content.height)/2);
			}
			this._background.addChild(this._content);
			
			if (!this._selected) {
				Tweener.addTween(this._content, {_brightness:UNHIGHLIGHT_VALUE, time:0.1, transition:"linear"});
			}
			
			//fade in content
			Tweener.addTween(this._content, {alpha:1, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:cleanup});			
		}
		
		//on slide mouse over handler
		protected function onSlideOver(event:MouseEvent):void {
			if (!this._selected) {
				Tweener.addTween(this._content, {_brightness:HIGHLIGHT_VALUE, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
				if (this._frame) {
					Tweener.addTween(this._frame, {_color:this._mouseoverColor, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
				}
			}
			
			if (this._displayText && this._tooltip) {
				this._tooltip.assignText((this._displayNumber) ? (this._index + 1) + ". " + this._caption : this._caption);
				this._tooltip.display(event.stageX, event.stageY);
			}
		}
	
		//on slide move handler	
		protected function onSlideMove(event:MouseEvent):void {
			if (this._displayText && this._tooltip) {
				this._tooltip.move(event.stageX, event.stageY);	
				event.updateAfterEvent();					
			}
		}
		
		//on slide mouse out handler
		protected function onSlideOut(event:MouseEvent):void {
			if (!this._selected) {
				Tweener.addTween(this._content, {_brightness:UNHIGHLIGHT_VALUE, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
				if (this._frame) {
					Tweener.addTween(this._frame, {_color:this._color, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
				}
			}
			
			if (this._displayText && this._tooltip) {
				this._tooltip.hide();
			}
		}
		
		//highlight slide
		public function highlight():void {
			this._selected = true;
			
			if (this._frame) {
				Tweener.addTween(this._frame, {_color:this._mouseoverColor, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
			}
			
			Tweener.addTween(this._content, {_brightness:HIGHLIGHT_VALUE, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});			
		}	

		//unhighlight slide
		public function unhighlight():void {
			this._selected = false;
			
			if (this._frame) {
				Tweener.addTween(this._frame, {_color:this._color, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
			}
			
			Tweener.addTween(this._content, {_brightness:UNHIGHLIGHT_VALUE, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});			
		}	
			
		//cleanup after content loaded
		protected function cleanup():void {
			this._preloader.visible = false;
		}
		
		//on IO Error event handler
		protected function onIOError(event:IOErrorEvent):void {
			trace(event.text);
			this.dispatchEvent(new Event(SLIDE_LOADED));
		}
		
		//get slide index
		public function get index():uint {
			return this._index;	
		}
		
		//set slide index
		public function set index(val:uint):void {
			this._index = val;	
		}
		
		//get slide width		
		public function get slideWidth():Number {
			return this._slideWidth;
		}
		
		//get slide height
		public function get slideHeight():Number {
			return this._slideHeight;
		}
		
		//get external path
		public function get extPath():String {
			return this._extPath;	
		}
		
		//get content path
		public function get path():String {
			return this._path;	
		}
		
		//set content path
		public function set path(val:String):void {
			this._path = val;	
		}
		
		//get description
		public function get description():String {
			return this._description;	
		}
		
		//set description
		public function set description(val:String):void {
			this._description = val;	
		}
		
		//get caption
		public function get caption():String {
			return this._caption;
		}
		
		//set caption
		public function set caption(val:String):void {
			this._caption = val;	
			this._displayText = (this._caption && this._caption != "") ? true : false;
		}
		
		//get timer delay
		public function get delay():Number {
			return this._delay;
		}
		
		//set timer delay
		public function set delay(val:Number):void {
			this._delay = val;
		}
		
		//get tool tip
		public function get tooltip():Tooltip {
			return this._tooltip;	
		}
		
		//set tool tip
		public function set tooltip(val:Tooltip):void {
			this._tooltip = val;	
		}
		
		//get display number
		public function get displayNumber():Boolean {
			return this._displayNumber;
		}
		
		//set display number
		public function set displayNumber(val:Boolean):void {
			this._displayNumber = val;
			if (this._displayNumber && !this._displayText) {
				this._displayText = true;
			}
		}
		
		public function get content():DisplayObject {
			return this._content;
		}
	}
}