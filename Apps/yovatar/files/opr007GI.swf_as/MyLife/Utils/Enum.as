package MyLife.Utils 
{
    import flash.utils.*;
    
    public class Enum extends Object
    {
        public function Enum()
        {
            super();
            return;
        }

        protected static function initEnum(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = describeType(arg1);
            loc4 = 0;
            loc5 = loc2.constant;
            for each (loc3 in loc5)
            {
                arg1[loc3.name].Text = loc3.name;
            }
            return;
        }

        public var Text:String;
    }
}
