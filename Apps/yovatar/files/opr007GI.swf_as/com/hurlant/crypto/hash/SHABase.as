package com.hurlant.crypto.hash 
{
    import flash.utils.*;
    
    public class SHABase extends Object implements com.hurlant.crypto.hash.IHash
    {
        public function SHABase()
        {
            super();
            return;
        }

        public function toString():String
        {
            return "sha";
        }

        public function getInputSize():uint
        {
            return 64;
        }

        public function getHashSize():uint
        {
            return 0;
        }

        public function hash(arg1:flash.utils.ByteArray):flash.utils.ByteArray
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = arg1.length;
            loc3 = arg1.endian;
            arg1.endian = Endian.BIG_ENDIAN;
            loc4 = loc2 * 8;
            while (arg1.length % 4 != 0) 
            {
                arg1[arg1.length] = 0;
            }
            arg1.position = 0;
            loc5 = [];
            loc6 = 0;
            while (loc6 < arg1.length) 
            {
                loc5.push(arg1.readUnsignedInt());
                loc6 = loc6 + 4;
            }
            loc7 = core(loc5, loc4);
            loc8 = new ByteArray();
            loc9 = getHashSize() / 4;
            loc6 = 0;
            while (loc6 < loc9) 
            {
                loc8.writeUnsignedInt(loc7[loc6]);
                loc6 = (loc6 + 1);
            }
            arg1.length = loc2;
            arg1.endian = loc3;
            return loc8;
        }

        protected function core(arg1:Array, arg2:uint):Array
        {
            return null;
        }
    }
}
