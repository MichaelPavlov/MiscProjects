package com.boostworthy.animation.rendering 
{
    import com.boostworthy.core.*;
    import com.boostworthy.utils.logger.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class Renderer extends flash.events.EventDispatcher implements com.boostworthy.core.IDisposable
    {
        public function Renderer(arg1:Function, arg2:Function, arg3:Number)
        {
            super();
            if (arg1 != null)
            {
                m_fncOnEnterFrame = arg1;
                m_objStage = Global.stage;
            }
            if (arg2 != null)
            {
                m_fncOnTimer = arg2;
                m_objTimer = new Timer(arg3, 0);
                m_objTimer.addEventListener(TimerEvent.TIMER, m_fncOnTimer);
            }
            m_objLog = LogFactory.getInstance().getLog("Renderer");
            return;
        }

        public function start(arg1:Number):void
        {
            if (arg1 != RenderMethod.ENTER_FRAME)
            {
                if (arg1 == RenderMethod.TIMER)
                {
                    startTimer();
                }
            }
            else 
            {
                startEnterFrame();
            }
            return;
        }

        protected function startTimer():void
        {
            m_objTimer.start();
            return;
        }

        public function startAll():void
        {
            startEnterFrame();
            startTimer();
            return;
        }

        public function stop(arg1:Number):void
        {
            if (arg1 != RenderMethod.ENTER_FRAME)
            {
                if (arg1 == RenderMethod.TIMER)
                {
                    stopTimer();
                }
            }
            else 
            {
                stopEnterFrame();
            }
            return;
        }

        protected function stopTimer():void
        {
            m_objTimer.stop();
            return;
        }

        public function stopAll():void
        {
            stopEnterFrame();
            stopTimer();
            return;
        }

        protected function startEnterFrame():void
        {
            if (!m_objStage)
            {
                m_objStage = Global.stage;
            }
            if (m_objStage)
            {
                m_objStage.addEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
            }
            else 
            {
                m_objLog.warning("startEnterFrame :: Unable to add a listener to the enter frame event because a global stage reference does not exist.");
            }
            return;
        }

        protected function stopEnterFrame():void
        {
            if (m_objStage)
            {
                m_objStage.removeEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
            }
            return;
        }

        public function dispose():void
        {
            if (!(m_fncOnEnterFrame == null) && !(m_objStage == null))
            {
                m_objStage.removeEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
            }
            if (m_objTimer != null)
            {
                m_objTimer.removeEventListener(TimerEvent.TIMER, m_fncOnTimer);
            }
            m_fncOnEnterFrame = null;
            m_objTimer = null;
            m_fncOnTimer = null;
            m_objStage = null;
            return;
        }

        protected var m_objTimer:flash.utils.Timer;

        protected var m_fncOnTimer:Function;

        protected var m_objStage:flash.display.Stage;

        protected var m_fncOnEnterFrame:Function;

        protected var m_objLog:com.boostworthy.utils.logger.ILog;
    }
}
