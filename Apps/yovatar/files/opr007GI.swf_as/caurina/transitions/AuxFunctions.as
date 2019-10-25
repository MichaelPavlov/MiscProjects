package caurina.transitions 
{
    public class AuxFunctions extends Object
    {
        public function AuxFunctions()
        {
            super();
            return;
        }

        public static function getObjectLength(arg1:Object):uint
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = 0;
            loc4 = 0;
            loc5 = arg1;
            for (loc3 in loc5)
            {
                loc2 = (loc2 + 1);
            }
            return loc2;
        }

        public static function numberToG(arg1:Number):Number
        {
            return (arg1 & 65280) >> 8;
        }

        public static function numberToB(arg1:Number):Number
        {
            return arg1 & 255;
        }

        public static function numberToR(arg1:Number):Number
        {
            return (arg1 & 16711680) >> 16;
        }

        public static function concatObjects(... rest):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc5 = null;
            loc2 = {};
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                loc3 = rest[loc4];
                loc6 = 0;
                loc7 = loc3;
                for (loc5 in loc7)
                {
                    if (loc3[loc5] == null)
                    {
                        delete loc2[loc5];
                        continue;
                    }
                    loc2[loc5] = loc3[loc5];
                }
                ++loc4;
            }
            return loc2;
        }
    }
}
