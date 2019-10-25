package com.adobe.serialization.json 
{
    public class JSONParseError extends Error
    {
        public function JSONParseError(arg1:String="", arg2:int=0, arg3:String="")
        {
            super(arg1);
            _location = arg2;
            _text = arg3;
            return;
        }

        public function get location():int
        {
            return _location;
        }

        public function get text():String
        {
            return _text;
        }

        private var _location:int;

        private var _text:String;
    }
}
