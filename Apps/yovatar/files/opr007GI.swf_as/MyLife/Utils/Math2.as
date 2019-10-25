package MyLife.Utils 
{
    public class Math2 extends Object
    {
        public function Math2()
        {
            super();
            return;
        }

        public static function random(arg1:int, arg2:int=0):int
        {
            var loc3:*;

            loc3 = Math.floor(Math.random() * (arg1 - arg2 + 1)) + arg2;
            return loc3;
        }
    }
}
