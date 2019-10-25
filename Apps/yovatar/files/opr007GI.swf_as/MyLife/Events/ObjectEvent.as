package MyLife.Events 
{
    import MyLife.*;
    import flash.events.*;
    
    public class ObjectEvent extends MyLife.MyLifeEvent
    {
        public function ObjectEvent(arg1:String, arg2:String="", arg3:*=null, arg4:Object=null, arg5:Boolean=true)
        {
            super(arg1, arg3, arg5);
            context = arg4;
            _oeType = arg2;
            return;
        }

        public function get oeType():String
        {
            return _oeType;
        }

        public override function clone():flash.events.Event
        {
            return new ObjectEvent(type, _oeType, eventData, context, bubbles);
        }

        public static const OETYPE_UPDATE_ROOM:String="OETYPE_UPDATE_ROOM";

        public static const OBJECT_REQUEST_EVENT:String="MLOE_OBJECT_REQUEST";

        public static const OETYPE_SAVE_ROOM:String="OETYPE_SAVE_ROOM";

        private var _oeType:String;

        public var context:*;
    }
}
