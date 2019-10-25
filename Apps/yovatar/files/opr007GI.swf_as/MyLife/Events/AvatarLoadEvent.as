package MyLife.Events 
{
    import flash.events.*;
    
    public class AvatarLoadEvent extends flash.events.Event
    {
        public function AvatarLoadEvent(arg1:String, arg2:Object=null, arg3:Boolean=true)
        {
            eventData = arg2;
            super(arg1, arg3);
            return;
        }

        public static const PLAYER_LOAD_COMPLETE:String="PLAYER_LOAD_COMPLETE";

        public static const NPC_LOAD_COMPLETE:String="NPC_LOAD_COMPLETE";

        public static const CLOTHING_LOAD_COMPLETE:String="CLOTHING_LOAD_COMPLETE";

        public static const CHARACTER_LOAD_COMPLETE:String="CHARACTER_LOAD_COMPLETE";

        public var eventData:Object;
    }
}
