package com.hurlant.crypto.hash 
{
    public class SHA256 extends com.hurlant.crypto.hash.SHABase implements com.hurlant.crypto.hash.IHash
    {
        public function SHA256()
        {
            h = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225];
            super();
            return;
        }

        public override function toString():String
        {
            return "sha256";
        }

        public override function getHashSize():uint
        {
            return 32;
        }

        protected function rrol(arg1:uint, arg2:uint):uint
        {
            return arg1 << 32 - arg2 | arg1 >>> arg2;
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
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;
            var loc24:*;
            var loc25:*;

            loc13 = 0;
            loc14 = 0;
            loc15 = 0;
            loc16 = 0;
            loc17 = 0;
            loc18 = 0;
            loc19 = 0;
            loc20 = 0;
            loc21 = 0;
            loc22 = 0;
            loc23 = 0;
            loc24 = 0;
            loc25 = 0;
            arg1[(arg2 >> 5)] = arg1[(arg2 >> 5)] | 128 << 24 - arg2 % 32;
            arg1[((arg2 + 64 >> 9 << 4) + 15)] = arg2;
            loc3 = [];
            loc4 = h[0];
            loc5 = h[1];
            loc6 = h[2];
            loc7 = h[3];
            loc8 = h[4];
            loc9 = h[5];
            loc10 = h[6];
            loc11 = h[7];
            loc12 = 0;
            while (loc12 < arg1.length) 
            {
                loc13 = loc4;
                loc14 = loc5;
                loc15 = loc6;
                loc16 = loc7;
                loc17 = loc8;
                loc18 = loc9;
                loc19 = loc10;
                loc20 = loc11;
                loc21 = 0;
                while (loc21 < 64) 
                {
                    if (loc21 < 16)
                    {
                        loc3[loc21] = arg1[(loc12 + loc21)] || 0;
                    }
                    else 
                    {
                        loc24 = rrol(loc3[(loc21 - 15)], 7) ^ rrol(loc3[(loc21 - 15)], 18) ^ loc3[(loc21 - 15)] >>> 3;
                        loc25 = rrol(loc3[(loc21 - 2)], 17) ^ rrol(loc3[(loc21 - 2)], 19) ^ loc3[(loc21 - 2)] >>> 10;
                        loc3[loc21] = loc3[(loc21 - 16)] + loc24 + loc3[(loc21 - 7)] + loc25;
                    }
                    loc22 = (rrol(loc4, 2) ^ rrol(loc4, 13) ^ rrol(loc4, 22)) + (loc4 & loc5 ^ loc4 & loc6 ^ loc5 & loc6);
                    loc23 = loc11 + (rrol(loc8, 6) ^ rrol(loc8, 11) ^ rrol(loc8, 25)) + (loc8 & loc9 ^ loc10 & !loc8) + k[loc21] + loc3[loc21];
                    loc11 = loc10;
                    loc10 = loc9;
                    loc9 = loc8;
                    loc8 = loc7 + loc23;
                    loc7 = loc6;
                    loc6 = loc5;
                    loc5 = loc4;
                    loc4 = loc23 + loc22;
                    loc21 = (loc21 + 1);
                }
                loc4 = loc4 + loc13;
                loc5 = loc5 + loc14;
                loc6 = loc6 + loc15;
                loc7 = loc7 + loc16;
                loc8 = loc8 + loc17;
                loc9 = loc9 + loc18;
                loc10 = loc10 + loc19;
                loc11 = loc11 + loc20;
                loc12 = loc12 + 16;
            }
            return [loc4, loc5, loc6, loc7, loc8, loc9, loc10, loc11];
        }

        protected static const k:Array=[1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298];

        protected var h:Array;
    }
}
