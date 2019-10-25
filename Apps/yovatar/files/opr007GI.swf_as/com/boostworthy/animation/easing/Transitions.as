package com.boostworthy.animation.easing 
{
    public final class Transitions extends Object
    {
        public function Transitions()
        {
            super();
            return;
        }

        public static function quadOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return -arg3 * loc5 * (arg1 - 2) + arg2;
        }

        public static function expoOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (arg1 != arg4) ? arg3 * (-Math.pow(2, -10 * arg1 / arg4) + 1) + arg2 : arg2 + arg3;
        }

        public static function expoInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            if (arg1 == 0)
            {
                return arg2;
            }
            if (arg1 == arg4)
            {
                return arg2 + arg3;
            }
            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * Math.pow(2, 10 * (arg1 - 1)) + arg2;
            }
            return arg3 / 2 * (-Math.pow(2, -10 * --arg1) + 2) + arg2;
        }

        public static function quintOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return arg3 * (loc5 * arg1 * arg1 * arg1 * arg1 + 1) + arg2;
        }

        public static function cubicIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 + arg2;
        }

        public static function sineIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return -arg3 * Math.cos(arg1 / arg4 * Math.PI / 2) + arg2 + arg3;
        }

        public static function sineOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return arg3 * Math.sin(arg1 / arg4 * Math.PI / 2) + arg2;
        }

        public static function quartOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return -arg3 * (loc5 * arg1 * arg1 * arg1 - 1) + arg2;
        }

        public static function sineInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return -arg3 / 2 * (Math.cos(arg1 / arg4 * Math.PI) - 1) + arg2;
        }

        public static function bounce(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            if (loc5 < 1 / 2.75)
            {
                return arg3 * 7.5625 * arg1 * arg1 + arg2;
            }
            if (arg1 < 2 / 2.75)
            {
                arg1 = loc5 = arg1 - 1.5 / 2.75;
                return arg3 * (7.5625 * loc5 * arg1 + 0.75) + arg2;
            }
            if (arg1 < 2.5 / 2.75)
            {
                arg1 = loc5 = arg1 - 2.25 / 2.75;
                return arg3 * (7.5625 * loc5 * arg1 + 0.9375) + arg2;
            }
            arg1 = loc5 = arg1 - 2.625 / 2.75;
            return arg3 * (7.5625 * loc5 * arg1 + 0.984375) + arg2;
        }

        public static function backInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;

            loc5 = BACK_OVERSHOOT;
            arg1 = loc6 = arg1 / (arg4 / 2);
            if (loc6 < 1)
            {
                loc5 = loc6 = loc5 * 1.525;
                return arg3 / 2 * arg1 * arg1 * ((loc6 + 1) * arg1 - loc5) + arg2;
            }
            arg1 = loc6 = arg1 - 2;
            loc5 = loc6 = loc5 * 1.525;
            return arg3 / 2 * (loc6 * arg1 * ((loc6 + 1) * arg1 + loc5) + 2) + arg2;
        }

        public static function expoIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return (arg1 != 0) ? arg3 * Math.pow(2, 10 * (arg1 / arg4 - 1)) + arg2 : arg2;
        }

        public static function linear(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return arg3 * arg1 / arg4 + arg2;
        }

        public static function cubicOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = (arg1 / arg4 - 1);
            return arg3 * (loc5 * arg1 * arg1 + 1) + arg2;
        }

        public static function quadIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 + arg2;
        }

        public static function quintIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 * arg1 * arg1 + arg2;
        }

        public static function elasticOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            loc5 = ELASTIC_AMPLITUDE;
            loc6 = ELASTIC_PERIOD;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / arg4;
            if (loc8 == 1)
            {
                return arg2 + arg3;
            }
            if (!loc6)
            {
                loc6 = arg4 * 0.3;
            }
            if (!loc5 || loc5 < Math.abs(arg3))
            {
                loc5 = arg3;
                loc7 = loc6 / 4;
            }
            else 
            {
                loc7 = loc6 / (2 * Math.PI) * Math.asin(arg3 / loc5);
            }
            return loc5 * Math.pow(2, -10 * arg1) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / loc6) + arg3 + arg2;
        }

        public static function linearRandom(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            loc5 = (loc5 = (loc5 = Math.sin(arg1 * 2 * 3.1415)) / arg3) * 1;
            return arg3 * arg1 / arg4 + arg2 + loc5;
        }

        public static function quartInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return -arg3 / 2 * (loc5 * arg1 * arg1 * arg1 - 2) + arg2;
        }

        public static function quartIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return arg3 * loc5 * arg1 * arg1 * arg1 + arg2;
        }

        public static function quadInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 + arg2;
            }
            return -arg3 / 2 * (--arg1 * (arg1 - 2) - 1) + arg2;
        }

        public static function quintInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return arg3 / 2 * (loc5 * arg1 * arg1 * arg1 * arg1 + 2) + arg2;
        }

        public static function elasticIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            loc5 = ELASTIC_AMPLITUDE;
            loc6 = ELASTIC_PERIOD;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / arg4;
            if (loc8 == 1)
            {
                return arg2 + arg3;
            }
            if (!loc6)
            {
                loc6 = arg4 * 0.3;
            }
            if (!loc5 || loc5 < Math.abs(arg3))
            {
                loc5 = arg3;
                loc7 = loc6 / 4;
            }
            else 
            {
                loc7 = loc6 / (2 * Math.PI) * Math.asin(arg3 / loc5);
            }
            arg1 = loc8 = (arg1 - 1);
            return -(loc5 * Math.pow(2, 10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / loc6)) + arg2;
        }

        public static function cubicInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / (arg4 / 2);
            if (loc5 < 1)
            {
                return arg3 / 2 * arg1 * arg1 * arg1 + arg2;
            }
            arg1 = loc5 = arg1 - 2;
            return arg3 / 2 * (loc5 * arg1 * arg1 + 2) + arg2;
        }

        public static function backOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;

            loc5 = BACK_OVERSHOOT;
            arg1 = loc6 = (arg1 / arg4 - 1);
            return arg3 * (loc6 * arg1 * ((loc5 + 1) * arg1 + loc5) + 1) + arg2;
        }

        public static function elasticInAndOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = NaN;
            loc5 = ELASTIC_AMPLITUDE;
            loc6 = ELASTIC_PERIOD;
            if (arg1 == 0)
            {
                return arg2;
            }
            arg1 = loc8 = arg1 / (arg4 / 2);
            if (loc8 == 2)
            {
                return arg2 + arg3;
            }
            if (!loc6)
            {
                loc6 = arg4 * 0.3 * 1.5;
            }
            if (!loc5 || loc5 < Math.abs(arg3))
            {
                loc5 = arg3;
                loc7 = loc6 / 4;
            }
            else 
            {
                loc7 = loc6 / (2 * Math.PI) * Math.asin(arg3 / loc5);
            }
            if (arg1 < 1)
            {
                arg1 = loc8 = (arg1 - 1);
                return -0.5 * loc5 * Math.pow(2, 10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / loc6) + arg2;
            }
            arg1 = loc8 = (arg1 - 1);
            return loc5 * Math.pow(2, -10 * loc8) * Math.sin((arg1 * arg4 - loc7) * 2 * Math.PI / loc6) * 0.5 + arg3 + arg2;
        }

        public static function backIn(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;
            var loc6:*;

            loc5 = BACK_OVERSHOOT;
            arg1 = loc6 = arg1 / arg4;
            return arg3 * loc6 * arg1 * ((loc5 + 1) * arg1 - loc5) + arg2;
        }

        public static const SINE_OUT:String="sineOut";

        public static const QUAD_IN_AND_OUT:String="quadInAndOut";

        private static const ELASTIC_PERIOD:Number=400;

        public static const QUART_OUT:String="quartOut";

        public static const BOUNCE:String="bounce";

        public static const EXPO_IN:String="expoIn";

        public static const SINE_IN:String="sineIn";

        public static const CUBIC_OUT:String="cubicOut";

        public static const QUINT_OUT:String="quintOut";

        public static const LINEAR_RANDOM:String="linearRandom";

        public static const QUINT_IN_AND_OUT:String="quintInAndOut";

        public static const QUAD_IN:String="quadIn";

        public static const LINEAR:String="linear";

        public static const QUART_IN_AND_OUT:String="quartInAndOut";

        public static const QUAD_OUT:String="quadOut";

        public static const QUINT_IN:String="quintIn";

        public static const ELASTIC_OUT:String="elasticOut";

        public static const CUBIC_IN_AND_OUT:String="cubicInAndOut";

        public static const QUART_IN:String="quartIn";

        public static const DEFAULT_TRANSITION:String=LINEAR;

        private static const BACK_OVERSHOOT:Number=1.70158;

        public static const BACK_OUT:String="backOut";

        private static const ELASTIC_AMPLITUDE:Number=undefined;

        public static const CUBIC_IN:String="cubicIn";

        public static const ELASTIC_IN_AND_OUT:String="elasticInAndOut";

        public static const EXPO_OUT:String="expoOut";

        public static const BACK_IN_AND_OUT:String="backInAndOut";

        public static const ELASTIC_IN:String="elasticIn";

        public static const EXPO_IN_AND_OUT:String="expoInAndOut";

        public static const BACK_IN:String="backIn";

        public static const SINE_IN_AND_OUT:String="sineInAndOut";
    }
}
