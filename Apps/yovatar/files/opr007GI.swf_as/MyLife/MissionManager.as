package MyLife 
{
    import MyLife.Interfaces.*;
    import MyLife.NPC.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class MissionManager extends Object
    {
        public function MissionManager()
        {
            super();
            _linkTracker = new LinkTracker();
            _isOnMission = false;
            ignoreCount = 0;
            _trackingLinks = {"fight":{"link":"2698", "client":"1533"}, "kiss":{"link":"2696", "client":"1533"}, "dance":{"link":"2699", "client":"1533"}, "message":{"link":"2697", "client":"1533"}, "gift":{"link":"2693", "client":"1533"}, "joke":{"link":"2694", "client":"1533"}};
            missions = [{"description":"I am feeling feisty today! Would you like to come and show me what you are made of?", "engageButtonText":"Ready to Fight?", "action":"fight", "onSiteDescription":"Glad you made it over, are you ready to throw down?", "completeDialogue":"Rats, looks like I\'ll need more practice to beat you."}, {"description":"I am feeling feisty today! Would you like to come and show me what you are made of?", "engageButtonText":"Ready to Fight?", "action":"fight", "onSiteDescription":"Glad you made it over, are you ready to throw down?", "completeDialogue":"It\'s a Draw!  There\'s never a real winner when friends fight."}, {"description":"I am feeling feisty today! Would you like to come and show me what you are made of?", "engageButtonText":"Ready to Fight?", "action":"fight", "onSiteDescription":"Glad you made it over, are you ready to throw down?", "completeDialogue":"Try again next time; it looks like my kung-fu is better than yours!"}, {"description":"I am ready to lace up the gloves and box. Would you like to challenge me to a fight?", "engageButtonText":"Ready to Box?", "action":"fight", "onSiteDescription":"Just got my shoes on and I am ready to go, you want to throw first?", "completeDialogue":"Nice toss. Pound for pound you have one strong throw!"}, {"description":"I am ready to lace up the gloves and box. Would you like to challenge me to a fight?", "engageButtonText":"Ready to Box?", "action":"fight", "onSiteDescription":"Just got my shoes on and I am ready to go, you want to throw first?", "completeDialogue":"Sloppy toss. You could not hit the side of a barn!"}, {"description":"I am ready to lace up the gloves and box. Would you like to challenge me to a fight?", "engageButtonText":"Ready to Box?", "action":"fight", "onSiteDescription":"Just got my shoes on and I am ready to go, you want to throw first?", "completeDialogue":"Just plain splat, we might need to try that again!"}, {"description":"I just got a new pair of dancing shoes! Would you like to come over and dance with me?", "engageButtonText":"Care to Dance?", "action":"dance", "onSiteDescription":"Perfect timing, I just got my shoes on, are you ready to bust a move?", "completeDialogue":"Nice moves partner.  We can shake it with the best of them!"}, {"description":"I just got a new pair of dancing shoes! Would you like to come over and dance with me?", "engageButtonText":"Care to Dance?", "action":"dance", "onSiteDescription":"Perfect timing, I just got my shoes on, are you ready to bust a move?", "completeDialogue":"Awesome footwork! Thanks."}, {"description":"I just got a new pair of dancing shoes! Would you like to come over and dance with me?", "engageButtonText":"Care to Dance?", "action":"dance", "onSiteDescription":"Perfect timing, I just got my shoes on, are you ready to bust a move?", "completeDialogue":"So much for my new shoes, ouch, we both need better footwork!"}, {"description":"I was moving the couch and I dropped it on my toe! Can you kiss it to make it better?", "engageButtonText":"Make it better?", "action":"kiss", "onSiteDescription":"Thank you for coming over so quickly! A kiss is definitely what I need to heal quickly!", "completeDialogue":"Feels better already, Thanks!"}, {"description":"I was moving the couch and I dropped it on my toe! Can you kiss it to make it better?", "engageButtonText":"Make it better?", "action":"kiss", "onSiteDescription":"Thank you for coming over so quickly! A kiss is definitely what I need to heal quickly!", "completeDialogue":"Aww, that was so sweet. Thanks!"}, {"description":"It has been a rough day at the factory! I need to hear a good joke, got any good ones?", "engageButtonText":"Make me laugh?", "action":"joke", "onSiteDescription":"A good laugh is just what the doctor ordered, lay it on me!", "completeDialogue":"I had not heard that one before,  just what I needed!"}, {"description":"It has been a rough day at the factory! I need to hear a good joke, got any good ones?", "engageButtonText":"Make me laugh?", "action":"joke", "onSiteDescription":"A good laugh is just what the doctor ordered, lay it on me!", "completeDialogue":"That\'s awesome. Thanks, I needed a good laugh!"}, {"description":"I can not remember the last time I got a personal note at the house, could you stop by to leave me a message?", "engageButtonText":"Scribe a note?", "action":"message", "onSiteDescription":"My message board is definitely dusty, thanks for coming to leave some new marks!", "completeDialogue":"Thanks, stop by anytime to write again!"}, {"description":"I have not heard from you in a long time, can you drop me a line and let me know how you\'re doing?", "engageButtonText":"Leave a Message?", "action":"message", "onSiteDescription":"Can\'t wait to read all the latest news from you.", "completeDialogue":"It was great to hear from you, take care!"}, {"description":"I love keeping in touch with my friends, won\'t you come by and say hi?", "engageButtonText":"Scribe a note?", "action":"message", "onSiteDescription":"My message board is definitely dusty, thanks for coming to leave some new marks!", "completeDialogue":"You have such lovely handwriting!"}, {"description":"Feels like we haven\'t chatted in ages.  Tell me what\'s new with you.", "engageButtonText":"Leave a Message?", "action":"message", "onSiteDescription":"Can\'t wait to read all the latest news from you.", "completeDialogue":"Thanks for the update!"}, {"description":"Gotta broken hand or something?  Would it kill you to write me a message every once in a while?", "engageButtonText":"Scribe a note?", "action":"message", "onSiteDescription":"My message board is definitely dusty, thanks for coming to leave some new marks!", "completeDialogue":"Thanks for dropping me a line!"}, {"description":"I really need new stuff for my house! Do you have anything you would like to get rid of?", "engageButtonText":"Gift a new item?", "action":"gift", "onSiteDescription":"It is so much better to get something from a friend instead of having to buy it yourself. Are you still up for sharing today?", "completeDialogue":"You are awesome, thanks for taking the time to stop by and leave a present!"}, {"description":"I could really use something new to wear or something new to decorate my place with.", "engageButtonText":"Send a Gift?", "action":"gift", "onSiteDescription":"It is always better to give than to receive, would you agree?", "completeDialogue":"I\'ve been wanting one of these, thanks a bunch!"}, {"description":"They say it\'s better to give than receive.  You want to try it and find out?", "engageButtonText":"Gift a new item?", "action":"gift", "onSiteDescription":"I\'m not choosy, but I do have great taste.", "completeDialogue":"Thanks for helping me out, my place needs some fresh decor!"}, {"description":"You can\'t put a price on good karma, care to leave a gift?", "engageButtonText":"Send a Gift?", "action":"gift", "onSiteDescription":"It is always better to give than to receive, would you agree?", "completeDialogue":"All kidding aside, thank you for the nice gift!"}, {"description":"My furniture is getting really old, have any new stuff you would like to share?", "engageButtonText":"Gift a new item?", "action":"gift", "onSiteDescription":"I\'m not choosy, but I do have great taste.", "completeDialogue":"That was mighty nice of you, Thanks!"}];
            return;
        }

        private function onInterfaceWindowCloseHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = arg1.eventData.interfaceType;
            if (loc2)
            {
                if (loc2 == InterfaceTypes.GIFT_WINDOW || loc2 == InterfaceTypes.MESSAGE_WINDOW)
                {
                    _isOnMission = false;
                    if (_linkTracker && !_myLife.runningLocal)
                    {
                        _linkTracker.setRandomActive();
                        _linkTracker.track("2711", "1533");
                    }
                    beginMissions(CANCEL_TIME);
                }
            }
            return;
        }

        private function onMissionNextBtnClick(arg1:MyLife.MyLifeEvent):void
        {
            _myLife._interface.unloadInterface(dialog);
            beginMissions(0);
            return;
        }

        private function performAction(arg1:flash.events.MouseEvent=null):void
        {
            var loc2:*;

            _myLife._interface.unloadInterface(completeDialog);
            visitableFriends.splice(selectedFriendIndex, 1);
            setVisitedFriendId(currCharData.playerId);
            loc2 = currNPCObject.bot as AsyncFriend;
            if (loc2)
            {
                loc2.doAction(AsyncFriend.ACTION_IDLE, false);
            }
            AsyncVisitManager.instance.selectedAction = currMissionData.action;
            AsyncVisitManager.instance.doSelectedAction(currNPCObject);
            return;
        }

        private function onMissionIgnoreBtnClick(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            _myLife._interface.unloadInterface(dialog);
            if (_linkTracker && !_myLife.runningLocal)
            {
                _linkTracker.setRandomActive();
                _linkTracker.track("2710", "1533");
            }
            ignoreCount++;
            if (ignoreCount >= 2)
            {
                return;
            }
            beginMissions(IGNORE_TIME);
            return;
        }

        private function onShowMissionTimerComplete(arg1:flash.events.TimerEvent=null):void
        {
            if (showMissionTimer)
            {
                showMissionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowMissionTimerComplete);
            }
            if (_myLife.getZone().isGameMode() || _myLife.getZone().editMode)
            {
                beginMissions(COMPLETE_TIME);
            }
            else 
            {
                showMissionDialog();
            }
            return;
        }

        private function onInterfaceLoadCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            _myLife.getInterface().addEventListener(MyLifeEvent.WINDOW_CLOSE, onInterfaceWindowCloseHandler, false, 0, true);
            return;
        }

        private function showMissionCompleteDialog():void
        {
            var loc1:*;

            completeDialog = new MissionProgressInterface();
            completeDialog.btnClose.addEventListener(MouseEvent.CLICK, onMissionCancelBtnClick, false, 0, true);
            completeDialog.title.htmlText = "<b>" + currMissionData.engageButtonText + "</b>";
            completeDialog.message.text = currMissionData.onSiteDescription.replace(new RegExp("<<buddy>>", "g"), currCharData.name);
            loc1 = currMissionData.action;
            switch (loc1) 
            {
                case "dance":
                    performAction();
                    return;
                case "fight":
                    performAction();
                    return;
                case "kiss":
                    performAction();
                    return;
                case "joke":
                    performAction();
                    return;
                case "message":
                    performAction();
                    return;
                case "gift":
                    performAction();
                    return;
            }
            _myLife.showDialog(completeDialog, true);
            return;
        }

        private function onAsyncAvatarLoad(arg1:MyLife.MyLifeEvent):void
        {
            asyncTimeoutTimer.stop();
            asyncTimeoutTimer.removeEventListener(TimerEvent.TIMER, onAsyncLoadTimeout);
            currNPCObject = arg1.eventData;
            AsyncVisitManager.instance.removeEventListener(MyLifeEvent.ASYNC_AVATAR_LOADED, onAsyncAvatarLoad);
            showMissionCompleteDialog();
            return;
        }

        private function onMissionEngageBtnClick(arg1:MyLife.MyLifeEvent):void
        {
            if (_linkTracker && !_myLife.runningLocal)
            {
                _linkTracker.setRandomActive();
                _linkTracker.track("2709", "1533");
            }
            engageMission();
            return;
        }

        private function obtainFriend():MyLife.NPC.SimpleNPC
        {
            var loc1:*;

            visitableFriends = getVisitableFriendDataArray();
            loc1 = null;
            if (visitableFriends.length)
            {
                selectedFriendIndex = Math.round(Math.random() * (visitableFriends.length - 1));
                currCharData = visitableFriends[selectedFriendIndex];
                loc1 = new SimpleNPC(_myLife, -1);
                loc1.setCharacterProperties(currCharData.clothing, currCharData.gender, currCharData.name);
                loc1.loadCharacterClothing(currCharData.clothing);
            }
            return loc1;
        }

        private function getVisitedFriendIds():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = SharedObjectManager.getValue(SharedObjectManager.VISIT_DATE);
            loc2 = new Date();
            loc3 = [];
            if (loc1 && loc1.monthUTC == loc2.monthUTC && loc1.dateUTC == loc2.dateUTC)
            {
                loc3 = SharedObjectManager.getValue(SharedObjectManager.VISITED_FRIENDS) as Array;
            }
            return loc3;
        }

        public function beginMissions(arg1:int=120000):void
        {
            if (ignoreCount >= 2)
            {
                return;
            }
            if (FriendDataManager.ready)
            {
                reallyBeginMissions(arg1);
            }
            else 
            {
                FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, onFriendDataManagerReady, false, 0, true);
            }
            return;
        }

        private function onFriendDataManagerReady(arg1:flash.events.Event):void
        {
            reallyBeginMissions();
            return;
        }

        private function onNotificationSuccess(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = 0;
            loc2 = _myLife.getServer();
            if (arg1.eventData["action"] == loc2.ACTION_MANAGER_TYPE_RACE_WON || arg1.eventData["action"] == loc2.ACTION_MANAGER_TYPE_RACE_LOST || arg1.eventData["action"] == loc2.ACTION_MANAGER_TYPE_NONE)
            {
                return;
            }
            if (_isOnMission)
            {
                _isOnMission = false;
                beginMissions(COMPLETE_TIME);
                if (loc4 = currNPCObject.bot as AsyncFriend)
                {
                    loc4.doAction(AsyncFriend.ACTION_IDLE, false);
                    loc4.sayMessage("C:" + currMissionData.completeDialogue, true);
                }
                speakTimer = new Timer(2000, 1);
                speakTimer.addEventListener(TimerEvent.TIMER_COMPLETE, unsquelch);
                speakTimer.start();
            }
            loc3 = Number(arg1.eventData["playerId"]);
            if (loc3)
            {
                loc5 = 0;
                while (loc5 < visitableFriends.length) 
                {
                    if (visitableFriends[loc5].playerId == loc3)
                    {
                        visitableFriends.splice(loc5, 1);
                    }
                    ++loc5;
                }
            }
            return;
        }

        private function reallyBeginMissions(arg1:int=120000):void
        {
            visitableFriends = getVisitableFriendDataArray();
            if (visitableFriends.length > 0 && _myLife.getPlayer().friendVisitsLeft > 0)
            {
                if (showMissionTimer)
                {
                    showMissionTimer.stop();
                    showMissionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowMissionTimerComplete);
                }
                if (arg1 > 0)
                {
                    showMissionTimer = new Timer(arg1, 1);
                    showMissionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onShowMissionTimerComplete, false, 0, true);
                    showMissionTimer.start();
                }
                else 
                {
                    onShowMissionTimerComplete();
                }
            }
            return;
        }

        public function setMyLife(arg1:MyLife.MyLife):void
        {
            _myLife = arg1;
            _myLife.addEventListener(MyLifeEvent.INTERFACE_LOAD_COMPLETE, onInterfaceLoadCompleteHandler, false, 0, true);
            _myLife.server.addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, onNotificationSuccess);
            return;
        }

        private function onMissionCancelBtnClick(arg1:flash.events.MouseEvent):void
        {
            _myLife._interface.unloadInterface(completeDialog);
            if (_linkTracker && !_myLife.runningLocal)
            {
                _linkTracker.setRandomActive();
                _linkTracker.track("2711", "1533");
            }
            _isOnMission = false;
            beginMissions(CANCEL_TIME);
            return;
        }

        private function getVisitableFriendDataArray():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            loc6 = false;
            loc7 = 0;
            if (visitableFriends)
            {
                return visitableFriends;
            }
            loc1 = [];
            loc2 = FriendDataManager.getAppUserFriendData(0, true) as Array;
            loc3 = getVisitedFriendIds();
            if (!loc2)
            {
                return [];
            }
            loc4 = 0;
            while (loc4 < loc2.length) 
            {
                loc5 = loc2[loc4];
                loc6 = false;
                if (loc5.playerId != _myLife.getPlayer().getPlayerId())
                {
                    loc7 = 0;
                    while (loc7 < loc3.length) 
                    {
                        if (loc3[loc7] == loc5.playerId)
                        {
                            loc3.splice(loc7, 1);
                            loc6 = true;
                            break;
                        }
                        ++loc7;
                    }
                    if (!loc6)
                    {
                        loc1.push(loc5);
                    }
                }
                ++loc4;
            }
            return loc1;
        }

        private function setVisitedFriendId(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = new Date();
            loc3 = getVisitedFriendIds();
            loc3.push(arg1);
            SharedObjectManager.setValue(SharedObjectManager.VISITED_FRIENDS, loc3);
            SharedObjectManager.setValue(SharedObjectManager.VISIT_DATE, loc2);
            return;
        }

        private function unsquelch(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            speakTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, unsquelch);
            loc2 = currNPCObject.bot as AsyncFriend;
            if (loc2)
            {
                loc2.doAction(AsyncFriend.ACTION_IDLE, true);
            }
            return;
        }

        private function showMissionDialog():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            if (!_myLife)
            {
                return;
            }
            loc1 = obtainFriend();
            if (_myLife.getZone().currentOwnerPlayerId == currCharData.playerId)
            {
                if (visitableFriends.length > 1)
                {
                    do 
                    {
                        loc1 = obtainFriend();
                    }
                    while (_myLife.getZone().currentOwnerPlayerId == currCharData.playerId);
                }
                else 
                {
                    beginMissions(COMPLETE_TIME);
                    return;
                }
            }
            do 
            {
                currMissionData = missions[Math.round(Math.random() * (missions.length - 1))];
            }
            while (currMissionData.action == lastMissionAction);
            if (!(currMissionData.action == "gift") && !(currMissionData.action == "message"))
            {
                lastMissionAction = currMissionData.action;
            }
            dialog = new MissionInterface();
            dialog.addEventListener(MyLifeEvent.IGNORE_MISSION, onMissionIgnoreBtnClick, false, 0, true);
            dialog.addEventListener(MyLifeEvent.ENGAGE_MISSION, onMissionEngageBtnClick, false, 0, true);
            dialog.addEventListener(MyLifeEvent.NEXT_MISSION, onMissionNextBtnClick, false, 0, true);
            if (!loc1)
            {
            };
            loc2 = currMissionData.description.replace(new RegExp("<<buddy>>", "g"), currCharData.name);
            loc3 = currMissionData.engageButtonText.replace(new RegExp("<<buddy>>", "g"), currCharData.name);
            dialog.setData(loc2, loc3, currCharData, loc1);
            _myLife.showDialog(dialog, false, true);
            return;
        }

        private function engageMission():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc3 = null;
            if (!currCharData)
            {
                return;
            }
            _isOnMission = true;
            ignoreCount = 0;
            _myLife._interface.unloadInterface(dialog);
            AsyncVisitManager.instance.addEventListener(MyLifeEvent.ASYNC_AVATAR_LOADED, onAsyncAvatarLoad, false, 0, true);
            loc1 = parseInt(currCharData["default_home"]);
            loc2 = parseInt(currCharData["playerId"]);
            if (loc1)
            {
                _myLife.getZone().joinHomeRoom(loc1, loc2);
            }
            else 
            {
                loc3 = "APLiving-" + loc2;
                _myLife.getZone().join(loc3, 0);
            }
            asyncTimeoutTimer = new Timer(ASYNC_LOAD_TIMEOUT);
            asyncTimeoutTimer.addEventListener(TimerEvent.TIMER, onAsyncLoadTimeout, false, 0, true);
            asyncTimeoutTimer.start();
            return;
        }

        private function onAsyncLoadTimeout(arg1:flash.events.TimerEvent):void
        {
            _isOnMission = false;
            asyncTimeoutTimer.stop();
            asyncTimeoutTimer.removeEventListener(TimerEvent.TIMER, onAsyncLoadTimeout);
            beginMissions(IGNORE_TIME);
            return;
        }

        public static function get instance():MyLife.MissionManager
        {
            if (!_instance)
            {
                _instance = new MissionManager();
            }
            return _instance;
        }

        public static function get trackingLinks():Object
        {
            return _trackingLinks;
        }

        public static function get isOnMission():Boolean
        {
            return _isOnMission;
        }

        private const COMPLETE_TIME:int=3000;

        private const IGNORE_TIME:int=300000;

        private const ASYNC_LOAD_TIMEOUT:int=45000;

        private const STARTING_TIME:int=120000;

        private const CANCEL_TIME:int=300000;

        private var currCharData:Object;

        private var asyncTimeoutTimer:flash.utils.Timer;

        private var _linkTracker:MyLife.LinkTracker;

        private var speakTimer:flash.utils.Timer;

        private var visitableFriends:Array;

        private var showMissionTimer:flash.utils.Timer;

        private var selectedFriendIndex:int;

        private var currMissionData:Object;

        private var dialog:MyLife.Interfaces.MissionInterface;

        private var ignoreCount:int;

        private var completeDialog:MyLife.Interfaces.MissionProgressInterface;

        private var lastMissionIndex:int;

        private var _myLife:MyLife.MyLife;

        private var currNPCObject:Object;

        private var missions:Array;

        private var lastMissionAction:String;

        private static var _trackingLinks:Object;

        private static var _isOnMission:Boolean;

        private static var _instance:MyLife.MissionManager;
    }
}
