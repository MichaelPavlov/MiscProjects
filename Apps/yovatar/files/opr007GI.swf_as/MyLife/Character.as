package MyLife 
{
    import MyLife.Events.*;
    import MyLife.Interfaces.*;
    import MyLife.NPC.*;
    import MyLife.Xp.*;
    import fai.*;
    import fl.motion.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import gs.*;
    
    public class Character extends MyLife.NPC.SimpleNPC
    {
        public function Character(arg1:flash.display.MovieClip=null, arg2:Boolean=false)
        {
            badgeList = [[], [], [], [], [], []];
            super(arg1);
            _playerCharacter = arg2;
            _characterTypingTimer = new Timer(5000, 1);
            _characterTypingTimer.addEventListener("timer", characterTypingTimerTick);
            nameShapeColor = 16777215;
            return;
        }

        private function confirmKickOutOfHomeDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = false;
            loc3 = null;
            loc4 = false;
            loc5 = null;
            loc6 = null;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = this._myLife.zone.isApartmentMode;
                loc3 = this._myLife._interface.interfaceHUD.mode;
                loc4 = Boolean(loc3 == "homeOwner");
                loc5 = String(this._myLife.zone.getApartmentOwnerPlayerId());
                loc6 = String(this._myLife.player._playerId);
                if (loc5 == loc6 && loc2 && loc4)
                {
                    _myLife.server.callExtension("kickUserFromRoom", {"target":serverUserId});
                }
            }
            return;
        }

        public function showPlayerInfo():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = {};
            loc1.selectedGender = _gender;
            loc1.selectedName = _characterName;
            loc1.selectedClothes = _currentClothing;
            loc1.selectedPlayerId = myLifePlayerId;
            loc1.selectedLevel = level;
            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("PlayerInfoWindow", loc1);
            loc2.setCharacterInstance(this);
            loc2.loadAvatarPreview();
            loc2.y = -loc2.height;
            loc2.x = 90;
            TweenLite.to(loc2, 0.75, {"y":130, "ease":Back.easeOut});
            popupCollection[serverUserId] = loc2;
            popupUserId.push(serverUserId);
            return;
        }

        internal function btnContextPlayTicTacToeClick():void
        {
            MyLifeTicTacToe.getInstance().sendNewGameRequest(serverUserId);
            return;
        }

        public function setXpAndLevel(arg1:int):void
        {
            setXp(arg1);
            if (XpManager.instance.isInitialized())
            {
                setLevel(XpManager.instance.getLevelFromXp(arg1).getLevel());
            }
            else 
            {
                XpManager.instance.addEventListener(XpManagerEvent.XP_MANAGER_INITIALIZED, setLevelHandler);
            }
            return;
        }

        private function initGameRequest(arg1:String, arg2:Number=0):void
        {
            var loc3:*;

            loc3 = NaN;
            this.gameRequestType = arg1;
            this.gameRequestCost = arg2;
            if (this.gameRequestCost)
            {
                loc3 = _myLife.player.getCoinBalance();
                if (loc3 >= this.gameRequestCost)
                {
                    this.checkCoinBalance();
                }
                else 
                {
                    _myLife._interface.showInterface("GenericDialog", {"title":"Not Enough Coins For This Game", "message":"This game cost " + this.gameRequestCost + " coins to play.  Please try again later after you have more coins."});
                }
            }
            else 
            {
                this.sendGameRequest();
            }
            return;
        }

        public function updateBadgeList(arg1:int, arg2:int):void
        {
            if (badgeList[arg1].length != arg2)
            {
                return;
            }
            badgeList[arg1].push(arg2);
            if (arg2 >= dispBadgeLevel)
            {
                renderDisplayBadge(arg1, arg2);
            }
            return;
        }

        public function characterIsTyping():void
        {
            if (!this._isBlocked)
            {
                _characterTyping = true;
                renderCharacterName();
                _characterTypingTimer.reset();
                _characterTypingTimer.start();
            }
            return;
        }

        public function set BadgeList(arg1:Array):void
        {
            badgeList = arg1;
            return;
        }

        public function resetPopupCollection():void
        {
            var loc1:*;

            popupCollection[serverUserId] = null;
            loc1 = 0;
            while (loc1 < popupUserId.length) 
            {
                if (popupUserId[loc1] == serverUserId)
                {
                    popupUserId.splice(loc1, 1);
                    break;
                }
                ++loc1;
            }
            return;
        }

        public override function sayMessage(arg1:*, arg2:Boolean=false):void
        {
            if (!this._isBlocked)
            {
                super.sayMessage(arg1, arg2);
                _characterTyping = false;
            }
            return;
        }

        internal function btnContextKickOutOfHomeClick():void
        {
            var loc1:*;

            loc1 = _myLife._interface.showInterface("GenericDialog", {"title":"Are You Sure?", "message":"Are you sure you want to kick this player out of your apartment?", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc1.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmKickOutOfHomeDialogResponse);
            return;
        }

        private function onCharacterClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc8 = false;
            arg1.stopPropagation();
            loc2 = arg1.currentTarget.parentCharacter;
            characterContextMenu = _myLife.getNewContextMenu();
            loc3 = {};
            if (loc4 = _myLife.zone.getCharacterName(loc2.serverUserId))
            {
                loc3.PLAYER_NAME = loc4;
            }
            if (_playerCharacter)
            {
                loc3.DEFAULTS = false;
                loc3.SELF_CLICK = true;
                loc3.EDIT_PLAYER_INFO = true;
                loc3.VIEW_BADGES = true;
            }
            else 
            {
                loc3.DEFAULTS = true;
                loc3.SELF_CLICK = false;
                loc3.VIEW_BADGES = true;
                if (!(loc8 = MyLifeInstance.getInstance().getInterface().interfaceHUD.buddyListViewer.isPlayerABuddy(myLifePlayerId)))
                {
                    loc3.ADD_BUDDY = true;
                }
                if (!_myLife._interface.interfaceHUD.btnGoHome.visible)
                {
                    if (loc2._modLevel <= _myLife.player.getModLevel())
                    {
                        loc3.KICK_FROM_HOME = true;
                    }
                }
                if (_myLife.player.getModLevel() > 0)
                {
                    loc3.IS_ADMIN = true;
                }
                loc3.GIVE_GIFT = true;
                if (_myLife.zone._apartmentMode)
                {
                    loc3.MAKE_TRADE = true;
                }
                else 
                {
                    loc3.MAKE_TRADE = false;
                }
                if (this._isBlocked)
                {
                    loc3.UNBLOCK_PLAYER = true;
                }
                else 
                {
                    loc3.BLOCK_PLAYER = true;
                }
            }
            characterContextMenu.Show(loc3);
            if (loc3.VIEW_BADGES)
            {
                characterContextMenu.achievementBadge.loadDisplayBadgeFromParams(dispBadgeType, dispBadgeLevel);
                characterContextMenu.achievementBadge.setPlayer(this);
            }
            _myLife.zone.addChild(characterContextMenu);
            loc5 = 25;
            loc6 = arg1.stageX - 10;
            loc7 = arg1.stageY - 54;
            if (loc6 < 5)
            {
                loc6 = 5;
            }
            if (loc6 > 500)
            {
                loc6 = 500;
            }
            if (loc7 < 71)
            {
                loc7 = 71;
            }
            if (loc7 - characterContextMenu.height < loc5)
            {
                loc7 = loc5 + characterContextMenu.height;
            }
            characterContextMenu.x = loc6;
            characterContextMenu.y = loc7;
            characterContextMenu.alpha = 0;
            TweenLite.to(characterContextMenu, 0.3, {"alpha":1});
            characterContextMenu.addEventListener(MouseEvent.ROLL_OUT, oncharacterContextMenuMouseOut);
            characterContextMenu.addEventListener(MyLifeEvent.CONTEXT_ITEM, onCharacterContextMenuSelectItem);
            return;
        }

        private function setCharacterSkew(arg1:Number):void
        {
            var loc2:*;

            loc2 = _renderClip.transform.matrix;
            MatrixTransformer.setSkewX(loc2, arg1);
            _renderClip.transform.matrix = loc2;
            return;
        }

        public function get DisplayBadge():Array
        {
            return [dispBadgeType, dispBadgeLevel];
        }

        internal function onCharacterContextMenuSelectItem(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            oncharacterContextMenuMouseOut({"currentTarget":characterContextMenu}, true);
            loc2 = arg1.eventData.value;
            switch (loc2) 
            {
                case "btnViewBadges":
                    (loc2 = _myLife["badgeManager"])["openBadgesWindow"](this);
                    characterContextMenu.achievementBadge.trackAction();
                    break;
                case "btnContextPlayTicTacToe":
                    btnContextPlayTicTacToeClick();
                    break;
                case "btnContextPlayRockPaperScissors":
                    btnContextPlayRockPaperScissorsClick();
                    break;
                case "btnContextVisitTheirHome":
                    btnContextVisitTheirHomeClick();
                    break;
                case "btnContextReportPlayer":
                    btnContextReportPlayerClick();
                    break;
                case "btnContextKickOutOfHome":
                    btnContextKickOutOfHomeClick();
                    break;
                case "btnContextKickBan":
                    btnContextKickBanClick();
                    break;
                case "btnContextSendAdminMsg":
                    btnContextSendAdminMsgClick();
                    break;
                case "btnContextSendPrivateMsg":
                    btnContextSendPrivateMsgClick();
                    break;
                case "btnContextGiveGift":
                    btnContextGiveGift();
                    break;
                case "btnContextMakeTrade":
                    btnContextMakeTradeClick();
                    break;
                case "btnContextReloadExtensions":
                    btnContextReloadExtensionsClick();
                    break;
                case "btnContextAddAsAFriend":
                    btnContextAddAsAFriendClick();
                    break;
                case "btnContextViewPlayerInfo":
                    btnContextViewPlayerInfo();
                    break;
                case "btnContextEditPlayerInfo":
                    btnContextEditPlayerInfo();
                    break;
                case "btnBlockPlayer":
                    btnBlockPlayer();
                    break;
                case "btnUnblockPlayer":
                    btnUnblockPlayer();
                    break;
                default:
                    break;
            }
            return;
        }

        private function sendGameRequest():void
        {
            var loc1:*;

            loc1 = this.gameRequestType;
            switch (loc1) 
            {
                case "TicTacToe":
                    MyLifeTicTacToe.getInstance().sendNewGameRequest(serverUserId);
                    break;
                case "RockPaperScissors":
                    MyLifeRockPaperScissors.getInstance().sendNewGameRequest(serverUserId);
                    break;
            }
            return;
        }

        private function checkCoinBalanceErrorHandler(arg1:flash.events.IOErrorEvent):void
        {
            return;
        }

        internal function btnContextVisitTheirHomeClick():void
        {
            MyLifeInstance.getInstance()._interface.showInterface("ViewHomes", {"playerId":myLifePlayerId});
            return;
        }

        private function btnUnblockPlayer():void
        {
            MyLifeBuddyRequest.getInstance().removeBlockedPlayer(this);
            return;
        }

        public function setModLevel(arg1:*):void
        {
            _modLevel = arg1;
            return;
        }

        private function btnContextMakeTradeClick():void
        {
            TradeManager.sendTradeInvite(this.serverUserId);
            return;
        }

        public override function doStop(arg1:Boolean=false):void
        {
            super.doStop(arg1);
            if (_playerCharacter && arg1)
            {
                trace("dispatching stop");
                _myLife.player.dispatchStopCharacterEvent();
            }
            _myLife.zone.resortDepths();
            return;
        }

        private function setLevelHandler(arg1:MyLife.Xp.XpManagerEvent):void
        {
            setLevel(XpManager.instance.getLevelFromXp(getXp()).getLevel());
            return;
        }

        internal function btnContextReloadExtensionsClick():void
        {
            _myLife.server.callExtension("sendAdminMessageToUser", {"target":serverUserId, "message":"CMD:EXT_RELOAD"});
            _myLife._interface.showInterface("GenericDialog", {"title":"Reload Java Extensions", "message":"All Java Extensions Have Been Reloaded.\nPlease Verify Log Files."});
            return;
        }

        public function renderDisplayBadge(arg1:int, arg2:int):void
        {
            dispBadgeType = arg1;
            dispBadgeLevel = arg2;
            if (achievementBadge)
            {
                achievementBadge.update();
            }
            return;
        }

        internal function btnContextPlayRockPaperScissorsClick():void
        {
            this.initGameRequest("RockPaperScissors", MyLifeRockPaperScissors.GAME_COST);
            return;
        }

        private function getNewInstanceFromClassName(arg1:String):Object
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
            catch (e:Error)
            {
            };
            return null;
        }

        private function btnContextGiveGift():void
        {
            var loc1:*;

            loc1 = {};
            loc1.giftData = {};
            loc1.giftData.senderName = this._myLife.player._character._characterName;
            loc1.giftData.recipientName = this._characterName;
            loc1.giftData.recipientPlayerId = this.myLifePlayerId;
            loc1.giftData.recipientServerUserId = this.serverUserId;
            this._myLife._interface.showInterface("GiftStepInventory", loc1);
            return;
        }

        internal function oncharacterContextMenuMouseOut(arg1:*, arg2:Boolean=false):void
        {
            var bypassMenuFade:Boolean=false;
            var event:*;
            var loc3:*;
            var loc4:*;

            event = arg1;
            bypassMenuFade = arg2;
            event.currentTarget.btnContextVisitTheirHome.removeEventListener(MouseEvent.CLICK, btnContextVisitTheirHomeClick);
            event.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, oncharacterContextMenuMouseOut);
            try
            {
                if (bypassMenuFade)
                {
                    removeZoneChild(event.currentTarget);
                }
                else 
                {
                    TweenLite.to(event.currentTarget, 0.3, {"alpha":0, "onComplete":removeZoneChild, "onCompleteParams":[event.currentTarget]});
                }
            }
            catch (e:Error)
            {
            };
            return;
        }

        protected override function onAvatarLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;

            loc2 = _renderClip.avatarClip;
            loc2.addEventListener(MouseEvent.CLICK, onCharacterClick);
            super.onAvatarLoaded(arg1);
            return;
        }

        public function isPlayerCharacter():Boolean
        {
            return _playerCharacter;
        }

        private function skewCharacter(arg1:*, arg2:Object):void
        {
            if (_drunkSkewMax <= 1)
            {
                _drunkSkewMax = 0;
                return;
            }
            if (arg1 != 1)
            {
                TweenLite.to(arg2, 5, {"xSkew":-_drunkSkewMax, "ease":Linear.easeInOut, "onUpdate":skewUpdateFunction, "onUpdateParams":[arg2], "onComplete":skewCharacter, "onCompleteParams":[1, arg2]});
            }
            else 
            {
                TweenLite.to(arg2, 5, {"xSkew":_drunkSkewMax, "ease":Linear.easeInOut, "onUpdate":skewUpdateFunction, "onUpdateParams":[arg2], "onComplete":skewCharacter, "onCompleteParams":[2, arg2]});
            }
            return;
        }

        public function setXp(arg1:int):void
        {
            this.xp = arg1;
            return;
        }

        public function setZzzStatus(arg1:Boolean):void
        {
            if (_renderClip && _renderClip.avatarClip && _renderClip.avatarClip.setZzzStatus)
            {
                _renderClip.avatarClip.setZzzStatus(arg1);
            }
            return;
        }

        private function removeZoneChild(arg1:flash.display.MovieClip):void
        {
            arg1.destroy();
            _myLife.zone.removeChild(arg1);
            return;
        }

        private function reportMessageInputResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (arg1.eventData.userResponse == "BTN_OK")
            {
                loc3 = StringUtils.trim(arg1.eventData.inputText);
                if (loc3 != "")
                {
                    _myLife.server.callExtension("reportUser", {"target":serverUserId, "message":loc3});
                    _myLife._interface.showInterface("GenericDialog", {"title":"Report Sent Successfully", "message":"Your report for offensive behavior has been sent.\nThank you for your help."});
                }
                else 
                {
                    _myLife._interface.showInterface("GenericDialog", {"title":"Missing Required Field", "message":"In order to report a user, you must provide an accurate reason.  Please try again."});
                }
            }
            return;
        }

        public function get BadgeList():Array
        {
            return badgeList;
        }

        public function setDrunkLevel(arg1:Number):void
        {
            var loc2:*;

            loc2 = Math.sqrt(arg1);
            if (_drunkSkewMax <= 0)
            {
                if (loc2 > 1)
                {
                    startSkewCharacter(loc2);
                }
            }
            else 
            {
                _drunkSkewMax = loc2;
            }
            return;
        }

        public function set isBlocked(arg1:Boolean):void
        {
            this._isBlocked = arg1;
            if (this._isBlocked)
            {
                this._renderClip.alpha = 0.5;
            }
            else 
            {
                this._renderClip.alpha = 1;
            }
            return;
        }

        private function confirmKickAndBanDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                _myLife.server.callExtension("kickUser", {"target":serverUserId});
            }
            return;
        }

        internal function btnContextSendPrivateMsgClick():void
        {
            _myLife.player.sendPrivateMessage(serverUserId);
            return;
        }

        internal function btnContextAddAsAFriendClick():void
        {
            var loc1:*;

            loc1 = MyLifeInstance.getInstance().getInterface().interfaceHUD.buddyListViewer.isPlayerABuddy(myLifePlayerId);
            if (!loc1)
            {
                MyLifeBuddyRequest.getInstance().sendNewBuddyRequest(serverUserId);
            }
            return;
        }

        public function setLevel(arg1:int):void
        {
            this.level = arg1;
            return;
        }

        private function btnBlockPlayer():void
        {
            MyLifeBuddyRequest.getInstance().addBlockedPlayer(this);
            return;
        }

        public override function highlightCharacter(arg1:*, arg2:Boolean):void
        {
            super.highlightCharacter(arg1, arg2);
            this.highlighted = arg2;
            return;
        }

        private function btnContextViewPlayerInfo():void
        {
            if (popupCollection[serverUserId])
            {
                return;
            }
            showPlayerInfo();
            return;
        }

        internal function btnContextSendAdminMsgClick():void
        {
            _myLife.player.sendAdminMessage(serverUserId);
            return;
        }

        public override function cleanUp():void
        {
            if (characterContextMenu)
            {
                oncharacterContextMenuMouseOut({"currentTarget":characterContextMenu}, true);
            }
            super.cleanUp();
            return;
        }

        public function getLevel():int
        {
            return level;
        }

        internal function btnContextReportPlayerClick():void
        {
            var loc1:*;

            loc1 = _myLife._interface.showInterface("InputDialog", {"title":"Enter Your Reason For Reporting", "message":"Please Provide A Reason For Reporting This User:", "buttons":[{"name":"Send", "value":"BTN_OK"}, {"name":"Cancel", "value":"BTN_NO"}]});
            loc1.addEventListener(MyLifeEvent.DIALOG_RESPONSE, reportMessageInputResponse);
            _myLife.stage.focus = loc1.txtInputMessage;
            return;
        }

        protected override function getNameTagItems():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc2 = undefined;
            loc1 = new Array();
            if (_characterTyping)
            {
                loc2 = getNewInstanceFromClassName("TypingAnimation");
                if (loc2)
                {
                    loc1.push(loc2);
                }
            }
            else 
            {
                if (achievementBadge && !(dispBadgeType == -1))
                {
                    loc1.push(achievementBadge);
                }
            }
            loc1.push(this.getNameTagTextField());
            if (_modLevel > 0)
            {
                loc3 = _modLevel;
                switch (loc3) 
                {
                    case 10:
                        loc1.push(getModBadge(1));
                        break;
                    case 50:
                        loc1.push(getModBadge(2));
                        break;
                    default:
                        loc1.push(getModBadge(3));
                        break;
                }
            }
            return loc1;
        }

        private function characterTypingTimerTick(arg1:flash.events.TimerEvent):void
        {
            _characterTyping = false;
            renderCharacterName();
            _characterTypingTimer.reset();
            return;
        }

        private function skewUpdateFunction(arg1:Object):void
        {
            setCharacterSkew(arg1.xSkew);
            return;
        }

        private function btnContextEditPlayerInfo():void
        {
            _myLife.player.editPlayerInfo();
            return;
        }

        private function checkCoinBalanceCompleteHandler(arg1:flash.events.Event):void
        {
            this.coinBalance = Number(arg1.target.data);
            if (this.coinBalance >= this.gameRequestCost)
            {
                this.sendGameRequest();
            }
            else 
            {
                _myLife._interface.showInterface("GenericDialog", {"title":"Your Opponent Does Not Have Enough Coins", "message":"Your opponent does not have the " + this.gameRequestCost + " coins required to play this game. Please try challenging a different player."});
            }
            return;
        }

        private function checkCoinBalance():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
            loc2 = loc1 + "get_balance.php?pid=" + myLifePlayerId + "&r=" + Math.random();
            loc3 = new URLRequest(loc2);
            (loc4 = new URLLoader()).addEventListener(Event.COMPLETE, checkCoinBalanceCompleteHandler);
            loc4.addEventListener(IOErrorEvent.IO_ERROR, checkCoinBalanceErrorHandler);
            loc4.load(loc3);
            return;
        }

        public function getXp():int
        {
            return xp;
        }

        internal function btnContextKickBanClick():void
        {
            var loc1:*;

            loc1 = _myLife._interface.showInterface("GenericDialog", {"title":"Are You Sure?", "message":"Are you sure you want to ban this player?", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc1.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmKickAndBanDialogResponse);
            return;
        }

        public override function setCharacterProperties(arg1:*, arg2:int, arg3:String=""):void
        {
            super.setCharacterProperties(arg1, arg2, arg3);
            if (_myLife.player.SHOW_BADGE)
            {
                achievementBadge = new AchievementBadge(this, -1, -1, -1, null, true, false, 16768000, 0.9);
            }
            return;
        }

        public function renderDisplayBadgeFromId(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = BadgeManager.instance.getBadgeTypeFromId(arg1);
            loc3 = BadgeManager.instance.getBadgeLevelFromId(arg1);
            renderDisplayBadge(loc2, loc3);
            return;
        }

        private function startSkewCharacter(arg1:Number):void
        {
            var loc2:*;

            _drunkSkewMax = arg1;
            loc2 = {"xSkew":0};
            TweenLite.to(loc2, 2.5, {"xSkew":_drunkSkewMax, "ease":Linear.easeOut, "onUpdate":skewUpdateFunction, "onUpdateParams":[loc2], "onComplete":skewCharacter, "onCompleteParams":[2, loc2]});
            return;
        }

        public static function closeAllPopupCollection():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = 0;
            loc2 = undefined;
            if (Character.popupUserId != null)
            {
                loc1 = 0;
                while (loc1 < Character.popupUserId.length) 
                {
                    loc2 = Character.popupCollection[Character.popupUserId[loc1]];
                    if (loc2 != null)
                    {
                        MyLifeInstance.getInstance().getInterface().unloadInterface(loc2);
                    }
                    Character.popupCollection[Character.popupUserId[loc1]] = null;
                    ++loc1;
                }
                Character.popupUserId.splice(0);
            }
            return;
        }

        
        {
            popupCollection = new Array();
            popupUserId = new Array();
        }

        public var _modLevel:int=0;

        private var _characterTypingTimer:flash.utils.Timer;

        private var _playerCharacter:Boolean=false;

        public var coinBalance:Number=0;

        private var level:int=-1;

        private var _drunkSkewMax:Number=0;

        private var gameRequestType:String;

        private var gameRequestCost:Number;

        private var achievementBadge:MyLife.Interfaces.AchievementBadge;

        private var _characterTyping:Boolean=false;

        private var characterContextMenu:flash.display.MovieClip;

        private var highlighted:Boolean=false;

        private var badgeList:Array;

        private var dispBadgeLevel:int=-1;

        private var _isBlocked:Boolean=false;

        public var freeActions:Boolean=false;

        private var xp:int=-1;

        private var dispBadgeType:int=-1;

        public static var popupCollection:Array;

        public static var popupUserId:Array;
    }
}
