package MyLife.FB 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.FB.Interfaces.*;
    import MyLife.FB.Objects.*;
    import MyLife.FB.ShortStories.*;
    import MyLife.Games.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class ShortStoryPublisher extends flash.events.EventDispatcher
    {
        public function ShortStoryPublisher()
        {
            super();
            init();
            return;
        }

        private function mysteryHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (arg1.eventData.hasOwnProperty("rarity"))
            {
                loc2 = arg1.eventData.rarity;
            }
            if (arg1.eventData.hasOwnProperty("receivedItem"))
            {
                mysteryReceivedItem = arg1.eventData.receivedItem;
            }
            if (loc2 == "Rare")
            {
                loc3 = new Timer(10000);
                loc3.addEventListener(TimerEvent.TIMER, publishMystery);
                loc3.start();
            }
            return;
        }

        private function addItemToStory(arg1:MyLife.FB.Interfaces.FeedObject):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            if (arg1)
            {
                if (arg1 as AppearanceFeedObject)
                {
                    loc2 = APPEARANCE_FEED;
                    loc3 = "AppearanceFeedStory";
                }
                else 
                {
                    if (arg1 as ApartmentFeedObject)
                    {
                        loc2 = APARTMENT_FEED;
                        loc3 = "ApartmentFeedStory";
                    }
                    else 
                    {
                        if (arg1 as BadgeFeedObject)
                        {
                            loc2 = BADGE_FEED;
                            loc3 = "BadgeFeedStory";
                        }
                        else 
                        {
                            if (arg1 as ItemFeedObject)
                            {
                                loc2 = ITEM_FEED;
                                loc3 = "ItemFeedStory";
                            }
                            else 
                            {
                                if (arg1 as MessageFeedObject)
                                {
                                    loc2 = MESSAGE_FEED;
                                    loc3 = "MessageFeedStory";
                                }
                                else 
                                {
                                    if (arg1 as MysteryFeedObject)
                                    {
                                        loc2 = MYSTERY_FEED;
                                        loc3 = "MysteryFeedStory";
                                    }
                                    else 
                                    {
                                        if (arg1 as RacingFeedObject)
                                        {
                                            loc2 = RACING_FEED;
                                            loc3 = "RacingFeedStory";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (loc2 && loc3)
                {
                    if (!(loc4 = getStory(loc2)))
                    {
                        loc4 = new (loc5 = getDefinitionByName(STORY_CLASS_PATH + loc3) as Class)() as ShortStory;
                    }
                    loc4.addItem(arg1);
                }
                putStory(loc4, loc2);
            }
            return loc2;
        }

        public function publish(arg1:String):void
        {
            var loc2:*;

            loc2 = getStory(arg1);
            if (loc2)
            {
                publishStory(loc2);
            }
            return;
        }

        public function init():void
        {
            shortStoryList = new Array();
            _myLife = MyLifeInstance.getInstance();
            _myLife.server.addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, actionHandler);
            _myLife.server.addEventListener(MyLifeEvent.USE_ITEM_RESPONSE, mysteryHandler);
            addEventListener(MyLifeEvent.FB_PUBLISH_SHORT_STORY, publishEventHandler);
            addEventListener(MyLifeEvent.FB_ADD_ITEM_TO_STORY, addItemEventHandler);
            (MyLifeInstance.getInstance() as MyLife).addEventListener(MyLifeEvent.INTERFACE_DIALOG_QUEUE_EMPTY, publishAllHandler);
            GameManager.instance.addEventListener(GameManagerEvent.GAME_EXIT, publishAllHandler);
            return;
        }

        public function removeStory(arg1:String):void
        {
            delete shortStoryList[arg1];
            return;
        }

        private function addItemEventHandler(arg1:MyLife.MyLifeEvent):void
        {
            addItemToStory(arg1.eventData as FeedObject);
            return;
        }

        private function publishAllHandler(arg1:flash.events.Event):void
        {
            if (canPublish())
            {
                publishAll();
            }
            return;
        }

        public function publishAll():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            shortStoryList.sort(comparePriority);
            loc2 = 0;
            loc3 = shortStoryList;
            for each (loc1 in loc3)
            {
                publishStory(loc1);
            }
            return;
        }

        public function canPublish():Boolean
        {
            return !(MyLifeInstance.getInstance() as MyLife).getZone().isGameMode() && !(MyLifeInstance.getInstance() as MyLife).isDialogOpen();
        }

        private function publishEventHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.eventData as FeedObject)
            {
                loc2 = addItemToStory(arg1.eventData as FeedObject);
            }
            else 
            {
                if (arg1.eventData as String)
                {
                    loc2 = arg1.eventData as String;
                }
            }
            if (loc2)
            {
                publish(loc2);
            }
            return;
        }

        public function putStory(arg1:MyLife.FB.Interfaces.ShortStory, arg2:String):void
        {
            shortStoryList[arg2] = arg1;
            return;
        }

        private function comparePriority(arg1:MyLife.FB.Interfaces.ShortStory, arg2:MyLife.FB.Interfaces.ShortStory):int
        {
            if (arg1.getPriority() == arg2.getPriority())
            {
                return 0;
            }
            if (arg1.getPriority() < arg2.getPriority())
            {
                return -1;
            }
            return 1;
        }

        private function actionHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = null;
            if (arg1.eventData.hasOwnProperty("action"))
            {
                loc2 = arg1.eventData.action;
            }
            if (loc2 == _myLife.server.ACTION_MANAGER_TYPE_RACE_WON)
            {
                loc3 = addItemToStory(new RacingFeedObject(_myLife.player._playerId));
            }
            return;
        }

        private function publishMystery(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = addItemToStory(new MysteryFeedObject(_myLife.player._playerId, mysteryReceivedItem.itemId, mysteryReceivedItem.name));
            publish(loc2);
            loc3 = arg1.currentTarget as Timer;
            if (loc3)
            {
                loc3.stop();
                loc3.removeEventListener(TimerEvent.TIMER, publishMystery);
                loc3 = null;
            }
            return;
        }

        private function publishStory(arg1:MyLife.FB.Interfaces.ShortStory):void
        {
            arg1.publish();
            return;
        }

        public function getStory(arg1:String):MyLife.FB.Interfaces.ShortStory
        {
            return shortStoryList[arg1];
        }

        public static function get instance():MyLife.FB.ShortStoryPublisher
        {
            if (!_instance)
            {
                _instance = new ShortStoryPublisher();
            }
            return _instance;
        }

        
        {
            STORY_CLASS_PATH = "MyLife.FB.ShortStories.";
            ITEM_FEED = "itemFeed";
            APPEARANCE_FEED = "appearanceFeed";
            APARTMENT_FEED = "apartmentFeed";
            RACING_FEED = "racingFeed";
            MYSTERY_FEED = "mysteryFeed";
            BADGE_FEED = "badgeFeed";
            MESSAGE_FEED = "messageFeed";
            XP_FEED = "xpFeed";
        }

        public static const PUBLISH_FIRST:int=1;

        public static const PUBLISH_LAST:int=10;

        public static const PUBLISH_REGULAR:int=5;

        private var racingStory:MyLife.FB.ShortStories.RacingFeedStory;

        private var badgeStory:MyLife.FB.ShortStories.BadgeFeedStory;

        public var shortStoryList:Array;

        private var xpStory:MyLife.FB.ShortStories.XPFeedStory;

        private var apartmentStory:MyLife.FB.ShortStories.ApartmentFeedStory;

        private var _myLife:flash.display.MovieClip;

        private var itemStory:MyLife.FB.ShortStories.ItemFeedStory;

        private var appearanceStory:MyLife.FB.ShortStories.AppearanceFeedStory;

        private var messageStory:MyLife.FB.ShortStories.MessageFeedStory;

        private var mysteryStory:MyLife.FB.ShortStories.MysteryFeedStory;

        private var mysteryReceivedItem:Object;

        private static var _instance:MyLife.FB.ShortStoryPublisher;

        public static var XP_FEED:String="xpFeed";

        public static var ITEM_FEED:String="itemFeed";

        private static var STORY_CLASS_PATH:String="MyLife.FB.ShortStories.";

        public static var APPEARANCE_FEED:String="appearanceFeed";

        public static var BADGE_FEED:String="badgeFeed";

        public static var APARTMENT_FEED:String="apartmentFeed";

        public static var RACING_FEED:String="racingFeed";

        public static var MESSAGE_FEED:String="messageFeed";

        public static var MYSTERY_FEED:String="mysteryFeed";
    }
}
