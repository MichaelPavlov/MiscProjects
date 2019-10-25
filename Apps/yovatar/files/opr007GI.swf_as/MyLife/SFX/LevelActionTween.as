package MyLife.SFX 
{
    import caurina.transitions.*;
    import flash.display.*;
    
    public class LevelActionTween extends flash.display.MovieClip
    {
        public function LevelActionTween()
        {
            super();
            blendMode = BlendMode.SCREEN;
            beginConsecrate();
            return;
        }

        private function beginConsecrate():void
        {
            var loc1:*;

            consecration = new DingBase() as Sprite;
            consecration.scaleY = loc1 = 0;
            consecration.scaleX = loc1;
            consecration.y = verticalCenter;
            Tweener.addTween(consecration, {"scaleX":1, "scaleY":1, "time":1, "transition":"easeOutElastic"});
            Tweener.addCaller(this, {"onUpdate":createSparkly, "time":1, "count":50, "transition":"easeInQuad"});
            return;
        }

        private function fadeSparklies(arg1:flash.display.Sprite):void
        {
            Tweener.addTween(arg1, {"time":1, "alpha":0});
            return;
        }

        private function jitterSparklies(arg1:flash.display.Sprite):void
        {
            var loc2:*;

            arg1.scaleY = loc2 = Math.random();
            arg1.scaleX = loc2;
            return;
        }

        private function createSparkly():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = this;
            loc2 = new YoVilleApp.Sparkle() as Sprite;
            loc2.y = verticalCenter;
            loc2.x = Math.random() * 60 - 30;
            loc2.scaleY = loc3 = Math.random();
            loc2.scaleX = loc3;
            this.addChild(loc2);
            Tweener.addTween(loc2, {"time":1 + Math.random(), "y":-60 * Math.random(), "transition":"easeOutCubic", "onUpdate":jitterSparklies, "onUpdateParams":[loc2], "onComplete":fadeSparklies, "onCompleteParams":[loc2]});
            return;
        }

        
        {
            DingBase = LevelActionTween_DingBase;
            Sparkle = LevelActionTween_Sparkle;
        }

        private static const verticalCenter:int=50;

        private var consecration:flash.display.Sprite;

        public static var Sparkle:Class;

        public static var DingBase:Class;
    }
}
