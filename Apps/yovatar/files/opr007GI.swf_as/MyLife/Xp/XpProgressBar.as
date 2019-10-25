package MyLife.Xp 
{
    import MyLife.UI.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class XpProgressBar extends flash.display.MovieClip implements MyLife.UI.ProgressBarInterface
    {
        public function XpProgressBar()
        {
            super();
            levelNumber = levelBackground.levelNumber;
            xpFillMask = xpFill.xpFillMask;
            levelNumber.selectable = false;
            levelNumber.mouseEnabled = false;
            xpText.selectable = false;
            xpText.mouseEnabled = false;
            this.xpValue = 0;
            this.level = 0;
            this.lowerThreshold = 0;
            this.upperThreshold = 0;
            xpTextTarget = xpValue;
            setXpText(xpValue);
            setLevelDisplay(level);
            if (level != MAX_LEVEL)
            {
                setBar(xpValue, DEFAULT_EMPTY_BAR);
            }
            else 
            {
                setBar(xpValue, DEFAULT_FULL_BAR);
            }
            return;
        }

        public function getLevelVisibility():Boolean
        {
            return levelNumber.visible;
        }

        private function animateXpText(arg1:int):int
        {
            if (!inBounds(arg1))
            {
                throw new Error("Invalid XP value for progress bar.  If XP is above the threshold, then a new level should be awarded and threshold should be raised.");
            }
            if (incrementTimer)
            {
                queuedTextTarget = arg1;
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, queuedAnimationHandler);
                addEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, queuedAnimationHandler);
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, animationCompleteHandler);
            }
            else 
            {
                xpTextTarget = arg1;
                startTextAnimation();
            }
            return 0;
        }

        private function incrementXpText(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1 && xpTextValue < xpTextTarget)
            {
                if (xpTextValue + textIncrement <= xpTextTarget)
                {
                    setXpText(xpTextValue + textIncrement);
                }
                else 
                {
                    setXpText(xpTextTarget);
                }
            }
            else 
            {
                if (arg1 && xpTextValue > xpTextTarget)
                {
                    if (xpTextValue - textIncrement >= xpTextTarget)
                    {
                        setXpText(xpTextValue - textIncrement);
                    }
                    else 
                    {
                        setXpText(xpTextTarget);
                    }
                }
                else 
                {
                    if (incrementTimer)
                    {
                        incrementTimer.stop();
                        incrementTimer.removeEventListener(TimerEvent.TIMER, incrementXpText);
                        incrementTimer = null;
                    }
                    loc2 = {};
                    loc2.xpTextValue = xpTextValue;
                    dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, loc2));
                }
            }
            return;
        }

        private function startTextAnimation():void
        {
            var loc1:*;

            loc1 = xpTextTarget - xpTextValue;
            if (loc1 == 0)
            {
                addEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, animationCompleteHandler);
                incrementXpText(null);
            }
            else 
            {
                animationInProgress = true;
                if (totalTweenDuration < MAX_TOTAL_TWEEN)
                {
                    textIncrement = 1;
                }
                else 
                {
                    textIncrement = loc1 / (MAX_TOTAL_TWEEN * 1000 / TWEEN_DURATION);
                }
                incrementTimer = new Timer(TWEEN_DURATION - OVERHEAD_FUDGE_FACTOR);
                incrementTimer.addEventListener(TimerEvent.TIMER, incrementXpText);
                addEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, animationCompleteHandler);
                incrementTimer.start();
            }
            return;
        }

        public function getDisplayPercent():int
        {
            return xpFillMask.width / xpFill.width;
        }

        public function init(arg1:int, arg2:int=0, arg3:int=0, arg4:int=0):void
        {
            this.xpValue = arg3;
            this.level = arg4;
            this.lowerThreshold = arg2;
            this.upperThreshold = arg1;
            xpTextTarget = xpValue;
            setXpText(xpValue);
            if (level != MAX_LEVEL)
            {
                setBar(xpValue, DEFAULT_EMPTY_BAR);
            }
            else 
            {
                setBar(xpValue, DEFAULT_FULL_BAR);
            }
            setLevelDisplay(level);
            return;
        }

        public function getProgress():int
        {
            return xpTextValue;
        }

        private function fullBarHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;

            loc2 = 0;
            if (arg1.data.hasOwnProperty("xpTextValue"))
            {
                loc2 = arg1.data.xpTextValue;
            }
            if (loc2 >= upperThreshold)
            {
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_ANIMATION_COMPLETE, fullBarHandler);
                progressBarFull(loc2);
            }
            return;
        }

        public function showLevel(arg1:int):void
        {
            setLevelDisplay(arg1);
            return;
        }

        private function animationCompleteHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            if (arg1.type == XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE)
            {
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE, animationCompleteHandler);
                receivedBarComplete = true;
            }
            if (arg1.type == XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE)
            {
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, animationCompleteHandler);
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, queuedAnimationHandler);
                receivedTextComplete = true;
                animCompleteParams = arg1.data;
            }
            if (receivedBarComplete && receivedTextComplete)
            {
                removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE, animationCompleteHandler);
                animationInProgress = false;
                receivedBarComplete = false;
                receivedTextComplete = false;
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PROGRESS_BAR_ANIMATION_COMPLETE, animCompleteParams));
                animCompleteParams = null;
            }
            return;
        }

        public function moveTo(arg1:int):int
        {
            var loc2:*;

            loc2 = 0;
            if (inBounds(arg1))
            {
                loc2 = arg1;
                moveWithinLevel(arg1, 0);
            }
            else 
            {
                if (arg1 > upperThreshold)
                {
                    if (inBounds(xpValue) && !(xpValue == upperThreshold) || xpValue == 0)
                    {
                        loc2 = upperThreshold;
                        moveWithinLevel(upperThreshold);
                    }
                }
                else 
                {
                    throw new Error("Level can only increase.");
                }
            }
            if (arg1 >= upperThreshold)
            {
                if (xpValue < upperThreshold || xpValue == 0)
                {
                    removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_ANIMATION_COMPLETE, fullBarHandler);
                    addEventListener(XpManagerEvent.XP_PROGRESS_BAR_ANIMATION_COMPLETE, fullBarHandler);
                }
            }
            xpValue = arg1;
            return loc2;
        }

        private function setLevelDisplay(arg1:int):void
        {
            this.level = arg1;
            levelNumber.text = arg1.toString();
            return;
        }

        private function queuedAnimationHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE, queuedAnimationHandler);
            xpTextTarget = queuedTextTarget;
            queuedTextTarget = 0;
            startTextAnimation();
            return;
        }

        private function inBounds(arg1:int):Boolean
        {
            return arg1 >= lowerThreshold && arg1 <= upperThreshold;
        }

        private function setXpText(arg1:int):int
        {
            if (!inBounds(arg1))
            {
                throw new Error("Invalid XP value for progress bar.  If XP is above the threshold, then a new level should be awarded and threshold should be raised.");
            }
            xpTextValue = arg1;
            xpText.text = arg1 + "/" + upperThreshold;
            return arg1;
        }

        private function moveWithinLevel(arg1:int, arg2:Number=1, arg3:Boolean=true):void
        {
            totalTweenDuration = Math.min(TWEEN_DURATION / 1000 * Math.abs(arg1 - xpTextTarget), MAX_TOTAL_TWEEN);
            totalTweenDuration = Math.max(totalTweenDuration, MIN_TOTAL_TWEEN);
            if (fullBarFlag)
            {
                fullBarFlag = false;
            }
            if (arg3)
            {
                animateXpText(arg1);
                animateBar(arg1, arg2);
            }
            else 
            {
                setXpText(arg1);
                setBar(arg1, arg2);
            }
            return;
        }

        public function setLevel(arg1:int, arg2:int, arg3:int, arg4:int):int
        {
            this.lowerThreshold = arg3;
            this.upperThreshold = arg4;
            this.xpValue = arg3;
            setBar(xpValue);
            setXpText(xpValue);
            setLevelDisplay(arg2);
            dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PROGRESS_BAR_SET_LEVEL_COMPLETE));
            return arg2;
        }

        public function getValue():int
        {
            return xpValue;
        }

        private function setBar(arg1:int, arg2:Number=1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = NaN;
            loc3 = xpFill.width;
            if (upperThreshold - lowerThreshold != 0)
            {
                loc4 = (arg1 - lowerThreshold) / (upperThreshold - lowerThreshold);
            }
            else 
            {
                loc4 = arg2;
            }
            loc5 = loc3 * loc4;
            xpFillMask.width = loc5;
            return;
        }

        public function getLevel():int
        {
            return level;
        }

        private function progressBarFull(arg1:int):void
        {
            var loc2:*;

            loc2 = {};
            loc2.xpTextValue = arg1;
            loc2.xpValue = xpValue;
            loc2.level = level;
            loc2.upperThreshold = upperThreshold;
            fullBarFlag = true;
            dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PROGRESS_BAR_FULL, loc2));
            return;
        }

        public function isFull():Boolean
        {
            return fullBarFlag;
        }

        private function finishBarAnimation():void
        {
            if (tweenQueueValue >= 0)
            {
                runDelayedAnimation();
            }
            else 
            {
                barAnimating = false;
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE));
            }
            return;
        }

        public function setLevelVisibility(arg1:Boolean):void
        {
            levelNumber.visible = arg1;
            return;
        }

        private function animateBar(arg1:int, arg2:Number=1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = NaN;
            loc3 = xpFill.width;
            if (upperThreshold - lowerThreshold == 0)
            {
                loc4 = arg2;
            }
            else 
            {
                loc4 = (arg1 - lowerThreshold) / (upperThreshold - lowerThreshold);
            }
            loc5 = loc3 * loc4;
            if (barAnimating)
            {
                tweenQueueValue = loc5;
            }
            else 
            {
                if (totalTweenDuration > 0)
                {
                    barAnimating = true;
                    tweenQueueValue = -1;
                    animationInProgress = true;
                    removeEventListener(XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE, animationCompleteHandler);
                    addEventListener(XpManagerEvent.XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE, animationCompleteHandler);
                    TweenLite.to(xpFillMask, totalTweenDuration, {"width":loc5, "onComplete":finishBarAnimation});
                }
                else 
                {
                    finishBarAnimation();
                }
            }
            return;
        }

        private function runDelayedAnimation():void
        {
            TweenLite.to(xpFillMask, totalTweenDuration, {"width":tweenQueueValue, "onComplete":finishBarAnimation});
            tweenQueueValue = -1;
            return;
        }

        private static const DEFAULT_FULL_BAR:Number=1;

        private static const MIN_TOTAL_TWEEN:Number=1;

        private static const OVERHEAD_FUDGE_FACTOR:Number=9;

        private static const TWEEN_DURATION:Number=25;

        private static const DEFAULT_EMPTY_BAR:Number=0;

        private static const MAX_TOTAL_TWEEN:Number=2;

        private static const MAX_LEVEL:int=50;

        private var level:int;

        private var receivedTextComplete:Boolean;

        private var animCompleteParams:Object;

        private var barAnimating:Boolean;

        private var fullBarFlag:Boolean;

        public var xpFill:flash.display.MovieClip;

        private var incrementTimer:flash.utils.Timer;

        public var xpFillMask:flash.display.Sprite;

        private var tweenQueueValue:int;

        private var animationInProgress:Boolean;

        private var totalTweenDuration:Number;

        private var xpTextTarget:int;

        private var textIncrement:int;

        private var xpTextValue:int;

        public var xpText:flash.text.TextField;

        private var receivedBarComplete:Boolean;

        public var levelBackground:flash.display.MovieClip;

        private var xpValue:int;

        private var upperThreshold:int;

        private var lowerThreshold:int;

        public var levelNumber:flash.text.TextField;

        private var queuedTextTarget:int;
    }
}
