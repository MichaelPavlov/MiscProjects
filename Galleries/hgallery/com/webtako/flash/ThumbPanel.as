package com.webtako.flash
{
	import caurina.transitions.Tweener;
	
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class ThumbPanel extends Sprite {	
		public static const BUTTON_WIDTH:Number = 30;
			
		private var _thumbPane:Sprite;
		private var _thumbStrip:Sprite;
		private var _maskSprite:Sprite;
		private var _background:Shape;
		private var _backButton:ArrowButton;
		private var _fwdButton:ArrowButton;		
		private var _unitSize:Number;
		private var _panelWidth:Number;
		private var _panelHeight:Number;
		private var _thumbWidth:Number;
		private var _thumbHeight:Number;
		private var _gap:Number;
		private var _thumbPaneWidth:Number;
		private var _currentPos:Number;		
		private var _numThumbs:uint;
		private var _numThumbDisplay:uint;
		private var _slotsLimit:uint;
		private var _backSlotsFilled:uint;
		private var _fwdSlotsFilled:uint;
		private var _userInteraction:Boolean;
		private var _hidden:Boolean;
		
		public function ThumbPanel(panelWidth:Number, panelHeight:Number, thumbWidth:Number, thumbHeight:Number, gap:Number, 
									color:uint = 0xFFFFFF, mouseoverColor:uint = 0x0066FF, 
									bgColor:uint = 0x000000, gradientColor:uint = 0x000000,
									bgAlpha:Number = 1) {			
			this._panelWidth = panelWidth;
			this._panelHeight = panelHeight;
			this._thumbWidth = thumbWidth;
			this._thumbHeight = thumbHeight;
			this._gap = gap;
			this._unitSize = this._thumbWidth + this._gap;		
			this._userInteraction = false;
			this._hidden = false;
			
			//init back button		
			this._backButton = new ArrowButton(ArrowButton.BACK, color, mouseoverColor, 0x000000, 0, 0x000000,
											 	BUTTON_WIDTH, thumbHeight);			
			this._backButton.addEventListener(MouseEvent.CLICK, moveThumbsBack);	
			this._backButton.x = 0;
			this._backButton.y = FlashUtil.getCenter(this._panelHeight, this._backButton.height);
			this.addChild(this._backButton);					
			
			//init forward button				 					
			this._fwdButton = new ArrowButton(ArrowButton.FORWARD, color, mouseoverColor, 0x000000, 0, 0x000000,
												BUTTON_WIDTH, thumbHeight);
			this._fwdButton.addEventListener(MouseEvent.CLICK, moveThumbsFwd);
			this._fwdButton.x = this._panelWidth - this._fwdButton.width;	
			this._fwdButton.y = FlashUtil.getCenter(this._panelHeight,  this._fwdButton.height);			
			this.addChild(this._fwdButton);
						
			//init background
			this._background = new Shape();
			if (bgColor == gradientColor || bgAlpha < 1) {
				this._background.graphics.beginFill(bgColor, bgAlpha);
			}
			else {
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(this._panelWidth, this._panelHeight, Math.PI/2, 0, 0);
				this._background.graphics.beginGradientFill(GradientType.LINEAR, [bgColor, gradientColor], [1, 1], [0, 255], matrix, SpreadMethod.PAD);	
			}
			this._background.graphics.drawRect(0, 0, this._panelWidth, this._panelHeight);
			this._background.graphics.endFill();			
			this.addChildAt(this._background, 0);
		}

		//init thumb pane
		public function initThumbPane(thumbs:Array):void {
			if (this._thumbPane && this.contains(this._thumbPane)) {
				this.removeChild(this._thumbPane);
				this._thumbPane = null;
				this._thumbStrip = null;				
			}
			
			this._numThumbs = thumbs.length;
			var stripWidth:Number = this._numThumbs * this._unitSize;								
			var availWidth:Number = Math.floor(this.panelWidth - (2 * BUTTON_WIDTH));			
			var numDisplay:Number = Math.max(Math.floor(availWidth/this._thumbWidth), 1);			
			
			//set properties
			this._currentPos = 0;			
			this._numThumbDisplay = (numDisplay > this._numThumbs) ? this._numThumbs : numDisplay;					
			this._thumbPaneWidth = (this._numThumbDisplay * this._thumbWidth) + ((this._numThumbDisplay - 1) * this._gap);	
			
			//init thumb pane					
			this._thumbPane = new Sprite();
			
			//init mask		
			this._maskSprite = new Sprite();
			this._maskSprite.graphics.beginFill(0x000000);
			this._maskSprite.graphics.drawRect(0, 0, this._thumbPaneWidth, this._thumbHeight);
			this._maskSprite.graphics.endFill();
			this._thumbPane.mask = this._maskSprite;
			this._thumbPane.addChild(this._maskSprite);			
			
			//init thumb strip
			this._thumbStrip = new Sprite();			
			this._thumbStrip.graphics.beginFill(0x000000, 0);
			this._thumbStrip.graphics.drawRect(0, 0, stripWidth, this._thumbHeight);
			this._thumbStrip.graphics.endFill();
			this._thumbPane.addChild(this._thumbStrip);
			
			//add component	
			this._thumbPane.x = FlashUtil.getCenter(this.panelWidth, this._thumbPaneWidth);
			this._thumbPane.y = FlashUtil.getCenter(this.panelHeight, this._thumbHeight);
			this.addChild(this._thumbPane);
			
			//add thumbnails
			for (var i:int = 0; i < thumbs.length; i++) {
				var thumb:Slide = Slide(thumbs[i]);
				thumb.index = i;

				//add thumbnail 		
				thumb.x = i * this._unitSize;
				this._thumbStrip.addChild(thumb);	
			}	
			
			//set slots value
			this._slotsLimit = this._numThumbs - this._numThumbDisplay;
			this._backSlotsFilled = 0;
			this._fwdSlotsFilled = this._slotsLimit;
			
			this.checkButtons();
		}
		
		//on stage resize
		public function onResize():void {			
			this.x = 0;
			if (!this._hidden) {
				this.y = this.stage.stageHeight - this.panelHeight;
			}
			else {
				this.y = this.stage.stageHeight;
			}
			this._background.x = this.x;
			this._background.width = this.stage.stageWidth;
			
			var availWidth:Number = Math.floor(this.stage.stageWidth - (2 * BUTTON_WIDTH));
			var numDisplay:Number = Math.max(Math.floor(availWidth/this._thumbWidth), 1);
			if (numDisplay > this._numThumbs) {
				numDisplay = this._numThumbs;
			}
			
			var diff:int = numDisplay - this._numThumbDisplay;
			this._numThumbDisplay = numDisplay;
			
			//set slots value
			this._slotsLimit = this._numThumbs - this._numThumbDisplay;
			if (diff <= this._fwdSlotsFilled) {
				//slots available
				this._fwdSlotsFilled = this._fwdSlotsFilled - diff;
			}
			else {
				//slots unavailable
				this._currentPos = -this._slotsLimit * this._unitSize;
				this._thumbStrip.x = this._currentPos;
				this._backSlotsFilled = this._slotsLimit;				
				this._fwdSlotsFilled = 0;				
			}
			
			//init mask
			this._thumbPaneWidth = (this._numThumbDisplay * this._thumbWidth) + ((this._numThumbDisplay - 1) * this._gap);
			this._maskSprite.width = this._thumbPaneWidth;
			this._thumbPane.x = FlashUtil.getCenter(this.stage.stageWidth, this._thumbPaneWidth);
		
			//init directional buttons	
			this._backButton.x = 0;
			this._fwdButton.x = this.stage.stageWidth - BUTTON_WIDTH;		
			this.checkButtons();
		}
		
		//move thumbs forward
		public function moveThumbsFwd(event:MouseEvent):void {	
			this._userInteraction = true;		
			if (this._backSlotsFilled < this._slotsLimit) {
				var moveBy:uint = this._slotsLimit - this._backSlotsFilled;
				if (moveBy >= this._numThumbDisplay) {
					moveBy = this._numThumbDisplay;
				}	
				
				this._backSlotsFilled += moveBy;
				this._fwdSlotsFilled -= moveBy;
				this._currentPos -= (moveBy * this._unitSize);
			
				Tweener.addTween(this._thumbStrip, {x:this._currentPos, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:checkButtons});
			}
		}

		//move thumbs backward
		public function moveThumbsBack(event:MouseEvent):void {
			this._userInteraction = true;		
			if (this._fwdSlotsFilled < this._slotsLimit) {
				var moveBy:uint = this._slotsLimit - this._fwdSlotsFilled;
				if (moveBy >= this._numThumbDisplay) {
					moveBy = this._numThumbDisplay;
				}	
				
				this._fwdSlotsFilled += moveBy;
				this._backSlotsFilled -= moveBy;
				this._currentPos += (moveBy * this._unitSize);	

				Tweener.addTween(this._thumbStrip, {x:this._currentPos, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:checkButtons});				
			}
		}
		
		//move one thumb forward
		public function moveThumbFwd(event:MouseEvent):void {	
			this._userInteraction = true;				
			if (this._backSlotsFilled < this._slotsLimit) {
				this._backSlotsFilled += 1;
				this._fwdSlotsFilled -= 1;
				this._currentPos -= this._unitSize;
			
				Tweener.addTween(this._thumbStrip, {x:this._currentPos, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:checkButtons});
			}
		}

		//move one thumb back		
		public function moveThumbBack(event:MouseEvent):void {
			this._userInteraction = true;			
			if (this._fwdSlotsFilled < this._slotsLimit) {
				this._fwdSlotsFilled += 1;
				this._backSlotsFilled -= 1;
				this._currentPos += this._unitSize;	

				Tweener.addTween(this._thumbStrip, {x:this._currentPos, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:checkButtons});				
			}
		}
		
		//move thumbs by index
		public function moveByIndex(index:uint):void {
			var prevPos:Number = Math.abs(this._currentPos/this._unitSize);
			if (index >= prevPos && index < prevPos + this._numThumbDisplay) {
				return;
			}
			
			if (index < this._slotsLimit) {					
				this._backSlotsFilled = index;
				this._fwdSlotsFilled = this._slotsLimit - index;
				this._currentPos = -index * this._unitSize;  						
			}
			else {
				this._backSlotsFilled = this._slotsLimit;
				this._fwdSlotsFilled = 0;
				this._currentPos = -this._slotsLimit * this._unitSize;
			}
		
			Tweener.addTween(this._thumbStrip, {x:this._currentPos, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onStart:checkButtons});		
		}
		
		//move thumbs on rotate
		public function moveByRotate(index:uint):void {
			var prevPos:Number = Math.abs(this._currentPos/this._unitSize);
			if (this._userInteraction) {
				 if (index >= prevPos && index < prevPos + this._numThumbDisplay) {
				 	this._userInteraction = false;
				 }
				 else if (prevPos >= (this._numThumbs - this._numThumbDisplay) && prevPos < (this._numThumbs - 1) && index == 0) {
				 	this._userInteraction = false;
				 }
				 else {
				 	return;
				 }
			}			
			this.moveByIndex(index);
		}
		
		//display panel
		public function display():void {
			this._hidden = false;
			Tweener.addTween(this, {y:this.stage.stageHeight - this._panelHeight, time:0.5, transition:"linear"});		
		}
		
		//hide panel
		public function hide():void {
			this._hidden = true;
			Tweener.addTween(this, {y:this.stage.stageHeight, time:0.4, transition:"linear"});
		}

		//get panel height		
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
		
		//get hidden flag
		public function get hidden():Boolean {
			return this._hidden;	
		}
		
		//check directional buttons
		private function checkButtons():void {			
			//check back button
			if (this._fwdSlotsFilled == this._slotsLimit) {
				this._backButton.disable();
			}
			else {
				this._backButton.enable();	
			}
			
			//check forward button
			if (this._backSlotsFilled == this._slotsLimit) {
				this._fwdButton.disable();
			}
			else {
				this._fwdButton.enable();
			}
		}
	}
}