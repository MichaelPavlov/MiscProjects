package com.boostworthy.collections 
{
    import com.boostworthy.collections.iterators.*;
    
    public interface ICollection
    {
        function getIterator(arg1:uint=2):com.boostworthy.collections.iterators.IIterator;
    }
}
