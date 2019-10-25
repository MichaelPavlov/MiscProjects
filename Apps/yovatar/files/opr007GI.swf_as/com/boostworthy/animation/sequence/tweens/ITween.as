package com.boostworthy.animation.sequence.tweens 
{
    public interface ITween
    {
        function get target():Object;

        function clone():com.boostworthy.animation.sequence.tweens.ITween;

        function get property():String;

        function get lastFrame():uint;

        function get firstFrame():uint;

        function renderFrame(arg1:uint):void;
    }
}
