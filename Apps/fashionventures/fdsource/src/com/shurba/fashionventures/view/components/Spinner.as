package com.shurba.fashionventures.view.components{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import com.shurba.utils.GraphicsUtil;

	public class Spinner extends Sprite {
		private var fadeTimer:Timer;

		private var isDrawn:Boolean = false;
		private var isPlaying:Boolean = false;

		private var size:Number;
		private var speed:Number;
		private var fadeSpeed:Number;
		private var numTicks:int = 12;
		private var tickColor:Number;
		private var tickWidth:Number;
		private var tickNum:int;
		private var tick:Tick;
		
		public function Spinner(host:DisplayObjectContainer, speed:Number = 1000, diameter:Number = 600, tickColor:Number = 0xCACACA, tickWidth:Number = 3) {			
			this.size = diameter;

			this.tickColor = tickColor;
			this.tickWidth = tickWidth != -1 ? tickWidth:size / 10;

			this.speed = speed;
			this.fadeSpeed = speed * 6 / 10000;
			host.addChild(this);
			GraphicsUtil.addChildAtCenter(host,this);
			
			draw();
			
		}

		public function show():void {
			visible = true;
		}

		public function hide():void {
			visible = false;
		}


		public function draw():void {
			
			if (!isDrawn) {

				isDrawn = true;

				// Find out whether it's playing so we can restart it later if we need to
				var wasPlaying:Boolean = isPlaying;

				// stop the spinning
				stop();

				// Remove all children
				for (var i:int = numChildren - 1; i >= 0; i--) {
					removeChildAt(i);
				}

				// Re-create the children
				var radius:Number = size / 2;
				var angle:Number = 2 * Math.PI / numTicks;// The angle between each tick
				var currentAngle:Number = 0;

				for (var j:int = 0; j < numTicks; j++) {
					var xStart:Number = radius + Math.sin(currentAngle) * numTicks * (tickWidth + 1)/ 2 / Math.PI;
					var yStart:Number = radius - Math.cos(currentAngle) * numTicks * (tickWidth + 1)/ 2 / Math.PI;
					var xEnd:Number = radius + Math.sin(currentAngle) * radius;
					var yEnd:Number = radius - Math.cos(currentAngle) * radius;

					var t:Tick = new Tick(xStart, yStart, xEnd, yEnd, tickWidth, tickColor);					
					this.addChild(t);

					currentAngle +=  angle;
				}

				// Start the spinning again if it was playing when this function was called.
				if (wasPlaying) {
					play();
				}
			}
		}


		/**
		 * Begin the circular fading of the ticks.
		 */
		public function play():void {
			if (! isPlaying) {
				
				fadeTimer = new Timer(speed / numTicks);
				if (!fadeTimer.hasEventListener(TimerEvent.TIMER)) 
					fadeTimer.addEventListener(TimerEvent.TIMER, render, false, 0, true);
				
				fadeTimer.start();

				isPlaying = true;

				if (! visible) {
					show();
				}
			}
		}

		/**
		 * Stop the spinning.
		 */

		public function stop():void {
			if (fadeTimer != null && fadeTimer.running) {
				isPlaying = false;
				fadeTimer.stop();
			}
			if (visible) {
				hide();
			}
		}
		
		public function destroy():void {
			if (fadeTimer.hasEventListener(TimerEvent.TIMER))
					fadeTimer.removeEventListener(TimerEvent.TIMER, render);
			stop();
			// Remove all children
			for (var i:int = numChildren - 1; i >= 0; i--) {
				removeChildAt(i);
			}
		}

		private function render(event:TimerEvent):void {
			tickNum = int(fadeTimer.currentCount % numTicks);
			if (numChildren > tickNum) {
				tick = getChildAt(tickNum) as Tick;
				tick.fadeIn(fadeSpeed);
			}
		}
	}
}