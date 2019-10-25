package com.shurba.components.carousel {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class CarouselEvent extends Event {
		
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_SELECT:String = "itemSelect";
		public var data:ThumbVO;
		
		public function CarouselEvent(type:String, data:ThumbVO, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.data = data;
		} 
		
		public override function clone():Event { 
			return new CarouselEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("CarouselEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}