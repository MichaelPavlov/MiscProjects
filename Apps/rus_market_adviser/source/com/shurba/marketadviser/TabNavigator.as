package com.shurba.marketadviser {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class TabNavigator extends Sprite {
		
		[Event(name="change", type="flash.events.Event")]
		
		public var tab0:Sprite;
		public var tab1:Sprite;
		public var tab2:Sprite;
		public var tab3:Sprite;
		
		private var _selectedIndex:int;
		
		private var _selectedTab:Sprite;
		
		public function TabNavigator() {
			super();
			this.affListeners();
			this.selectedIndex = 0;
		}
		
		private function affListeners():void {
			for (var i:int = 0; i < 4; i++) {
				var tabName:String = "tab" + i.toString();				
				(this[tabName] as Sprite).addEventListener(MouseEvent.CLICK, tabClickHandler, false, 0, true);
			}
		}
		
		private function removeListeners():void {
			for (var i:int = 0; i < 4; i++) {
				var tabName:String = "tab" + i.toString();				
				(this[tabName] as Sprite).removeEventListener(MouseEvent.CLICK, tabClickHandler);
			}
		}
		
		private function tabClickHandler(e:MouseEvent):void {			
			var tab:Sprite = e.currentTarget as Sprite;			
			this.selectedIndex = e.currentTarget.index;
		}
		
		public function get selectedIndex():int { 
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			_selectedIndex = value;
			var tabName:String = "tab" + value.toString();
			_selectedTab = this[tabName];
			this.removeChild(_selectedTab);
			this.addChild(_selectedTab);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selectedTab():Sprite { 
			return _selectedTab; 
		}
		
		public function set selectedTab(value:Sprite):void {
			//_selectedTab = value;
		}
		
	}

}