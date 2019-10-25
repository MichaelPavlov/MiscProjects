package MyLife 
{
    import flash.events.*;
    import flash.net.*;
    
    public class ExceptionLogger extends Object
    {
        public function ExceptionLogger()
        {
            super();
            return;
        }

        public static function logException(arg1:*, arg2:*):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = MyLifeConfiguration.getInstance().variables["global"]["game_control_server"] + "log_as3_exception.php?r=" + Math.random();
            loc4 = MyLifeConfiguration.getInstance().playerId;
            (loc5 = new URLVariables())["playerId"] = loc4;
            loc5["stack"] = arg1;
            loc5["meta"] = "v2.1 - " + arg2;
            (loc6 = new URLRequest(loc3)).data = loc5;
            loc6.method = URLRequestMethod.POST;
            (loc7 = new URLLoader()).addEventListener(Event.COMPLETE, onLoaderComplete);
            loc7.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            loc7.load(loc6);
            return;
        }

        private static function onLoaderComplete(arg1:flash.events.Event):void
        {
            trace("Exception Error Log Sent Successfully");
            return;
        }

        private static function onLoaderError(arg1:flash.events.IOErrorEvent):void
        {
            trace("Error While Sending Exception Error");
            return;
        }
    }
}
