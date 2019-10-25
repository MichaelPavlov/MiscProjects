package com.boostworthy.core 
{
    import flash.display.*;
    
    public final class Global extends Object
    {
        public function Global()
        {
            super();
            throw new Error("ERROR -> Global :: Constructor :: The \'Global\' class is not meant to be instantiated.");
        }

        public static function set stage(arg1:flash.display.Stage):void
        {
            c_objStage = arg1;
            return;
        }

        public static function get stage():flash.display.Stage
        {
            return c_objStage;
        }

        
        {
            NULL_INDEX = -1;
        }

        private static var c_objStage:flash.display.Stage;

        public static var NULL_INDEX:int=-1;
    }
}
