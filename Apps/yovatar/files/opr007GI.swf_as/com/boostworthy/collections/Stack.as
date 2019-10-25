package com.boostworthy.collections 
{
    import com.boostworthy.collections.iterators.*;
    import com.boostworthy.core.*;
    
    public class Stack extends Object implements com.boostworthy.collections.ICollection, com.boostworthy.core.IDisposable
    {
        public function Stack()
        {
            super();
            dispose();
            return;
        }

        public function getIterator(arg1:uint=2):com.boostworthy.collections.iterators.IIterator
        {
            if (arg1 == IteratorType.ARRAY_FORWARD)
            {
                return new ForwardArrayIterator(m_aData.concat());
            }
            if (arg1 == IteratorType.ARRAY_REVERSE)
            {
                return new ReverseArrayIterator(m_aData.concat());
            }
            return new ForwardArrayIterator(m_aData.concat());
        }

        private function getElementIndex(arg1:Object):int
        {
            var loc2:*;

            loc2 = 0;
            while (loc2 < m_aData.length) 
            {
                if (m_aData[loc2] === arg1)
                {
                    return loc2;
                }
                ++loc2;
            }
            return Global.NULL_INDEX;
        }

        public function get length():uint
        {
            return m_aData.length;
        }

        public function removeElement(arg1:Object):void
        {
            var loc2:*;

            loc2 = getElementIndex(arg1);
            if (loc2 != Global.NULL_INDEX)
            {
                m_aData.splice(loc2, 1);
            }
            return;
        }

        public function addElement(arg1:Object):void
        {
            m_aData.unshift(arg1);
            return;
        }

        public function dispose():void
        {
            m_aData = new Array();
            return;
        }

        protected var m_aData:Array;
    }
}
