package com.hurlant.crypto.prng 
{
    import flash.utils.*;
    
    public interface IPRNG
    {
        function init(arg1:flash.utils.ByteArray):void;

        function next():uint;

        function getPoolSize():uint;

        function toString():String;

        function dispose():void;
    }
}
