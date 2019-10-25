package MyLife 
{
    import MyLife.Events.*;
    import MyLife.FB.*;
    import MyLife.FB.Objects.*;
    import MyLife.Games.*;
    import MyLife.NPC.*;
    import MyLife.Utils.*;
    import MyLife.Xp.*;
    import com.adobe.serialization.json.*;
    import fai.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import it.gotoandplay.smartfoxserver.*;
    import it.gotoandplay.smartfoxserver.data.*;
    
    public class Zone extends flash.display.MovieClip
    {
        public function Zone(arg1:MyLife.MyLife)
        {
            _eventQueue = [];
            super();
            _myLife = arg1;
            _myLife.addChildAt(this, 0);
            if (!_myLife.runningLocal)
            {
                _assetVersionParam = "?v=" + MyLifeConfiguration.version;
            }
            this.y = 60;
            _collisionPath = new CollisionPath(_myLife);
            _myLife._interface.addEventListener(MyLifeEvent.DO_GO_HOME, onDoGoHome);
            _myLife._interface.interfaceHUD.mapWorldSelector.addEventListener(MyLifeEvent.JOIN_ZONE, onRequestJoinZone);
            _myLife.getServer().addEventListener(MyLifeEvent.ROOM_RATING_UPDATE, roomRatingUpdate);
            _myLife.getServer().addEventListener(MyLifeEvent.NOTIFICATION_SUCCESS, giveReward);
            this.zoneItemManager = new ZoneItemManager();
            this.asyncVisitManager = AsyncVisitManager.instance;
            this.npcManager = NPCManager.instance;
            _teleportArray = new Array();
            charactersWaitingToEnterZone = new Object();
            _levelingItemManager = LevelingItemManager.instance;
            return;
        }

        public function kickFromApartment():void
        {
            _myLife._interface.showInterface("GenericDialog", {"title":"You Were Kicked Out", "message":"You were kicked out of the room by it\'s owner."});
            this.join("CondoExterior");
            return;
        }

        private function processUpdateRoomRequest(arg1:*, arg2:*):Boolean
        {
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

            loc5 = undefined;
            loc6 = undefined;
            loc7 = 0;
            loc8 = 0;
            loc9 = undefined;
            loc3 = true;
            loc4 = false;
            loc10 = 0;
            loc11 = arg2;
            label616: for each (loc5 in loc11)
            {
                loc12 = loc5.action;
                switch (loc12) 
                {
                    case "HIDE_ITEM":
                        arg1.visible = false;
                        continue label616;
                    case "REMOVE_ITEM":
                        if (zoneRenderClip && zoneRenderClip.contains(loc5.item))
                        {
                            zoneRenderClip.removeChild(loc5.item);
                            if ((loc7 = renderLayerCollection.indexOf(loc5.item)) >= 0)
                            {
                                renderLayerCollection.splice(loc7, 1);
                            }
                        }
                        zoneItemManager.removeItem(loc5.item);
                        if (_zoneMovie.hasOwnProperty("furnitureItemCollection"))
                        {
                            loc8 = _zoneMovie.furnitureItemCollection.length;
                            while (loc8) 
                            {
                                if ((loc9 = _zoneMovie.furnitureItemCollection.shift()).playerItemId != loc5.item.playerItemId)
                                {
                                };
                                _zoneMovie.furnitureItemCollection.push(loc9);
                                loc8 = (loc8 - 1);
                            }
                        }
                        loc4 = loc4 ? loc4 : !loc5.item.itemData.isProp;
                        loc5.item.removeEventListener(ObjectEvent.OBJECT_REQUEST_EVENT, objectEventHandler);
                        continue label616;
                    case "ADD_ITEM":
                        if (loc5.hasOwnProperty("x"))
                        {
                            loc5.item.x = loc5.x;
                        }
                        if (loc5.hasOwnProperty("y"))
                        {
                            loc5.item.y = loc5.y;
                        }
                        if ((loc6 = loc5.item) as DisplayObject == null && _zoneMovie.hasOwnProperty("addFurnitureItemToRoom"))
                        {
                            loc6 = _zoneMovie.addFurnitureItemToRoom(loc5.item, zoneRenderClip);
                            loc4 = loc4 ? loc4 : !loc5.item.itemData.isProp;
                            if (_zoneMovie.hasOwnProperty("furnitureItemCollection"))
                            {
                                _zoneMovie.furnitureItemCollection.push(loc5.item);
                            }
                        }
                        if (loc6 as DisplayObject)
                        {
                            zoneItemManager.addItem(loc6);
                            renderLayerCollection.push(loc6);
                            if (!editMode && loc6.hasOwnProperty("activate"))
                            {
                                loc6.activate();
                            }
                            else 
                            {
                                loc6.isProp = true;
                            }
                            resortDepths();
                        }
                        continue label616;
                }
            }
            if (loc4)
            {
                if (_zoneMovie.hasOwnProperty("refreshCollision"))
                {
                    _zoneMovie.refreshCollision(zoneRenderClip);
                    generateCollisionPaths();
                }
            }
            return loc3;
        }

        private function onPlayerActivated(arg1:MyLife.MyLifeEvent):void
        {
            _myLife.server.removeEventListener(MyLifeEvent.PLAYER_ACTIVATED, onPlayerActivated);
            this.continueJoin();
            return;
        }

        private function joinNewRoom():void
        {
            trace("joinNewRoom()");
            _myLife.server.joinZone(_zoneName);
            _myLife.server.addEventListener(MyLifeEvent.JOIN_SUCCESS, onJoinRoomSuccess);
            return;
        }

        public function resetApartmentRating():void
        {
            this._myLife.server.callExtension("PlayerRoom.resetRoomRating", {"lk":_myLife.getConfiguration().variables["querystring"]["lk"], "room":this.getCurrentZoneName(), "playerHomeRoomId":this.currentPlayerHomeRoomId});
            return;
        }

        public function deleteEventCompleteHandler(arg1:flash.events.Event):void
        {
            return;
        }

        public function addTriggerZone(arg1:flash.display.DisplayObject):void
        {
            if (_triggerZones)
            {
                this._triggerZones.push(arg1);
            }
            return;
        }

        private function objectEventHandler(arg1:MyLife.Events.ObjectEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = false;
            loc3 = arg1.oeType;
            switch (loc3) 
            {
                case ObjectEvent.OETYPE_UPDATE_ROOM:
                    loc2 = processUpdateRoomRequest(arg1.currentTarget, arg1.eventData);
                    break;
                case ObjectEvent.OETYPE_SAVE_ROOM:
                    loc2 = true;
                    processSaveRoomRequest();
                    break;
            }
            if (!loc2 && _zoneMovie && _zoneMovie.hasOwnProperty("objectEventHandler"))
            {
                loc2 = _zoneMovie.objectEventHandler(arg1);
            }
            if (!loc2)
            {
                dispatchEvent(arg1);
            }
            return;
        }

        public function rateApartment(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = undefined;
            loc3 = null;
            if (this.currentOwnerPlayerId == _myLife._selectedPlayerId || this.currentOwnerPlayerId == 0)
            {
                _myLife._interface.showInterface("GenericDialog", {"title":"Room Rating Error", "message":"Sorry, you cannot rate your own room.", "buttons":[{"name":"Ok", "value":"BTN_YES"}]});
            }
            else 
            {
                if (this.currentPlayerHomeRoomId)
                {
                    loc2 = 0;
                }
                else 
                {
                    loc2 = this.getCurrentZoneName();
                }
                loc3 = _myLife.getConfiguration().variables["querystring"]["lk"];
                _myLife.server.callExtension("PlayerRoom.processRating", {"room":loc2, "owner_player_id":getApartmentOwnerPlayerId(), "playerHomeRoomId":this.currentPlayerHomeRoomId, "lk":loc3, "rating":arg1});
                _myLife._interface.interfaceHUD.toggleRoomRatings(true);
            }
            return;
        }

        private function loadPlayersAndItems():void
        {
            var character:MyLife.NPC.SimpleNPC;
            var default_room:String;
            var errorJoinRoomDialog:flash.display.DisplayObject;
            var isReplay:Boolean;
            var layer:flash.display.DisplayObject;
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var playAction:Number;
            var playerActionSender:Number;
            var tracker:MyLife.LinkTracker;

            playerActionSender = NaN;
            character = null;
            layer = null;
            default_room = null;
            tracker = null;
            playAction = NaN;
            isReplay = false;
            errorJoinRoomDialog = null;
            try
            {
                if (_gameMode)
                {
                    _myLife._interface.interfaceHUD.TickerBar.visible = false;
                    _myLife._interface.interfaceHUD.ChatBarMask.visible = true;
                    _myLife._interface.interfaceHUD.chatWindowHistory.visible = false;
                }
                else 
                {
                    _myLife._interface.interfaceHUD.TickerBar.visible = true;
                    _myLife._interface.interfaceHUD.ChatBarMask.visible = false;
                    if (_myLife._interface.interfaceHUD.chatWindowHistory)
                    {
                        _myLife._interface.interfaceHUD.chatWindowHistory.visible = true;
                    }
                    setupCharacters();
                    _mainCharacterClip.visible = true;
                    loc2 = 0;
                    loc3 = characterCollection;
                    for each (character in loc3)
                    {
                        if (!character)
                        {
                            continue;
                        }
                        character.visible = true;
                    }
                    loc2 = 0;
                    loc3 = renderLayerCollection;
                    for each (layer in loc3)
                    {
                        if (!layer)
                        {
                            continue;
                        }
                        layer.visible = true;
                    }
                }
                _myLife._interface.friendLadder.visible = true;
                _myLife._interface.show();
                _myLife.loadingStatus.hide();
                _zoneMovie.visible = true;
                if (_zoneMovie.hasOwnProperty("activate"))
                {
                    _zoneMovie.activate();
                }
                if (_myLife.player._firstTimeShowIntro)
                {
                    _myLife.player._firstTimeShowIntro = false;
                    playerActionSender = Number(MyLifeConfiguration.getInstance().variables["querystring"]["play_action_sender"]);
                    default_room = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["default_room"];
                    if (playerActionSender && default_room == "FactoryInterior")
                    {
                        tracker = new LinkTracker();
                        tracker.isActive = true;
                        tracker.track("2790", "555");
                        MyLifeConfiguration.getInstance().variables["querystring"]["play_action_sender"] = 0;
                        _myLife.server.addEventListener(FactoryEvent.HELP_REQUEST_HELP, helpRequestHelpResponse);
                        _myLife.server.callExtension("FactoryManager.helpPlayerWork", {"requesterId":playerActionSender});
                    }
                    else 
                    {
                        startTutorial();
                    }
                    _tutorialActive = true;
                    _tutorialAB = true;
                }
                else 
                {
                    playAction = Number(_myLife.myLifeConfiguration.variables["querystring"]["play_action_type"]);
                    playerActionSender = Number(_myLife.myLifeConfiguration.variables["querystring"]["play_action_sender"]);
                    isReplay = Boolean(playAction && playerActionSender);
                    if (isReplay)
                    {
                        _myLife.myLifeConfiguration.variables["querystring"]["play_action_type"] = 0;
                        _myLife.myLifeConfiguration.variables["querystring"]["play_action_sender"] = 0;
                    }
                    if (!isReplay && !_tutorialActive)
                    {
                        if (isOwner && _myLife.player._firstTime == "0")
                        {
                            _myLife.displayStartUpDialogs();
                        }
                        if (!_tutorialAB)
                        {
                            _myLife.startMissions();
                        }
                    }
                }
                firstApartmentTour = false;
                this.zoneItemManager.activateItems();
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.JOIN_ROOM_COMPLETE));
            }
            catch (e:*)
            {
                trace(undefined);
                errorJoinRoomDialog = _myLife._interface.showInterface("GenericDialog", {"title":"There Was A Problem Joining The Room", "message":"There was a problem trying to join the new room.  This problem has been logged.\nWe will instead send you to the Condo Exterior."});
                errorJoinRoomDialog.addEventListener(MyLifeEvent.DIALOG_RESPONSE, errorJoinRoomDialogResponse);
                ExceptionLogger.logException("onJoinRoomSuccess: " + undefined.toString(), "v1.2 Problem Joining New Room.");
            }
            return;
        }

        public function getCurrentPlayerHomeRoomId():int
        {
            return 0;
        }

        public function setApartmentLock(arg1:Boolean):void
        {
            var loc2:*;

            loc2 = undefined;
            if (arg1)
            {
                if (this._myEventData)
                {
                    loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Locking Door Confirmation", "message":"Locking your home will automatically close your event. Proceed with locking?", "buttons":[{"name":"Cancel", "value":"BTN_NO"}, {"name":"Ok", "value":"BTN_YES"}]});
                    loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmEndEventDialogResponse);
                    return;
                }
            }
            updateLockStatus(arg1);
            return;
        }

        public function resortDepthsViaDepth():void
        {
            var blockX:Number;
            var blockY:Number;
            var char:*;
            var character:MyLife.NPC.SimpleNPC;
            var characterList:Array;
            var col:int;
            var collisionBlocks:Array;
            var collision_block:flash.display.DisplayObject;
            var depthMap:Array;
            var depthOffset:Number;
            var depthSort:MyLife.DepthSort;
            var hit1:Boolean;
            var hit2:Boolean;
            var i:int;
            var inactivePropItem:*;
            var isProp:Boolean;
            var isoPos:fai.Position;
            var item:flash.display.MovieClip;
            var itemCollection:Array;
            var itemIndex:int;
            var itemList:Array;
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var mapHeight:int;
            var mapWidth:int;
            var mc:flash.display.MovieClip;
            var myCharacter:MyLife.Character;
            var propItem:*;
            var propList:Array;
            var row:int;
            var sortItem:*;
            var sortOrder:Array;
            var sortedItem:flash.display.MovieClip;
            var sortedItemIndex:int;
            var sortedItems:Array;
            var speechBubble:flash.display.MovieClip;
            var xyPos:fai.Position;

            character = null;
            myCharacter = null;
            isoPos = null;
            xyPos = null;
            col = 0;
            item = null;
            depthSort = null;
            sortOrder = null;
            depthOffset = NaN;
            sortItem = undefined;
            propItem = undefined;
            sortedItem = null;
            sortedItemIndex = 0;
            speechBubble = null;
            i = 0;
            isProp = false;
            collisionBlocks = null;
            blockX = NaN;
            blockY = NaN;
            collision_block = null;
            inactivePropItem = undefined;
            char = undefined;
            hit1 = false;
            hit2 = false;
            characterList = [];
            itemList = [];
            propList = [];
            mc = zoneRenderClip;
            sortedItems = DisplayObjectContainerUtils.getChildren(mc);
            loc2 = 0;
            loc3 = this.characterCollection;
            for each (character in loc3)
            {
                if (!(character && !(character.parent == mc)))
                {
                    continue;
                }
                sortedItems.push(character);
            }
            myCharacter = this._myLife.getPlayer().getCharacter();
            if (myCharacter.parent != mc)
            {
                sortedItems.push(myCharacter);
            }
            sortedItems.sortOn("y", Array.NUMERIC);
            mapWidth = this.currentGridLength;
            mapHeight = this.currentGridLength;
            itemIndex = 0;
            itemCollection = [];
            depthMap = [];
            row = mapHeight;
            for (;;) 
            {
                row = ((row) - 1);
                if (!row)
                {
                    break;
                }
                depthMap[row] = [];
                col = mapWidth;
                for (;;) 
                {
                    col = ((col) - 1);
                    if (!col)
                    {
                        break;
                    }
                    depthMap[row][col] = "";
                }
            }
            loc2 = 0;
            loc3 = sortedItems;
            for each (item in loc3)
            {
                isProp = false;
                try
                {
                    isProp = item.itemData.isProp;
                }
                catch (error:Error)
                {
                    isProp = false;
                }
                if (item.name == "TransportButtons")
                {
                    isProp = true;
                }
                if (!isProp)
                {
                    collisionBlocks = getMovieChildrenFloorBlocks(item);
                    if (collisionBlocks.length > 0)
                    {
                        blockX = 0;
                        blockY = 0;
                        itemIndex = (itemIndex + 1);
                        itemCollection[itemIndex] = item;
                        loc4 = 0;
                        loc5 = collisionBlocks;
                        for each (collision_block in loc5)
                        {
                            isoPos = new Position(collision_block.x * item.scaleX + item.x, collision_block.y + item.y);
                            xyPos = transformIsoToXy(isoPos);
                            xyPos.x = Math.round(xyPos.x);
                            xyPos.y = Math.round(xyPos.y);
                            if (!(xyPos && xyPos.x && xyPos.y))
                            {
                                continue;
                            }
                            if (!depthMap[xyPos.y])
                            {
                                continue;
                            }
                            if (depthMap[xyPos.y][xyPos.x] == "")
                            {
                                depthMap[xyPos.y][xyPos.x] = itemIndex;
                                continue;
                            }
                            depthMap[xyPos.y][xyPos.x] = depthMap[xyPos.y][xyPos.x] + "_" + itemIndex;
                        }
                        itemList.push(item);
                    }
                    else 
                    {
                        isoPos = new Position(item.x, item.y);
                        xyPos = transformIsoToXy(isoPos);
                        xyPos.x = Math.round(xyPos.x);
                        xyPos.y = Math.round(xyPos.y);
                        itemIndex = (itemIndex + 1);
                        itemCollection[itemIndex] = item;
                        if (xyPos.y >= 0 && xyPos.y < depthMap.length && xyPos.x >= 0 && xyPos.x < depthMap[xyPos.y].length)
                        {
                            depthMap[xyPos.y][xyPos.x] = itemIndex;
                        }
                        characterList.push(item);
                    }
                    continue;
                }
                propList.push(item);
                item.depth_value = Math.floor(item.y * 1000);
            }
            depthSort = new DepthSort();
            depthSort.initDepthMap(mapWidth, mapHeight, depthMap);
            sortOrder = depthSort.calcSortOrder();
            depthOffset = 10000;
            loc2 = 0;
            loc3 = sortOrder;
            for each (sortItem in loc3)
            {
                depthOffset = (depthOffset - 1);
                itemCollection[Math.round(sortItem)].depth_value = depthOffset * 2000;
            }
            loc2 = 0;
            loc3 = propList;
            for each (propItem in loc3)
            {
                if (propItem.name == "TransportButtons")
                {
                    propItem.depth_value = 99999999999;
                    continue;
                }
                if (propItem.itemData.isInactive)
                {
                    continue;
                }
                loc4 = 0;
                loc5 = propList;
                for each (inactivePropItem in loc5)
                {
                    if (!(!(inactivePropItem.name == "TransportButtons") && inactivePropItem.itemData.isInactive))
                    {
                        continue;
                    }
                    if (!(propItem.depth_value < inactivePropItem.depth_value))
                    {
                        continue;
                    }
                    propItem.depth_value = inactivePropItem.depth_value + propItem.y;
                }
                loc4 = 0;
                loc5 = characterList;
                for each (char in loc5)
                {
                    if (!(propItem.y > char.y))
                    {
                        continue;
                    }
                    propItem.depth_value = char.depth_value + propItem.y;
                }
                loc4 = 0;
                loc5 = itemList;
                for each (item in loc5)
                {
                    hit1 = fastHitTest(item.hitZone, propItem.x, propItem.y);
                    hit2 = false;
                    if (!hit1)
                    {
                        hit2 = fastHitTest(item.hitZone, propItem.x, propItem.y - propItem.height);
                    }
                    if (!(hit1 || hit2))
                    {
                        continue;
                    }
                    propItem.depth_value = item.depth_value + propItem.y;
                }
            }
            sortedItems.sortOn("depth_value", Array.NUMERIC);
            i = sortedItems.length;
            for (;;) 
            {
                i = ((i) - 1);
                if (!i)
                {
                    break;
                }
                sortedItem = sortedItems[i];
                if (!sortedItem.parent)
                {
                    continue;
                }
                sortedItem.parent.setChildIndex(sortedItem, 0);
                if (!sortedItem.hasOwnProperty("getSpeechBubble"))
                {
                    continue;
                }
                speechBubble = sortedItem.getSpeechBubble();
                if (!(speechBubble && speechBubble.parent == this.speechBubbleRenderClip))
                {
                    continue;
                }
                this.speechBubbleRenderClip.setChildIndex(speechBubble, 0);
            }
            return;
        }

        public function addMainCharacterClip(arg1:MyLife.Character):void
        {
            var loc2:*;

            _mainCharacterClip = arg1;
            arg1.visible = false;
            zoneRenderClip.addChild(arg1);
            loc2 = arg1.getSpeechBubble() as MovieClip;
            this.speechBubbleRenderClip.addChild(loc2);
            if (!arg1.activate())
            {
                arg1.doAvatarAction("0");
            }
            trace("addMainCharacterClip this.speechBubbleRenderClip.numChildren = " + this.speechBubbleRenderClip.numChildren);
            return;
        }

        private function detectEventTimeoutHandler():void
        {
            loadPlayersAndItems();
            return;
        }

        private function setDrunkLevel(arg1:Number):void
        {
            if (arg1 <= 0.11)
            {
                this.filters = [];
            }
            else 
            {
                this.filters = [new BlurFilter(arg1, arg1, BitmapFilterQuality.LOW)];
            }
            return;
        }

        public function getCurrentInstanceId():String
        {
            return MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
        }

        public function resetTeleportId():void
        {
            this.joinTeleportId = null;
            return;
        }

        private function errorJoinRoomDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse == "BTN_OK")
            {
                join("CondoExterior");
            }
            return;
        }

        private function showAllItemsInZone(arg1:Boolean=true):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc4 = 0;
            loc5 = characterCollection;
            for each (loc2 in loc5)
            {
                if (!loc2)
                {
                    continue;
                }
                loc2.visible = arg1;
            }
            if (_mainCharacterClip)
            {
                _mainCharacterClip.visible = arg1;
            }
            loc4 = 0;
            loc5 = renderLayerCollection;
            for each (loc3 in loc5)
            {
                if (!loc3)
                {
                    continue;
                }
                loc3.visible = arg1;
            }
            return;
        }

        private function removeAllCharactersFromZone():void
        {
            var character:MyLife.NPC.SimpleNPC;
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            character = null;
            loc2 = 0;
            loc3 = characterCollection;
            for each (character in loc3)
            {
                if (!character)
                {
                    continue;
                }
            }
            characterCollection = {};
            _characterCount = 0;
            return;
        }

        public function findAvailablePosition(arg1:Function=null, arg2:int=1000, arg3:Number=65, arg4:Number=100, arg5:Number=590, arg6:Number=400):fai.Position
        {
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;

            loc7 = null;
            loc8 = null;
            loc12 = false;
            loc13 = 0;
            loc14 = 0;
            loc9 = this._collisionPath.mapMatrix.h;
            loc10 = this._collisionPath.mapMatrix.v;
            loc11 = 1;
            while (loc11 || arg2--) 
            {
                loc13 = Math.floor(Math.random() * (loc10 - 1));
                loc14 = Math.floor(Math.random() * (loc9 - 1));
                if (loc11 = this._collisionPath.mapMatrix.getxy(loc13, loc14))
                {
                    continue;
                }
                loc8 = new Position(loc13, loc14);
                if ((loc7 = this.transformXyToIso(loc8)).x >= arg3 && loc7.x <= arg5 && loc7.y >= arg4 && loc7.y <= arg6)
                {
                    loc12 = (arg1 == null) ? checkValidPlayerMove(loc7.x, loc7.y) : arg1(loc7.x, loc7.y);
                }
                if (!loc12)
                {
                    loc11 = 1;
                    continue;
                }
                arg2 = 0;
            }
            if (loc11 || !loc12)
            {
                loc7 = null;
            }
            trace("\t\tisoPos = " + loc7);
            return loc7;
        }

        private function addLoadedCharacterToZone(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            trace("ADD LOADED CHARACTER TO ZONE");
            loc2 = this.charactersWaitingToEnterZone[arg1];
            loc3 = loc2.loadedCharacter;
            loc3.setModLevel(loc2.player.mod_level);
            loc3.visible = true;
            loc3.isBlocked = this._myLife.getInterface().interfaceHUD.buddyListViewer.checkIfPlayerBlocked(loc2.player.playerId);
            loc3.renderCharacterName();
            if (loc2.player.hasOwnProperty("badgeType") && loc2.player.hasOwnProperty("badgeLevel") && !(loc2.player.badgeType == null) && !(loc2.player.badgeLevel == null))
            {
                loc3.renderDisplayBadge(loc2.player.badgeType, loc2.player.badgeLevel);
            }
            else 
            {
                if (loc2.player.hasOwnProperty("badgeId"))
                {
                    loc3.renderDisplayBadgeFromId(loc2.player.badgeId);
                }
                else 
                {
                    loc3.renderDisplayBadge(-1, -1);
                }
            }
            if (loc2.hasOwnProperty("xp"))
            {
                loc3.setXpAndLevel(loc2.xp);
            }
            trace("characterCollection[" + loc2.serverUserId + "] = " + loc3);
            characterCollection[loc2.serverUserId] = loc3;
            if (loc2.properties)
            {
                if (loc2.properties as String)
                {
                    loc2.properties = JSON.decode(loc2.properties);
                }
                loc6 = 0;
                loc7 = loc2.properties;
                label509: for each (loc4 in loc7)
                {
                    if (!loc4.p)
                    {
                        continue;
                    }
                    loc5 = JSON.decode(loc4.v);
                    loc8 = loc4.p;
                    switch (loc8) 
                    {
                        case "dk":
                            loc3.setDrunkLevel(loc5.l);
                            continue label509;
                        case "zzz":
                            loc3.setZzzStatus(loc5.z);
                            continue label509;
                        case "item":
                            loc3.setInteractingItemState(loc5.piid, loc5.posId, loc5.itemPos);
                            continue label509;
                        default:
                            continue label509;
                    }
                }
            }
            this.addCharacterToRenderClip(loc3, loc2.x, loc2.y);
            this.charactersWaitingToEnterZone[arg1] = null;
            delete this.charactersWaitingToEnterZone[arg1];
            this.zoneItemManager.dispatchEvent(new AvatarLoadEvent(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, loc3));
            return;
        }

        private function continueJoin():void
        {
            var loc1:*;
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

            loc1 = null;
            loc3 = undefined;
            loc4 = null;
            loc5 = NaN;
            loc7 = null;
            loc8 = null;
            loc9 = false;
            loc10 = undefined;
            loc11 = undefined;
            loc12 = null;
            trace("continueJoin");
            Character.closeAllPopupCollection();
            if (MyLifeGameManager.getInstance().getActiveWindowCount() > 0 || MyLifeGameManager.getInstance().getActiveGameCount() > 0)
            {
                loc7 = this._myLife.player.getCharacter();
                suid = loc7.serverUserId;
            }
            this.asyncVisitManager.endPlayerVisit();
            _apartmentMode = this.joinZone.substr(0, 2) == "AP" || this.joinHomeId;
            if (_apartmentMode)
            {
                if (this.joinHomeId)
                {
                    loc8 = this.homeData.playerId;
                }
                else 
                {
                    if ((loc8 = StringUtils.afterFirst(this.joinZone, "-")) == "")
                    {
                        loc8 = _myLife._selectedPlayerId.toString();
                    }
                }
                if (loc9 = loc8 == _myLife._selectedPlayerId.toString())
                {
                    _myLife._interface.interfaceHUD.setMode("homeOwner");
                    if (this._myEventData)
                    {
                        loc10 = this._myEventData.instance;
                        loc11 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
                        if (loc10 != loc11)
                        {
                            this.joinInNewServer();
                            return;
                        }
                    }
                }
                else 
                {
                    _myLife._interface.interfaceHUD.setMode("homeVisitor");
                }
                if (this.homeData || loc9)
                {
                    if (this.homeData)
                    {
                        (loc12 = {}).isOwner = loc9;
                        loc12.isDefault = homeData.homeId == _myLife.player.defaultHomePlayerItemId;
                        loc12.playerItemId = homeData.homeId;
                        if (loc12.isOwner)
                        {
                            loc12.playerName = "Your";
                        }
                        else 
                        {
                            if (homeData.playerName)
                            {
                                loc12.playerName = homeData.playerName + "\'s";
                            }
                        }
                        loc12.title = homeData.title || "";
                        if (loc12.title == "null" || loc12.title == "")
                        {
                            loc12.title = homeData.homeName || "Home";
                        }
                        _myLife._interface.interfaceHUD.showHomeInfoLink(loc12);
                    }
                    else 
                    {
                        _myLife._interface.interfaceHUD.homeInfoLink.visible = false;
                    }
                }
            }
            else 
            {
                _myLife._interface.interfaceHUD.setMode("mapVisitor");
            }
            _myLife._interface.interfaceHUD.btnEditHome.visible = !_myLife._interface.interfaceHUD.btnGoHome.visible;
            if (_apartmentMode)
            {
                if (this.joinHomeId)
                {
                    _zoneObj = _myLife.myLifeConfiguration.variables["zone"][this.joinZone];
                    this.joinZone = "h" + this.homeData.rooms[this.homeData.joinRoomId].roomId;
                }
                else 
                {
                    if (this.joinZone.search("-") != -1)
                    {
                        _zoneObj = _myLife.myLifeConfiguration.variables["zone"][StringUtils.beforeFirst(this.joinZone, "-")];
                    }
                    else 
                    {
                        this.joinZone = this.joinZone + "-" + _myLife._selectedPlayerId;
                        _zoneObj = _myLife.myLifeConfiguration.variables["zone"][StringUtils.beforeFirst(this.joinZone, "-")];
                    }
                }
            }
            else 
            {
                _zoneObj = _myLife.myLifeConfiguration.variables["zone"][this.joinZone];
            }
            if (_zoneName == this.joinZone)
            {
                if (!this.newServerZoneName)
                {
                    firstApartmentTour = false;
                    return;
                }
                this.newServerZoneName = "";
            }
            this.leave();
            if (_myLife._interface.interfaceHUD.mcHomeLock.visible == false)
            {
                if (_myLife._interface.interfaceHUD.homeIsLocked)
                {
                    _myLife._interface.interfaceHUD.toggleHomeLock();
                }
            }
            _zoneName = this.joinZone;
            if (this.homeData)
            {
                this.currentPlayerHomeId = this.homeData.homeId;
                this.currentPlayerHomeRoomId = this.homeData.joinRoomId;
                this.currentOwnerPlayerId = this.homeData.playerId;
            }
            else 
            {
                this.currentPlayerHomeId = 0;
                this.currentPlayerHomeRoomId = 0;
                this.currentOwnerPlayerId = Number(StringUtils.afterFirst(_zoneName, "-"));
            }
            if (!_apartmentMode)
            {
                _myLife._interface.interfaceHUD.setMode("mapVisitor");
                this.asyncVisitManager.clearDisabledPlayerId();
            }
            characterCollection = {};
            if (!this.isFirstZoneLoad)
            {
                this.isFirstZoneLoad = false;
            }
            _myLife.loadingStatus.show(false);
            _positionIndex = this.joinPosition;
            _myLife.server.addEventListener(MyLifeEvent.USER_LEAVE, onUserUpdate);
            _myLife.server.addEventListener(MyLifeEvent.USER_JOIN, onUserUpdate);
            loc2 = zoneItemManager.items;
            loc13 = 0;
            loc14 = loc2;
            for each (loc3 in loc14)
            {
                loc3.removeEventListener(ObjectEvent.OBJECT_REQUEST_EVENT, objectEventHandler);
            }
            this.zoneItemManager.clear();
            _myLife.loadingStatus.setTask("Loading Players...");
            _myLife.loadingStatus.setProgress(0, 1);
            this.loadZoneSWF();
            if (loc5 = (loc4 = _myLife._interface.interfaceHUD.eventLink.eventData || {}).pid || 0)
            {
                if (loc5 != this._myLife.getPlayer()._playerId)
                {
                    _myLife._interface.interfaceHUD.eventLink.eventData = {};
                }
                else 
                {
                    if (_apartmentMode)
                    {
                    };
                }
            }
            loc6 = new MyLifeEvent(MyLifeEvent.JOIN_ZONE_COMPLETE, {"success":true}, false);
            this.dispatchEvent(loc6);
            return;
        }

        private function userLeft(arg1:Number):void
        {
            MyLifeGameManager.getInstance().handleUserLeave(arg1);
            removeCharacter(arg1);
            return;
        }

        public function getTriggerZoneHit(arg1:fai.Position, arg2:MyLife.Character):MyLife.Trigger
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = false;
            if (arg2 != _myLife.player.getCharacter())
            {
                return null;
            }
            if (MyLifeGameManager.getInstance().getActiveWindowCount() > 0 || MyLifeGameManager.getInstance().getActiveGameCount() > 0)
            {
                return null;
            }
            loc5 = 0;
            loc6 = _triggerZones;
            for each (loc3 in loc6)
            {
                loc4 = false;
                if (loc3.hitTestPoint(arg1.x, arg1.y + this.y))
                {
                    loc4 = loc3.hitTestPoint(arg1.x, arg1.y + this.y, true);
                }
                if (loc4)
                {
                    loc3.trigger.fireWalk(arg2);
                    continue;
                }
                if (loc3.trigger.fired)
                {
                    loc3.trigger.fireWalkOut(arg2);
                }
                loc3.trigger.fired = false;
            }
            return null;
        }

        public function transformXyToIso(arg1:fai.Position):fai.Position
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = this.collisionBlockHeight;
            loc3 = (this.zoneCenterX + loc2) / this.zoneScale;
            loc4 = -this.zoneOffsetY;
            (loc5 = new Position()).x = arg1.x - arg1.y;
            loc5.y = (arg1.x + arg1.y) / 2;
            loc5.x = loc5.x * loc2 + loc3;
            loc5.y = loc5.y * loc2 + loc4 + loc2 * 0.5;
            return loc5;
        }

        public function getCharacter(arg1:Number=0):MyLife.NPC.SimpleNPC
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            if (arg1)
            {
                if (characterCollection[arg1] != null)
                {
                    loc2 = characterCollection[arg1];
                }
                else 
                {
                    if (arg1 == _myLife.server.getUserId())
                    {
                        loc2 = _myLife.player.getCharacter();
                    }
                }
            }
            else 
            {
                loc3 = 0;
                loc4 = characterCollection;
                for each (loc2 in loc4)
                {
                    if (!loc2)
                    {
                        continue;
                    }
                    break;
                }
            }
            return loc2;
        }

        private function zoneSWFLoadingComplete(arg1:flash.events.Event):void
        {
            _zoneMovie = arg1.currentTarget.content;
            max_npcs = _zoneMovie.hasOwnProperty("max_npcs") ? _zoneMovie["max_npcs"] : 0;
            min_npcs = _zoneMovie.hasOwnProperty("min_npcs") ? _zoneMovie["min_npcs"] : 0;
            joinNewRoom();
            return;
        }

        private function addCharacterToRenderClip(arg1:MyLife.NPC.SimpleNPC, arg2:Number=0, arg3:Number=0, arg4:Number=0):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = undefined;
            trace("addCharacterToRenderClip " + arg1._characterName);
            zoneRenderClip.addChild(arg1);
            loc5 = arg1.getSpeechBubble() as MovieClip;
            speechBubbleRenderClip.addChild(loc5);
            if (arg2 <= 0 || arg3 <= 0 || isNaN(arg2) || isNaN(arg3))
            {
                trace("***** Bad Character Position *****");
                if (!(arg1 as AsyncFriend))
                {
                    if (_zoneMovie.dropZones)
                    {
                        if (loc6 = _zoneMovie.dropZones.getChildAt(0))
                        {
                            arg2 = loc7 = loc6.x;
                            arg1.x = loc7;
                            arg3 = loc7 = loc6.y;
                            arg1.y = loc7;
                        }
                    }
                    if (arg2 <= 0 || arg3 <= 0 || isNaN(arg2) || isNaN(arg3))
                    {
                        zoneRenderClip.removeChild(arg1);
                        speechBubbleRenderClip.removeChild(loc5);
                        return;
                    }
                }
            }
            else 
            {
                arg1._renderClip.avatarClip.visible = true;
                if (!(arg1 as AsyncFriend))
                {
                    trace("addCharacter " + arg2 + " " + arg3);
                    arg1.setPosition(new Position(arg2, arg3));
                }
                if (!arg1.activate())
                {
                    arg1.doAvatarAction("0");
                }
                arg1.visible = true;
                _characterCount++;
                this.resortDepths();
            }
            return;
        }

        private function processUserUpdateQueue():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            if (_zoneInitialized)
            {
                loc1 = _eventQueue.shift();
                loc2 = loc1.type;
                switch (loc2) 
                {
                    case MyLifeEvent.USER_JOIN:
                        addNewCharacter(loc1.eventData);
                        break;
                    case MyLifeEvent.USER_LEAVE:
                        userLeft(loc1.eventData.userId);
                        break;
                }
                if (_eventQueue.length)
                {
                    processUserUpdateQueue();
                }
            }
            return;
        }

        public function updateCharacterStop(arg1:Number):void
        {
            var loc2:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc2 = characterCollection[arg1];
            loc2.doStop();
            return;
        }

        public function getApartmentOwnerPlayerId():Number
        {
            var loc1:*;

            loc1 = null;
            if (_apartmentMode)
            {
                if (this.homeData)
                {
                    loc1 = this.homeData.playerId;
                }
                else 
                {
                    loc1 = StringUtils.afterFirst(_zoneName, "-");
                    if (loc1 == "")
                    {
                        loc1 = _myLife._selectedPlayerId.toString();
                    }
                }
                return Number(loc1);
            }
            return 0;
        }

        private function enableButton(arg1:flash.display.SimpleButton, arg2:Boolean):void
        {
            arg1.alpha = arg2 ? 1 : 0.5;
            arg1.mouseEnabled = arg2;
            return;
        }

        private function zoneSWFLoadingIOError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            trace("zoneSWFLoadingIOError()");
            loc2 = _myLife.zonePath + "ApartmentLiving.swf" + _assetVersionParam;
            trace("SWFPath = " + loc2);
            loc3 = new Loader();
            loc4 = new URLRequest(loc2);
            loc3.contentLoaderInfo.addEventListener(Event.COMPLETE, zoneSWFLoadingComplete);
            loc3.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, zoneSWFLoadingStatus);
            loc3.load(loc4);
            return;
        }

        private function updateLockStatus(arg1:Boolean):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = _myLife.server.getSFS();
            loc3 = loc2.getActiveRoom();
            if (loc3)
            {
                loc2.setRoomVariables([{"name":"locked", "val":arg1 ? 1 : 0, "priv":true, "persistent":false}], loc3.getId(), false);
            }
            return;
        }

        public function addNewCharacter(arg1:Object, arg2:Function=null):MyLife.NPC.SimpleNPC
        {
            var charData:Object;
            var character:MyLife.NPC.SimpleNPC;
            var loadCallBack:Function=null;
            var loc3:*;
            var loc4:*;
            var tempCostume:Object;

            character = null;
            tempCostume = null;
            charData = arg1;
            loadCallBack = arg2;
            try
            {
                if (!(charData && charData.serverUserId))
                {
                    return null;
                }
                if (charData.type != "npc")
                {
                    if (charData.type != "asyncFriend")
                    {
                        if (_zoneMovie.hasOwnProperty("SINGLE_USER") || async_mode)
                        {
                            return null;
                        }
                        asyncVisitManager.endPlayerVisit();
                        character = new Character(MovieClip(_myLife), false);
                        character = new Character(MovieClip(_myLife), false);
                    }
                    else 
                    {
                        character = new AsyncFriend(MovieClip(_myLife));
                    }
                }
                else 
                {
                    character = new SimpleNPC(MovieClip(_myLife));
                }
                if (charData.player && charData.player.serverUserId)
                {
                    character.serverUserId = charData.player.serverUserId;
                }
                else 
                {
                    character.serverUserId = charData.serverUserId;
                }
                if (charData.player && charData.player.playerId)
                {
                    character.myLifePlayerId = charData.player.playerId;
                }
                else 
                {
                    character.myLifePlayerId = charData.playerId;
                }
                trace("add new character  this.charactersWaitingToEnterZone[" + character.serverUserId + "] = " + charData);
                this.charactersWaitingToEnterZone[character.serverUserId] = charData;
                if (loadCallBack != null)
                {
                    character.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, loadCallBack);
                }
                character.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, onCharacterLoaded);
                if (charData.temporaryCostume != null)
                {
                    tempCostume = JSON.decode(charData.temporaryCostume);
                }
                character.loadCharacterClothing(charData.player.clothing, tempCostume);
                return character;
            }
            catch (error:Error)
            {
                ExceptionLogger.logException("addNewCharacter: " + undefined.toString(), "v1.2 addNewCharacter()");
                throw undefined;
            }
            return null;
        }

        public function getXyPosCollisionValue(arg1:fai.Position):uint
        {
            var loc2:*;

            loc2 = this._collisionPath.mapMatrix.getxy(arg1.x, arg1.y);
            return loc2;
        }

        public function getPlayerServerUserIdFromPlayerId(arg1:*):Number
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = NaN;
            loc5 = null;
            loc2 = Number(arg1);
            loc4 = 0;
            loc6 = 0;
            loc7 = characterCollection;
            for each (loc5 in loc7)
            {
                if (!(loc5 && loc5.myLifePlayerId))
                {
                    continue;
                }
                loc3 = Number(loc5.myLifePlayerId);
                if (loc3 != loc2)
                {
                    continue;
                }
                loc4 = Number(loc5.serverUserId);
                break;
            }
            return loc4;
        }

        private function onCharacterLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var asyncFriend:MyLife.NPC.AsyncFriend;
            var charData:Object;
            var character:MyLife.Character;
            var event:MyLife.Events.AvatarLoadEvent;
            var loc2:*;
            var loc3:*;
            var npc:MyLife.NPC.SimpleNPC;

            npc = null;
            charData = null;
            character = null;
            asyncFriend = null;
            event = arg1;
            trace("onCharacterLoaded ");
            try
            {
                npc = event.eventData as SimpleNPC;
                npc.removeEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, onCharacterLoaded);
                charData = charactersWaitingToEnterZone[npc.serverUserId];
                if (charData)
                {
                    npc.setCharacterProperties(charData.player.clothing, charData.player.gender, charData.player.name);
                    if (npc as Character)
                    {
                        trace("waiting for character player data");
                        character = npc as Character;
                        charactersWaitingToEnterZone[npc.serverUserId].loadedCharacter = character;
                        if (charactersWaitingToEnterZone[npc.serverUserId].hasData == true)
                        {
                            addLoadedCharacterToZone(npc.serverUserId);
                        }
                        return;
                    }
                    if (npc as AsyncFriend)
                    {
                        trace("added async freind");
                        asyncFriend = npc as AsyncFriend;
                        characterCollection[charData.serverUserId] = npc;
                        this.addCharacterToRenderClip(npc, charData.x, charData.y);
                    }
                    else 
                    {
                        trace("added npc");
                        if (charData.x == null)
                        {
                            charData.x = 0;
                        }
                        if (charData.y == null)
                        {
                            charData.y = 0;
                        }
                        if (charData.d == null)
                        {
                            charData.d = 0;
                        }
                        npc.setPosition(new Position(charData.x, charData.y));
                        npc.visible = true;
                        npc.doAvatarAction(charData.d);
                        if (this._zoneMovie.renderLayer.NPC.characterLayer == null)
                        {
                            if (this._zoneMovie.renderLayer.NPC.NPC.characterLayer != null)
                            {
                                this._zoneMovie.renderLayer.NPC.NPC.characterLayer.addChild(npc);
                            }
                        }
                        else 
                        {
                            this._zoneMovie.renderLayer.NPC.characterLayer.addChild(npc);
                        }
                    }
                }
            }
            catch (error:Error)
            {
                ExceptionLogger.logException("addNewCharacter: " + undefined.toString(), "v1.2 addNewCharacter()");
                throw undefined;
            }
            this.charactersWaitingToEnterZone[npc.serverUserId] = null;
            delete this.charactersWaitingToEnterZone[npc.serverUserId];
            return;
        }

        private function leave():void
        {
            var loc1:*;

            _myLife._interface.hide();
            if (_zoneMovie != null)
            {
                if (_zoneMovie.hasOwnProperty("cleanUp"))
                {
                    _zoneMovie.cleanUp();
                }
                else 
                {
                    if (_zoneMovie.hasOwnProperty("removeListeners"))
                    {
                        _zoneMovie.removeListeners();
                    }
                }
                if (_zoneMovie.parent == this)
                {
                    this.removeChild(_zoneMovie);
                    _zoneMovie = null;
                }
            }
            _eventQueue.splice(0);
            _myLife.server.callExtension("updateCharacterProperty", {"p":"vis", "v":{"vis":false}, "s":0});
            removeAllCharactersFromZone();
            removeAllRenderLayersFromZone();
            if (_mainCharacterClip)
            {
                this.removeCharacterFromZoneRenderClip(this._mainCharacterClip);
                _mainCharacterClip = null;
            }
            loc1 = new MyLifeEvent(MyLifeEvent.ROOM_LEAVE);
            this.dispatchEvent(loc1);
            return;
        }

        private function zoneSWFLoadingStatus(arg1:flash.events.ProgressEvent):void
        {
            var loc2:*;

            loc2 = arg1.bytesLoaded / arg1.bytesTotal;
            loc2 = loc2 * 100;
            _myLife.loadingStatus.setProgress(loc2, 100);
            return;
        }

        private function joinPreviousRoom():void
        {
            if (_previousHomeData)
            {
                homeData = _previousHomeData;
                _previousHomeData = null;
            }
            _joinRequest = null;
            join(_previousZone["zone"], _previousZone["position"], _previousZone["instance"], _previousZone["message"], _previousZone["teleportId"], _previousZone["homeId"]);
            return;
        }

        public function updateCharacterItemState(arg1:Number, arg2:Number, arg3:Number, arg4:Number):*
        {
            var loc5:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if ((loc5 = characterCollection[arg1]) != null)
            {
                loc5.setInteractingItemState(arg2, arg3, arg4);
            }
            return;
        }

        public function getRandomAvailableIsoPos():fai.Position
        {
            trace("getRandomAvailableIsoPos()");
            return findAvailablePosition();
        }

        public function updateCharacterDrunkLevel(arg1:Number, arg2:Number):void
        {
            var loc3:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc3 = characterCollection[arg1];
            loc3.setDrunkLevel(arg2);
            return;
        }

        public function getCollisionPath():MyLife.CollisionPath
        {
            return _collisionPath;
        }

        public function updateCharacterAction(arg1:Number, arg2:Object):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = null;
            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc3 = !(arg2.piid == null) && !(arg2.piid == 0) && !(arg2.piid == -1) && !isNaN(arg2.piid);
            loc4 = !(arg2.posId == null) && !(arg2.posId == 0) && !(arg2.posId == -1) && !isNaN(arg2.posId);
            if (loc3 || loc4)
            {
                this.zoneItemManager.doItemAction(arg1, arg2.piid, arg2.posId, arg2);
            }
            else 
            {
                (loc5 = characterCollection[arg1]).avatarActionManager.doActionList(arg2.actions, false, arg2.actionListID);
            }
            return;
        }

        public function getCharacterFromServerUserId(arg1:int):MyLife.NPC.SimpleNPC
        {
            return characterCollection[arg1];
        }

        private function setupCharacters():void
        {
            var anim:String;
            var characterCount:int;
            var defaultRoom:String;
            var eventData:Object;
            var eventHostId:Number;
            var eventTitle:String;
            var hostFound:Boolean;
            var hostName:String;
            var isOwner:Boolean;
            var isReplay:Boolean;
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var pid:Number;
            var playAction:Number;
            var playerActionSender:Number;
            var roomObj:it.gotoandplay.smartfoxserver.data.Room;
            var smartFoxClient:it.gotoandplay.smartfoxserver.SmartFoxClient;
            var uId:int;
            var uVariables:Array;
            var user:it.gotoandplay.smartfoxserver.data.User;
            var userList:Array;

            smartFoxClient = null;
            roomObj = null;
            userList = null;
            eventData = null;
            eventTitle = null;
            eventHostId = NaN;
            hostName = null;
            hostFound = false;
            characterCount = 0;
            user = null;
            uId = 0;
            uVariables = null;
            pid = NaN;
            isOwner = false;
            playAction = NaN;
            playerActionSender = NaN;
            isReplay = false;
            defaultRoom = null;
            anim = null;
            trace("setupCharacters()");
            try
            {
                smartFoxClient = _myLife.server.getSFS();
                roomObj = smartFoxClient.getRoom(smartFoxClient.activeRoomId);
                userList = (_zoneMovie.hasOwnProperty("SINGLE_USER") || async_mode) ? [] : roomObj.getUserList();
                eventData = this._lastEventData || {};
                eventTitle = eventData.title || "";
                eventHostId = this.getApartmentOwnerPlayerId();
                hostName = "";
                hostFound = false;
                characterCount = 0;
                loc2 = 0;
                loc3 = userList;
                for each (user in loc3)
                {
                    uId = user.getId();
                    uVariables = user.getVariables();
                    pid = uVariables.playerId;
                    if (uVariables.player && uVariables.player as String)
                    {
                        uVariables.player = JSON.decode(uVariables.player);
                    }
                    if (uId != smartFoxClient.myUserId)
                    {
                        trace("ac");
                        uVariables.hasData = true;
                        addNewCharacter(uVariables);
                        characterCount = characterCount + 1;
                    }
                    if (pid != eventHostId)
                    {
                        continue;
                    }
                    hostName = uVariables.player.name;
                    hostFound = true;
                }
                if (eventTitle)
                {
                    if (!(this._myLife.getPlayer()._playerId == this.getApartmentOwnerPlayerId()) && this.getApartmentOwnerPlayerId())
                    {
                        eventData.hostName = hostName;
                        this._myLife.getInterface().interfaceHUD.showEventLink(eventData);
                    }
                }
                else 
                {
                    _myLife.getInterface().interfaceHUD.hideEventLink();
                    if (!characterCount && this._apartmentMode)
                    {
                        isOwner = this.currentOwnerPlayerId == this._myLife.player._character.myLifePlayerId;
                        if (isOwner)
                        {
                            playAction = Number(_myLife.myLifeConfiguration.variables["querystring"]["play_action_type"]);
                            playerActionSender = Number(_myLife.myLifeConfiguration.variables["querystring"]["play_action_sender"]);
                            isReplay = Boolean(playAction && playerActionSender);
                            trace("\t\t", "playAction = " + playAction, "playerActionSender = " + playerActionSender, "isReplay = " + isReplay);
                            if (isReplay)
                            {
                                defaultRoom = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["default_room"];
                                loc2 = defaultRoom;
                                switch (loc2) 
                                {
                                    case "YoMotoX":
                                        break;
                                    default:
                                        anim = MyLifeConfiguration.getInstance().variables["querystring"]["anim"];
                                        this.asyncVisitManager.initReplay(playerActionSender, playAction, anim);
                                        break;
                                }
                            }
                        }
                        else 
                        {
                            asyncVisitManager.initVisit(this.currentOwnerPlayerId);
                        }
                    }
                    else 
                    {
                        if (max_npcs)
                        {
                            if (_zoneMovie.hasOwnProperty("MANAGE_ASYNC") && _zoneMovie.MANAGE_ASYNC)
                            {
                                _zoneMovie.asyncVisitManager = asyncVisitManager;
                            }
                            else 
                            {
                                asyncVisitManager.initVisit();
                            }
                        }
                    }
                }
            }
            catch (error:Error)
            {
                ExceptionLogger.logException("setupCharacters(): " + undefined.toString(), "v1.2 setupCharacters()");
                throw undefined;
            }
            return;
        }

        public function onCharacterMoved(arg1:flash.display.MovieClip):void
        {
            this.dispatchEvent(new MyLifeEvent(MyLifeEvent.CHARACTER_MOVED, {"character":arg1}));
            return;
        }

        private function tutorialCompleteHandler(arg1:flash.events.Event):void
        {
            if (arg1.type == Event.CLOSE)
            {
                if (_tutorial)
                {
                    _myLife.server.callExtension("XpManager.tutorialComplete");
                    _tutorial.removeEventListener(Event.CLOSE, tutorialCompleteHandler);
                    _tutorial.removeEventListener(Event.COMPLETE, tutorialCompleteHandler);
                    _tutorial = null;
                }
                if (_myLife.getPlayer().getPlayerId() % 2)
                {
                    MissionManager.instance.beginMissions();
                }
                _tutorialActive = false;
            }
            return;
        }

        public function getPositionFromPositionIndex():fai.Position
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            trace("getPositionFromPositionIndex()");
            loc1 = new Position(0, (0));
            loc2 = new Position(0, (0));
            loc3 = new Position(0, -200);
            if (this.joinTeleportId != null)
            {
                return loc3;
            }
            trace("\t\t_positionIndex = " + _positionIndex);
            loc7 = 0;
            loc8 = DisplayObjectContainerUtils.getChildren(_zoneMovie.dropZones);
            for each (loc6 in loc8)
            {
                if (!loc4)
                {
                    loc4 = loc6;
                }
                if (loc6.name == "drop_0")
                {
                    loc4 = loc6;
                }
                if (loc6.name != "drop_" + _positionIndex)
                {
                    continue;
                }
                loc5 = loc6;
                break;
            }
            if (loc5)
            {
                loc2.x = loc5.x / this.zoneScale;
                loc2.y = (loc5.y + Math.random() * 3) / this.zoneScale;
                return loc2;
            }
            if (loc4)
            {
                loc1.x = loc4.x / this.zoneScale;
                loc1.y = (loc4.y + Math.random() * 3) / this.zoneScale;
            }
            return loc1;
        }

        public function getCurrentZoneName():String
        {
            return _zoneName;
        }

        private function fastHitTest(arg1:flash.display.DisplayObject, arg2:Number, arg3:Number):Boolean
        {
            if (arg1 && arg1.hitTestPoint(arg2, arg3 + this.y))
            {
                if (arg1.hitTestPoint(arg2, arg3 + this.y, true))
                {
                    return true;
                }
            }
            return false;
        }

        private function newServerConnectHandler(arg1:MyLife.MyLifeEvent):void
        {
            trace("newServerConnectHandler()");
            _myLife.server.removeEventListener(MyLifeEvent.SERVER_CONNECT, newServerConnectHandler);
            _myLife.server.addEventListener(MyLifeEvent.PLAYER_ACTIVATED, onPlayerActivated, false, 0, true);
            _myLife.server.activatePlayer(this._myLife.getPlayer()._playerId);
            return;
        }

        public function reloadZone(arg1:Object=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = false;
            trace("reloadZone()");
            trace("roomData: " + arg1);
            if (_disableReload)
            {
                _disableReload = false;
                return;
            }
            if (arg1)
            {
                trace("editMode = " + editMode);
                if (editMode)
                {
                    loc4 = true;
                    this.disableEditMode(loc4);
                }
                loc2 = zoneItemManager.items;
                loc5 = 0;
                loc6 = loc2;
                for each (loc3 in loc6)
                {
                    loc3.removeEventListener(ObjectEvent.OBJECT_REQUEST_EVENT, objectEventHandler);
                }
                this.zoneItemManager.clear();
                this._zoneMovie.loadRoomFurniture(arg1);
                _zoneMovie.addEventListener(MyLifeEvent.LOADING_DONE, reloadZoneComplete);
            }
            else 
            {
                _rejoinZone = _zoneName;
                join("Reload");
            }
            return;
        }

        private function confirmEndEventDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = 0;
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                _myLife._interface.interfaceHUD.toggleHomeLock();
            }
            else 
            {
                if (this._myEventData)
                {
                    this.deleteEvent(this._myEventData);
                }
                loc2 = 0;
                if (this.homeData && this.homeData.joinRoomId)
                {
                    loc2 = this.homeData.joinRoomId;
                }
                updateLockStatus(true);
            }
            return;
        }

        private function confirmServerSwitchDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                this.dispatchJoinFailEvent();
            }
            else 
            {
                this.joinInNewServer();
            }
            return;
        }

        public function isApartmentMode():Boolean
        {
            return _apartmentMode;
        }

        public function updateCharacterDirection(arg1:Object):void
        {
            var loc2:*;

            if (arg1.uid == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1.uid] == null)
            {
                return;
            }
            loc2 = characterCollection[arg1.uid];
            if (!loc2.isBusy())
            {
                loc2.changeDirection(Number(arg1.d));
            }
            return;
        }

        public function removeCharacterFromZoneRenderClip(arg1:MyLife.NPC.SimpleNPC):void
        {
            var loc2:*;
            var loc3:*;

            if (arg1.parent)
            {
                arg1.parent.removeChild(arg1);
            }
            if (arg1 != _myLife.player._character)
            {
                arg1.cleanUp();
            }
            _characterCount--;
            return;
        }

        private function checkZoneLocked(arg1:String, arg2:it.gotoandplay.smartfoxserver.data.Room):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc3 = false;
            if ((loc4 = arg1.substr(0, 2) == "AP" || this.joinHomeId) && _myLife.player && _myLife.player.getModLevel() <= 0 && !isOwner)
            {
                loc3 = arg2.getVariable("locked") == 1;
            }
            return loc3;
        }

        private function processSaveRoomRequest():void
        {
            var loc1:*;
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

            loc5 = undefined;
            loc6 = 0;
            loc7 = 0;
            loc8 = 0;
            loc9 = 0;
            loc10 = null;
            loc11 = undefined;
            loc12 = null;
            loc1 = {};
            loc1.wallPattern = _zoneMovie.currentWallPattern;
            loc1.floorPattern = _zoneMovie.currentFloorPattern;
            loc1.furnitureItemCollection = [];
            loc2 = 0;
            while (loc2 < zoneRenderClip.numChildren) 
            {
                if ((loc5 = zoneRenderClip.getChildAt(loc2)).hasOwnProperty("hitZone"))
                {
                    loc6 = 0;
                    loc7 = 640;
                    loc8 = 77;
                    loc9 = 477;
                    if ((loc10 = loc5.hitZone.getBounds(this)).bottom >= loc8 && loc10.top <= loc9 && loc10.right >= loc6 && loc10.left <= loc7)
                    {
                        (loc11 = {}).itemId = loc5.itemData.itemId;
                        if (loc5.itemData.filename)
                        {
                            loc11.filename = loc5.itemData.filename;
                        }
                        if (loc5.playerItemId)
                        {
                            loc11.playerItemId = loc5.playerItemId;
                            loc11.r = loc5.rotationView;
                            if (loc5.itemData.isProp)
                            {
                                loc11.x = loc5.x;
                                loc11.y = loc5.y;
                            }
                            else 
                            {
                                loc12 = transformIsoToXy(new Position(loc5.x, loc5.y - 7.5));
                                loc11.isox = loc12.x;
                                loc11.isoy = loc12.y;
                            }
                            loc1.furnitureItemCollection.push(loc11);
                        }
                    }
                }
                ++loc2;
            }
            loc3 = JSON.encode(loc1);
            loc4 = String(_myLife.myLifeConfiguration.variables["querystring"]["lk"]);
            _disableReload = true;
            _myLife.server.callExtension("savePlayerRoom", {"roomName":_zoneMovie.roomName, "roomObj":loc3, "lk":loc4, "playerHomeRoomId":currentPlayerHomeRoomId});
            return;
        }

        public function applyDrinksToView(arg1:Number):void
        {
            var loc2:*;

            loc2 = Math.sqrt(arg1) + arg1 / 10;
            setDrunkLevel(loc2);
            return;
        }

        private function createRoomTriggerData(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = undefined;
            loc3 = 0;
            loc4 = null;
            loc5 = 0;
            loc6 = arg1;
            for each (loc2 in loc6)
            {
                loc2.triggerDataArray = [];
                loc7 = 0;
                loc8 = loc2.connectsTo;
                for each (loc3 in loc8)
                {
                    (loc4 = {}).roomIndex = loc3;
                    if (loc3 >= 0)
                    {
                        loc4.roomId = arg1[loc3].roomId;
                        loc4.targetDrop = homeData.rooms[loc4.roomId].connectsTo.indexOf(loc2.roomIndex) + 1;
                        loc4.labelName = "Enter " + arg1[loc3].defaultName;
                    }
                    else 
                    {
                        loc4.roomId = 0;
                        loc4.targetDrop = 0;
                        loc4.labelName = "Exit To Guard House";
                    }
                    loc2.triggerDataArray.push(loc4);
                }
            }
            return;
        }

        public function removeCharacter(arg1:Number):void
        {
            var loc2:*;

            loc2 = null;
            if (characterCollection[arg1] != null)
            {
                _myLife.debug("removeCharacter: " + arg1);
                loc2 = characterCollection[arg1];
                this.removeCharacterFromZoneRenderClip(loc2);
                characterCollection[arg1] = null;
            }
            return;
        }

        private function joiningFakeTimerTick(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = arg1.target.currentCount;
            if (loc2 > 50)
            {
                arg1.target.stop();
                arg1.target.removeEventListener("timer", joiningFakeTimerTick);
            }
            else 
            {
                _myLife.loadingStatus.setProgress(loc2 * 2, 100);
            }
            return;
        }

        private function onPlayerSetupComplete(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = null;
            trace("onPlayerSetupComplete()");
            _myLife.player.removeEventListener(MyLifeEvent.PLAYER_LOADED, onPlayerSetupComplete);
            _myLife.player.sendServerNewPlayerData();
            _myLife.loadingStatus.setTask("Joining New Room...");
            _myLife.loadingStatus.setProgress(0, 100);
            if (_zoneName != "Reload")
            {
                loc2 = new Timer(50);
                loc2.addEventListener("timer", joiningFakeTimerTick);
                loc2.start();
            }
            _myLife.getInterface().interfaceHUD.hideEventLink();
            trace("\t\tthis._apartmentMode = " + this._apartmentMode);
            if (this._apartmentMode)
            {
                this.detectEvent();
            }
            else 
            {
                this._lastEventData = {};
                _myLife.getInterface().interfaceHUD.hideEventLink();
                loadPlayersAndItems();
            }
            return;
        }

        private function detectEventCompleteHandler(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;
            var json:String;
            var jsonObj:Object;
            var loc2:*;
            var loc3:*;
            var roomEvent:Object;

            json = null;
            jsonObj = null;
            roomEvent = null;
            event = arg1;
            trace("detectEventCompleteHandler()");
            if (this.detectEventTimeoutId)
            {
                clearTimeout(this.detectEventTimeoutId);
                this.detectEventTimeoutId = 0;
                json = event.target.data;
                trace("\t\tjson = " + json);
                if (json)
                {
                    try
                    {
                        jsonObj = JSON.decode(json);
                        roomEvent = jsonObj[0];
                        if (roomEvent)
                        {
                            this._myLife.getInterface().interfaceHUD.showEventLink(roomEvent);
                            this._lastEventData = roomEvent;
                        }
                        else 
                        {
                            _myLife.getInterface().interfaceHUD.hideEventLink();
                            this._lastEventData = {};
                        }
                    }
                    catch (error:Error)
                    {
                        _myLife.getInterface().interfaceHUD.hideEventLink();
                        this._lastEventData = {};
                    }
                }
                else 
                {
                    _myLife.getInterface().interfaceHUD.hideEventLink();
                    this._lastEventData = {};
                }
                loadPlayersAndItems();
            }
            return;
        }

        public function getZoneMovieObject():flash.display.MovieClip
        {
            return _zoneMovie;
        }

        public function getPlayerHomeId():int
        {
            var loc1:*;

            loc1 = 0;
            if (this.homeData && this.homeData.homeId)
            {
                loc1 = this.homeData.homeId;
            }
            return loc1;
        }

        private function checkZoneSwitch():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            loc1 = this.getCurrentInstanceId();
            if (!this.joinInstanceId || this.joinInstanceId == loc1)
            {
                this.continueJoin();
            }
            else 
            {
                loc2 = this.joinServerSwithcMessage || "This location is currently on a different server. Are you sure you want to change servers?";
                loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Are You Sure?", "message":loc2, "metaData":{}, "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
                loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmServerSwitchDialogHandler, false, 0, true);
            }
            return;
        }

        private function removeAllRenderLayersFromZone():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = renderLayerCollection;
            for each (loc1 in loc3)
            {
                if (!loc1)
                {
                    continue;
                }
                if (!loc1.parent)
                {
                    continue;
                }
                loc1.parent.removeChild(loc1);
            }
            renderLayerCollection = [];
            return;
        }

        private function zoneMovieInitCompleteEvent(arg1:MyLife.MyLifeEvent):void
        {
            trace("zoneMovieInitCompleteEvent()");
            _zoneMovie.removeEventListener(MyLifeEvent.LOADING_DONE, zoneMovieInitCompleteEvent);
            zoneMovieInitComplete();
            return;
        }

        public function join(arg1:String, arg2:Number=0, arg3:*=null, arg4:String="", arg5:*=null, arg6:int=0):void
        {
            trace("join(" + arg1 + "," + arg2 + "," + arg3 + ",\'\'," + arg5 + "," + arg6 + ")");
            if (isOwner)
            {
                this._myLife._interface.setIsHomeLocked(false);
            }
            if (this.joinZone != arg1)
            {
                dispatchEvent(new Event("requestJoinRoom"));
            }
            this.joinZone = arg1;
            this.joinPosition = arg2;
            this.joinInstanceId = String(arg3 || "");
            this.joinServerSwithcMessage = arg4;
            this.joinTeleportId = arg5;
            this.joinHomeId = arg6;
            _previousZone = _joinRequest;
            _joinRequest = {};
            _joinRequest.zone = arg1;
            _joinRequest.position = arg2;
            _joinRequest.instanceId = arg3;
            _joinRequest.message = arg4;
            _joinRequest.teleportId = arg5;
            _joinRequest.homeId = arg6;
            if (!this.joinHomeId)
            {
                _previousHomeData = homeData;
                this.homeData = null;
            }
            checkZoneSwitch();
            return;
        }

        public function getLevelingItemManager():MyLife.LevelingItemManager
        {
            return _levelingItemManager;
        }

        private function onJoinRoomSuccess(arg1:MyLife.MyLifeEvent):void
        {
            var e:MyLife.MyLifeEvent;
            var errorJoinRoomDialog:flash.display.DisplayObject;
            var initObj:Object;
            var loc2:*;
            var loc3:*;
            var room:*;
            var roomData:Object;
            var roomId:int;
            var sfs:*;

            initObj = null;
            roomData = null;
            errorJoinRoomDialog = null;
            e = arg1;
            sfs = _myLife.server.getSFS();
            room = sfs.getActiveRoom();
            roomId = room.getId();
            isOwner = currentOwnerPlayerId == _myLife.player.getPlayerId();
            if (checkZoneLocked(_joinRequest["zone"], room))
            {
                if (_previousZone)
                {
                    joinPreviousRoom();
                }
                else 
                {
                    join("CondoExterior");
                }
                _myLife._interface.showInterface("GenericDialog", {"title":"Apartment Locked", "message":"Sorry, this player\'s apartment door is currently locked."});
                _myLife._interface.friendLadder.visible = true;
                return;
            }
            _previousZone = null;
            _previousHomeData = null;
            try
            {
                _myLife.server.removeEventListener(MyLifeEvent.JOIN_SUCCESS, onJoinRoomSuccess);
                if (_rejoinZone != "")
                {
                    join(_rejoinZone);
                    _rejoinZone = "";
                    return;
                }
                _zoneMovie.addEventListener(MyLifeEvent.LOADING_DONE, zoneMovieInitCompleteEvent);
                if (_zoneMovie.hasOwnProperty("ownerXP"))
                {
                    try
                    {
                        _zoneMovie.ownerXP = XpManager.instance.getLevelFromXp(parseInt(room.getVariable("ownerXP"))).getLevel();
                    }
                    catch (error:TypeError)
                    {
                        trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                        undefined.getStackTrace();
                    }
                }
                if (this.joinHomeId)
                {
                    roomData = this.homeData.rooms[this.homeData.joinRoomId];
                    initObj = _zoneMovie.init(_myLife, roomData);
                }
                else 
                {
                    initObj = _zoneMovie.init(_myLife);
                }
                if (initObj)
                {
                    if (initObj.gameMode)
                    {
                        _gameMode = true;
                        GameManager.start();
                    }
                    else 
                    {
                        _gameMode = false;
                    }
                    if (initObj.bgSound)
                    {
                        MyLifeSoundController.getInstance().playBgSound(initObj.bgSound);
                    }
                    if (!initObj.waitForLoadEvent)
                    {
                        _zoneMovie.removeEventListener(MyLifeEvent.LOADING_DONE, zoneMovieInitCompleteEvent);
                        zoneMovieInitComplete();
                    }
                }
                else 
                {
                    _gameMode = false;
                    _zoneMovie.removeEventListener(MyLifeEvent.LOADING_DONE, zoneMovieInitCompleteEvent);
                    zoneMovieInitComplete();
                }
            }
            catch (error:Error)
            {
                trace("error:" + undefined);
                errorJoinRoomDialog = _myLife._interface.showInterface("GenericDialog", {"title":"There Was A Problem Joining The Room", "message":"There was a problem trying to join the new room.  This problem has been logged.\nWe will instead send you to the Condo Exterior."});
                errorJoinRoomDialog.addEventListener(MyLifeEvent.DIALOG_RESPONSE, errorJoinRoomDialogResponse);
                ExceptionLogger.logException("onJoinRoomSuccess: " + undefined.toString(), "v1.2 Problem Joining New Room.");
            }
            return;
        }

        public function roomRatingUpdate(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = NaN;
            if (arg1.eventData.result != 1)
            {
                if (arg1.eventData.result != 0)
                {
                };
            }
            else 
            {
                loc2 = arg1.eventData.total;
                _myLife._interface.interfaceHUD.setRoomRatingTotal(loc2);
            }
            return;
        }

        private function reloadZoneComplete(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc2 = [];
            loc3 = DisplayObjectContainerUtils.getChildren(this.zoneRenderClip);
            loc6 = 0;
            loc7 = loc3;
            for each (loc4 in loc7)
            {
                if (loc4.name != "TransportButtons")
                {
                    continue;
                }
                loc2.push(loc4);
            }
            this.generateTriggerZones();
            this.generateCollisionPaths();
            this.setupZone();
            loc6 = 0;
            loc7 = loc2;
            for each (loc4 in loc7)
            {
                this.zoneRenderClip.addChild(loc4);
            }
            this.zoneItemManager.activateItems();
            this.addMainCharacterClip(_mainCharacterClip);
            loc6 = 0;
            loc7 = characterCollection;
            for each (loc5 in loc7)
            {
                if (!loc5)
                {
                    continue;
                }
                this.addCharacterToRenderClip(loc5, loc5.x, loc5.y);
            }
            this.showAllItemsInZone(true);
            this._myLife.player.setWalkable(true);
            return;
        }

        public function checkValidPlayerMove(arg1:Number=0, arg2:Number=0):Boolean
        {
            var loc3:*;

            arg1 = arg1 || this.stage.mouseX;
            arg2 = arg2 || this.stage.mouseY;
            loc3 = true;
            if (this.isGameMode())
            {
                loc3 = false;
            }
            else 
            {
                if (_zoneMovie && _zoneMovie.hasOwnProperty("checkValidPlayerMove"))
                {
                    loc3 = _zoneMovie.checkValidPlayerMove(arg1, arg2);
                }
            }
            return loc3;
        }

        private function workHelpCloseHandler(arg1:flash.events.Event):void
        {
            _workHelpDialog.removeEventListener(Event.CLOSE, workHelpCloseHandler);
            _workHelpDialog.btnWork.removeEventListener(MouseEvent.CLICK, workHelpCloseHandler);
            _workHelpDialog.close();
            _workHelpDialog = null;
            startTutorial();
            return;
        }

        public function updateCharacterZzzStatus(arg1:Number, arg2:Boolean):void
        {
            var loc3:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc3 = characterCollection[arg1];
            loc3.setZzzStatus(arg2);
            return;
        }

        private function onResortDepthsTimerTick(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = 0;
            doResortDepths();
            if (_characterCount < 10)
            {
                loc2 = 300;
            }
            else 
            {
                if (_characterCount < 20)
                {
                    loc2 = 600;
                }
                else 
                {
                    loc2 = 1000;
                }
            }
            if (_resortDepthsTimer.delay != loc2)
            {
                _resortDepthsTimer.delay = loc2;
                _resortDepthsTimer.reset();
                _resortDepthsTimer.start();
            }
            return;
        }

        public function onDoGoHome(arg1:MyLife.MyLifeEvent=null):void
        {
            if (this._myLife.player.defaultHomePlayerItemId)
            {
                this.joinHomeRoom(this._myLife.player.defaultHomePlayerItemId, _myLife.player.getPlayerId());
            }
            else 
            {
                this.join("APLiving", 0);
            }
            return;
        }

        private function enableEditModeLoadingDone(arg1:MyLife.MyLifeEvent=null):void
        {
            _myLife.loadingStatus.hide();
            _myLife.enableInput();
            dispatchEvent(new MyLifeEvent(MyLifeEvent.LOADING_EDIT_DONE, {}));
            return;
        }

        private function getMovieChildrenFloorBlocks(arg1:flash.display.DisplayObject):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = [];
            loc4 = 0;
            loc5 = DisplayObjectContainerUtils.getChildren(arg1 as DisplayObjectContainer);
            for each (loc3 in loc5)
            {
                if (!(loc3 && loc3.width == 30 && loc3.height == 15))
                {
                    continue;
                }
                loc2.push(loc3);
            }
            return loc2;
        }

        private function zoneMovieInitComplete():void
        {
            enableButton(_myLife._interface.interfaceHUD.btnChangeAppearance, !_gameMode);
            _zoneMovie.dropZones.visible = false;
            _zoneMovie.visible = false;
            addChild(_zoneMovie);
            if (this._zoneMovie.hasOwnProperty("scale"))
            {
                this.zoneScale = _zoneMovie.scale;
            }
            else 
            {
                this.zoneScale = 1;
            }
            generateTriggerZones();
            generateCollisionPaths();
            setupZone();
            _myLife.loadingStatus.setProgress(100, (100));
            _myLife.player.addEventListener(MyLifeEvent.PLAYER_LOADED, onPlayerSetupComplete);
            _myLife.player.addEventListener(MyLifeEvent.PLAYER_STARTMOVE, onPlayerStartMove);
            _myLife.player.setupCharacter();
            return;
        }

        private function loadZoneSWF():void
        {
            var SWFPath:String;
            var loc1:*;
            var loc2:*;
            var zoneLoader:flash.display.Loader;
            var zoneRequest:flash.net.URLRequest;

            SWFPath = null;
            zoneLoader = null;
            zoneRequest = null;
            max_npcs = 0;
            min_npcs = 0;
            _myLife.loadingStatus.setTask("Loading New Room...");
            _myLife.loadingStatus.setProgress(1, 100);
            try
            {
                SWFPath = _myLife.zonePath + _zoneObj.swf + _assetVersionParam;
                zoneLoader = new Loader();
                zoneRequest = new URLRequest(SWFPath);
                zoneLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, zoneSWFLoadingComplete);
                zoneLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, zoneSWFLoadingIOError);
                zoneLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, zoneSWFLoadingStatus);
                zoneLoader.load(zoneRequest);
            }
            catch (error:Error)
            {
                trace("loadZoneSWF " + undefined);
            }
            trace("SWFPath = " + SWFPath);
            return;
        }

        public function deleteEventErrorHandler(arg1:flash.events.Event):void
        {
            _myLife.debug("Delete Room Event Error");
            return;
        }

        public function enableEditMode():void
        {
            var loc1:*;

            editMode = true;
            speechBubbleRenderClip.visible = false;
            _myLife.disableInput();
            _myLife._interface.interfaceHUD.setMode("homeEdit");
            this.showAllItemsInZone(false);
            this.zoneItemManager.deactivateItems();
            _zoneMovie.enableEditMode();
            _myLife.player.enableEditMode();
            loc1 = new MyLifeEvent(MyLifeEvent.ENABLING_EDIT_MODE);
            this.dispatchEvent(loc1);
            enableEditModeLoadingDone(null);
            return;
        }

        public function getCharacterCollection():Object
        {
            return this.characterCollection;
        }

        private function detectEventErrorHandler(arg1:flash.events.Event):void
        {
            if (this.detectEventTimeoutId)
            {
                clearTimeout(this.detectEventTimeoutId);
                this.detectEventTimeoutId = 0;
                loadPlayersAndItems();
            }
            return;
        }

        private function resortDepthsViaY():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            loc4 = null;
            loc1 = zoneRenderClip;
            loc2 = DisplayObjectContainerUtils.getChildren(loc1);
            loc2.sortOn("y", Array.NUMERIC);
            loc5 = loc2.length;
            while (loc5--) 
            {
                loc3 = loc2[loc5];
                if (loc1.getChildAt(loc5) != loc3)
                {
                    loc1.setChildIndex(loc3, loc5);
                }
                if (!loc3.hasOwnProperty("getSpeechBubble"))
                {
                    continue;
                }
                if (!((loc4 = loc3.getSpeechBubble()) && loc4.parent == this.speechBubbleRenderClip))
                {
                    continue;
                }
                this.speechBubbleRenderClip.setChildIndex(loc4, 0);
            }
            return;
        }

        public function getCharacterServerUserId(arg1:Number):Number
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = 0;
            loc4 = 0;
            loc5 = characterCollection;
            for each (loc3 in loc5)
            {
                if (loc3.myLifePlayerId != arg1)
                {
                    continue;
                }
                loc2 = loc3.serverUserId;
            }
            return loc2;
        }

        public function checkForCollisionBlock(arg1:int, arg2:int):Boolean
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = new Position(arg1, arg2);
            loc4 = this.transformIsoToXy(loc3);
            loc5 = _collisionPath.mapMatrix.getpos(loc4);
            return loc6 = Boolean(loc5);
        }

        private function generateTriggerZones():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            _triggerZones = new Array();
            loc2 = 0;
            loc3 = DisplayObjectContainerUtils.getChildren(_zoneMovie.zoneTriggers);
            for each (loc1 in loc3)
            {
                _triggerZones.push(loc1);
            }
            _zoneMovie.zoneTriggers.visible = false;
            return;
        }

        public function getCurrentPlayerHomeId():int
        {
            return 0;
        }

        public function updateCharacterVisibility(arg1:Number, arg2:Boolean):void
        {
            var loc3:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc3 = characterCollection[arg1];
            loc3.visible = arg2;
            return;
        }

        private function onPlayerStartMove(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = _triggerZones;
            for each (loc2 in loc4)
            {
                loc2.trigger.characterStartMove(_myLife.player.getCharacter());
            }
            return;
        }

        public function updateNewPlayerData(arg1:Object):void
        {
            var loc2:*;

            trace("updateNewPlayerData " + arg1.x + " " + arg1.y);
            if (charactersWaitingToEnterZone[arg1.uid] == null)
            {
                return;
            }
            charactersWaitingToEnterZone[arg1.uid].x = arg1.x;
            charactersWaitingToEnterZone[arg1.uid].y = arg1.y;
            charactersWaitingToEnterZone[arg1.uid].hasData = true;
            loc2 = charactersWaitingToEnterZone[arg1.uid].loadedCharacter;
            if (loc2 == null)
            {
                return;
            }
            if (editMode)
            {
                loc2.visible = false;
            }
            else 
            {
                this.addLoadedCharacterToZone(loc2.serverUserId);
            }
            return;
        }

        public function getCharacterName(arg1:Number):String
        {
            var loc2:*;
            var loc3:*;

            loc2 = getCharacter(arg1);
            loc3 = "";
            if (loc2)
            {
                loc3 = loc2._characterName;
            }
            return loc3;
        }

        private function giveReward(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = NaN;
            loc3 = null;
            loc4 = NaN;
            if (arg1.eventData)
            {
                loc2 = Number(arg1.eventData["reward"]);
            }
            if (loc2)
            {
                loc3 = ActionTweenType.COIN;
                loc4 = _myLife.getPlayer().getCharacter()["serverUserId"];
                ActionTweenManager.instance.makeActionTween(loc3, loc4, loc4, {"coins":loc2});
                loc2 = loc2 + _myLife.getPlayer().getCoinBalance();
                _myLife.getPlayer().setCoinBalance(loc2);
            }
            return;
        }

        public function joinHomeRoom(arg1:int=0, arg2:*=0, arg3:int=0, arg4:int=1, arg5:*=null, arg6:String="", arg7:*=null):void
        {
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc9 = null;
            loc10 = null;
            trace("joinHomeRoom(" + arg1 + ", " + arg3 + ", " + arg4 + ")");
            if (!(loc8 = this.homeData && this.homeData.homeId == arg1))
            {
                _previousHomeData = homeData;
                this.homeData = {};
            }
            this.homeData.homeId = arg1;
            this.homeData.joinRoomId = arg3;
            this.homeData.joinDropTarget = arg4;
            this.homeData.joinInstanceId = arg5;
            this.homeData.joinServerSwitchMessage = arg6;
            this.homeData.joinTeleportId = arg7;
            if (loc8)
            {
                if (!arg3)
                {
                    loc11 = 0;
                    loc12 = this.homeData.rooms;
                    for each (loc9 in loc12)
                    {
                        if (loc9.roomIndex != 0)
                        {
                            continue;
                        }
                        arg3 = loc9.roomId;
                        break;
                    }
                }
                this.homeData.joinRoomId = arg3;
                if (loc9 = homeData.hasOwnProperty("rooms") ? homeData.rooms[arg3] : null)
                {
                    loc10 = loc9.zoneName;
                    this.join(loc10, arg4, arg5, arg6, arg7, this.homeData.homeId);
                }
            }
            else 
            {
                this.asyncVisitManager.clearDisabledPlayerId();
                _myLife.updateLoadingMonitor(SharedObjectManager.LOADISSUE_HOMEDATA);
                _myLife.server.callExtension("HomeManager.getDefaultHomeData", {"playerItemId":arg1, "playerHomeRoomId":arg3, "player_id":arg2});
                _myLife.server.addEventListener(MyLifeEvent.GET_DEFAULT_HOME_DATA_COMPLETE, getDefaultHomeDataComplete, false, 0, true);
            }
            return;
        }

        public function setHomeDataProp(arg1:String, arg2:*):void
        {
            if (this.homeData)
            {
                this.homeData[arg1] = arg2;
            }
            return;
        }

        public function deleteEvent(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = this._myLife.getPlayer()._playerId;
            loc3 = MyLifeInstance.getInstance().myLifeConfiguration;
            (loc4 = new URLVariables()).pid = loc2;
            loc4.locale = MyLifeInstance.getInstance().getPlayer()._locale;
            loc4.instance = loc3.variables["querystring"]["defaultInstance"];
            loc4.server = loc3.variables["querystring"]["defaultServer"];
            loc4.age = MyLifeInstance.getInstance().getPlayer().age || 100;
            loc6 = (loc5 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_events_server"]) + "events.php?action=delete&r=" + Math.random();
            (loc7 = new URLRequest(loc6)).method = URLRequestMethod.POST;
            loc7.data = loc4;
            (loc8 = new URLLoader()).addEventListener(Event.COMPLETE, deleteEventCompleteHandler, false, 0, true);
            loc8.addEventListener(IOErrorEvent.IO_ERROR, deleteEventErrorHandler, false, 0, true);
            loc8.load(loc7);
            if (loc2 == arg1.pid)
            {
                _myLife._interface.interfaceHUD.eventLink.eventData = {};
                _myLife._interface.interfaceHUD.eventLink.visible = false;
            }
            this._myEventData = null;
            return;
        }

        private function generateCollisionPaths():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            this.currentGridLength = this.defaultGridLength / this.zoneScale;
            loc1 = this.currentGridLength;
            loc2 = this.currentGridLength;
            _collisionPath.initializeMap(loc1, loc2);
            if (this._zoneMovie.hasOwnProperty("staticCollisionBlockPositions"))
            {
                loc6 = this._zoneMovie.staticCollisionBlockPositions;
                loc7 = 0;
                loc8 = loc6;
                for each (loc3 in loc8)
                {
                    if (!((loc4 = transformIsoToXy(loc3)).x >= 0 && loc4.y >= 0 && loc4.x < loc1 && loc4.y < loc2))
                    {
                        continue;
                    }
                    _collisionPath.mapMatrix.setxy(loc4.x, loc4.y, 1);
                }
            }
            loc7 = 0;
            loc8 = DisplayObjectContainerUtils.getChildren(_zoneMovie.collision);
            for each (loc5 in loc8)
            {
                loc3 = new Position(loc5.x, loc5.y);
                if ((loc4 = transformIsoToXy(loc3)).x >= 0 && loc4.y >= 0 && loc4.x < loc1 && loc4.y < loc2)
                {
                    _collisionPath.mapMatrix.setxy(loc4.x, loc4.y, 1);
                }
                _zoneMovie.collision.removeChild(loc5);
            }
            return;
        }

        private function onUserUpdate(arg1:MyLife.MyLifeEvent):void
        {
            if (_zoneMovie)
            {
                _eventQueue.push(arg1);
                processUserUpdateQueue();
            }
            return;
        }

        private function detectEvent():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            trace("detectEvent()");
            loc1 = this.getApartmentOwnerPlayerId();
            loc2 = this.getPlayerHomeId();
            loc3 = MyLifeInstance.getInstance().myLifeConfiguration;
            (loc4 = new URLVariables()).pid = loc1;
            loc4.playerHomeId = loc2;
            loc4.locale = MyLifeInstance.getInstance().getPlayer()._locale;
            loc4.instance = loc3.variables["querystring"]["defaultInstance"];
            loc4.server = loc3.variables["querystring"]["defaultServer"];
            loc4.age = MyLifeInstance.getInstance().getPlayer().age || 100;
            loc6 = (loc5 = this._myLife.myLifeConfiguration.variables["global"]["game_events_server"]) + "events.php?action=find&r=" + Math.random();
            trace("\t\turl = " + loc6);
            (loc7 = new URLRequest(loc6)).method = URLRequestMethod.POST;
            loc7.data = loc4;
            (loc8 = new URLLoader()).addEventListener(Event.COMPLETE, detectEventCompleteHandler, false, 0, true);
            loc8.addEventListener(IOErrorEvent.IO_ERROR, detectEventErrorHandler, false, 0, true);
            loc8.load(loc7);
            clearTimeout(this.detectEventTimeoutId);
            this.detectEventTimeoutId = setTimeout(detectEventTimeoutHandler, this.detectEventTimeoutDelay);
            return;
        }

        private function dispatchJoinFailEvent():void
        {
            var loc1:*;

            loc1 = new MyLifeEvent(MyLifeEvent.JOIN_ZONE_COMPLETE, {"success":false}, false);
            this.dispatchEvent(loc1);
            return;
        }

        private function getDefaultHomeDataComplete(arg1:MyLife.MyLifeEvent):void
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

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = 0;
            loc10 = null;
            loc11 = 0;
            loc12 = 0;
            trace("getDefaultHomeDataComplete()");
            _myLife.server.removeEventListener(MyLifeEvent.GET_DEFAULT_HOME_DATA_COMPLETE, getDefaultHomeDataComplete);
            _myLife.updateLoadingMonitor();
            loc2 = arg1.eventData;
            loc3 = loc2.defaultData;
            loc4 = (loc2.rooms as Array).sort();
            this.homeData.homeId = parseInt(loc2.homeItemId);
            if (this.homeData.homeId)
            {
                loc5 = {};
                loc6 = [];
                loc12 = loc4.length;
                while (loc12--) 
                {
                    loc10 = loc3[loc12];
                    loc11 = loc4[loc12];
                    (loc7 = {}).defaultName = loc10.defaultName;
                    loc7.homeId = this.homeData.homeId;
                    loc7.roomId = loc11;
                    loc7.roomIndex = loc10.roomIndex;
                    loc7.playerId = loc10.playerId;
                    loc7.zoneName = loc10.filename;
                    loc7.connectsTo = loc10.connectsTo;
                    loc5[loc11] = loc7;
                    loc6.push(loc7);
                }
                this.homeData.rooms = loc5;
                this.homeData.playerId = loc2.playerId;
                this.homeData.playerName = loc2.playerName;
                this.homeData.title = loc2.title;
                this.homeData.homeName = loc2.homeName;
                createRoomTriggerData(loc6.sortOn("roomIndex", Array.NUMERIC));
                this.joinHomeRoom(this.homeData.homeId, homeData.playerId, this.homeData.joinRoomId, this.homeData.joinDropTarget, this.homeData.joinInstanceId, this.homeData.joinServerSwitchMessage, this.homeData.joinTeleportId);
            }
            return;
        }

        public function getTeleportId():String
        {
            return joinTeleportId;
        }

        public function resortDepths():void
        {
            _doResortDepthsOnNextTick = true;
            return;
        }

        private function onRequestJoinZone(arg1:MyLife.MyLifeEvent):void
        {
            join(arg1.eventData.zone, 0);
            return;
        }

        private function setupZone():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = undefined;
            loc2 = null;
            if (this.speechBubbleRenderClip)
            {
                trace("setupZone this.speechBubbleRenderClip.numChildren = " + this.speechBubbleRenderClip.numChildren);
                this.removeChild(this.speechBubbleRenderClip);
            }
            if (zoneRenderClip != null)
            {
                removeChild(zoneRenderClip);
            }
            if (this.actionTweenRenderClip != null)
            {
                this.removeChild(this.actionTweenRenderClip);
            }
            this.zoneRenderClip = new MovieClip();
            this.addChild(zoneRenderClip);
            this.speechBubbleRenderClip = new MovieClip();
            this.addChild(this.speechBubbleRenderClip);
            this.actionTweenRenderClip = new Sprite();
            this.actionTweenRenderClip.mouseChildren = loc3 = false;
            this.actionTweenRenderClip.mouseEnabled = loc3;
            this.addChild(this.actionTweenRenderClip);
            loc3 = 0;
            loc4 = DisplayObjectContainerUtils.getChildren(_zoneMovie.renderLayer);
            for each (loc1 in loc4)
            {
                loc2 = new Position(loc1.x, loc1.y);
                loc1.visible = false;
                if (loc1 != "[object SimpleButton]")
                {
                    loc1.sortOrder = Math.round(Math.random() * 99);
                }
                loc1.addEventListener(ObjectEvent.OBJECT_REQUEST_EVENT, objectEventHandler);
                renderLayerCollection.push(loc1);
                zoneRenderClip.addChild(loc1);
                loc1.x = loc2.x;
                loc1.y = loc2.y;
            }
            this.zoneRenderClip.scaleY = loc3 = this.zoneScale;
            this.zoneRenderClip.scaleX = loc3;
            this.resortDepths();
            _resortDepthsTimer = new Timer(300);
            _resortDepthsTimer.addEventListener("timer", onResortDepthsTimerTick);
            _resortDepthsTimer.start();
            return;
        }

        public function showCharacterMessage(arg1:Number, arg2:String):void
        {
            var loc3:*;

            loc3 = null;
            if (characterCollection[arg1] != null)
            {
                loc3 = characterCollection[arg1];
            }
            else 
            {
                if (arg1 != _myLife.server.getUserId())
                {
                    return;
                }
                else 
                {
                    loc3 = _myLife.player.getCharacter();
                }
            }
            if (arg2.substring(0, 2) != "A:")
            {
                loc3.sayMessage(arg2);
            }
            return;
        }

        private function helpRequestHelpResponse(arg1:MyLife.Events.FactoryEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = NaN;
            loc6 = 0;
            trace("Work Help Help: " + JSON.encode(arg1.eventData));
            loc2 = "Thanks For Helping";
            loc3 = "";
            if (Number(arg1.eventData["success"]) != 0)
            {
                loc4 = ActionTweenType.COIN;
                loc5 = _myLife.getPlayer().getCharacter()["serverUserId"];
                loc6 = Number(arg1.eventData["coinsReceived"]);
                loc3 = "You Helped Your Friend Complete a Job at the Widget Factory and Earned " + loc6 + " Bonus Coins!";
                ActionTweenManager.instance.makeActionTween(loc4, loc5, loc5, {"coins":loc6});
            }
            else 
            {
                loc7 = arg1.eventData["reason"];
                switch (loc7) 
                {
                    case "requestExpired":
                        loc3 = "Thanks for offering to help, but I�ve already gotten all the help I need.\nLet�s help each other again tomorrow!";
                        break;
                    case "alreadyHelped":
                        loc3 = "Thank you for offering to help again, but we can only help each other work once a day.";
                        break;
                    case "requestLimitMax":
                        loc3 = "Thanks for offering to help, but I�ve already worked with 10 friends today.\nLet�s help each other again tomorrow!";
                        break;
                    case "helpRequestsMax":
                        loc3 = "You have already helped 10 friends today.\nCome back tomorrow and help more of your friends.";
                        break;
                    default:
                        loc2 = "Unable To Help";
                        loc3 = "You cannot help yourself.";
                        break;
                }
            }
            _workHelpDialog = _myLife.getInterface().showInterface("WorkHelpDlg", {"title":loc2, "message":loc3, "btnText":"Close"}, true, false, true);
            _workHelpDialog.addEventListener(Event.CLOSE, workHelpCloseHandler);
            _workHelpDialog.btnWork.addEventListener(MouseEvent.CLICK, workHelpCloseHandler);
            return;
        }

        public function setZoneCollision(arg1:flash.display.MovieClip):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = 0;
            loc3 = 0;
            loc4 = null;
            loc5 = undefined;
            loc6 = null;
            if (arg1)
            {
                generateCollisionPaths();
                loc2 = this.currentGridLength;
                loc3 = this.currentGridLength;
                loc7 = 0;
                loc8 = DisplayObjectContainerUtils.getChildren(arg1);
                for each (loc4 in loc8)
                {
                    loc5 = new Position(loc4.x, loc4.y);
                    if (!((loc6 = transformIsoToXy(loc5)).x >= 0 && loc6.y >= 0 && loc6.x < loc2 && loc6.y < loc3))
                    {
                        continue;
                    }
                    _collisionPath.mapMatrix.setxy(loc6.x, loc6.y, 1);
                }
            }
            return;
        }

        public function joinInNewServer():void
        {
            _myLife.server.addEventListener(MyLifeEvent.SERVER_CONNECT, newServerConnectHandler, false, 0, true);
            _myLife.server.reconnect(this.joinInstanceId);
            return;
        }

        public function disableEditMode(arg1:Boolean=false):void
        {
            editMode = false;
            _myLife._interface.interfaceHUD.setMode("homeOwner");
            _myLife.player.disableEditMode();
            _zoneMovie.disableEditMode();
            if (arg1)
            {
                if (MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_FACEBOOK)
                {
                    ShortStoryPublisher.instance.dispatchEvent(new MyLifeEvent(MyLifeEvent.FB_PUBLISH_SHORT_STORY, new ApartmentFeedObject(MyLifeConfiguration.getInstance().playerId, _zoneName)));
                }
            }
            else 
            {
                showAllItemsInZone(true);
                this.zoneItemManager.activateItems();
            }
            return;
        }

        private function startTutorial():void
        {
            _tutorial = _myLife._interface.showInterface("NewUserTutorial");
            _tutorial.addEventListener(Event.COMPLETE, tutorialCompleteHandler);
            _tutorial.addEventListener(Event.CLOSE, tutorialCompleteHandler);
            return;
        }

        public function rejoin(arg1:*=null):void
        {
            trace("rejoin() _zoneName = " + _zoneName);
            this.joinZone = this._zoneName;
            this.joinPosition = 0;
            this.joinInstanceId = this.getCurrentInstanceId();
            this.joinTeleportId = arg1;
            this.joinInNewServer();
            return;
        }

        public function transformIsoToXy(arg1:*):fai.Position
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = this.collisionBlockHeight;
            loc3 = (this.zoneCenterX + loc2) / this.zoneScale;
            loc4 = -this.zoneOffsetY;
            loc5 = new Position();
            loc6 = arg1.x - loc3;
            loc7 = arg1.y - loc4;
            loc5.x = (loc6 + 2 * loc7) / 2;
            loc5.y = 2 * loc7 - loc5.x;
            loc5.x = loc5.x / loc2;
            loc5.y = loc5.y / loc2;
            loc5.x = Math.round(loc5.x);
            loc5.y = Math.round(loc5.y);
            return loc5;
        }

        public function updateCharacterTyping(arg1:Number):void
        {
            var loc2:*;

            if (arg1 == _myLife.server.getUserId())
            {
                return;
            }
            if (characterCollection[arg1] == null)
            {
                return;
            }
            loc2 = characterCollection[arg1];
            loc2.characterIsTyping();
            return;
        }

        private function doResortDepths():void
        {
            if (!_doResortDepthsOnNextTick)
            {
                return;
            }
            _doResortDepthsOnNextTick = false;
            if (_apartmentMode)
            {
                resortDepthsViaDepth();
            }
            else 
            {
                resortDepthsViaY();
            }
            return;
        }

        public function isGameMode():Boolean
        {
            return _gameMode;
        }

        private const detectEventTimeoutDelay:int=5000;

        private const zoneOffsetY:int=150;

        private const defaultGridLength:int=53;

        private const zoneCenterX:int=315;

        private const collisionBlockHeight:int=15;

        private var _gameMode:Boolean=false;

        private var _tutorialActive:Boolean=false;

        private var joinHomeId:int;

        private var currentGridLength:int=53;

        private var _eventQueue:Array;

        private var _joinRequest:Object=null;

        private var renderLayerCollection:Array;

        private var _mainCharacterClip:MyLife.Character;

        private var detectEventTimeoutId:int;

        private var _zoneObj:Object;

        public var currentPlayerHomeRoomId:int;

        private var joinTeleportId:*=null;

        public var joinPosition:Number;

        private var _collisionPath:MyLife.CollisionPath;

        private var newServerZoneName:String;

        public var asyncVisitManager:MyLife.AsyncVisitManager;

        private var isFirstZoneLoad:Boolean=true;

        private var _loadTimer:flash.utils.Timer;

        private var _doResortDepthsOnNextTick:Boolean=false;

        private var _disableReload:Boolean=false;

        private var furnitureLoader:MyLife.AssetListLoader;

        public var characterCollection:Object;

        public var currentPlayerHomeId:int;

        public var currentOwnerPlayerId:int;

        private var depthMapCharacterPositions:Array;

        public var speechBubbleRenderClip:flash.display.MovieClip;

        private var _tutorial:flash.display.MovieClip=null;

        private var _rejoinZone:String="";

        public var editMode:Boolean=false;

        private var joinServerSwithcMessage:String;

        public var zoneRenderClip:flash.display.MovieClip;

        private var suid:*;

        public var zoneScale:Number=1;

        private var _requestedItems:Number=0;

        private var _previousZone:Object=null;

        private var _assetVersionParam:String="";

        public var homeData:Object;

        private var _positionIndex:Number=0;

        private var _zoneInitialized:Boolean=true;

        private var _triggerZones:Array;

        public var _myEventData:Object;

        public var joinInstanceId:String;

        private var loadItemList:Array;

        public var _zoneMovie:flash.display.MovieClip;

        private var _lastEventData:Object;

        public var min_npcs:int=0;

        private var _resortDepthsTimer:flash.utils.Timer;

        public var async_mode:Boolean=false;

        public var npcManager:MyLife.NPC.NPCManager;

        private var _characterCount:int=0;

        private var depthMap:Array;

        private var _levelingItemManager:MyLife.LevelingItemManager;

        private var _tutorialAB:Boolean=false;

        private var _previousHomeData:Object=null;

        private var isOwner:Boolean=false;

        public var max_npcs:int=0;

        public var _zoneName:String="";

        public var actionTweenRenderClip:flash.display.Sprite;

        public var zoneItemManager:MyLife.ZoneItemManager;

        private var resortDepthsCount:int=0;

        public var firstApartmentTour:Boolean=false;

        private var charactersWaitingToEnterZone:Object;

        private var _myLife:MyLife.MyLife;

        private var _teleportArray:Array;

        public var _apartmentMode:Boolean=false;

        private var _workHelpDialog:flash.display.MovieClip;

        public var joinZone:String;
    }
}
