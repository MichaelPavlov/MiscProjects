package MyLife 
{
    import flash.net.*;
    
    public class SharedObjectManager extends Object
    {
        public function SharedObjectManager()
        {
            super();
            return;
        }

        private static function get so():Object
        {
            var loc1:*;
            var loc2:*;

            if (!_sharedObject)
            {
                try
                {
                    _sharedObject = SharedObject.getLocal("YoVille-" + MyLifeConfiguration.getInstance().playerId);
                }
                catch (e:Error)
                {
                    _sharedObject = {};
                }
            }
            return _sharedObject;
        }

        public static function setValue(arg1:String, arg2:*=null):void
        {
            if (arg1 && so as SharedObject)
            {
                if (arg2)
                {
                    so.data[arg1] = arg2;
                }
                else 
                {
                    delete so.data[arg1];
                }
                if (so as SharedObject)
                {
                    so.flush();
                }
            }
            return;
        }

        public static function getValue(arg1:String):*
        {
            var loc2:*;

            loc2 = null;
            if (so as SharedObject && arg1)
            {
                loc2 = so.data[arg1];
            }
            return loc2;
        }

        public static const LOADISSUE_PLAYERACTIVATE:String="onPlayerActivateRequest";

        public static const VISIT_DATE:String="visitDate";

        public static const ITEM_FEED_DAILY:String="dailyItemFeed";

        public static const VISITED_FRIENDS:String="visitedFriends";

        public static const APPEARANCE_FEED_DAILY:String="dailyAppearanceFeed";

        public static const BADGE_FEED_DAILY:String="dailyBadgeFeed";

        public static const DASHBOARD_DATE:String="dashboardShown";

        public static const APARTMENT_FEED_DAILY:String="dailyApartmentFeed";

        public static const SCRATCHER_DATE:String="scratcherDate";

        public static const RACING_FEED_DAILY:String="dailyRacingFeed";

        public static const ANIMATION_DATA:String="animationData";

        public static const DASHBOARD_DAILY:String="dailyDashboard";

        public static const MESSAGE_FEED_DAILY:String="dailyMessageFeed";

        public static const WORK_HELP_EXPIRES:String="workHelpRequestExpires";

        public static const LOADISSUE_SFS:String="onSFSConnectRequest";

        public static const LOADISSUE_HOMEDATA:String="onHomeDataRequest";

        public static const MYSTERY_FEED_DAILY:String="dailyMysteryFeed";

        public static const YOMOTOX_DAILY:String="dailyYoMotoX";

        private static var _sharedObject:Object;
    }
}
