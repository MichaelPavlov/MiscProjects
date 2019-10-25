package com.hurlant.crypto.symmetric 
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class XTeaKey extends Object implements com.hurlant.crypto.symmetric.ISymmetricKey
    {
        public function XTeaKey(arg1:flash.utils.ByteArray)
        {
            super();
            arg1.position = 0;
            k = [arg1.readUnsignedInt(), arg1.readUnsignedInt(), arg1.readUnsignedInt(), arg1.readUnsignedInt()];
            return;
        }

        public function encrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = 0;
            arg1.position = arg2;
            loc3 = arg1.readUnsignedInt();
            loc4 = arg1.readUnsignedInt();
            loc6 = 0;
            loc7 = 2654435769;
            loc5 = 0;
            while (loc5 < NUM_ROUNDS) 
            {
                loc3 = loc3 + ((loc4 << 4 ^ loc4 >> 5) + loc4 ^ loc6 + k[(loc6 & 3)]);
                loc6 = loc6 + loc7;
                loc4 = loc4 + ((loc3 << 4 ^ loc3 >> 5) + loc3 ^ loc6 + k[(loc6 >> 11 & 3)]);
                loc5 = (loc5 + 1);
            }
            arg1.position = arg1.position - 8;
            arg1.writeUnsignedInt(loc3);
            arg1.writeUnsignedInt(loc4);
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = 0;
            arg1.position = arg2;
            loc3 = arg1.readUnsignedInt();
            loc4 = arg1.readUnsignedInt();
            loc7 = (loc6 = 2654435769) * NUM_ROUNDS;
            loc5 = 0;
            while (loc5 < NUM_ROUNDS) 
            {
                loc4 = loc4 - ((loc3 << 4 ^ loc3 >> 5) + loc3 ^ loc7 + k[(loc7 >> 11 & 3)]);
                loc7 = loc7 - loc6;
                loc3 = loc3 - ((loc4 << 4 ^ loc4 >> 5) + loc4 ^ loc7 + k[(loc7 & 3)]);
                loc5 = (loc5 + 1);
            }
            arg1.position = arg1.position - 8;
            arg1.writeUnsignedInt(loc3);
            arg1.writeUnsignedInt(loc4);
            return;
        }

        public function getBlockSize():uint
        {
            return 8;
        }

        public function toString():String
        {
            return "xtea";
        }

        public function dispose():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = new Random();
            loc2 = 0;
            while (loc2 < k.length) 
            {
                k[loc2] = loc1.nextByte();
                delete k[loc2];
                loc2 = (loc2 + 1);
            }
            k = null;
            Memory.gc();
            return;
        }

        public static function parseKey(arg1:String):com.hurlant.crypto.symmetric.XTeaKey
        {
            var loc2:*;

            loc2 = new ByteArray();
            loc2.writeUnsignedInt(parseInt(arg1.substr(0, 8), 16));
            loc2.writeUnsignedInt(parseInt(arg1.substr(8, (8)), 16));
            loc2.writeUnsignedInt(parseInt(arg1.substr(16, 8), 16));
            loc2.writeUnsignedInt(parseInt(arg1.substr(24, 8), 16));
            loc2.position = 0;
            return new XTeaKey(loc2);
        }

        public const NUM_ROUNDS:uint=64;

        private var k:Array;
    }
}
