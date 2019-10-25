package com.shurba.fashionventures.view {
	import com.shurba.fashionventures.ApplicationFacade;
	import com.shurba.fashionventures.model.*;
	import com.shurba.fashionventures.model.vo.RequestDataVO;
	import com.shurba.fashionventures.view.components.ControlBar;
	import com.shurba.fashionventures.view.events.ControlBarEvent;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class ControlBarMediator extends Mediator {
		
		public static const NAME:String = 'ControlBarMediator';
		
		public function ControlBarMediator(mediatorName:String = null, viewComponent:Object = null) {
			super(mediatorName, viewComponent);
		}
		
		private function itemSelectedHandler(e:ControlBarEvent):void {
			var requestData:RequestDataVO = new RequestDataVO();
			requestData.type = DataServiceProxy.TYPE_ITEMS;
			requestData.vars = e.data;
			sendNotification(DataServiceProxy.LOAD, requestData);
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.PARAMETERS_DATA_CHANGE];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case (ApplicationFacade.PARAMETERS_DATA_CHANGE) : updateData(); break;
			}
		}
		
		private function updateData():void {			
			//we don't need event on every data set to ControlBar, so we remove the listener here
			if ((viewComponent as ControlBar).hasEventListener(ControlBarEvent.SELECT_ITEM)) 
				(viewComponent as ControlBar).removeEventListener(ControlBarEvent.SELECT_ITEM, itemSelectedHandler);
			
			var proxy:ParametersDataProxy = facade.retrieveProxy(ParametersDataProxy.NAME) as ParametersDataProxy;
			(viewComponent as ControlBar).brands = proxy.brands;
			(viewComponent as ControlBar).categories = proxy.categories;
			(viewComponent as ControlBar).themes = proxy.themes;
			(viewComponent as ControlBar).colors = proxy.colors;
			
			//continue listening ControlBar for data change
			(viewComponent as ControlBar).addEventListener(ControlBarEvent.SELECT_ITEM, itemSelectedHandler);
		}
		
	}

}