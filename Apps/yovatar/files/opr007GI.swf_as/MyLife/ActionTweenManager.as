package MyLife 
{
    import MyLife.Events.*;
    import MyLife.NPC.*;
    import MyLife.SFX.*;
    import com.adobe.serialization.json.*;
    import fai.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class ActionTweenManager extends flash.events.EventDispatcher
    {
        public function ActionTweenManager()
        {
            super();
            this.init();
            return;
        }

        private function init():void
        {
            ActionTweenManager._instance = this;
            myLifeInstance = MyLifeInstance.getInstance();
            actionTweens = [];
            myLifeInstance.getServer().addEventListener(MyLifeEvent.ACTION_TWEEN_EVENT_RECEIVED, actionTweenEventReceivedHandler);
            return;
        }

        private function particleSytemCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.target as MovieClipPlayer;
            loc3 = loc2.movieClip;
            if (loc3.parent)
            {
                loc3.parent.removeChild(loc3);
            }
            return;
        }

        public function broadcastActionTween(arg1:String, arg2:*, arg3:*, arg4:*=null):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = MyLifeInstance.getInstance().getServer().getUserId();
            (loc6 = {}).type = arg1;
            loc6.src = arg2;
            loc6.dst = arg3;
            loc6.params = arg4 || {};
            loc7 = JSON.encode(loc6);
            loc8 = SERVER_EVENT_PREFIX + loc7;
            MyLifeInstance.getInstance().getServer().sendPublicMessage(loc8);
            return;
        }

        private function addChildToActionTweenRenderClip(arg1:flash.display.DisplayObject):void
        {
            myLifeInstance.zone.actionTweenRenderClip.addChild(arg1);
            return;
        }

        private function tweenUpdateHandler(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (arg1.ParticleSystemClass)
            {
                loc2 = arg1.ParticleSystemClass as Class;
                loc3 = new loc2();
                loc3.x = arg1.icon.x;
                loc3.y = arg1.icon.y;
                addChildToActionTweenRenderClip(loc3);
                (loc4 = new MovieClipPlayer(loc3)).addEventListener(Event.COMPLETE, particleSytemCompleteHandler, false, 0, true);
                loc4.play();
            }
            if (arg1.delay)
            {
                arg1.icon.visible = true;
                if (arg1.movieClipPlayer)
                {
                    arg1.movieClipPlayer.play();
                }
                arg1.delay = 0;
            }
            return;
        }

        public function makeActionTween(arg1:String, arg2:*, arg3:*, arg4:*=null, arg5:Number=0):void
        {
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
            var loc16:*;
            var loc17:*;
            var loc18:*;

            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = NaN;
            loc13 = NaN;
            loc14 = null;
            loc15 = null;
            loc16 = null;
            loc17 = null;
            loc6 = getPosition(arg2);
            loc7 = getPosition(arg3);
            loc8 = Boolean(loc6 && loc6);
            arg1 = arg1 || ActionTweenType.COIN;
            if (loc8)
            {
                loc18 = arg1;
                switch (loc18) 
                {
                    case ActionTweenType.XP:
                        loc9 = ActionTweenXpIcon;
                        loc10 = null;
                        loc11 = null;
                        loc12 = SECONDS_MOVE_XP;
                        loc13 = SECONDS_FADE_OUT_XP;
                        arg4 = arg4 || {};
                        break;
                    case ActionTweenType.LEVEL:
                        loc9 = ActionTweenLevelIcon;
                        loc10 = null;
                        loc11 = LevelSound;
                        loc12 = SECONDS_LEVEL;
                        loc13 = SECONDS_FADE_OUT_XP;
                        arg4 = arg4 || {};
                        break;
                    case ActionTweenType.GIFT:
                        loc9 = ActionTweenGiftIcon;
                        loc10 = ActionTweenStarParticleSystem;
                        loc11 = GiftSound;
                        loc12 = SECONDS_MOVE_DEFAULT;
                        loc13 = SECONDS_FADE_OUT_DEFAULT;
                        break;
                    case ActionTweenType.KISS:
                        loc9 = ActionTweenHeartIcon;
                        loc10 = ActionTweenStarParticleSystem;
                        loc11 = KissSound;
                        loc12 = SECONDS_MOVE_DEFAULT;
                        loc13 = SECONDS_FADE_OUT_DEFAULT;
                        break;
                    case ActionTweenType.MESSAGE:
                        loc9 = ActionTweenMessageIcon;
                        loc10 = ActionTweenStarParticleSystem;
                        loc11 = MessageSound;
                        loc12 = SECONDS_MOVE_MESSAGE;
                        loc13 = SECONDS_FADE_OUT_MESSAGE;
                        break;
                    case ActionTweenType.EAT:
                        loc9 = ActionTweenEatIcon;
                        loc10 = null;
                        loc11 = EatSound;
                        loc12 = SECONDS_MOVE_EAT;
                        loc13 = SECONDS_FADE_OUT_EAT;
                        break;
                    case ActionTweenType.COIN:
                    default:
                        loc9 = ActionTweenCoinIcon;
                        loc10 = null;
                        loc11 = CoinSound;
                        loc12 = SECONDS_MOVE_COIN;
                        loc13 = SECONDS_FADE_OUT_COIN;
                        arg4 = arg4 || {};
                        break;
                }
                (loc14 = new loc9() as MovieClip).x = loc6.x;
                loc14.y = loc6.y;
                if (arg4)
                {
                    loc18 = arg1;
                    switch (loc18) 
                    {
                        case ActionTweenType.COIN:
                            loc14["coinSplashAnim"]["coinTextFieldContainer"]["coinTextField"]["text"] = arg4.coins ? "+" + arg4.coins : "";
                            break;
                        case ActionTweenType.XP:
                            loc17 = loc14["xpScrollingText"]["xpTextField"];
                            loc17.defaultTextFormat = loc17.getTextFormat();
                            loc17.text = arg4.xp ? "+" + arg4.xp + " YP" : "";
                            break;
                        case ActionTweenType.LEVEL:
                            break;
                    }
                }
                if (loc14.totalFrames > 1)
                {
                    loc15 = new MovieClipPlayer(loc14);
                    if (!arg5)
                    {
                        loc15.play();
                    }
                }
                if (arg5)
                {
                    loc14.visible = false;
                }
                (loc16 = {}).type = arg1;
                loc16.src = arg2;
                loc16.dst = arg3;
                loc16.icon = loc14;
                loc16.secondsMove = loc12;
                loc16.secondsFadeOut = loc13;
                loc16.ParticleSystemClass = loc10;
                loc16.isTranslateComplete = false;
                loc16.movieClipPlayer = loc15;
                loc16.delay = arg5;
                if (loc16.icon && loc7 && loc7.x && loc7.y)
                {
                    addChildToActionTweenRenderClip(loc14);
                    TweenLite.to(loc14, loc12, {"x":loc7.x, "y":loc7.y, "delay":arg5, "ease":Linear.easeOut, "onUpdate":tweenUpdateHandler, "onUpdateParams":[loc16], "onComplete":tweenCompleteHandler, "onCompleteParams":[loc16]});
                    if (loc11)
                    {
                        MyLifeSoundController.getInstance().playClassSound(loc11);
                    }
                }
            }
            return;
        }

        private function actionTweenEventReceivedHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = arg1.eventData;
            loc3 = loc2.type;
            loc4 = loc2.src;
            loc5 = loc2.dst;
            loc6 = loc2.params;
            makeActionTween(loc3, loc4, loc5, loc6);
            return;
        }

        private function tweenCompleteHandler(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = arg1.icon;
            if (arg1.isTranslateComplete)
            {
                if (loc2.parent)
                {
                    loc2.parent.removeChild(loc2);
                }
                loc3 = new ActionTweenEvent(ActionTweenEvent.COMPLETE, arg1);
                dispatchEvent(loc3);
            }
            else 
            {
                arg1.isTranslateComplete = true;
                TweenLite.to(loc2, arg1.secondsFadeOut, {"alpha":0, "onComplete":tweenCompleteHandler, "onCompleteParams":[arg1]});
            }
            return;
        }

        private function getPosition(arg1:Object):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (arg1.hasOwnProperty("x"))
            {
                loc2 = {"x":arg1.x, "y":arg1.y};
            }
            else 
            {
                loc3 = myLifeInstance.zone.getCharacter(arg1);
                if (loc3)
                {
                    loc4 = loc3.getPosition();
                    loc4.y = loc4.y + AVATAR_OFFSET_Y;
                    loc2 = {"x":loc4.x, "y":loc4.y};
                }
            }
            return loc2;
        }

        public static function get instance():MyLife.ActionTweenManager
        {
            if (!_instance)
            {
                _instance = new ActionTweenManager();
            }
            return _instance;
        }

        
        {
            ActionTweenGiftIcon = ActionTweenManager_ActionTweenGiftIcon;
            ActionTweenHeartIcon = ActionTweenManager_ActionTweenHeartIcon;
            ActionTweenMessageIcon = ActionTweenManager_ActionTweenMessageIcon;
            ActionTweenCoinIcon = ActionTweenManager_ActionTweenCoinIcon;
            ActionTweenXpIcon = ActionTweenManager_ActionTweenXpIcon;
            ActionTweenLevelIcon = LevelActionTween;
            ActionTweenEatIcon = ActionTweenManager_ActionTweenEatIcon;
            ActionTweenStarParticleSystem = ActionTweenManager_ActionTweenStarParticleSystem;
            CoinSound = ActionTweenManager_CoinSound;
            GiftSound = ActionTweenManager_GiftSound;
            KissSound = ActionTweenManager_KissSound;
            MessageSound = ActionTweenManager_MessageSound;
            EatSound = ActionTweenManager_EatSound;
            SplashSound = ActionTweenManager_SplashSound;
            TeleportSound = ActionTweenManager_TeleportSound;
            ThrowSound = ActionTweenManager_ThrowSound;
            LevelSound = ActionTweenManager_LevelSound;
        }

        private static const SECONDS_FADE_OUT_COIN:Number=0.25;

        private static const SECONDS_MOVE_DEFAULT:Number=0.66;

        private static const SECONDS_LEVEL:Number=1;

        private static const SECONDS_MOVE_EAT:Number=2.25;

        private static const SECONDS_FADE_OUT_DEFAULT:Number=0.25;

        private static const SECONDS_FADE_OUT_EAT:Number=0.25;

        private static const SECONDS_MOVE_XP:Number=2.25;

        private static const AVATAR_OFFSET_Y:int=-50;

        private static const SECONDS_MOVE_MESSAGE:Number=0.66;

        private static const SECONDS_MOVE_COIN:Number=2.25;

        private static const SECONDS_FADE_OUT_XP:Number=0.25;

        public static const SERVER_EVENT_PREFIX:String="ACTIONTWEEN:";

        private static const SECONDS_FADE_OUT_MESSAGE:Number=0.25;

        private static var TeleportSound:Class;

        private static var LevelSound:Class;

        private static var ActionTweenGiftIcon:Class;

        private static var GiftSound:Class;

        private static var ActionTweenXpIcon:Class;

        private static var ActionTweenHeartIcon:Class;

        private static var ActionTweenMessageIcon:Class;

        private static var EatSound:Class;

        private static var SplashSound:Class;

        private static var actionTweens:Array;

        private static var KissSound:Class;

        private static var ActionTweenStarParticleSystem:Class;

        private static var CoinSound:Class;

        private static var ThrowSound:Class;

        private static var ActionTweenLevelIcon:Class;

        private static var _instance:MyLife.ActionTweenManager;

        private static var MessageSound:Class;

        private static var ActionTweenEatIcon:Class;

        private static var myLifeInstance:flash.display.MovieClip;

        private static var ActionTweenCoinIcon:Class;
    }
}
