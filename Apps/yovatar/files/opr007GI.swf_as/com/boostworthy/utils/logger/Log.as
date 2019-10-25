package com.boostworthy.utils.logger 
{
    public class Log extends Object implements com.boostworthy.utils.logger.ILog
    {
        public function Log(arg1:String, arg2:uint)
        {
            super();
            init(arg1, arg2);
            return;
        }

        protected function output(arg1:String, arg2:uint):void
        {
            if (!(m_uLevel & LogLevel.OFF) && m_uLevel >= arg2)
            {
                trace(createOutputMessage(arg1, arg2));
            }
            return;
        }

        public function getName():String
        {
            return m_strName;
        }

        public function setLevel(arg1:uint):void
        {
            m_uLevel = arg1;
            return;
        }

        protected function createOutputMessage(arg1:String, arg2:uint):String
        {
            return m_strName + " (" + getLevelName(arg2) + ") :: " + arg1 + "\n";
        }

        public function getLevel():uint
        {
            return m_uLevel;
        }

        protected function init(arg1:String, arg2:uint):void
        {
            m_strName = arg1;
            m_uLevel = arg2;
            return;
        }

        protected function getLevelName(arg1:uint):String
        {
            var loc2:*;

            loc2 = arg1;
            switch (loc2) 
            {
                case LogLevel.OFF:
                    return "OFF";
                case LogLevel.SEVERE:
                    return "SEVERE";
                case LogLevel.WARNING:
                    return "WARNING";
                case LogLevel.INFO:
                    return "INFO";
                case LogLevel.DEBUG:
                    return "DEBUG";
                default:
                    return "";
            }
        }

        public function debug(arg1:String):void
        {
            output(arg1, LogLevel.DEBUG);
            return;
        }

        public function severe(arg1:String):void
        {
            output(arg1, LogLevel.SEVERE);
            return;
        }

        public function warning(arg1:String):void
        {
            output(arg1, LogLevel.WARNING);
            return;
        }

        public function info(arg1:String):void
        {
            output(arg1, LogLevel.INFO);
            return;
        }

        protected var m_strName:String;

        protected var m_uLevel:uint;
    }
}
