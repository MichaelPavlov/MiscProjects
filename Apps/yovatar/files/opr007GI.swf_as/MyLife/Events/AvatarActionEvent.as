package MyLife.Events 
{
    import flash.events.*;
    
    public class AvatarActionEvent extends flash.events.Event
    {
        public function AvatarActionEvent(arg1:String, arg2:String, arg3:Number, arg4:Object, arg5:String)
        {
            super(arg1);
            this.actionId = arg2;
            this.actionParams = arg4;
            this.characterId = arg3;
            this.actionListID = arg5;
            return;
        }

        public static const ACTION_CANCELLED:String="ACTION_CANCELLED";

        public static const ACTION_COMPLETE:String="ACTION_COMPLETE";

        public static const ACTION_LIST_START:String="ACTION_LIST_START";

        public static const SERVER_ACTION_LIST_START:String="SERVER_ACTION_LIST_START";

        public static const ACTION_LIST_COMPLETE:String="ACTION_LIST_COMPLETE";

        public static const ACTION_START:String="ACTION_START";

        public var actionId:String;

        public var characterId:Number;

        public var actionListID:String;

        public var actionParams:Object;
    }
}
