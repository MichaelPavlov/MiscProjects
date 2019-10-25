package com.UI {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.*;
	import fl.motion.Color;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	*/
	
	
	 
	public class CategoryButton extends MovieClip {
		
		public var buttonText:TextField;
		public var hitZone:SimpleButton;
		public var isToggled:Boolean = false;
		public var categoryId:int = -1;
		
		private var uiColorNormal:uint = 0x38548F;
		private var uiColorToggled:uint = 0xFFFFFF;
		
		public function CategoryButton() {
			this.gotoAndStop(1);
		}
		
		public function toggleOff():void {
			isToggled = false;			
			this.gotoAndStop(1);
			this.updateTextColor();
		}
		
		public function toggleOn():void {
			isToggled = true;			
			this.gotoAndStop(2);
			this.updateTextColor();
		}
		
		public function set label($value:String):void {
			buttonText.text = $value;
		}
		
		public function get label():String {
			return buttonText.text; 
		}
		
		private function updateTextColor():void {
			var $colorTransform:ColorTransform = new ColorTransform();
			if (!isToggled) {
				$colorTransform.color = uiColorNormal;				
				buttonText.transform.colorTransform = $colorTransform;				
			} else {
				$colorTransform.color = uiColorToggled;
				buttonText.transform.colorTransform = $colorTransform;				
			}
		}
		
	}
	
	
}