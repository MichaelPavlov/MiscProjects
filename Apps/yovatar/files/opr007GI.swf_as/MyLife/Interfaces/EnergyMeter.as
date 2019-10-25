package MyLife.Interfaces 
{
    import MyLife.UI.*;
    import flash.display.*;
    import flash.text.*;
    import gs.*;
    
    public class EnergyMeter extends flash.display.MovieClip implements MyLife.UI.ProgressBarInterface
    {
        public function EnergyMeter()
        {
            super();
            fillMask = fillClip.fillMask;
            return;
        }

        public function getValue():int
        {
            return _energy;
        }

        public function moveTo(arg1:int):int
        {
            if (arg1 < 0)
            {
                arg1 = 0;
            }
            animateBar(arg1);
            _energy = arg1;
            label.text = arg1 + "%";
            return _energy;
        }

        private function animateBar(arg1:int, arg2:Number=1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = NaN;
            loc3 = fillClip.width;
            if (upperThreshold - lowerThreshold != 0)
            {
                loc4 = (arg1 - lowerThreshold) / (upperThreshold - lowerThreshold);
            }
            if (loc4 > 1)
            {
                loc4 = 1;
            }
            loc5 = loc3 * loc4;
            TweenLite.to(fillMask, 2 * Math.abs((loc5 - fillMask.width) / loc3), {"width":loc5});
            return;
        }

        private var _energy:int=0;

        private var upperThreshold:int=100;

        private var lowerThreshold:int=0;

        public var fillMask:flash.display.MovieClip;

        public var fillClip:flash.display.MovieClip;

        public var label:flash.text.TextField;
    }
}
