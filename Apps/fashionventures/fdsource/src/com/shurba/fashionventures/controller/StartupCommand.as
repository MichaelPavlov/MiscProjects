package com.shurba.fashionventures.controller {
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class StartupCommand extends MacroCommand {
		
		
		override protected function initializeMacroCommand():void {
			addSubCommand(ModelPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
		
	}

}