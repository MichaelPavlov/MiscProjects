package com.webtako.flash
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ControlPanel extends Sprite
	{
		public static const CPANEL_HEIGHT:Number = 24;
		public static const MARGIN:Number = 10;

		private var _cpanelWidth:Number;
		private var _cpanelHeight:Number;		
		private var _background:Shape;
		private var _controlPane:Sprite;
		private var _menu:Menu;
		private var _infoField:TextField;
		private var _playButton:ControlButton;
		private var _timerBar:TimerBar;
		private var _yOffset:Number;
		private var _yPos:Number;
		private var _cpaneXOffset:Number;
		private var _down:Boolean;
		
		public function ControlPanel(cpanelWidth:Number, cpanelHeight:Number = CPANEL_HEIGHT, 
										bgColor:uint = 0x000000, bgAlpha:Number = FlashUtil.DEFAULT_ALPHA) {
			this._down = false;									
			this._cpanelWidth =  cpanelWidth;
			this._cpanelHeight = cpanelHeight;
						
			this._background = new Shape();
			this._background.graphics.beginFill(bgColor, bgAlpha);
			this._background.graphics.drawRect(0, 0, this._cpanelWidth, this._cpanelHeight);
			this._background.graphics.endFill();
			this.addChild(this._background);
			
			this._cpaneXOffset = 0;
			this._controlPane = new Sprite();
			this.addChild(this._controlPane);
		}

		//on stage resize
		public function onResize():void {
			this.x = 0;
			if (!this._down) {
				this.y = this.stage.stageHeight - (this._yOffset + this._cpanelHeight);
			}
			else {
				this.y = this.stage.stageHeight - this._cpanelHeight;
			}
			this._background.x = this.x;
			this._background.width = this.stage.stageWidth;
			
			this._infoField.x = FlashUtil.getCenter(this.stage.stageWidth, this._infoField.width);			
			this._controlPane.x = this.stage.stageWidth - (this._controlPane.width + MARGIN);
		}
		
		//move control panel down
		public function moveDown():void {
			this._down = true;
			Tweener.addTween(this, {y:this.stage.stageHeight - this._cpanelHeight, time:0.4, transition:"linear"});		
		}

		//move control panel up
		public function moveUp():void {
			this._down = false;
			Tweener.addTween(this, {y:this.stage.stageHeight - (this._yOffset + this._cpanelHeight), time:0.5, transition:"linear"});		
		}
		
		//add info field
		public function addInfoField(field:TextField):void {
			this._infoField = field;
			this._infoField.x = FlashUtil.getCenter(this._cpanelWidth, this._infoField.width);
			this._infoField.y = FlashUtil.getCenter(this._cpanelHeight, this._infoField.height);
			this.addChild(this._infoField);
		}
		
		//add play/pause button
		public function addPlayButton(button:ControlButton):void {
			this._playButton = button;
			this._playButton.x = this._cpaneXOffset;
			this._playButton.y = FlashUtil.getCenter(this._cpanelHeight, this._playButton.height);
			
			this._controlPane.addChild(this._playButton);	
			this._controlPane.x = this._cpanelWidth - (this._controlPane.width + MARGIN);
			this._cpaneXOffset += this._playButton.width;
		}

		//add timer bar
		public function addTimerBar(bar:TimerBar):void {
			this._timerBar = bar;
			this._timerBar.x = this._cpaneXOffset;
			this._timerBar.y = 	FlashUtil.getCenter(this._cpanelHeight, this._timerBar.height);
			
			this._controlPane.addChild(this._timerBar);	
			this._controlPane.x = this._cpanelWidth - (this._controlPane.width + MARGIN);
			this._cpaneXOffset += this._timerBar.width;			
		}	
			
		public function addThumbPanelButton(button:ControlButton):void {
			button.x = this._cpaneXOffset;
			button.y = FlashUtil.getCenter(this._cpanelHeight, button.height);
			this._controlPane.addChild(button);
			this._controlPane.x = this._cpanelWidth - (this._controlPane.width + MARGIN);
			this._cpaneXOffset += button.width;
		}
		
		//add menu	
		public function addMenu(menu:Menu):void {
			this._menu = menu;
			this._menu.x = MARGIN;
			this._menu.y = this._menu.yPosition;
			this.addChild(this._menu);
		}
		
		//set y offset
		public function set yOffset(offset:Number):void {
			this._yOffset = offset;
			this._yPos = this._yOffset + this._cpanelHeight; 
		}
	}
}