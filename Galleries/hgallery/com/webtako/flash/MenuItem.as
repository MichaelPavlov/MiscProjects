package com.webtako.flash {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	ColorShortcuts.init();
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.MovieClip;
	
	public class MenuItem extends Sprite {
		public static const DOWN:uint = 1;
		public static const UP:uint = 2;
		public static const RIGHT:uint = 3;
		public static const EMPTY:uint = 4;
		public static const ITEM_WIDTH:Number = 120;
		public static const ITEM_HEIGHT:Number = 24;

		private var _index:int;
		private var _path:String;
		private var _icon:MovieClip;
		private var _textField:TextField;		
		private var _color:uint;
		private var _mouseoverColor:uint;
		private var _bgColor:uint;
		private var _main:Boolean;
		
		public function MenuItem(index:int, labelText:String, path:String, itemWidth:Number = ITEM_WIDTH, itemHeight:Number = ITEM_HEIGHT,  
								 textSize:Number = 12, color:uint = 0xFFFFFF, mouseoverColor:uint = 0x0066FF, bgColor:uint = 0x000000,
								 bgAlpha:Number = FlashUtil.DEFAULT_ALPHA, main:Boolean = false) {
			//set properties
			this._index = index;
			this._path = path;					 	
			this._color = color;
			this._mouseoverColor = mouseoverColor;
			this._bgColor = bgColor;
			this._main = main;

			//init background
			this.graphics.beginFill(this._bgColor, bgAlpha);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();

			//init icon
			this._icon = new MenuIcon();
			this._icon.y = FlashUtil.getCenter(itemHeight, this._icon.height);
			FlashUtil.setColor(this._icon, this._color);
			if (this._main) {
				this._icon.gotoAndStop(DOWN);
			}
			else {
				this._icon.gotoAndStop(EMPTY);				
			}
			this.addChild(this._icon);
						
			//init text format
			var textFormat:TextFormat = new TextFormat();
			//textFormat.font = FlashUtil.getInstance().TEXT_FONT1.fontName;
			textFormat.size = textSize;
			textFormat.color = this._color;	
			textFormat.align = TextFormatAlign.LEFT;
			
			//init text field
			var txtHolder:TextFieldHolder = new TextFieldHolder();
			this._textField = txtHolder.TXT;
			this._textField.defaultTextFormat = textFormat;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.selectable = false;
			this._textField.multiline = false;			
			this._textField.wordWrap = false;			
			this._textField.embedFonts = true;
			this._textField.antiAliasType = AntiAliasType.ADVANCED;				
			this._textField.text = labelText;			
			this._textField.x = this._icon.x + this._icon.width;
			this._textField.y = FlashUtil.getCenter(itemHeight, this._textField.height);
			this.addChild(this._textField);	
			
			FlashUtil.initMask(this, itemWidth, itemHeight);
			
			//init mouse behavior
			this.buttonMode = true;
			this.mouseEnabled = true;	
			this.mouseChildren = false;			
			this.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,  onItemOut);
		}

		//get index
		public function get index():int {
			return this._index;
		}
		
		//get path
		public function get path():String {
			return this._path;	
		}
		
		//get icon
		public function get icon():MovieClip {
			return this._icon;	
		}	
			
		//get label text
		public function get labelText():String {
			return this._textField.text;	
		}
		
		//set label text
		public function set labelText(val:String):void {
			this._textField.text = val;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		//on menu item over
		private function onItemOver(event:MouseEvent):void {
			if (!this._main) { 	
				this._icon.gotoAndStop(RIGHT);
			}
			else {
				this._icon.gotoAndStop(UP);	
			}
			
			Tweener.addTween(this._icon, {_color:this._mouseoverColor, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
			Tweener.addTween(this._textField, {_color:this._mouseoverColor, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on menu item out
		private function onItemOut(event:MouseEvent):void {
			if (!this._main) { 	
				this._icon.gotoAndStop(EMPTY);
			}
			
			Tweener.addTween(this._icon, {_color:this._color, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});
			Tweener.addTween(this._textField,  {_color:this._color, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
	}
}