package MyLife 
{
    import MyLife.Assets.*;
    import MyLife.Events.*;
    import MyLife.FB.*;
    import MyLife.Games.*;
    import MyLife.Interfaces.*;
    import MyLife.Utils.*;
    import MyLife.Xp.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import gs.*;
    
    public class MyLife extends flash.display.MovieClip
    {
        public function MyLife()
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            _dialogList = [];
            _delayedPriorityDialogQueue = [];
            _lowPriorityDialogQueue = [];
            _myDelayedDialogs = [];
            super();
            loc1 = new InteractiveActionItem();
            loc2 = new Chair();
            Security.allowDomain("*");
            loc3 = new LocalConnection();
            if (loc3.domain == "localhost")
            {
                runningLocal = true;
            }
            debug("mMyLife Version: " + VERSION);
            debug("Running Local: " + runningLocal);
            MyLifeInstance.getClassInstance().setMyLifeInstance(this);
            if (this.parent)
            {
                init({});
            }
            else 
            {
                USING_PRELOADER = true;
            }
            _loadingMonitor = new DataTimer(null, MAX_WAIT, 1);
            _loadingMonitor.addEventListener(TimerEvent.TIMER, loadingMonitorHandler);
            this.server = new Server();
            server.addEventListener(MyLifeEvent.UPDATE_GIFT_COUNT, updateGiftCountHandler, false, 0, true);
            server.addEventListener(MyLifeEvent.WHATS_NEW_UPDATE, updateNewsItems, false, 0, true);
            this.shortStoryPublisher = ShortStoryPublisher.instance;
            GameManager.instance.addEventListener(GameManagerEvent.GAME_EXIT, checkDialogQueuesHandler);
            return;
        }

        public function navigateToURL(arg1:String, arg2:String="_blank"):void
        {
            var loc3:*;
            var loc4:*;
            var pURL:String;
            var pWindow:String="_blank";
            var req:flash.net.URLRequest;
            var strUserAgent:String;

            req = null;
            strUserAgent = null;
            pURL = arg1;
            pWindow = arg2;
            if (!pURL)
            {
                return;
            }
            try
            {
                req = new URLRequest(pURL);
                if (ExternalInterface.available)
                {
                    strUserAgent = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
                    if (!(strUserAgent.indexOf("firefox") == -1) || !(strUserAgent.indexOf("msie") == -1) && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)
                    {
                        ExternalInterface.call("window.open", req.url, pWindow);
                    }
                    else 
                    {
                        navigateToURL(req, pWindow);
                    }
                }
                else 
                {
                    navigateToURL(req, pWindow);
                }
            }
            catch (e:*)
            {
                trace("navigateToURL error: " + pURL);
            }
            return;
        }

        private function loadingMonitorHandler(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc2 = arg1.currentTarget as DataTimer;
            if (loc2 && loc2.data)
            {
                loc3 = SharedObjectManager.getValue(String(loc2.data));
                loc4 = new Date();
                if (loc3 && loc3.monthUTC == loc4.monthUTC && loc3.dateUTC == loc4.dateUTC)
                {
                    return;
                }
                loc5 = null;
                SharedObjectManager.setValue(String(loc2.data), loc4);
                loc6 = loc2.data;
                switch (loc6) 
                {
                    case SharedObjectManager.LOADISSUE_SFS:
                        loc5 = "2230";
                        break;
                    case SharedObjectManager.LOADISSUE_HOMEDATA:
                        loc5 = "2228";
                        break;
                    case SharedObjectManager.LOADISSUE_PLAYERACTIVATE:
                        loc5 = "2227";
                        break;
                }
                if (loc5)
                {
                    linkTracker.isActive = true;
                    linkTracker.track(loc5, "1533");
                    ExceptionLogger.logException("EVT: " + String(loc2.data), "FlashClientLoadingMonitor");
                }
            }
            return;
        }

        private function checkDialogQueuesHandler(arg1:flash.events.Event):void
        {
            checkDialogQueues();
            return;
        }

        public function enableInput():void
        {
            if (_inputMask && contains(_inputMask))
            {
                this.removeChild(_inputMask);
            }
            _inputMask = null;
            return;
        }

        public function get myLifeConfiguration():MyLife.MyLifeConfiguration
        {
            return MyLifeConfiguration.getInstance();
        }

        private function onPlayerActivated(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            trace("playerActivated");
            updateLoadingMonitor();
            server.removeEventListener(MyLifeEvent.PLAYER_ACTIVATED, onPlayerActivated);
            player = new Player(_selectedPlayerId, MovieClip(this), arg1.eventData);
            player.defaultHomePlayerItemId = parseInt(arg1.eventData["defaultHome"]);
            _interface.interfaceHUD.setReferralLinkPlayerId(player.getPlayerId());
            addEventListener(MyLifeEvent.UPDATE_BALANCE, onBalanceUpdated);
            _interface.initializeFriendLadder();
            MyLifeSoundController.getInstance().loadLastSettings();
            server.callExtension("ActionManager.updateActionCount", {"actionType":server.ACTION_MANAGER_TYPE_GIFT});
            loc2 = Number(this.myLifeConfiguration.variables["querystring"]["play_action_type"]);
            loc3 = Number(this.myLifeConfiguration.variables["querystring"]["play_action_sender"]);
            if (loc4 = Boolean(loc2 && loc3))
            {
                FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, friendDataManagerReadyHandler, false, 0, true);
            }
            else 
            {
                initZoneJoin();
            }
            badgeManager = BadgeManager.instance;
            xpManager = XpManager.instance;
            dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_ACTIVATED));
            return;
        }

        private function checkDialogQueues():void
        {
            var loc1:*;

            loc1 = null;
            if (canShowLowPriorityDialog())
            {
                if (!_lowPriorityTimer)
                {
                    _lowPriorityTimer = new Timer(2000);
                    _lowPriorityTimer.addEventListener(TimerEvent.TIMER, lowPriorityDialogCheck);
                }
                dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_LOW_PRIORITY_DIALOG_READY));
                _lowPriorityTimer.start();
            }
            else 
            {
                if (canShowDelayedPriorityDialog())
                {
                    loc1 = _delayedPriorityDialogQueue[0];
                    _pendingDialog = loc1.dialog;
                    dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_DELAYED_DIALOG_READY, loc1));
                }
                else 
                {
                    if (isDialogQueueEmpty())
                    {
                        dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_DIALOG_QUEUE_EMPTY));
                    }
                }
            }
            return;
        }

        private function canShowLowPriorityDialog():Boolean
        {
            return _dialogList.length == 0 && _delayedPriorityDialogQueue.length == 0 && !_pendingDialog && _lowPriorityDialogQueue.length && !getZone().isGameMode();
        }

        public function init(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = null;
            this.gblStage = parent.stage;
            this._loadingParameters = arg1;
            loc2 = "";
            if (this.runningLocal)
            {
                loc2 = "mylife.cfg";
            }
            else 
            {
                loc4 = loadingParameters["static_base_url"] || "";
                trace("\t\tstatic_base_url = " + loc4);
                loc3 = loadingParameters["v"] || String(Math.round(Math.random() * 100000000));
                loc2 = loc4 + "mylife_cfg.php?v=" + loc3;
            }
            USING_PRELOADER = false;
            myLifeConfiguration.load(loc2, loadingParameters, runningLocal);
            myLifeConfiguration.addEventListener(MyLifeEvent.LOADING_DONE, configLoadComplete);
            this.linkTracker = new LinkTracker();
            _missionManager = MissionManager.instance;
            _missionManager.setMyLife(this);
            return;
        }

        private function interfaceLoadComplete(arg1:MyLife.MyLifeEvent):void
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

            loc4 = NaN;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = NaN;
            loc9 = null;
            loc10 = undefined;
            trace("interfaceLoadComplete");
            _interface = Interface(arg1.eventData);
            _interface.initialize(this);
            zone = new Zone(this);
            loc2 = Number(myLifeConfiguration.variables["querystring"]["autoLogin"]) == 1;
            loc3 = Boolean(Number(myLifeConfiguration.variables["querystring"]["autoCreateNewPlayer"]));
            if (loc3 == true)
            {
                loc4 = Number(myLifeConfiguration.variables["querystring"]["autoCreateNewPlayerId"]);
                loc5 = {"showCancel":false, "playerId":loc4};
                loc6 = myLifeConfiguration.platformType;
                loc7 = myLifeConfiguration.variables["querystring"]["uname"];
                if ((loc8 = Number(myLifeConfiguration.variables["querystring"]["ugender"])) == 1 || loc8 == 2)
                {
                    loc5.selectedGender = loc8;
                }
                if (!(loc7 == null) && !(loc7 == ""))
                {
                    loc5.nameSelected = loc7;
                }
                loadingStatus.hide();
                loc9 = _interface.showInterface("CreateNewPlayerStep1", loc5);
                TweenLite.to(loc9, 0.75, {"alpha":1});
                loc9.alpha = 0;
                if (_interfaceStartScreen)
                {
                    unloadInterface(_interfaceStartScreen);
                }
                return;
            }
            if (runningLocal && myLifeConfiguration.variables["querystring"]["devui"] == 1)
            {
                (loc10 = new DeveloperUI()).x = 80;
                loc10.y = 230;
                loc10.addEventListener(Event.CLOSE, removeDeveloperUI);
                showDialog(loc10, true);
            }
            else 
            {
                if (loc2)
                {
                    _interfaceStartScreen = _interface.showInterface("StartScreen", {});
                    userStartGame();
                }
                else 
                {
                    _interfaceStartScreen = _interface.showInterface("StartScreen", {});
                    _interfaceStartScreen.addEventListener(MyLifeEvent.START_GAME, startScreenStartGameHandler);
                    _interfaceStartScreen.alpha = 0;
                    _interfaceStartScreen.fbBookmarkReminder.visible = MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_FACEBOOK && Number(MyLifeConfiguration.getInstance().variables["querystring"]["onCanvas"]);
                    TweenLite.to(_interfaceStartScreen, 1, {"alpha":1});
                    loadingStatus.hide();
                }
            }
            dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_LOAD_COMPLETE));
            return;
        }

        public function getZone():MyLife.Zone
        {
            return zone;
        }

        public function initZoneJoin():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = 0;
            if (!player._firstTimeShowIntro && MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["default_room"])
            {
                loc1 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["default_room"];
                if (loc1.substring(0, 1) != "h")
                {
                    this.zone.join(loc1);
                }
                else 
                {
                    loc2 = int(Number(loc1.substring(1)));
                    this.zone.joinHomeRoom(0, (0), loc2);
                }
            }
            else 
            {
                if (player.defaultHomePlayerItemId)
                {
                    this.zone.joinHomeRoom(player.defaultHomePlayerItemId, player.getPlayerId());
                }
                else 
                {
                    this.zone.join("APLiving");
                }
            }
            zone.addEventListener(MyLifeEvent.JOIN_ROOM_COMPLETE, roomJoinHandler);
            return;
        }

        public function checkDialogList(arg1:flash.display.DisplayObject):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = false;
            loc4 = 0;
            loc5 = _dialogList;
            for each (loc3 in loc5)
            {
                if (loc3["dialog"] != arg1)
                {
                    continue;
                }
                loc2 = true;
                break;
            }
            return loc2;
        }

        public function displayStartUpDialogs():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = null;
            loc2 = undefined;
            loc3 = null;
            loc4 = null;
            if (scratchedToday)
            {
                if (_newGift)
                {
                    loc1 = {"title":"You Received a New Gift!"};
                    loc2 = _interface.interfaceHUD.openGiftWindow(loc1);
                    loc2.addEventListener(Event.CLOSE, startupDialogClosed);
                    _interface.interfaceHUD.setupGiveGift(true, true, _interface.interfaceHUD.giftCount);
                    _newGift = false;
                }
                else 
                {
                    if (_interface.interfaceHUD.unreadMessageCount > 0)
                    {
                        loc2 = _interface.showInterface("WindowReadMessages", {});
                        loc2.addEventListener(Event.CLOSE, startupDialogClosed);
                        _interface.interfaceHUD.unreadMessageCount = 0;
                    }
                    else 
                    {
                        if (!_whatsNewShown && _whatsNewData && _whatsNewData.length > 0)
                        {
                            loc2 = _interface.showInterface("WhatsNewWindow", {"whatsNewData":_whatsNewData});
                            loc2.addEventListener(Event.CLOSE, startupDialogClosed);
                            _whatsNewShown = true;
                        }
                        else 
                        {
                            if (!_dashboardHasBeenShown && player.friendVisitsLeft > 0)
                            {
                                loc1 = {"visitsLeft":player.friendVisitsLeft};
                                if (0 && MyLifeConfiguration.getInstance().runningLocal && SharedObjectManager.getValue(SharedObjectManager.DASHBOARD_DAILY))
                                {
                                    loc3 = SharedObjectManager.getValue(SharedObjectManager.DASHBOARD_DATE);
                                    loc4 = new Date();
                                    if (loc3 && loc3.month == loc4.month && loc3.date == loc4.date)
                                    {
                                        return;
                                    }
                                    SharedObjectManager.setValue(SharedObjectManager.DASHBOARD_DATE, loc4);
                                }
                                loc2 = new Dashboard();
                                loc2.addEventListener(Event.CLOSE, startupDialogClosed);
                                loc2.initialize(this, loc1);
                                showDialog(loc2, true);
                                loc2.show();
                                _dashboardHasBeenShown = true;
                            }
                            else 
                            {
                                startMissions();
                            }
                        }
                    }
                }
            }
            else 
            {
                loc3 = SharedObjectManager.getValue(SharedObjectManager.SCRATCHER_DATE);
                loc4 = new Date();
                if (loc3 && loc3.monthUTC == loc4.monthUTC && loc3.dateUTC == loc4.dateUTC)
                {
                    scratchedToday = true;
                    displayStartUpDialogs();
                }
                else 
                {
                    SharedObjectManager.setValue(SharedObjectManager.SCRATCHER_DATE, loc4);
                    loc2 = new ScratcherWindow();
                    loc2.initialize(this);
                    loc2.addEventListener(Event.CLOSE, startupDialogClosed);
                    showDialog(loc2, true);
                    scratchedToday = true;
                }
            }
            return;
        }

        public function hideDialog(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = false;
            loc3 = false;
            loc4 = NaN;
            loc5 = 0;
            loc6 = undefined;
            if (arg1)
            {
                loc2 = false;
                loc3 = false;
                loc4 = _dialogList.length;
                loc5 = 0;
                while (loc5 < loc4) 
                {
                    loc2 = (loc6 = _dialogList.shift()).dialog == arg1;
                    if (loc2)
                    {
                        if (contains(arg1))
                        {
                            removeChild(arg1);
                        }
                        loc6.dialog = null;
                    }
                    else 
                    {
                        loc3 = loc3 ? loc3 : loc6.modal;
                        _dialogList.push(loc6);
                    }
                    ++loc5;
                }
                if (!loc3)
                {
                    enableInput();
                }
                checkDialogQueues();
            }
            return;
        }

        public function getServer():MyLife.Server
        {
            return server;
        }

        public function addItemInterface(arg1:flash.display.DisplayObject, arg2:Boolean=false):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = null;
            if (_interface && !_interface.contains(arg1))
            {
                if (arg2)
                {
                    loc3 = _interface.MAX_X - _interface.MIN_X >> 1;
                    loc4 = _interface.MAX_Y - _interface.MIN_Y >> 1;
                    loc5 = arg1.getBounds(_interface);
                    arg1.x = Math.max(0, loc3 - (loc5.width >> 1));
                    arg1.y = Math.max(_interface.MIN_Y, loc4 - (loc5.height >> 1));
                }
                _interface.addChild(arg1);
            }
            _interface.setChildIndex(arg1, (_interface.numChildren - 1));
            return;
        }

        public function getConfiguration():MyLife.MyLifeConfiguration
        {
            return myLifeConfiguration;
        }

        public function get loadingParameters():Object
        {
            return _loadingParameters;
        }

        public function get loadingStatus():MyLife.LoadingStatus
        {
            return LoadingStatus.getInstance();
        }

        public function removeItemInterface(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;
            var loc3:*;
            var pInterface:flash.display.DisplayObject;

            pInterface = arg1;
            try
            {
                if (_interface && _interface.contains(pInterface))
                {
                    _interface.removeChild(pInterface);
                }
            }
            catch (e:*)
            {
            };
            return;
        }

        public function debug(arg1:Object):void
        {
            if (runningLocal)
            {
                trace(arg1);
            }
            return;
        }

        private function canShowDelayedPriorityDialog():Boolean
        {
            return _dialogList.length == 0 && _delayedPriorityDialogQueue.length && !getZone().isGameMode();
        }

        public function onPlayerSelected(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.eventData.playerId;
            loc3 = arg1.eventData.selectPlayerInterface;
            TweenLite.to(loc3, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[loc3]});
            unloadInterface(_interfaceStartScreen);
            _selectedPlayerId = arg1.eventData.playerId;
            connectToDefaultServer();
            return;
        }

        private function lowPriorityDialogCheck(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = undefined;
            if (canShowLowPriorityDialog())
            {
                loc2 = _lowPriorityDialogQueue.shift();
                showDialog(loc2.dialog, loc2.modal);
                loc2.dialog = null;
            }
            return;
        }

        private function isDialogQueueEmpty():Boolean
        {
            return _dialogList.length == 0 && _lowPriorityDialogQueue.length == 0 && _delayedPriorityDialogQueue.length == 0 && !_pendingDialog;
        }

        public function get assetsLoader():MyLife.AssetsManager
        {
            return AssetsManager.getInstance();
        }

        private function updateGiftCountHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            trace("updateGiftCountHandler()");
            loc2 = int(Number(arg1.eventData.actionCount));
            if (loc2 > _interface.interfaceHUD.getGiftCount())
            {
                _newGift = true;
                _interface.interfaceHUD.giftCount = loc2;
            }
            return;
        }

        public function isDialogOpen():Boolean
        {
            return _dialogList.length > 0;
        }

        private function onLoginServerConnect(arg1:MyLife.MyLifeEvent):void
        {
            debug("onLoginServerConnect");
            _whatsNewShown = false;
            _connectingFakeTimer.stop();
            _connectingFakeTimer.removeEventListener("timer", connectingFakeTimerTick);
            updateLoadingMonitor();
            server.removeEventListener(MyLifeEvent.SERVER_CONNECT, onLoginServerConnect);
            loadingStatus.setTask("Activating Your Player...");
            loadingStatus.setProgress(75, 100);
            server.addEventListener(MyLifeEvent.PLAYER_ACTIVATED, onPlayerActivated);
            updateLoadingMonitor(SharedObjectManager.LOADISSUE_PLAYERACTIVATE);
            server.activatePlayer(_selectedPlayerId);
            return;
        }

        public function getInterface():MyLife.Interface
        {
            return _interface;
        }

        private function initializeInterface():void
        {
            var loc1:*;

            loc1 = new InterfaceLoader(this);
            loc1.addEventListener(MyLifeEvent.LOADING_DONE, interfaceLoadComplete);
            loc1.load();
            return;
        }

        public function updateLoadingMonitor(arg1:String=null):void
        {
            _loadingMonitor.reset();
            _loadingMonitor.data = arg1;
            if (arg1)
            {
                _loadingMonitor.start();
            }
            return;
        }

        private function configLoadComplete(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = myLifeConfiguration.variables["querystring"]["autoCreateNewPlayer"];
            if (loc2)
            {
                this.linkTracker.isActive = true;
                if (myLifeConfiguration.platformType != "platformFacebook")
                {
                    linkTracker.track("2034", "1372");
                }
                else 
                {
                    linkTracker.track("1534", "1479");
                }
            }
            myLifeConfiguration.removeEventListener(MyLifeEvent.LOADING_DONE, configLoadComplete);
            assetPath = myLifeConfiguration.variables["global"]["asset_path"];
            zonePath = myLifeConfiguration.variables["global"]["zone_path"];
            serverPath = myLifeConfiguration.variables["global"]["server_path"];
            loadingStatus.show();
            loadingStatus.setTask("Loading Configuration File...");
            loadingStatus.setProgress(0, 1);
            InventoryManager.getInstance();
            initializeInterface();
            loadingStatus.loadPromotionsList();
            return;
        }

        public function showDialog(arg1:flash.display.DisplayObject=null, arg2:Boolean=false, arg3:Boolean=false, arg4:Boolean=false):void
        {
            var count:int;
            var delayedObject:Object;
            var delayedQueueIndex:int;
            var index:int;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var pDelayedPriority:Boolean=false;
            var pDialog:flash.display.DisplayObject=null;
            var pLowPriortiy:Boolean=false;
            var pModal:Boolean=false;

            delayedQueueIndex = 0;
            count = 0;
            delayedObject = null;
            index = 0;
            pDialog = arg1;
            pModal = arg2;
            pLowPriortiy = arg3;
            pDelayedPriority = arg4;
            if (pDialog)
            {
                if (pLowPriortiy)
                {
                    _lowPriorityDialogQueue.push({"dialog":pDialog, "modal":pModal});
                }
                else 
                {
                    if (pDelayedPriority)
                    {
                        _delayedPriorityDialogQueue.push({"dialog":pDialog, "modal":pModal});
                    }
                    else 
                    {
                        delayedQueueIndex = -1;
                        count = 0;
                        loc6 = 0;
                        loc7 = _delayedPriorityDialogQueue;
                        for each (delayedObject in loc7)
                        {
                            if (_pendingDialog && pDialog == _pendingDialog && delayedObject.dialog == _pendingDialog)
                            {
                                delayedQueueIndex = count;
                                break;
                            }
                            count = (count + 1);
                        }
                        if (delayedQueueIndex >= 0)
                        {
                            _delayedPriorityDialogQueue.splice(delayedQueueIndex, 1);
                            _pendingDialog = null;
                        }
                        if (!checkDialogList(pDialog))
                        {
                            if (_lowPriorityTimer)
                            {
                                _lowPriorityTimer.reset();
                            }
                            _dialogList.push({"dialog":pDialog, "modal":pModal});
                            if (pModal)
                            {
                                disableInput();
                            }
                        }
                        try
                        {
                            index = getChildIndex(pDialog);
                            setChildIndex(pDialog, (numChildren - 1));
                        }
                        catch (e:*)
                        {
                            addChild(pDialog);
                        }
                        dispatchEvent(new MyLifeEvent(MyLifeEvent.INTERFACE_DIALOG_OPEN, {"dialog":pDialog}));
                    }
                }
                checkDialogQueues();
            }
            return;
        }

        public function closeAllPopupCollection():void
        {
            Character.closeAllPopupCollection();
            return;
        }

        private function getNewInstanceFromClassName(arg1:String):*
        {
            var AssetClass:Class;
            var AssetObj:*;
            var className:String;
            var loc2:*;
            var loc3:*;

            AssetClass = null;
            AssetObj = undefined;
            className = arg1;
            try
            {
                AssetClass = getDefinitionByName(className) as Class;
                AssetObj = new AssetClass();
                return AssetObj;
            }
            catch (e:*)
            {
                trace(undefined.message);
                return null;
            }
            return;
        }

        private function startScreenStartGameHandler(arg1:MyLife.MyLifeEvent):void
        {
            this.linkTracker.track("1535");
            this.userStartGame();
            return;
        }

        private function removeDeveloperUI(arg1:flash.events.Event):void
        {
            arg1.currentTarget.removeEventListener(Event.CLOSE, removeDeveloperUI);
            hideDialog(arg1.currentTarget as DisplayObject);
            userStartGame();
            return;
        }

        public function disableInput():void
        {
            if (!_inputMask)
            {
                _inputMask = new MovieClip();
                _inputMask.alpha = 0;
                _inputMask.graphics.beginFill(16711680, 1);
                _inputMask.graphics.drawRect(0, (0), width, height);
                _inputMask.graphics.endFill();
                this.addChild(_inputMask);
            }
            return;
        }

        private function connectingFakeTimerTick(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = arg1.target.currentCount;
            if (loc2 < 50)
            {
                loadingStatus.setProgress(25 + loc2, 100);
            }
            else 
            {
                _connectingFakeTimer.stop();
                _connectingFakeTimer.removeEventListener("timer", connectingFakeTimerTick);
                server.onSFSConnectionFail();
            }
            return;
        }

        public function getPlayer():MyLife.Player
        {
            return player;
        }

        public function getXpManager():MyLife.Xp.XpManager
        {
            if (!xpManager)
            {
                xpManager = XpManager.instance;
            }
            return xpManager;
        }

        public function getNewContextMenu():MyLife.Interfaces.CharacterContextMenu
        {
            return new CharacterContextMenu();
        }

        private function roomJoinHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            zone.removeEventListener(MyLifeEvent.JOIN_ROOM_COMPLETE, roomJoinHandler);
            if (MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_FACEBOOK && !runningLocal)
            {
                loc2 = JSON.decode(MyLifeConfiguration.getInstance().variables["querystring"]["facebookJSON"]);
                loc3 = MyLifeConfiguration.getInstance().variables["global"]["game_control_server"] + "onelineendpoint.php?ep=start";
                loc3 = loc3 + "&sn_uid=" + loc2.fb_sig_user;
                loc3 = loc3 + "&sn_session_key=" + loc2.fb_sig_session_key;
                loc4 = new URLLoader(new URLRequest(loc3));
            }
            return;
        }

        public function connectToDefaultServer():void
        {
            var loc1:*;

            trace("connectToDefaultServer()");
            loc1 = myLifeConfiguration.variables["querystring"]["defaultServer"];
            if (myLifeConfiguration.platformType != myLifeConfiguration.PLATFORM_FACEBOOK)
            {
                loadingStatus.show();
            }
            else 
            {
                loadingStatus.show(false, LoadingStatus.PROMO_ROOMCHANGE);
            }
            loadingStatus.setTask("Connecting To Server...");
            loadingStatus.setProgress(25, 100);
            _connectingFakeTimer = new Timer(400);
            _connectingFakeTimer.addEventListener("timer", connectingFakeTimerTick);
            _connectingFakeTimer.start();
            server.addEventListener(MyLifeEvent.SERVER_CONNECT, onLoginServerConnect);
            updateLoadingMonitor(SharedObjectManager.LOADISSUE_SFS);
            server.connect(loc1);
            return;
        }

        public function startMissions():void
        {
            if (!_missionsAlreadyBegun)
            {
                MissionManager.instance.beginMissions();
                _missionsAlreadyBegun = true;
            }
            return;
        }

        private function updateNewsItems(arg1:MyLife.MyLifeEvent):void
        {
            _whatsNewShown = false;
            _whatsNewData = arg1.eventData;
            return;
        }

        private function friendDataManagerReadyHandler(arg1:flash.events.Event):void
        {
            FriendDataManager.instance.removeEventListener(FriendDataManager.EVENT_READY, friendDataManagerReadyHandler);
            initZoneJoin();
            return;
        }

        private function userStartGame():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc1 = myLifeConfiguration.variables["querystring"]["autoSelectPlayerId"];
            if (!loc1)
            {
                loc2 = JSON.decode(myLifeConfiguration.variables["querystring"]["playersJSON"]);
                loc4 = 0;
                loc5 = loc2;
                for (loc3 in loc5)
                {
                    loc1 = parseInt(loc3);
                    break;
                }
            }
            if (loc1)
            {
                _selectedPlayerId = loc1;
                if (_interfaceStartScreen)
                {
                    unloadInterface(_interfaceStartScreen);
                }
                connectToDefaultServer();
                return;
            }
            return;
        }

        private function startupDialogClosed(arg1:flash.events.Event):void
        {
            arg1.currentTarget.removeEventListener(Event.CLOSE, startupDialogClosed);
            hideDialog(arg1.currentTarget as DisplayObject);
            displayStartUpDialogs();
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _interface.unloadInterface(arg1);
            return;
        }

        private function onBalanceUpdated(arg1:MyLife.MyLifeEvent):void
        {
            player.setCoinBalance(arg1.eventData.balance);
            return;
        }

        public static const VERSION:String="1.5";

        public static const MAX_WAIT:Number=10000;

        public var serverPath:String="";

        private var _whatsNewData:Object=null;

        public var shortStoryPublisher:MyLife.FB.ShortStoryPublisher;

        public var assetPath:String="";

        public var TELEPORT_DOOR_ID:String="15216";

        public var USING_PRELOADER:Boolean=false;

        public var server:MyLife.Server;

        private var _delayedPriorityDialogQueue:Array;

        private var _interfaceStartScreen:flash.display.MovieClip;

        private var _inputMask:flash.display.MovieClip;

        private var _connectingFakeTimer:flash.utils.Timer;

        private var _lowPriorityTimer:flash.utils.Timer;

        private var _dashboardHasBeenShown:Boolean=false;

        public var badgeManager:MyLife.BadgeManager;

        private var _missionsAlreadyBegun:Boolean=false;

        public var gblStage:flash.display.Stage;

        private var _lowPriorityDialogQueue:Array;

        private var _myDelayedDialogs:Array;

        private var xpManager:MyLife.Xp.XpManager;

        private var _loadingMonitor:MyLife.Utils.DataTimer;

        private var _missionManager:MyLife.MissionManager;

        private var _whatsNewShown:Boolean=false;

        private var _dialogList:Array;

        public var zone:MyLife.Zone;

        private var scratchedToday:Boolean=false;

        private var _newGift:Boolean=false;

        public var _interface:MyLife.Interface;

        private var _pendingDialog:flash.display.DisplayObject;

        private var _loadingParameters:Object;

        public var linkTracker:MyLife.LinkTracker;

        public var player:MyLife.Player;

        public var runningLocal:Boolean=false;

        public var _selectedPlayerId:int=0;

        public var zonePath:String="";
    }
}
