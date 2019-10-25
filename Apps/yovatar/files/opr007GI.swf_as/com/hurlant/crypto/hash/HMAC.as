package com.hurlant.crypto.hash 
{
    import flash.utils.*;
    
    public class HMAC extends Object
    {
        public function HMAC(arg1:com.hurlant.crypto.hash.IHash, arg2:uint=0)
        {
            super();
            this.hash = arg1;
            this.bits = arg2;
            return;
        }

        public function toString():String
        {
            return "hmac-" + (bits > 0) ? bits + "-" : "" + hash.toString();
        }

        public function getHashSize():uint
        {
            if (bits != 0)
            {
                return bits / 8;
            }
            return hash.getHashSize();
        }

        public function compute(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray):flash.utils.ByteArray
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = null;
            if (arg1.length > hash.getInputSize())
            {
                loc3 = hash.hash(arg1);
            }
            else 
            {
                loc3 = new ByteArray();
                loc3.writeBytes(arg1);
            }
            while (loc3.length < hash.getInputSize()) 
            {
                loc3[loc3.length] = 0;
            }
            loc4 = new ByteArray();
            loc5 = new ByteArray();
            loc6 = 0;
            while (loc6 < loc3.length) 
            {
                loc4[loc6] = loc3[loc6] ^ 54;
                loc5[loc6] = loc3[loc6] ^ 92;
                loc6 = (loc6 + 1);
            }
            loc4.position = loc3.length;
            loc4.writeBytes(arg2);
            loc7 = hash.hash(loc4);
            loc5.position = loc3.length;
            loc5.writeBytes(loc7);
            loc8 = hash.hash(loc5);
            if (bits > 0 && bits < 8 * loc8.length)
            {
                loc8.length = bits / 8;
            }
            return loc8;
        }

        public function dispose():void
        {
            hash = null;
            bits = 0;
            return;
        }

        private var bits:uint;

        private var hash:com.hurlant.crypto.hash.IHash;
    }
}
