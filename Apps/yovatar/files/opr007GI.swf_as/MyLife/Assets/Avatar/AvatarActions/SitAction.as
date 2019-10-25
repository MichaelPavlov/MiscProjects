package MyLife.Assets.Avatar.AvatarActions 
{
    import flash.display.*;
    import flash.events.*;
    
    public class SitAction extends MyLife.Assets.Avatar.AvatarActions.AnimationAction
    {
        public function SitAction(arg1:String, arg2:flash.display.MovieClip, arg3:Object, arg4:Number=2, arg5:Boolean=false)
        {
            super(arg1, arg2, arg3, arg4, arg5);
            sitIndex = arg3.sitIndex;
            goalPositionX = arg3.x;
            goalPositionY = arg3.y;
            return;
        }

        public override function start():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            super.start();
            loc1 = Math.abs(this.endFrame - this.startFrame) + 1;
            if (loc1 <= 1)
            {
                positionIncrementX = 0;
                positionIncrementY = 0;
                this.avatarClip.x = goalPositionX;
                this.avatarClip.y = goalPositionY;
                return;
            }
            loc2 = this.avatarClip.x;
            loc3 = this.avatarClip.y;
            loc4 = goalPositionX - loc2;
            loc5 = goalPositionY - loc3;
            positionIncrementX = loc4 / loc1;
            positionIncrementY = loc5 / loc1;
            return;
        }

        protected override function initializeActionData(arg1:String, arg2:Object=null):void
        {
            var loc3:*;

            loc3 = Number(arg1);
            if (loc3 < 12)
            {
                startFrame = 1;
                endFrame = AnimationAction.TOTAL_FRAMES;
            }
            else 
            {
                if (loc3 < 16)
                {
                    startFrame = AnimationAction.TOTAL_FRAMES;
                    endFrame = AnimationAction.TOTAL_FRAMES;
                }
                else 
                {
                    if (loc3 < 20)
                    {
                        startFrame = AnimationAction.TOTAL_FRAMES;
                        endFrame = 1;
                    }
                }
            }
            direction = loc3 % 4;
            duration = 1;
            actionName = "sit";
            return;
        }

        protected override function updateAction(arg1:flash.events.Event):void
        {
            this.avatarClip.x = this.avatarClip.x + positionIncrementX;
            this.avatarClip.y = this.avatarClip.y + positionIncrementY;
            super.updateAction(arg1);
            return;
        }

        public static function registerAction():void
        {
            ActionLibrary.registerActionClass(SitAction, FORWARD_SIT_RIGHT_FRONT);
            ActionLibrary.registerActionClass(SitAction, FORWARD_SIT_LEFT_FRONT);
            ActionLibrary.registerActionClass(SitAction, FORWARD_SIT_RIGHT_BACK);
            ActionLibrary.registerActionClass(SitAction, FORWARD_SIT_LEFT_BACK);
            ActionLibrary.registerActionClass(SitAction, NONANIMATED_SIT_RIGHT_FRONT);
            ActionLibrary.registerActionClass(SitAction, NONANIMATED_SIT_LEFT_FRONT);
            ActionLibrary.registerActionClass(SitAction, NONANIMATED_SIT_RIGHT_BACK);
            ActionLibrary.registerActionClass(SitAction, NONANIMATED_SIT_LEFT_BACK);
            ActionLibrary.registerActionClass(SitAction, BACK_SIT_RIGHT_FRONT);
            ActionLibrary.registerActionClass(SitAction, BACK_SIT_LEFT_FRONT);
            ActionLibrary.registerActionClass(SitAction, BACK_SIT_RIGHT_BACK);
            ActionLibrary.registerActionClass(SitAction, BACK_SIT_LEFT_BACK);
            return;
        }

        public static const NONANIMATED_SIT_LEFT_FRONT:String="13";

        public static const BACK_SIT_RIGHT_BACK:String="18";

        public static const FORWARD_SIT_LEFT_BACK:String="11";

        public static const FORWARD_SIT_RIGHT_BACK:String="10";

        public static const BACK_SIT_LEFT_BACK:String="19";

        public static const BACK_SIT_LEFT_FRONT:String="17";

        public static const FORWARD_SIT_LEFT_FRONT:String="9";

        public static const NONANIMATED_SIT_RIGHT_FRONT:String="12";

        public static const FORWARD_SIT_RIGHT_FRONT:String="8";

        public static const BACK_SIT_RIGHT_FRONT:String="16";

        public static const NONANIMATED_SIT_LEFT_BACK:String="15";

        public static const NONANIMATED_SIT_RIGHT_BACK:String="14";

        private var positionIncrementX:Number;

        private var positionIncrementY:Number;

        private var sitIndex:Number;

        private var goalPositionX:Number;

        private var goalPositionY:Number;
    }
}
