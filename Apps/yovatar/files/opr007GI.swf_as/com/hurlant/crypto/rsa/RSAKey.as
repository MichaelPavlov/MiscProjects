package com.hurlant.crypto.rsa 
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.math.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class RSAKey extends Object
    {
        public function RSAKey(arg1:com.hurlant.math.BigInteger, arg2:int, arg3:com.hurlant.math.BigInteger=null, arg4:com.hurlant.math.BigInteger=null, arg5:com.hurlant.math.BigInteger=null, arg6:com.hurlant.math.BigInteger=null, arg7:com.hurlant.math.BigInteger=null, arg8:com.hurlant.math.BigInteger=null)
        {
            super();
            this.n = arg1;
            this.e = arg2;
            this.d = arg3;
            this.p = arg4;
            this.q = arg5;
            this.dmp1 = arg6;
            this.dmq1 = arg7;
            this.coeff = arg8;
            canEncrypt = !(n == null) && !(e == 0);
            canDecrypt = canEncrypt && !(d == null);
            return;
        }

        public function verify(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray, arg3:uint, arg4:Function=null):void
        {
            _decrypt(doPublic, arg1, arg2, arg3, arg4, 1);
            return;
        }

        protected function doPrivate2(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            if (p == null && q == null)
            {
                return arg1.modPow(d, n);
            }
            loc2 = arg1.mod(p).modPow(dmp1, p);
            loc3 = arg1.mod(q).modPow(dmq1, q);
            while (loc2.compareTo(loc3) < 0) 
            {
                loc2 = loc2.add(p);
            }
            return loc4 = loc2.subtract(loc3).multiply(coeff).mod(p).multiply(q).add(loc3);
        }

        public function dump():String
        {
            var loc1:*;

            loc1 = "N=" + n.toString(16) + "\n" + "E=" + e.toString(16) + "\n";
            if (canDecrypt)
            {
                loc1 = loc1 + "D=" + d.toString(16) + "\n";
                if (!(p == null) && !(q == null))
                {
                    loc1 = loc1 + "P=" + p.toString(16) + "\n";
                    loc1 = loc1 + "Q=" + q.toString(16) + "\n";
                    loc1 = loc1 + "DMP1=" + dmp1.toString(16) + "\n";
                    loc1 = loc1 + "DMQ1=" + dmq1.toString(16) + "\n";
                    loc1 = loc1 + "IQMP=" + coeff.toString(16) + "\n";
                }
            }
            return loc1;
        }

        public function decrypt(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray, arg3:uint, arg4:Function=null):void
        {
            _decrypt(doPrivate2, arg1, arg2, arg3, arg4, 2);
            return;
        }

        private function _decrypt(arg1:Function, arg2:flash.utils.ByteArray, arg3:flash.utils.ByteArray, arg4:uint, arg5:Function, arg6:int):void
        {
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc9 = null;
            loc10 = null;
            loc11 = null;
            if (arg5 == null)
            {
                arg5 = pkcs1unpad;
            }
            if (arg2.position >= arg2.length)
            {
                arg2.position = 0;
            }
            loc7 = getBlockSize();
            loc8 = arg2.position + arg4;
            while (arg2.position < loc8) 
            {
                loc9 = new BigInteger(arg2, arg4);
                loc10 = arg1(loc9);
                loc11 = arg5(loc10, loc7);
                arg3.writeBytes(loc11);
            }
            return;
        }

        protected function doPublic(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            return arg1.modPowInt(e, n);
        }

        public function dispose():void
        {
            e = 0;
            n.dispose();
            n = null;
            Memory.gc();
            return;
        }

        private function _encrypt(arg1:Function, arg2:flash.utils.ByteArray, arg3:flash.utils.ByteArray, arg4:uint, arg5:Function, arg6:int):void
        {
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc9 = null;
            loc10 = null;
            if (arg5 == null)
            {
                arg5 = pkcs1pad;
            }
            if (arg2.position >= arg2.length)
            {
                arg2.position = 0;
            }
            loc7 = getBlockSize();
            loc8 = arg2.position + arg4;
            while (arg2.position < loc8) 
            {
                loc9 = new BigInteger(arg5(arg2, loc8, loc7, arg6), loc7);
                (loc10 = arg1(loc9)).toArray(arg3);
            }
            return;
        }

        private function rawpad(arg1:flash.utils.ByteArray, arg2:int, arg3:uint):flash.utils.ByteArray
        {
            return arg1;
        }

        public function encrypt(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray, arg3:uint, arg4:Function=null):void
        {
            _encrypt(doPublic, arg1, arg2, arg3, arg4, 2);
            return;
        }

        private function pkcs1pad(arg1:flash.utils.ByteArray, arg2:int, arg3:uint, arg4:uint=2):flash.utils.ByteArray
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc9 = 0;
            loc5 = new ByteArray();
            loc6 = arg1.position;
            arg2 = Math.min(arg2, arg1.length, loc6 + arg3 - 11);
            arg1.position = arg2;
            loc7 = (arg2 - 1);
            while (loc7 >= loc6 && arg3 > 11) 
            {
                loc5[(loc10 = --arg3)] = arg1[loc7--];
            }
            loc5[(loc10 = --arg3)] = 0;
            loc8 = new Random();
            while (arg3 > 2) 
            {
                loc9 = 0;
                while (loc9 == 0) 
                {
                    loc9 = (arg4 != 2) ? 255 : loc8.nextByte();
                }
                loc5[(loc11 = --arg3)] = loc9;
            }
            loc5[(loc11 = --arg3)] = arg4;
            loc5[(loc12 = --arg3)] = 0;
            return loc5;
        }

        private function pkcs1unpad(arg1:com.hurlant.math.BigInteger, arg2:uint, arg3:uint=2):flash.utils.ByteArray
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = arg1.toByteArray();
            loc5 = new ByteArray();
            loc6 = 0;
            while (loc6 < loc4.length && loc4[loc6] == 0) 
            {
                ++loc6;
            }
            if (!(loc4.length - loc6 == (arg2 - 1)) || loc4[loc6] > 2)
            {
                trace("PKCS#1 unpad: i=" + loc6 + ", expected b[i]==[0,1,2], got b[i]=" + loc4[loc6].toString(16));
                return null;
            }
            ++loc6;
            while (loc4[loc6] != 0) 
            {
                if (!(++loc6 >= loc4.length))
                {
                    continue;
                }
                trace("PKCS#1 unpad: i=" + loc6 + ", b[i-1]!=0 (=" + loc4[(loc6 - 1)].toString(16) + ")");
                return null;
            }
            while (++loc6 < loc4.length) 
            {
                loc5.writeByte(loc4[loc6]);
            }
            loc5.position = 0;
            return loc5;
        }

        public function getBlockSize():uint
        {
            return (n.bitLength() + 7) / 8;
        }

        public function toString():String
        {
            return "rsa";
        }

        public function sign(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray, arg3:uint, arg4:Function=null):void
        {
            _encrypt(doPrivate2, arg1, arg2, arg3, arg4, 1);
            return;
        }

        protected function doPrivate(arg1:com.hurlant.math.BigInteger):com.hurlant.math.BigInteger
        {
            var loc2:*;
            var loc3:*;

            if (p == null || q == null)
            {
                return arg1.modPow(d, n);
            }
            loc2 = arg1.mod(p).modPow(dmp1, p);
            loc3 = arg1.mod(q).modPow(dmq1, q);
            while (loc2.compareTo(loc3) < 0) 
            {
                loc2 = loc2.add(p);
            }
            return loc2.subtract(loc3).multiply(coeff).mod(p).multiply(q).add(loc3);
        }

        protected static function bigRandom(arg1:int, arg2:com.hurlant.crypto.prng.Random):com.hurlant.math.BigInteger
        {
            var loc3:*;
            var loc4:*;

            if (arg1 < 2)
            {
                return BigInteger.nbv(1);
            }
            loc3 = new ByteArray();
            arg2.nextBytes(loc3, arg1 >> 3);
            loc3.position = 0;
            (loc4 = new BigInteger(loc3)).primify(arg1, 1);
            return loc4;
        }

        public static function parsePublicKey(arg1:String, arg2:String):com.hurlant.crypto.rsa.RSAKey
        {
            return new RSAKey(new BigInteger(arg1, 16), parseInt(arg2, 16));
        }

        public static function generate(arg1:uint, arg2:String):com.hurlant.crypto.rsa.RSAKey
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc3 = new Random();
            loc4 = arg1 >> 1;
            (loc5 = new RSAKey(null, 0, null)).e = parseInt(arg2, 16);
            loc6 = new BigInteger(arg2, 16);
            for (;;) 
            {
                for (;;) 
                {
                    loc5.p = bigRandom(arg1 - loc4, loc3);
                    if (!(loc5.p.subtract(BigInteger.ONE).gcd(loc6).compareTo(BigInteger.ONE) == 0 && loc5.p.isProbablePrime(10)))
                    {
                        continue;
                    }
                    break;
                }
                for (;;) 
                {
                    loc5.q = bigRandom(loc4, loc3);
                    if (!(loc5.q.subtract(BigInteger.ONE).gcd(loc6).compareTo(BigInteger.ONE) == 0 && loc5.q.isProbablePrime(10)))
                    {
                        continue;
                    }
                    break;
                }
                if (loc5.p.compareTo(loc5.q) <= 0)
                {
                    loc10 = loc5.p;
                    loc5.p = loc5.q;
                    loc5.q = loc10;
                }
                loc7 = loc5.p.subtract(BigInteger.ONE);
                loc8 = loc5.q.subtract(BigInteger.ONE);
                if ((loc9 = loc7.multiply(loc8)).gcd(loc6).compareTo(BigInteger.ONE) != 0)
                {
                    continue;
                }
                loc5.n = loc5.p.multiply(loc5.q);
                loc5.d = loc6.modInverse(loc9);
                loc5.dmp1 = loc5.d.mod(loc7);
                loc5.dmq1 = loc5.d.mod(loc8);
                loc5.coeff = loc5.q.modInverse(loc5.p);
                break;
            }
            return loc5;
        }

        public static function parsePrivateKey(arg1:String, arg2:String, arg3:String, arg4:String=null, arg5:String=null, arg6:String=null, arg7:String=null, arg8:String=null):com.hurlant.crypto.rsa.RSAKey
        {
            if (arg4 == null)
            {
                return new RSAKey(new BigInteger(arg1, 16), parseInt(arg2, 16), new BigInteger(arg3, 16));
            }
            return new RSAKey(new BigInteger(arg1, 16), parseInt(arg2, 16), new BigInteger(arg3, 16), new BigInteger(arg4, 16), new BigInteger(arg5, 16), new BigInteger(arg6, 16), new BigInteger(arg7), new BigInteger(arg8));
        }

        public var dmp1:com.hurlant.math.BigInteger;

        protected var canDecrypt:Boolean;

        public var d:com.hurlant.math.BigInteger;

        public var e:int;

        public var dmq1:com.hurlant.math.BigInteger;

        public var n:com.hurlant.math.BigInteger;

        public var p:com.hurlant.math.BigInteger;

        public var q:com.hurlant.math.BigInteger;

        protected var canEncrypt:Boolean;

        public var coeff:com.hurlant.math.BigInteger;
    }
}
