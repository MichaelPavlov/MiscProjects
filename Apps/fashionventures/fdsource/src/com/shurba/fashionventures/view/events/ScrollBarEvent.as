package com.shurba.fashionventures.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class ScrollBarEvent extends Event {
		
		/**
		 * When the scrollbar has changed its position.
		 */
		public static const POSITION_CHANGED:String = "positionChanged";
		
		
		/**
		 * Current position of scrollbar in percent.
		 */
		public var currentPosition:int;
		
		public function ScrollBarEvent(type:String, pos:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			currentPosition = pos;
		} 
		
		public override function clone():Event { 
			return new ScrollBarEvent(type, currentPosition, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ScrollBarEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}