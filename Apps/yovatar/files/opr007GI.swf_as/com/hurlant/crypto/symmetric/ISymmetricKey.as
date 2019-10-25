package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public interface ISymmetricKey
    {
        function encrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void;

        function getBlockSize():uint;

        function toString():String;

        function decrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void;

        function dispose():void;
    }
}
