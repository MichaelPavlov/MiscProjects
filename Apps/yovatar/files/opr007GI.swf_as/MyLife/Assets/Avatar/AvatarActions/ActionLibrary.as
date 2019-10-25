package MyLife.Assets.Avatar.AvatarActions 
{
    import flash.display.*;
    
    public class ActionLibrary extends Object
    {
        public function ActionLibrary()
        {
            super();
            return;
        }

        public static function unregisterAnimationClipClass(arg1:String):void
        {
            delete animationClipHash[arg1];
            return;
        }

        public static function getActionInstance(arg1:String, arg2:flash.display.MovieClip, arg3:Object=null, arg4:Number=2, arg5:Boolean=false):MyLife.Assets.Avatar.AvatarActions.AvatarAction
        {
            var action:MyLife.Assets.Avatar.AvatarActions.AvatarAction;
            var actionIdentifier:String;
            var actionParams:Object=null;
            var animationClass:Class;
            var avatar:flash.display.MovieClip;
            var interruptionType:Number=2;
            var isWaiting:Boolean=false;
            var loc6:*;
            var loc7:*;

            action = null;
            actionIdentifier = arg1;
            avatar = arg2;
            actionParams = arg3;
            interruptionType = arg4;
            isWaiting = arg5;
            animationClass = actionHash[actionIdentifier];
            try
            {
                action = new animationClass(actionIdentifier, avatar, actionParams, interruptionType, isWaiting) as AvatarAction;
            }
            catch (error:Error)
            {
                trace("ActionLibrary.getActionInstance  " + undefined);
                action = null;
            }
            return action;
        }

        public static function isActionLoaded(arg1:String):Boolean
        {
            var loc2:*;

            if (registeredDefaultClasses == false)
            {
                SitAction.registerAction();
                AnimationAction.registerAction();
                WalkAction.registerAction();
                registeredDefaultClasses = true;
            }
            loc2 = false;
            if (actionHash && arg1)
            {
                loc2 = !(actionHash[arg1] == null);
            }
            return loc2;
        }

        public static function unregisterActionClass(arg1:String):void
        {
            delete actionHash[arg1];
            return;
        }

        public static function registerAnimationClipClass(arg1:Class, arg2:String):void
        {
            if (animationClipHash == null)
            {
                animationClipHash = new Object();
            }
            animationClipHash[arg2] = arg1;
            return;
        }

        public static function makeAnimItem(arg1:Object):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc7 = null;
            if (arg1.hasOwnProperty("metaData"))
            {
                loc2 = arg1.metaData.split("|");
            }
            else 
            {
                if (arg1.hasOwnProperty("meta_data"))
                {
                    loc2 = arg1.meta_data.split("|");
                }
            }
            if (loc2)
            {
                loc4 = {"name":arg1.filename, "s":1, "e":0, "l":1};
                loc5 = {"params":loc4};
                loc3 = {"value":loc5, "used":0};
                loc6 = loc2.length;
                label424: while (loc6) 
                {
                    loc6 = (loc6 - 1);
                    loc7 = loc2[loc6].split(":");
                    loc8 = loc7[0];
                    switch (loc8) 
                    {
                        case "energy":
                            loc5.e = Number(loc7[1]);
                            continue label424;
                        case "action":
                            loc3.name = loc7[1];
                            loc5.a = loc7[1];
                            continue label424;
                        case "startFrame":
                            loc4.s = Number(loc7[1]);
                            continue label424;
                        case "endFrame":
                            loc4.e = Number(loc7[1]);
                            continue label424;
                        case "loop":
                            loc4.l = Number(loc7[1]);
                            continue label424;
                    }
                }
                loc3.text = arg1.name;
                loc3.meta = loc5.e + " energy";
            }
            return loc3;
        }

        public static function getAnimationClipInstance(arg1:String):flash.display.MovieClip
        {
            var animationClass:Class;
            var animationClip:flash.display.MovieClip;
            var animationClipClassName:String;
            var loc2:*;
            var loc3:*;

            animationClip = null;
            animationClipClassName = arg1;
            animationClass = animationClipHash[animationClipClassName];
            try
            {
                animationClip = new animationClass() as MovieClip;
            }
            catch (error:Error)
            {
                animationClip = null;
                trace("ActionLibrary.getAnimationClipInstance  ERROR " + undefined);
            }
            return animationClip;
        }

        public static function getAnimClassName(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc4 = NaN;
            loc5 = null;
            loc3 = "";
            if (arg1)
            {
                loc2 = arg1.split("_");
                loc4 = 0;
                while (loc4 < loc2.length) 
                {
                    loc5 = loc2[loc4];
                    if (loc4 != 0)
                    {
                        loc5 = loc5.substring(0, 1) + loc5.substring(1, loc5.length).toLowerCase();
                    }
                    else 
                    {
                        loc5 = loc5.toLowerCase();
                    }
                    loc3 = loc3 + loc5;
                    loc4 = (loc4 + 1);
                }
            }
            return loc3;
        }

        public static function registerActionClass(arg1:Class, arg2:String):void
        {
            if (actionHash == null)
            {
                actionHash = new Object();
            }
            actionHash[arg2] = arg1;
            return;
        }

        
        {
            registeredDefaultClasses = false;
        }

        private static var animationClipHash:Object;

        private static var actionHash:Object;

        private static var registeredDefaultClasses:Boolean=false;
    }
}
