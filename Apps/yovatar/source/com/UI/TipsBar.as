package com.UI {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("finishBtnClick", type = "flash.events.MouseEvent")]
	
	public class TipsBar extends Sprite {
		
		public var num:TextField;
		public var tips:TextField;
		
		public var btnFinish:MovieClip;
		
		public static const SELECT_GENDER_STATE:int = 1;
		public static const CREATE_AVATAR_STATE:int = 2;
		
		public const SELECT_GENDER_TIP:String = "Select your Gender";
		public const CREATE_AVATAR_TIP:String = "Wait for page load and then create your Avatar <br>When you are satisfied click FINISH";
		
		public function TipsBar() {
			this.addListeners();
		}
		
		public function setState($state:int):void {
			if ($state == TipsBar.SELECT_GENDER_STATE) {
				btnFinish.enabled = false;
				btnFinish.visible = false;
				num.text = $state.toString();
				tips.htmlText = this.SELECT_GENDER_TIP;
			} else if ($state == TipsBar.CREATE_AVATAR_STATE) {
				btnFinish.enabled = true;
				btnFinish.visible = true;
				num.text = $state.toString();
				tips.htmlText = this.CREATE_AVATAR_TIP;
			}
		}
		
		private function addListeners():void {
			btnFinish.addEventListener(MouseEvent.CLICK, btnFinishClickHandler);			
		}
		
		private function removeListeners():void {
			btnFinish.removeEventListener(MouseEvent.CLICK, btnFinishClickHandler);			
		}
		
		public function clear():void {
			this.removeListeners();
		}
		
		private function btnFinishClickHandler($event:MouseEvent):void {
			this.dispatchEvent(new Event("finishBtnClick"));
		}
	}
	
}