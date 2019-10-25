package com.UI {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import gs.TweenLite;
	
	//[Event("pause", type = "flash.events.Event")]
	
	public class ToggleButton extends Sprite {
		
		public var normalState:MovieClip;
		public var toggleState:MovieClip;
		private var isToggled:Boolean = false;
		public var txtLabel:TextField;
		
		private var activeButton:MovieClip;
		
		private var uiColorNormal:uint = 0x38548F;
		private var uiColorToggled:uint = 0xFFFFFF;
		
		public function ToggleButton() {
			super();
			toggleState.gotoAndStop(1);
			normalState.gotoAndStop(1);
			this.toggleOff();
			txtLabel.mouseEnabled = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OVER, thisOnRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, thisOnRollOut);
			//this.addEventListener(MouseEvent.CLICK, thisClickHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, thisOnRollOut);
		}
		
		
		//SHOULD BE TOGGLED FROM OUTSIDE
		/*private function thisClickHandler($event:MouseEvent):void {
			if (!isToggled) {
				this.toggleOn();
			} else {
				this.toggleOff();
			}			
		}*/
		
		private function thisOnRollOver($event:MouseEvent):void {
			activeButton.gotoAndStop(2);			
		}
		
		private function thisOnRollOut($event:MouseEvent):void {
			activeButton.gotoAndStop(1);			
		}
		
		public function set normalTextColor($color:uint):void {
			uiColorNormal = $color;
			this.updateTextColor();
		}
		
		public function set toggledTextColor($color:uint):void {
			uiColorToggled = $color;
			this.updateTextColor();
		}
		
		public function toggleOff():void {
			isToggled = false;
			activeButton = normalState;
			normalState.visible = true;
			toggleState.visible = false;
			this.updateTextColor();
		}
		
		public function toggleOn():void {
			isToggled = true;
			activeButton = toggleState;
			normalState.visible = false;
			toggleState.visible = true;
			this.updateTextColor();
		}
		
		private function updateTextColor():void {
			var $colorTransform:ColorTransform = new ColorTransform();
			if (!isToggled) {
				$colorTransform.color = uiColorNormal;				
				txtLabel.transform.colorTransform = $colorTransform;
				//TweenLite.to(txtLabel, 0.5, { tint:uiColorNormal } );
			} else {
				$colorTransform.color = uiColorToggled;
				txtLabel.transform.colorTransform = $colorTransform;
				//TweenLite.to(txtLabel, 0.5, { tint:uiColorNormal } );
			}
		}
		
		private function updateWidth():void {
			txtLabel.width = txtLabel.textWidth + 5;
			normalState.width = txtLabel.width + 5;
			toggleState.width = txtLabel.width + 5;
			txtLabel.x = 2;
		}
		
		public function set label($text:String):void {
			this.updateWidth();
			txtLabel.text = $text;
		}
		
		public function get label():String { 
			return txtLabel.text; 
		}
		
		
	}
}