package com.boostworthy.collections 
{
    import com.boostworthy.collections.iterators.*;
    import com.boostworthy.core.*;
    
    public class HashMap extends Object implements com.boostworthy.collections.ICollection, com.boostworthy.core.IDisposable
    {
        public function HashMap(arg1:Object=null)
        {
            super();
            init(arg1);
            return;
        }

        public function containsKey(arg1:Object):Boolean
        {
            return !(searchForKey(arg1) == Global.NULL_INDEX);
        }

        public function remove(arg1:Object):void
        {
            var loc2:*;

            loc2 = searchForKey(arg1);
            if (loc2 != Global.NULL_INDEX)
            {
                m_aKeys.splice(loc2, 1);
                m_aValues.splice(loc2, 1);
            }
            return;
        }

        public function getValueIterator(arg1:uint=2):com.boostworthy.collections.iterators.IIterator
        {
            if (arg1 == IteratorType.ARRAY_FORWARD)
            {
                return new ForwardArrayIterator(m_aValues.concat());
            }
            if (arg1 == IteratorType.ARRAY_REVERSE)
            {
                return new ReverseArrayIterator(m_aValues.concat());
            }
            return new ForwardArrayIterator(m_aValues.concat());
        }

        public function getIterator(arg1:uint=2):com.boostworthy.collections.iterators.IIterator
        {
            return getValueIterator(arg1);
        }

        public function putMap(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = arg1;
            for (loc2 in loc4)
            {
                put(loc2, arg1[loc2]);
            }
            return;
        }

        public function put(arg1:Object, arg2:Object):void
        {
            remove(arg1);
            m_aKeys.push(arg1);
            m_aValues.push(arg2);
            return;
        }

        protected function init(arg1:Object):void
        {
            dispose();
            if (arg1 != null)
            {
                putMap(arg1);
            }
            return;
        }

        public function get length():uint
        {
            return m_aKeys.length;
        }

        public function get(arg1:Object):Object
        {
            var loc2:*;

            loc2 = searchForKey(arg1);
            if (loc2 != Global.NULL_INDEX)
            {
                return m_aValues[loc2];
            }
            return null;
        }

        public function getKeyIterator(arg1:uint=2):com.boostworthy.collections.iterators.IIterator
        {
            if (arg1 == IteratorType.ARRAY_FORWARD)
            {
                return new ForwardArrayIterator(m_aKeys.concat());
            }
            if (arg1 == IteratorType.ARRAY_REVERSE)
            {
                return new ReverseArrayIterator(m_aKeys.concat());
            }
            return new ForwardArrayIterator(m_aKeys.concat());
        }

        public function clone():com.boostworthy.collections.HashMap
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = new HashMap();
            loc2 = m_aKeys.length;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                loc1.put(m_aKeys[loc3], m_aValues[loc3]);
                ++loc3;
            }
            return loc1;
        }

        protected function searchForKey(arg1:Object):int
        {
            var loc2:*;
            var loc3:*;

            loc2 = m_aKeys.length;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                if (m_aKeys[loc3] === arg1)
                {
                    return loc3;
                }
                ++loc3;
            }
            return Global.NULL_INDEX;
        }

        public function dispose():void
        {
            m_aKeys = new Array();
            m_aValues = new Array();
            return;
        }

        protected var m_aKeys:Array;

        protected var m_aValues:Array;
    }
}
