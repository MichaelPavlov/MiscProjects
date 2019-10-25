package com.boostworthy.utils.logger 
{
    public interface ILog
    {
        function getName():String;

        function setLevel(arg1:uint):void;

        function debug(arg1:String):void;

        function severe(arg1:String):void;

        function getLevel():uint;

        function warning(arg1:String):void;

        function info(arg1:String):void;
    }
}
