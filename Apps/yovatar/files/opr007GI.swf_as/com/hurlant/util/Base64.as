package com.hurlant.util 
{
    import flash.utils.*;
    
    public class Base64 extends Object
    {
        public function Base64()
        {
            super();
            throw new Error("Base64 class is static container only");
        }

        public static function encode(arg1:String):String
        {
            var loc2:*;

            loc2 = new ByteArray();
            loc2.writeUTFBytes(arg1);
            return encodeByteArray(loc2);
        }

        public static function encodeByteArray(arg1:flash.utils.ByteArray):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            loc2 = "";
            loc4 = new Array(4);
            arg1.position = 0;
            while (arg1.bytesAvailable > 0) 
            {
                loc3 = new Array();
                loc5 = 0;
                while (loc5 < 3 && arg1.bytesAvailable > 0) 
                {
                    loc3[loc5] = arg1.readUnsignedByte();
                    loc5 = (loc5 + 1);
                }
                loc4[0] = (loc3[0] & 252) >> 2;
                loc4[1] = (loc3[0] & 3) << 4 | loc3[1] >> 4;
                loc4[2] = (loc3[1] & 15) << 2 | loc3[2] >> 6;
                loc4[3] = loc3[2] & 63;
                loc6 = loc3.length;
                while (loc6 < 3) 
                {
                    loc4[(loc6 + 1)] = 64;
                    loc6 = (loc6 + 1);
                }
                loc7 = 0;
                while (loc7 < loc4.length) 
                {
                    loc2 = loc2 + BASE64_CHARS.charAt(loc4[loc7]);
                    loc7 = (loc7 + 1);
                }
            }
            return loc2;
        }

        public static function decode(arg1:String):String
        {
            var loc2:*;

            loc2 = decodeToByteArray(arg1);
            return loc2.readUTFBytes(loc2.length);
        }

        public static function decodeToByteArray(arg1:String):flash.utils.ByteArray
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = 0;
            loc7 = 0;
            loc2 = new ByteArray();
            loc3 = new Array(4);
            loc4 = new Array(3);
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                loc6 = 0;
                while (loc6 < 4 && loc5 + loc6 < arg1.length) 
                {
                    loc3[loc6] = BASE64_CHARS.indexOf(arg1.charAt(loc5 + loc6));
                    loc6 = (loc6 + 1);
                }
                loc4[0] = (loc3[0] << 2) + ((loc3[1] & 48) >> 4);
                loc4[1] = ((loc3[1] & 15) << 4) + ((loc3[2] & 60) >> 2);
                loc4[2] = ((loc3[2] & 3) << 6) + loc3[3];
                loc7 = 0;
                while (loc7 < loc4.length) 
                {
                    if (loc3[(loc7 + 1)] == 64)
                    {
                        break;
                    }
                    loc2.writeByte(loc4[loc7]);
                    loc7 = (loc7 + 1);
                }
                loc5 = loc5 + 4;
            }
            loc2.position = 0;
            return loc2;
        }

        public static const version:String="1.0.0";

        private static const BASE64_CHARS:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    }
}
