package de.ameria.cairngorm.event {
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class GetParticipantsEvent extends CairngormEvent {
		
		public static const GET_PARTICIPANTS_DATA:String = "getParticipants";
		
		public function GetParticipantsEvent() {
			super(GET_PARTICIPANTS_DATA);
		}
		
		override public function clone():Event {
			return new GetParticipantsEvent();
		}
		
	}
	
}