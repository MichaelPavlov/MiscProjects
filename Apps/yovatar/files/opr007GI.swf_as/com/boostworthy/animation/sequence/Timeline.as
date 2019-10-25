package com.boostworthy.animation.sequence 
{
    import com.boostworthy.animation.*;
    import com.boostworthy.animation.rendering.*;
    import com.boostworthy.animation.sequence.tweens.*;
    import com.boostworthy.collections.iterators.*;
    import com.boostworthy.core.*;
    import com.boostworthy.events.*;
    import flash.events.*;
    
    public class Timeline extends flash.events.EventDispatcher implements com.boostworthy.core.IDisposable
    {
        public function Timeline(arg1:uint=2, arg2:Number=60)
        {
            super();
            init(arg1, arg2);
            return;
        }

        protected function computeFrameData(arg1:uint, arg2:uint):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = null;
            loc3 = m_objTweenStack.getIterator(IteratorType.ARRAY_REVERSE);
            loc4 = arg1;
            while (loc4 <= arg2) 
            {
                while (loc3.hasNext()) 
                {
                    if ((loc5 = loc3.next() as ITween) as Action)
                    {
                        continue;
                    }
                    loc5.renderFrame(loc4);
                }
                loc3.reset();
                ++loc4;
            }
            render();
            return;
        }

        public function prevFrame():void
        {
            setFrame((m_uFrame - 1));
            return;
        }

        protected function onNextFrameEF(arg1:flash.events.Event):void
        {
            nextFrame();
            return;
        }

        public function gotoAndPlay(arg1:uint):void
        {
            stop();
            setFrame(arg1);
            play();
            return;
        }

        public function stop():void
        {
            m_objRendererPrev.stop(m_uRenderMethod);
            m_objRendererNext.stop(m_uRenderMethod);
            dispatchEvent(new AnimationEvent(AnimationEvent.STOP));
            return;
        }

        public function playReverse():void
        {
            stop();
            dispatchEvent(new AnimationEvent(AnimationEvent.START));
            m_objRendererPrev.start(m_uRenderMethod);
            return;
        }

        public function set loop(arg1:Boolean):void
        {
            m_bLoop = arg1;
            return;
        }

        protected function init(arg1:uint, arg2:Number):void
        {
            var loc3:*;

            BoostworthyAnimation.log();
            setFrameRate(arg2);
            m_uRenderMethod = arg1;
            m_objRendererPrev = new Renderer(onPrevFrameEF, onPrevFrameT, m_nRefreshRate);
            m_objRendererNext = new Renderer(onNextFrameEF, onNextFrameT, m_nRefreshRate);
            m_objTweenStack = new TweenStack();
            m_uLength = loc3 = 1;
            m_uFrame = loc3;
            loop = DEFAULT_LOOP;
            return;
        }

        public function gotoAndStop(arg1:uint):void
        {
            stop();
            setFrame(arg1);
            return;
        }

        protected function onPrevFrameT(arg1:flash.events.TimerEvent):void
        {
            prevFrame();
            arg1.updateAfterEvent();
            return;
        }

        public function nextFrame():void
        {
            setFrame(m_uFrame + 1);
            return;
        }

        protected function render(arg1:Boolean=false):void
        {
            var loc2:*;

            loc2 = m_objTweenStack.getIterator(arg1 ? IteratorType.ARRAY_REVERSE : IteratorType.ARRAY_FORWARD);
            while (loc2.hasNext()) 
            {
                loc2.next().renderFrame(m_uFrame);
            }
            return;
        }

        public function get loop():Boolean
        {
            return m_bLoop;
        }

        public function get length():Number
        {
            return m_uLength;
        }

        public function setFrameRate(arg1:Number):void
        {
            m_uFrameRate = (arg1 > 0) ? arg1 : DEFAULT_FRAME_RATE;
            m_nRefreshRate = Math.floor(1000 / m_uFrameRate);
            return;
        }

        public function addTween(arg1:com.boostworthy.animation.sequence.tweens.ITween):void
        {
            var loc2:*;

            loc2 = arg1.clone();
            m_uLength = (loc2.lastFrame > m_uLength) ? loc2.lastFrame : m_uLength;
            m_objTweenStack.addElement(loc2);
            computeFrameData(loc2.firstFrame, loc2.lastFrame);
            return;
        }

        public function dispose():void
        {
            stop();
            m_objRendererPrev.dispose();
            m_objRendererNext.dispose();
            m_objTweenStack.dispose();
            m_uRenderMethod = NaN;
            m_uFrameRate = NaN;
            m_nRefreshRate = NaN;
            m_uFrame = NaN;
            m_uLength = NaN;
            m_bLoop = false;
            return;
        }

        protected function onNextFrameT(arg1:flash.events.TimerEvent):void
        {
            nextFrame();
            arg1.updateAfterEvent();
            return;
        }

        protected function setFrame(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = false;
            loc3 = false;
            if (arg1 > m_uLength)
            {
                if (m_bLoop)
                {
                    arg1 = 1;
                }
                else 
                {
                    loc3 = true;
                }
            }
            if (arg1 < 1)
            {
                if (m_bLoop)
                {
                    arg1 = m_uLength;
                    loc2 = true;
                }
                else 
                {
                    loc3 = true;
                }
            }
            m_uFrame = Math.min(Math.max(1, arg1), m_uLength);
            if (!loc3)
            {
                render(loc2);
            }
            dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
            if (loc3)
            {
                stop();
                dispatchEvent(new AnimationEvent(AnimationEvent.FINISH));
            }
            return;
        }

        public function gotoAndPlayReverse(arg1:uint):void
        {
            stop();
            setFrame(arg1);
            playReverse();
            return;
        }

        public function play():void
        {
            stop();
            dispatchEvent(new AnimationEvent(AnimationEvent.START));
            m_objRendererNext.start(m_uRenderMethod);
            return;
        }

        protected function onPrevFrameEF(arg1:flash.events.Event):void
        {
            prevFrame();
            return;
        }

        protected const DEFAULT_LOOP:Boolean=false;

        protected const DEFAULT_RENDER_METHOD:uint=2;

        protected const DEFAULT_FRAME_RATE:Number=60;

        protected var m_uFrameRate:uint;

        protected var m_uFrame:uint;

        protected var m_uRenderMethod:uint;

        protected var m_nRefreshRate:Number;

        protected var m_objTweenStack:com.boostworthy.animation.sequence.TweenStack;

        protected var m_bLoop:Boolean;

        protected var m_uLength:uint;

        protected var m_objRendererPrev:com.boostworthy.animation.rendering.Renderer;

        protected var m_objRendererNext:com.boostworthy.animation.rendering.Renderer;
    }
}
