package com.shurba.fashionventures.model {
	import com.shurba.fashionventures.model.vo.DataServiceResponseVO;
	import com.shurba.fashionventures.model.vo.RequestDataVO;
	import com.shurba.fashionventures.view.events.ControlBarEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.*;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DataServiceProxy extends Proxy {
		
		// Cannonical name of the Proxy
		public static const NAME:String = 'dataServiceProxy';
		public static const LOAD:String = NAME + "Load";
		public static const LOADING_PROGRESS:String = NAME + "Progress";
		public static const COMPLETE:String = NAME + "Complete";
		public static const ERROR:String = NAME + "Error";
		
		public static const TYPE_SEARCH_PARAMETERS:String = "typeSearchParameters";
		public static const TYPE_ITEMS:String = "typeItems";
		
		public var dataType:String;
		
		public var loader:URLLoader = new URLLoader();
		
		public function DataServiceProxy(data:Object = null) {
			super(NAME, data);
		}
		
		override public function onRemove():void {
			super.onRemove();
			loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		override public function onRegister():void {
			super.onRegister();
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function loaderProgressHandler(e:ProgressEvent):void {
			sendNotification(LOADING_PROGRESS, e);			
		}
		
		private function loaderIOErrorHandler(e:IOErrorEvent):void {
			sendNotification(ERROR);			
		}
		
		private function loaderCompleteHandler(e:Event):void {
			var response:DataServiceResponseVO;
			response = new DataServiceResponseVO(dataType, new XML(e.currentTarget.data));
			sendNotification(COMPLETE, response);
		}
		
		override public function getProxyName():String {
			return NAME;
		}
		
		public function loadData(requestData:RequestDataVO):void {			
			dataType = requestData.type;
			
			var request:URLRequest;
			switch (dataType)  {
				case TYPE_ITEMS :
					request = new URLRequest(ProjectConstants.INVENTORY_DATA_URL);
					var vars:URLVariables = new URLVariables();
					if (requestData.vars.hasOwnProperty(ControlBarEvent.BRAND))
						vars[ControlBarEvent.BRAND] = requestData.vars[ControlBarEvent.BRAND];
					if (requestData.vars.hasOwnProperty(ControlBarEvent.COLOR))
						vars[ControlBarEvent.COLOR] = requestData.vars[ControlBarEvent.COLOR];
					if (requestData.vars.hasOwnProperty(ControlBarEvent.CATEGORY))
						vars[ControlBarEvent.CATEGORY] = requestData.vars[ControlBarEvent.CATEGORY];
					if (requestData.vars.hasOwnProperty(ControlBarEvent.THEME))
						vars[ControlBarEvent.THEME] = requestData.vars[ControlBarEvent.THEME];
					request.data = vars;
					request.method = URLRequestMethod.GET;
				break;
				
				case TYPE_SEARCH_PARAMETERS :
					request = new URLRequest(ProjectConstants.MAIN_DATA_URL);
				break;
			}
			
			loader.load(request);
		}
		
	}

}