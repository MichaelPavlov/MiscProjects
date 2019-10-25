package com.utils {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	*/
	
	public class LogWindow extends Sprite {
		public var dtLog:TextField;
		
		public var btnHide:SimpleButton;
		public var btnShow:SimpleButton;
		
		public var mcBack:Sprite;
		
		public function LogWindow($alpha:Number = NaN, $text:String = null) {
			if ($text != null) {
				dtLog.text = $text;
			}
			
			if (!isNaN($alpha)) {
				this.alpha = $alpha;
			} else {
				this.alpha = 0.6;
			}
			
			this.mouseEnabled = false;
			btnShow.visible = false;
			this.addListeners();
		}
		
		private function addListeners():void {
			btnHide.addEventListener(MouseEvent.CLICK, hideLogger);
			btnShow.addEventListener(MouseEvent.CLICK, showLogger);
		}
		
		public function removeListeners():void {
			btnHide.removeEventListener(MouseEvent.CLICK, hideLogger);
			btnShow.removeEventListener(MouseEvent.CLICK, showLogger);
		}
		
		public function logThis($text:String):void {
			dtLog.appendText($text);
			dtLog.scrollV = dtLog.maxScrollV;
		}
		
		private function showLogger($event:MouseEvent):void {			
			TweenLite.to(mcBack, 0.5, { width:410, height:280 , onComplete:function() { 
																				btnHide.visible = true; 
																				dtLog.visible = true;
																				dtLog.alpha = 0.5;
																				TweenLite.to(dtLog, 0.5, {alpha:1})}} );
			btnShow.visible = false;
		}
		
		private function hideLogger($event:MouseEvent):void {
			btnHide.visible = false;
			dtLog.visible = false;
			TweenLite.to(mcBack, 0.5, { width:(2 * btnShow.x) + btnShow.width, height:(2 * btnShow.y) + btnShow.height, onComplete:function() { btnShow.visible = true; }} );			
		}
	}
	
}