package com.boostworthy.animation.sequence.tweens 
{
    public class Action extends Object implements com.boostworthy.animation.sequence.tweens.ITween
    {
        public function Action(arg1:Function, arg2:Array, arg3:Function, arg4:Array, arg5:uint)
        {
            super();
            m_fncForward = arg1;
            m_aParamsForward = arg2;
            m_fncReverse = arg3;
            m_aParamsReverse = arg4;
            m_uFirstFrame = arg5;
            m_uLastFrame = arg5;
            m_uPreviousFrame = 1;
            return;
        }

        public function get target():Object
        {
            return null;
        }

        public function get property():String
        {
            return PROPERTY;
        }

        public function get firstFrame():uint
        {
            return m_uFirstFrame;
        }

        public function clone():com.boostworthy.animation.sequence.tweens.ITween
        {
            return new Action(m_fncForward, m_aParamsForward, m_fncReverse, m_aParamsReverse, m_uFirstFrame);
        }

        public function get lastFrame():uint
        {
            return m_uLastFrame;
        }

        public function renderFrame(arg1:uint):void
        {
            if (arg1 == m_uFirstFrame)
            {
                if (m_uPreviousFrame > arg1)
                {
                    m_fncReverse.apply(null, m_aParamsReverse);
                }
                else 
                {
                    m_fncForward.apply(null, m_aParamsForward);
                }
            }
            m_uPreviousFrame = arg1;
            return;
        }

        protected const PROPERTY:String="action";

        protected var m_aParamsForward:Array;

        protected var m_uPreviousFrame:uint;

        protected var m_uLastFrame:uint;

        protected var m_fncReverse:Function;

        protected var m_uFirstFrame:uint;

        protected var m_aParamsReverse:Array;

        protected var m_fncForward:Function;
    }
}
