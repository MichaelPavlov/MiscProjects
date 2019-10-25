package com.hurlant.crypto.hash 
{
    import flash.utils.*;
    
    public interface IHash
    {
        function toString():String;

        function getHashSize():uint;

        function getInputSize():uint;

        function hash(arg1:flash.utils.ByteArray):flash.utils.ByteArray;
    }
}
