package com.shurba.fashionventures.view {
	import adobe.utils.CustomActions;
	import com.shurba.fashionventures.model.*;
	import com.shurba.fashionventures.model.vo.RequestDataVO;
	import com.shurba.fashionventures.view.components.Spinner;
	import com.shurba.Main;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ApplicationMediator extends Mediator{
		
		public static const NAME:String = 'ApplicationMediator';		
		
		public function ApplicationMediator(app:Main) {
			super(NAME, app);
			facade.registerMediator(new ControlBarMediator(ControlBarMediator.NAME, (viewComponent as Main).controlBar));
			//TODO register all the application mediators
		}
		
		override public function onRegister():void {
			super.onRegister();
			var requestData:RequestDataVO = new RequestDataVO();
			requestData.type = DataServiceProxy.TYPE_SEARCH_PARAMETERS;
			sendNotification(DataServiceProxy.LOAD, requestData);
		}
		
		override public function listNotificationInterests():Array {
			return [DataServiceProxy.LOAD,
					DataServiceProxy.LOADING_PROGRESS,
					DataServiceProxy.COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case DataServiceProxy.LOAD : {
					(viewComponent as Main).showPreloader();
					break; 
				}
				
				case DataServiceProxy.LOADING_PROGRESS : break;
				
				case DataServiceProxy.COMPLETE : {
					(viewComponent as Main).hidePreloader();
					break; 
				}
				
			}
		}
		
	}

}