package com.boostworthy.collections.iterators 
{
    public class ReverseArrayIterator extends Object implements com.boostworthy.collections.iterators.IIterator
    {
        public function ReverseArrayIterator(arg1:Array)
        {
            super();
            m_aData = arg1;
            reset();
            return;
        }

        public function reset():void
        {
            m_uIndex = m_aData.length;
            return;
        }

        public function next():Object
        {
            var loc1:*;
            var loc2:*;

            return m_aData[--m_uIndex];
        }

        public function hasNext():Boolean
        {
            return m_uIndex > 0;
        }

        private var m_aData:Array;

        private var m_uIndex:uint;
    }
}
