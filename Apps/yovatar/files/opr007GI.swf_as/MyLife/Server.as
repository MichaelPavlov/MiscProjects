package MyLife 
{
    import MyLife.Events.*;
    import MyLife.Xp.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import it.gotoandplay.smartfoxserver.*;
    import it.gotoandplay.smartfoxserver.data.*;
    
    public class Server extends flash.events.EventDispatcher
    {
        public function Server()
        {
            _smartFoxClient = new SmartFoxClient(true);
            super();
            _smartFoxClient.addEventListener(SFSEvent.onConnection, onSFSConnection);
            _smartFoxClient.addEventListener(SFSEvent.onLogin, onSFSLogin);
            _smartFoxClient.addEventListener(SFSEvent.onRoomListUpdate, onSFSRoomListUpdate);
            _smartFoxClient.addEventListener(SFSEvent.onJoinRoom, onSFSJoinRoom);
            _smartFoxClient.addEventListener(SFSEvent.onExtensionResponse, onSFSExtensionResponse);
            _smartFoxClient.addEventListener(SFSEvent.onUserLeaveRoom, onSFSUserLeaveRoom);
            _smartFoxClient.addEventListener(SFSEvent.onUserEnterRoom, onSFSUserEnterRoom);
            _smartFoxClient.addEventListener(SFSEvent.onRoundTripResponse, onRoundTripResponse);
            _smartFoxClient.addEventListener(SFSEvent.onPublicMessage, onSFSPublicMessage);
            _smartFoxClient.addEventListener(SFSEvent.onAdminMessage, onAdminMessage);
            _smartFoxClient.addEventListener(SFSEvent.onModeratorMessage, onModeratorMessage);
            _smartFoxClient.addEventListener(SFSEvent.onConnectionLost, onSFSConnectionLost);
            _smartFoxClient.addEventListener(SFSEvent.onJoinRoomError, onSFSJoinRoomError);
            _smartFoxClient.addEventListener(SFSEvent.onUserVariablesUpdate, onUserVariablesUpdate);
            _smartFoxClient.addEventListener(SFSEvent.onRoomVariablesUpdate, onRoomVariablesUpdate);
            _smartFoxClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSFSSecurityError);
            _smartFoxClient.addEventListener(IOErrorEvent.IO_ERROR, onSFSIOError);
            playerToPlayerEventHandler = new PlayerToPlayerEventHandler(MyLifeInstance.getInstance());
            _linkTracker = new LinkTracker();
            return;
        }

        private function getStatusError(arg1:flash.events.IOErrorEvent):void
        {
            trace("getPlayerInfoError: Error Retrieving Status!");
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_STATUS_ERROR));
            return;
        }

        public function callExtension(arg1:String, arg2:Object=null, arg3:String="myLife"):void
        {
            if (!isConnected)
            {
                return;
            }
            if (arg2 == null)
            {
                arg2 = new Object();
            }
            _smartFoxClient.sendXtMessage(arg3, arg1, arg2, "json");
            return;
        }

        private function doSFSLogin():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["user"] + "_" + MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
            loc1 = loc1 + "_" + MyLifeConfiguration.getInstance().playerId;
            loc2 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["lk"];
            loc3 = MyLifeInstance.getInstance().getConfiguration().variables["global"]["default_zone"];
            _smartFoxClient.login(loc3, loc1, loc2);
            return;
        }

        private function onUserVariablesUpdate(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = undefined;
            loc6 = null;
            trace("onUserVariables");
            loc2 = arg1.params.user;
            loc3 = loc2.getVariables().serverUserId;
            loc4 = loc2.getVariables();
            if (arg1.params.changedVars[0] != "temporaryCostume")
            {
                if (arg1.params.changedVars[0] == "player")
                {
                    if (loc4.player as String)
                    {
                        loc6 = JSON.decode(loc4.player);
                    }
                    else 
                    {
                        loc6 = loc4.player;
                    }
                    if (loc5 = MyLifeInstance.getInstance().getZone().getCharacterFromServerUserId(loc3))
                    {
                        trace("setNewClothing on uvars update");
                        loc5.setNewClothing(loc6.clothing, true);
                    }
                }
            }
            else 
            {
                if (loc3 != MyLifeInstance.getInstance().player._character.serverUserId)
                {
                    loc5 = MyLifeInstance.getInstance().getZone().getCharacterFromServerUserId(loc3);
                }
                else 
                {
                    loc5 = MyLifeInstance.getInstance().player._character;
                }
                if (loc5)
                {
                    loc5.setTemporaryCostume(JSON.decode(loc4.temporaryCostume));
                }
            }
            trace("end onUserVariables");
            return;
        }

        internal function onSFSUserLeaveRoom(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.USER_LEAVE, arg1.params));
            return;
        }

        internal function onSFSSecurityError(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            MyLifeInstance.getInstance().debug("onSFSSecurityError Occured");
            ExceptionLogger.logException("EVT: " + arg1.toString(), "onSFSSecurityError");
            disconnectLog(2);
            return;
        }

        private function onRoomVariablesUpdate(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.ROOM_VARS_UPDATE, {"changedVars":arg1.params.changedVars}));
            return;
        }

        private function fireServerConnectEvent():void
        {
            isConnected = true;
            if (this.isReconnecting)
            {
                this.isReconnecting = false;
            }
            dispatchEvent(new MyLifeEvent(MyLifeEvent.SERVER_CONNECT));
            return;
        }

        private function onAdminMessage(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            if (arg1.params.message.indexOf("re being kicked") > 0)
            {
                _userKicked = arg1.params.message;
                disconnect();
            }
            else 
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Administrator Message Received", "message":"Administrator Message: " + arg1.params.message});
            }
            return;
        }

        internal function onSFSExtensionResponse(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            var actionTweenPrefix:String;
            var actionTweenPrefixLength:int;
            var activeRoomId:int;
            var command:String;
            var dataObject:Object;
            var dataString:String;
            var eventName:String;
            var evt:it.gotoandplay.smartfoxserver.SFSEvent;
            var fromCharacter:*;
            var fromCharacterName:*;
            var loc2:*;
            var loc3:*;
            var msgJSON:String;
            var myLifeEvent:MyLife.MyLifeEvent;
            var playerCount:*;
            var resObj:Object;
            var roomData:Object;
            var roomDataString:String;
            var zoneEventName:String;

            playerCount = undefined;
            dataString = null;
            dataObject = null;
            myLifeEvent = null;
            actionTweenPrefix = null;
            actionTweenPrefixLength = 0;
            fromCharacter = undefined;
            eventName = null;
            zoneEventName = null;
            fromCharacterName = undefined;
            activeRoomId = 0;
            roomDataString = null;
            roomData = null;
            evt = arg1;
            trace("onSFSExtensionResponse()");
            resObj = evt.params.dataObj;
            msgJSON = JSON.encode(resObj);
            command = resObj._cmd;
            if (!(command && command.search("GameManager.getGameLimits") >= 0))
            {
                _lastMessage = msgJSON;
            }
            if (resObj._cmd != "logOK")
            {
                if (resObj._cmd != "logKO")
                {
                    if (resObj._cmd != "moneyStats")
                    {
                        if (resObj._cmd != "updateCharacterPath")
                        {
                            if (resObj._cmd != "updateCharacterDirection")
                            {
                                if (resObj._cmd != "updateCharacterProperty")
                                {
                                    if (resObj._cmd != "apartmentCommentCount")
                                    {
                                        if (resObj._cmd != "ActionManager.updateActionCount")
                                        {
                                            if (resObj._cmd != "ActionManager.getActions")
                                            {
                                                if (resObj._cmd != "ActionManager.sendAction")
                                                {
                                                    if (resObj._cmd != "ActionManager.openAction")
                                                    {
                                                        if (resObj._cmd != "updatePlayersInRoom")
                                                        {
                                                            if (resObj._cmd != "sendNewPlayerData")
                                                            {
                                                                if (resObj._cmd != "activatePlayer")
                                                                {
                                                                    if (resObj._cmd != "news")
                                                                    {
                                                                        if (resObj._cmd != "sendMessage")
                                                                        {
                                                                            if (resObj._cmd != "updateCoinBalance")
                                                                            {
                                                                                if (resObj._cmd != "updateCashBalance")
                                                                                {
                                                                                    if (resObj._cmd != "updateEnergyBalance")
                                                                                    {
                                                                                        if (resObj._cmd != "kickedFromApartment")
                                                                                        {
                                                                                            if (resObj._cmd != "updateApartmentCount")
                                                                                            {
                                                                                                if (resObj._cmd != "getInventory")
                                                                                                {
                                                                                                    if (resObj._cmd != "itemsInUse")
                                                                                                    {
                                                                                                        if (resObj._cmd != "reloadCurrentRoom")
                                                                                                        {
                                                                                                            if (resObj._cmd != "getNextApartmentTourLocation")
                                                                                                            {
                                                                                                                if (resObj._cmd != "registerGameResult")
                                                                                                                {
                                                                                                                    if (resObj._cmd != "getApartmentLocked")
                                                                                                                    {
                                                                                                                        if (resObj._cmd != "TradeMaster.initiateTrade")
                                                                                                                        {
                                                                                                                            if (resObj._cmd != "PlayerRoom.updateRating")
                                                                                                                            {
                                                                                                                                if (resObj._cmd != "SpecialItem.getData")
                                                                                                                                {
                                                                                                                                    if (resObj._cmd != "updateBuddyList")
                                                                                                                                    {
                                                                                                                                        if (resObj._cmd != "HomeManager.getPlayerHomes")
                                                                                                                                        {
                                                                                                                                            if (resObj._cmd != "HomeManager.getDefaultHomeData")
                                                                                                                                            {
                                                                                                                                                if (resObj._cmd != "BadgeManager.getBadgeList")
                                                                                                                                                {
                                                                                                                                                    if (resObj._cmd != "BadgeManager.updateBadgeProgress")
                                                                                                                                                    {
                                                                                                                                                        if (resObj._cmd != "BadgeManager.getPlayerBadges")
                                                                                                                                                        {
                                                                                                                                                            if (resObj._cmd != "XpManager.newLevel")
                                                                                                                                                            {
                                                                                                                                                                if (resObj._cmd != "XpManager.getStaticData")
                                                                                                                                                                {
                                                                                                                                                                    if (resObj._cmd != "XpManager.getProgress")
                                                                                                                                                                    {
                                                                                                                                                                        if (resObj._cmd != "XpManager.updateProgress")
                                                                                                                                                                        {
                                                                                                                                                                            if (resObj._cmd != "XpManager.getUpcomingRewards")
                                                                                                                                                                            {
                                                                                                                                                                                if (resObj._cmd != "FactoryManager.beginHelpRequest")
                                                                                                                                                                                {
                                                                                                                                                                                    if (resObj._cmd != "FactoryManager.helpPlayerWork")
                                                                                                                                                                                    {
                                                                                                                                                                                        if (resObj._cmd != "FactoryManager.checkHelpRequest")
                                                                                                                                                                                        {
                                                                                                                                                                                            if (resObj._cmd != "XpManager.processReward")
                                                                                                                                                                                            {
                                                                                                                                                                                                if (resObj._cmd != "LevelingItem.replaceItem")
                                                                                                                                                                                                {
                                                                                                                                                                                                    if (resObj._cmd != "buyCrewMembers")
                                                                                                                                                                                                    {
                                                                                                                                                                                                        if (resObj._cmd != "convertCashToCoins")
                                                                                                                                                                                                        {
                                                                                                                                                                                                            if (resObj._cmd != "useItem")
                                                                                                                                                                                                            {
                                                                                                                                                                                                                if (resObj._cmd != "GameManager.registerGameResult")
                                                                                                                                                                                                                {
                                                                                                                                                                                                                    if (resObj._cmd != "GameManager.registerBet")
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        if (resObj._cmd != "GameManager.getGameLimits")
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                            if (resObj._cmd != "sendJSON")
                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                if (resObj._cmd != "ScratcherManager.checkTicket")
                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                    dispatchEvent(new MyLifeEvent("MLXT_" + resObj._cmd, {"params":evt.params, "cmd":resObj._cmd}, false));
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                else 
                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.SCRATCHER_DATA_COMPLETE, resObj));
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                            }
                                                                                                                                                                                                                            else 
                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                MyLifeInstance.getInstance().getZone().updateCharacterAction(resObj.uid, resObj.a);
                                                                                                                                                                                                                            }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        else 
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                            trace("Server: dispatching GameManager.getGameLimits");
                                                                                                                                                                                                                            dispatchEvent(new GameManagerEvent(GameManagerEvent.GET_GAME_LIMITS_COMPLETE, resObj));
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                    else 
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        dispatchEvent(new GameManagerEvent(GameManagerEvent.REGISTER_BET_COMPLETE, resObj));
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                }
                                                                                                                                                                                                                else 
                                                                                                                                                                                                                {
                                                                                                                                                                                                                    dispatchEvent(new GameManagerEvent(GameManagerEvent.REGISTER_GAME_RESULT_COMPLETE, resObj));
                                                                                                                                                                                                                }
                                                                                                                                                                                                            }
                                                                                                                                                                                                            else 
                                                                                                                                                                                                            {
                                                                                                                                                                                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.USE_ITEM_RESPONSE, resObj));
                                                                                                                                                                                                            }
                                                                                                                                                                                                        }
                                                                                                                                                                                                        else 
                                                                                                                                                                                                        {
                                                                                                                                                                                                            dispatchEvent(new MyLifeEvent(MyLifeEvent.BUY_COINS_COMPLETE, resObj));
                                                                                                                                                                                                        }
                                                                                                                                                                                                    }
                                                                                                                                                                                                    else 
                                                                                                                                                                                                    {
                                                                                                                                                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.BUY_CREW_COMPLETE, resObj));
                                                                                                                                                                                                    }
                                                                                                                                                                                                }
                                                                                                                                                                                                else 
                                                                                                                                                                                                {
                                                                                                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.LEVELING_ITEM_REPLACE, resObj));
                                                                                                                                                                                                }
                                                                                                                                                                                            }
                                                                                                                                                                                            else 
                                                                                                                                                                                            {
                                                                                                                                                                                                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_PROCESS_REWARD, resObj));
                                                                                                                                                                                            }
                                                                                                                                                                                        }
                                                                                                                                                                                        else 
                                                                                                                                                                                        {
                                                                                                                                                                                            dispatchEvent(new FactoryEvent(FactoryEvent.HELP_REQUEST_COMPLETE, resObj));
                                                                                                                                                                                        }
                                                                                                                                                                                    }
                                                                                                                                                                                    else 
                                                                                                                                                                                    {
                                                                                                                                                                                        dispatchEvent(new FactoryEvent(FactoryEvent.HELP_REQUEST_HELP, resObj));
                                                                                                                                                                                    }
                                                                                                                                                                                }
                                                                                                                                                                                else 
                                                                                                                                                                                {
                                                                                                                                                                                    dispatchEvent(new FactoryEvent(FactoryEvent.HELP_REQUEST_SUBMIT, resObj));
                                                                                                                                                                                }
                                                                                                                                                                            }
                                                                                                                                                                            else 
                                                                                                                                                                            {
                                                                                                                                                                                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_UPCOMING_REWARDS_COMPLETE, resObj));
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        else 
                                                                                                                                                                        {
                                                                                                                                                                            dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_UPDATE_PROGRESS, resObj));
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                    else 
                                                                                                                                                                    {
                                                                                                                                                                        dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_PLAYER_DATA_COMPLETE, resObj));
                                                                                                                                                                    }
                                                                                                                                                                }
                                                                                                                                                                else 
                                                                                                                                                                {
                                                                                                                                                                    dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_STATIC_DATA_COMPLETE, resObj));
                                                                                                                                                                }
                                                                                                                                                            }
                                                                                                                                                            else 
                                                                                                                                                            {
                                                                                                                                                                dispatchEvent(new XpManagerEvent(XpManagerEvent.XP_MANAGER_NEW_LEVEL, resObj));
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                        else 
                                                                                                                                                        {
                                                                                                                                                            dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_PLAYER_BADGE_LIST_COMPLETE, resObj));
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                    else 
                                                                                                                                                    {
                                                                                                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.BADGE_EARNED_EVENT, resObj));
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                                else 
                                                                                                                                                {
                                                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_BADGE_LIST_COMPLETE, resObj));
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                            else 
                                                                                                                                            {
                                                                                                                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_DEFAULT_HOME_DATA_COMPLETE, resObj.defaultData));
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        else 
                                                                                                                                        {
                                                                                                                                            dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_PLAYER_HOMES_COMPLETE, resObj));
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else 
                                                                                                                                    {
                                                                                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.BUDDYLIST_UPDATE, resObj.buddyList));
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else 
                                                                                                                                {
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                        resObj.special_data = JSON.decode(resObj.special_data);
                                                                                                                                    }
                                                                                                                                    catch (e:*)
                                                                                                                                    {
                                                                                                                                    };
                                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.SPECIALITEM_GETDATA_COMPLETE, resObj.special_data));
                                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.SPECIALITEM_GETDATA2_COMPLETE, resObj));
                                                                                                                                }
                                                                                                                            }
                                                                                                                            else 
                                                                                                                            {
                                                                                                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.ROOM_RATING_UPDATE, resObj));
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else 
                                                                                                                        {
                                                                                                                            dispatchEvent(new MyLifeEvent(MyLifeEvent.TRADE_COMPLETE, resObj));
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else 
                                                                                                                    {
                                                                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_APARTMENT_LOCKED_COMPLETE, resObj));
                                                                                                                    }
                                                                                                                }
                                                                                                                else 
                                                                                                                {
                                                                                                                    if (resObj.coins)
                                                                                                                    {
                                                                                                                        if (resObj.balance)
                                                                                                                        {
                                                                                                                            dispatchEvent(new MyLifeEvent(MyLifeEvent.UPDATE_BALANCE, {"coins":resObj.balance}));
                                                                                                                        }
                                                                                                                    }
                                                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.GAME_REGISTER_RESULT_COMPLETE, resObj));
                                                                                                                }
                                                                                                            }
                                                                                                            else 
                                                                                                            {
                                                                                                                if (resObj.playerId == "" || resObj.playerId == "0")
                                                                                                                {
                                                                                                                    return;
                                                                                                                }
                                                                                                                onApartmentTourCallback(resObj.playerId, resObj.firstTime);
                                                                                                            }
                                                                                                        }
                                                                                                        else 
                                                                                                        {
                                                                                                            activeRoomId = this._smartFoxClient.activeRoomId;
                                                                                                            roomDataString = resObj.roomData;
                                                                                                            roomData = JSON.decode(roomDataString);
                                                                                                            MyLifeInstance.getInstance().getZone().reloadZone(roomData);
                                                                                                        }
                                                                                                    }
                                                                                                    else 
                                                                                                    {
                                                                                                        InventoryManager.setItemsInUse(resObj.itemsInUse);
                                                                                                    }
                                                                                                }
                                                                                                else 
                                                                                                {
                                                                                                    dispatchEvent(new ServerEvent(ServerEvent.LOAD_INVENTORY_COMPLETE, resObj));
                                                                                                }
                                                                                            }
                                                                                            else 
                                                                                            {
                                                                                                MyLifeInstance.getInstance().dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_APARTMENT_COUNT_UPDATE, {"count":resObj.count}, true));
                                                                                            }
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            MyLifeInstance.getInstance().getZone().kickFromApartment();
                                                                                        }
                                                                                    }
                                                                                    else 
                                                                                    {
                                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.UPDATE_ENERGY, {"energy":resObj.energy}));
                                                                                    }
                                                                                }
                                                                                else 
                                                                                {
                                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.UPDATE_BALANCE, {"cash":resObj.balance}));
                                                                                }
                                                                            }
                                                                            else 
                                                                            {
                                                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.UPDATE_BALANCE, {"coins":resObj.balance}));
                                                                            }
                                                                        }
                                                                        else 
                                                                        {
                                                                            if (resObj.message.substr(0, 4) == "EVT:")
                                                                            {
                                                                                if (resObj.from != _smartFoxClient.myUserId)
                                                                                {
                                                                                    playerToPlayerEventHandler.handlePlayerEvent(resObj);
                                                                                }
                                                                                return;
                                                                            }
                                                                            if (resObj.message.substr(0, 2) == "T:")
                                                                            {
                                                                                MyLifeInstance.getInstance().getInterface().interfaceHUD.waterBalloonManager.handleThrowEvent(resObj.from, resObj.message.substr(2));
                                                                                return;
                                                                            }
                                                                            actionTweenPrefix = ActionTweenManager.SERVER_EVENT_PREFIX;
                                                                            actionTweenPrefixLength = actionTweenPrefix.length;
                                                                            if (resObj.message.substr(0, actionTweenPrefixLength) == actionTweenPrefix)
                                                                            {
                                                                                dataString = resObj.message.substr(actionTweenPrefixLength);
                                                                                dataObject = JSON.decode(dataString);
                                                                                myLifeEvent = new MyLifeEvent(MyLifeEvent.ACTION_TWEEN_EVENT_RECEIVED, dataObject);
                                                                                this.dispatchEvent(myLifeEvent);
                                                                                return;
                                                                            }
                                                                            if (resObj.message.substr(0, 8) == "ITEMEVT:")
                                                                            {
                                                                                dataString = resObj.message.substr(8);
                                                                                dataObject = JSON.decode(dataString);
                                                                                eventName = dataObject.eventName;
                                                                                trace("ITEMEVT: eventName = " + eventName);
                                                                                if (eventName)
                                                                                {
                                                                                    myLifeEvent = new MyLifeEvent(eventName, dataObject);
                                                                                    this.dispatchEvent(myLifeEvent);
                                                                                }
                                                                                return;
                                                                            }
                                                                            if (resObj.message.substr(0, 8) == "ZONEEVT:")
                                                                            {
                                                                                dataString = resObj.message.substr(8);
                                                                                dataObject = JSON.decode(dataString);
                                                                                zoneEventName = dataObject.eventName;
                                                                                trace("ZONEEVT: eventName = " + zoneEventName);
                                                                                if (eventName)
                                                                                {
                                                                                    myLifeEvent = new MyLifeEvent(zoneEventName, dataObject);
                                                                                    this.dispatchEvent(myLifeEvent);
                                                                                }
                                                                                return;
                                                                            }
                                                                            fromCharacter = MyLifeInstance.getInstance().getZone().getCharacter(resObj.from);
                                                                            if (fromCharacter)
                                                                            {
                                                                                fromCharacterName = fromCharacter._characterName;
                                                                                if (fromCharacterName)
                                                                                {
                                                                                    MyLifeInstance.getInstance().getInterface().interfaceHUD.chatWindowHistory.logChatMessage(fromCharacterName, resObj.message);
                                                                                }
                                                                                MyLifeInstance.getInstance().getZone().showCharacterMessage(resObj.from, resObj.message);
                                                                            }
                                                                        }
                                                                    }
                                                                    else 
                                                                    {
                                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.WHATS_NEW_UPDATE, resObj.newsItems));
                                                                    }
                                                                }
                                                                else 
                                                                {
                                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_ACTIVATED, resObj));
                                                                    dispatchEvent(new ServerEvent(ServerEvent.PLAYER_ACTIVATED, resObj));
                                                                }
                                                            }
                                                            else 
                                                            {
                                                                MyLifeInstance.getInstance().getZone().updateNewPlayerData(resObj);
                                                            }
                                                        }
                                                        else 
                                                        {
                                                            playerCount = Number(resObj.user_count);
                                                            if (!MyLifeInstance.getInstance().getInterface().interfaceHUD.btnGoHome.visible)
                                                            {
                                                                playerCount = (playerCount - 1);
                                                                if (playerCount < 0)
                                                                {
                                                                    playerCount = 0;
                                                                }
                                                            }
                                                            MyLifeInstance.getInstance().dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_APARTMENT_COUNT_UPDATE, {"count":playerCount}, true));
                                                        }
                                                    }
                                                    else 
                                                    {
                                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.OPEN_ACTION_COMPLETE, resObj));
                                                    }
                                                }
                                                else 
                                                {
                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.SEND_ACTION_COMPLETE, resObj));
                                                }
                                            }
                                            else 
                                            {
                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_ACTIONS_COMPLETE, resObj));
                                            }
                                        }
                                        else 
                                        {
                                            if (parseInt(resObj["actionType"]) != ACTION_MANAGER_TYPE_GIFT)
                                            {
                                                if (parseInt(resObj["actionType"]) == ACTION_MANAGER_TYPE_MESSAGE)
                                                {
                                                    dispatchEvent(new MyLifeEvent(MyLifeEvent.MESSAGE_COUNT, parseInt(resObj.actionCount)));
                                                }
                                            }
                                            else 
                                            {
                                                dispatchEvent(new MyLifeEvent(MyLifeEvent.UPDATE_GIFT_COUNT, resObj));
                                            }
                                        }
                                    }
                                    else 
                                    {
                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.MESSAGE_COUNT, parseInt(resObj.commentCount)));
                                    }
                                }
                                else 
                                {
                                    handleUpdateCharacterProperty(resObj);
                                }
                            }
                            else 
                            {
                                MyLifeInstance.getInstance().getZone().updateCharacterDirection(resObj);
                            }
                        }
                    }
                }
                else 
                {
                    onLoginFailed(resObj.err);
                }
            }
            else 
            {
                _smartFoxClient.amIModerator = resObj.mod;
                _smartFoxClient.myUserId = resObj.serverUserId;
                fireServerConnectEvent();
            }
            return;
        }

        public function disconnectLog(arg1:int):void
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

            loc6 = undefined;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            trace("disconnectLog()");
            loc2 = MyLifeInstance.getInstance().getConfiguration();
            loc3 = "http://yoload.zynga.com/fb/scripts/log_disconnect.php";
            loc4 = 0;
            loc5 = JSON.decode(loc2.variables["querystring"]["playersJSON"]);
            loc10 = 0;
            loc11 = loc5;
            for (loc6 in loc11)
            {
                loc4 = loc6;
                break;
            }
            trace("PLAYER ID: " + loc4);
            (loc7 = new URLVariables()).error_code = arg1;
            loc7.player = loc4;
            (loc8 = new URLRequest(loc3)).method = URLRequestMethod.POST;
            loc8.data = loc7;
            (loc9 = new URLLoader()).addEventListener(Event.COMPLETE, disconnectLogComplete);
            loc9.addEventListener(IOErrorEvent.IO_ERROR, disconnectLogError);
            loc9.load(loc8);
            return;
        }

        public function sendNotification(arg1:int, arg2:*, arg3:Boolean=false, arg4:*=null, arg5:String=null):void
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;

            loc11 = null;
            loc15 = null;
            loc16 = null;
            trace("sendNotification()");
            loc6 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
            loc7 = (arg3 || arg1 == 10 || arg1 == 11) ? "send_notif.php" : "send_action.php";
            loc8 = (loc8 = "?action_type=" + arg1) + "&player_id=" + MyLifeInstance.getInstance().getPlayer()._playerId;
            if (arg2)
            {
                loc8 = loc8 + "&player_receiver=" + arg2;
            }
            else 
            {
                if (arg4)
                {
                    loc8 = loc8 + "&target_fb_user=" + arg4;
                }
            }
            if (arg3)
            {
                loc8 = loc8 + "&bypass_visit=true";
            }
            if (arg5)
            {
                loc8 = loc8 + "&notif_params=" + encodeURI(arg5);
            }
            loc9 = null;
            loc10 = new RegExp("fb", "g");
            loc17 = MyLifeInstance.getInstance().myLifeConfiguration.platformType;
            switch (loc17) 
            {
                case "platformFacebook":
                    loc11 = JSON.decode(MyLifeInstance.getInstance().myLifeConfiguration.variables["querystring"]["facebookJSON"]);
                    loc8 = (loc8 = loc8 + "&sn_uid=" + loc11.fb_sig_user) + "&sn_session_key=" + loc11.fb_sig_session_key;
                    break;
                case "platformMySpace":
                    loc9 = "ms";
                    loc15 = MyLifeInstance.getInstance().myLifeConfiguration.variables["querystring"]["opensocialJSON"];
                    loc16 = MyLifeInstance.getInstance().myLifeConfiguration.variables["querystring"]["oathJSON"];
                    loc8 = loc8 + "&opensocialJSON=" + loc15 + "&oauthJSON=" + loc16;
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc9 = "tg";
                    loc8 = (loc8 = loc8 + "&") + MyLifeConfiguration.networkCredentials;
                    break;
            }
            if (loc9 != null)
            {
                loc6 = loc6.replace(loc10, loc9);
            }
            loc8 = loc8 + "&r=" + Math.random();
            loc12 = loc6 + loc7 + loc8;
            trace("url = " + loc12);
            (loc13 = new URLRequest(loc12)).method = URLRequestMethod.GET;
            (loc14 = new URLLoader()).addEventListener(Event.COMPLETE, sendNotificationCompleteHandler, false, 0, true);
            loc14.addEventListener(IOErrorEvent.IO_ERROR, sendNotificationErrorHandler, false, 0, true);
            loc14.load(loc13);
            return;
        }

        private function handleUpdateCharacterProperty(arg1:Object):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = JSON.decode(arg1.v);
            loc3 = arg1.uid;
            loc4 = arg1.p;
            switch (loc4) 
            {
                case "vis":
                    break;
                case "tp":
                    MyLifeInstance.getInstance().getZone().updateCharacterTyping(loc3);
                    break;
                case "dk":
                    MyLifeInstance.getInstance().getZone().updateCharacterDrunkLevel(loc3, loc2.l);
                    break;
                case "zzz":
                    MyLifeInstance.getInstance().getZone().updateCharacterZzzStatus(loc3, loc2.z);
                    break;
                case "stop":
                    MyLifeInstance.getInstance().getZone().updateCharacterStop(loc3);
                    break;
                case "item":
                    MyLifeInstance.getInstance().getZone().updateCharacterItemState(loc3, loc2.piid, loc2.posId, loc2.itemPos);
                    break;
                default:
                    break;
            }
            return;
        }

        private function onRoundTripResponse(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.ROUND_TRIP_COMPLETE, {"ms":getTickCount() - _lastRoundTripStart}));
            return;
        }

        public function disconnect():void
        {
            _smartFoxClient.disconnect();
            return;
        }

        public function roundTripBench():void
        {
            _lastRoundTripStart = getTickCount();
            _smartFoxClient.roundTripBench();
            return;
        }

        internal function onSFSConnectionLost(arg1:it.gotoandplay.smartfoxserver.SFSEvent=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc3 = null;
            loc4 = null;
            if (this.isReconnecting)
            {
                loc2 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultServer"];
                this.connect(loc2);
            }
            else 
            {
                isConnected = false;
                MyLifeInstance.getInstance().loadingStatus.hide();
                if (_userKicked == "")
                {
                    connectionLostCount = connectionLostCount + 1;
                    if (connectionLostCount <= 1)
                    {
                        loc3 = "You lost your connection to the game server.\nPlease refresh your browser to continue.";
                        (loc4 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Connection To The Server Was Lost", "message":loc3, "buttons":[{"name":"Refresh", "value":"BTN_REFRESH"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, reconnectDialogHandler, false, 0, true);
                    }
                    else 
                    {
                        loc3 = "You lost your connection to the game server.\nPlease refresh your browser to continue.";
                        MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Connection To The Server Was Lost", "message":loc3});
                    }
                }
                else 
                {
                    loc3 = _userKicked;
                    MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Connection To The Server Was Lost", "message":loc3, "noButtons":true});
                }
            }
            this.dispatchEvent(new Event("sfs_connectionLost"));
            return;
        }

        public function sendItemEvent(arg1:*, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = null;
            loc3 = arg2.eventName;
            if (loc3)
            {
                (loc4 = {}).eventName = loc3;
                loc4.itemId = arg1.itemId || 0;
                loc4.itemX = arg1.x || 0;
                loc4.itemY = arg1.y || 0;
                loc4.params = arg2;
                loc5 = JSON.encode(loc4);
                sendPublicMessage("ITEMEVT:" + loc5);
            }
            return;
        }

        internal function onSFSUserEnterRoom(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            var evt:it.gotoandplay.smartfoxserver.SFSEvent;
            var loc2:*;
            var loc3:*;
            var newUser:it.gotoandplay.smartfoxserver.data.User;
            var uVariables:*;

            evt = arg1;
            newUser = evt.params.user;
            uVariables = newUser.getVariables();
            if (uVariables.player)
            {
                try
                {
                    uVariables.player = JSON.decode(uVariables.player);
                }
                catch (e:Error)
                {
                    return;
                }
                trace("x " + uVariables.x + " y " + uVariables.y);
                uVariables.d = 1;
                dispatchEvent(new MyLifeEvent(MyLifeEvent.USER_JOIN, uVariables));
            }
            return;
        }

        internal function onSFSConnectionFail():void
        {
            var loc1:*;
            var loc2:*;

            trace("onSFSConnectionFail()");
            loc1 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultServer"];
            loc2 = MyLifeInstance.getInstance().getConfiguration().variables["server"][loc1];
            trace("serverConnection.port = " + loc2.port);
            if (loc2.port != this.BACKUP_PORT)
            {
                loc2.port = this.BACKUP_PORT;
                _smartFoxClient.connect(loc2.ip, loc2.port);
            }
            else 
            {
                isConnected = false;
                MyLifeInstance.getInstance().loadingStatus.hide();
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Could Not Connect To The Server", "message":"There was a problem connecting to the server. This may be due to a firewall on your network. Press your refresh button to try again. Please let us know if the problem continues.", "noButtons":true});
                ExceptionLogger.logException("Firewall Problem or IP", "onSFSConnectionFail");
                disconnectLog(3);
            }
            return;
        }

        internal function onLoginFailed(arg1:String="General failure"):void
        {
            isConnected = false;
            MyLifeInstance.getInstance().loadingStatus.hide();
            MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Could Not Login To Your Account", "message":"There was a problem connecting to the server.\nThe error that was returned is: " + arg1 + ".\nPlease let us know that you have received this error.", "noButtons":true});
            ExceptionLogger.logException(arg1, "onLoginFailed");
            return;
        }

        public function sendPlayerToPlayerEvent(arg1:*, arg2:String, arg3:String, arg4:Object):*
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;

            (loc5 = arg4).action = arg3;
            (loc6 = {}).t = arg2;
            loc6.p = loc5;
            loc7 = JSON.encode(loc6);
            sendPublicMessage("EVT:" + loc7, arg1);
            return;
        }

        public function sendPublicMessage(arg1:String, arg2:int=0):void
        {
            callExtension("sendMessage", {"message":arg1, "target":arg2});
            return;
        }

        public function activatePlayer(arg1:int):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = MyLifeInstance.getInstance().getConfiguration();
            loc4 = loc3.platformType;
            switch (loc4) 
            {
                case loc3.PLATFORM_FACEBOOK:
                    loc2 = "1:" + MyLifeConfiguration.sn_uid;
                    break;
                case loc3.PLATFORM_MYSPACE:
                    loc2 = "2:" + MyLifeConfiguration.sn_uid;
                    break;
                case loc3.PLATFORM_TAGGED:
                    loc2 = "3:" + MyLifeConfiguration.sn_uid;
                    break;
                default:
                    loc2 = "";
                    break;
            }
            callExtension("activatePlayer", {"playerId":arg1, "sn_uid":loc2, "versionMinor":MyLifeConfiguration.version, "versionMajor":MyLifeConfiguration.getInstance().variables["querystring"]["versionMajor"]});
            return;
        }

        internal function onSFSIOError(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            MyLifeInstance.getInstance().debug("onSFSIOError Occured");
            ExceptionLogger.logException("EVT: " + arg1.toString(), "onSFSIOError");
            disconnectLog(1);
            return;
        }

        internal function onSFSRoomListUpdate(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            return;
        }

        private function sendNotificationCompleteHandler(arg1:flash.events.Event):void
        {
            var action:int;
            var link:String;
            var loader:flash.net.URLLoader;
            var loc2:*;
            var loc3:*;
            var object:Object;
            var pEvent:flash.events.Event;
            var response:Object;

            loader = null;
            response = null;
            object = null;
            pEvent = arg1;
            loader = pEvent.currentTarget as URLLoader;
            loader.removeEventListener(Event.COMPLETE, sendNotificationCompleteHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, sendNotificationErrorHandler);
            response = {};
            try
            {
                object = JSON.decode(loader.data);
                if (object as Number)
                {
                    response.reward = object;
                }
                else 
                {
                    response = object;
                }
            }
            catch (e:*)
            {
                response.reward = Number(loader.data);
            }
            response = response || {};
            dispatchEvent(new MyLifeEvent(MyLifeEvent.NOTIFICATION_SUCCESS, response));
            action = response["action"];
            link = null;
            loc3 = action;
            switch (loc3) 
            {
                case ACTION_MANAGER_TYPE_DANCE:
                    link = Number(response["reward"]) ? "1980" : null;
                    break;
                case ACTION_MANAGER_TYPE_FIGHT:
                    link = Number(response["reward"]) ? "1981" : null;
                    break;
                case ACTION_MANAGER_TYPE_GIFT:
                    link = "1982";
                    break;
                case ACTION_MANAGER_TYPE_JOKE:
                    link = Number(response["reward"]) ? "1983" : null;
                    break;
                case ACTION_MANAGER_TYPE_KISS:
                    link = Number(response["reward"]) ? "1984" : null;
                    break;
                case ACTION_MANAGER_TYPE_MESSAGE:
                    link = "1985";
                    break;
                case ACTION_MANAGER_TYPE_RACE_WON:
                case ACTION_MANAGER_TYPE_RACE_LOST:
                    link = "2315";
                    break;
            }
            if (_linkTracker && link && MyLifeInstance.getInstance().myLifeConfiguration.platformType == "platformFacebook")
            {
                _linkTracker.setRandomActive();
                _linkTracker.track(link, "1529");
                trace("Server LinkTrack(" + link + ", 1529)");
            }
            return;
        }

        public function getSFS():it.gotoandplay.smartfoxserver.SmartFoxClient
        {
            return _smartFoxClient;
        }

        public function getUserId():*
        {
            return _smartFoxClient.myUserId;
        }

        private function onSFSPublicMessage(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            return;
        }

        internal function onSFSLogin(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            return;
        }

        private function onSFSJoinRoomError(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            MyLifeInstance.getInstance().loadingStatus.hide();
            ExceptionLogger.logException("EVT: " + arg1.toString(), "onSFSJoinRoomError");
            return;
        }

        private function getTickCount():Number
        {
            var loc1:*;

            loc1 = new Date();
            return loc1.valueOf();
        }

        private function sendNotificationErrorHandler(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, sendNotificationCompleteHandler);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, sendNotificationErrorHandler);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.NOTIFICATION_ERROR));
            return;
        }

        public function requestStatus(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
            loc3 = loc2 + "player_info.php?player_id=" + arg1;
            loc4 = new URLRequest(loc3);
            (loc5 = new URLLoader()).addEventListener(Event.COMPLETE, getStatusComplete);
            loc5.addEventListener(IOErrorEvent.IO_ERROR, getStatusError);
            loc5.load(loc4);
            return;
        }

        private function getStatusComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            trace("getStatusComplete() json = " + arg1.target.data);
            if (arg1.target.hasOwnProperty("data") && !(arg1.target.data == null))
            {
                loc2 = JSON.decode(arg1.target.data);
                loc3 = loc2[0];
                if (loc3.result == 1 && loc2[1].description.length > 0)
                {
                    loc4 = loc2[1].description;
                }
                else 
                {
                    loc4 = "";
                }
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_STATUS_SUCCESS, {"status":loc4}));
            }
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.GET_STATUS_ERROR));
            return;
        }

        internal function onSFSConnection(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            var loc2:*;

            loc2 = arg1.params.success;
            if (loc2)
            {
                doSFSLogin();
            }
            else 
            {
                onSFSConnectionFail();
            }
            return;
        }

        private function disconnectLogError(arg1:flash.events.IOErrorEvent):void
        {
            trace("disconnectLogError()");
            return;
        }

        private function disconnectLogComplete(arg1:flash.events.Event):void
        {
            trace("disconnectLogComplete()");
            return;
        }

        internal function onSFSJoinRoom(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.JOIN_SUCCESS, arg1.params, false));
            return;
        }

        private function onModeratorMessage(arg1:it.gotoandplay.smartfoxserver.SFSEvent):void
        {
            MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Moderator Message Received", "message":"Moderator Message: " + arg1.params.message});
            return;
        }

        public function reconnect(arg1:*):void
        {
            var loc2:*;
            var loc3:*;

            trace("Server() reconnect(" + arg1 + ")");
            this.isReconnecting = true;
            loc2 = String(arg1);
            loc3 = "server" + loc2.charAt();
            MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultServer"] = loc3;
            MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"] = arg1;
            if (this.isConnected)
            {
                this.disconnect();
            }
            else 
            {
                this.connect(loc3);
            }
            return;
        }

        public function onApartmentTourCallback(arg1:*, arg2:*):*
        {
            if (arg2 != "1")
            {
                MyLifeInstance.getInstance().getZone().firstApartmentTour = false;
            }
            else 
            {
                MyLifeInstance.getInstance().getZone().firstApartmentTour = true;
            }
            trace("server join(\'APLiving");
            MyLifeInstance.getInstance().getZone().join("APLiving-" + arg1);
            return;
        }

        public function connect(arg1:Object, arg2:String=""):void
        {
            var loc3:*;
            var loc4:*;
            var serverConnection:Object;
            var serverName:Object;
            var zoneName:String="";

            serverConnection = null;
            serverName = arg1;
            zoneName = arg2;
            trace("Server() connect() serverName = " + serverName);
            try
            {
                serverConnection = MyLifeInstance.getInstance().getConfiguration().variables["server"][serverName];
                MyLifeInstance.getInstance().debug("serverConnection IP: " + serverConnection.ip);
                MyLifeInstance.getInstance().debug("serverConnection Port: " + serverConnection.port);
                MyLifeInstance.getInstance().debug("Trying to connect to server...");
            }
            catch (error:Error)
            {
                trace("Server connect " + undefined);
            }
            if (serverConnection)
            {
                _smartFoxClient.smartConnect = true;
                _smartFoxClient.connect(serverConnection.ip, serverConnection.port);
            }
            return;
        }

        private function reconnectDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            navigateToURL(new URLRequest("javascript:window.location.reload(true)"), "_self");
            return;
        }

        public function joinZone(arg1:String):void
        {
            trace("Server joinZone() zoneName = " + arg1);
            callExtension("joinRoom", {"zone":arg1});
            return;
        }

        public const ACTION_MANAGER_TYPE_GIFT:int=1;

        public const ACTION_MANAGER_TYPE_NONE:int=0;

        public const ACTION_MANAGER_TYPE_KISS:int=4;

        public const ACTION_MANAGER_TYPE_HUG:int=6;

        public const ACTION_MANAGER_TYPE_RACE_LOST:int=11;

        public const ACTION_MANAGER_TYPE_ANIMATION:int=13;

        public const ACTION_MANAGER_TYPE_MESSAGE:int=2;

        public const ACTION_MANAGER_TYPE_FIGHT:int=3;

        public const ACTION_MANAGER_TYPE_JOKE:int=7;

        private const BACKUP_PORT:String="443";

        public const ACTION_MANAGER_TYPE_DANCE:int=5;

        public const ACTION_MANAGER_TYPE_RACE_WON:int=10;

        public const ACTION_MANAGER_TYPE_PET_FED:int=12;

        private var connectionLostCount:int=0;

        private var _linkTracker:MyLife.LinkTracker;

        private var _lastRoundTripStart:Number;

        public var playerToPlayerEventHandler:MyLife.PlayerToPlayerEventHandler;

        private var _userKicked:String="";

        private var _lastMessage:String;

        private var _smartFoxClient:it.gotoandplay.smartfoxserver.SmartFoxClient;

        public var isReconnecting:Boolean=false;

        public var isConnected:Boolean=false;
    }
}
