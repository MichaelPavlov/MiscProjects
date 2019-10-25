package com.events {
	
	import flash.events.Event;
	
	public class LobbyDoneEvent extends Event {
		
		public static var LOBBY_DONE:String = "lobbyDone";
		
		public static const SEX_MALE:String = "male";
		public static const SEX_FEMALE:String = "female";
		
		public var sex:String;
		public var playerName:String;
		
		
		public function LobbyDoneEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new LobbyDoneEvent(type, bubbles, cancelable);
		}
	}
	
}