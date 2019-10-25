package fai 
{
    public class Map extends Object
    {
        public function Map()
        {
            keys = new Array();
            values = new Array();
            super();
            return;
        }

        public function add(arg1:Object, arg2:*):void
        {
            index_ = 0;
            find(arg1);
            keys.splice(index_, 0, arg1);
            values.splice(index_, 0, arg2);
            return;
        }

        public function empty():Boolean
        {
            return keys.length == 0;
        }

        public function shift():*
        {
            var loc1:*;

            loc1 = values.shift();
            keys.shift();
            return loc1;
        }

        public function remove(arg1:Object):void
        {
            if (find(arg1))
            {
                keys.splice(index_, 1);
                values.splice(index_, 1);
            }
            return;
        }

        public function clear():void
        {
            keys.length = 0;
            values.length = 0;
            index_ = 0;
            return;
        }

        public function size():int
        {
            return keys.length;
        }

        public function pop():*
        {
            var loc1:*;

            loc1 = values.pop();
            keys.pop();
            return loc1;
        }

        public function get(arg1:Object):*
        {
            if (!find(arg1))
            {
                return null;
            }
            return values[index_];
        }

        public function getout(arg1:Object):*
        {
            var loc2:*;

            if (!find(arg1))
            {
                return null;
            }
            loc2 = values[index_];
            values.splice(index_, 1);
            keys.splice(index_, 1);
            return loc2;
        }

        public function find(arg1:Object):Boolean
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = (keys.length - 1);
            while (loc2 <= loc3) 
            {
                index_ = loc2 + loc3 >> 1;
                if (arg1 < keys[index_])
                {
                    loc3 = (index_ - 1);
                    continue;
                }
                if (arg1 > keys[index_])
                {
                    loc2 = index_ + 1;
                    continue;
                }
                return true;
            }
            index_ = loc2;
            return false;
        }

        public var values:Array;

        public var keys:Array;

        protected var index_:int=0;
    }
}
