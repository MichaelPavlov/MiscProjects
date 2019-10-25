package com.hurlant.crypto.hash 
{
    import flash.utils.*;
    
    public class MD5 extends Object implements com.hurlant.crypto.hash.IHash
    {
        public function MD5()
        {
            super();
            return;
        }

        private function ff(arg1:uint, arg2:uint, arg3:uint, arg4:uint, arg5:uint, arg6:uint, arg7:uint):uint
        {
            return cmn(arg2 & arg3 | !arg2 & arg4, arg1, arg2, arg5, arg6, arg7);
        }

        private function cmn(arg1:uint, arg2:uint, arg3:uint, arg4:uint, arg5:uint, arg6:uint):uint
        {
            return rol(arg2 + arg1 + arg4 + arg6, arg5) + arg3;
        }

        private function hh(arg1:uint, arg2:uint, arg3:uint, arg4:uint, arg5:uint, arg6:uint, arg7:uint):uint
        {
            return cmn(arg2 ^ arg3 ^ arg4, arg1, arg2, arg5, arg6, arg7);
        }

        public function getHashSize():uint
        {
            return HASH_SIZE;
        }

        public function hash(arg1:flash.utils.ByteArray):flash.utils.ByteArray
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = arg1.length * 8;
            loc3 = arg1.endian;
            while (arg1.length % 4 != 0) 
            {
                arg1[arg1.length] = 0;
            }
            arg1.position = 0;
            loc4 = [];
            arg1.endian = Endian.LITTLE_ENDIAN;
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                loc4.push(arg1.readUnsignedInt());
                loc5 = loc5 + 4;
            }
            loc6 = core_md5(loc4, loc2);
            (loc7 = new ByteArray()).endian = Endian.LITTLE_ENDIAN;
            loc5 = 0;
            while (loc5 < 4) 
            {
                loc7.writeUnsignedInt(loc6[loc5]);
                loc5 = (loc5 + 1);
            }
            arg1.length = loc2 / 8;
            arg1.endian = loc3;
            return loc7;
        }

        private function gg(arg1:uint, arg2:uint, arg3:uint, arg4:uint, arg5:uint, arg6:uint, arg7:uint):uint
        {
            return cmn(arg2 & arg4 | arg3 & !arg4, arg1, arg2, arg5, arg6, arg7);
        }

        public function toString():String
        {
            return "md5";
        }

        public function getInputSize():uint
        {
            return 64;
        }

        private function rol(arg1:uint, arg2:uint):uint
        {
            return arg1 << arg2 | arg1 >>> 32 - arg2;
        }

        private function ii(arg1:uint, arg2:uint, arg3:uint, arg4:uint, arg5:uint, arg6:uint, arg7:uint):uint
        {
            return cmn(arg3 ^ (arg2 | !arg4), arg1, arg2, arg5, arg6, arg7);
        }

        private function core_md5(arg1:Array, arg2:uint):Array
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

            loc8 = 0;
            loc9 = 0;
            loc10 = 0;
            loc11 = 0;
            arg1[(arg2 >> 5)] = arg1[(arg2 >> 5)] | 128 << arg2 % 32;
            arg1[((arg2 + 64 >>> 9 << 4) + 14)] = arg2;
            loc3 = 1732584193;
            loc4 = 4023233417;
            loc5 = 2562383102;
            loc6 = 271733878;
            loc7 = 0;
            while (loc7 < arg1.length) 
            {
                arg1[loc7] = arg1[loc7] || 0;
                arg1[(loc7 + 1)] = arg1[(loc7 + 1)] || 0;
                arg1[(loc7 + 2)] = arg1[(loc7 + 2)] || 0;
                arg1[(loc7 + 3)] = arg1[(loc7 + 3)] || 0;
                arg1[(loc7 + 4)] = arg1[(loc7 + 4)] || 0;
                arg1[(loc7 + 5)] = arg1[(loc7 + 5)] || 0;
                arg1[(loc7 + 6)] = arg1[(loc7 + 6)] || 0;
                arg1[(loc7 + 7)] = arg1[(loc7 + 7)] || 0;
                arg1[(loc7 + 8)] = arg1[(loc7 + 8)] || 0;
                arg1[(loc7 + 9)] = arg1[(loc7 + 9)] || 0;
                arg1[(loc7 + 10)] = arg1[(loc7 + 10)] || 0;
                arg1[(loc7 + 11)] = arg1[(loc7 + 11)] || 0;
                arg1[(loc7 + 12)] = arg1[(loc7 + 12)] || 0;
                arg1[(loc7 + 13)] = arg1[(loc7 + 13)] || 0;
                arg1[(loc7 + 14)] = arg1[(loc7 + 14)] || 0;
                arg1[(loc7 + 15)] = arg1[(loc7 + 15)] || 0;
                loc8 = loc3;
                loc9 = loc4;
                loc10 = loc5;
                loc11 = loc6;
                loc3 = ff(loc3, loc4, loc5, loc6, arg1[(loc7 + 0)], 7, 3614090360);
                loc6 = ff(loc6, loc3, loc4, loc5, arg1[(loc7 + 1)], 12, 3905402710);
                loc5 = ff(loc5, loc6, loc3, loc4, arg1[(loc7 + 2)], 17, 606105819);
                loc4 = ff(loc4, loc5, loc6, loc3, arg1[(loc7 + 3)], 22, 3250441966);
                loc3 = ff(loc3, loc4, loc5, loc6, arg1[(loc7 + 4)], 7, 4118548399);
                loc6 = ff(loc6, loc3, loc4, loc5, arg1[(loc7 + 5)], 12, 1200080426);
                loc5 = ff(loc5, loc6, loc3, loc4, arg1[(loc7 + 6)], 17, 2821735955);
                loc4 = ff(loc4, loc5, loc6, loc3, arg1[(loc7 + 7)], 22, 4249261313);
                loc3 = ff(loc3, loc4, loc5, loc6, arg1[(loc7 + 8)], 7, 1770035416);
                loc6 = ff(loc6, loc3, loc4, loc5, arg1[(loc7 + 9)], 12, 2336552879);
                loc5 = ff(loc5, loc6, loc3, loc4, arg1[(loc7 + 10)], 17, 4294925233);
                loc4 = ff(loc4, loc5, loc6, loc3, arg1[(loc7 + 11)], 22, 2304563134);
                loc3 = ff(loc3, loc4, loc5, loc6, arg1[(loc7 + 12)], 7, 1804603682);
                loc6 = ff(loc6, loc3, loc4, loc5, arg1[(loc7 + 13)], 12, 4254626195);
                loc5 = ff(loc5, loc6, loc3, loc4, arg1[(loc7 + 14)], 17, 2792965006);
                loc4 = ff(loc4, loc5, loc6, loc3, arg1[(loc7 + 15)], 22, 1236535329);
                loc3 = gg(loc3, loc4, loc5, loc6, arg1[(loc7 + 1)], 5, 4129170786);
                loc6 = gg(loc6, loc3, loc4, loc5, arg1[(loc7 + 6)], 9, 3225465664);
                loc5 = gg(loc5, loc6, loc3, loc4, arg1[(loc7 + 11)], 14, 643717713);
                loc4 = gg(loc4, loc5, loc6, loc3, arg1[(loc7 + 0)], 20, 3921069994);
                loc3 = gg(loc3, loc4, loc5, loc6, arg1[(loc7 + 5)], 5, 3593408605);
                loc6 = gg(loc6, loc3, loc4, loc5, arg1[(loc7 + 10)], 9, 38016083);
                loc5 = gg(loc5, loc6, loc3, loc4, arg1[(loc7 + 15)], 14, 3634488961);
                loc4 = gg(loc4, loc5, loc6, loc3, arg1[(loc7 + 4)], 20, 3889429448);
                loc3 = gg(loc3, loc4, loc5, loc6, arg1[(loc7 + 9)], 5, 568446438);
                loc6 = gg(loc6, loc3, loc4, loc5, arg1[(loc7 + 14)], 9, 3275163606);
                loc5 = gg(loc5, loc6, loc3, loc4, arg1[(loc7 + 3)], 14, 4107603335);
                loc4 = gg(loc4, loc5, loc6, loc3, arg1[(loc7 + 8)], 20, 1163531501);
                loc3 = gg(loc3, loc4, loc5, loc6, arg1[(loc7 + 13)], 5, 2850285829);
                loc6 = gg(loc6, loc3, loc4, loc5, arg1[(loc7 + 2)], 9, 4243563512);
                loc5 = gg(loc5, loc6, loc3, loc4, arg1[(loc7 + 7)], 14, 1735328473);
                loc4 = gg(loc4, loc5, loc6, loc3, arg1[(loc7 + 12)], 20, 2368359562);
                loc3 = hh(loc3, loc4, loc5, loc6, arg1[(loc7 + 5)], 4, 4294588738);
                loc6 = hh(loc6, loc3, loc4, loc5, arg1[(loc7 + 8)], 11, 2272392833);
                loc5 = hh(loc5, loc6, loc3, loc4, arg1[(loc7 + 11)], 16, 1839030562);
                loc4 = hh(loc4, loc5, loc6, loc3, arg1[(loc7 + 14)], 23, 4259657740);
                loc3 = hh(loc3, loc4, loc5, loc6, arg1[(loc7 + 1)], 4, 2763975236);
                loc6 = hh(loc6, loc3, loc4, loc5, arg1[(loc7 + 4)], 11, 1272893353);
                loc5 = hh(loc5, loc6, loc3, loc4, arg1[(loc7 + 7)], 16, 4139469664);
                loc4 = hh(loc4, loc5, loc6, loc3, arg1[(loc7 + 10)], 23, 3200236656);
                loc3 = hh(loc3, loc4, loc5, loc6, arg1[(loc7 + 13)], 4, 681279174);
                loc6 = hh(loc6, loc3, loc4, loc5, arg1[(loc7 + 0)], 11, 3936430074);
                loc5 = hh(loc5, loc6, loc3, loc4, arg1[(loc7 + 3)], 16, 3572445317);
                loc4 = hh(loc4, loc5, loc6, loc3, arg1[(loc7 + 6)], 23, 76029189);
                loc3 = hh(loc3, loc4, loc5, loc6, arg1[(loc7 + 9)], 4, 3654602809);
                loc6 = hh(loc6, loc3, loc4, loc5, arg1[(loc7 + 12)], 11, 3873151461);
                loc5 = hh(loc5, loc6, loc3, loc4, arg1[(loc7 + 15)], 16, 530742520);
                loc4 = hh(loc4, loc5, loc6, loc3, arg1[(loc7 + 2)], 23, 3299628645);
                loc3 = ii(loc3, loc4, loc5, loc6, arg1[(loc7 + 0)], 6, 4096336452);
                loc6 = ii(loc6, loc3, loc4, loc5, arg1[(loc7 + 7)], 10, 1126891415);
                loc5 = ii(loc5, loc6, loc3, loc4, arg1[(loc7 + 14)], 15, 2878612391);
                loc4 = ii(loc4, loc5, loc6, loc3, arg1[(loc7 + 5)], 21, 4237533241);
                loc3 = ii(loc3, loc4, loc5, loc6, arg1[(loc7 + 12)], 6, 1700485571);
                loc6 = ii(loc6, loc3, loc4, loc5, arg1[(loc7 + 3)], 10, 2399980690);
                loc5 = ii(loc5, loc6, loc3, loc4, arg1[(loc7 + 10)], 15, 4293915773);
                loc4 = ii(loc4, loc5, loc6, loc3, arg1[(loc7 + 1)], 21, 2240044497);
                loc3 = ii(loc3, loc4, loc5, loc6, arg1[(loc7 + 8)], 6, 1873313359);
                loc6 = ii(loc6, loc3, loc4, loc5, arg1[(loc7 + 15)], 10, 4264355552);
                loc5 = ii(loc5, loc6, loc3, loc4, arg1[(loc7 + 6)], 15, 2734768916);
                loc4 = ii(loc4, loc5, loc6, loc3, arg1[(loc7 + 13)], 21, 1309151649);
                loc3 = ii(loc3, loc4, loc5, loc6, arg1[(loc7 + 4)], 6, 4149444226);
                loc6 = ii(loc6, loc3, loc4, loc5, arg1[(loc7 + 11)], 10, 3174756917);
                loc5 = ii(loc5, loc6, loc3, loc4, arg1[(loc7 + 2)], 15, 718787259);
                loc4 = ii(loc4, loc5, loc6, loc3, arg1[(loc7 + 9)], 21, 3951481745);
                loc3 = loc3 + loc8;
                loc4 = loc4 + loc9;
                loc5 = loc5 + loc10;
                loc6 = loc6 + loc11;
                loc7 = loc7 + 16;
            }
            return [loc3, loc4, loc5, loc6];
        }

        public static const HASH_SIZE:int=16;
    }
}
