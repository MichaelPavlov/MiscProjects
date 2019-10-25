package MyLife.Events 
{
    import flash.events.*;
    
    public class ActionTweenEvent extends flash.events.Event
    {
        public function ActionTweenEvent(arg1:String, arg2:Object, arg3:Boolean=false, arg4:Boolean=false)
        {
            this.data = arg2;
            super(arg1, arg3, arg4);
            return;
        }

        public static const COMPLETE:String="complete";

        public var data:Object;
    }
}
