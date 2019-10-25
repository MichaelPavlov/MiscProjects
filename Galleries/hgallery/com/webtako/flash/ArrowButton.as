package com.webtako.flash {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	ColorShortcuts.init();
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	
	public class ArrowButton extends Sprite {			
		public static const BACK:String = "BACK";
		public static const FORWARD:String = "FORWARD";
		public static const ARROW_WIDTH:Number = 6;
		public static const ARROW_HEIGHT:Number = 12;
		public static const MARGIN:Number = 4;
		public static const DISABLE_ALPHA:Number = 0.30;
		
		private var _arrow:Shape;
		private var _button:Sprite;
		private var _direction:String;
		private var _arrowColor:uint;
		private var _arrowMouseoverColor:uint;	
		private var _paneColor:uint;
		private var _bgAlpha:Number;
		private var _slide:PreviewSlide;
		private var _slidePane:Sprite;
		private var _slideXOffset:Number;
		private var _slideXPos:Number;
						
		public function ArrowButton(type:String = FORWARD, 
										  arrowColor:uint = 0xFFFFFF, arrowMouseoverColor:uint = 0x0066FF,  
										  bgColor:uint = 0x000000, bgAlpha:Number = FlashUtil.DEFAULT_ALPHA, paneColor:uint = 0x333333,
										  buttonWidth:Number = 24, buttonHeight:Number = 80, 
										  arrowWidth:Number = ARROW_WIDTH, arrowHeight:Number = ARROW_HEIGHT) {
										  	
			this._direction = type.toUpperCase();
			this._arrowColor = arrowColor;
			this._arrowMouseoverColor = arrowMouseoverColor;	
			this._paneColor = paneColor;			
			this._bgAlpha = bgAlpha;
			
			//init button
			this._button = new Sprite();
			this._button.graphics.beginFill(bgColor, bgAlpha);			
			this._button.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			this._button.graphics.endFill();
			
			//init directional arrow
			this._arrow = new Shape();				
			var arrowMidpoint:uint = Math.round(arrowHeight/2);
			var g:Graphics = this._arrow.graphics;
			g.lineStyle(2, this._arrowColor, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			if (this._direction == BACK) {
				g.moveTo(arrowWidth, 0);
				g.lineTo(0, arrowMidpoint);
				g.lineTo(arrowWidth, arrowHeight);
			}
			else {
				g.lineTo(arrowWidth, arrowMidpoint);
				g.lineTo(0, arrowHeight);
			}			
			
			//add components
			this._arrow.x = FlashUtil.getCenter(buttonWidth, arrowWidth); 
			this._arrow.y = FlashUtil.getCenter(buttonHeight, arrowHeight);
			this._button.addChild(this._arrow);
			this._button.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			this.addChild(this._button);

			//init mouse behavior			
			this.buttonMode = true;
			this.useHandCursor = true;	
			this.mouseChildren = true;			
			this.addEventListener(MouseEvent.MOUSE_OVER, onButtonOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onButtonOut);			
		}
		
		//on stage resize
		public function onResize():void {
			if (this._direction == FORWARD) {
				this.x = this.stage.stageWidth - this.buttonWidth;
			}			
			this.y = FlashUtil.getCenter(this.stage.stageHeight, this.buttonHeight);
		}
		
		//get preview slide
		public function get previewSlide():PreviewSlide {
			return this._slide;
		}
		
		//set preview slide
		public function set previewSlide(slide:PreviewSlide):void {
			this._slide = slide;
			
			//init slide pane
			this._slidePane = new Sprite();
			this._slidePane.graphics.beginFill(this._paneColor, this._bgAlpha);
			this._slidePane.graphics.drawRect(0, 0, 
								this.buttonWidth + this._slide.slideWidth + (2 * MARGIN), 
								this._slide.slideHeight + (2 * MARGIN));
			this._slidePane.graphics.endFill();
			this._slidePane.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			
			//set positioning	
			if (this._direction == ArrowButton.BACK) {
				this._slideXPos = this._button.x;
				this._slideXOffset = this._button.x - this._slidePane.width;	
				this._slide.x = this.buttonWidth + MARGIN;			
			}
			else {
				this._slideXPos = (this._button.x + this.buttonWidth) - this._slidePane.width;
				this._slideXOffset = this._button.x + this.buttonWidth;
				this._slide.x = MARGIN;
			}
			this._slide.y = MARGIN;
			
			this._slidePane.x = this._slideXOffset;			
			this._slidePane.y = FlashUtil.getCenter(this.buttonHeight, this._slidePane.height);		
			
			//init mask
			var maskY:Number = (this._slidePane.y <= this._button.y) ? this._slidePane.y : this._button.y;
			var maskHeight:Number = (this._slidePane.height >= this.buttonHeight) ? this._slidePane.height : this.buttonHeight;
			var maskSprite:Sprite = new Sprite();
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(this._slideXPos, maskY, this._slidePane.width, maskHeight);
			maskSprite.graphics.endFill();	
			this.mask = maskSprite;
			this.addChild(maskSprite);

			//add components
			this._slidePane.addChild(this._slide);
			this.addChildAt(this._slidePane, 0);
		}
		
		//get button width;
		public function get buttonWidth():Number {
			return this._button.width;
		}
		
		//get button height
		public function get buttonHeight():Number {
			return this._button.height;
		}
		
		//disable button
		public function disable():void {
			this._arrow.alpha = DISABLE_ALPHA;
			this.mouseEnabled = false;
			this.mouseChildren = false;	
		}
		
		//enable button
		public function enable():void {
			this._arrow.alpha = 1;
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		//on button over handler
		private function onButtonOver(event:MouseEvent):void {
			Tweener.addTween(this._arrow, {_color:this._arrowMouseoverColor,
								time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	

			if (this._slidePane) {
				Tweener.addTween(this._slidePane, {x:this._slideXPos, 
									time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
			}
		}
		
		//on button out handler
		private function onButtonOut(event:MouseEvent):void {
			Tweener.addTween(this._arrow, {_color:this._arrowColor, 
								time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});			

			if (this._slidePane) {
				Tweener.addTween(this._slidePane, {x:this._slideXOffset, 
									time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
			}
		}
		
		//on mouse move
		private function onMousemove(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
	}
}