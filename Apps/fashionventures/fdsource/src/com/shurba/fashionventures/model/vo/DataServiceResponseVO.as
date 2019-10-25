package com.shurba.fashionventures.model.vo {
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class DataServiceResponseVO {
		
		public var type:String;
		public var data:XML;
		
		public function DataServiceResponseVO(type:String = '', data:XML = null) {
			this.type = type;
			this.data = data;
		}
		
	}

}