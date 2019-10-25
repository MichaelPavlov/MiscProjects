package MyLife.Assets.Avatar.AvatarActions 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    
    public class AnimationAction extends MyLife.Assets.Avatar.AvatarActions.AvatarAction
    {
        public function AnimationAction(arg1:String, arg2:flash.display.MovieClip, arg3:Object=null, arg4:Number=2, arg5:Boolean=false)
        {
            super(arg1, arg2, arg3, arg4, arg5);
            initializeActionData(arg1, arg3);
            return;
        }

        public function getDirection():Number
        {
            return direction;
        }

        protected function startAnimation():void
        {
            trace("startAnimation " + actionName);
            if (actionName == null)
            {
                return;
            }
            setAnimationClip();
            if (isNaN(startFrame) || startFrame < TOTAL_FRAMES)
            {
                startFrame = 1;
            }
            else 
            {
                if (startFrame == TOTAL_FRAMES || startFrame > currentAnimation.totalFrames)
                {
                    startFrame = currentAnimation.totalFrames;
                }
            }
            if (isNaN(endFrame) || endFrame == TOTAL_FRAMES || endFrame > currentAnimation.totalFrames)
            {
                endFrame = currentAnimation.totalFrames;
            }
            else 
            {
                if (endFrame < TOTAL_FRAMES)
                {
                    endFrame = 1;
                }
            }
            frameIncrement = (startFrame <= endFrame) ? 1 : -1;
            frame = startFrame;
            currentAnimation.gotoAndStop(startFrame);
            return;
        }

        public override function cleanUp():void
        {
            currentAnimation = null;
            super.cleanUp();
            return;
        }

        protected override function updateAction(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            if (frame != endFrame)
            {
                frame = frame + frameIncrement;
            }
            else 
            {
                frame = startFrame;
                currentLoop++;
                if (!(duration == LOOP) && currentLoop == duration)
                {
                    onActionComplete();
                    return;
                }
            }
            if (currentAnimation)
            {
                currentAnimation.gotoAndStop(frame);
            }
            return;
        }

        public override function start():void
        {
            startAnimation();
            currentLoop = 0;
            super.start();
            return;
        }

        public override function resume():void
        {
            super.resume();
            return;
        }

        public override function changeDirection(arg1:Number):void
        {
            direction = arg1;
            setAnimationClip();
            return;
        }

        protected function initializeActionData(arg1:String, arg2:Object=null):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = NaN;
            loc5 = null;
            startFrame = 1;
            endFrame = TOTAL_FRAMES;
            duration = 1;
            loc3 = arg1.split("_");
            if (loc3.length > 0 && arg2 == null)
            {
                if (loc3[(loc3.length - 1)] != "LOOP")
                {
                    if (arg1 == YOU_DA_BOMB || arg1 == MYSTIC_LEVITATION || arg1 == ROBOT_DANCE)
                    {
                        duration = 1;
                    }
                    else 
                    {
                        if (arg1 == ARM_SHUFFLE || arg1 == JUMP_AND_SWING || arg1 == POWER_JUMP)
                        {
                            duration = 2;
                        }
                        else 
                        {
                            duration = 7;
                        }
                    }
                }
                else 
                {
                    loc3.pop();
                    duration = LOOP;
                }
                if (isNaN(Number(arg1)))
                {
                    direction = 0;
                    actionName = "";
                    loc4 = 0;
                    while (loc4 < loc3.length) 
                    {
                        loc5 = loc3[loc4];
                        if (loc4 != 0)
                        {
                            loc5 = loc5.substring(0, 1) + loc5.substring(1, loc5.length).toLowerCase();
                        }
                        else 
                        {
                            loc5 = loc5.toLowerCase();
                        }
                        actionName = actionName + loc5;
                        loc4 = (loc4 + 1);
                    }
                }
                else 
                {
                    actionName = "stand";
                    direction = Number(arg1);
                    duration = 1;
                }
            }
            else 
            {
                direction = 0;
                if (arg2)
                {
                    startFrame = arg2.s;
                    endFrame = arg2.e;
                    duration = arg2.l;
                }
                actionName = arg1;
            }
            trace("new AnimationAction " + startFrame + " " + endFrame + " " + duration + " " + arg1 + " " + actionName);
            return;
        }

        private function initializeDefaultActionData(arg1:String):*
        {
            return;
        }

        protected final function setAnimationClip():void
        {
            var animationClassName:String;
            var isFront:Boolean;
            var loc1:*;
            var loc2:*;

            animationClassName = null;
            if (actionName == null)
            {
                return;
            }
            isFront = direction == MyLifeInstance.LEFT_FRONT || direction == MyLifeInstance.RIGHT_FRONT;
            if (actionName == actionId)
            {
                animationClassName = actionName;
            }
            else 
            {
                animationClassName = actionName + isFront ? "Front" : "Back";
            }
            try
            {
                currentAnimation = null;
                currentAnimation = ActionLibrary.getAnimationClipInstance(animationClassName);
                avatarClip.setAnimationClip(currentAnimation, direction);
            }
            catch (error:Error)
            {
                trace("AnimationAction.setAnimationClip " + undefined);
                return;
            }
            return;
        }

        public override function pause():void
        {
            super.pause();
            return;
        }

        public static function registerAction():void
        {
            ActionLibrary.registerActionClass(AnimationAction, "0");
            ActionLibrary.registerActionClass(AnimationAction, "1");
            ActionLibrary.registerActionClass(AnimationAction, "2");
            ActionLibrary.registerActionClass(AnimationAction, "3");
            ActionLibrary.registerActionClass(AnimationAction, ARM_SHUFFLE);
            ActionLibrary.registerActionClass(AnimationAction, JUMPING_JACKS);
            ActionLibrary.registerActionClass(AnimationAction, POWER_JUMP);
            ActionLibrary.registerActionClass(AnimationAction, ROBOT_DANCE);
            ActionLibrary.registerActionClass(AnimationAction, JUMP_AND_SWING);
            ActionLibrary.registerActionClass(AnimationAction, MYSTIC_LEVITATION);
            ActionLibrary.registerActionClass(AnimationAction, YOU_DA_BOMB);
            ActionLibrary.registerActionClass(AnimationAction, ARM_SHUFFLE_LOOP);
            ActionLibrary.registerActionClass(AnimationAction, JUMPING_JACKS_LOOP);
            ActionLibrary.registerActionClass(AnimationAction, ROBOT_DANCE_LOOP);
            ActionLibrary.registerActionClass(AnimationAction, JUMP_AND_SWING_LOOP);
            ActionLibrary.registerActionClass(AnimationAction, POWER_JUMP_LOOP);
            return;
        }

        
        {
            isRegistered = false;
        }

        public static const STAND_LEFT_FRONT:String="1";

        public static const JUMP_AND_SWING:String="JUMP_AND_SWING";

        public static const JUMPING_JACKS_LOOP:String="JUMPING_JACKS_LOOP";

        public static const POWER_JUMP:String="POWER_JUMP";

        public static const POWER_JUMP_LOOP:String="POWER_JUMP_LOOP";

        public static const MYSTIC_LEVITATION:String="MYSTIC_LEVITATION";

        public static const ARM_SHUFFLE:String="ARM_SHUFFLE";

        public static const STAND_LEFT_BACK:String="3";

        public static const ROBOT_DANCE:String="ROBOT_DANCE";

        public static const TOTAL_FRAMES:int=0;

        public static const LOOP:Number=-1;

        public static const ROBOT_DANCE_LOOP:String="ROBOT_DANCE_LOOP";

        public static const JUMPING_JACKS:String="JUMPING_JACKS";

        public static const YOU_DA_BOMB:String="YOU_DA_BOMB";

        public static const ARM_SHUFFLE_LOOP:String="ARM_SHUFFLE_LOOP";

        public static const STAND_RIGHT_BACK:String="2";

        public static const JUMP_AND_SWING_LOOP:String="JUMP_AND_SWING_LOOP";

        public static const STAND_RIGHT_FRONT:String="0";

        protected var frameIncrement:Number;

        protected var currentAnimation:flash.display.MovieClip;

        protected var endFrame:Number;

        protected var duration:Number;

        protected var actionName:String;

        protected var startFrame:Number;

        protected var frame:Number;

        protected var currentLoop:Number;

        protected var direction:Number;

        private static var isRegistered:Boolean=false;
    }
}
