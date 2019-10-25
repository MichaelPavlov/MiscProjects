package com.UI {
	import com.data.CustomLoader;
	import com.data.DataHolder;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author ...
	 */
	
	public class ItemPreviewButton extends Sprite {
		
		
		public var btnMain:SimpleButton;
		
		public var selectionItemPlaceholderImage:Sprite;
		
		public var loadingAnimation:MovieClip;
		
		public var ID:int;
		
		public var itemName:TextField;
		public var itemPrice:TextField;
		
		private var loader:Loader = new Loader();
		
		private var _itemObject:Object;
		
		private var bAssetloaded:Boolean;
		private var bPreviewloaded:Boolean;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function ItemPreviewButton() {			
			itemPrice.visible = false;
			itemPrice.mouseEnabled = false;
			itemName.mouseEnabled = false;
			btnMain.mouseEnabled = true;
			this.addListeners();
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, previewLoadCompleteHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, previewLoadErrorHandler);
		}
		 
		private function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, previewLoadCompleteHandler);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, previewLoadErrorHandler);			
		}
		
		public function showButton($value:Boolean):void {
            btnMain.visible = $value;
            return;
        }
		
		public function enable():void {
			this.visible = true;
			//this.mouseEnabled = true;
			loadingAnimation.gotoAndPlay(1);
		}
		
		public function disable():void {
			this.visible = false;
			//this.mouseEnabled = false;
			loadingAnimation.stop();
		}
		
		public function set itemObject($item:Object):void {
			if (!$item) {
				this.disable();
				return;
			}
			
			
			var url:String;
			if (dataHolder.gender == 2) {
				url = DataHolder.URL_MALE_ASSETS_PATH+"/item_images/"+$item.itemId + "_60_60.gif";
			} else if (dataHolder.gender == 1) {
				url = DataHolder.URL_FEMALE_ASSETS_PATH+"/item_images/"+$item.itemId + "_60_60.gif";
			}
			
			this.loadPreview(url);
			//if ($item.name != "None" || $item) {
			if ($item.swf && $item.swf.length > 0) {
				this.loadAsset($item);
				bAssetloaded = false;
			} else {
				bAssetloaded = true;
			}
			
			bPreviewloaded = false;
			loadingAnimation.visible = true;
			this.enable();
			_itemObject = $item;
			itemName.text = $item.name;
			selectionItemPlaceholderImage.visible = false;
		}
		
		public function loadAsset($dataObject:Object):void {
			if ($dataObject.categoryId == 1000) {				
				return;
			}
			if ($dataObject.hasOwnProperty("filename") && $dataObject.filename != "") {
				//trace ($dataObject.filename);
				var url:String;
				if (dataHolder.gender == 2) {
					url = DataHolder.URL_MALE_ASSETS_PATH + "/avatar_assets/" + $dataObject.filename + ".swf";
				} else if (dataHolder.gender == 1) {
					url = DataHolder.URL_FEMALE_ASSETS_PATH + "/avatar_assets/" + $dataObject.filename + ".swf";
				}
				new CustomLoader(url, assetLoaded, $dataObject);
			}
		}
		
		private function assetLoaded($data:Object):void {
			_itemObject = $data;
			bAssetloaded = true;
			if (bPreviewloaded && bAssetloaded) {
				this.fadeIn();
				loadingAnimation.visible = false;
			}		
		}
		
		private function fadeIn():void {
			selectionItemPlaceholderImage.visible = true;
			selectionItemPlaceholderImage.alpha = 0;
			TweenLite.to(selectionItemPlaceholderImage, 0.75, { "alpha":1 } );
		}
		
		public function get itemObject():Object { 
			return _itemObject;
		}
		
		private function loadPreview($src:String):void {
			var request:URLRequest = new URLRequest($src);
			loader.load(request);
		}
		
		private function previewLoadCompleteHandler($event:Event):void {
			while(selectionItemPlaceholderImage.numChildren) selectionItemPlaceholderImage.removeChildAt(0);			
			selectionItemPlaceholderImage.addChild(loader);
			bPreviewloaded = true;
			if (bPreviewloaded && bAssetloaded) {
				this.fadeIn();
				loadingAnimation.visible = false;			
			}
			
			
			$event.currentTarget.content.parent.x = -$event.currentTarget.content.width / 2;
			$event.currentTarget.content.parent.y = -$event.currentTarget.content.height / 2;
		}
		
		private function previewLoadErrorHandler($event:IOErrorEvent):void {
			//trace ($event.message+" "+$event.);
		}
		
	}
	
}