package com.shurba.fashionventures.view.events {
	import flash.events.Event;
	
	
	/// @eventType	com.shurba.fashionventures.view.events.ControlBarEvent.SELECT_ITEM
	[Event(name="selectItem", type="com.shurba.fashionventures.view.events.ControlBarEvent")] 
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ControlBarEvent extends Event {
		
		public static const SELECT_ITEM:String = "selectItem";
		public static const CATEGORY:String = "category";
		public static const THEME:String = "theme";
		public static const COLOR:String = "color";
		public static const BRAND:String = "brand";
		
		public var component:String;
		public var data:Object;
		
		public function ControlBarEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			//this.component = component;
			this.data = data;
			
		} 
		
		public override function clone():Event { 
			return new ControlBarEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ControlBarEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}