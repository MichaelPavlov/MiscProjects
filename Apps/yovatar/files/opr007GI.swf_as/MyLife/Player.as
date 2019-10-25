package MyLife 
{
    import MyLife.Events.*;
    import MyLife.Interfaces.*;
    import MyLife.NPC.*;
    import com.adobe.serialization.json.*;
    import fai.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import gs.*;
    
    public class Player extends flash.events.EventDispatcher
    {
        public function Player(arg1:Number, arg2:flash.display.MovieClip, arg3:Object)
        {
            _useItemQueue = [];
            super();
            trace("NEW PLAYER");
            _playerId = arg1;
            _myLife = arg2;
            SHOW_BADGE = true;
            arg3.player.energy = arg3.energy;
            importPlayerData(arg3.player);
            friendVisitsLeft = arg3.visitsLeft || 0;
            _myLife._interface.addEventListener(MyLifeEvent.DO_CHANGE_APPEARANCE, onShowChangeAppearance);
            _myLife.server.addEventListener(MyLifeEvent.UPDATE_BALANCE, onBalanceUpdated);
            _myLife.server.addEventListener(MyLifeEvent.UPDATE_ENERGY, onEnergyUpdated);
            _myLife.server.addEventListener(MyLifeEvent.USE_ITEM_RESPONSE, useItemHandler);
            _myLife.server.addEventListener(MyLifeEvent.SERVER_CONNECT, serverConnectHandler);
            _updateDirectionTimer = new Timer(2000);
            _updateDirectionTimer.addEventListener("timer", onUpdateDirectionTimerTick);
            _updateDirectionTimer.start();
            _detoxifyTimer = new Timer(3000);
            _detoxifyTimer.addEventListener("timer", detoxifyTimerTick);
            _detoxifyTimer.start();
            _idleZzzTimer = new Timer(1000);
            _idleZzzTimer.addEventListener("timer", idleZzzTimerTick);
            _idleZzzTimer.start();
            _idleDisconnectTimer = new Timer(DISCONNECT_IDLE_TIME_TRIGGER * 1000, 1);
            _idleDisconnectTimer.addEventListener("timer", idleDisconnectTimerTick);
            isCostumesDisabled = !Boolean(Number(MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["costumesEnabled"]));
            _energyDecrementTimer = new Timer(ENERGY_DECREMENT_TIME);
            _energyDecrementTimer.addEventListener(TimerEvent.TIMER, onDecreaseEnergyTimerTick);
            _energyDecrementTimer.start();
            linkTracker = new LinkTracker();
            linkTracker.setRandomActive();
            _myLife.server.addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, onNotificationSuccess);
            return;
        }

        private function onSendMessage(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.eventData.msg;
            loc3 = arg1.eventData.recipient;
            if (loc2 != "")
            {
                setZzzStatus(false);
                _myLife.server.sendPublicMessage(loc2, loc3);
            }
            return;
        }

        public function getPlayerName():String
        {
            return _playerName;
        }

        public function checkClothingCategoryInUse(arg1:int):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = false;
            loc4 = 0;
            loc5 = _currentClothing;
            for each (loc3 in loc5)
            {
                if (loc3.categoryId != arg1)
                {
                    continue;
                }
                loc2 = true;
                break;
            }
            return loc2;
        }

        private function getSpeedFromEnergyLevel(arg1:Number):Number
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = NaN;
            loc2 = 125;
            loc3 = 150;
            loc4 = 200;
            loc5 = 300;
            loc6 = 350;
            if (arg1 <= 0)
            {
                return loc2;
            }
            if (arg1 <= 20)
            {
                loc7 = arg1 / 20;
                return (loc3 - loc2) * loc7 + loc2;
            }
            if (arg1 <= 80)
            {
                loc7 = (arg1 - 20) / (80 - 20);
                return (loc4 - loc3) * loc7 + loc3;
            }
            if (arg1 <= 99)
            {
                loc7 = (arg1 - 80) / (99 - 80);
                return (loc5 - loc4) * loc7 + loc4;
            }
            return loc6;
        }

        private function onStartHungerCausingAction(arg1:MyLife.MyLifeEvent):void
        {
            _character.removeEventListener(MyLifeEvent.CHARACTER_ACTION_START, onStartHungerCausingAction);
            _character.addEventListener(MyLifeEvent.CHARACTER_ACTION_START, showHungerBubble);
            return;
        }

        private function removeMeterOnConfirmationClose(arg1:MyLife.MyLifeEvent):void
        {
            var dialog:MyLife.Interfaces.GenericDialog;
            var loc2:*;
            var loc3:*;
            var pEvent:MyLife.MyLifeEvent;

            pEvent = arg1;
            dialog = GenericDialog(pEvent.target);
            dialog.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, removeMeterOnConfirmationClose);
            try
            {
                dialog.removeChild(dialog.getChildByName("energyMeter"));
            }
            catch (error:Error)
            {
            };
            return;
        }

        public function getModLevel():int
        {
            return _modLevel;
        }

        public function getWalkable():Boolean
        {
            return isWalkable;
        }

        public function setEnergyLevel(arg1:Number):void
        {
            _energyLevel = arg1;
            if (_energyLevelInt != Math.ceil(_energyLevel))
            {
                _energyLevelInt = Math.ceil(_energyLevel);
            }
            if (_character)
            {
                _character.characterSpeed = getSpeedFromEnergyLevel(_energyLevelInt);
            }
            _myLife.getInterface().interfaceHUD.updatePlayerEnergy(_energyLevelInt);
            return;
        }

        private function onBalanceUpdated(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.coins != null)
            {
                setCoinBalance(arg1.eventData.coins);
            }
            if (arg1.eventData.cash != null)
            {
                setCashBalance(arg1.eventData.cash);
            }
            return;
        }

        public function get currentClothing():Object
        {
            return _currentClothing;
        }

        private function detoxifyTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (_drinksLevel > 0)
            {
                adjustDrinksLevel(-0.2);
            }
            return;
        }

        public function setWalkable(arg1:Boolean):void
        {
            isWalkable = arg1;
            return;
        }

        private function serverConnectHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (_character != null)
            {
                _character.serverUserId = _myLife.getServer().getUserId();
            }
            return;
        }

        public function setupCharacter():void
        {
            this._myLife.player.setWalkable(true);
            if (_character != null)
            {
                trace("not recreating character");
                onCharacterLoadingDone(null);
                return;
            }
            _character = new Character(MovieClip(_myLife), true);
            _character.myLifePlayerId = _rawPlayerData.playerId;
            _character.serverUserId = _myLife.server.getUserId();
            _character.setModLevel(_modLevel);
            _character.setCharacterProperties(_currentClothing, _gender, _playerName);
            if (BadgeManager.instance.isInitialized())
            {
                setupCharacterBadge();
            }
            else 
            {
                BadgeManager.instance.addEventListener(MyLifeEvent.BADGE_MANAGER_INITIALIZED, setupCharacterBadge);
            }
            _character.setXpAndLevel(_xp);
            _character.characterSpeed = getSpeedFromEnergyLevel(_energyLevelInt);
            _character.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, onCharacterLoadingDone);
            _character.loadCharacterClothing(_currentClothing, _rawPlayerData["temporaryCostume"]);
            adjustEnergyLevel(0, false);
            adjustDrinksLevel(0, false);
            if (_energyLevel < 10 && hungerThoughtTimer == null)
            {
                setZzzStatus(false);
                _myLife.server.sendPublicMessage("E:25", 0);
                this.hungerThoughtTimer = new Timer(HUNGER_THOUGHT_TIME);
                hungerThoughtTimer.addEventListener(TimerEvent.TIMER, onHungerThoughtTimerTick);
                hungerThoughtTimer.start();
            }
            return;
        }

        public function getDrinksLevel():Number
        {
            return _drinksLevel;
        }

        private function onNotificationSuccess(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            if (arg1.eventData.reward != 0)
            {
                friendVisitsLeft--;
            }
            if (friendVisitsLeft < 0)
            {
                friendVisitsLeft = 0;
            }
            return;
        }

        private function editPlayerInfoResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (arg1.eventData.userResponse == "BTN_OK")
            {
                loc3 = arg1.eventData.inputText;
                savePlayerInfoToServer(loc3);
            }
            return;
        }

        public function moveTo(arg1:fai.Position, arg2:Boolean=false):Object
        {
            var loc3:*;
            var loc4:*;

            loc4 = null;
            _currentMouseLookDirection = -1;
            setZzzStatus(false);
            loc3 = _character.getWalkPathToPosition(arg1);
            if (loc3 != null)
            {
                if (arg2 == true)
                {
                    loc3[(loc3.length - 1)] = arg1;
                }
                (loc4 = new Object()).id = 4;
                loc4.interruptionType = 2;
                loc4.params = {"walkPath":loc3, "walkSpeed":_character.characterSpeed};
                if (waitingToShowHungerBubble)
                {
                    showHungerBubble();
                }
                return loc4;
            }
            return null;
        }

        public function setCoinBalance(arg1:Number):void
        {
            _money = arg1;
            _myLife._interface.interfaceHUD.txtCoinCount.text = _money;
            return;
        }

        public function savePlayerInfoToServer(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            if (MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_FACEBOOK)
            {
                loc2 = JSON.decode(MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["facebookJSON"]);
                loc3 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
                loc4 = loc3 + "player_info.php";
                trace("EXPORT URL: " + loc4);
                (loc5 = new URLVariables()).fb_sig_user = loc2.fb_sig_user;
                loc5.fb_sig_session_key = loc2.fb_sig_session_key;
                loc5.player_id = _playerId;
                loc5.description = arg1;
                (loc6 = new URLRequest(loc4)).method = URLRequestMethod.POST;
                loc6.data = loc5;
                (loc7 = new URLLoader()).addEventListener(Event.COMPLETE, savePlayerInfoCompleteHandler);
                loc7.addEventListener(IOErrorEvent.IO_ERROR, savePlayerInfoErrorHandler);
                loc7.load(loc6);
            }
            return;
        }

        public function getPlayerId():Number
        {
            return _playerId;
        }

        private function adminMessageInputResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = null;
            if (arg1.eventData.userResponse == "BTN_OK")
            {
                loc3 = arg1.eventData.metaData.recipient;
                loc4 = arg1.eventData.inputText;
                setZzzStatus(false);
                _myLife.server.callExtension("sendAdminMessageToUser", {"target":loc3, "message":loc4});
            }
            return;
        }

        public function adjustDrinksLevel(arg1:Number, arg2:Boolean=true):void
        {
            setDrinksLevel(Math.round((_drinksLevel + arg1) * 10) / 10, arg2);
            return;
        }

        private function idleZzzTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (arg1.currentTarget.currentCount == ZZZ_IDLE_TIME_TRIGGER)
            {
                arg1.currentTarget.stop();
                setZzzStatus(true);
                _idleDisconnectTimer.reset();
                _idleDisconnectTimer.start();
            }
            return;
        }

        public function sendAdminMessage(arg1:*):void
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("InputDialog", {"title":"Enter Your Admin Message Text", "message":"Admin Message:", "metaData":{"recipient":arg1}, "buttons":[{"name":"Send", "value":"BTN_OK"}, {"name":"Cancel", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, adminMessageInputResponse);
            return;
        }

        public function setCashBalance(arg1:Number):void
        {
            _cash = arg1;
            _myLife._interface.interfaceHUD.txtCashCount.text = _cash;
            return;
        }

        public function updateDisplayBadge(arg1:int, arg2:int):void
        {
            if (arg2 >= _badgeLevel)
            {
                _badgeId = BadgeManager.instance.getBadgeIdFromTypeLevel(arg1, arg2);
                _badgeType = arg1;
                _badgeLevel = arg2;
                _character.renderDisplayBadge(_badgeType, _badgeLevel);
            }
            return;
        }

        private function onUpdateDirectionTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (_currentMouseLookDirection > -1 && !_character.actionBusy)
            {
                if (_lastServerUpdateDirection != _currentMouseLookDirection)
                {
                    _lastServerUpdateDirection = _currentMouseLookDirection;
                    _myLife.server.callExtension("updateCharacterDirection", {"d":_currentMouseLookDirection});
                }
            }
            return;
        }

        public function enableEditMode():void
        {
            editMode = true;
            _character.doStop();
            _myLife.zone.removeEventListener(MouseEvent.CLICK, onMouseClickEvent);
            _myLife.zone.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEvent);
            return;
        }

        public function getSpeedLevel():Number
        {
            return _speedLevel;
        }

        public function getCharacter():MyLife.Character
        {
            return _character;
        }

        private function onEnergyUpdated(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = NaN;
            if (arg1.eventData.energy != null)
            {
                loc2 = Number(arg1.eventData.energy) - _energyLevel;
                adjustEnergyLevel(loc2, loc2 < -1);
                setEnergyLevel(Number(arg1.eventData.energy));
            }
            return;
        }

        private function onDecreaseEnergyTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (!_character.freeActions)
            {
                _myLife.server.callExtension("updateCharacterEnergy", {"e":-ENERGY_DECREMENT});
            }
            return;
        }

        private function onCharacterLoadingDone(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            _myLife.zone.addMainCharacterClip(_character);
            _character.setPosition(_myLife.zone.getPositionFromPositionIndex());
            _myLife.zone.resortDepths();
            _myLife.zone.addEventListener(MouseEvent.CLICK, onMouseClickEvent);
            _myLife.zone.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEvent);
            _myLife.addEventListener(MyLifeEvent.SEND_MESSAGE, onSendMessage);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_LOADED, false));
            return;
        }

        private function getPlayerInfoComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (arg1.target.data != null)
            {
                loc2 = _myLife._interface.showInterface("InputDialog", {"title":"Enter Your Status Here", "message":"Status (" + MAX_PLAYER_STATUS + " chars max):", "buttons":[{"name":"Save", "value":"BTN_OK"}, {"name":"Cancel", "value":"BTN_NO"}]});
                loc2.txtInputMessage.maxChars = MAX_PLAYER_STATUS;
                loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, editPlayerInfoResponse);
                loc3 = JSON.decode(arg1.target.data);
                if ((loc4 = loc3[0]).result == 1)
                {
                    if (loc3[1].description.length > 0)
                    {
                        loc2.txtInputMessage.text = loc3[1].description;
                    }
                }
                _myLife.stage.focus = loc2.txtInputMessage;
            }
            return;
        }

        public function setNewClothing(arg1:Object, arg2:Boolean=false):void
        {
            trace("player.setNewClothing");
            _currentClothing = arg1;
            _character.setNewClothing(arg1, arg2);
            if (arg2)
            {
                InventoryManager.setClothingInUse(_currentClothing);
            }
            return;
        }

        private function privateMessageInputResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            if (arg1.eventData.userResponse == "BTN_OK")
            {
                loc3 = arg1.eventData.metaData.recipient;
                loc4 = _myLife.zone.getCharacter(loc3);
                loc5 = "";
                if (loc4)
                {
                    loc5 = loc4._characterName;
                }
                loc6 = "C:" + loc5 + ": " + arg1.eventData.inputText;
                setZzzStatus(false);
                _myLife.server.sendPublicMessage(loc6, loc3);
            }
            return;
        }

        public function setZzzStatus(arg1:Boolean):void
        {
            if (!arg1)
            {
                _idleDisconnectTimer.stop();
                _idleZzzTimer.reset();
                _idleZzzTimer.start();
            }
            if (_zzzMode != arg1)
            {
                _character.setZzzStatus(arg1);
                if (arg1)
                {
                    _myLife.server.callExtension("updateCharacterProperty", {"p":"zzz", "v":{"z":true}, "s":1});
                }
                else 
                {
                    _myLife.server.callExtension("updateCharacterProperty", {"p":"zzz", "v":{"z":false}, "s":0});
                }
                _zzzMode = arg1;
            }
            return;
        }

        private function onMouseClickEvent(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = null;
            if (isWalkable == false)
            {
                return;
            }
            loc2 = this._myLife.zone.checkValidPlayerMove();
            _myLife.zone.getTriggerZoneHit(_character.getPosition(), _character);
            if (loc2)
            {
                loc3 = new Position();
                loc3.x = _myLife.zone.zoneRenderClip.mouseX;
                loc3.y = _myLife.zone.zoneRenderClip.mouseY;
                if ((loc4 = moveTo(loc3)) != null)
                {
                    trace("onMouseClickEvent doActionList");
                    if (this._character && this._character.avatarActionManager)
                    {
                        this._character.avatarActionManager.doActionList([loc4], true);
                    }
                }
            }
            return;
        }

        private function getPlayerInfoFromServer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
            loc2 = loc1 + "player_info.php?player_id=" + _playerId;
            loc3 = new URLRequest(loc2);
            (loc4 = new URLLoader()).addEventListener(Event.COMPLETE, getPlayerInfoComplete);
            loc4.addEventListener(IOErrorEvent.IO_ERROR, getPlayerInfoError);
            loc4.load(loc3);
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
            while (_useItemQueue.length) 
            {
                useItemHandler(_useItemQueue.shift() as MyLifeEvent);
            }
            return;
        }

        public function savePlayerInfoCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (arg1.target.data.length != 0)
            {
                loc3 = JSON.decode(arg1.target.data);
                if ((loc4 = loc3[0]).result == 0)
                {
                    loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Save Player Info", "message":"We encountered a problem while saving your player info. Error Code 02.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
                }
            }
            else 
            {
                loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Save Player Info", "message":"We encountered a problem while saving your player info. Error Code 01.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            }
            return;
        }

        public function getEnergyLevel():Number
        {
            return _energyLevel;
        }

        public function setDrinksLevel(arg1:Number, arg2:Boolean=true):void
        {
            _drinksLevel = arg1;
            if (_drinksLevel < 0)
            {
                _drinksLevel = 0;
            }
            if (_drinksLevel > 100)
            {
                _drinksLevel = 100;
            }
            _myLife.zone.applyDrinksToView(_drinksLevel);
            if (_drinksLevelInt != Math.ceil(arg1))
            {
                _drinksLevelInt = Math.ceil(_drinksLevel);
                if (arg2)
                {
                    if (_myLife.server.isConnected)
                    {
                        if (_drinksLevelInt > 0)
                        {
                            _myLife.server.callExtension("updateCharacterProperty", {"p":"dk", "v":{"l":_drinksLevelInt}, "s":1});
                        }
                        else 
                        {
                            _myLife.server.callExtension("updateCharacterProperty", {"p":"dk", "v":{"l":0}, "s":0});
                        }
                    }
                }
                _myLife.dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_DRINKS_UPDATE, {"drinks":_drinksLevelInt}, true));
            }
            _character.setDrunkLevel(_drinksLevel);
            return;
        }

        public function dispatchStopCharacterEvent():void
        {
            _myLife.server.callExtension("updateCharacterProperty", {"p":"stop", "v":{}, "s":0});
            return;
        }

        private function importPlayerData(arg1:Object):void
        {
            _rawPlayerData = arg1;
            _currentClothing = _rawPlayerData.clothing;
            InventoryManager.setClothingInUse(_currentClothing);
            _firstTime = _rawPlayerData.firstTime;
            _locale = _rawPlayerData.locale;
            if (_firstTime == "1")
            {
                _firstTimeShowIntro = true;
            }
            _gender = _rawPlayerData.gender;
            age = _rawPlayerData.age;
            _modLevel = _rawPlayerData.mod_level;
            _playerName = _rawPlayerData.name;
            if (_rawPlayerData.hasOwnProperty("badgeId"))
            {
                _badgeId = _rawPlayerData.badgeId;
            }
            if (_rawPlayerData.hasOwnProperty("xp"))
            {
                _xp = _rawPlayerData.xp;
            }
            setCoinBalance(_rawPlayerData.money);
            if (!_rawPlayerData.hasOwnProperty("cash"))
            {
                _rawPlayerData.cash = "0";
            }
            setCashBalance(_rawPlayerData.cash);
            setEnergyLevel(_rawPlayerData.energy);
            _drinksLevel = 0;
            return;
        }

        public function showChangeClothing():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = {};
            loc1.editMode = Inventory.CLOTHING_ITEMS;
            loc1.nextStep = 3;
            loc1.selectedGender = _gender;
            loc1.nameSelected = _playerName;
            loc1.currentClothes = _currentClothing;
            loc2 = _myLife._interface.showInterface("CreateNewPlayerStep2", loc1);
            loc2.loadAvatarPreview();
            loc2.y = -loc2.height;
            TweenLite.to(loc2, 0.75, {"y":0, "ease":Back.easeOut});
            return;
        }

        public function getGender():int
        {
            return _gender;
        }

        public function sendPrivateMessage(arg1:*):void
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("InputDialog", {"title":"Enter Your Private Message Text", "message":"Private Message:", "metaData":{"recipient":arg1}, "buttons":[{"name":"Send", "value":"BTN_OK"}, {"name":"Cancel", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, privateMessageInputResponse);
            _myLife.stage.focus = loc2.txtInputMessage;
            return;
        }

        private function useItemHandler(arg1:MyLife.MyLifeEvent):void
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
            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = NaN;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            if (InventoryManager.ready)
            {
                loc2 = arg1.eventData;
                if (loc2.success == "true")
                {
                    loc13 = loc2.type;
                    switch (loc13) 
                    {
                        case "addItem":
                            InventoryManager.addItemToInventory(loc2.receivedItem);
                            if (showUseDialog)
                            {
                                _myLife.getInterface().showInterface("MysteryBoxDialog", {"newItem":loc2.receivedItem, "boxItem":InventoryManager.getInventoryItem(loc2.usedPlayerItemId), "rarity":loc2.rarity});
                            }
                            else 
                            {
                                showUseDialog = true;
                            }
                            break;
                        case "addEnergy":
                            loc3 = InventoryManager.getInventoryItem(loc2.usedPlayerItemId);
                            loc4 = {};
                            if (loc3["metaData"])
                            {
                                loc10 = String(loc3.metaData).split("|");
                                loc13 = 0;
                                loc14 = loc10;
                                for each (loc11 in loc14)
                                {
                                    loc12 = loc11.split(":");
                                    loc4[loc12[0]] = loc12[1];
                                }
                            }
                            loc5 = loc3.name;
                            loc6 = (loc2.addedEnergy > 0) ? "You Received +" + loc2.addedEnergy + " Energy From The " + loc3.name + "!" : "You Have Just Enjoyed The " + loc3.name + "!";
                            if (loc4["drunk"])
                            {
                                loc6 = "\nYour " + loc3.name + " Made You " + loc4.drunk + "% More Dizzy!";
                                _myLife.player.adjustDrinksLevel(loc4.drunk);
                            }
                            (loc7 = new EnergyMeter()).name = "energyMeter";
                            if ((loc8 = loc2.newEnergy) <= 0)
                            {
                                loc7.gotoAndStop(1);
                                loc7.txtEnergy.text = "0%";
                            }
                            else 
                            {
                                if (loc8 > 100)
                                {
                                    loc7.gotoAndStop(100);
                                    loc7.txtEnergy.text = "100%";
                                }
                                else 
                                {
                                    loc7.gotoAndStop(loc8);
                                    loc7.txtEnergy.text = String(loc8) + "%";
                                }
                            }
                            loc7.x = 255;
                            loc7.y = 275;
                            loc9 = _myLife._interface.showInterface("GenericDialog", {"title":loc5, "message":loc6});
                            if (!loc4["drunk"])
                            {
                                loc9.addChild(loc7);
                                loc9.addEventListener(MyLifeEvent.DIALOG_RESPONSE, removeMeterOnConfirmationClose, false, 0, true);
                            }
                            break;
                    }
                    InventoryManager.removeItemFromInventory(loc2.usedPlayerItemId);
                }
            }
            else 
            {
                _useItemQueue.push(arg1);
                InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
                InventoryManager.loadInventory();
            }
            return;
        }

        private function showHungerBubble(arg1:MyLife.MyLifeEvent=null):void
        {
            waitingToShowHungerBubble = false;
            this.hungerThoughtTimer = new Timer(HUNGER_THOUGHT_TIME);
            hungerThoughtTimer.addEventListener(TimerEvent.TIMER, onHungerThoughtTimerTick);
            hungerThoughtTimer.start();
            _character.removeEventListener(MyLifeEvent.CHARACTER_ACTION_COMPLETE, showHungerBubble);
            _character.removeEventListener(MyLifeEvent.CHARACTER_ACTION_START, showHungerBubble);
            setZzzStatus(false);
            _myLife.server.sendPublicMessage("E:25", 0);
            return;
        }

        public function sendServerNewPlayerData():void
        {
            var loc1:*;

            loc1 = new Object();
            loc1.x = _character.getPosition().x;
            loc1.y = _character.getPosition().y;
            loc1.d = 1;
            _myLife.server.callExtension("sendNewPlayerData", loc1);
            return;
        }

        private function onShowChangeAppearance(arg1:MyLife.MyLifeEvent):void
        {
            showChangeClothing();
            return;
        }

        private function idleDisconnectTimerTick(arg1:flash.events.TimerEvent):void
        {
            MyLifeInstance.getInstance().getServer().disconnect();
            return;
        }

        public function adjustEnergyLevel(arg1:Number, arg2:Boolean=false):void
        {
            var loc3:*;

            loc3 = _energyLevel + arg1;
            if (loc3 < 10 && _energyLevel >= 10)
            {
                if (arg2 != false)
                {
                    waitingToShowHungerBubble = true;
                    _character.addEventListener(MyLifeEvent.CHARACTER_ACTION_START, onStartHungerCausingAction);
                    _character.addEventListener(MyLifeEvent.CHARACTER_ACTION_COMPLETE, showHungerBubble);
                }
                else 
                {
                    showHungerBubble();
                }
            }
            else 
            {
                if (loc3 >= 10 && _energyLevel < 10)
                {
                    if (hungerThoughtTimer != null)
                    {
                        hungerThoughtTimer.stop();
                        hungerThoughtTimer.removeEventListener(TimerEvent.TIMER, onHungerThoughtTimerTick);
                        this.hungerThoughtTimer = null;
                    }
                }
            }
            if (_energyLevelInt > 0 && loc3 <= 0)
            {
                linkTracker.track("2159", "1533");
            }
            else 
            {
                if (_energyLevelInt < 100 && loc3 >= 100)
                {
                    linkTracker.track("2158", "1533");
                }
            }
            return;
        }

        private function setupCharacterBadge(arg1:flash.events.Event=null):void
        {
            _badgeType = BadgeManager.instance.getBadgeTypeFromId(_badgeId);
            _badgeLevel = BadgeManager.instance.getBadgeLevelFromId(_badgeId);
            _character.renderDisplayBadge(_badgeType, _badgeLevel);
            _character.renderCharacterName();
            return;
        }

        public function editPlayerInfo():void
        {
            getPlayerInfoFromServer();
            return;
        }

        public function disableEditMode():void
        {
            editMode = false;
            _myLife.zone.addEventListener(MouseEvent.CLICK, onMouseClickEvent);
            _myLife.zone.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEvent);
            return;
        }

        private function onMouseMoveEvent(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = NaN;
            loc6 = 0;
            if (_myLife.zone.isGameMode())
            {
                return;
            }
            loc2 = _myLife.zone.zoneRenderClip;
            loc3 = new Position(loc2.mouseX, loc2.mouseY);
            setZzzStatus(false);
            if (!_character.isBusy())
            {
                loc4 = loc3.deltaPosition(_character.getPosition());
                if ((loc5 = Math.atan2(loc4.y, loc4.x) * 180 / 3.1415 + 180) < 90)
                {
                    loc6 = MyLifeInstance.LEFT_BACK;
                }
                else 
                {
                    if (loc5 < 180)
                    {
                        loc6 = MyLifeInstance.RIGHT_BACK;
                    }
                    else 
                    {
                        if (loc5 < 270)
                        {
                            loc6 = MyLifeInstance.RIGHT_FRONT;
                        }
                        else 
                        {
                            loc6 = MyLifeInstance.LEFT_FRONT;
                        }
                    }
                }
                if (loc6 != _currentMouseLookDirection)
                {
                    _character.changeDirection(loc6);
                    _currentMouseLookDirection = loc6;
                }
            }
            return;
        }

        public function getCoinBalance():Number
        {
            return _money;
        }

        private function getPlayerInfoError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;

            trace("getPlayerInfoError: Error Retrieving Player Info!");
            loc2 = _myLife._interface.showInterface("InputDialog", {"title":"Enter Your Description Here", "message":"Description (" + MAX_PLAYER_STATUS + " chars max):", "buttons":[{"name":"Save", "value":"BTN_OK"}, {"name":"Cancel", "value":"BTN_NO"}]});
            loc2.txtInputMessage.maxChars = MAX_PLAYER_STATUS;
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, editPlayerInfoResponse);
            _myLife.stage.focus = loc2.txtInputMessage;
            return;
        }

        public function savePlayerInfoErrorHandler(arg1:flash.events.IOErrorEvent):Boolean
        {
            var loc2:*;

            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Save Player Info", "message":"We encountered a problem while saving your player info. Error Code 03.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            return false;
        }

        public function getCashBalance():Number
        {
            return _cash;
        }

        private function onHungerThoughtTimerTick(arg1:flash.events.TimerEvent):void
        {
            setZzzStatus(false);
            _myLife.server.sendPublicMessage("E:25", 0);
            return;
        }

        
        {
            EnergyMeter = Player_EnergyMeter;
        }

        private static const ZZZ_IDLE_TIME_TRIGGER:Number=60 * 10;

        private static const DISCONNECT_IDLE_TIME_TRIGGER:Number=60 * 5;

        private static const ENERGY_DECREMENT_TIME:Number=288000;

        public static const MAX_PLAYER_STATUS:Number=128;

        private static const ENERGY_DECREMENT:Number=1;

        private static const HUNGER_THOUGHT_TIME:Number=608000;

        private var _modLevel:int=0;

        private var _idleZzzTimer:flash.utils.Timer;

        public var age:int;

        private var _updateDirectionTimer:flash.utils.Timer;

        private var _cash:Number=0;

        public var _badgeType:int=-1;

        private var _speedLevel:Number=0;

        private var _energyLevel:Number=0;

        public var _firstTime:String="0";

        public var showUseDialog:Boolean=true;

        public var _playerId:Number;

        public var _badgeLevel:int=-1;

        private var _speedLevelInt:int=0;

        private var _rawPlayerData:Object;

        public var isCostumesDisabled:Boolean;

        private var _lastServerUpdateDirection:int=-1;

        private var waitingToShowHungerBubble:Boolean=false;

        public var _locale:String="en-US";

        private var _energyLevelInt:int=0;

        private var _xp:int=-1;

        public var _character:MyLife.Character;

        private var _playerName:String;

        public var defaultHomePlayerItemId:int=0;

        private var _drinksLevel:Number=0;

        public var SHOW_BADGE:*;

        private var _zzzMode:Boolean=false;

        private var _money:Number=0;

        private var editMode:Boolean=false;

        private var _currentMouseLookDirection:int=-1;

        private var _idleDisconnectTimer:flash.utils.Timer;

        private var _useItemQueue:Array;

        private var linkTracker:MyLife.LinkTracker;

        public var _badgeId:int=-1;

        private var _gender:int;

        private var _drinksLevelInt:int=0;

        private var _detoxifyTimer:flash.utils.Timer;

        private var _myLife:flash.display.MovieClip;

        private var _currentClothing:Object;

        public var friendVisitsLeft:int=0;

        public var _firstTimeShowIntro:Boolean=false;

        public var isWalkable:Boolean=true;

        private var _energyDecrementTimer:flash.utils.Timer;

        private var hungerThoughtTimer:flash.utils.Timer;

        public static var EnergyMeter:Class;
    }
}
