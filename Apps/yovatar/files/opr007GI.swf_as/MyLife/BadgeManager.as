package MyLife 
{
    import MyLife.FB.*;
    import MyLife.FB.Objects.*;
    import MyLife.Interfaces.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class BadgeManager extends flash.events.EventDispatcher
    {
        public function BadgeManager()
        {
            _myLife = MyLifeInstance.getInstance();
            _interface = _myLife.getInterface();
            _variables = _myLife.myLifeConfiguration.variables;
            totalBadgeList = [];
            badgeAlertQueue = [];
            imageCache = new Dictionary();
            super();
            this.init();
            return;
        }

        private function checkPlayerVisitBadge(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = arg1.eventData["action"];
            loc3 = Number(arg1.eventData["reward"]);
            if (loc3)
            {
                (loc4 = {}).badgeType = BadgeManager.BADGE_VISIT_ID;
                loc4.amount = 1;
                _myLife.server.callExtension("BadgeManager.updateBadgeProgressExtension", loc4);
            }
            return;
        }

        public function getSmallImageURL(arg1:int, arg2:int):String
        {
            var loc3:*;
            var loc4:*;

            if (arg1 < 0 || arg2 < 0)
            {
                return null;
            }
            loc3 = getBadgeIdFromTypeLevel(arg1, arg2);
            if (loc4 = getBadgeProperty(loc3, "small_image"))
            {
                return _variables["global"]["badge_asset_path"] + loc4;
            }
            return null;
        }

        public function getBadgeTypeFromId(arg1:int):int
        {
            var loc2:*;

            loc2 = getBadgeProperty(arg1, "badge_type");
            if (loc2 != null)
            {
                return loc2;
            }
            return -1;
        }

        private function init():void
        {
            BadgeManager._instance = this;
            initialized = false;
            this._myLife.server.addEventListener(MyLifeEvent.BADGE_EARNED_EVENT, badgeEarnedHandler, false, 0, true);
            _myLife.server.addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, checkPlayerVisitBadge);
            getPlayerBadges(_myLife.player._character);
            updateTotalBadgeList();
            return;
        }

        public function getBadgeName(arg1:int, arg2:int=-1):String
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = 0;
            if (arg2 >= 0)
            {
                loc4 = getBadgeIdFromTypeLevel(arg1, arg2);
                loc3 = getBadgeProperty(loc4, "badge_name");
            }
            else 
            {
                loc3 = _variables["badge"][("name_" + arg1)];
            }
            return loc3 ? loc3 : "";
        }

        public function badgesWindowCloseHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (_badgesWindow)
            {
                _myLife.hideDialog(_badgesWindow);
                _badgesWindow = null;
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE));
            }
            return;
        }

        public function get TotalBadgeList():Array
        {
            return totalBadgeList;
        }

        public function getPlayerBadgeListCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = null;
            loc6 = 0;
            loc7 = 0;
            loc8 = 0;
            _myLife.server.removeEventListener(MyLifeEvent.GET_PLAYER_BADGE_LIST_COMPLETE, getPlayerBadgeListCompleteHandler);
            loc2 = arg1.eventData.playerBadgeData as Array;
            loc3 = TotalBadgeList;
            loc4 = new Array(loc3.length);
            loc9 = 0;
            loc10 = loc2;
            for each (loc5 in loc10)
            {
                if (loc5 == null)
                {
                    continue;
                }
                loc6 = loc5.maxLevel;
                loc7 = loc5.badgeType;
                loc8 = 0;
                loc4[loc7] = [];
                while (loc8 <= loc6) 
                {
                    loc4[loc7].push(loc8);
                    ++loc8;
                }
            }
            _clickedCharacter = null;
            return;
        }

        public function openBadgesWindow(arg1:flash.display.MovieClip=null, arg2:int=-1, arg3:String=null):void
        {
            if (!_badgesWindow)
            {
                if (arg1 == null)
                {
                    if (arg2 >= 0 && !(arg3 == null))
                    {
                        _badgesWindow = new BadgesWindow(null, arg2, arg3);
                    }
                }
                else 
                {
                    _badgesWindow = new BadgesWindow(arg1 as Character);
                }
                _myLife.showDialog(_badgesWindow);
                _badgesWindow.addEventListener(MyLifeEvent.WINDOW_CLOSE, badgesWindowCloseHandler);
            }
            return;
        }

        private function updateTotalBadgeList():void
        {
            this._myLife.server.addEventListener(MyLifeEvent.GET_BADGE_LIST_COMPLETE, getBadgeListCompleteHandler, false, 0, true);
            this._myLife.server.callExtension("BadgeManager.getBadgeList");
            return;
        }

        private function badgeCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, badgeCompleteHandler);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, badgeErrorHandler);
            return;
        }

        private function getBadgeListCompleteHandler(arg1:MyLife.MyLifeEvent=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = null;
            loc6 = 0;
            loc7 = 0;
            loc8 = 0;
            this._myLife.server.removeEventListener(MyLifeEvent.GET_BADGE_LIST_COMPLETE, getBadgeListCompleteHandler);
            loc2 = arg1.eventData || {};
            loc3 = loc2.badgeData || [];
            loc4 = loc3.length;
            totalBadgeData = loc3;
            totalBadgeList = [];
            loc9 = 0;
            loc10 = loc3;
            for each (loc5 in loc10)
            {
                if (!loc5)
                {
                    continue;
                }
                loc6 = loc5.badge_type;
                loc7 = loc5.level;
                loc8 = loc5.badge_id;
                if (!totalBadgeList[loc6])
                {
                    totalBadgeList[loc6] = [];
                }
                totalBadgeList[loc6][loc7] = loc8;
            }
            initialized = true;
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.BADGE_MANAGER_INITIALIZED));
            return;
        }

        public function getLargeImageURL(arg1:int, arg2:int):String
        {
            var loc3:*;
            var loc4:*;

            if (arg1 < 0 || arg2 < 0)
            {
                return null;
            }
            loc3 = getBadgeIdFromTypeLevel(arg1, arg2);
            if (loc4 = getBadgeProperty(loc3, "large_image"))
            {
                return _variables["global"]["badge_asset_path"] + loc4;
            }
            return null;
        }

        public function alertWindowCloseHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            if (_badgeAlertWindow)
            {
                _myLife.hideDialog(_badgeAlertWindow);
                _badgeAlertWindow = null;
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE));
            }
            if (badgeAlertQueue.length > 0)
            {
                loc2 = badgeAlertQueue.pop();
                loc3 = loc2[0];
                loc4 = loc2[1];
                openAlertWindow(loc3, loc4);
            }
            return;
        }

        public function getBadgeLevelName(arg1:int):String
        {
            var loc2:*;

            loc2 = _variables["badge"][("level_" + arg1)];
            return loc2 ? loc2 : "";
        }

        public function isInitialized():Boolean
        {
            return initialized;
        }

        public function getBadgeDescription(arg1:int, arg2:int):String
        {
            var loc3:*;
            var loc4:*;

            if (arg2 < 0)
            {
                arg2 = 0;
            }
            loc3 = getBadgeIdFromTypeLevel(arg1, arg2);
            return (loc4 = getBadgeProperty(loc3, "description")) ? loc4 : "";
        }

        public function getMicroImageURL(arg1:int, arg2:int):String
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = _variables["global"]["badge_asset_path"] + _variables["badge"]["default"]["micro"];
            loc3 = loc3 ? loc3 : "";
            if (arg1 < 0 || arg2 < 0)
            {
                return loc3;
            }
            loc4 = this.getBadgeIdFromTypeLevel(arg1, arg2);
            if (loc5 = getBadgeProperty(loc4, "icon"))
            {
                return _variables["global"]["badge_asset_path"] + loc5;
            }
            return loc3;
        }

        public function getBadgeIdFromTypeLevel(arg1:int, arg2:int):int
        {
            if (arg1 < 0 || arg2 < 0)
            {
                return 0;
            }
            if (totalBadgeList[arg1] && totalBadgeList[arg1][arg2])
            {
                return totalBadgeList[arg1][arg2];
            }
            return 0;
        }

        public function getPlayerBadgesById(arg1:int):void
        {
            _myLife.server.addEventListener(MyLifeEvent.GET_PLAYER_BADGE_LIST_COMPLETE, getPlayerBadgeListCompleteHandler);
            _myLife.server.callExtension("BadgeManager.getPlayerBadges", {"playerId":arg1, "serverUser":null});
            return;
        }

        public function openAlertWindow(arg1:int, arg2:int):void
        {
            if (!_badgeAlertWindow && arg1 >= 0 && arg2 >= 0)
            {
                _badgeAlertWindow = new BadgeAlertWindow(arg1, arg2);
                _myLife.showDialog(_badgeAlertWindow, true, true);
                _badgeAlertWindow.addEventListener(MyLifeEvent.WINDOW_CLOSE, alertWindowCloseHandler);
            }
            else 
            {
                badgeAlertQueue.push(new Array(arg1, arg2));
                _badgeAlertWindow.hideViewButton();
            }
            return;
        }

        public function getBadgeLevelFromId(arg1:int):int
        {
            var loc2:*;

            loc2 = getBadgeProperty(arg1, "level");
            if (loc2 != null)
            {
                return loc2;
            }
            return -1;
        }

        public function get badgeAlertWindow():MyLife.Interfaces.BadgeAlertWindow
        {
            return _badgeAlertWindow;
        }

        public function getBadgeProperty(arg1:int, arg2:String):*
        {
            if (arg1 <= 0)
            {
                return null;
            }
            if (totalBadgeData[arg1] && totalBadgeData[arg1].hasOwnProperty(arg2))
            {
                return totalBadgeData[arg1][arg2];
            }
            return null;
        }

        private function badgeErrorHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, badgeCompleteHandler);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, badgeErrorHandler);
            return;
        }

        public function keyDownHandler(arg1:flash.events.KeyboardEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {};
            loc2.badgeType = 6;
            loc2.amount = 1;
            loc3 = {};
            loc3.playerId = "";
            loc3.result = "1";
            loc3.gameType = 1;
            _myLife.server.callExtension("GameManager.registerGameResult", loc3);
            return;
        }

        public function badgeEarnedHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.eventData;
            loc3 = loc2.badgeType;
            loc4 = loc2.badgeLevel;
            _myLife.player.updateDisplayBadge(loc3, loc4);
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.DISPLAY_BADGE_UPDATED));
            openAlertWindow(loc3, loc4);
            ShortStoryPublisher.instance.dispatchEvent(new MyLifeEvent(MyLifeEvent.FB_ADD_ITEM_TO_STORY, new BadgeFeedObject(_myLife.player._playerId, getBadgeName(loc3, loc4), getLargeImageURL(loc3, loc4), getBadgeIdFromTypeLevel(loc3, loc4))));
            return;
        }

        public function getPlayerBadges(arg1:MyLife.Character):void
        {
            if (!_clickedCharacter && !(arg1 == null))
            {
                _clickedCharacter = arg1;
                this._myLife.server.addEventListener(MyLifeEvent.GET_PLAYER_BADGE_LIST_COMPLETE, getPlayerBadgeListCompleteHandler);
                this._myLife.server.callExtension("BadgeManager.getPlayerBadges", {"playerId":arg1.myLifePlayerId, "serverUser":arg1.serverUserId});
            }
            return;
        }

        public function getBadgeIntro(arg1:int, arg2:int):String
        {
            var loc3:*;
            var loc4:*;

            loc3 = getBadgeIdFromTypeLevel(arg1, arg2);
            return (loc4 = getBadgeProperty(loc3, "intro")) ? loc4 : "";
        }

        public static function get instance():MyLife.BadgeManager
        {
            if (!_instance)
            {
                _instance = new BadgeManager();
            }
            return _instance;
        }

        
        {
            BADGE_VISIT_ID = 5;
            IMAGE_CACHE_SIZE = 30;
        }

        private var totalBadgeData:Array;

        private var badgeAlertQueue:Array;

        private var _clickedCharacter:MyLife.Character;

        private var _badgesWindow:MyLife.Interfaces.BadgesWindow;

        private var _badgeAlertWindow:MyLife.Interfaces.BadgeAlertWindow;

        private var _interface:flash.display.MovieClip;

        private var initialized:Boolean;

        public var imageCache:flash.utils.Dictionary;

        private var _myLife:flash.display.MovieClip;

        private var _variables:Object;

        private var totalBadgeList:Array;

        public static var IMAGE_CACHE_SIZE:int=30;

        private static var _instance:MyLife.BadgeManager;

        private static var BADGE_VISIT_ID:int=5;
    }
}
