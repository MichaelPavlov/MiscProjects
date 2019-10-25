package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public interface IPad
    {
        function unpad(arg1:flash.utils.ByteArray):void;

        function pad(arg1:flash.utils.ByteArray):void;

        function setBlockSize(arg1:uint):void;
    }
}
