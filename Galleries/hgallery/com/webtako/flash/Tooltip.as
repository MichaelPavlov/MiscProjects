package com.webtako.flash {
	import caurina.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Tooltip extends Sprite {		
		public static const TRANSITION_TIME:Number = 0.25;
		public static const PADDING:Number = 2;	
		public static const DOUBLE_PADDING:Number = 2 * PADDING;	
		public static const ELLIPSE_SIZE:uint = 6;
		public static const TAIL_WIDTH:Number = 8;
		public static const TAIL_HEIGHT:Number = 7;
		public static const MAX_LENGTH:Number = 15;
		public static const MAX_WIDTH:Number = 100;
		
		private var _textField:TextField;
		private var _xOffset:Number;
		private var _container:Sprite;
		private var _tail:Shape;
		private var _bgColor:uint;
		private var _bgAlpha:Number;
		
		public function Tooltip(text:String = "", textSize:Number = 12, textColor:uint = 0xFFFFFF, 
								bgColor:uint = 0x000000, bgAlpha:Number = FlashUtil.DEFAULT_ALPHA) {
			//assign properties
			this._bgColor = bgColor;
			this._bgAlpha = bgAlpha;
			
			//init text format
			var textFormat:TextFormat = new TextFormat();
			//textFormat.font = FlashUtil.getInstance().TEXT_FONT1.fontName;
			textFormat.size =  textSize;
			textFormat.color = textColor;	
			textFormat.align = TextFormatAlign.LEFT;
			
			//init text field
			var txtHolder:TextFieldHolder = new TextFieldHolder();
			this._textField = txtHolder.TXT;
			this._textField.defaultTextFormat = textFormat;
			this._textField.selectable = false;	
			this._textField.multiline = true;			
			this._textField.wordWrap = false;
			this._textField.embedFonts = true;
			this._textField.antiAliasType = AntiAliasType.ADVANCED;				
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.text = text;
			
			//init background	
			this._container = new Sprite();
			this._container.graphics.beginFill(this._bgColor, this._bgAlpha);
			this._container.graphics.drawRoundRect(0, 0, 
													this._textField.width + DOUBLE_PADDING, 
													this._textField.height + DOUBLE_PADDING, 
													ELLIPSE_SIZE, ELLIPSE_SIZE);
			this._container.graphics.endFill();

			//init tooltip tail			
			this._tail = new Shape();
			this._tail.graphics.beginFill(this._bgColor, this._bgAlpha);
			this._tail.graphics.lineTo(TAIL_WIDTH, 0);
			this._tail.graphics.lineTo(Math.round(TAIL_WIDTH/2), TAIL_HEIGHT);
			this._tail.graphics.endFill();			
			this._tail.x = FlashUtil.getCenter(this._container.width, this._tail.width);			
			this._tail.y = this._container.height;
			this._container.addChild(this._tail);
					
			//add text field
			this._textField.x = PADDING;
			this._textField.y = PADDING;
			this._container.addChild(this._textField);			
									
			//add container
			this._xOffset = -Math.round(this._container.width/2);	
			this.addChild(this._container);
			
			//init misc. properties
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.buttonMode = false;			
			this.alpha = 0;			
		}
		
		//display tooltip
		public function display(xPos:Number, yPos:Number):void {
			if (this._textField.text != "") {			
				this.x = xPos + this._xOffset ;
				this.y = yPos - this._container.height;		
				Tweener.addTween(this, {alpha:1, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});				
			}
		}
		
		//move tooltip
		public function move(xPos:Number, yPos:Number):void {
			this.x = xPos + this._xOffset;
			this.y = yPos - this._container.height;
		}
		
		//hide tooltip
		public function hide():void {
			Tweener.addTween(this, {alpha:0, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//set tooltip text
		public function assignText(val:String):void {
			this.removeChild(this._container);
			this._container.removeChild(this._textField);
			this._container.removeChild(this._tail);
			this._container.graphics.clear();
			
			//set text field
			if (val.length > MAX_LENGTH) {
				this._textField.wordWrap = true;	
				this._textField.width = MAX_WIDTH;
			}
			else {
				this._textField.wordWrap = false;
			}
			this._textField.text = val;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			
			//init container
			this._container.graphics.beginFill(this._bgColor, this._bgAlpha);
			this._container.graphics.drawRoundRect(0, 0, 
													this._textField.width + DOUBLE_PADDING, 
													this._textField.height + DOUBLE_PADDING, 
													ELLIPSE_SIZE, ELLIPSE_SIZE);
			this._container.graphics.endFill();
		
			//add components
			this._container.addChild(this._textField);						
			this._tail.x = FlashUtil.getCenter(this._container.width, this._tail.width);
			this._tail.y = this._container.height;			
			this._container.addChild(this._tail);			
			
			this._xOffset = -Math.round(this._container.width/2);			
			this.addChild(this._container);			
		}	
	}
}