package com.UI {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class Preloader extends Sprite {
		
		public var mcRedArrow:Sprite;
		public var mcBlueArrow:Sprite
		public var mcYellowArrow:Sprite
		public var mcGreenArrow:Sprite
		
		private var onCompleteCallBack:Function;
		
		public function Preloader($onComplete:Function) {			
			this.hideArrows();
			this.onCompleteCallBack = $onComplete;
		}
		
		public function start():void {
			this.addListeners();
			this.setPosition();
		}
		
		private function addListeners():void {
			root.loaderInfo.addEventListener(Event.COMPLETE, initApplication);
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, trackLoadingProgress);
			this.loaderInfo.addEventListener(Event.INIT, loadInitHandler);
		}
		
		private function removeListeners():void {
			root.loaderInfo.removeEventListener(Event.COMPLETE, initApplication);
			root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, trackLoadingProgress);
			this.loaderInfo.removeEventListener(Event.INIT, loadInitHandler);
		}
		
		private function hideArrows():void {
			mcBlueArrow.alpha = 0;
			mcGreenArrow.alpha = 0;
			mcRedArrow.alpha = 0;
			mcYellowArrow.alpha = 0;
		}
		
		private function showArrows():void {
			mcBlueArrow.alpha = 1;
			mcGreenArrow.alpha = 1;
			mcRedArrow.alpha = 1;
			mcYellowArrow.alpha = 1;
		}
		
		private function loadInitHandler($event:Event):void {
			this.setPosition();
		}
		
		private function setPosition():void {			
			this.x = (stage.stageWidth - this.width) / 2;
			this.y = (stage.stageHeight - this.height) / 2;
		}
		
		private function trackLoadingProgress($event:ProgressEvent):void {
			var $nPercent:Number = $event.bytesLoaded / $event.bytesTotal;
			var $nAlpha:Number = ($nPercent % 0.25) / 0.25 ;;
			
			if ($nPercent > 0 && $nPercent < 0.25) {				
				mcRedArrow.alpha = $nAlpha;				
			} else if ($nPercent > 0.25 && $nPercent < 0.5) {				
				mcRedArrow.alpha = 1;
				mcGreenArrow.alpha = $nAlpha;				
			} else if ($nPercent > 0.5 && $nPercent < 0.75) {				
				mcRedArrow.alpha = 1;
				mcGreenArrow.alpha = 1;
				mcYellowArrow.alpha = $nAlpha;				
			} else if ($nPercent > 0.75 && $nPercent <= 1) {				
				mcRedArrow.alpha = 1;
				mcGreenArrow.alpha = 1;
				mcYellowArrow.alpha = 1;
				mcBlueArrow.alpha = $nAlpha;				
			}			
		}		
		
		private function initApplication($event:Event):void {
			this.showArrows();
			this.removeListeners();
			this.onLoadComplete();
		}
		
		public function onLoadComplete():void {
			this.onCompleteCallBack();
		}
		
	}
	
}