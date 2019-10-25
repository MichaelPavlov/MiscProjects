package de.ameria.cairngorm.business {
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	
	public class ParticipantsDelegate {
		
		private var service:Object;
		private var responder:IResponder;
		
		public function ParticipantsDelegate($responder:IResponder) {
			this.responder = $responder;
			this.service = ServiceLocator.getInstance().getHTTPService("serviceMainData");			
		}
		
		public function getParticipants():void {
			var call:Object = service.send();
			call.addResponder(responder);
		}

	}
}