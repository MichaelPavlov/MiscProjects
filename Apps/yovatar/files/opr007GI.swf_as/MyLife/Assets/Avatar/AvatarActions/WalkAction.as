package MyLife.Assets.Avatar.AvatarActions 
{
    import MyLife.*;
    import com.boostworthy.animation.easing.*;
    import com.boostworthy.animation.rendering.*;
    import com.boostworthy.animation.sequence.*;
    import com.boostworthy.animation.sequence.tweens.*;
    import com.boostworthy.events.*;
    import fai.*;
    import fl.motion.easing.*;
    import flash.display.*;
    
    public class WalkAction extends MyLife.Assets.Avatar.AvatarActions.AnimationAction
    {
        public function WalkAction(arg1:String, arg2:flash.display.MovieClip, arg3:Object, arg4:Number=2, arg5:Boolean=false)
        {
            super(arg1, arg2, arg3, arg4, arg5);
            walkPath = arg3.walkPath;
            if (!(walkPath[0] as Position))
            {
                convertObjectsToPositions();
            }
            walkSpeed = arg3.walkSpeed;
            prepareWalkTweens();
            isWalking = false;
            return;
        }

        public override function cleanUp():void
        {
            if (timeline != null)
            {
                timeline.stop();
                timeline = null;
            }
            super.cleanUp();
            return;
        }

        public override function changeDirection(arg1:Number):void
        {
            if (direction != arg1)
            {
                super.changeDirection(arg1);
            }
            return;
        }

        protected function onMovementFinish(arg1:com.boostworthy.events.AnimationEvent):void
        {
            isWalking = false;
            if (characterClip.hasOwnProperty("isPlayerCharacter") && characterClip.isPlayerCharacter())
            {
                MyLifeInstance.getInstance().server.callExtension("updateCharacterPath", {"speed":characterClip.characterSpeed, "path":[{"x":characterClip.x, "y":characterClip.y, "d":avatarClip.getDirection()}]});
            }
            onActionComplete();
            return;
        }

        public override function start():void
        {
            if (timeline != null)
            {
                timeline.play();
            }
            isWalking = true;
            if (this.avatarClip.parent != characterClip._renderClip)
            {
                trace("WalkAction moving avatar back into character");
                avatarClip.x = 0;
                avatarClip.y = 0;
                characterClip._renderClip.avatarClip = avatarClip;
                characterClip._renderClip.addChild(avatarClip);
            }
            super.start();
            return;
        }

        public function getWalkLength():Number
        {
            return walkLength;
        }

        protected override function initializeActionData(arg1:String, arg2:Object=null):void
        {
            duration = AnimationAction.LOOP;
            startFrame = 1;
            endFrame = AnimationAction.TOTAL_FRAMES;
            actionName = "walk";
            direction = Number(arg1);
            return;
        }

        public override function stop():void
        {
            super.stop();
            timeline.stop();
            isWalking = false;
            if (characterClip.hasOwnProperty("isPlayerCharacter") && characterClip.isPlayerCharacter())
            {
                MyLifeInstance.getInstance().server.callExtension("updateCharacterPath", {"speed":characterClip.characterSpeed, "path":[{"x":characterClip.x, "y":characterClip.y, "d":avatarClip.getDirection()}]});
            }
            return;
        }

        public function getDirectionFromDelta(arg1:fai.Position, arg2:fai.Position):Number
        {
            if (arg1.y > 0 && arg1.x > 0)
            {
                return MyLifeInstance.RIGHT_FRONT;
            }
            if (arg1.y > 0 && arg1.x < 0)
            {
                return MyLifeInstance.LEFT_FRONT;
            }
            if (arg1.y < 0 && arg1.x < 0)
            {
                return MyLifeInstance.LEFT_BACK;
            }
            if (arg1.y < 0 && arg1.x > 0)
            {
                return MyLifeInstance.RIGHT_BACK;
            }
            if (arg1.y == 0)
            {
                if (arg2.y < 0)
                {
                    if (arg1.x > 0)
                    {
                        return MyLifeInstance.RIGHT_BACK;
                    }
                    return MyLifeInstance.LEFT_BACK;
                }
                if (arg1.x > 0)
                {
                    return MyLifeInstance.RIGHT_FRONT;
                }
                return MyLifeInstance.LEFT_FRONT;
            }
            if (arg1.x == 0)
            {
                if (arg2.x < 0)
                {
                    if (arg1.y > 0)
                    {
                        return MyLifeInstance.LEFT_FRONT;
                    }
                    return MyLifeInstance.LEFT_BACK;
                }
                if (arg1.y > 0)
                {
                    return MyLifeInstance.RIGHT_FRONT;
                }
                return MyLifeInstance.RIGHT_BACK;
            }
            return MyLifeInstance.LEFT_FRONT;
        }

        private function convertObjectsToPositions():void
        {
            var loc1:*;
            var loc2:*;

            loc2 = null;
            loc1 = 0;
            while (loc1 < walkPath.length) 
            {
                loc2 = new Position(walkPath[loc1].x, walkPath[loc1].y);
                walkPath[loc1] = loc2;
                loc1 = (loc1 + 1);
            }
            return;
        }

        protected function onTimelineChange(arg1:com.boostworthy.events.AnimationEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (characterClip)
            {
                loc2 = MyLifeInstance.getInstance();
                if (characterClip.hasOwnProperty("isPlayerCharacter") && characterClip.isPlayerCharacter())
                {
                    loc2.getZone().getTriggerZoneHit(characterClip.getPosition(), characterClip);
                }
                loc2.getZone().onCharacterMoved(characterClip);
                loc2.getZone().resortDepths();
            }
            return;
        }

        public function prepareWalkTweens():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc4 = null;
            loc8 = null;
            loc9 = NaN;
            loc10 = NaN;
            loc1 = timeline == null;
            walkLength = 0;
            loc2 = 1;
            loc3 = 1;
            timeline = new Timeline(RenderMethod.ENTER_FRAME);
            loc5 = -1;
            loc6 = walkPath[(walkPath.length - 1)];
            loc4 = new Position(characterClip.x, characterClip.y);
            loc7 = 50 / walkSpeed;
            loc11 = 0;
            loc12 = walkPath;
            for each (loc8 in loc12)
            {
                if ((loc9 = loc8.deltaPosition(loc4).vectorLength()) > 0)
                {
                    walkLength = walkLength + loc9;
                    loc3 = loc9 * loc7;
                    timeline.addTween(new Tween(characterClip, "x", loc8.x, loc2, loc2 + loc3, Transitions.LINEAR));
                    timeline.addTween(new Tween(characterClip, "y", loc8.y, loc2, loc2 + loc3, Transitions.LINEAR));
                    loc10 = getDirectionFromDelta(loc8.deltaPosition(loc4), loc6.deltaPosition(loc8));
                    timeline.addTween(new Action(changeDirection, [loc10], new Function(), [], loc2));
                    loc2 = loc2 + loc3;
                }
                loc5 = loc10;
                loc4 = loc8;
            }
            timeline.addEventListener(AnimationEvent.FINISH, onMovementFinish);
            timeline.addEventListener(AnimationEvent.CHANGE, onTimelineChange);
            return;
        }

        public override function resume():void
        {
            super.resume();
            if (timeline != null)
            {
                isWalking = true;
                timeline.play();
            }
            return;
        }

        public override function pause():void
        {
            super.pause();
            if (timeline != null)
            {
                isWalking = false;
                timeline.stop();
            }
            return;
        }

        public static function registerAction():void
        {
            ActionLibrary.registerActionClass(WalkAction, "4");
            ActionLibrary.registerActionClass(WalkAction, "5");
            ActionLibrary.registerActionClass(WalkAction, "6");
            ActionLibrary.registerActionClass(WalkAction, "7");
            return;
        }

        
        {
            isRegistered = false;
        }

        public static const WALK_RIGHT_FRONT:String="4";

        public static const WALK_LEFT_FRONT:String="5";

        public static const WALK_RIGHT_BACK:String="6";

        public static const WALK_LEFT_BACK:String="7";

        private var timeline:com.boostworthy.animation.sequence.Timeline;

        private var walkSpeed:Number;

        private var walkPath:Array;

        private var isWalking:Boolean;

        private var walkLength:Number;

        private static var isRegistered:Boolean=false;
    }
}
