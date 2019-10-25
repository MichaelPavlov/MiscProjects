package MyLife.Events 
{
    import flash.events.*;
    
    public class StoreEvent extends flash.events.Event
    {
        public function StoreEvent(arg1:String, arg2:Object=null, arg3:Boolean=false, arg4:Boolean=false)
        {
            this.data = arg2 || {};
            super(arg1, arg3, arg4);
            return;
        }

        public static const DIALOG_COMPLETE:String="storeDialogComplete";

        public var data:Object;
    }
}
