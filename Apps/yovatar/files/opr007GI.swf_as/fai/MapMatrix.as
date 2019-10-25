package fai 
{
    public class MapMatrix extends Object
    {
        public function MapMatrix(arg1:uint, arg2:uint)
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = 0;
            matrix = new Array();
            super();
            h = arg1;
            v = arg2;
            loc3 = 0;
            loc4 = 0;
            while (loc4 < arg2) 
            {
                matrix.push(new Array(arg1));
                loc5 = 0;
                while (loc5 < arg1) 
                {
                    matrix[(matrix.length - 1)][loc5] = loc3;
                    ++loc5;
                }
                ++loc4;
            }
            return;
        }

        public function getxy(arg1:uint, arg2:uint):uint
        {
            return matrix[arg2][arg1];
        }

        public function setpos(arg1:fai.Position, arg2:uint):void
        {
            matrix[arg1.y][arg1.x] = arg2;
            return;
        }

        public function setxy(arg1:uint, arg2:uint, arg3:uint):void
        {
            matrix[arg2][arg1] = arg3;
            return;
        }

        public function getpos(arg1:fai.Position):uint
        {
            return matrix[arg1.y][arg1.x];
        }

        public var matrix:Array;

        public var v:uint;

        public var h:uint;
    }
}
