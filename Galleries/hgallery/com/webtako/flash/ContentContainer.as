package com.webtako.flash
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ContentContainer extends Sprite {
		public static const SCROLL_SPEED:Number = 4;
		public static const TRANSITION_TIME:Number = 0.5;
		
		private var _content:DisplayObject;
		private var _contentWidth:Number;
		private var _contentHeight:Number;		
		private var _destX:Number;
		private var _destY:Number;
		private var _zoomin:Boolean;
		private var _zoomWidth:Number;
		private var _zoomHeight:Number;
		
		public function ContentContainer(content:DisplayObject) {
			//init properties
			this._content = content;	
					
			if (this._content is MovieClip) {
				try { 
					MovieClip(this._content).gotoAndStop(1); 
				}
				catch (e:Error) { trace(e.message); }
			}						
			
			//set content properties			
			this._contentWidth =  this._content.width;
			this._contentHeight = this._content.height;	
						
			//init background
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, this._contentWidth, this._contentHeight);
			this.graphics.endFill();
				
			//set mouse properties
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = true;
			
			//add content
			this.addChild(this._content);	
		}
		
		//get content
		public function get content():DisplayObject {
			return this._content;
		}
		
		//on resize
		public function onResize():void {
			this.x = FlashUtil.getCenter(this.stage.stageWidth,  this.width);
			this.y = FlashUtil.getCenter(this.stage.stageHeight, this.height);
		}
		
		//zoom in content
		public function zoomin(transition:Boolean = true):void {
			if (!this._zoomin) {
				var zoomWidth:Number;
				var zoomHeight:Number;
				
				if (this._contentWidth >= this._contentHeight) {
					this._zoomWidth =  this.stage.stageWidth;
					this._zoomHeight = Math.round(this._contentHeight * (this.stage.stageWidth/this._contentWidth));
					if (this._zoomHeight < this.stage.stageHeight) {
						this._zoomHeight = this.stage.stageHeight;
						this._zoomWidth = Math.round(this._contentWidth * (this.stage.stageHeight/this._contentHeight));
					}
				}
				else {
					this._zoomHeight = this.stage.stageHeight;
					this._zoomWidth = Math.round(this._contentWidth * (this.stage.stageHeight/this._contentHeight));			
					if (this._zoomWidth < this.stage.stageWidth) {
						this._zoomWidth =  this.stage.stageWidth;
						this._zoomHeight = Math.round(this._contentHeight * (this.stage.stageWidth/this._contentWidth));
					}
				}	
			
				var	zoomX:Number = FlashUtil.getCenter(this.stage.stageWidth,  this._zoomWidth);
				var	zoomY:Number = FlashUtil.getCenter(this.stage.stageHeight, this._zoomHeight);
					
				if (transition) {
					Tweener.addTween(this, {width:this._zoomWidth, height:this._zoomHeight, x:zoomX, y:zoomY,						
									 			time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, 
									 			onComplete:zoomComplete});	
				}
				else {
					this.width  = this._zoomWidth;
					this.height = this._zoomHeight;
					this.x = zoomX;
					this.y = zoomY;
					this.zoomComplete();
				}
			}
			this._zoomin = true;			
		}
        
        //zoom out content
		public function zoomout(transition:Boolean = true):void {
			if (this._zoomin) {
				//remove mouse listeners				
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
				this.removeEventListener(Event.ENTER_FRAME, scrollX);
				this.removeEventListener(Event.ENTER_FRAME, scrollY);
				
				var zoomX:Number = FlashUtil.getCenter(this.stage.stageWidth, this._contentWidth);
				var zoomY:Number = FlashUtil.getCenter(this.stage.stageHeight, this._contentHeight);
					
				if (transition) {
					Tweener.addTween(this, {width:this._contentWidth, height:this._contentHeight, 
											x:zoomX, y:zoomY, time:TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
				}
				else {
					this.width = this._contentWidth;
					this.height = this._contentHeight;
					this.x = zoomX;
					this.y = zoomY;
				}
			}
			this._zoomin = false;				
		}
		
		//on zoom complete
		private function zoomComplete():void {
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);				
		}

		//on mouse move event handler
		private function onMousemove(event:MouseEvent) {	
			if (this.stage) {
				var xPct:Number = event.stageX/this.stage.stageWidth;
				var yPct:Number = event.stageY/this.stage.stageHeight;

				this._destX = Math.round(-((this.width - this.stage.stageWidth) * xPct));
				this._destY = Math.round(-((this.height - this.stage.stageHeight) * yPct));
                
	            this.addEventListener(Event.ENTER_FRAME, scrollX);
    	        this.addEventListener(Event.ENTER_FRAME, scrollY);
   			}
		} 
		
		//scroll by x
		private function scrollX(event:Event):void {
			if (this.x == this._destX) {
				this.removeEventListener(Event.ENTER_FRAME, scrollX);
			} 
			else {
				var moveBy:Number = ((this._destX - this.x) * (SCROLL_SPEED/100));
				moveBy = (moveBy > 0) ? Math.ceil(moveBy) : Math.floor(moveBy);
				this.x += moveBy;
			//	trace("x = " + this.x + "," + this._destX + " (" + this._zoomWidth + "," + this.stage.stageWidth + ")");
			}
		}
		
		//scroll by y
		private function scrollY(event:Event):void {
			if (this.y == this._destY) {
				this.removeEventListener(Event.ENTER_FRAME, scrollY);
			}
			else {
				var moveBy:Number = ((this._destY - this.y) * (SCROLL_SPEED/100));
				moveBy = (moveBy > 0) ? Math.ceil(moveBy) : Math.floor(moveBy);
				this.y += moveBy;
			//	trace("y = " + this.y + "," + this._destY + " (" + this._zoomHeight + "," + this.stage.stageHeight + ")");			
			}
		}	
	}
}