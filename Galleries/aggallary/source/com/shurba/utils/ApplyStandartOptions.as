package com.shurba.utils {
	import flash.display.*;	
	import flash.ui.ContextMenu;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ApplyStandartOptions {
		
		public function ApplyStandartOptions($scene:InteractiveObject) {
			$scene.stage.align = StageAlign.TOP_LEFT;
			$scene.stage.scaleMode = StageScaleMode.NO_SCALE;
			var myMenu:ContextMenu = new ContextMenu();
            myMenu.hideBuiltInItems();
			$scene.contextMenu = myMenu;
		}
		
	}

}