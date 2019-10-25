package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public interface ICipher
    {
        function encrypt(arg1:flash.utils.ByteArray):void;

        function getBlockSize():uint;

        function toString():String;

        function decrypt(arg1:flash.utils.ByteArray):void;

        function dispose():void;
    }
}
