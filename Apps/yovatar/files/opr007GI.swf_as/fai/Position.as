package fai 
{
    public class Position extends Object
    {
        public function Position(arg1:Number=0, arg2:Number=0)
        {
            super();
            set(arg1, arg2);
            return;
        }

        public function set(arg1:Number, arg2:Number):void
        {
            x = arg1;
            y = arg2;
            return;
        }

        public function isequal(arg1:fai.Position):Boolean
        {
            return x == arg1.x && y == arg1.y;
        }

        public function vectorLength():Number
        {
            return Math.sqrt(x * x + y * y);
        }

        public function toString():String
        {
            return "(" + x + ", " + y + ")";
        }

        public function deltaPosition(arg1:fai.Position):fai.Position
        {
            return new Position(x - arg1.x, y - arg1.y);
        }

        public var x:Number=0;

        public var y:Number=0;
    }
}
