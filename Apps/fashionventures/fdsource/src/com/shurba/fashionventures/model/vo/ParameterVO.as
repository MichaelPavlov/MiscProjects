package com.shurba.fashionventures.model.vo {
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class ParameterVO {
		
		public var data:String;
		public var label:String;
		
		public function ParameterVO(parameter:String = '') {
			data = parameter;
			label = parameter;
		}
		
	}

}