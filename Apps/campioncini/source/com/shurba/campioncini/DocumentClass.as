package com.shurba.campioncini {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		public function DocumentClass() {
			super();
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			
		}
		
	}

}