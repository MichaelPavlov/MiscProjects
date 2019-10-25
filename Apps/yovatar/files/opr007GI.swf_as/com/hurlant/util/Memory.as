package com.hurlant.util 
{
    import flash.net.*;
    import flash.system.*;
    
    public class Memory extends Object
    {
        public function Memory()
        {
            super();
            return;
        }

        public static function gc():void
        {
            var loc1:*;
            var loc2:*;

            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (e:*)
            {
            };
            return;
        }

        public static function get used():uint
        {
            return System.totalMemory;
        }
    }
}
