package com.shurba.marketadviser {
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class LinkBuilder extends Sprite	{
		
		[Event(name="complete", type="flash.events.Event")]
		
		private const TWEEN_SHIFT:int = 15;
		
		private var _dataProvider:Array;
		
		public var links:Array = [];
		
		public var linksHolder:Sprite;
		
		private var tweenTimeline:TimelineLite;
		
		public var background:Shape = new Shape();
		
		public function LinkBuilder() {
			super();
			this.addChild(background);
		}
		
		private function buildLinks():void {			
			var tweens:Array = [];
			for (var i:int = 0; i < _dataProvider.length; i++) {
				var tmpLink:Link = new Link(_dataProvider[i]);
				links.push(tmpLink);
				this.addChild(tmpLink);
				tmpLink.alpha = 0;
				tmpLink.y = i * 18 + TWEEN_SHIFT;
				var tweenToY:Number = tmpLink.y - TWEEN_SHIFT;
				
				tweens.push(new TweenLite(tmpLink, TweenConfiguration.TWEEN_DURATION, { y:tweenToY, alpha:1 } ));
			}
			tweenTimeline = new TimelineLite();
			tweenTimeline.insertMultiple(tweens, 0, TweenAlign.START, TweenConfiguration.TWEEN_STAGER);
			//tweenTimeline.vars.onComplete = displayReasy;
			
			this.drawBack();
			
			this.dispatchEvent(new Event(Event.COMPLETE));			
		}
		
		private function drawBack():void {
			background.graphics.clear();
			background.graphics.beginFill(0xFFFFFF, 0);
			background.graphics.drawRect(0, 0, this.width, this.height + 10);
			background.graphics.endFill();
		}
		
		
		
		public function clear():void {
			if (links.length == 0) {
				return;
			}
			
			for (var i:int = 0; i < links.length; i++) {
				(links[i] as Link).clear();
				this.removeChild(links[i]);
				links[i] = null;				
			}
			
			links = [];
		}
		
		
		
		public function get dataProvider():Array { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:Array):void {
			_dataProvider = value;
			this.clear();
			this.buildLinks();
		}
		
	}

}