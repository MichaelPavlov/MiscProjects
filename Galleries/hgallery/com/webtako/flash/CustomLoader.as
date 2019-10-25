package com.webtako.flash {
	import flash.display.Loader;
	
	public class CustomLoader extends Loader {
		private var _key:String;
		private var _categoryId:int;
		private var _contentId:int;
				
		public function CustomLoader(contentID:int, categoryID:int) {
			super();
			this._categoryId = categoryID;
			this._contentId  = contentID;
			this._key = this._categoryId + "_" + this._contentId;
		}
		
		public function get categoryId():int {
			return this._categoryId;	
		}
		
		public function get contentId():int {
			return this._contentId;
		}
		
		public function get key():String {
			return this._key;
		}
	}
}