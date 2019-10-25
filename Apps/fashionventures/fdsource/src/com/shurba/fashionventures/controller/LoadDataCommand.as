package com.shurba.fashionventures.controller {
	import com.shurba.fashionventures.model.DataServiceProxy;
	import com.shurba.fashionventures.model.vo.RequestDataVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class LoadDataCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			var tServiceProxy:DataServiceProxy = facade.retrieveProxy(DataServiceProxy.NAME) as DataServiceProxy;
			tServiceProxy.loadData(notification.getBody() as RequestDataVO);
		}
		
	}

}