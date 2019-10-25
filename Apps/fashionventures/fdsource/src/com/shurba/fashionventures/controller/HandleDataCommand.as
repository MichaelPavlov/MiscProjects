package com.shurba.fashionventures.controller {
	import com.shurba.fashionventures.model.*;
	import com.shurba.fashionventures.*;
	import com.shurba.fashionventures.model.vo.DataServiceResponseVO;
	import com.shurba.fashionventures.model.vo.ParameterVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class HandleDataCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			var response:DataServiceResponseVO = notification.getBody() as DataServiceResponseVO;
			
			switch (response.type) {
				case DataServiceProxy.TYPE_SEARCH_PARAMETERS : parseParametersData(response.data); break;
				case DataServiceProxy.TYPE_ITEMS : parseItemsData(response.data); break;
			}
		}
		
		private function parseParametersData(xml:XML):void {
			if (!facade.hasProxy(ParametersDataProxy.NAME))
				facade.registerProxy(new ParametersDataProxy());
			
			var tDataProxy:ParametersDataProxy = facade.retrieveProxy(ParametersDataProxy.NAME) as ParametersDataProxy;
			
			var xList:XMLList = xml.brands.children();			
			for (var i:int = 0; i < xList.length(); i++) {
				tDataProxy.brands.push(new ParameterVO(xList[i]));
			}
			
			xList = xml.colors.children();			
			for (i = 0; i < xList.length(); i++) {
				tDataProxy.colors.push (new ParameterVO(xList[i]));
			}
			
			xList = xml.categories.children();			
			for (i = 0; i < xList.length(); i++) {
				tDataProxy.categories.push (new ParameterVO(xList[i]));
			}

			xList = xml.themes.children();			
			for (i = 0; i < xList.length(); i++) {
				tDataProxy.themes.push (new ParameterVO(xList[i]));
			}
			
			sendNotification(ApplicationFacade.PARAMETERS_DATA_CHANGE);
		}
		
		private function parseItemsData(xml:XML):void {
			sendNotification(ApplicationFacade.ITEMS_DATA_CHANGE, xml);	
		}
		
		
		
	}

}