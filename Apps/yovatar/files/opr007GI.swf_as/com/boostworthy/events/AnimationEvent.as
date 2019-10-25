package com.boostworthy.events 
{
    import flash.events.*;
    
    public class AnimationEvent extends flash.events.Event
    {
        public function AnimationEvent(arg1:String, arg2:Object=null, arg3:String="")
        {
            super(arg1);
            m_objTarget = arg2;
            m_strProperty = arg3;
            return;
        }

        public function get animTarget():Object
        {
            return m_objTarget;
        }

        public function get animProperty():String
        {
            return m_strProperty;
        }

        public static const CHANGE:String="animationChange";

        public static const STOP:String="animationStop";

        public static const START:String="animationStart";

        public static const FINISH:String="animationFinish";

        protected var m_strProperty:String;

        protected var m_objTarget:Object;
    }
}
