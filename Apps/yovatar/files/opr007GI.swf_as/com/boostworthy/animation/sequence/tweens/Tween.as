package com.boostworthy.animation.sequence.tweens 
{
    import com.boostworthy.animation.easing.*;
    
    public class Tween extends Object implements com.boostworthy.animation.sequence.tweens.ITween
    {
        public function Tween(arg1:Object, arg2:String, arg3:Number, arg4:uint, arg5:uint, arg6:String="linear")
        {
            super();
            m_objToTween = arg1;
            m_strProperty = arg2;
            m_nTargetValue = arg3;
            m_uFirstFrame = arg4;
            m_uLastFrame = arg5;
            m_strTransition = arg6;
            m_fncTransition = Transitions[m_strTransition];
            return;
        }

        public function renderFrame(arg1:uint):void
        {
            var loc2:*;

            loc2 = NaN;
            if (arg1 < m_uFirstFrame && !isNaN(m_nStartValue))
            {
                m_objToTween[m_strProperty] = m_nStartValue;
                m_bIsDirty = true;
            }
            else 
            {
                if (arg1 >= m_uFirstFrame && arg1 <= m_uLastFrame)
                {
                    loc2 = (arg1 - m_uFirstFrame) / (m_uLastFrame - m_uFirstFrame);
                    if (isNaN(m_nStartValue) && arg1 == m_uFirstFrame)
                    {
                        m_nStartValue = m_objToTween[m_strProperty];
                        m_nChangeValue = m_nTargetValue - m_nStartValue;
                    }
                    m_objToTween[m_strProperty] = m_fncTransition(loc2, m_nStartValue, m_nChangeValue, 1);
                    m_bIsDirty = true;
                }
                else 
                {
                    if (arg1 > m_uLastFrame && m_bIsDirty)
                    {
                        m_objToTween[m_strProperty] = m_nTargetValue;
                        m_bIsDirty = false;
                    }
                }
            }
            return;
        }

        public function get target():Object
        {
            return m_objToTween;
        }

        public function get property():String
        {
            return m_strProperty;
        }

        public function get lastFrame():uint
        {
            return m_uLastFrame;
        }

        public function clone():com.boostworthy.animation.sequence.tweens.ITween
        {
            return new Tween(m_objToTween, m_strProperty, m_nTargetValue, m_uFirstFrame, m_uLastFrame, m_strTransition);
        }

        public function get firstFrame():uint
        {
            return m_uFirstFrame;
        }

        protected const DEFAULT_TRANSITION:String="linear";

        protected var m_objToTween:Object;

        protected var m_strTransition:String;

        protected var m_bIsDirty:Boolean;

        protected var m_strProperty:String;

        protected var m_uFirstFrame:uint;

        protected var m_uLastFrame:uint;

        protected var m_nTargetValue:Number;

        protected var m_nChangeValue:Number;

        protected var m_nStartValue:Number;

        protected var m_fncTransition:Function;
    }
}
