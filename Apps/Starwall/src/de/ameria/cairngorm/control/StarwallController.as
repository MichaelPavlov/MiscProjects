package de.ameria.cairngorm.control {
	import com.adobe.cairngorm.control.FrontController;
	
	import de.ameria.cairngorm.command.GetParticipantsCommand;
	import de.ameria.cairngorm.event.GetParticipantsEvent;
	
	
	public class StarwallController extends FrontController	{
		
		public function StarwallController() {
			super();
			this.initialiseCommands();
		}
		
		public function initialiseCommands():void {
			addCommand(GetParticipantsEvent.GET_PARTICIPANTS_DATA, GetParticipantsCommand);
		}
		
	}
}