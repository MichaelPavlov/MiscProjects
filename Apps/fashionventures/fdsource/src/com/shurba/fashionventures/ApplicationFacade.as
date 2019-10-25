package com.shurba.fashionventures {
	import com.shurba.fashionventures.controller.*;
	import com.shurba.fashionventures.model.*;
	import com.shurba.Main;
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ApplicationFacade extends Facade {
		// Notification name constants
		public static const STARTUP:String = "startup";
		public static const PARAMETERS_DATA_CHANGE:String = "parametersDataChange";
		static public const ITEMS_DATA_CHANGE:String = "itemsDataChange";
		public static const PARAMETER_SELECTED:String = "parameterSelected";
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		/**
		 * Register Commands with the Controller 
		 */
		override protected function initializeController( ) : void {
			super.initializeController();
			
			registerCommand(STARTUP, StartupCommand);
			registerCommand(DataServiceProxy.LOAD, LoadDataCommand);
			registerCommand(DataServiceProxy.COMPLETE, HandleDataCommand);
			registerCommand(PARAMETER_SELECTED, LoadDataCommand);
		}
		
		/**
		 * The view hierarchy has been built, so start the application.
		 */
		public function startup( app:Main ):void {
			sendNotification(STARTUP, app);
		}
	}

}