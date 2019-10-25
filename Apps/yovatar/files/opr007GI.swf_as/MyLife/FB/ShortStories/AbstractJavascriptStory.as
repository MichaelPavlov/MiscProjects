package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    import flash.errors.*;
    import flash.external.*;
    
    public class AbstractJavascriptStory extends Object implements MyLife.FB.Interfaces.ShortStory
    {
        public function AbstractJavascriptStory(arg1:MyLife.FB.ShortStories.AbstractJavascriptStory, arg2:String, arg3:String, arg4:int=5)
        {
            super();
            if (arg1 != this)
            {
                throw new IllegalOperationError("Abstract class did not receive reference to self. AbstractJavascriptStory cannot be instantiated directly.");
            }
            FEED_TYPE = arg2;
            SHARED_OBJECT = arg3;
            this.priority = arg4;
            return;
        }

        public function getPriority():int
        {
            return priority;
        }

        public function getFeedObject():MyLife.FB.Interfaces.FeedObject
        {
            return feedObject;
        }

        public function addItem(arg1:MyLife.FB.Interfaces.FeedObject):int
        {
            this.feedObject = arg1;
            return 1;
        }

        public function clear():void
        {
            this.feedObject = null;
            return;
        }

        public function publish():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = null;
            loc2 = 0;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            if (getFeedObject())
            {
                loc1 = SharedObjectManager.getValue(SHARED_OBJECT);
                loc2 = 0;
                if (canShowFeed(loc1))
                {
                    SharedObjectManager.setValue(SHARED_OBJECT, new Date());
                    loc2 = 1;
                }
                loc3 = getFeedObject().getPlayerId().toString();
                loc4 = getFeedObject().getArgs();
                loc5 = loc2.toString();
                if (ExternalInterface.available)
                {
                    ExternalInterface.call(JAVASCRIPT_FUNCTION, FEED_TYPE, loc3, loc4, loc5);
                }
                clear();
            }
            return;
        }

        protected function isSharedObjectExpired(arg1:Date):Boolean
        {
            var loc2:*;
            var loc3:*;

            loc2 = new Date();
            loc3 = !(arg1 && arg1.getFullYear() == loc2.getFullYear() && arg1.getMonth() == loc2.getMonth() && arg1.getDate() == loc2.getDate());
            return loc3;
        }

        protected function canShowFeed(arg1:Date):Boolean
        {
            return !arg1 || isSharedObjectExpired(arg1);
        }

        
        {
            JAVASCRIPT_FUNCTION = "showFeed";
            ITEM_FEED_TYPE = "item";
            APARTMENT_FEED_TYPE = "apartment";
            APPEARANCE_FEED_TYPE = "look";
            RACING_FEED_TYPE = "yomoto";
            MYSTERY_FEED_TYPE = "mysterybox";
            BADGE_FEED_TYPE = "badge";
            MESSAGE_FEED_TYPE = "message";
            WORK_HELP_FEED_TYPE = "factoryhelp";
            XP_FEED_TYPE = "xp";
        }

        protected var priority:int;

        protected var SHARED_OBJECT:String;

        protected var FEED_TYPE:String;

        protected var feedObject:MyLife.FB.Interfaces.FeedObject;

        protected static var APPEARANCE_FEED_TYPE:String="look";

        protected static var RACING_FEED_TYPE:String="yomoto";

        protected static var WORK_HELP_FEED_TYPE:String="factoryhelp";

        protected static var XP_FEED_TYPE:String="xp";

        protected static var APARTMENT_FEED_TYPE:String="apartment";

        protected static var ITEM_FEED_TYPE:String="item";

        protected static var JAVASCRIPT_FUNCTION:String="showFeed";

        protected static var MESSAGE_FEED_TYPE:String="message";

        protected static var MYSTERY_FEED_TYPE:String="mysterybox";

        protected static var BADGE_FEED_TYPE:String="badge";
    }
}
