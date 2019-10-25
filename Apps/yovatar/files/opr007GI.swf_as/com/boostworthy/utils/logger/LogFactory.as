package com.boostworthy.utils.logger 
{
    import com.boostworthy.collections.*;
    import com.boostworthy.collections.iterators.*;
    import com.boostworthy.core.*;
    
    public class LogFactory extends Object implements com.boostworthy.core.IDisposable
    {
        public function LogFactory(arg1:SingletonEnforcer)
        {
            super();
            init();
            return;
        }

        protected function init():void
        {
            m_uLevel = LogSettings.DEFAULT_LOG_LEVEL;
            m_objLogHash = new HashMap();
            return;
        }

        public function getLog(arg1:String):com.boostworthy.utils.logger.ILog
        {
            if (m_objLogHash.containsKey(arg1))
            {
                return m_objLogHash.get(arg1) as ILog;
            }
            m_objLogHash.put(arg1, new Log(arg1, m_uLevel));
            return m_objLogHash.get(arg1) as ILog;
        }

        public function setLevel(arg1:uint):void
        {
            var loc2:*;

            m_uLevel = arg1;
            loc2 = m_objLogHash.getValueIterator();
            while (loc2.hasNext()) 
            {
                loc2.next().setLevel(m_uLevel);
            }
            return;
        }

        public function getLevel():uint
        {
            return m_uLevel;
        }

        public function dispose():void
        {
            m_objLogHash.dispose();
            return;
        }

        public static function getInstance():com.boostworthy.utils.logger.LogFactory
        {
            if (c_objInstance == null)
            {
                c_objInstance = new LogFactory(new SingletonEnforcer());
            }
            return c_objInstance;
        }

        private var m_uLevel:uint;

        private var m_objLogHash:com.boostworthy.collections.HashMap;

        private static var c_objInstance:com.boostworthy.utils.logger.LogFactory;
    }
}


class SingletonEnforcer extends Object
{
    public function SingletonEnforcer()
    {
        super();
        return;
    }
}