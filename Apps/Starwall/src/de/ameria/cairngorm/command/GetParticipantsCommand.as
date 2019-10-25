package de.ameria.cairngorm.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import de.ameria.cairngorm.business.ParticipantsDelegate;
	import de.ameria.cairngorm.model.StarwallModelLocator;
	import de.ameria.cairngorm.vo.ParticipantVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ArrayUtil;

	public class GetParticipantsCommand implements IResponder, ICommand	{
		
		private var model:StarwallModelLocator = StarwallModelLocator.getInstance();
		
		public function GetParticipantsCommand() {
						
		}

		public function result(data:Object):void {
			var result:ArrayCollection = data.result.participants.participant is ArrayCollection
			? data.result.participants.participant as ArrayCollection
	        : new ArrayCollection(ArrayUtil.toArray(data.result.participants.participant));
	        
	        var temp:ArrayCollection = new ArrayCollection();
	        var cursor:IViewCursor = result.createCursor();	        
		    while (!cursor.afterLast) {
		        temp.addItem(new ParticipantVO(cursor.current));		        
		        cursor.moveNext(); 
		    }
			model.participants = temp;
			
			var tmpValue:ParticipantVO;
			
			 for (var i:int = 0; i < model.participants.length; i++) {
				tmpValue = model.participants[i]
				trace (tmpValue.name);
			} 
		}
		
		public function fault(info:Object):void {
			Alert.show( "Participants data can't be retrieved!" );
		}
		
		public function execute(event:CairngormEvent):void {
			if( StarwallModelLocator.getInstance().participants == null ) {
			    var delegate : ParticipantsDelegate = new ParticipantsDelegate( this );
			    delegate.getParticipants();
			} else {
				Alert.show( "Participants data already retrieved!" );
				return;
			}
		}
		
	}
}