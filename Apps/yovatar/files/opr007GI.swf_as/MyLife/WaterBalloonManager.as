package MyLife 
{
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    
    public class WaterBalloonManager extends flash.events.EventDispatcher
    {
        public function WaterBalloonManager()
        {
            BalloonExplosion = WaterBalloonManager_BalloonExplosion;
            super();
            return;
        }

        public function startBalloonDrag():*
        {
            MyLifeInstance.getInstance().getInterface().interfaceHUD.btnShowThrowBalloon.mouseEnabled = false;
            MyLifeInstance.getInstance().getInterface().interfaceHUD.btnShowThrowBalloon.enabled = false;
            dragBalloonIcon = MyLifeInstance.getInstance().getInterface().interfaceHUD.throwBalloonButtonIcon;
            if (!dragBalloonIcon.orgX)
            {
                dragBalloonIcon.orgX = dragBalloonIcon.x;
            }
            if (!dragBalloonIcon.orgY)
            {
                dragBalloonIcon.orgY = dragBalloonIcon.y;
            }
            dragBalloonIcon.alpha = 0.75;
            MyLifeInstance.getInstance().addEventListener(MouseEvent.MOUSE_MOVE, throwBalloonMouseMove);
            MyLifeInstance.getInstance().addEventListener(MouseEvent.MOUSE_UP, btnShowThrowBalloonMouseUp);
            return;
        }

        internal function removeMouseEventHandlers():*
        {
            MyLifeInstance.getInstance().getInterface().interfaceHUD.btnShowThrowBalloon.mouseEnabled = true;
            MyLifeInstance.getInstance().getInterface().interfaceHUD.btnShowThrowBalloon.enabled = true;
            MyLifeInstance.getInstance().removeEventListener(MouseEvent.MOUSE_MOVE, throwBalloonMouseMove);
            MyLifeInstance.getInstance().removeEventListener(MouseEvent.MOUSE_UP, btnShowThrowBalloonMouseUp);
            return;
        }

        private function explosionCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var mp:MyLife.MovieClipPlayer;
            var pEvent:flash.events.Event;

            pEvent = arg1;
            mp = pEvent.currentTarget as MovieClipPlayer;
            mp.removeEventListener(Event.COMPLETE, explosionCompleteHandler);
            try
            {
                MyLifeInstance.getInstance().getZone().removeChild(mp.movieClip);
            }
            catch (e:*)
            {
            };
            mp.clearClip();
            return;
        }

        public function handleThrowEvent(arg1:*, arg2:*):*
        {
            var loc3:*;

            loc3 = JSON.decode(arg2);
            throwNewBalloon(arg1, loc3.x, loc3.y);
            return;
        }

        private function throwBalloonMouseMove(arg1:flash.events.MouseEvent):*
        {
            if (!arg1.buttonDown)
            {
                removeMouseEventHandlers();
                return;
            }
            dragBalloonIcon.x = arg1.stageX;
            dragBalloonIcon.y = arg1.stageY;
            arg1.updateAfterEvent();
            return;
        }

        public function throwNewBalloon(arg1:*, arg2:*, arg3:*):*
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;

            if (!(loc4 = MyLifeInstance.getInstance().getZone().getCharacter(arg1)))
            {
                return;
            }
            loc5 = false;
            if (loc6 = loc4 == MyLifeInstance.getInstance().getPlayer().getCharacter())
            {
                if (this.isPlayerThrowing)
                {
                    return;
                }
                this.isPlayerThrowing = true;
                loc5 = true;
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_WATERBALLOON_START));
            }
            loc7 = loc4.x;
            loc8 = loc4.y - 15;
            loc9 = arg2;
            loc10 = arg3 - 60;
            (loc11 = new BalloonExplosion()).gotoAndStop(1);
            loc11.x = loc7;
            loc11.y = loc8;
            MyLifeInstance.getInstance().getZone().addChild(loc11);
            loc13 = (loc12 = Math.sqrt(Math.pow(loc9 - loc7, 2) + Math.pow(loc10 - loc8, 2))) / 300;
            TweenLite.to(loc11, loc13, {"x":loc9, "rotation":loc12 * 3, "ease":Linear.easeOut, "onComplete":explodeBalloon, "onCompleteParams":[loc11, loc5]});
            loc15 = (loc14 = Math.min(loc8, loc10)) - loc12 / 3;
            TweenLite.to(loc11, loc13 / 2, {"y":loc15, "ease":Circular.easeOut, "overwrite":false});
            TweenLite.to(loc11, loc13 / 2, {"y":loc10, "ease":Circular.easeIn, "delay":loc13 / 2, "overwrite":false});
            MyLifeSoundController.getInstance().playLibrarySound("throwSound");
            return;
        }

        protected function ballonRefillComplete(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as MovieClipPlayer;
            loc2.removeEventListener(Event.COMPLETE, ballonRefillComplete);
            loc2.movieClip.gotoAndStop(1);
            loc2.clearClip();
            return;
        }

        internal function explodeBalloon(arg1:flash.display.MovieClip, arg2:Boolean=false):*
        {
            var loc3:*;
            var loc4:*;

            loc3 = new MovieClipPlayer(arg1);
            arg1.rotation = 0;
            arg1.scaleY = loc4 = 0.5;
            arg1.scaleX = loc4;
            loc3.play();
            loc3.addEventListener(Event.COMPLETE, explosionCompleteHandler);
            MyLifeSoundController.getInstance().playLibrarySound("splashSound");
            if (arg2)
            {
                this.isPlayerThrowing = false;
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_WATERBALLOON_COMPLETE));
            }
            this.dispatchEvent(new Event(Event.COMPLETE));
            return;
        }

        private function btnShowThrowBalloonMouseUp(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            removeMouseEventHandlers();
            loc2 = dragBalloonIcon.x;
            loc3 = dragBalloonIcon.y;
            loc4 = Math.sqrt(Math.pow(dragBalloonIcon.x - dragBalloonIcon.orgX, 2) + Math.pow(dragBalloonIcon.y - dragBalloonIcon.orgY, 2));
            dragBalloonIcon.alpha = 1;
            dragBalloonIcon.x = dragBalloonIcon.orgX;
            dragBalloonIcon.y = dragBalloonIcon.orgY;
            if (loc4 < 35)
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Water Balloon", "message":"To throw a water balloon, click and drag it to where you want to throw it."});
                return;
            }
            loc5 = MyLifeInstance.getInstance().getServer().getUserId();
            loc6 = {"x":loc2, "y":loc3};
            loc7 = JSON.encode(loc6);
            MyLifeInstance.getInstance().getServer().sendPublicMessage("T:" + loc7, 0);
            loc8 = new MovieClipPlayer(dragBalloonIcon);
            dragBalloonIcon.gotoAndStop(3);
            loc8.play();
            loc8.addEventListener(Event.COMPLETE, ballonRefillComplete);
            return;
        }

        private var BalloonExplosion:Class;

        public var isPlayerThrowing:Boolean;

        private var dragBalloonIcon:flash.display.MovieClip;
    }
}
