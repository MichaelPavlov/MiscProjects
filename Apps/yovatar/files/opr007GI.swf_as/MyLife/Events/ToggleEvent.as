package MyLife.Events 
{
    import flash.events.*;
    
    public class ToggleEvent extends flash.events.Event
    {
        public function ToggleEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const TOGGLE:String="toggle";

        public static const SELECTED:String="selected";

        public static const DESELECTED:String="deselected";
    }
}
