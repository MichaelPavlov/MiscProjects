package com.shurba.fashionventures.view.components {
	import com.bit101.components.ComboBox;
	import com.shurba.fashionventures.model.constants.ProjectConstants;
	import com.shurba.fashionventures.model.vo.ParameterVO;
	import com.shurba.fashionventures.view.events.ControlBarEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	 
	/**
	 Dispatched when a new items has been selected.
	 @eventType	com.shurba.fashionventures.view.events.ControlBarEvent.SELECT_ITEM
	 */
	[Event(name="selectItem", type="com.shurba.fashionventures.view.events.ControlBarEvent")] 
	 
	public class ControlBar extends Sprite {
		
		public var categoriesCombo:ComboBox;
		public var themesCombo:ComboBox;
		public var colorsCombo:ComboBox;
		public var brandsCombo:ComboBox;
		
		public function ControlBar() {
			super();
			initializeView();
		}
		
		private function addListeners():void {
			categoriesCombo.addEventListener(Event.SELECT, newItemSelected, false, 0, true);
			themesCombo.addEventListener(Event.SELECT, newItemSelected, false, 0, true);
			colorsCombo.addEventListener(Event.SELECT, newItemSelected, false, 0, true);
			brandsCombo.addEventListener(Event.SELECT, newItemSelected, false, 0, true);
		}
		
		private function newItemSelected(e:Event):void {
			var event:ControlBarEvent = new ControlBarEvent(ControlBarEvent.SELECT_ITEM, e.currentTarget.selectedItem);
			var dataObj:Object = { };
			if (brandsCombo.selectedItem && brandsCombo.selectedItem.data)
				dataObj[ControlBarEvent.BRAND] = brandsCombo.selectedItem.data;
			if (categoriesCombo.selectedItem && categoriesCombo.selectedItem.data)
				dataObj[ControlBarEvent.CATEGORY] = categoriesCombo.selectedItem.data;
			if (colorsCombo.selectedItem && colorsCombo.selectedItem.data)
				dataObj[ControlBarEvent.COLOR] = colorsCombo.selectedItem.data;
			if (themesCombo.selectedItem && themesCombo.selectedItem.data)
				dataObj[ControlBarEvent.THEME] = themesCombo.selectedItem.data;
				
			event.data = dataObj;
			dispatchEvent(event);
		}
		
		private function initializeView():void {
			categoriesCombo = new ComboBox();
			themesCombo = new ComboBox();
			colorsCombo = new ComboBox();
			brandsCombo = new ComboBox();
			
			addChild(categoriesCombo);
			addChild(themesCombo);
			addChild(colorsCombo);
			addChild(brandsCombo);
			
			addListeners();
			
			brandsCombo.x = 0;
			themesCombo.x = 110;
			colorsCombo.x = 220;
			categoriesCombo.x = 330;
		}
		
		public function set categories(data:Array):void {
			categoriesCombo.items = data;
			var emptyObject:ParameterVO = new ParameterVO();
			emptyObject.data = null;
			emptyObject.label = 'All categoriesCombo';
			categoriesCombo.addItemAt(emptyObject, 0);
			categoriesCombo.selectedIndex = 0;
		}
		
		public function set themes(data:Array):void {
			themesCombo.items = data;
			var emptyObject:ParameterVO = new ParameterVO();
			emptyObject.data = null;
			emptyObject.label = 'All themesCombo';
			themesCombo.addItemAt(emptyObject, 0);
			themesCombo.selectedIndex = 0;
		}
		
		public function set colors(data:Array):void {
			colorsCombo.items = data;
			var emptyObject:ParameterVO = new ParameterVO();
			emptyObject.data = null;
			emptyObject.label = 'All colorsCombo';
			colorsCombo.addItemAt(emptyObject, 0);
			colorsCombo.selectedIndex = 0;
		}
		
		public function set brands(data:Array):void {
			brandsCombo.items = data;
			var emptyObject:ParameterVO = new ParameterVO();
			emptyObject.data = null;
			emptyObject.label = 'All brandsCombo';
			brandsCombo.addItemAt(emptyObject, 0);
			brandsCombo.selectedIndex = 0;
		}
		
		public function get categories():Array {
			return categoriesCombo.items;
		}
		
		public function get themes():Array {
			return themesCombo.items;
		}
		
		public function get colors():Array {
			return colorsCombo.items;
		}
		
		public function get brands():Array {
			return brandsCombo.items;
		}
		
		
	}

}