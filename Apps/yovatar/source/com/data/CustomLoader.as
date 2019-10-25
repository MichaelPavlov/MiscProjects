package com.data {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class CustomLoader {
		
		public var dataObject:Object;
		private var _callback:Function;
		
		public function CustomLoader($url:String, $callBack:Function , $data:Object):void {			
			_callback = $callBack;
			dataObject = $data;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			var request:URLRequest = new URLRequest($url);
			loader.load(request, new LoaderContext(true, ApplicationDomain.currentDomain));
		}
		
		private function loadCompleteHandler($event:Event):void {
			dataObject.asset = $event.target
			this._callback(dataObject);			
			$event.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
            $event.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		}
		
		private function loadErrorHandler($event:IOErrorEvent):void {
			trace("ioErrorHandler: " + $event);
			$event.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
            $event.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		}
	}
	
}