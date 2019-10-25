package it.gotoandplay.smartfoxserver.http 
{
    import flash.events.*;
    
    public class HttpEvent extends flash.events.Event
    {
        public function HttpEvent(arg1:String, arg2:Object)
        {
            super(arg1);
            this.params = arg2;
            this.evtType = arg1;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new HttpEvent(this.evtType, this.params);
        }

        public override function toString():String
        {
            return formatToString("HttpEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
        }

        public static const onHttpClose:String="onHttpClose";

        public static const onHttpError:String="onHttpError";

        public static const onHttpConnect:String="onHttpConnect";

        public static const onHttpData:String="onHttpData";

        public var params:Object;

        private var evtType:String;
    }
}
