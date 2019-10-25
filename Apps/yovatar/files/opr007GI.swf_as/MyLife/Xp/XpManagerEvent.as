package MyLife.Xp 
{
    import flash.events.*;
    
    public class XpManagerEvent extends flash.events.Event
    {
        public function XpManagerEvent(arg1:String, arg2:Object=null, arg3:Boolean=false, arg4:Boolean=false)
        {
            this.data = arg2;
            super(arg1, arg3, arg4);
            return;
        }

        public static const XP_MANAGER_NEW_LEVEL_ALERT_CLOSED:String="XP_MANAGER_NEW_LEVEL_ALERT_CLOSED";

        public static const XP_MANAGER_CAN_SHOW_UPDATE:String="XP_MANAGER_CAN_SHOW_UPDATE";

        public static const XP_STATIC_DATA_COMPLETE:String="XP_STATIC_DATA_COMPLETE";

        public static const XP_MANAGER_INITIALIZED:String="XP_MANAGER_INITIALIZED";

        public static const XP_MANAGER_SUSPEND_UPDATES:String="XP_MANAGER_SUSPEND_UPDATES";

        public static const XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE:String="XP_PROGRESS_BAR_TEXT_ANIMATION_COMPLETE";

        public static const XP_UPCOMING_REWARDS_COMPLETE:String="XP_UPCOMING_REWARDS_COMPLETE";

        public static const XP_PROGRESS_BAR_ANIMATION_COMPLETE:String="XP_PROGRESS_BAR_ANIMATION_COMPLETE";

        public static const XP_MANAGER_STATIC_DATA_INITIALIZED:String="XP_MANAGER_STATIC_DATA_INITIALIZED";

        public static const XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE:String="XP_PROGRESS_BAR_TWEEN_ANIMATION_COMPLETE";

        public static const XP_PROGRESS_BAR_FULL:String="XP_PROGRESS_BAR_FULL";

        public static const XP_PROGRESS_BAR_SET_LEVEL_COMPLETE:String="XP_PROGRESS_BAR_SET_LEVEL_COMPLETE";

        public static const XP_MANAGER_UPDATE_PROGRESS:String="XP_MANAGER_UPDATE_PROGRESS";

        public static const XP_MANAGER_NEW_LEVEL:String="XP_MANAGER_NEW_LEVEL";

        public static const XP_MANAGER_UPCOMING_REWARDS_INITIALIZED:String="XP_MANAGER_UPCOMING_REWARDS_INITIALIZED";

        public static const XP_PLAYER_DATA_COMPLETE:String="XP_PLAYER_DATA_COMPLETE";

        public static const XP_MANAGER_PROCESS_REWARD:String="XP_MANAGER_PROCESS_REWARD";

        public static const XP_MANAGER_PROGRESS_INITIALIZED:String="XP_MANAGER_PROGRESS_INITIALIZED";

        public static const XP_MANAGER_GAIN_XP:String="XP_MANAGER_GAIN_XP";

        public var data:Object;
    }
}
