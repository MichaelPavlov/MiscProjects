package com.shurba.fashionventures.view.components {
	import com.greensock.TweenLite;
    import flash.display.Sprite;
        
    public class Tick extends Sprite {

        public function Tick(fromX:Number, fromY:Number, toX:Number, toY:Number, tickWidth:int, tickColor:uint) {
			this.graphics.lineStyle(tickWidth, tickColor, 1.0, false, "normal", "rounded");
			this.graphics.moveTo(fromX, fromY);
			this.graphics.lineTo(toX, toY);
        }
        
        public function fadeIn(duration:Number):void {
			TweenLite.killTweensOf(this);
			alpha = 0.1;			
			TweenLite.to(this, duration, { alpha:1 } );
        }
		
	}
}