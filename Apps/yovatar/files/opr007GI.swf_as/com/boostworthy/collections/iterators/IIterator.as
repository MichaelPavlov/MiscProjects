package com.boostworthy.collections.iterators 
{
    public interface IIterator
    {
        function next():Object;

        function hasNext():Boolean;

        function reset():void;
    }
}
