package com.shurba.fashionventures.view.components {
	import flash.display.*;
	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class AssetContainer extends Sprite{
		
		public var item:DisplayObject;
		
		public function AssetContainer(Asset:Class) {
			item = new Asset();
			addChild(item);
		}
		
	}

}