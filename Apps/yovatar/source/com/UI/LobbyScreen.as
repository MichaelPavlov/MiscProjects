package com.UI {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	[Event("lobbyDone", type = "flash.events.Event")]
	
	public class LobbyScreen extends Sprite {
		
		private const SILHOUETTE_FEMALE:int = 1;
		private const SILHOUETTE_FEMALE_SELECTED:int = 2;
		private const SILHOUETTE_MALE:int = 3;
		private const SILHOUETTE_MALE_SELECTED:int = 4;
		
		
		
		public var select_female:MovieClip;
		public var select_male:MovieClip;
		//public var inputNameBox:MovieClip;
		public var selectGenderErrorOutline:Sprite;
		
		public var nextButton:SimpleButton;
		
		
		
		//public var nameInput:TextField
		
		private var selectedGender:int = -1;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function LobbyScreen() {
			this.init();
		}
		
		private function init():void {
			select_female.gotoAndStop(this.SILHOUETTE_FEMALE);
			select_male.gotoAndStop(this.SILHOUETTE_MALE);
			selectGenderErrorOutline.visible = false;
			select_male.buttonMode = true;
			select_female.buttonMode = true;
			//nameInput.type = TextFieldType.INPUT;
			//inputNameBox.gotoAndStop(1);			
			this.addListeners();
		}
		
		private function addListeners():void {
			select_female.addEventListener(MouseEvent.CLICK, selectGender);
			select_male.addEventListener(MouseEvent.CLICK, selectGender);
			
			nextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler);
			//nameInput.addEventListener(MouseEvent.CLICK, nameInputClickHandler);
			
			//nameInput.addEventListener(KeyboardEvent.KEY_DOWN, inputKeyDownHandler);
		}
		
		private function removeListeners():void {
			select_female.removeEventListener(MouseEvent.CLICK, selectGender);
			select_male.removeEventListener(MouseEvent.CLICK, selectGender);
			
			nextButton.removeEventListener(MouseEvent.CLICK, nextButtonClickHandler);
			//nameInput.removeEventListener(MouseEvent.CLICK, nameInputClickHandler);
			
			//nameInput.removeEventListener(KeyboardEvent.KEY_DOWN, inputKeyDownHandler);
		}
		
		private function selectGender($event:MouseEvent):void {
			
			if (selectGenderErrorOutline.visible) selectGenderErrorOutline.visible = false;
			
			switch ($event.currentTarget) {
				case select_male: {
					select_male.gotoAndStop(this.SILHOUETTE_MALE_SELECTED);
					select_female.gotoAndStop(this.SILHOUETTE_FEMALE);
					this.selectedGender = DataHolder.GENDER_MALE
					break;					
				}
				
				case select_female: {
					select_male.gotoAndStop(this.SILHOUETTE_MALE);
					select_female.gotoAndStop(this.SILHOUETTE_FEMALE_SELECTED);
					this.selectedGender = DataHolder.GENDER_FEMALE;
					break;
				}
			}
		}
		
		private function nextButtonClickHandler($event:MouseEvent):void {
			
			/*if (!this.checkValidName()) {				
				nameInput.text=" ";
				this.stage.focus = nameInput;
				nameInput.setSelection(nameInput.length, nameInput.length);
				nameInput.text = "";
				inputNameBox.gotoAndStop(2);
				return;
			}*/
			
			if (this.selectedGender == -1) {
				selectGenderErrorOutline.visible = true;
				return;
			}
			
			dataHolder.gender = this.selectedGender;
			//dataHolder.playerName = nameInput.text;
			
			this.dispatchNextEvent();			
		}
		
		/*private function nameInputClickHandler($event:MouseEvent):void {
			
			if (nameInput.text == "Enter Player Name") {
				nameInput.text = "";
			}
			
			nameInput.removeEventListener(MouseEvent.CLICK, nameInputClickHandler);
		}*/
		
		/*private function checkValidName():Boolean {
			return (nameInput.text == "Enter Player Name" || nameInput.text == "")? false: true;
		}*/
		
		protected function dispatchNextEvent():void {
			var $event:Event = new Event("lobbyDone");			
			this.dispatchEvent($event);
			this.removeListeners();
		}
		
		/*private function inputKeyDownHandler($event:KeyboardEvent):void {
			if ($event.currentTarget.text != "") inputNameBox.gotoAndStop(1);
		}*/
	}
	
}