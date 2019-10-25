package com.shurba.fashionventures.controller {
	import com.shurba.fashionventures.view.ApplicationMediator;
	import com.shurba.Main;
	import flash.display.DisplayObject;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ViewPrepCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void {			
			facade.registerMediator(new ApplicationMediator(notification.getBody() as Main));
		}
		
	}

}