package MyLife.Events 
{
    import MyLife.*;
    import flash.events.*;
    
    public class FactoryEvent extends MyLife.MyLifeEvent
    {
        public function FactoryEvent(arg1:String, arg2:Object=null, arg3:Boolean=true)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public override function clone():flash.events.Event
        {
            return new FactoryEvent(type, eventData, bubbles);
        }

        public static const HELP_REQUEST_SUBMIT:String="MLE_FE_SUBMIT";

        public static const HELP_REQUEST_COMPLETE:String="MLE_FE_COMPLETE";

        public static const HELP_REQUEST_HELP:String="MLE_FE_HELP";
    }
}
