package de.ameria.cairngorm.vo {
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	public class ParticipantVO implements IValueObject {
		
		public var name:String;
		public var lastName:String;
		public var country:String;
		public var id:int;
		public var connections:Array;
		
		public function ParticipantVO($data:Object) {
			if ($data != null) {
				fill($data);
			}
		}
		
		private function fill($data:Object):void {
			this.name = $data.name;
			this.lastName = $data.lastName;
			this.id = $data.id;
			this.country = $data.country;
			this.connections = $data.connections.connection as Array;			
		}
	}
}