package com.data {
	import com.adobe.serialization.json.JSONDecoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DataLoader {
		
		private var urlLoader:URLLoader;
		
		private var callBack:Function;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function DataLoader($url:String, $callBack:Function) {
			callBack = $callBack;			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest($url));
		}
		
		private function removeListeners():void {
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		public function completeHandler(event:Event):void {
			this.removeListeners();
			var jsonDecoder:JSONDecoder = new JSONDecoder(event.target.data as String);
			dataHolder.inventoryData = jsonDecoder.getValue().inventory as Array;
			dataHolder.avatarDefaultAssets = jsonDecoder.getValue().player.clothing as Array;
			
			
			//dataHolder.defaultdefaultAppearanceData = jsonDecoder.getValue().player as Array;
			dataHolder.playerID = jsonDecoder.getValue().playerId;
			this.callBack();
		}
		
		public function ioErrorHandler(event:IOErrorEvent):void {
			this.removeListeners();
		}
	}
	
}