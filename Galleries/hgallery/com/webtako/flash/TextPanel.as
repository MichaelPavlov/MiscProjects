package com.webtako.flash {
	import caurina.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.webtako.flash.TextFieldHolder;
	
	public class TextPanel extends Sprite {
		public static const TRANSITION_TIME:Number = 0.40;
		public static const TEXT_MARGIN:Number = 5;
		public static const DEFAULT_HEIGHT:Number = 500;
		
		private var _textField:TextField;
		private var _panel:Shape;		
		private var _panelWidth:Number;
		private var _panelHeight:Number;
		private var _margin:Number;
		private var _doubleMargin:Number;
					
		public function TextPanel(panelWidth:Number, panelHeight:Number = DEFAULT_HEIGHT, margin:Number = TEXT_MARGIN,
								   textSize:Number = 12, textAlign:String = TextFormatAlign.LEFT, 
								   textColor:uint = 0xFFFFFF, bgColor:uint = 0x000000, bgAlpha = FlashUtil.DEFAULT_ALPHA) {			
			//set properties
			this._panelWidth =  panelWidth;
			this._panelHeight = panelHeight;
			this._margin = margin;
			this._doubleMargin = (2 * this._margin);
			
			//init panel
			this._panel = new Shape();
			this._panel.graphics.beginFill(bgColor, bgAlpha);
			this._panel.graphics.drawRect(0, 0, this._panelWidth, this._panelHeight);
			this._panel.graphics.endFill();	
			this.addChild(this._panel);	
			
			//init text format
			var textFormat:TextFormat = new TextFormat();
			//textFormat.font = FlashUtil.getInstance().TEXT_FONT1.fontName;
			textFormat.size =  textSize;
			textFormat.color = textColor;	
			textFormat.align = textAlign.toLowerCase();
			
			//init text field
			var txtHolder:TextFieldHolder = new TextFieldHolder();
			this._textField = txtHolder.TXT;
			this._textField.defaultTextFormat = textFormat;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.selectable = false;
			this._textField.multiline = true;			
			this._textField.wordWrap = true;										
			this._textField.condenseWhite = true;
			this._textField.embedFonts = true;
			this._textField.antiAliasType = AntiAliasType.ADVANCED;				
			this._textField.width = this._panelWidth - this._doubleMargin;
			this._textField.htmlText = "";
			this._textField.x = this._margin;		
			this.addChild(this._textField);

			//set position
			this.y = -this._panelHeight;
		}
		
		//reset text panel
		public function reset():void {
			this._textField.alpha = 0;
			this._textField.htmlText = "";
			this._textField.autoSize = TextFieldAutoSize.LEFT;		
			Tweener.addTween(this, {y:-this.panelHeight, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});						
		}

		//on stage resize
		public function onResize():void {
			this._panel.width = this.stage.stageWidth;
			this._textField.width = this._panel.width - this._doubleMargin;
			this._textField.y = this._panel.height - (this._textField.height + this._margin);	
			if (this._textField.htmlText != "") {
				this.y = -this.panelHeight + (this._textField.height + this._doubleMargin);	
			}
			else {
				this.y = -this.panelHeight;
			}
		}
				
		//update text
		public function updatePanelText(description:String):void {
			this._textField.alpha = 0;
			
			//set text			
			this._textField.htmlText = description;
			this._textField.autoSize = TextFieldAutoSize.LEFT;		

			//empty text
			if (!description || this._textField.htmlText == "") {
				Tweener.addTween(this, {y:-this.panelHeight, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE,
									onComplete:fadeinText, onOverwrite:fadeinText});
				return;
			}
			
			//adjust text field
			if (this._textField.height + this._doubleMargin > this.panelHeight) {
				this._textField.autoSize = TextFieldAutoSize.NONE;
				this._textField.height = this.panelHeight - this._doubleMargin;	
			}			
			
			this._textField.y = this.panelHeight - (this._textField.height + this._margin);						
			var yPos:Number = -this.panelHeight + (this._textField.height + this._doubleMargin);	
							
			Tweener.addTween(this, {y:yPos, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, 
								onComplete:fadeinText, onOverwrite:fadeinText});
		}
		
		//get panel width
		public function get panelWidth():Number {
			if (this.stage) {
				return this.stage.stageWidth;
			}	
			return this._panelWidth;
		}
		
		//get panel height
		public function get panelHeight():Number {
			return this._panelHeight;	
		}
		
		//fade in text field
		private function fadeinText():void {
			Tweener.addTween(this._textField, {alpha:1, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
		}		
	}
}