package com.shurba.marketadviser {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MarketItemVO {
		
		public var signal:String;
		public var code:String;
		public var name:String;
		public var price:String;
		public var trend:String;
		
		public function MarketItemVO(data:Object = null) {
			if (data) {
				if (data.hasOwnProperty("signal")) {
					this.signal = data.signal;
				}
				
				if (data.hasOwnProperty("code")) {
					this.code = data.code;
				}
				
				if (data.hasOwnProperty("name")) {
					this.name = data.name;
				}
				
				if (data.hasOwnProperty("price")) {
					this.price = data.price;
				}
				
				if (data.hasOwnProperty("trend")) {
					this.trend = data.trend;
				}
			}
		}
		
	}

}