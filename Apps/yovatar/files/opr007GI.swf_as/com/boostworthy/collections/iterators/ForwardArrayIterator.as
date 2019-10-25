package com.boostworthy.collections.iterators 
{
    public class ForwardArrayIterator extends Object implements com.boostworthy.collections.iterators.IIterator
    {
        public function ForwardArrayIterator(arg1:Array)
        {
            super();
            m_aData = arg1;
            reset();
            return;
        }

        public function reset():void
        {
            m_uIndex = 0;
            return;
        }

        public function next():Object
        {
            var loc1:*;
            var loc2:*;

            return m_aData[m_uIndex++];
        }

        public function hasNext():Boolean
        {
            return m_uIndex < m_aData.length;
        }

        private var m_aData:Array;

        private var m_uIndex:uint;
    }
}
