package com.boostworthy.animation 
{
    import com.boostworthy.utils.logger.*;
    
    public final class BoostworthyAnimation extends Object
    {
        public function BoostworthyAnimation()
        {
            super();
            return;
        }

        public static function log():void
        {
            if (!c_bIsLogged)
            {
                LogFactory.getInstance().getLog(NAME).info("Version " + VERSION + " :: " + AUTHOR);
                c_bIsLogged = true;
            }
            return;
        }

        public static const VERSION:String="2.1";

        public static const AUTHOR:String="Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com";

        public static const NAME:String="Boostworthy Animation System";

        public static const DATE:String="06.07.2007";

        private static var c_bIsLogged:Boolean;
    }
}
