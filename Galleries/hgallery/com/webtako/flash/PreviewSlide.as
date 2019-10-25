package com.webtako.flash
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.TextShortcuts;
	TextShortcuts.init();
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	
	public class PreviewSlide extends Slide {
		public static const PREV_LABEL:String = "BACK";
		public static const NEXT_LABEL:String = "NEXT";
		
		private var _label:String;
		
		public function PreviewSlide(label:String, slideWidth:Number, slideHeight:Number,
							  bgColor:uint = 0x000000, color:uint = 0xFFFFFF, mouseoverColor:uint = 0x0066FF, 
							  preloaderColor:uint = 0x0066FF, preloaderSize:Number = 24) {
			this._label = label;			  	
			super(caption, "", "", "", slideWidth, slideHeight, bgColor, color, mouseoverColor, preloaderColor, preloaderSize, 0, 0);
		}

		//reset preview slide
		public function reset():void {
			//remove content
			if (this._content && this._background.contains(this._content)) {
				this._background.removeChild(this._content);
				this._content = null;
			}
			
			//add back preloader
			this._background.addChild(this._preloader);
		}
		
		//assign content
		public function assign(slide:Slide):void {
			if (slide.loaded) {
				var bitmap:Bitmap
				if (!(slide.content is MovieClip)) {
					bitmap = new Bitmap(Bitmap(slide.content).bitmapData);
					this.content = bitmap;
				}
				else {
					var mcBitmap:BitmapData = new BitmapData(this._slideWidth, this._slideHeight, false, this._bgColor);
				   	mcBitmap.draw(slide.content);
				   	
                    bitmap = new Bitmap(mcBitmap);
               		var mc:MovieClip = new MovieClip();
               		mc.addChild(bitmap);
					this.content = mc;
				}
			
				if (FlashUtil.isNullEmptyString(slide.caption)) {
					this.caption = this._label;
				}
				else {
					this.caption = this._label + ": " + slide.caption;
				}
				
				if (this.hitTestPoint(this.stage.mouseX, this.stage.mouseY)) {
					this._tooltip.assignText(this.caption);
					this._tooltip.display(this.stage.mouseX, this.stage.mouseY);
				}
			}
		}
		
		//set content
		public function set content(obj:DisplayObject):void {
			//add content
			this._content = obj;
			this._content.alpha = 0;
			
			if (this._content is MovieClip) {
				MovieClip(this._content).gotoAndStop(1);	
			}
			else {
				this._content.x = FlashUtil.getCenter(this._areaWidth, this._content.width);
				this._content.y = FlashUtil.getCenter(this._areaHeight, this._content.height);
			}
			this._background.addChild(this._content);
			
			//fade in content
			Tweener.addTween(this._content, {alpha:1, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onComplete:onComplete});				
		}

		//on complete
		private function onComplete():void {
			this.startSWF();
			this.cleanup();	
		}
		
		//cleanup after content loaded
		protected override function cleanup():void {
			for (var i:uint = 0; i < this._background.numChildren; i++) {
				var obj:DisplayObject = this._background.getChildAt(i);
				if (obj != this._content && obj != this._maskSprite) {
					this._background.removeChildAt(i);
				}
			}	
		}
		
		//start swf		
		private function startSWF():void {
			if (this._content is MovieClip) {
				try {	
					MovieClip(this._content).gotoAndPlay(1);
				}
				catch (e:Error) {
					trace(e.message);
				}
			}							
		}
		
		//on slide mouse over handler
		protected override function onSlideOver(event:MouseEvent):void {
			if (this._content && this._tooltip) {
				this._tooltip.assignText(this._caption);
				this._tooltip.display(event.stageX, event.stageY);
			}
		}
	
		//on slide move handler	
		protected override function onSlideMove(event:MouseEvent):void {
			event.stopImmediatePropagation();
			if (this._content && this._tooltip) {
				this._tooltip.move(event.stageX, event.stageY);	
				event.updateAfterEvent();					
			}
		}
		
		//on slide mouse out handler
		protected override function onSlideOut(event:MouseEvent):void {
			if (this._content && this._tooltip) {
				this._tooltip.hide();
			}
		}
	}
}