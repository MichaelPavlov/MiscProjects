package de.ameria.cairngorm.model {
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class StarwallModelLocator implements ModelLocator {
		
		private static var modelLocator:StarwallModelLocator;
		
		public const MAIN_DATA_URL:String = "data/data.xml";
		
		public var participants:ArrayCollection;
		public var connections:ArrayCollection;
		
		public function StarwallModelLocator() {
			if (modelLocator != null) {
				throw new Error( "Only one ModelLocator instance should be instantiated" );	
			}
		}
		
		public static function getInstance():StarwallModelLocator {
			if (modelLocator == null) {
				modelLocator = new StarwallModelLocator();
			}
			return modelLocator;
		}

	}
}