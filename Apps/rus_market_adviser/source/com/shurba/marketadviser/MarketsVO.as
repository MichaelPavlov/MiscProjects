package com.shurba.marketadviser {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MarketsVO {
		
		public static const MICEX:String = "micex";
		public static const INDEX:String = "index";
		public static const COMMODITIES:String = "commodities";
		public static const FOREX:String = "forex";
		
		public var micex:Array;
		public var index:Array;
		public var commodities:Array;
		public var forex:Array;
		
		public function MarketsVO() {
			micex = [];
			index = [];
			commodities = [];
			forex = [];
		}
		
	}

}