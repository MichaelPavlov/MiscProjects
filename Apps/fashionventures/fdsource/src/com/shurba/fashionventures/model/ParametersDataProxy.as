package com.shurba.fashionventures.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ParametersDataProxy extends Proxy {
		
		public static const NAME:String = 'mainDataProxy';
		public static const CHANGE:String = NAME + 'Change';
		
		public var brands:Array;
		public var themes:Array;
		public var categories:Array;
		public var colors:Array;
		
		
		
		public function ParametersDataProxy(data:Object = null) {			
			super(NAME, data);
			brands = [];
			themes = [];
			categories = [];
			colors = [];
		}
		
	}

}