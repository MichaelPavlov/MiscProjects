package com.hurlant.crypto.hash 
{
    public class SHA1 extends com.hurlant.crypto.hash.SHABase implements com.hurlant.crypto.hash.IHash
    {
        public function SHA1()
        {
            super();
            return;
        }

        public override function toString():String
        {
            return "sha1";
        }

        protected override function core(arg1:Array, arg2:uint):Array
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

            loc10 = 0;
            loc11 = 0;
            loc12 = 0;
            loc13 = 0;
            loc14 = 0;
            loc15 = 0;
            loc16 = 0;
            arg1[(arg2 >> 5)] = arg1[(arg2 >> 5)] | 128 << 24 - arg2 % 32;
            arg1[((arg2 + 64 >> 9 << 4) + 15)] = arg2;
            loc3 = [];
            loc4 = 1732584193;
            loc5 = 4023233417;
            loc6 = 2562383102;
            loc7 = 271733878;
            loc8 = 3285377520;
            loc9 = 0;
            while (loc9 < arg1.length) 
            {
                loc10 = loc4;
                loc11 = loc5;
                loc12 = loc6;
                loc13 = loc7;
                loc14 = loc8;
                loc15 = 0;
                while (loc15 < 80) 
                {
                    if (loc15 < 16)
                    {
                        loc3[loc15] = arg1[(loc9 + loc15)] || 0;
                    }
                    else 
                    {
                        loc3[loc15] = rol(loc3[(loc15 - 3)] ^ loc3[(loc15 - 8)] ^ loc3[(loc15 - 14)] ^ loc3[(loc15 - 16)], 1);
                    }
                    loc16 = rol(loc4, 5) + ft(loc15, loc5, loc6, loc7) + loc8 + loc3[loc15] + kt(loc15);
                    loc8 = loc7;
                    loc7 = loc6;
                    loc6 = rol(loc5, 30);
                    loc5 = loc4;
                    loc4 = loc16;
                    loc15 = (loc15 + 1);
                }
                loc4 = loc4 + loc10;
                loc5 = loc5 + loc11;
                loc6 = loc6 + loc12;
                loc7 = loc7 + loc13;
                loc8 = loc8 + loc14;
                loc9 = loc9 + 16;
            }
            return [loc4, loc5, loc6, loc7, loc8];
        }

        private function kt(arg1:uint):uint
        {
            return (arg1 < 20) ? 1518500249 : (arg1 < 40) ? 1859775393 : (arg1 < 60) ? 2400959708 : 3395469782;
        }

        public override function getHashSize():uint
        {
            return HASH_SIZE;
        }

        private function ft(arg1:uint, arg2:uint, arg3:uint, arg4:uint):uint
        {
            if (arg1 < 20)
            {
                return arg2 & arg3 | !arg2 & arg4;
            }
            if (arg1 < 40)
            {
                return arg2 ^ arg3 ^ arg4;
            }
            if (arg1 < 60)
            {
                return arg2 & arg3 | arg2 & arg4 | arg3 & arg4;
            }
            return arg2 ^ arg3 ^ arg4;
        }

        private function rol(arg1:uint, arg2:uint):uint
        {
            return arg1 << arg2 | arg1 >>> 32 - arg2;
        }

        public static const HASH_SIZE:int=20;
    }
}
