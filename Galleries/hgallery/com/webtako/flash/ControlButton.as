package com.webtako.flash {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	ColorShortcuts.init();
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ControlButton extends Sprite {
		public static const ON:uint = 1;
		public static const OFF:uint = 2;
		
		private var _symbol:MovieClip;
		private var _color:uint;
		private var _mouseoverColor:uint;
		private var _state:uint;
		
		public function ControlButton(symbol:MovieClip, buttonWidth:Number, buttonHeight:Number,
										color:uint, mouseoverColor:uint, bgColor:uint, bgAlpha:Number = 0,  state:uint = ON) {
			//init properties
			this._color = color;
			this._mouseoverColor = mouseoverColor;
			this._state = state;
			
			//init background
			this.graphics.beginFill(bgColor, bgAlpha);
			this.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			this.graphics.endFill();
			
			//init symbol
			this._symbol = symbol;
			FlashUtil.setColor(this._symbol, this._color);
			this._symbol.x = FlashUtil.getCenter(buttonWidth, this._symbol.width);
			this._symbol.y = FlashUtil.getCenter(buttonHeight, this._symbol.height);		
			this.addChild(this._symbol);
			
			//init mouse behavior
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = false;					
			this.addEventListener(MouseEvent.MOUSE_OVER, onButtonOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onButtonOut);		
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);	
		}

		//toggle button state
		public function toggle():void {
			if (this._state == OFF) {
				this._state = ON;				
			}
			else {
				this._state = OFF;				
			}
			this._symbol.gotoAndStop(this._state);
		}
		
		//get button state
		public function get state():uint {
			return this._state;	
		}
		
		//set button state
		public function set state(val:uint):void {
			if (val <= this._symbol.totalFrames) {
				this._state = val;
				this._symbol.gotoAndStop(this.state);	
			}
		}
		
		//on button over
		private function onButtonOver(event:MouseEvent):void {
			Tweener.addTween(this._symbol, {_color:this._mouseoverColor, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on button out
		private function onButtonOut(event:MouseEvent):void {
			Tweener.addTween(this._symbol, {_color:this._color, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on mouse move
		private function onMousemove(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
	}
}