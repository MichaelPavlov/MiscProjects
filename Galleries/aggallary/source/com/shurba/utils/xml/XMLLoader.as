package com.shurba.utils.xml {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class XMLLoader {
		
		
		private var callBack:Function;
		//private 
		
		public function XMLLoader($xmlURL:String, $callBack:Function) {			
			if ($xmlURL == '') {
				throw new Error('GalleryXMLLoader: not valid XML path.');
			} 
			if ($callBack == null) {
				throw new Error('GalleryXMLLoader: not valid callback function.');
			}
			callBack = $callBack;
			this.loadXML($xmlURL);
		}
		
		private function loadXML($url:String):void	{
			var request:URLRequest = new URLRequest($url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError, false, 0, true);
			
			try {
                urlLoader.load(request);
            } catch (error:SecurityError) {
                trace("A SecurityError has occurred.");
            }
			
		}
		
		private function xmlLoaded(e:Event):void {			
			var xml:XML = new XML(e.target.data);			
			this.callBack(xml);
		}
		
		private function xmlLoadError(e:IOErrorEvent):void {
			trace (e);
		}
		
	}

}