package com.webtako.flash {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class TimerBar extends Sprite {
		public static const TIMERBAR_WIDTH:Number = 100;
		public static const TIMERBAR_HEIGHT:Number = 8;
		
   		private var _startTime:uint;
   		private var _elapseTime:uint;
   		private var _delay:uint;
		private var _barWidth:Number;
		private var _barHeight:Number;
		private var _color:uint;
   		private var _bar:Sprite;
		
		public function TimerBar(barWidth:Number = TIMERBAR_WIDTH, barHeight:Number = TIMERBAR_HEIGHT, 
									color:uint = 0x0066FF, bgColor:uint = 0xFFFFFF, bgAlpha:Number = 1) {
			this._elapseTime = 0;
			this._delay = 0;
			this._barWidth = barWidth;
			this._barHeight = barHeight;
			this._color = color;
			
			//init background
			this.graphics.beginFill(bgColor, bgAlpha);
			this.graphics.drawRect(0, 0, this._barWidth, this._barHeight);
			this.graphics.endFill();	
			
			//init bar
			this._bar = new Sprite();
			this._bar.graphics.beginFill(this._color);
			this._bar.graphics.drawRect(0, 0, 0.1, this._barHeight);
			this._bar.graphics.endFill();
			this.initMask();
			this.addChild(this._bar);
			
			//init mouse behavior	
			this.buttonMode = true;		
			this.useHandCursor = true;	
			this.mouseEnabled = true;
			this.mouseChildren = false;
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
		}
		
		//get elapse time
		public function get elapseTime():uint {
			return this._elapseTime;	
		}
		
		//get delay
		public function get delay():uint {
			return this._delay;	
		}
		
		//set delay
		public function set delay(delay:uint):void {
			this._delay = delay;
		}
		
		//start
		public function start():void {
			this._startTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		//resume
		public function resume():void {
			this._startTime = getTimer() - this._elapseTime;
			this.addEventListener(Event.ENTER_FRAME, update);	
		}
		
		//stop
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME, update);		
			this.reset();				
		}
		
		//pause
		public function pause():void {
			this.removeEventListener(Event.ENTER_FRAME, update);			
		}
		
		//reset 
		public function reset():void {
			this._bar.width = 0.1;
			this._elapseTime = 0;
			this._delay = 0;	
		}
		
		//update 
		private function update(event:Event):void {		
			this._elapseTime = getTimer() - this._startTime;
			this._bar.width = (this._elapseTime/this._delay) * this._barWidth;
		}
		
		//init mask	
		private function initMask():void {
			var maskSprite:Sprite = new Sprite();
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(0, 0, this._barWidth, this._barHeight);
			maskSprite.graphics.endFill();
			
 			this.mask = maskSprite;
   			this.addChild(maskSprite);
		}
		
		//on mouse move
		private function onMousemove(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
	}
}