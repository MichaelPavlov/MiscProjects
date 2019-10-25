package MyLife.Utils 
{
    import flash.display.*;
    import flash.geom.*;
    
    public class DisplayObjectContainerUtils extends Object
    {
        public function DisplayObjectContainerUtils()
        {
            super();
            return;
        }

        public static function removeChildren(arg1:flash.display.DisplayObjectContainer):void
        {
            if (arg1 == null)
            {
                return;
            }
            while (arg1.numChildren > 0) 
            {
                arg1.removeChildAt(0);
            }
            return;
        }

        public static function getCoordinatesInSpace(arg1:flash.display.DisplayObjectContainer, arg2:flash.display.DisplayObjectContainer, arg3:flash.geom.Point):flash.geom.Point
        {
            var loc4:*;
            var loc5:*;

            loc4 = arg1.localToGlobal(arg3);
            return loc5 = arg2.globalToLocal(loc4);
        }

        public static function getChildren(arg1:flash.display.DisplayObjectContainer):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc2 = [];
            loc4 = arg1.numChildren;
            while (loc4--) 
            {
                loc3 = arg1.getChildAt(loc4);
                loc2.unshift(loc3);
            }
            return loc2;
        }
    }
}
