package com.webtako.flash {
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Menu extends Sprite {
		public static var GAP_SIZE:Number = 1;

		private var _selectedIndex:int;
		private var _menuItem:MenuItem;
		private var _menuItems:Array;
		private var _menuPane:Sprite;
		private var _color:uint;
		private var _mouseoverColor:uint;
		
		public function Menu(menuItems:Array, menuWidth:Number, menuHeight:Number, textSize:Number = 12,
							color:uint = 0xFFFFFF, mouseoverColor:uint = 0x0066FF, bgColor:uint = 0x000000, 
							selectedIndex:int = 0) {			
			//set properties
			this._selectedIndex = selectedIndex;
			this._menuItems = menuItems;
			this._color = color;
			this._mouseoverColor = mouseoverColor;
			var unitSize:Number = (menuHeight + GAP_SIZE);		
			
			//init menu pane
			this._menuPane = new Sprite();
			this._menuPane.graphics.beginFill(0x000000, 0);
			this._menuPane.graphics.drawRect(0, 0, menuWidth, this._menuItems.length * unitSize);
			this._menuPane.graphics.endFill();
			this._menuPane.mouseEnabled = true;
			this._menuPane.mouseChildren = true;
			
			//add menu items
			for (var i:uint = 0; i < this._menuItems.length; i++) {
				var menuItem:MenuItem = MenuItem(this._menuItems[i]);
				menuItem.addEventListener(MouseEvent.CLICK, onMenuItemClick);
				//add menu item
				menuItem.y = i * unitSize;
				this._menuPane.addChild(menuItem);
			}	
			
			//init container
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0x000000, 0);
			container.graphics.drawRect(0, 0, menuWidth, (2 * this._menuPane.height));
			container.graphics.endFill();
			FlashUtil.initMask(container, menuWidth, this._menuPane.height);
			
			//init main menu item
			var isMain:Boolean = (this._menuItems.length > 1) ? true : false;
			this._menuItem = new MenuItem(selectedIndex, " ", "", menuWidth, menuHeight, textSize, 
											this._color, this._mouseoverColor, bgColor, 0, isMain);
			this._menuItem.addEventListener(MouseEvent.CLICK, onMainItemClick);
			
			//add components
			this._menuPane.y = this._menuPane.height;
			container.addChild(this._menuPane);
			this.addChild(container);
				
			this._menuItem.y = this._menuPane.height;
			if (this._selectedIndex >= 0 && this._selectedIndex < this._menuItems.length) {
				this._menuItem.labelText = MenuItem(this._menuItems[this._selectedIndex]).labelText;
			}
			this.addChild(this._menuItem);			
						
			//add event listener
			if (isMain) {
				this._menuItem.addEventListener(MouseEvent.ROLL_OVER, onMenuOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMenuOut);
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			}
			else {
				this._menuItem.mouseEnabled = false;
			}
		}

		//get selected index
		public function get selectedIndex():int {
			return this._selectedIndex;
		}
				
		//get y position
		public function get yPosition():Number {
			return -this._menuItem.y;
		}

		//on main item click event handler
		private function onMainItemClick(event:MouseEvent):void {
			event.stopPropagation();	
		}
		
		//on menu item click event handler
		private function onMenuItemClick(event:MouseEvent):void {					
			this._menuItem.icon.gotoAndStop(MenuItem.DOWN);
			Tweener.addTween(this._menuPane, {y:this._menuItem.y, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
			
			//update selected
			var selectedItem:MenuItem = MenuItem(event.currentTarget);
			this._selectedIndex = selectedItem.index;
			this._menuItem.labelText = selectedItem.labelText;
		}
		
		//on menu over event handler
		private function onMenuOver(event:MouseEvent):void {
			Tweener.addTween(this._menuPane, {y:0, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on menu out event handler
		private function onMenuOut(event:MouseEvent):void {
			this._menuItem.icon.gotoAndStop(MenuItem.DOWN);
			Tweener.addTween(this._menuPane, {y:this._menuItem.y, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});				
		}
		
		//on mouse move
		private function onMousemove(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
	}
}