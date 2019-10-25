package MyLife.Xp 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.FB.*;
    import MyLife.FB.Objects.*;
    import MyLife.FB.ShortStories.*;
    import MyLife.Games.*;
    import MyLife.Interfaces.*;
    import com.adobe.serialization.json.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class XpManager extends flash.events.EventDispatcher
    {
        public function XpManager()
        {
            _upcomingRewards = [];
            _pendingLevelDialogs = [];
            super();
            if (!_allowInstantiation)
            {
                throw new Error("Error: Instantiation failed: Use XpManager.getInstance() instead of new.");
            }
            this.init();
            return;
        }

        private function mouseClickProgressBarHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (isInitialized())
            {
                if (_level < getMaxLevel())
                {
                    loc2 = getUpcomingReward(RewardType.NONE);
                    if (loc2)
                    {
                        loc3 = new XpNextLevelDialog(getLevelData(loc2.getLevel()).getThreshold(), loc2.getReward());
                        (loc4 = new StandardDialog(loc3, "", 320, 400, 320, 300, false)).show(true);
                    }
                }
            }
            return;
        }

        private function staticDataCompleteHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            if (arg1.data.hasOwnProperty("staticData"))
            {
                _staticData = arg1.data.staticData as Array;
                if (!_isStaticDataInitialized)
                {
                    dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_STATIC_DATA_INITIALIZED));
                }
            }
            return;
        }

        private function delayedUpdateHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (!(MyLifeInstance.getInstance() as MyLife).getZone().isGameMode() && !(MyLifeInstance.getInstance() as MyLife).isDialogOpen())
            {
                _canShowUpdate = true;
                loc2 = new Timer(500);
                loc2.addEventListener(TimerEvent.TIMER, runUpdateHandler);
                loc2.start();
            }
            return;
        }

        private function init():void
        {
            XpManager._instance = this;
            _server = MyLifeInstance.getInstance().getServer();
            _xpProgressBar = new XpProgressBar();
            setupEventListeners();
            ShortStoryPublisher.instance.putStory(new XPFeedStory(), ShortStoryPublisher.XP_FEED);
            return;
        }

        private function mouseOutProgressBarHandler(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        private function onInitializedHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            setupXpProgressBar();
            return;
        }

        private function setupXpProgressBar():void
        {
            var barValue:int;
            var level:int;
            var loc1:*;
            var loc2:*;
            var lowerThreshold:int;
            var upperThreshold:int;
            var xpCount:int;

            level = 0;
            xpCount = 0;
            upperThreshold = 0;
            lowerThreshold = 0;
            barValue = 0;
            level = getPlayerProgress().getMaxLevel();
            if (level >= 0)
            {
                xpCount = getPlayerProgress().getXpCount();
                upperThreshold = getPlayerProgress().getThreshold();
                if (getPlayerProgress().getMaxLevel() <= 0)
                {
                    lowerThreshold = 0;
                }
                else 
                {
                    if (getLevelData(getPlayerProgress().getMaxLevel()))
                    {
                        lowerThreshold = getLevelData(getPlayerProgress().getMaxLevel()).getThreshold();
                    }
                    else 
                    {
                        lowerThreshold = 0;
                    }
                }
                barValue = xpCount;
                if (xpCount > upperThreshold)
                {
                    barValue = upperThreshold;
                }
                try
                {
                    _xpProgressBar.init(upperThreshold, lowerThreshold, barValue, level);
                }
                catch (e:Error)
                {
                    if (lowerThreshold > barValue)
                    {
                        lowerThreshold = barValue;
                    }
                    else 
                    {
                        if (upperThreshold <= barValue)
                        {
                            upperThreshold = barValue + 1;
                        }
                    }
                    _xpProgressBar.init(upperThreshold, lowerThreshold, barValue, level);
                }
            }
            else 
            {
                _xpProgressBarError = true;
                requestProgress(MyLifeInstance.getInstance().getPlayer().getCharacter().getPlayerId(), MyLifeInstance.getInstance().getPlayer().getCharacter().getServerUserId());
            }
            _xpProgressBar.buttonMode = true;
            _xpProgressBar.useHandCursor = true;
            return;
        }

        private function playGainXpAnimation():void
        {
            var loc1:*;

            loc1 = _currentDisplayXp - _lastDisplayXp;
            _lastDisplayXp = _currentDisplayXp;
            dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_GAIN_XP, {"xp":loc1}));
            return;
        }

        private function asyncVisitHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = NaN;
            loc3 = 0;
            loc4 = null;
            loc5 = null;
            if (arg1.eventData)
            {
                loc2 = Number(arg1.eventData["reward"]);
                if (arg1.eventData.hasOwnProperty("action"))
                {
                    loc3 = arg1.eventData["action"];
                }
                if (arg1.eventData.hasOwnProperty("key"))
                {
                    loc4 = arg1.eventData["key"];
                }
            }
            if (loc4 && loc3)
            {
                (loc5 = {}).key = loc4;
                loc5.action = loc3;
                loc5.amt = 1;
                _server.callExtension("XpManager.updateVisitXpSFS", loc5);
            }
            return;
        }

        public function getLevelData(arg1:int):MyLife.Xp.LevelData
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = getStaticData();
            if (loc2.length > arg1)
            {
                if (loc2[arg1].level == arg1)
                {
                    return new LevelData(loc2[arg1].level as int, loc2[arg1].threshold as int, loc2[arg1].name as String);
                }
            }
            loc4 = 0;
            loc5 = loc2;
            for each (loc3 in loc5)
            {
                if (loc3.level != arg1)
                {
                    continue;
                }
                return new LevelData(loc3.level as int, loc3.threshold as int, loc3.name as String);
            }
            return null;
        }

        public function getPlayerProgress():MyLife.Xp.ProgressData
        {
            return _playerProgressData;
        }

        private function initializationHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            if (arg1.type == XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED)
            {
                removeEventListener(XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED, initializationHandler);
                _isProgressInitialized = true;
            }
            if (arg1.type == XpManagerEvent.XP_MANAGER_STATIC_DATA_INITIALIZED)
            {
                removeEventListener(XpManagerEvent.XP_MANAGER_STATIC_DATA_INITIALIZED, initializationHandler);
                _isStaticDataInitialized = true;
            }
            if (arg1.type == XpManagerEvent.XP_MANAGER_UPCOMING_REWARDS_INITIALIZED)
            {
                removeEventListener(XpManagerEvent.XP_MANAGER_UPCOMING_REWARDS_INITIALIZED, initializationHandler);
                _isUpcomingRewardsInitialized = true;
            }
            if (_isProgressInitialized && _isStaticDataInitialized && _isUpcomingRewardsInitialized)
            {
                _isInitialized = true;
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_INITIALIZED));
            }
            return;
        }

        private function sendFriendNotifs():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            trace("***** Check for passed friends. *****");
            loc1 = FriendDataManager.getAppUserFriendData(0, true) as Array;
            loc2 = false;
            loc1.sortOn(["xp_count"]);
            loc3 = 0;
            while (loc3 < 5 && loc1.length) 
            {
                loc4 = loc1.shift();
                if (getLevelFromXp(loc4.xp_count).getLevel() == (_level - 1))
                {
                    loc2 = true;
                    ++loc3;
                    loc5 = (loc5 = (loc5 = (loc5 = MyLifeConfiguration.getInstance().variables["global"]["game_control_server"]) + "new_level.php?levelMsg=1&player_receiver=" + loc4.playerId) + "&player_id=" + MyLifeConfiguration.getInstance().playerId) + "&" + MyLifeConfiguration.networkCredentials;
                    trace("***** " + loc5 + " *****");
                    loc6 = new URLLoader(new URLRequest(loc5));
                    continue;
                }
                if (!loc2)
                {
                    continue;
                }
                break;
            }
            return;
        }

        private function setupEventListeners():void
        {
            _server.addEventListener(XpManagerEvent.XP_MANAGER_UPDATE_PROGRESS, updateXpHandler);
            _server.addEventListener(XpManagerEvent.XP_MANAGER_NEW_LEVEL, newLevelHandler);
            _server.addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, asyncVisitHandler);
            _server.addEventListener(XpManagerEvent.XP_MANAGER_PROCESS_REWARD, processRewardHandler);
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.PLAYER_ACTIVATED, requestDataHandler);
            _xpProgressBar.addEventListener(XpManagerEvent.XP_PROGRESS_BAR_FULL, xpProgressBarFullHandler);
            _xpProgressBar.addEventListener(MouseEvent.MOUSE_OVER, mouseOverProgressBarHandler);
            _xpProgressBar.addEventListener(MouseEvent.MOUSE_OUT, mouseOutProgressBarHandler);
            _xpProgressBar.addEventListener(MouseEvent.CLICK, mouseClickProgressBarHandler);
            _xpProgressBar.addEventListener(XpManagerEvent.XP_PROGRESS_BAR_ANIMATION_COMPLETE, xpProgressBarAnimationCompleteHandler);
            addEventListener(XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED, initializationHandler);
            addEventListener(XpManagerEvent.XP_MANAGER_STATIC_DATA_INITIALIZED, initializationHandler);
            addEventListener(XpManagerEvent.XP_MANAGER_UPCOMING_REWARDS_INITIALIZED, initializationHandler);
            addEventListener(XpManagerEvent.XP_MANAGER_INITIALIZED, onInitializedHandler);
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.INTERFACE_DIALOG_OPEN, suspendUpdatesManager);
            addEventListener(XpManagerEvent.XP_MANAGER_SUSPEND_UPDATES, suspendUpdatesHandler);
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.INTERFACE_DIALOG_QUEUE_EMPTY, suspendUpdatesManager);
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.INTERFACE_DELAYED_DIALOG_READY, suspendUpdatesManager);
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.INTERFACE_LOW_PRIORITY_DIALOG_READY, suspendUpdatesManager);
            GameManager.instance.addEventListener(GameManagerEvent.GAME_START, suspendUpdatesManager);
            GameManager.instance.addEventListener(GameManagerEvent.GAME_EXIT, suspendUpdatesManager);
            addEventListener(XpManagerEvent.XP_MANAGER_CAN_SHOW_UPDATE, delayedUpdateHandler);
            if ((MyLifeInstance.getInstance() as MyLife).runningLocal)
            {
                MyLifeInstance.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
            }
            return;
        }

        private function requestStaticData():void
        {
            _server.addEventListener(XpManagerEvent.XP_STATIC_DATA_COMPLETE, staticDataCompleteHandler);
            _server.callExtension("XpManager.getStaticData");
            return;
        }

        private function requestDataHandler(arg1:MyLife.MyLifeEvent):void
        {
            MyLifeInstance.getInstance().removeEventListener(MyLifeEvent.PLAYER_ACTIVATED, requestDataHandler);
            requestStaticData();
            requestProgress(MyLifeInstance.getInstance().getPlayer().getPlayerId(), MyLifeInstance.getInstance().getServer().getUserId());
            addEventListener(XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED, requestUpcomingRewards);
            return;
        }

        private function processUpcomingRewards(arg1:Array):void
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

            loc2 = null;
            loc3 = 0;
            loc4 = null;
            loc5 = 0;
            loc6 = 0;
            loc7 = null;
            loc8 = null;
            loc9 = 0;
            loc10 = arg1;
            for each (loc2 in loc10)
            {
                loc3 = loc2.rewardType;
                loc4 = new RewardType(loc3);
                loc5 = loc2.rewardId;
                loc6 = loc2.level;
                loc7 = loc2.rewardObject;
                loc8 = new Reward(loc4, loc5, loc7);
                _upcomingRewards[loc4.toString()] = new UpcomingReward(loc6, loc8, loc4);
                if (loc6 != _level + 1)
                {
                    continue;
                }
                _upcomingRewards[RewardType.NONE.toString()] = new UpcomingReward(loc6, loc8, RewardType.NONE);
            }
            return;
        }

        private function upcomingRewardsHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;

            loc2 = null;
            _server.removeEventListener(XpManagerEvent.XP_UPCOMING_REWARDS_COMPLETE, upcomingRewardsHandler);
            if (arg1.data.hasOwnProperty("upcomingRewards"))
            {
                loc2 = arg1.data.upcomingRewards;
                processUpcomingRewards(loc2);
            }
            if (!_isUpcomingRewardsInitialized)
            {
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_UPCOMING_REWARDS_INITIALIZED));
            }
            return;
        }

        private function newLevelAlertClosedHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = null;
            loc6 = NaN;
            loc2 = _xpProgressBar.getLevel();
            loc3 = getLevelData(loc2);
            loc4 = getLevelData(loc2 + 1);
            if (loc3 && loc4)
            {
                _xpProgressBar.setLevel(_xp, loc2, loc3.getThreshold(), loc4.getThreshold());
                loc6 = (loc5 = MyLifeInstance.getInstance() as MyLife).getPlayer().getCharacter().getServerUserId();
                ActionTweenManager.instance.makeActionTween(ActionTweenType.LEVEL, loc6, loc6, {"xp":loc2});
                ActionTweenManager.instance.broadcastActionTween(ActionTweenType.LEVEL, loc6, loc6, {"xp":loc2});
            }
            return;
        }

        private function mouseOverProgressBarHandler(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        public function getTitle():String
        {
            return _title;
        }

        public function getStaticData():Array
        {
            return _staticData;
        }

        public function isInitialized():Boolean
        {
            return _isInitialized;
        }

        public function getXpProgressBar():MyLife.Xp.XpProgressBar
        {
            return _xpProgressBar;
        }

        private function xpProgressBarAnimationCompleteHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            return;
        }

        private function xpProgressBarFullHandler(arg1:MyLife.Xp.XpManagerEvent):void
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
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc2 = 0;
            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            loc7 = null;
            loc8 = null;
            loc9 = 0;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            loc13 = false;
            if (arg1.data.hasOwnProperty("xpTextValue"))
            {
                loc3 = arg1.data.xpTextValue;
            }
            if (arg1.data.hasOwnProperty("xpValue"))
            {
                loc2 = arg1.data.xpValue as int;
            }
            if (arg1.data.hasOwnProperty("level"))
            {
                loc4 = arg1.data.level as int;
            }
            if (arg1.data.hasOwnProperty("upperThreshold"))
            {
                loc5 = arg1.data.upperThreshold as int;
            }
            loc6 = getPlayerProgress();
            if (_xpProgressBar.getLevelVisibility())
            {
                loc7 = getLevelData(loc4 + 1);
                loc8 = getLevelData(loc4 + 2);
            }
            else 
            {
                _xpProgressBar.setLevelVisibility(true);
                loc7 = getLevelData(loc4);
                loc8 = getLevelData(loc4 + 1);
            }
            if (loc7)
            {
                _xpProgressBar.showLevel(loc7.getLevel());
                if (loc8)
                {
                    loc9 = loc8.getThreshold();
                }
                if (_xpProgressBar.getLevel() <= _level)
                {
                    if (canShowNewLevelDialog())
                    {
                        loc12 = _readyDelayedDialog.dialog as StandardDialog;
                        loc13 = _readyDelayedDialog.modal;
                        loc12.addEventListener(MyLifeEvent.WINDOW_CLOSE, newLevelAlertClosedHandler);
                        loc12.show(true);
                        _dialogReadyForCleanup = true;
                        (loc12.getContent() as XpNewLevelDialog).playAction();
                        loc12.dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_DELAYED_DIALOG_DONE));
                    }
                }
            }
            return;
        }

        public function getLevelFromXp(arg1:int):MyLife.Xp.LevelData
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

            loc6 = 0;
            loc7 = null;
            loc8 = null;
            loc2 = getStaticData();
            loc3 = 0;
            loc4 = 1;
            loc5 = null;
            if (loc2)
            {
                loc6 = 0;
                loc9 = 0;
                loc10 = loc2;
                for each (loc7 in loc10)
                {
                    if (arg1 >= loc3 && arg1 < loc7.threshold)
                    {
                        if (!loc5)
                        {
                            loc5 = loc7.name;
                        }
                        return new LevelData(loc4, loc7.threshold as int, loc7.name as String);
                    }
                    loc4 = loc7.level as int;
                    loc5 = loc7.name as String;
                    ++loc6;
                }
                loc8 = loc2[(loc6 - 1)];
                return new LevelData(loc8.level as int, loc8.threshold as int, loc8.name as String);
            }
            return null;
        }

        private function requestUpcomingRewards(arg1:MyLife.Xp.XpManagerEvent):void
        {
            removeEventListener(XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED, requestUpcomingRewards);
            _server.addEventListener(XpManagerEvent.XP_UPCOMING_REWARDS_COMPLETE, upcomingRewardsHandler);
            _server.callExtension("XpManager.getUpcomingRewards");
            return;
        }

        public function getUpcomingReward(arg1:MyLife.Xp.RewardType):MyLife.Xp.UpcomingReward
        {
            if (_upcomingRewards.hasOwnProperty(arg1.toString()))
            {
                return _upcomingRewards[arg1.toString()];
            }
            return null;
        }

        private function requestProgress(arg1:int, arg2:int):void
        {
            var loc3:*;

            loc3 = {};
            loc3.playerId = arg1;
            loc3.serverUser = arg2;
            _server.addEventListener(XpManagerEvent.XP_PLAYER_DATA_COMPLETE, progressCompleteHandler);
            _server.callExtension("XpManager.getProgress", loc3);
            return;
        }

        private function progressCompleteHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            loc6 = 0;
            loc7 = null;
            if (arg1.data.hasOwnProperty("progressArray"))
            {
                loc2 = arg1.data.progressArray;
                loc3 = int(loc2.player_id);
                loc4 = int(loc2.xp_count);
                loc5 = int(loc2.max_level);
                loc6 = int(loc2.threshold);
                _playerProgressData = new ProgressData(loc3, loc4, loc5, loc6);
            }
            if (arg1.data.hasOwnProperty("title"))
            {
                loc7 = arg1.data.title as String;
            }
            if (_xpProgressBarError)
            {
                _xpProgressBarError = false;
                _xpProgressBar.init(_playerProgressData.getThreshold(), getLevelData(_playerProgressData.getMaxLevel()).getThreshold(), _playerProgressData.getXpCount(), _playerProgressData.getMaxLevel());
            }
            if (!_isProgressInitialized)
            {
                updateXpHandler(arg1);
                _title = loc7;
                _level = loc5;
                _xp = loc4;
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_PROGRESS_INITIALIZED));
            }
            return;
        }

        private function updateXpHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            loc6 = 0;
            if (arg1.data.hasOwnProperty("progressArray"))
            {
                loc2 = arg1.data.progressArray;
                loc3 = int(loc2.player_id);
                loc4 = int(loc2.xp_count);
                loc5 = int(loc2.max_level);
                loc6 = int(loc2.threshold);
                _deltaXp = (_lastXp >= 0) ? loc4 - _lastXp : 0;
                _lastXp = loc4;
                if (_lastDisplayXp < 0)
                {
                    _lastDisplayXp = loc4;
                }
                _currentDisplayXp = loc4;
                if (isInitialized())
                {
                    if (loc4 != _xp)
                    {
                        _xp = loc4;
                        if (_canShowUpdate)
                        {
                            if (_xpProgressBar.moveTo(loc4) != loc4)
                            {
                                _updatePending = true;
                            }
                            else 
                            {
                                _updatePending = false;
                            }
                            if (_deltaXp)
                            {
                                playGainXpAnimation();
                                _deltaXp = 0;
                            }
                        }
                        else 
                        {
                            _updatePending = true;
                        }
                    }
                }
            }
            return;
        }

        private function keyHandler(arg1:flash.events.KeyboardEvent):void
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
            var loc11:*;
            var loc12:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = NaN;
            if (arg1.keyCode != 49)
            {
                if (arg1.keyCode != 50)
                {
                    if (arg1.keyCode != 51)
                    {
                        if (arg1.keyCode != 52)
                        {
                            if (arg1.keyCode == 53 || arg1.keyCode == 54 || arg1.keyCode == 55 || arg1.keyCode == 56 || arg1.keyCode == 57)
                            {
                                if (arg1.keyCode == 53)
                                {
                                    loc2 = RewardType.ACCESSORY;
                                }
                                if (arg1.keyCode == 54)
                                {
                                    loc2 = RewardType.ACTION;
                                }
                                if (arg1.keyCode == 55)
                                {
                                    loc2 = RewardType.DANCE;
                                }
                                if (arg1.keyCode == 56)
                                {
                                    loc2 = RewardType.ITEM;
                                }
                                if (arg1.keyCode == 57)
                                {
                                    loc2 = RewardType.POSE;
                                }
                                loc3 = getUpcomingReward(loc2);
                                if (loc3)
                                {
                                    (loc4 = new StandardDialog(new XpNextLevelDialog(getLevelData(loc3.getLevel()).getThreshold(), loc3.getReward()), "Next Level")).show(true);
                                }
                            }
                        }
                        else 
                        {
                            _xpProgressBar.moveTo(_xpProgressBar.getValue() + 32007);
                        }
                    }
                    else 
                    {
                        _xpProgressBar.moveTo(_xpProgressBar.getValue() - 10);
                    }
                }
                else 
                {
                    requestProgress(MyLifeInstance.getInstance().getPlayer().getCharacter().getPlayerId(), MyLifeInstance.getInstance().getPlayer().getCharacter().getServerUserId());
                }
            }
            else 
            {
                requestStaticData();
            }
            if (arg1.keyCode == 74 || arg1.keyCode == 75 || arg1.keyCode == 76)
            {
                loc5 = {};
                loc6 = 0;
                loc7 = RewardType.ITEM;
                loc12 = arg1.keyCode;
                switch (loc12) 
                {
                    case 74:
                        loc5 = {"created_on":"2009-05-14 20:20:12.0", "can_sell":"0", "refundable":"1", "trade_limit":"0", "item_category":"2004", "item_categories.active":"1", "category":"Lamps", "can_charity":"0", "parent_category":"5", "item_category_id":"2004", "items.sort_order":"2663200", "item_id":"26632", "default_player_item_qty":"0", "special":"0", "filename":"XPLampLv2", "can_gift":"0", "gender":"0", "items.active":"2", "can_consume":"0", "room_rating":"0", "description":"Your lamp now has a <b>Black\r\nLight</b>. Click the lamp to try\r\nit out!", "crew_members":"0", "must_consume":"0", "price_cash":"0", "name":"XP Lamp Level 2", "meta_data":"prev:26628|1:26628|2:26632", "price":"0"};
                        loc6 = 26632;
                        loc7 = RewardType.LEVELING_ITEM;
                        break;
                    case 75:
                        loc5 = {"meta_data":"prev:26599", "trade_limit":"0", "item_category":"2009", "filename":"SprFlwrs_Iris", "items.sort_order":"2660000", "can_gift":"0", "items.active":"1", "can_consume":"0", "can_sell":"0", "item_categories.active":"1", "can_charity":"0", "item_category_id":"2009", "created_on":"2009-05-02 00:44:29.0", "item_id":"26600", "price":"250", "must_consume":"0", "gender":"0", "parent_category":"5", "name":"Spring Irises", "default_player_item_qty":"0", "room_rating":"0", "description":"", "special":"0", "category":"Plants", "refundable":"1", "crew_members":"0", "price_cash":"0"};
                        loc6 = 26600;
                        loc7 = RewardType.ITEM;
                        break;
                    case 76:
                        loc5 = {"itemId":"26639", "swf":"", "categoryId":"2053", "name":"KungFu", "g":"0", "playerItemId":"1000014375", "can_consume":"0", "metaData":"energy:10|action:kungFu", "playerId":"100000386", "price":"0", "parentCategoryId":"2050", "filename":"kungFu", "startItem":"0", "category":"Action"};
                        loc6 = 26639;
                        loc7 = RewardType.ACTION;
                        break;
                }
                loc8 = new Reward(loc7, loc6, loc5);
                loc9 = new XpNewLevelDialog(10, (MyLifeInstance.getInstance() as MyLife).getPlayer().getPlayerName(), "Yo-About-Town", loc8);
                (loc10 = new StandardDialog(loc9, "", 320, 400, 320, 300, false)).show(true);
            }
            if (arg1.keyCode == 77)
            {
                loc11 = MyLifeInstance.getInstance().getPlayer().getCharacter().getServerUserId();
                ActionTweenManager.instance.makeActionTween(ActionTweenType.COIN, loc11, loc11, {"coins":1234});
            }
            return;
        }

        private function processRewardHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            if (arg1.data.hasOwnProperty("reward"))
            {
                loc2 = arg1.data["reward"];
            }
            if (arg1.data.hasOwnProperty("type"))
            {
                loc3 = new RewardType(arg1.data.type);
            }
            if (loc2 && loc3)
            {
                loc4 = loc3.getValue();
                switch (loc4) 
                {
                    case RewardType.ACTION.getValue():
                    case RewardType.DANCE.getValue():
                    case RewardType.POSE.getValue():
                    case RewardType.ACCESSORY.getValue():
                    case RewardType.LEVELING_ITEM.getValue():
                    case RewardType.ITEM.getValue():
                        InventoryManager.addItemToInventory(loc2);
                        break;
                    default:
                        break;
                }
            }
            return;
        }

        private function newLevelHandler(arg1:MyLife.Xp.XpManagerEvent):void
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
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;

            loc2 = null;
            loc3 = 0;
            loc4 = null;
            loc5 = 0;
            loc6 = null;
            loc7 = null;
            loc9 = null;
            loc13 = 0;
            if (arg1.data.hasOwnProperty("name"))
            {
                loc2 = String(arg1.data.name);
            }
            if (arg1.data.hasOwnProperty("level"))
            {
                loc3 = int(arg1.data.level);
            }
            if (arg1.data.hasOwnProperty("rewardType"))
            {
                loc13 = int(arg1.data.rewardType);
                loc4 = new RewardType(loc13);
            }
            if (arg1.data.hasOwnProperty("rewardId"))
            {
                loc5 = int(arg1.data.rewardId);
            }
            if (arg1.data.hasOwnProperty("rewardObject"))
            {
                loc6 = arg1.data.rewardObject;
            }
            loc8 = JSON.encode(loc6);
            _level = loc3;
            if (loc2)
            {
                _title = loc2;
            }
            if (loc5 && loc4 && loc6)
            {
                loc9 = new Reward(loc4, loc5, loc6);
            }
            loc10 = "room";
            loc14 = loc9.getRewardType().getValue();
            switch (loc14) 
            {
                case RewardType.ACTION.getValue():
                case RewardType.DANCE.getValue():
                case RewardType.POSE.getValue():
                    loc10 = "action";
                    MyLifeInstance.getInstance().getInterface().getHud().actionsIconHighlite(true);
                    break;
                case RewardType.ACCESSORY.getValue():
                case RewardType.LEVELING_ITEM.getValue():
                case RewardType.LEVELING_ROOM_GRANT.getValue():
                case RewardType.ITEM.getValue():
                    loc10 = "item";
                    MyLifeInstance.getInstance().getInterface().getHud().inventoryBtnHighlite(true);
                    break;
                default:
                    break;
            }
            loc11 = new XPFeedObject(MyLifeConfiguration.getInstance().playerId, loc2 ? loc2 : String(loc3), loc2 ? "title" : "level", loc5, loc9.getRewardName(), loc10);
            ShortStoryPublisher.instance.getStory(ShortStoryPublisher.XP_FEED).addItem(loc11);
            if (MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_FACEBOOK)
            {
                sendFriendNotifs();
            }
            upcomingRewardsHandler(arg1);
            loc12 = new StandardDialog(new XpNewLevelDialog(loc3, (MyLifeInstance.getInstance() as MyLife).getPlayer().getPlayerName(), loc2, loc9), "", 320, 400, 320, 300, false);
            _pendingLevelDialogs.push(loc12);
            loc12.show(false, false, true);
            return;
        }

        private function runUpdateHandler(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1)
            {
                loc2 = arg1.target as Timer;
                loc2.removeEventListener(TimerEvent.TIMER, runUpdateHandler);
                if (loc2)
                {
                    loc2.stop();
                    loc2 = null;
                }
            }
            if (_updatePending && _canShowUpdate)
            {
                if (_deltaXp)
                {
                    playGainXpAnimation();
                    _deltaXp = 0;
                }
                if (_xpProgressBar.moveTo(_xp) == _xp)
                {
                    _updatePending = false;
                }
            }
            return;
        }

        private function suspendUpdatesManager(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = false;
            if (arg1.type == MyLifeEvent.INTERFACE_DIALOG_OPEN || arg1.type == GameManagerEvent.GAME_START)
            {
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_SUSPEND_UPDATES));
            }
            if (arg1.type == MyLifeEvent.INTERFACE_LOW_PRIORITY_DIALOG_READY || arg1.type == MyLifeEvent.INTERFACE_DIALOG_QUEUE_EMPTY || arg1.type == GameManagerEvent.GAME_EXIT)
            {
                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_CAN_SHOW_UPDATE));
            }
            if (arg1.type == MyLifeEvent.INTERFACE_DELAYED_DIALOG_READY)
            {
                loc2 = arg1 as MyLifeEvent;
                if (loc2.eventData && loc2.eventData.hasOwnProperty("dialog"))
                {
                    if (_pendingLevelDialogs.indexOf(loc2.eventData.dialog) >= 0)
                    {
                        _readyDelayedDialog = loc2.eventData;
                        if (canShowNewLevelDialog())
                        {
                            loc3 = _readyDelayedDialog.dialog as StandardDialog;
                            loc4 = _readyDelayedDialog.modal;
                            loc3.addEventListener(MyLifeEvent.WINDOW_CLOSE, newLevelAlertClosedHandler);
                            loc3.show(true);
                            _dialogReadyForCleanup = true;
                            (loc3.getContent() as XpNewLevelDialog).playAction();
                            loc3.dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_DELAYED_DIALOG_DONE));
                        }
                        else 
                        {
                            dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_CAN_SHOW_UPDATE, loc2.eventData));
                        }
                    }
                }
            }
            return;
        }

        private function canShowNewLevelDialog():Boolean
        {
            return _readyDelayedDialog && (_forceDialog || ((_readyDelayedDialog.dialog as StandardDialog).getContent() as XpNewLevelDialog).getLevel() == _xpProgressBar.getLevel() && _xpProgressBar.isFull() && !MyLifeInstance.getInstance().isDialogOpen());
        }

        private function suspendUpdatesHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            _canShowUpdate = false;
            return;
        }

        public function getMaxLevel():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = null;
            if (!_maxLevel)
            {
                loc1 = getStaticData();
                loc2 = 0;
                while (loc2 < loc1.length) 
                {
                    loc3 = getLevelData(loc2);
                    if (loc3 && (!_maxLevel || loc3.getLevel() > _maxLevel))
                    {
                        _maxLevel = loc3.getLevel();
                    }
                    ++loc2;
                }
            }
            return _maxLevel;
        }

        public static function get instance():MyLife.Xp.XpManager
        {
            if (_instance == null)
            {
                _allowInstantiation = true;
                _instance = new XpManager();
                _allowInstantiation = false;
            }
            return _instance;
        }

        private var feedInterval:Number;

        private var _level:int=1;

        private var _readyDelayedDialog:Object;

        private var _updatePending:Boolean;

        private var _deltaXp:int=0;

        private var _playerProgressData:MyLife.Xp.ProgressData;

        private var _xp:int;

        private var _canShowUpdate:Boolean;

        private var _xpProgressBar:MyLife.Xp.XpProgressBar;

        private var _upcomingRewards:Array;

        private var _isStaticDataInitialized:Boolean;

        private var _dialogReadyForCleanup:Boolean;

        private var _xpProgressBarError:Boolean;

        private var _currentDisplayXp:int=0;

        private var _isInitialized:Boolean;

        private var _lastXp:int=-1;

        private var _forceDialog:Boolean=false;

        private var _staticData:Array;

        private var _title:String;

        private var _isProgressInitialized:Boolean;

        private var _maxLevel:int;

        private var _server:*;

        private var _lastDisplayXp:int=-1;

        private var _isUpcomingRewardsInitialized:Boolean;

        private var _pendingLevelDialogs:Array;

        private static var _allowInstantiation:Boolean;

        private static var _instance:MyLife.Xp.XpManager;
    }
}
