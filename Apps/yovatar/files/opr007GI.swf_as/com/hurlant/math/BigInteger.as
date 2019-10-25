package com.hurlant.math 
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class BigInteger extends Object
    {
        public function BigInteger(arg1:*=null, arg2:int=0)
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = 0;
            super();
            bi_internal::a = new Array();
            if (arg1 as String)
            {
                arg1 = Hex.toArray(arg1);
                arg2 = 0;
            }
            if (arg1 as ByteArray)
            {
                loc3 = arg1 as ByteArray;
                loc4 = arg2 || loc3.length - loc3.position;
                bi_internal::fromArray(loc3, loc4);
            }
            return;
        }

        public function clearBit(arg1:int):com.hurlant.math.BigInteger
        {
            return changeBit(arg1, op_andnot);
        }

        private function op_or(arg1:int, arg2:int):int
        {
            return arg1 | arg2;
        }

        public function negate():com.hurlant.math.BigInteger
        {
            var loc1:*;

            loc1 = nbi();
            ZERO.bi_internal::subTo(this, loc1);
            return loc1;
        }

        public function andNot(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bitwiseTo(arg1, op_andnot, loc2);
            return loc2;
        }

        public function modPow(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;

            loc4 = 0;
            loc6 = null;
            loc12 = 0;
            loc15 = null;
            loc16 = null;
            loc3 = arg1.bitLength();
            loc5 = nbv(1);
            if (loc3 <= 0)
            {
                return loc5;
            }
            if (loc3 < 18)
            {
                loc4 = 1;
            }
            else 
            {
                if (loc3 < 48)
                {
                    loc4 = 3;
                }
                else 
                {
                    if (loc3 < 144)
                    {
                        loc4 = 4;
                    }
                    else 
                    {
                        if (loc3 < 768)
                        {
                            loc4 = 5;
                        }
                        else 
                        {
                            loc4 = 6;
                        }
                    }
                }
            }
            if (loc3 < 8)
            {
                loc6 = new ClassicReduction(arg2);
            }
            else 
            {
                if (arg2.bi_internal::isEven())
                {
                    loc6 = new BarrettReduction(arg2);
                }
                else 
                {
                    loc6 = new MontgomeryReduction(arg2);
                }
            }
            loc7 = [];
            loc8 = 3;
            loc9 = (loc4 - 1);
            loc10 = (1 << loc4 - 1);
            loc7[1] = loc6.convert(this);
            if (loc4 > 1)
            {
                loc16 = new BigInteger();
                loc6.sqrTo(loc7[1], loc16);
                while (loc8 <= loc10) 
                {
                    loc7[loc8] = new BigInteger();
                    loc6.mulTo(loc16, loc7[(loc8 - 2)], loc7[loc8]);
                    loc8 = loc8 + 2;
                }
            }
            loc11 = (arg1.t - 1);
            loc13 = true;
            loc14 = new BigInteger();
            loc3 = (bi_internal::nbits(arg1.bi_internal::a[loc11]) - 1);
            while (loc11 >= 0) 
            {
                if (loc3 >= loc9)
                {
                    loc12 = arg1.bi_internal::a[loc11] >> loc3 - loc9 & loc10;
                }
                else 
                {
                    loc12 = (arg1.bi_internal::a[loc11] & (1 << loc3 + 1 - 1)) << loc9 - loc3;
                    if (loc11 > 0)
                    {
                        loc12 = loc12 | arg1.bi_internal::a[(loc11 - 1)] >> DB + loc3 - loc9;
                    }
                }
                loc8 = loc4;
                while ((loc12 & 1) == 0) 
                {
                    loc12 = loc12 >> 1;
                    loc8 = (loc8 - 1);
                }
                loc3 = loc17 = loc3 - loc8;
                if (loc17 < 0)
                {
                    loc3 = loc3 + DB;
                    loc11 = (loc11 - 1);
                }
                if (loc13)
                {
                    loc7[loc12].copyTo(loc5);
                    loc13 = false;
                }
                else 
                {
                    while (loc8 > 1) 
                    {
                        loc6.sqrTo(loc5, loc14);
                        loc6.sqrTo(loc14, loc5);
                        loc8 = loc8 - 2;
                    }
                    if (loc8 > 0)
                    {
                        loc6.sqrTo(loc5, loc14);
                    }
                    else 
                    {
                        loc15 = loc5;
                        loc5 = loc14;
                        loc14 = loc15;
                    }
                    loc6.mulTo(loc14, loc7[loc12], loc5);
                }
                while (loc11 >= 0 && (arg1.bi_internal::a[loc11] & 1 << loc3) == 0) 
                {
                    loc6.sqrTo(loc5, loc14);
                    loc15 = loc5;
                    loc5 = loc14;
                    loc14 = loc15;
                    if (!(--loc3 < 0))
                    {
                        continue;
                    }
                    loc3 = (DB - 1);
                    loc11 = (loc11 - 1);
                }
            }
            return loc6.revert(loc5);
        }

        public function isProbablePrime(arg1:int):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = 0;
            loc4 = 0;
            loc5 = 0;
            loc3 = abs();
            if (loc3.t == 1 && loc3.bi_internal::a[0] <= lowprimes[(lowprimes.length - 1)])
            {
                loc2 = 0;
                while (loc2 < lowprimes.length) 
                {
                    if (loc3[0] == lowprimes[loc2])
                    {
                        return true;
                    }
                    ++loc2;
                }
                return false;
            }
            if (loc3.bi_internal::isEven())
            {
                return false;
            }
            loc2 = 1;
            while (loc2 < lowprimes.length) 
            {
                loc4 = lowprimes[loc2];
                loc5 = loc2 + 1;
                while (loc5 < lowprimes.length && loc4 < lplim) 
                {
                    loc4 = loc4 * lowprimes[loc5++];
                }
                loc4 = loc3.modInt(loc4);
                while (loc2 < loc5) 
                {
                    if (loc4 % lowprimes[loc2++] != 0)
                    {
                        continue;
                    }
                    return false;
                }
            }
            return loc3.millerRabin(arg1);
        }

        public function divide(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bi_internal::divRemTo(arg1, loc2, null);
            return loc2;
        }

        public function mod(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = nbi();
            abs().bi_internal::divRemTo(arg1, null, loc2);
            if (bi_internal::s < 0 && loc2.compareTo(ZERO) > 0)
            {
                arg1.bi_internal::subTo(loc2, loc2);
            }
            return loc2;
        }

        protected function addTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = Math.min(arg1.t, t);
            while (loc3 < loc5) 
            {
                loc4 = loc4 + this.bi_internal::a[loc3] + arg1.bi_internal::a[loc3];
                arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                loc4 = loc4 >> DB;
            }
            if (arg1.t < t)
            {
                loc4 = loc4 + arg1.bi_internal::s;
                while (loc3 < t) 
                {
                    loc4 = loc4 + this.bi_internal::a[loc3];
                    arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                    loc4 = loc4 >> DB;
                }
                loc4 = loc4 + bi_internal::s;
            }
            else 
            {
                loc4 = loc4 + bi_internal::s;
                while (loc3 < arg1.t) 
                {
                    loc4 = loc4 + arg1.bi_internal::a[loc3];
                    arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                    loc4 = loc4 >> DB;
                }
                loc4 = loc4 + arg1.bi_internal::s;
            }
            arg2.bi_internal::s = (loc4 < 0) ? -1 : 0;
            if (loc4 > 0)
            {
                arg2.bi_internal::a[(loc6 = loc3++)] = loc4;
            }
            else 
            {
                if (loc4 < -1)
                {
                    arg2.bi_internal::a[(loc6 = loc3++)] = DV + loc4;
                }
            }
            arg2.t = loc3;
            arg2.bi_internal::clamp();
            return;
        }

        protected function bitwiseTo(arg1:com.hurlant.math.BigInteger, arg2:Function, arg3:com.hurlant.math.BigInteger):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = 0;
            loc5 = 0;
            loc6 = Math.min(arg1.t, t);
            loc4 = 0;
            while (loc4 < loc6) 
            {
                arg3.bi_internal::a[loc4] = arg2(this.bi_internal::a[loc4], arg1.bi_internal::a[loc4]);
                ++loc4;
            }
            if (arg1.t < t)
            {
                loc5 = arg1.bi_internal::s & DM;
                loc4 = loc6;
                while (loc4 < t) 
                {
                    arg3.bi_internal::a[loc4] = arg2(this.bi_internal::a[loc4], loc5);
                    ++loc4;
                }
                arg3.t = t;
            }
            else 
            {
                loc5 = bi_internal::s & DM;
                loc4 = loc6;
                while (loc4 < arg1.t) 
                {
                    arg3.bi_internal::a[loc4] = arg2(loc5, arg1.bi_internal::a[loc4]);
                    ++loc4;
                }
                arg3.t = arg1.t;
            }
            arg3.bi_internal::s = arg2(bi_internal::s, arg1.bi_internal::s);
            arg3.bi_internal::clamp();
            return;
        }

        protected function modInt(arg1:int):int
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = 0;
            if (arg1 <= 0)
            {
                return 0;
            }
            loc2 = DV % arg1;
            loc3 = (bi_internal::s < 0) ? (arg1 - 1) : 0;
            if (t > 0)
            {
                if (loc2 != 0)
                {
                    loc4 = (t - 1);
                    while (loc4 >= 0) 
                    {
                        loc3 = (loc2 * loc3 + bi_internal::a[loc4]) % arg1;
                        loc4 = (loc4 - 1);
                    }
                }
                else 
                {
                    loc3 = bi_internal::a[0] % arg1;
                }
            }
            return loc3;
        }

        protected function chunkSize(arg1:Number):int
        {
            return Math.floor(Math.LN2 * DB / Math.log(arg1));
        }

        public function gcd(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = null;
            loc2 = (bi_internal::s < 0) ? negate() : clone();
            loc3 = (arg1.bi_internal::s < 0) ? arg1.negate() : arg1.clone();
            if (loc2.compareTo(loc3) < 0)
            {
                loc6 = loc2;
                loc2 = loc3;
                loc3 = loc6;
            }
            loc4 = loc2.getLowestSetBit();
            if ((loc5 = loc3.getLowestSetBit()) < 0)
            {
                return loc2;
            }
            if (loc4 < loc5)
            {
                loc5 = loc4;
            }
            if (loc5 > 0)
            {
                loc2.bi_internal::rShiftTo(loc5, loc2);
                loc3.bi_internal::rShiftTo(loc5, loc3);
            }
            while (loc2.sigNum() > 0) 
            {
                loc4 = loc7 = loc2.getLowestSetBit();
                if (loc7 > 0)
                {
                    loc2.bi_internal::rShiftTo(loc4, loc2);
                }
                loc4 = loc7 = loc3.getLowestSetBit();
                if (loc7 > 0)
                {
                    loc3.bi_internal::rShiftTo(loc4, loc3);
                }
                if (loc2.compareTo(loc3) >= 0)
                {
                    loc2.bi_internal::subTo(loc3, loc2);
                    loc2.bi_internal::rShiftTo(1, loc2);
                    continue;
                }
                loc3.bi_internal::subTo(loc2, loc3);
                loc3.bi_internal::rShiftTo(1, loc3);
            }
            if (loc5 > 0)
            {
                loc3.bi_internal::lShiftTo(loc5, loc3);
            }
            return loc3;
        }

        bi_internal function dAddOffset(arg1:int, arg2:int):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            while (t <= arg2) 
            {
                loc3 = t++;
                bi_internal::a[loc3] = 0;
            }
            bi_internal::a[arg2] = bi_internal::a[arg2] + arg1;
            while (bi_internal::a[arg2] >= DV) 
            {
                bi_internal::a[arg2] = bi_internal::a[arg2] - DV;
                if (++arg2 >= t)
                {
                    loc3 = t++;
                    bi_internal::a[loc3] = 0;
                }
                loc5 = ((loc3 = bi_internal::a)[(loc4 = arg2)] + 1);
                loc3[loc4] = loc5;
            }
            return;
        }

        bi_internal function lShiftTo(arg1:int, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc8 = 0;
            loc3 = arg1 % DB;
            loc4 = DB - loc3;
            loc5 = (1 << loc4 - 1);
            loc6 = arg1 / DB;
            loc7 = bi_internal::s << loc3 & DM;
            loc8 = (t - 1);
            while (loc8 >= 0) 
            {
                arg2.bi_internal::a[(loc8 + loc6 + 1)] = bi_internal::a[loc8] >> loc4 | loc7;
                loc7 = (bi_internal::a[loc8] & loc5) << loc3;
                loc8 = (loc8 - 1);
            }
            loc8 = (loc6 - 1);
            while (loc8 >= 0) 
            {
                arg2.bi_internal::a[loc8] = 0;
                loc8 = (loc8 - 1);
            }
            arg2.bi_internal::a[loc6] = loc7;
            arg2.t = t + loc6 + 1;
            arg2.bi_internal::s = bi_internal::s;
            arg2.bi_internal::clamp();
            return;
        }

        public function getLowestSetBit():int
        {
            var loc1:*;

            loc1 = 0;
            while (loc1 < t) 
            {
                if (bi_internal::a[loc1] != 0)
                {
                    return loc1 * DB + lbit(bi_internal::a[loc1]);
                }
                ++loc1;
            }
            if (bi_internal::s < 0)
            {
                return t * DB;
            }
            return -1;
        }

        public function subtract(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bi_internal::subTo(arg1, loc2);
            return loc2;
        }

        public function primify(arg1:int, arg2:int):void
        {
            if (!testBit((arg1 - 1)))
            {
                bitwiseTo(BigInteger.ONE.shiftLeft((arg1 - 1)), op_or, this);
            }
            if (bi_internal::isEven())
            {
                bi_internal::dAddOffset(1, 0);
            }
            while (!isProbablePrime(arg2)) 
            {
                bi_internal::dAddOffset(2, 0);
                while (bitLength() > arg1) 
                {
                    bi_internal::subTo(BigInteger.ONE.shiftLeft((arg1 - 1)), this);
                }
            }
            return;
        }

        bi_internal function multiplyLowerTo(arg1:com.hurlant.math.BigInteger, arg2:int, arg3:com.hurlant.math.BigInteger):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = 0;
            loc4 = Math.min(t + arg1.t, arg2);
            arg3.bi_internal::s = 0;
            arg3.t = loc4;
            while (loc4 > 0) 
            {
                arg3.bi_internal::a[(loc6 = --loc4)] = 0;
            }
            loc5 = arg3.t - t;
            while (loc4 < loc5) 
            {
                arg3.bi_internal::a[(loc4 + t)] = bi_internal::am(0, arg1.bi_internal::a[loc4], arg3, loc4, 0, t);
                ++loc4;
            }
            loc5 = Math.min(arg1.t, arg2);
            while (loc4 < loc5) 
            {
                bi_internal::am(0, arg1.bi_internal::a[loc4], arg3, loc4, 0, arg2 - loc4);
                ++loc4;
            }
            arg3.bi_internal::clamp();
            return;
        }

        public function modPowInt(arg1:int, arg2:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc3:*;

            loc3 = null;
            if (arg1 < 256 || arg2.bi_internal::isEven())
            {
                loc3 = new ClassicReduction(arg2);
            }
            else 
            {
                loc3 = new MontgomeryReduction(arg2);
            }
            return bi_internal::exp(arg1, loc3);
        }

        bi_internal function intAt(arg1:String, arg2:int):int
        {
            return parseInt(arg1.charAt(arg2), 36);
        }

        public function testBit(arg1:int):Boolean
        {
            var loc2:*;

            loc2 = Math.floor(arg1 / DB);
            if (loc2 >= t)
            {
                return !(bi_internal::s == 0);
            }
            return !((bi_internal::a[loc2] & 1 << arg1 % DB) == 0);
        }

        bi_internal function exp(arg1:int, arg2:IReduction):com.hurlant.math.BigInteger
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = null;
            if (arg1 > 4294967295 || arg1 < 1)
            {
                return ONE;
            }
            loc3 = nbi();
            loc4 = nbi();
            loc5 = arg2.convert(this);
            loc6 = (bi_internal::nbits(arg1) - 1);
            loc5.bi_internal::copyTo(loc3);
            while (--loc6 >= 0) 
            {
                arg2.sqrTo(loc3, loc4);
                if ((arg1 & 1 << loc6) > 0)
                {
                    arg2.mulTo(loc4, loc5, loc3);
                    continue;
                }
                loc7 = loc3;
                loc3 = loc4;
                loc4 = loc7;
            }
            return arg2.revert(loc3);
        }

        public function toArray(arg1:flash.utils.ByteArray):uint
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = 8;
            loc3 = (1 << 8 - 1);
            loc4 = 0;
            loc5 = t;
            loc6 = DB - loc5 * DB % loc2;
            loc7 = false;
            loc8 = 0;
            if (loc5-- > 0)
            {
                if ((loc6 < DB))
                {
                    loc6 < DB;
                    loc4 = loc9 = bi_internal::a[loc5] >> loc6;
                }
                if (loc6 < DB)
                {
                    loc7 = true;
                    arg1.writeByte(loc4);
                    ++loc8;
                }
                while (loc5 >= 0) 
                {
                    if (loc6 < loc2)
                    {
                        loc6 = loc9 = loc6 + DB - loc2;
                        loc4 = (loc4 = (bi_internal::a[loc5] & (1 << loc6 - 1)) << loc2 - loc6) | bi_internal::a[--loc5] >> loc9;
                    }
                    else 
                    {
                        loc6 = loc9 = loc6 - loc2;
                        loc4 = bi_internal::a[loc5] >> loc9 & loc3;
                        if (loc6 <= 0)
                        {
                            loc6 = loc6 + DB;
                            loc5 = (loc5 - 1);
                        }
                    }
                    if (loc4 > 0)
                    {
                        loc7 = true;
                    }
                    if (!loc7)
                    {
                        continue;
                    }
                    arg1.writeByte(loc4);
                    ++loc8;
                }
            }
            return loc8;
        }

        public function dispose():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = new Random();
            loc2 = 0;
            while (loc2 < bi_internal::a.length) 
            {
                bi_internal::a[loc2] = loc1.nextByte();
                delete bi_internal::a[loc2];
                loc2 = (loc2 + 1);
            }
            bi_internal::a = null;
            t = 0;
            bi_internal::s = 0;
            Memory.gc();
            return;
        }

        private function lbit(arg1:int):int
        {
            var loc2:*;

            if (arg1 == 0)
            {
                return -1;
            }
            loc2 = 0;
            if ((arg1 & 65535) == 0)
            {
                arg1 = arg1 >> 16;
                loc2 = loc2 + 16;
            }
            if ((arg1 & 255) == 0)
            {
                arg1 = arg1 >> 8;
                loc2 = loc2 + 8;
            }
            if ((arg1 & 15) == 0)
            {
                arg1 = arg1 >> 4;
                loc2 = loc2 + 4;
            }
            if ((arg1 & 3) == 0)
            {
                arg1 = arg1 >> 2;
                loc2 = loc2 + 2;
            }
            if ((arg1 & 1) == 0)
            {
                ++loc2;
            }
            return loc2;
        }

        bi_internal function divRemTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger=null, arg3:com.hurlant.math.BigInteger=null):void
        {
            var d1:Number;
            var d2:Number;
            var e:Number;
            var i:int;
            var j:int;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var m:com.hurlant.math.BigInteger;
            var ms:int;
            var nsh:int;
            var pm:com.hurlant.math.BigInteger;
            var pt:com.hurlant.math.BigInteger;
            var q:com.hurlant.math.BigInteger=null;
            var qd:int;
            var r:com.hurlant.math.BigInteger=null;
            var t:com.hurlant.math.BigInteger;
            var ts:int;
            var y:com.hurlant.math.BigInteger;
            var y0:int;
            var ys:int;
            var yt:Number;

            qd = 0;
            m = arg1;
            q = arg2;
            r = arg3;
            pm = m.abs();
            if (pm.t <= 0)
            {
                return;
            }
            pt = abs();
            if (pt.t < pm.t)
            {
                if (q != null)
                {
                    q.bi_internal::fromInt(0);
                }
                if (r != null)
                {
                    bi_internal::copyTo(r);
                }
                return;
            }
            if (r == null)
            {
                r = nbi();
            }
            y = nbi();
            ts = bi_internal::s;
            ms = m.bi_internal::s;
            nsh = DB - bi_internal::nbits(pm.bi_internal::a[(pm.t - 1)]);
            if (nsh > 0)
            {
                pm.bi_internal::lShiftTo(nsh, y);
                pt.bi_internal::lShiftTo(nsh, r);
            }
            else 
            {
                pm.bi_internal::copyTo(y);
                pt.bi_internal::copyTo(r);
            }
            ys = y.t;
            y0 = y.bi_internal::a[(ys - 1)];
            if (y0 == 0)
            {
                return;
            }
            yt = y0 * (1 << F1) + (ys > 1) ? y.bi_internal::a[(ys - 2)] >> F2 : 0;
            d1 = FV / yt;
            d2 = (1 << F1) / yt;
            e = 1 << F2;
            i = r.t;
            j = i - ys;
            t = (q != null) ? q : nbi();
            y.bi_internal::dlShiftTo(j, t);
            if (r.compareTo(t) >= 0)
            {
                loc7 = (((loc6 = r).t) + 1);
                loc6.t = loc7;
                r.bi_internal::a[(loc5 = (loc6 = r).t)] = 1;
                r.bi_internal::subTo(t, r);
            }
            ONE.bi_internal::dlShiftTo(ys, t);
            t.bi_internal::subTo(y, y);
            while (y.t < ys) 
            {
                loc6 = 0;
                loc7 = y;
                loc5 = new XMLList("");
                for each (loc8 in loc7)
                {
                    with (loc9 = loc8)
                    {
                        loc11 = ((loc10 = y).t + 1);
                        loc10.t = loc11;
                        if (0)
                        {
                            loc5[loc6] = loc8;
                        }
                    }
                }
            }
            while ((j = (j - 1)) >= 0) 
            {
                qd = (r.bi_internal::a[(i = (i - 1))] != y0) ? Number(r.bi_internal::a[i]) * d1 + (Number(r.bi_internal::a[(i - 1)]) + e) * d2 : DM;
                r.bi_internal::a[i] = loc5 = r.bi_internal::a[i] + y.bi_internal::am(0, qd, r, j, 0, ys);
                if (!(loc5 < qd))
                {
                    continue;
                }
                y.bi_internal::dlShiftTo(j, t);
                r.bi_internal::subTo(t, r);
                while (r.bi_internal::a[i] < (qd = (qd - 1))) 
                {
                    r.bi_internal::subTo(t, r);
                }
            }
            if (q != null)
            {
                r.bi_internal::drShiftTo(ys, q);
                if (ts != ms)
                {
                    ZERO.bi_internal::subTo(q, q);
                }
            }
            r.t = ys;
            r.bi_internal::clamp();
            if (nsh > 0)
            {
                r.bi_internal::rShiftTo(nsh, r);
            }
            if (ts < 0)
            {
                ZERO.bi_internal::subTo(r, r);
            }
            return;
        }

        public function remainder(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bi_internal::divRemTo(arg1, null, loc2);
            return loc2;
        }

        bi_internal function multiplyUpperTo(arg1:com.hurlant.math.BigInteger, arg2:int, arg3:com.hurlant.math.BigInteger):void
        {
            var loc4:*;
            var loc5:*;

            arg2 = (arg2 - 1);
            arg3.t = loc5 = t + arg1.t - arg2;
            loc4 = loc5;
            arg3.bi_internal::s = 0;
            while (--loc4 >= 0) 
            {
                arg3.bi_internal::a[loc4] = 0;
            }
            loc4 = Math.max(arg2 - t, 0);
            while (loc4 < arg1.t) 
            {
                arg3.bi_internal::a[(t + loc4 - arg2)] = bi_internal::am(arg2 - loc4, arg1.bi_internal::a[loc4], arg3, 0, (0), t + loc4 - arg2);
                ++loc4;
            }
            arg3.bi_internal::clamp();
            arg3.bi_internal::drShiftTo(1, arg3);
            return;
        }

        public function divideAndRemainder(arg1:com.hurlant.math.BigInteger):Array
        {
            var loc2:*;
            var loc3:*;

            loc2 = new BigInteger();
            loc3 = new BigInteger();
            bi_internal::divRemTo(arg1, loc2, loc3);
            return [loc2, loc3];
        }

        public function valueOf():Number
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = 1;
            loc2 = 0;
            loc3 = 0;
            while (loc3 < t) 
            {
                loc2 = loc2 + bi_internal::a[loc3] * loc1;
                loc1 = loc1 * DV;
                loc3 = (loc3 + 1);
            }
            return loc2;
        }

        public function shiftLeft(arg1:int):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            if (arg1 < 0)
            {
                bi_internal::rShiftTo(-arg1, loc2);
            }
            else 
            {
                bi_internal::lShiftTo(arg1, loc2);
            }
            return loc2;
        }

        public function multiply(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bi_internal::multiplyTo(arg1, loc2);
            return loc2;
        }

        bi_internal function am(arg1:int, arg2:int, arg3:com.hurlant.math.BigInteger, arg4:int, arg5:int, arg6:int):int
        {
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc9 = 0;
            loc10 = 0;
            loc11 = 0;
            loc7 = arg2 & 32767;
            loc8 = arg2 >> 15;
            while (--arg6 >= 0) 
            {
                loc9 = bi_internal::a[arg1] & 32767;
                loc10 = bi_internal::a[arg1++] >> 15;
                loc11 = loc8 * loc9 + loc10 * loc7;
                arg5 = ((loc9 = loc7 * loc9 + ((loc11 & 32767) << 15) + arg3.bi_internal::a[arg4] + (arg5 & 1073741823)) >>> 30) + (loc11 >>> 15) + loc8 * loc10 + (arg5 >>> 30);
                arg3.bi_internal::a[(loc12 = arg4++)] = loc9 & 1073741823;
            }
            return arg5;
        }

        bi_internal function drShiftTo(arg1:int, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;

            loc3 = 0;
            loc3 = arg1;
            while (loc3 < t) 
            {
                arg2.bi_internal::a[(loc3 - arg1)] = bi_internal::a[loc3];
                ++loc3;
            }
            arg2.t = Math.max(t - arg1, 0);
            arg2.bi_internal::s = bi_internal::s;
            return;
        }

        public function add(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            addTo(arg1, loc2);
            return loc2;
        }

        protected function nbi():*
        {
            return new BigInteger();
        }

        protected function millerRabin(arg1:int):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = null;
            loc8 = 0;
            loc2 = subtract(BigInteger.ONE);
            loc3 = loc2.getLowestSetBit();
            if (loc3 <= 0)
            {
                return false;
            }
            loc4 = loc2.shiftRight(loc3);
            arg1 = arg1 + 1 >> 1;
            if (arg1 > lowprimes.length)
            {
                arg1 = lowprimes.length;
            }
            loc5 = new BigInteger();
            loc6 = 0;
            while (loc6 < arg1) 
            {
                loc5.bi_internal::fromInt(lowprimes[loc6]);
                if (!((loc7 = loc5.modPow(loc4, this)).compareTo(BigInteger.ONE) == 0) && !(loc7.compareTo(loc2) == 0))
                {
                    loc8 = 1;
                    while (loc8++ < loc3 && !(loc7.compareTo(loc2) == 0)) 
                    {
                        if ((loc7 = loc7.modPowInt(2, this)).compareTo(BigInteger.ONE) != 0)
                        {
                            continue;
                        }
                        return false;
                    }
                    if (loc7.compareTo(loc2) != 0)
                    {
                        return false;
                    }
                }
                ++loc6;
            }
            return true;
        }

        bi_internal function dMultiply(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            bi_internal::a[t] = bi_internal::am(0, (arg1 - 1), this, 0, (0), t);
            t++;
            bi_internal::clamp();
            return;
        }

        private function op_andnot(arg1:int, arg2:int):int
        {
            return arg1 & !arg2;
        }

        bi_internal function clamp():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = bi_internal::s & DM;
            while (t > 0 && bi_internal::a[(t - 1)] == loc1) 
            {
                t--;
            }
            return;
        }

        bi_internal function invDigit():int
        {
            var loc1:*;
            var loc2:*;

            if (t < 1)
            {
                return 0;
            }
            loc1 = bi_internal::a[0];
            if ((loc1 & 1) == 0)
            {
                return 0;
            }
            loc2 = loc1 & 3;
            loc2 = loc2 * (2 - (loc1 & 15) * loc2) & 15;
            loc2 = loc2 * (2 - (loc1 & 255) * loc2) & 255;
            loc2 = loc2 * (2 - ((loc1 & 65535) * loc2 & 65535)) & 65535;
            loc2 = loc2 * (2 - loc1 * loc2 % DV) % DV;
            return (loc2 > 0) ? DV - loc2 : -loc2;
        }

        protected function changeBit(arg1:int, arg2:Function):com.hurlant.math.BigInteger
        {
            var loc3:*;

            loc3 = BigInteger.ONE.shiftLeft(arg1);
            bitwiseTo(loc3, arg2, loc3);
            return loc3;
        }

        public function equals(arg1:com.hurlant.math.BigInteger):Boolean
        {
            return compareTo(arg1) == 0;
        }

        public function compareTo(arg1:com.hurlant.math.BigInteger):int
        {
            var loc2:*;
            var loc3:*;

            loc2 = bi_internal::s - arg1.bi_internal::s;
            if (loc2 != 0)
            {
                return loc2;
            }
            loc3 = t;
            loc2 = loc3 - arg1.t;
            if (loc2 != 0)
            {
                return loc2;
            }
            while (--loc3 >= 0) 
            {
                loc2 = bi_internal::a[loc3] - arg1.bi_internal::a[loc3];
                if (loc2 == 0)
                {
                    continue;
                }
                return loc2;
            }
            return 0;
        }

        public function shiftRight(arg1:int):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            if (arg1 < 0)
            {
                bi_internal::lShiftTo(-arg1, loc2);
            }
            else 
            {
                bi_internal::rShiftTo(arg1, loc2);
            }
            return loc2;
        }

        bi_internal function multiplyTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = abs();
            loc4 = arg1.abs();
            loc5 = loc3.t;
            arg2.t = loc5 + loc4.t;
            while (--loc5 >= 0) 
            {
                arg2.bi_internal::a[loc5] = 0;
            }
            loc5 = 0;
            while (loc5 < loc4.t) 
            {
                arg2.bi_internal::a[(loc5 + loc3.t)] = loc3.bi_internal::am(0, loc4.bi_internal::a[loc5], arg2, loc5, 0, loc3.t);
                ++loc5;
            }
            arg2.bi_internal::s = 0;
            arg2.bi_internal::clamp();
            if (bi_internal::s != arg1.bi_internal::s)
            {
                ZERO.bi_internal::subTo(arg2, arg2);
            }
            return;
        }

        public function bitCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = 0;
            loc2 = bi_internal::s & DM;
            loc3 = 0;
            while (loc3 < t) 
            {
                loc1 = loc1 + cbit(bi_internal::a[loc3] ^ loc2);
                ++loc3;
            }
            return loc1;
        }

        protected function toRadix(arg1:uint=10):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            if (sigNum() == 0 || arg1 < 2 || arg1 > 32)
            {
                return "0";
            }
            loc2 = chunkSize(arg1);
            loc3 = Math.pow(arg1, loc2);
            loc4 = nbv(loc3);
            loc5 = nbi();
            loc6 = nbi();
            loc7 = "";
            bi_internal::divRemTo(loc4, loc5, loc6);
            while (loc5.sigNum() > 0) 
            {
                loc7 = (loc3 + loc6.intValue()).toString(arg1).substr(1) + loc7;
                loc5.bi_internal::divRemTo(loc4, loc5, loc6);
            }
            return loc6.intValue().toString(arg1) + loc7;
        }

        private function cbit(arg1:int):int
        {
            var loc2:*;

            loc2 = 0;
            while (arg1 != 0) 
            {
                arg1 = arg1 & (arg1 - 1);
                loc2 = (loc2 + 1);
            }
            return loc2;
        }

        bi_internal function rShiftTo(arg1:int, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = 0;
            arg2.bi_internal::s = bi_internal::s;
            loc3 = arg1 / DB;
            if (loc3 >= t)
            {
                arg2.t = 0;
                return;
            }
            loc4 = arg1 % DB;
            loc5 = DB - loc4;
            loc6 = (1 << loc4 - 1);
            arg2.bi_internal::a[0] = bi_internal::a[loc3] >> loc4;
            loc7 = loc3 + 1;
            while (loc7 < t) 
            {
                arg2.bi_internal::a[(loc7 - loc3 - 1)] = arg2.bi_internal::a[(loc7 - loc3 - 1)] | (bi_internal::a[loc7] & loc6) << loc5;
                arg2.bi_internal::a[(loc7 - loc3)] = bi_internal::a[loc7] >> loc4;
                ++loc7;
            }
            if (loc4 > 0)
            {
                arg2.bi_internal::a[(t - loc3 - 1)] = arg2.bi_internal::a[(t - loc3 - 1)] | (bi_internal::s & loc6) << loc5;
            }
            arg2.t = t - loc3;
            arg2.bi_internal::clamp();
            return;
        }

        public function modInverse(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = arg1.bi_internal::isEven();
            if (bi_internal::isEven() && loc2 || arg1.sigNum() == 0)
            {
                return BigInteger.ZERO;
            }
            loc3 = arg1.clone();
            loc4 = clone();
            loc5 = nbv(1);
            loc6 = nbv(0);
            loc7 = nbv(0);
            loc8 = nbv(1);
            while (loc3.sigNum() != 0) 
            {
                while (loc3.bi_internal::isEven()) 
                {
                    loc3.bi_internal::rShiftTo(1, loc3);
                    if (loc2)
                    {
                        if (!loc5.bi_internal::isEven() || !loc6.bi_internal::isEven())
                        {
                            loc5.addTo(this, loc5);
                            loc6.bi_internal::subTo(arg1, loc6);
                        }
                        loc5.bi_internal::rShiftTo(1, loc5);
                    }
                    else 
                    {
                        if (!loc6.bi_internal::isEven())
                        {
                            loc6.bi_internal::subTo(arg1, loc6);
                        }
                    }
                    loc6.bi_internal::rShiftTo(1, loc6);
                }
                while (loc4.bi_internal::isEven()) 
                {
                    loc4.bi_internal::rShiftTo(1, loc4);
                    if (loc2)
                    {
                        if (!loc7.bi_internal::isEven() || !loc8.bi_internal::isEven())
                        {
                            loc7.addTo(this, loc7);
                            loc8.bi_internal::subTo(arg1, loc8);
                        }
                        loc7.bi_internal::rShiftTo(1, loc7);
                    }
                    else 
                    {
                        if (!loc8.bi_internal::isEven())
                        {
                            loc8.bi_internal::subTo(arg1, loc8);
                        }
                    }
                    loc8.bi_internal::rShiftTo(1, loc8);
                }
                if (loc3.compareTo(loc4) >= 0)
                {
                    loc3.bi_internal::subTo(loc4, loc3);
                    if (loc2)
                    {
                        loc5.bi_internal::subTo(loc7, loc5);
                    }
                    loc6.bi_internal::subTo(loc8, loc6);
                    continue;
                }
                loc4.bi_internal::subTo(loc3, loc4);
                if (loc2)
                {
                    loc7.bi_internal::subTo(loc5, loc7);
                }
                loc8.bi_internal::subTo(loc6, loc8);
            }
            if (loc4.compareTo(BigInteger.ONE) != 0)
            {
                return BigInteger.ZERO;
            }
            if (loc8.compareTo(arg1) >= 0)
            {
                return loc8.subtract(arg1);
            }
            if (loc8.sigNum() < 0)
            {
                loc8.addTo(arg1, loc8);
            }
            else 
            {
                return loc8;
            }
            if (loc8.sigNum() < 0)
            {
                return loc8.add(arg1);
            }
            return loc8;
        }

        bi_internal function fromArray(arg1:flash.utils.ByteArray, arg2:int):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc7 = 0;
            loc3 = arg1.position;
            loc4 = loc3 + arg2;
            loc5 = 0;
            loc6 = 8;
            t = 0;
            bi_internal::s = 0;
            while (--loc4 >= loc3) 
            {
                loc7 = (loc4 < arg1.length) ? arg1[loc4] : 0;
                if (loc5 != 0)
                {
                    if (loc5 + loc6 > DB)
                    {
                        bi_internal::a[(t - 1)] = bi_internal::a[(t - 1)] | (loc7 & (1 << DB - loc5 - 1)) << loc5;
                        bi_internal::a[(loc8 = t++)] = loc7 >> DB - loc5;
                    }
                    else 
                    {
                        bi_internal::a[(t - 1)] = bi_internal::a[(t - 1)] | loc7 << loc5;
                    }
                }
                else 
                {
                    bi_internal::a[(loc8 = t++)] = loc7;
                }
                if (!((loc5 = loc5 + loc6) >= DB))
                {
                    continue;
                }
                loc5 = loc5 - DB;
            }
            bi_internal::clamp();
            arg1.position = Math.min(loc3 + arg2, arg1.length);
            return;
        }

        bi_internal function copyTo(arg1:com.hurlant.math.BigInteger):void
        {
            var loc2:*;

            loc2 = (t - 1);
            while (loc2 >= 0) 
            {
                arg1.bi_internal::a[loc2] = bi_internal::a[loc2];
                loc2 = (loc2 - 1);
            }
            arg1.t = t;
            arg1.bi_internal::s = bi_internal::s;
            return;
        }

        public function intValue():int
        {
            if (bi_internal::s < 0)
            {
                if (t == 1)
                {
                    return bi_internal::a[0] - DV;
                }
                if (t == 0)
                {
                    return -1;
                }
            }
            else 
            {
                if (t == 1)
                {
                    return bi_internal::a[0];
                }
                if (t == 0)
                {
                    return 0;
                }
            }
            return (bi_internal::a[1] & (1 << 32 - DB - 1)) << DB | bi_internal::a[0];
        }

        public function min(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return (compareTo(arg1) < 0) ? this : arg1;
        }

        public function bitLength():int
        {
            if (t <= 0)
            {
                return 0;
            }
            return DB * (t - 1) + bi_internal::nbits(bi_internal::a[(t - 1)] ^ bi_internal::s & DM);
        }

        public function shortValue():int
        {
            return (t != 0) ? bi_internal::a[0] << 16 >> 16 : bi_internal::s;
        }

        public function and(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bitwiseTo(arg1, op_and, loc2);
            return loc2;
        }

        public function byteValue():int
        {
            return (t != 0) ? bi_internal::a[0] << 24 >> 24 : bi_internal::s;
        }

        public function not():com.hurlant.math.BigInteger
        {
            var loc1:*;
            var loc2:*;

            loc1 = new BigInteger();
            loc2 = 0;
            while (loc2 < t) 
            {
                loc1[loc2] = DM & !bi_internal::a[loc2];
                ++loc2;
            }
            loc1.t = t;
            loc1.bi_internal::s = !bi_internal::s;
            return loc1;
        }

        bi_internal function subTo(arg1:com.hurlant.math.BigInteger, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = Math.min(arg1.t, t);
            while (loc3 < loc5) 
            {
                loc4 = loc4 + bi_internal::a[loc3] - arg1.bi_internal::a[loc3];
                arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                loc4 = loc4 >> DB;
            }
            if (arg1.t < t)
            {
                loc4 = loc4 - arg1.bi_internal::s;
                while (loc3 < t) 
                {
                    loc4 = loc4 + bi_internal::a[loc3];
                    arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                    loc4 = loc4 >> DB;
                }
                loc4 = loc4 + bi_internal::s;
            }
            else 
            {
                loc4 = loc4 + bi_internal::s;
                while (loc3 < arg1.t) 
                {
                    loc4 = loc4 - arg1.bi_internal::a[loc3];
                    arg2.bi_internal::a[(loc6 = loc3++)] = loc4 & DM;
                    loc4 = loc4 >> DB;
                }
                loc4 = loc4 - arg1.bi_internal::s;
            }
            arg2.bi_internal::s = (loc4 < 0) ? -1 : 0;
            if (loc4 < -1)
            {
                arg2.bi_internal::a[(loc6 = loc3++)] = DV + loc4;
            }
            else 
            {
                if (loc4 > 0)
                {
                    arg2.bi_internal::a[(loc6 = loc3++)] = loc4;
                }
            }
            arg2.t = loc3;
            arg2.bi_internal::clamp();
            return;
        }

        public function clone():com.hurlant.math.BigInteger
        {
            var loc1:*;

            loc1 = new BigInteger();
            this.bi_internal::copyTo(loc1);
            return loc1;
        }

        public function pow(arg1:int):com.hurlant.math.BigInteger
        {
            return bi_internal::exp(arg1, new NullReduction());
        }

        public function flipBit(arg1:int):com.hurlant.math.BigInteger
        {
            return changeBit(arg1, op_xor);
        }

        public function xor(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bitwiseTo(arg1, op_xor, loc2);
            return loc2;
        }

        public function or(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            bitwiseTo(arg1, op_or, loc2);
            return loc2;
        }

        public function max(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return (compareTo(arg1) > 0) ? this : arg1;
        }

        bi_internal function fromInt(arg1:int):void
        {
            t = 1;
            bi_internal::s = (arg1 < 0) ? -1 : 0;
            if (arg1 > 0)
            {
                bi_internal::a[0] = arg1;
            }
            else 
            {
                if (arg1 < -1)
                {
                    bi_internal::a[0] = arg1 + DV;
                }
                else 
                {
                    t = 0;
                }
            }
            return;
        }

        bi_internal function isEven():Boolean
        {
            return (t > 0) ? bi_internal::a[0] & 1 : bi_internal::s == 0;
        }

        public function toString(arg1:Number=16):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = 0;
            if (bi_internal::s < 0)
            {
                return "-" + negate().toString(arg1);
            }
            loc9 = arg1;
            switch (loc9) 
            {
                case 2:
                    loc2 = 1;
                    break;
                case 4:
                    loc2 = 2;
                    break;
                case 8:
                    loc2 = 3;
                    break;
                case 16:
                    loc2 = 4;
                    break;
                case 32:
                    loc2 = 5;
                    break;
            }
            loc3 = (1 << loc2 - 1);
            loc4 = 0;
            loc5 = false;
            loc6 = "";
            loc7 = t;
            loc8 = DB - loc7 * DB % loc2;
            if (loc7-- > 0)
            {
                if ((loc8 < DB))
                {
                    loc8 < DB;
                    loc4 = loc9 = bi_internal::a[loc7] >> loc8;
                }
                if (loc8 < DB)
                {
                    loc5 = true;
                    loc6 = loc4.toString(36);
                }
                while (loc7 >= 0) 
                {
                    if (loc8 < loc2)
                    {
                        loc8 = loc9 = loc8 + DB - loc2;
                        loc4 = (loc4 = (bi_internal::a[loc7] & (1 << loc8 - 1)) << loc2 - loc8) | bi_internal::a[--loc7] >> loc9;
                    }
                    else 
                    {
                        loc8 = loc9 = loc8 - loc2;
                        loc4 = bi_internal::a[loc7] >> loc9 & loc3;
                        if (loc8 <= 0)
                        {
                            loc8 = loc8 + DB;
                            loc7 = (loc7 - 1);
                        }
                    }
                    if (loc4 > 0)
                    {
                        loc5 = true;
                    }
                    if (!loc5)
                    {
                        continue;
                    }
                    loc6 = loc6 + loc4.toString(36);
                }
            }
            return loc5 ? loc6 : "0";
        }

        public function setBit(arg1:int):com.hurlant.math.BigInteger
        {
            return changeBit(arg1, op_or);
        }

        public function abs():com.hurlant.math.BigInteger
        {
            return (bi_internal::s < 0) ? negate() : this;
        }

        bi_internal function nbits(arg1:int):int
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc2 = 1;
            loc3 = loc4 = arg1 >>> 16;
            if (loc4 != 0)
            {
                arg1 = loc3;
                loc2 = loc2 + 16;
            }
            loc3 = loc4 = arg1 >> 8;
            if (loc4 != 0)
            {
                arg1 = loc3;
                loc2 = loc2 + 8;
            }
            loc3 = loc4 = arg1 >> 4;
            if (loc4 != 0)
            {
                arg1 = loc3;
                loc2 = loc2 + 4;
            }
            loc3 = loc4 = arg1 >> 2;
            if (loc4 != 0)
            {
                arg1 = loc3;
                loc2 = loc2 + 2;
            }
            loc3 = loc4 = arg1 >> 1;
            if (loc4 != 0)
            {
                arg1 = loc3;
                loc2 = loc2 + 1;
            }
            return loc2;
        }

        public function sigNum():int
        {
            if (bi_internal::s < 0)
            {
                return -1;
            }
            if (t <= 0 || t == 1 && bi_internal::a[0] <= 0)
            {
                return 0;
            }
            return 1;
        }

        public function toByteArray():flash.utils.ByteArray
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = 0;
            loc1 = t;
            loc2 = new ByteArray();
            loc2[0] = bi_internal::s;
            loc3 = DB - loc1 * DB % 8;
            loc5 = 0;
            if (loc1-- > 0)
            {
                if ((loc3 < DB))
                {
                    loc3 < DB;
                    loc4 = loc6 = bi_internal::a[loc1] >> loc3;
                }
                if (loc3 < DB)
                {
                    loc2[(loc6 = loc5++)] = loc4 | bi_internal::s << DB - loc3;
                }
                while (loc1 >= 0) 
                {
                    if (loc3 < 8)
                    {
                        loc3 = loc6 = loc3 + DB - 8;
                        loc4 = (loc4 = (bi_internal::a[loc1] & (1 << loc3 - 1)) << 8 - loc3) | bi_internal::a[--loc1] >> loc6;
                    }
                    else 
                    {
                        loc3 = loc6 = loc3 - 8;
                        loc4 = bi_internal::a[loc1] >> loc6 & 255;
                        if (loc3 <= 0)
                        {
                            loc3 = loc3 + DB;
                            loc1 = (loc1 - 1);
                        }
                    }
                    if ((loc4 & 128) != 0)
                    {
                        loc4 = loc4 | -256;
                    }
                    if (loc5 == 0 && !((bi_internal::s & 128) == (loc4 & 128)))
                    {
                        ++loc5;
                    }
                    if (!(loc5 > 0 || !(loc4 == bi_internal::s)))
                    {
                        continue;
                    }
                    loc2[(loc6 = loc5++)] = loc4;
                }
            }
            return loc2;
        }

        bi_internal function squareTo(arg1:com.hurlant.math.BigInteger):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = 0;
            loc2 = abs();
            arg1.t = loc5 = 2 * loc2.t;
            loc3 = loc5;
            while (--loc3 >= 0) 
            {
                arg1.bi_internal::a[loc3] = 0;
            }
            loc3 = 0;
            while (loc3 < (loc2.t - 1)) 
            {
                loc4 = loc2.bi_internal::am(loc3, loc2.bi_internal::a[loc3], arg1, 2 * loc3, 0, 1);
                arg1.bi_internal::a[(loc3 + loc2.t)] = loc5 = arg1.bi_internal::a[(loc3 + loc2.t)] + loc2.bi_internal::am(loc3 + 1, 2 * loc2.bi_internal::a[loc3], arg1, 2 * loc3 + 1, loc4, (loc2.t - loc3 - 1));
                if (loc5 >= DV)
                {
                    arg1.bi_internal::a[(loc3 + loc2.t)] = arg1.bi_internal::a[(loc3 + loc2.t)] - DV;
                    arg1.bi_internal::a[(loc3 + loc2.t + 1)] = 1;
                }
                ++loc3;
            }
            if (arg1.t > 0)
            {
                arg1.bi_internal::a[(arg1.t - 1)] = arg1.bi_internal::a[(arg1.t - 1)] + loc2.bi_internal::am(loc3, loc2.bi_internal::a[loc3], arg1, 2 * loc3, 0, 1);
            }
            arg1.bi_internal::s = 0;
            arg1.bi_internal::clamp();
            return;
        }

        private function op_and(arg1:int, arg2:int):int
        {
            return arg1 & arg2;
        }

        protected function fromRadix(arg1:String, arg2:int=10):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc9 = 0;
            bi_internal::fromInt(0);
            loc3 = chunkSize(arg2);
            loc4 = Math.pow(arg2, loc3);
            loc5 = false;
            loc6 = 0;
            loc7 = 0;
            loc8 = 0;
            while (loc8 < arg1.length) 
            {
                if ((loc9 = bi_internal::intAt(arg1, loc8)) < 0)
                {
                    if (arg1.charAt(loc8) == "-" && sigNum() == 0)
                    {
                        loc5 = true;
                    }
                }
                else 
                {
                    loc7 = arg2 * loc7 + loc9;
                    if (++loc6 >= loc3)
                    {
                        bi_internal::dMultiply(loc4);
                        bi_internal::dAddOffset(loc7, 0);
                        loc6 = 0;
                        loc7 = 0;
                    }
                }
                ++loc8;
            }
            if (loc6 > 0)
            {
                bi_internal::dMultiply(Math.pow(arg2, loc6));
                bi_internal::dAddOffset(loc7, 0);
            }
            if (loc5)
            {
                BigInteger.ZERO.bi_internal::subTo(this, this);
            }
            return;
        }

        bi_internal function dlShiftTo(arg1:int, arg2:com.hurlant.math.BigInteger):void
        {
            var loc3:*;

            loc3 = 0;
            loc3 = (t - 1);
            while (loc3 >= 0) 
            {
                arg2.bi_internal::a[(loc3 + arg1)] = bi_internal::a[loc3];
                loc3 = (loc3 - 1);
            }
            loc3 = (arg1 - 1);
            while (loc3 >= 0) 
            {
                arg2.bi_internal::a[loc3] = 0;
                loc3 = (loc3 - 1);
            }
            arg2.t = t + arg1;
            arg2.bi_internal::s = bi_internal::s;
            return;
        }

        private function op_xor(arg1:int, arg2:int):int
        {
            return arg1 ^ arg2;
        }

        public static function nbv(arg1:int):com.hurlant.math.BigInteger
        {
            var loc2:*;

            loc2 = new BigInteger();
            loc2.bi_internal::fromInt(arg1);
            return loc2;
        }

        public static const ONE:com.hurlant.math.BigInteger=nbv(1);

        public static const ZERO:com.hurlant.math.BigInteger=nbv(0);

        public static const DM:int=(DV - 1);

        public static const F1:int=BI_FP - DB;

        public static const F2:int=2 * DB - BI_FP;

        public static const lplim:int=(1 << 26) / lowprimes[(lowprimes.length - 1)];

        public static const lowprimes:Array=[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];

        public static const FV:Number=Math.pow(2, BI_FP);

        public static const BI_FP:int=52;

        public static const DV:int=1 << DB;

        public static const DB:int=30;

        bi_internal var a:Array;

        bi_internal var s:int;

        public var t:int;
    }
}
