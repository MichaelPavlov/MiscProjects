package com.hurlant.math 
{
    public class NullReduction extends Object implements com.hurlant.math.IReduction
    {
        public function NullReduction()
        {
            super();
            return;
        }

        public function convert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return arg1;
        }

        public function sqrTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::squareTo(arg2);
            return;
        }

        public function mulTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger, arg3:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::multiplyTo(arg2, arg3);
            return;
        }

        public function revert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return arg1;
        }

        public function reduce(arg1:com.hurlant.math.BigInteger):void
        {
            return;
        }
    }
}
