package com.hurlant.math 
{
    internal class MontgomeryReduction extends Object implements com.hurlant.math.IReduction
    {
        public function MontgomeryReduction(arg1:com.hurlant.math.BigInteger)
        {
            super();
            this.m = arg1;
            mp = arg1.bi_internal::invDigit();
            mpl = mp & 32767;
            mph = mp >> 15;
            um = (1 << BigInteger.DB - 15 - 1);
            mt2 = 2 * arg1.t;
            return;
        }

        public function convert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            arg1.abs().bi_internal::dlShiftTo(m.t, loc2);
            loc2.bi_internal::divRemTo(m, null, loc2);
            if (arg1.bi_internal::s < 0 && loc2.compareTo(BigInteger.ZERO) > 0)
            {
                m.bi_internal::subTo(loc2, loc2);
            }
            return loc2;
        }

        public function revert(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            arg1.bi_internal::copyTo(loc2);
            reduce(loc2);
            return loc2;
        }

        public function sqrTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::squareTo(arg2);
            reduce(arg2);
            return;
        }

        public function reduce(arg1:com.hurlant.math.BigInteger):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = 0;
            loc4 = 0;
            while (arg1.t <= mt2) 
            {
                loc7 = (((loc6 = arg1).t) + 1);
                loc6.t = loc7;
                arg1.bi_internal::a[(loc5 = (loc6 = arg1).t)] = 0;
            }
            loc2 = 0;
            while (loc2 < m.t) 
            {
                loc3 = arg1.bi_internal::a[loc2] & 32767;
                loc4 = loc3 * mpl + ((loc3 * mph + (arg1.bi_internal::a[loc2] >> 15) * mpl & um) << 15) & BigInteger.DM;
                loc3 = loc2 + m.t;
                arg1.bi_internal::a[loc3] = arg1.bi_internal::a[loc3] + m.bi_internal::am(0, loc4, arg1, loc2, 0, m.t);
                while (arg1.bi_internal::a[loc3] >= BigInteger.DV) 
                {
                    arg1.bi_internal::a[loc3] = arg1.bi_internal::a[loc3] - BigInteger.DV;
                    loc7 = ((loc5 = arg1.bi_internal::a)[(loc6 = ++loc3)] + 1);
                    loc5[loc6] = loc7;
                }
                ++loc2;
            }
            arg1.bi_internal::clamp();
            arg1.bi_internal::drShiftTo(m.t, arg1);
            if (arg1.compareTo(m) >= 0)
            {
                arg1.bi_internal::subTo(m, arg1);
            }
            return;
        }

        public function mulTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger, arg3:com.hurlant.math.BigInteger):void
        {
            arg1.bi_internal::multiplyTo(arg2, arg3);
            reduce(arg3);
            return;
        }

        private var mp:int;

        private var mph:int;

        private var mpl:int;

        private var mt2:int;

        private var m:com.hurlant.math.BigInteger;

        private var um:int;
    }
}
