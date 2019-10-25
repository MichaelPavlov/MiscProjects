package MyLife.Events 
{
    import flash.events.*;
    
    public class InventoryEvent extends flash.events.Event
    {
        public function InventoryEvent(arg1:String, arg2:Object=null, arg3:Boolean=false, arg4:Boolean=false)
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
            return new InventoryEvent(type, eventData, bubbles, cancelable);
        }

        public static const ADD_ITEM:String="MLE_INVENTORY_ADDITEM";

        public static const READY:String="MLE_INVENTORY_READY";

        public static const REMOVE_ITEM:String="MLE_INVENTORY_REMOVEITEM";

        private var _eventData:Object;
    }
}
