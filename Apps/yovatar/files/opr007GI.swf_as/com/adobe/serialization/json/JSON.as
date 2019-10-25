package com.adobe.serialization.json 
{
    public class JSON extends Object
    {
        public function JSON()
        {
            super();
            return;
        }

        public static function decode(arg1:String):*
        {
            var loc2:*;

            loc2 = new JSONDecoder(arg1);
            return loc2.getValue();
        }

        public static function encode(arg1:Object):String
        {
            var loc2:*;

            loc2 = new JSONEncoder(arg1);
            return loc2.getString();
        }
    }
}
