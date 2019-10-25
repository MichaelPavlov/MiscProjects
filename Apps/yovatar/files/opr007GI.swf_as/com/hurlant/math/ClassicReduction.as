package com.hurlant.math 
{
    internal class ClassicReduction extends Object implements com.hurlant.math.IReduction
    {
        public function ClassicReduction(arg1:com.hurlant.math.BigInteger)
        {
            super();
            this.m = arg1;
            return;
        }

        public function revert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return arg1;
        }

        public function reduce(arg1:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::divRemTo(m, null, arg1);
            return;
        }

        public function mulTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger, arg3:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::multiplyTo(arg2, arg3);
            reduce(arg3);
            return;
        }

        public function sqrTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::squareTo(arg2);
            reduce(arg2);
            return;
        }

        public function convert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            if (arg1.bi_internal::s < 0 || arg1.compareTo(m) >= 0)
            {
                return arg1.mod(m);
            }
            return arg1;
        }

        private var m:com.hurlant.math.BigInteger;
    }
}
