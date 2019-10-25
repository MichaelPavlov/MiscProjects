package com.adobe.serialization.json 
{
    public class JSONToken extends Object
    {
        public function JSONToken(arg1:int=-1, arg2:Object=null)
        {
            super();
            _type = arg1;
            _value = arg2;
            return;
        }

        public function get value():Object
        {
            return _value;
        }

        public function get type():int
        {
            return _type;
        }

        public function set type(arg1:int):void
        {
            _type = arg1;
            return;
        }

        public function set value(arg1:Object):void
        {
            _value = arg1;
            return;
        }

        private var _value:Object;

        private var _type:int;
    }
}
