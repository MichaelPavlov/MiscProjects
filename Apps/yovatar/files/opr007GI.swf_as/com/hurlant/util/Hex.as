package com.hurlant.util 
{
    import flash.utils.*;
    
    public class Hex extends Object
    {
        public function Hex()
        {
            super();
            return;
        }

        public static function fromString(arg1:String, arg2:Boolean=false):String
        {
            var loc3:*;

            loc3 = new ByteArray();
            loc3.writeUTFBytes(arg1);
            return fromArray(loc3, arg2);
        }

        public static function toString(arg1:String):String
        {
            var loc2:*;

            loc2 = toArray(arg1);
            return loc2.readUTFBytes(loc2.length);
        }

        public static function toArray(arg1:String):flash.utils.ByteArray
        {
            var loc2:*;
            var loc3:*;

            arg1 = arg1.replace(new RegExp("\\s|:", "gm"), "");
            loc2 = new ByteArray();
            if (arg1.length & 1 == (1))
            {
                arg1 = "0" + arg1;
            }
            loc3 = 0;
            while (loc3 < arg1.length) 
            {
                loc2[(loc3 / 2)] = parseInt(arg1.substr(loc3, 2), 16);
                loc3 = loc3 + 2;
            }
            return loc2;
        }

        public static function fromArray(arg1:flash.utils.ByteArray, arg2:Boolean=false):String
        {
            var loc3:*;
            var loc4:*;

            loc3 = "";
            loc4 = 0;
            while (loc4 < arg1.length) 
            {
                loc3 = loc3 + ("0" + arg1[loc4].toString(16)).substr(-2, 2);
                if (arg2)
                {
                    if (loc4 < (arg1.length - 1))
                    {
                        loc3 = loc3 + ":";
                    }
                }
                loc4 = (loc4 + 1);
            }
            return loc3;
        }
    }
}
