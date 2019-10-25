package MyLife.Events 
{
    import flash.events.*;
    
    public class ServerEvent extends flash.events.Event
    {
        public function ServerEvent(arg1:String, arg2:Object=null, arg3:Boolean=false, arg4:Boolean=false)
        {
            _eventData = arg2;
            super(arg1, arg3, arg4);
            return;
        }

        public function get eventData():Object
        {
            return _eventData;
        }

        public override function clone():flash.events.Event
        {
            return new ServerEvent(type, eventData, bubbles, cancelable);
        }

        public static const PLAYER_ACTIVATED:String="MLSE_PLAYER_ACTIVATED";

        public static const LOAD_INVENTORY_COMPLETE:String="MLSE_LOAD_INVENTORY_COMPLETE";

        private var _eventData:Object;
    }
}
