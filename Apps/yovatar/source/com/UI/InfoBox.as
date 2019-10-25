package com.UI {	
	import com.data.DataHolder;
	import com.data.Publisher;
	import com.utils.EmailValidator;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InfoBox extends MovieClip {
		private var publisher:Publisher = new Publisher()
		var country_arr:Array = new Array()
		
		var dataHolder:DataHolder = DataHolder.getInstance()
		
		public var error_nickname:Sprite;
		public var error_email:Sprite;
		public var error_email2:Sprite;
		public var error_date:Sprite;
		public var error_country:Sprite;
		public var error_genre:Sprite;
		
		public var dateTF:TextField;
		public var nickname:TextField;
		public var email2:TextField;
		public var email:TextField;		
		
		public var sendBtn:SimpleButton;
		
		public var genre:ComboBox;
		public var countries:ComboBox = new ComboBox();
		private var cbData:DataProvider;
		
		
		public function InfoBox() {
			error_nickname.visible = false
			error_email.visible    = false
			error_email2.visible   = false
			error_date.visible     = false
			error_country.visible  = false
			error_genre.visible  = false
			
		    dateTF.restrict = "0-9";
			dateTF.maxChars = 2;
			
			sendBtn.addEventListener(MouseEvent.CLICK, sendBtn$click);
			this.initComponents();
		}
		
		private function initComponents():void {
			trace ("INIT COMPONENTS  " + countries + "  " + countries.addItem);
			var countriesArray:Array = dataHolder.getCountries();
			//cbData = new DataProvider();
			countries.addItem( { label:"Select country", data: -1 } );			
			for (var i in countriesArray) {				
				//trace ("INIT COMPONENTS  " + countries +);
				countries.addItem( { label:countriesArray[i], data:i } );				
			}
			//countries.dataProvider = cbData;
		}
		
		
		private function sendBtn$click(e:MouseEvent) {
			start_validate()
		}
		
		private function start_validate() {
			var has_error:Boolean = false;
			if (EmailValidator.isValidEmail(email.text)) {
				error_email.visible = false;
			}else {
				error_email.visible = true;
			}
			
			if (EmailValidator.isValidEmail(email2.text) && email2.text == email.text) {
				error_email2.visible = false;
			}else {
				error_email2.visible = true;
			}
			
			if (String(nickname.text).length > 0) {
				error_nickname.visible = false;
			}else {
				error_nickname.visible = true;
			}	
			
			
			if (String(dateTF.text).length == 2) {
				error_date.visible = false;
			}else {
				error_date.visible = true;
			}
			
			
			if (countries.selectedIndex != 0){
				error_country.visible = false;
			}else {
				error_country.visible = true;
			}		
			
			if (genre.selectedIndex != 0) {
				error_genre.visible = false;
			}else {
				error_genre.visible = true;
			}
			
			
			if (error_email2.visible || error_email.visible || error_nickname.visible || error_date.visible || error_country.visible || error_genre.visible) {
				has_error = true;
			}
			
			
			dataHolder.clientInfo.username = nickname.text;
			dataHolder.clientInfo.email    = email.text;
			dataHolder.clientInfo.birth_data = String(19) + dateTF.text;
			
			if (genre.selectedIndex != 0){
				dataHolder.clientInfo.sex = genre.selectedItem.label
			}
			
			
			dataHolder.clientInfo.country = countries.selectedItem.label;
			
			if (has_error) {				
				return
			}else {
				publisher.do_publish();
			}
		}
	}
}