package com.UI {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("okBtnClick", type = "flash.events.Event")]
	[Event("cancelBtnClick", type = "flash.events.Event")]
	 
	public class AdviceDialog extends Sprite {
		
		public var btnCancel:SimpleButton;
		public var btnOk:SimpleButton;
		
		private var _okFunction:Function;
		private var _cancelFunction:Function;
		
		public function AdviceDialog() {
			this.addListeners();
		}
		
		private function addListeners():void {
			btnCancel.addEventListener(MouseEvent.CLICK, btnCancelClickHandler);
			btnOk.addEventListener(MouseEvent.CLICK, btnOkClickHandler);
		}
		
		private function removeListeners():void {
			btnCancel.removeEventListener(MouseEvent.CLICK, btnCancelClickHandler);
			btnOk.removeEventListener(MouseEvent.CLICK, btnOkClickHandler);
		}
		
		public function clear():void {
			this.removeListeners();
		}
		
		private function btnOkClickHandler($event:MouseEvent):void {
			this.dispatchEvent(new Event("okBtnClick"));
		}
		
		private function btnCancelClickHandler($event:MouseEvent):void {
			this.dispatchEvent(new Event("cancelBtnClick"));
		}
	}
	
}