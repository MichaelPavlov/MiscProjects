package MyLife.Utils.Math 
{
    public class FitToDimensions extends Object
    {
        public function FitToDimensions()
        {
            super();
            return;
        }

        private static function fitToHeight(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:int):Object
        {
            var loc6:*;

            loc6 = arg2;
            arg2 = arg4;
            arg1 = arg1 * arg2 / loc6;
            if (continueSizing(arg1, arg3, arg5))
            {
                return fitToWidth(arg1, arg2, arg3, arg4, arg5);
            }
            return {"width":arg1, "height":arg2};
        }

        private static function continueSizing(arg1:Number, arg2:Number, arg3:int):Boolean
        {
            if (arg1 == 0)
            {
                return false;
            }
            if (arg3 == CONSTRAIN_MINIMUM && arg1 < arg2)
            {
                return true;
            }
            if (arg3 == CONSTRAIN_MAXIMUM && arg1 > arg2)
            {
                return true;
            }
            return false;
        }

        public static function fitToDimensions(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:int):Object
        {
            if (!(arg5 == CONSTRAIN_MINIMUM) && !(arg5 == CONSTRAIN_MAXIMUM))
            {
                trace("FitToDimensions.fitToDimensions WARNING: Invalid constrain mode. Returning constrain dimensions which may alter aspect ratio.");
                return {"width":arg3, "height":arg4};
            }
            if (arg3 > arg4 && arg2 > arg1)
            {
                return fitToWidth(arg1, arg2, arg3, arg4, arg5);
            }
            if (arg3 > arg4 && arg1 > arg2)
            {
                if (continueSizing(arg2, arg4, arg5))
                {
                    return fitToHeight(arg1, arg2, arg3, arg4, arg5);
                }
                return fitToWidth(arg1, arg2, arg3, arg4, arg5);
            }
            if (arg4 > arg3 && arg1 > arg2)
            {
                return fitToHeight(arg1, arg2, arg3, arg4, arg5);
            }
            if (arg4 > arg3 && arg1 > arg2)
            {
                if (continueSizing(arg1, arg3, arg5))
                {
                    return fitToWidth(arg1, arg2, arg3, arg4, arg5);
                }
                return fitToHeight(arg1, arg2, arg3, arg4, arg5);
            }
            return fitToWidth(arg1, arg2, arg3, arg4, arg5);
        }

        private static function fitToWidth(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number):Object
        {
            var loc6:*;

            loc6 = arg1;
            arg1 = arg3;
            arg2 = arg2 * arg1 / loc6;
            if (continueSizing(arg2, arg4, arg5))
            {
                return fitToHeight(arg1, arg2, arg3, arg4, arg5);
            }
            return {"width":arg1, "height":arg2};
        }

        public static const CONSTRAIN_MINIMUM:Number=0;

        public static const CONSTRAIN_MAXIMUM:Number=1;
    }
}
