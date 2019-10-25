package MyLife 
{
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    
    public class TradeManager extends flash.events.EventDispatcher
    {
        public function TradeManager()
        {
            super();
            return;
        }

        private static function handleAlreadyTrading(arg1:*):void
        {
            var loc2:*;

            if (tradeInitDialog)
            {
                _myLife.getInterface().unloadInterface(tradeInitDialog);
                tradeInitDialog = null;
            }
            loc2 = getPlayerName(arg1);
            _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":loc2 + " is already trading with another player."});
            return;
        }

        public static function sendCompletedTrade(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            arg1.lk = _myLife.getConfiguration().variables["querystring"]["lk"];
            loc2 = arg1.trade;
            loc2[0].sid = _myLife.getServer().getUserId();
            loc2[1].sid = tradeServerUserId;
            loc3 = loc2[0].items.length;
            loc4 = loc2[1].items.length;
            loc5 = loc2[0].coins;
            loc6 = loc2[1].coins;
            if (loc3 + loc4 + loc5 + loc6)
            {
                _myLife.getServer().addEventListener(MyLifeEvent.TRADE_COMPLETE, tradeCompleteHandler, false, 0, true);
                _myLife.getServer().callExtension("TradeMaster.initiateTrade", arg1);
            }
            else 
            {
                TradeManager.cancelTrade();
            }
            return;
        }

        private static function getPlayerName(arg1:*):String
        {
            var loc2:*;

            loc2 = "";
            if (arg1 && _myLife && _myLife.getZone())
            {
                loc2 = _myLife.getZone().getCharacterName(arg1);
            }
            return loc2;
        }

        private static function handleTradeInvite(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = null;
            if (isIgnoringTrades)
            {
                waitingForMeToAcceptTradeRequest[arg1] = false;
                sendPlayerToPlayerEvent(arg1, "leave_trade", {});
                return;
            }
            if (tradeInterface)
            {
                waitingForMeToAcceptTradeRequest[arg1] = false;
                sendPlayerToPlayerEvent(arg1, "already_trading", {});
                return;
            }
            if (_myLife.getZone().editMode)
            {
                waitingForMeToAcceptTradeRequest[arg1] = false;
                sendPlayerToPlayerEvent(arg1, "leave_trade", {});
                return;
            }
            loc2 = getPlayerName(arg1);
            if (loc2 != "")
            {
                loc4 = loc2 + " has requested a trade.\nDo you accept the request?";
                if (ignoreTradesCount < 2)
                {
                    loc3 = _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Invite", "message":loc4, "metaData":{"serverUserId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}]});
                }
                else 
                {
                    loc3 = _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Invite", "message":loc4, "metaData":{"serverUserId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}, {"name":"Ignore All", "value":"BTN_IGNORE"}]});
                }
                loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInviteDialogHandler, false, 0, true);
                tradeInviteDialogCollection[arg1] = loc3;
                waitingForMeToAcceptTradeRequest[arg1] = true;
            }
            return;
        }

        public static function sendTradeData(arg1:Object):void
        {
            sendPlayerToPlayerEvent(tradeServerUserId, "update_trade", arg1);
            return;
        }

        private static function handleLeaveTrade(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var otherPlayerName:*;
            var serverUserId:*;

            serverUserId = arg1;
            if (tradeInviteDialogCollection[serverUserId])
            {
                _myLife.getInterface().unloadInterface(tradeInviteDialogCollection[serverUserId]);
                tradeInviteDialogCollection[serverUserId] = null;
            }
            otherPlayerName = getPlayerName(serverUserId);
            if (otherPlayerName != "")
            {
                if (tradeInterface)
                {
                    TradeManager.closeTradeInterface();
                    _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":otherPlayerName + " has canceled the trade."});
                }
                else 
                {
                    if (tradeInviteServerUserId != serverUserId)
                    {
                        if (waitingForMeToAcceptTradeRequest[serverUserId])
                        {
                            _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":otherPlayerName + " canceled the trade request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                            TradeManager.closeTradeInterface();
                        }
                    }
                    else 
                    {
                        try
                        {
                            if (tradeInitDialog)
                            {
                                _myLife.getInterface().unloadInterface(tradeInitDialog);
                                tradeInitDialog = null;
                            }
                        }
                        catch (e:Error)
                        {
                        };
                        tradeInitDialog = null;
                        _tradeKey = null;
                        _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":otherPlayerName + " declined your trade request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                    }
                }
                waitingForMeToAcceptTradeRequest[serverUserId] = false;
            }
            return;
        }

        public static function cancelTrade():void
        {
            closeTradeInterface();
            sendPlayerToPlayerEvent(tradeServerUserId, "leave_trade", {});
            tradeServerUserId = 0;
            return;
        }

        private static function cancelTradeInvite(arg1:*):void
        {
            _tradeKey = null;
            tradeInviteServerUserId = 0;
            sendPlayerToPlayerEvent(arg1, "leave_trade", {});
            return;
        }

        public static function closeTradeInterface():void
        {
            if (tradeInterface)
            {
                _myLife.getInterface().unloadInterface(tradeInterface);
                tradeInterface = null;
            }
            isTrading = false;
            _tradeKey = null;
            _myLife.getInterface().interfaceHUD.showOverlayButtons();
            return;
        }

        private static function resetIgnoreStatus():*
        {
            ignoreTradesCount = 0;
            isIgnoringTrades = false;
            return;
        }

        private static function tradeCompleteHandler(arg1:MyLife.MyLifeEvent):void
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
            loc3 = null;
            loc5 = undefined;
            loc6 = NaN;
            loc7 = null;
            loc8 = 0;
            loc9 = undefined;
            loc10 = null;
            trace("tradeCompleteHandler()");
            trace("success: " + Number(arg1.eventData.success));
            if ((loc4 = Number(arg1.eventData.success)) != 1)
            {
                if (loc4 != 0)
                {
                    if (loc4 == 2)
                    {
                        trace("trade from same ip");
                        loc2 = "Trade Failed";
                        loc3 = "Users from the same IP address are not allowed to trade with each other";
                    }
                }
                else 
                {
                    loc2 = "Trade Failed";
                    loc3 = "Your trade failed to complete.";
                }
            }
            else 
            {
                loc2 = "Trade Completed";
                loc3 = "Your trade was successful!";
                loc5 = _myLife.getPlayer()._playerId;
                loc6 = Number(_myLife._interface.interfaceHUD.txtCoinCount.text);
                if (loc7 = tradeInterface.rawTradeData.items)
                {
                    loc8 = loc7.length;
                    while (loc8--) 
                    {
                        loc9 = loc7[loc8].piid;
                        InventoryManager.removeItemFromInventory(loc9);
                    }
                }
                loc6 = loc6 - tradeInterface.rawTradeData.coins;
                if (loc7 = arg1.eventData.items)
                {
                    loc8 = loc7.length;
                    while (loc8--) 
                    {
                        (loc10 = loc7[loc8]).playerId = loc5;
                        InventoryManager.addItemToInventory(loc10);
                    }
                }
                loc6 = loc6 + tradeInterface.otherPlayerRawTradeData.coins;
                _myLife._interface.interfaceHUD.txtCoinCount.text = String(loc6);
            }
            TradeManager.closeTradeInterface();
            _myLife.getInterface().showInterface("GenericDialog", {"title":loc2, "message":loc3, "autoClose":10});
            return;
        }

        public static function initialize():void
        {
            _myLife = MyLifeInstance.getInstance();
            tradeInviteDialogCollection = {};
            waitingForMeToAcceptTradeRequest = {};
            tradetIgnoreCount = 0;
            isIgnoringTrades = false;
            _myLife.server.playerToPlayerEventHandler.addEventListener(MyLifeEvent.TRADE_RESPONSE, eventHandler, false, 0, true);
            return;
        }

        private static function handleAgreeTrade(arg1:Object):void
        {
            tradeInterface.setOtherPlayerAgreement(arg1);
            return;
        }

        private static function tradeInviteDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc4 = undefined;
            loc5 = undefined;
            trace("tradeInviteDialogHandler");
            loc2 = arg1.eventData.metaData.serverUserId;
            if (tradeInviteDialogCollection[loc2])
            {
                tradeInviteDialogCollection[loc2].removeEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInviteDialogHandler);
                tradeInviteDialogCollection[loc2] = null;
            }
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                if (arg1.eventData.userResponse != "BTN_IGNORE")
                {
                    _tradeKey = null;
                    ignoreTradesCount++;
                    sendPlayerToPlayerEvent(loc2, "leave_trade", {});
                }
                else 
                {
                    _tradeKey = null;
                    isIgnoringTrades = true;
                    loc6 = 0;
                    loc7 = tradeInviteDialogCollection;
                    for each (loc4 in loc7)
                    {
                        if (!loc4)
                        {
                            continue;
                        }
                        loc4.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInviteDialogHandler);
                        loc4 = null;
                    }
                    loc6 = 0;
                    loc7 = waitingForMeToAcceptTradeRequest;
                    for (loc5 in loc7)
                    {
                        if (!waitingForMeToAcceptTradeRequest[loc5])
                        {
                            continue;
                        }
                        sendPlayerToPlayerEvent(loc5, "leave_trade", {});
                    }
                    waitingForMeToAcceptTradeRequest = {};
                    ignoreTradesCount++;
                }
            }
            else 
            {
                loc3 = Math.round(Math.random() * 10000).toString();
                _tradeKey = MyLifeUtils.hash(_tradeKey + loc3);
                sendPlayerToPlayerEvent(loc2, "accept_invite", {"key":loc3});
                openTradeInterface(loc2);
            }
            return;
        }

        public static function sendTradeInvite(arg1:*):void
        {
            var loc2:*;

            loc2 = null;
            trace("sendTradeRequest");
            tradeInviteServerUserId = arg1;
            if (waitingForMeToAcceptTradeRequest[arg1])
            {
                _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":"That player has already requested a trade with you."});
            }
            else 
            {
                _tradeKey = Math.round(Math.random() * 10000).toString();
                sendPlayerToPlayerEvent(arg1, "new_invite", {"key":_tradeKey});
                loc2 = getPlayerName(arg1);
                if (loc2)
                {
                    tradeInitDialog = _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":"Please wait for " + loc2 + " to accept your trade request...", "metaData":{"serverUserId":arg1}, "icon":"loading", "buttons":[{"name":"Cancel Trade", "value":"BTN_CANCEL"}]});
                    tradeInitDialog.addEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInitDialogHandler, false, 0, true);
                }
                else 
                {
                    _myLife.getInterface().showInterface("GenericDialog", {"title":"Trade Request", "message":"The player you requested to trade with has left the room."});
                }
            }
            resetIgnoreStatus();
            return;
        }

        private static function eventHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            trace("eventHandler()");
            loc2 = arg1.eventData;
            loc3 = false;
            loc4 = arg1.eventData.params.action;
            if (loc2.params["data"] && _tradeKey)
            {
                loc3 = true;
                loc2.params = JSON.decode(MyLifeUtils.decrypt(arg1.eventData.params.data, _tradeKey));
                loc2.params.action = loc4;
            }
            trace("action = " + loc4);
            if (loc2)
            {
                loc5 = loc4;
                switch (loc5) 
                {
                    case "new_invite":
                        if (loc2.params["key"])
                        {
                            _tradeKey = loc2.params["key"];
                            handleTradeInvite(loc2.sender);
                        }
                        else 
                        {
                            cancelTradeInvite(loc2.sender);
                        }
                        break;
                    case "leave_trade":
                        _tradeKey = null;
                        handleLeaveTrade(loc2.sender);
                        break;
                    case "accept_invite":
                        if (loc2.params["key"])
                        {
                            _tradeKey = MyLifeUtils.hash(_tradeKey + loc2.params["key"]);
                            handleAcceptInvite(loc2.sender);
                        }
                        else 
                        {
                            cancelTradeInvite(loc2.sender);
                        }
                        break;
                    case "already_trading":
                        _tradeKey = null;
                        handleAlreadyTrading(loc2.sender);
                        break;
                    case "update_trade":
                        if (loc3)
                        {
                            handleUpdateTrade(loc2.params);
                        }
                        else 
                        {
                            cancelTradeScam();
                        }
                        break;
                    case "agree_trade":
                        if (loc3)
                        {
                            handleAgreeTrade(loc2.params);
                        }
                        else 
                        {
                            cancelTradeScam();
                        }
                        break;
                }
            }
            return;
        }

        private static function handleUpdateTrade(arg1:Object):void
        {
            tradeInterface.setOtherPlayerTradeData(arg1);
            return;
        }

        public static function sendAgreement(arg1:Object):void
        {
            sendPlayerToPlayerEvent(tradeServerUserId, "agree_trade", arg1);
            return;
        }

        public static function openTradeInterface(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = undefined;
            loc3 = undefined;
            loc4 = null;
            if (!tradeInterface)
            {
                tradeServerUserId = arg1;
                if (tradeInitDialog)
                {
                    _myLife.getInterface().unloadInterface(tradeInitDialog);
                    tradeInitDialog = null;
                }
                loc5 = 0;
                loc6 = tradeInviteDialogCollection;
                for each (loc2 in loc6)
                {
                    if (!loc2)
                    {
                        continue;
                    }
                    loc2.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInviteDialogHandler);
                    _myLife.getInterface().unloadInterface(loc2);
                    loc2 = null;
                }
                loc5 = 0;
                loc6 = waitingForMeToAcceptTradeRequest;
                for (loc3 in loc6)
                {
                    if (!(!(loc3 == tradeServerUserId) && waitingForMeToAcceptTradeRequest[loc3]))
                    {
                        continue;
                    }
                    sendPlayerToPlayerEvent(loc3, "already_trading", {});
                }
                waitingForMeToAcceptTradeRequest = {};
                loc4 = getPlayerName(arg1);
                tradeInterface = _myLife.getInterface().showInterface("TradeInterface", {"serverUserId":arg1, "otherPlayerName":loc4});
            }
            isTrading = true;
            return;
        }

        private static function handleAcceptInvite(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var serverUserId:*;

            serverUserId = arg1;
            try
            {
                openTradeInterface(serverUserId);
            }
            catch (e:Error)
            {
            };
            return;
        }

        private static function sendPlayerToPlayerEvent(arg1:*, arg2:String, arg3:Object):void
        {
            var loc4:*;

            arg3 = ((loc4 = isTrading ? MyLifeUtils.encrypt(JSON.encode(arg3), _tradeKey) : null) != null) ? {"data":loc4} : arg3;
            _myLife.getServer().sendPlayerToPlayerEvent(arg1, "TRADE", arg2, arg3);
            return;
        }

        private static function tradeInitDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = undefined;
            trace("tradeInitDialogHandler");
            if (tradeInitDialog)
            {
                tradeInitDialog.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, tradeInitDialogHandler);
                tradeInitDialog = null;
            }
            if (arg1.eventData.userResponse == "BTN_CANCEL")
            {
                loc2 = arg1.eventData.metaData.serverUserId;
                cancelTradeInvite(loc2);
            }
            return;
        }

        public static function cancelTradeScam():void
        {
            var loc1:*;
            var loc2:*;

            cancelTrade();
            loc1 = "Trade Canceled";
            loc2 = "This trade was automatically canceled due to a possible scam attempt by the other player.";
            _myLife.getInterface().showInterface("GenericDialog", {"title":loc1, "message":loc2});
            return;
        }

        
        {
            isTrading = false;
            _tradeKey = null;
        }

        private static var tradeInitDialog:flash.display.MovieClip;

        private static var isIgnoringTrades:Boolean;

        private static var ignoreTradesCount:int;

        private static var tradeInviteServerUserId:*;

        public static var isTrading:Boolean=false;

        private static var _myLife:*;

        private static var waitingForMeToAcceptTradeRequest:Object;

        private static var tradetIgnoreCount:int;

        private static var tradeInviteDialogCollection:Object;

        private static var tradeInterface:flash.display.MovieClip;

        private static var _tradeKey:String=null;

        private static var tradeServerUserId:*;
    }
}
