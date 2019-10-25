package com.hurlant.math 
{
    internal interface IReduction
    {
        function revert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger;

        function reduce(arg1:com.hurlant.math.BigInteger):void;

        function convert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger;

        function mulTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger, arg3:com.hurlant.math.BigInteger):void;

        function sqrTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void;
    }
}
