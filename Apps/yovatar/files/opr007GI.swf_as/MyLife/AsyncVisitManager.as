package MyLife 
{
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Events.*;
    import MyLife.Interfaces.*;
    import MyLife.NPC.*;
    import MyLife.Utils.*;
    import fai.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.*;
    
    public class AsyncVisitManager extends flash.events.EventDispatcher
    {
        public function AsyncVisitManager()
        {
            delayedStartTimers = [];
            jokeEmotes = ["E:6", "E:10", "E:14", "E:19", "E:10", "E:14", "E:19", "E:10", "E:14", "E:19"];
            super();
            if (!_instance)
            {
                _npcList = [];
                this.init();
            }
            return;
        }

        private function giftCompleteHandler():void
        {
            this.endGift();
            this.showNPC(selectedFriend["bot"]);
            return;
        }

        private function windowPostNewCommentCanceledHandler(arg1:flash.events.Event):void
        {
            this.selectedAction = "";
            this.showNPC(selectedFriend["bot"]);
            return;
        }

        private function avatarToolTipHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = undefined;
            loc2 = arg1.currentTarget as MovieClip;
            if (loc2)
            {
                loc3 = getNPCObject(null, loc2);
                if (loc3["tooltipImage"])
                {
                    if (arg1.type != MouseEvent.ROLL_OVER)
                    {
                        loc3["bot"].canSpeak = true;
                        TweenLite.to(loc3["tooltipImage"], 0.25, {"alpha":0, "onComplete":toolTipHidden, "onCompleteParams":[loc3["tooltipImage"]]});
                    }
                    else 
                    {
                        loc3["bot"].canSpeak = false;
                        TweenLite.to(loc3["tooltipImage"], 0.5, {"scaleX":1, "scaleY":1, "ease":Bounce.easeOut});
                    }
                }
            }
            return;
        }

        private function startPostMessage():void
        {
            var loc1:*;

            loc1 = myLifeInterface.showInterface("WindowPostNewComment");
            loc1.addEventListener("commentSent", windowPostNewCommentSentHandler, false, 0, true);
            loc1.addEventListener("commentCanceled", windowPostNewCommentCanceledHandler, false, 0, true);
            return;
        }

        private function getNPCDataByPlayerID(arg1:Number, arg2:Boolean=false):Object
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = 0;
            trace("getNPCDataByPlayerID" + arg1);
            loc5 = 0;
            loc6 = _npcList;
            for each (loc3 in loc6)
            {
                trace("npc.id " + loc3.id);
                if (loc3.id != arg1)
                {
                    continue;
                }
                if (arg2 == true)
                {
                    loc4 = _npcList.indexOf(loc3);
                    _npcList.splice(loc4, 1);
                }
                return loc3;
            }
            return null;
        }

        private function startVisit(arg1:*):void
        {
            var loc2:*;

            loc2 = npcManager.addNPC(arg1["data"], onFriendLoaded) as AsyncFriend;
            return;
        }

        private function asyncResponseButtonDecline(arg1:flash.events.MouseEvent):void
        {
            TweenLite.to(_responseDlg, 0.75, {"alpha":0, "onComplete":closeAsyncResponseDlg, "onCompleteParams":[true]});
            _responseDlg.title.visible = false;
            _responseDlg.message.visible = false;
            return;
        }

        public function endPlayerVisit(arg1:Number=-1):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            if (arg1 == -1)
            {
                loc3 = 0;
                loc4 = _npcList;
                for each (loc2 in loc4)
                {
                    endVisit(loc2);
                }
                _npcList.splice(0);
            }
            else 
            {
                loc2 = this.getNPCDataByPlayerID(arg1, true);
                if (loc2 != null)
                {
                    endVisit(loc2);
                }
            }
            if (_npcList.length == 0)
            {
                _newVisitTimer.stop();
                if (_visitMode)
                {
                    myLifeInterface.interfaceHUD.setMode("homeVisitor");
                    _visitMode = false;
                }
                if (this.titleOverlay)
                {
                    this.titleOverlay.closeWindow();
                }
                removeListeners();
                clearTimeout(this.timeoutId);
                this.titleOverlay = null;
            }
            return;
        }

        private function init():void
        {
            AsyncVisitManager._instance = this;
            AsyncVisitManager._linkTracker = new LinkTracker();
            this.myLifeInstance = MyLifeInstance.getInstance();
            this.myLifeInterface = MyLifeInstance.getInstance().getInterface();
            this.myLifeServer = MyLifeInstance.getInstance().getServer();
            this.actionTweenManager = ActionTweenManager.instance;
            this.npcManager = NPCManager.instance;
            _newVisitTimer = new Timer(5000);
            return;
        }

        private function beginVisits(arg1:flash.events.Event=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 0;
            loc3 = 0;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            if (MAX_NPCS)
            {
                loc2 = Math.max(Math.round(Math.random() * MAX_NPCS), MIN_NPCS);
                if (loc2 && _npcList.length)
                {
                    loc2 = loc2 - _npcList.length;
                }
                while (loc2 > 0) 
                {
                    if (loc4 = selectFriendNPC())
                    {
                        loc4.isReplay = false;
                        _npcList.push({"id":loc4.playerId, "data":loc4});
                        loc2 = (loc2 - 1);
                        continue;
                    }
                    loc2 = 0;
                }
                loc3 = 0;
                while (loc3 < _npcList.length) 
                {
                    if (!(loc5 = _npcList[loc3])["data"])
                    {
                        loc5["data"] = FriendDataManager.getAppUserFriendData(loc5["id"]);
                    }
                    if (loc5["data"])
                    {
                        loc5["data"]["type"] = NPCManager.TYPE_ASYNC_FRIEND;
                        if (loc3 == 0 || !_useRezInAnim)
                        {
                            startVisit(loc5);
                        }
                        else 
                        {
                            loc6 = new DataTimer(loc5, 2000 * loc3, 1);
                            delayedStartTimers.push(loc6);
                            loc6.addEventListener(TimerEvent.TIMER, startVisitTimerEvent);
                            loc6.start();
                        }
                    }
                    else 
                    {
                        _npcList.splice(loc3, 1);
                        loc3 = (loc3 - 1);
                    }
                    ++loc3;
                }
            }
            return;
        }

        private function sendActionCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = false;
            loc3 = NaN;
            myLifeServer.removeEventListener(MyLifeEvent.SEND_ACTION_COMPLETE, sendActionCompleteHandler);
            if (arg1.eventData)
            {
                loc2 = Boolean(Number(arg1.eventData.success || 0));
                loc3 = Number(arg1.eventData.actionType);
                if (loc2 && loc3)
                {
                    checkReward(int(loc3));
                }
            }
            return;
        }

        private function tellJokeToNPC(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = ["E:24", ""];
            loc3 = null;
            loc4 = false;
            loc5 = Math.random() * 100 % jokeEmotes.length;
            loc3 = jokeEmotes[loc5];
            loc2.push(loc3);
            loc4 = loc3 == "E:6";
            while (loc3 == jokeEmotes[loc5] || jokeEmotes[loc5] == "E:6") 
            {
                loc5 = Math.random() * 100 % jokeEmotes.length;
            }
            loc2[1] = jokeEmotes[loc5];
            if (!loc4)
            {
                loc4 = !(int(Math.random() * 100) % 5 == 1);
            }
            (loc6 = new DataTimer({"npc":arg1["bot"], "joke":loc2, "funny":loc4}, 500, 19)).addEventListener(TimerEvent.TIMER, laughTimerHandler);
            loc6.addEventListener(TimerEvent.TIMER_COMPLETE, laughTimerComplete);
            loc6.start();
            return;
        }

        public function initReplay(arg1:Number, arg2:Number, arg3:String=null):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = 0;
            loc9 = null;
            loc10 = null;
            if (loc4 = FriendDataManager.getAppUserFriendData(arg1))
            {
                loc5 = null;
                loc6 = null;
                loc7 = this.myLifeInstance.getPlayer().getCharacter()._characterName;
                loc11 = int(arg2);
                switch (loc11) 
                {
                    case this.myLifeServer.ACTION_MANAGER_TYPE_GIFT:
                        loc5 = "gift";
                        loc6 = loc4.name + " gave " + loc7 + " a gift! Getting gifts is almost as fun as giving them.";
                        break;
                    case this.myLifeServer.ACTION_MANAGER_TYPE_MESSAGE:
                        loc5 = "message";
                        loc6 = loc4.name + " left " + loc7 + " a message. It’s nice to hear from your friends!";
                        break;
                    case this.myLifeServer.ACTION_MANAGER_TYPE_FIGHT:
                        loc5 = "fight";
                        loc6 = "Looks like " + loc4.name + " and " + loc7 + " were fighting. Let\'s hope they make up soon!";
                        break;
                    case this.myLifeServer.ACTION_MANAGER_TYPE_KISS:
                        loc5 = "kiss";
                        loc6 = loc4.name + " gave " + loc7 + " a kiss. Isn’t it nice when friends share a special moment together?";
                        break;
                    case this.myLifeServer.ACTION_MANAGER_TYPE_DANCE:
                        loc5 = "dance";
                        loc6 = loc4.name + " and " + loc7 + " boogied down together! Dancing with your friends is fun.";
                        break;
                    case myLifeServer.ACTION_MANAGER_TYPE_JOKE:
                        loc5 = AsyncFriend.ACTION_JOKE;
                        loc6 = loc4.name + " told " + loc7 + " a joke. See how hard you both laughed!";
                        break;
                    case myLifeServer.ACTION_MANAGER_TYPE_ANIMATION:
                        loc5 = AsyncFriend.ACTION_ANIMATION;
                        loc8 = MyLifeConfiguration.getInstance().variables["querystring"]["level"];
                        loc6 = loc4.name + " learned some sweet moves. Reach level " + loc8 + ", and you can do it, too!";
                }
                if (loc5 && loc6)
                {
                    (loc9 = {}).action = loc5;
                    loc9.title = loc6;
                    titleOverlay = myLifeInterface.showInterface("MyLife.Interfaces.TitleOverlay", {"title":""});
                    loc4.isReplay = true;
                    loc4.type = NPCManager.TYPE_ASYNC_FRIEND;
                    loc4.replayAction = loc9;
                    loc10 = npcManager.addNPC(loc4) as AsyncFriend;
                    selectedFriend = {"id":arg1, "data":loc4, "bot":loc10};
                    _npcList.push(selectedFriend);
                    loc10.addEventListener("actionComplete", npcActionCompleteHandler, false, 0, true);
                    this.myLifeInterface.interfaceHUD.setMode("homeVisitorAsyncMenu");
                }
                this.addListeners();
                if (!loc10 || !loc10.rezIn())
                {
                    endVisit(_npcList[(_npcList.length - 1)], true);
                }
            }
            return;
        }

        public function initVisit(arg1:Number=-1, arg2:Boolean=true, arg3:Object=null):Boolean
        {
            var loc4:*;

            loc4 = false;
            _useRezInAnim = arg2;
            _trackingLinks = arg3 || _asyncActionTracking;
            if (_responseDlg)
            {
                closeAsyncResponseDlg();
            }
            if (_messagesDlg)
            {
                closeMessagesDlg();
            }
            if (arg1 == -1)
            {
                _npcList.splice(0);
                activeCount = 0;
                MAX_NPCS = myLifeInstance.getZone()["max_npcs"];
                MIN_NPCS = myLifeInstance.getZone()["min_npcs"];
            }
            else 
            {
                MAX_NPCS = 1;
                MIN_NPCS = 1;
                activeCount = 1;
                selectedFriend = {"id":arg1, "data":null};
                _npcList.push(selectedFriend);
                _visitMode = true;
            }
            if (FriendDataManager.ready)
            {
                beginVisits();
            }
            else 
            {
                FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, beginVisits);
            }
            return loc4;
        }

        private function laughTimerComplete(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as DataTimer;
            loc2.removeEventListener(TimerEvent.TIMER, laughTimerHandler);
            loc2.removeEventListener(TimerEvent.TIMER_COMPLETE, laughTimerComplete);
            myLifeInstance.player._character.sayMessage("", true);
            if (loc2.data)
            {
                loc2.data.npc.sayMessage("", true);
            }
            loc2.data = null;
            callSendActionExtension("joke");
            return;
        }

        private function addListeners():void
        {
            var loc1:*;

            if (_newVisitTimer)
            {
                _newVisitTimer.addEventListener(TimerEvent.TIMER, newVisitTimerHandler);
            }
            this.actionTweenManager.addEventListener(ActionTweenEvent.COMPLETE, actionTweenEventCompleteHandler, false, 0, true);
            loc1 = myLifeInterface.interfaceHUD.waterBalloonManager;
            loc1.addEventListener(Event.COMPLETE, waterBalloonCompleteHandler);
            return;
        }

        private function giftCancelHandler():void
        {
            this.selectedAction = "";
            this.showNPC(selectedFriend["bot"]);
            return;
        }

        public function doSelectedAction(arg1:Object):void
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

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            if (arg1 && arg1["bot"])
            {
                loc2 = arg1.bot;
                if (selectedFriend && !selectedFriend["data"].isReplay)
                {
                    loc3 = null;
                    loc4 = null;
                    loc11 = this.selectedAction;
                    switch (loc11) 
                    {
                        case "fight":
                            loc3 = _trackingLinks.fight.link;
                            loc4 = _trackingLinks.fight.client;
                            loc2.waterBalloonTarget();
                            this.throwWaterballoonFromPlayerToNPC(loc2);
                            showNPC(loc2);
                            break;
                        case "kiss":
                            loc3 = _trackingLinks.kiss.link;
                            loc4 = _trackingLinks.kiss.client;
                            this.sendKissFromPlayerToNPC(loc2);
                            showNPC(loc2);
                            break;
                        case "joke":
                            loc3 = _trackingLinks.joke.link;
                            loc4 = _trackingLinks.joke.client;
                            tellJokeToNPC(arg1);
                            break;
                        case "dance":
                            loc3 = _trackingLinks.dance.link;
                            loc4 = _trackingLinks.dance.client;
                            this.startDance(loc2);
                            this.callSendActionExtension("dance");
                            showNPC(loc2);
                            break;
                        case "message":
                            this.startPostMessage();
                            break;
                        case "gift":
                            this.startGift();
                            break;
                    }
                    if (loc3 && loc4)
                    {
                        trackAction(loc3, loc4);
                    }
                }
                else 
                {
                    loc5 = arg1["data"]["replayAction"]["action"];
                    if ((loc6 = arg1["data"]["replayAction"]["title"]) && titleOverlay)
                    {
                        titleOverlay.titleTextField.text = loc6;
                    }
                    loc11 = loc5;
                    switch (loc11) 
                    {
                        case "fight":
                            loc2.throwWaterballoonFromNPCToPlayer();
                            break;
                        case "kiss":
                            loc2.sendKissFromNPCToPlayer();
                            break;
                        case "dance":
                            startDance(loc2);
                            break;
                        case "message":
                            delete arg1["data"]["replayAction"];
                            _showMessageDlg = true;
                            loc2.sendMessageFromNPCToPlayer();
                            break;
                        case "gift":
                            delete arg1["data"]["replayAction"];
                            loc2.sendGiftFromNPCToPlayer();
                            break;
                        case AsyncFriend.ACTION_JOKE:
                            loc2.tellJokeToPlayer();
                            break;
                        case AsyncFriend.ACTION_ANIMATION:
                            loc7 = MyLifeConfiguration.getInstance().variables["querystring"]["anim"];
                            loc8 = "action:" + loc7;
                            loc9 = {"metaData":loc8, "filename":loc7};
                            loc10 = ActionLibrary.makeAnimItem(loc9);
                            loc2.setAvatarAction(loc10);
                            loc2.doAction(AsyncFriend.ACTION_ANIMATION);
                            break;
                    }
                }
            }
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:Object):void
        {
            if (arg1 && arg2)
            {
                arg2.addImage(arg1);
            }
            return;
        }

        public function endReplay():void
        {
            if (selectedFriend)
            {
                this.timeoutId = setTimeout(selectedFriend["bot"].rezOut, 2000);
            }
            return;
        }

        private function removeListeners():void
        {
            var loc1:*;

            if (_newVisitTimer)
            {
                _newVisitTimer.removeEventListener(TimerEvent.TIMER, newVisitTimerHandler);
            }
            this.actionTweenManager.removeEventListener(ActionTweenEvent.COMPLETE, actionTweenEventCompleteHandler);
            loc1 = myLifeInterface.interfaceHUD.waterBalloonManager;
            loc1.removeEventListener(Event.COMPLETE, waterBalloonCompleteHandler);
            return;
        }

        private function playerInPosition(arg1:flash.events.Event):void
        {
            arg1.currentTarget.removeEventListener(SimpleNPC.CHARACTER_STOPPED, playerInPosition);
            if (selectedFriend)
            {
                if (arg1.currentTarget.x > selectedFriend.bot.x)
                {
                    Character(arg1.currentTarget).avatarActionManager.changeDirection(parseInt(AnimationAction.STAND_LEFT_FRONT));
                    AsyncFriend(selectedFriend.bot).doAvatarAction(AnimationAction.STAND_RIGHT_FRONT);
                }
                else 
                {
                    Character(arg1.currentTarget).avatarActionManager.changeDirection(parseInt(AnimationAction.STAND_RIGHT_FRONT));
                    AsyncFriend(selectedFriend.bot).doAvatarAction(AnimationAction.STAND_LEFT_FRONT);
                }
                doSelectedAction(selectedFriend);
            }
            return;
        }

        private function endVisit(arg1:*, arg2:Boolean=false):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = 0;
            loc4 = null;
            loc5 = null;
            if (arg1)
            {
                loc3 = 0;
                while (loc3 < delayedStartTimers.length) 
                {
                    if ((loc4 = delayedStartTimers[loc3] as DataTimer).data == arg1)
                    {
                        loc4.removeEventListener(TimerEvent.TIMER_COMPLETE, startVisitTimerEvent);
                        loc4.stop();
                        delayedStartTimers.splice(loc3, 1);
                        break;
                    }
                    ++loc3;
                }
                if (arg1["data"])
                {
                    if (arg1["data"].isReplay)
                    {
                        if (this.titleOverlay)
                        {
                            this.titleOverlay.closeWindow();
                            titleOverlay = null;
                        }
                        MyLifeInstance.getInstance().getInterface().interfaceHUD.setMode("homeOwner");
                        if (arg1["data"]["replayAction"])
                        {
                            loc5 = arg1["data"]["replayAction"]["action"];
                            showAsyncResponseDlg(loc5, arg1);
                            delete arg1["data"]["replayAction"];
                        }
                        else 
                        {
                            if (_showMessageDlg)
                            {
                                showMessagesDlg();
                            }
                            else 
                            {
                                if (arg2)
                                {
                                    myLifeInstance.displayStartUpDialogs();
                                }
                            }
                        }
                    }
                    else 
                    {
                        lastPlayerId = arg1["data"].playerId;
                    }
                }
                if (selectedFriend == arg1)
                {
                    selectedFriend = null;
                    selectedAction = "";
                    if (asyncActionInterface)
                    {
                        asyncActionInterface.closeWindow();
                    }
                }
                if (arg1["bot"])
                {
                    arg1["bot"].removeEventListener("actionComplete", npcActionCompleteHandler);
                    arg1["bot"].disable();
                    arg1["bot"] = null;
                }
                if (arg1["tooltipImage"])
                {
                    if (arg1["tooltipImage"].parent)
                    {
                        arg1["tooltipImage"].parent.removeChild(arg1["tooltipImage"]);
                    }
                    arg1["tooltipImage"].cleanUp();
                    arg1["avatar"].removeEventListener(MouseEvent.ROLL_OVER, avatarToolTipHandler);
                    arg1["avatar"].removeEventListener(MouseEvent.ROLL_OUT, avatarToolTipHandler);
                    arg1["tooltipImage"] = null;
                }
                if (arg1["avatar"])
                {
                    arg1["avatar"].removeEventListener(MouseEvent.CLICK, npcClickHandler);
                }
            }
            return;
        }

        private function sendKissFromPlayerToNPC(arg1:MyLife.NPC.AsyncFriend):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = ActionTweenType.KISS;
            loc3 = MyLifeInstance.getInstance().getPlayer().getCharacter()["serverUserId"];
            loc4 = arg1.serverUserId;
            actionTweenManager.makeActionTween(loc2, loc3, loc4);
            return;
        }

        private function showMessagesDlg():void
        {
            MyLifeInstance.getInstance().getInterface().interfaceHUD.unreadMessageCount = 0;
            _showMessageDlg = false;
            _messagesDlg = MyLifeInstance.getInstance().getInterface().showInterface("WindowReadMessages", {});
            _messagesDlg.addEventListener(Event.CLOSE, messageDlgCloseHandler);
            return;
        }

        private function messageDlgCloseHandler(arg1:flash.events.Event):void
        {
            closeMessagesDlg();
            return;
        }

        private function windowPostNewCommentSentHandler(arg1:flash.events.Event):void
        {
            if (selectedFriend && selectedFriend["bot"].isRezzedIn)
            {
                this.endPostMessage();
            }
            showNPC(selectedFriend["bot"]);
            return;
        }

        private function showNPC(arg1:MyLife.NPC.AsyncFriend):void
        {
            if (arg1 && !arg1.isRezzedIn)
            {
                arg1.rezIn();
            }
            if (_visitMode)
            {
                this.myLifeInterface.interfaceHUD.setMode("homeVisitor");
            }
            return;
        }

        private function removeAsyncActionListeners():void
        {
            if (asyncActionInterface)
            {
                asyncActionInterface.removeEventListener(Event.CANCEL, asyncActionInterfaceCancelHandler);
                asyncActionInterface.removeEventListener(asyncActionInterface.EVENT_ACTION_BUTTON_CLICK, asyncActionInterfaceClickHandler);
                asyncActionInterface = null;
            }
            return;
        }

        private function startGift():void
        {
            var loc1:*;

            loc1 = {};
            loc1.giftData = {};
            loc1.giftData.recipientPlayerId = selectedFriend["data"].playerId;
            loc1.giftData.recipientName = selectedFriend["data"].name;
            loc1.giftData.onComplete = giftCompleteHandler;
            loc1.giftData.onCancel = giftCancelHandler;
            loc1.giftData.isAsyncVisit = true;
            myLifeInterface.showInterface("GiftStepInventory", loc1);
            return;
        }

        private function onFriendLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = null;
            loc5 = false;
            loc2 = arg1.eventData as AsyncFriend;
            if (loc2)
            {
                loc2.removeEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, onFriendLoaded);
                loc3 = getNPCDataByPlayerID(loc2.myLifePlayerId);
                if (!loc3)
                {
                    loc2.disable();
                    loc2 = null;
                    return;
                }
                loc2.addEventListener("actionComplete", npcActionCompleteHandler, false, 0, true);
                if (loc4 = loc2.getAvatarClip())
                {
                    if (loc3["data"] && loc3["data"]["pic_url"])
                    {
                        loc3["tooltipImage"] = new ProfileImage();
                        AssetsManager.getInstance().loadImage(loc3["data"]["pic_url"], loc3["tooltipImage"], imageLoadedCallback);
                        loc3["tooltipImage"].scaleX = 0;
                        loc3["tooltipImage"].scaleY = 0;
                        loc4.addEventListener(MouseEvent.ROLL_OVER, avatarToolTipHandler);
                        loc4.addEventListener(MouseEvent.ROLL_OUT, avatarToolTipHandler);
                        loc3["tooltipImage"].y = -loc4.height - 25;
                        loc4.parent.addChild(loc3["tooltipImage"]);
                    }
                    loc4.addEventListener(MouseEvent.CLICK, npcClickHandler, false, 0, true);
                    loc3["avatar"] = loc4;
                }
                if (!(loc3["data"]["playerId"] == lastPlayerId) && _visitMode)
                {
                    myLifeInterface.interfaceHUD.setMode("homeVisitorAsyncMenu");
                }
                addListeners();
                if (loc5 = loc2.rezIn(_useRezInAnim))
                {
                    if (!selectedFriend || !(selectedFriend.id == loc2.myLifePlayerId))
                    {
                        loc2.setDelayedAction("idle", 1500);
                        showNPC(loc2);
                    }
                }
                else 
                {
                    disabledPlayerId = loc3["data"]["playerId"];
                    endVisit(loc3);
                    loc2 = null;
                }
                loc3["bot"] = loc2;
            }
            return;
        }

        private function startVisitTimerEvent(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget as DataTimer;
            loc2.removeEventListener(TimerEvent.TIMER_COMPLETE, startVisitTimerEvent);
            loc2.stop();
            loc3 = delayedStartTimers.indexOf(loc2);
            if (loc3 != -1)
            {
                delayedStartTimers.splice(loc3, 1);
            }
            startVisit(loc2.data);
            loc2.data = null;
            return;
        }

        private function waterBalloonCompleteHandler(arg1:flash.events.Event):void
        {
            if (selectedFriend && selectedFriend["data"].isReplay)
            {
                this.endReplay();
            }
            return;
        }

        private function selectFriendNPC():Object
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = 0;
            loc4 = undefined;
            loc1 = null;
            loc2 = FriendDataManager.getAppUserFriendData(0, true) as Array;
            while (loc2.length && loc1 == null) 
            {
                loc3 = Math.floor(Math.random() * loc2.length);
                loc1 = (loc3 + 1 != loc2.length) ? loc2.slice(loc3, loc3 + 1)[0] : loc2.slice(loc3)[0];
                loc2.splice(loc3, 1);
                if (loc1 && !(loc1.playerId == MyLifeConfiguration.getInstance().playerId))
                {
                    loc5 = 0;
                    loc6 = _npcList;
                    for each (loc4 in loc6)
                    {
                        if (loc1.playerId != loc4.id)
                        {
                            continue;
                        }
                        loc1 = null;
                        break;
                    }
                    continue;
                }
                loc1 = null;
            }
            return loc1;
        }

        private function asyncActionInterfaceClickHandler(arg1:flash.events.Event):void
        {
            this.selectedAction = this.asyncActionInterface.currentSelectedAction;
            this.asyncActionInterface.closeWindow();
            this.doSelectedAction(selectedFriend);
            return;
        }

        public function disableVisit(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = 0;
            loc5 = null;
            if (this.asyncActionInterface)
            {
                this.asyncActionInterface.closeWindow();
            }
            if (_visitMode)
            {
                this.myLifeInterface.interfaceHUD.setMode("homeVisitor");
            }
            while (loc4 < _npcList.length) 
            {
                loc3 = _npcList[loc4];
                if (loc3.id == arg1)
                {
                    loc2 = loc3["bot"] as AsyncFriend;
                    break;
                }
                ++loc4;
            }
            if (loc2 && loc2.isRezzedIn)
            {
                loc2.rezOut();
                if (loc5 = loc2.getAvatarClip())
                {
                    loc5.removeEventListener(MouseEvent.CLICK, npcClickHandler);
                }
            }
            else 
            {
                endVisit(loc3);
            }
            disabledPlayerId = arg1;
            return;
        }

        private function asyncActionInterfaceCancelHandler(arg1:flash.events.Event=null):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = undefined;
            if (asyncActionInterface && asyncActionInterface.playerId && asyncActionInterface.playerId == MyLifeInstance.getInstance().getZone().getApartmentOwnerPlayerId())
            {
                loc3 = getNPCObject(null, null, asyncActionInterface.playerId);
                if (loc3)
                {
                    loc2 = loc3["bot"];
                }
                asyncActionInterface.closeWindow();
                if (loc2)
                {
                    loc2.setDelayedAction("sayStatus", 500);
                }
            }
            return;
        }

        private function actionTweenEventCompleteHandler(arg1:MyLife.Events.ActionTweenEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            if (arg1.data && arg1.data.type)
            {
                if (selectedFriend && selectedFriend["data"] && !selectedFriend["data"].isReplay)
                {
                    loc2 = selectedFriend["bot"];
                    loc3 = arg1.data.type;
                    switch (loc3) 
                    {
                        case ActionTweenType.GIFT:
                            this.checkReward(this.myLifeServer.ACTION_MANAGER_TYPE_GIFT);
                            this.callSendActionExtension(arg1.data.type);
                            break;
                        case ActionTweenType.KISS:
                        case ActionTweenType.MESSAGE:
                            loc2.faceDirection(1);
                            loc2.sayEmoticon(11);
                            this.callSendActionExtension(arg1.data.type);
                            break;
                    }
                }
                else 
                {
                    this.endReplay();
                }
            }
            return;
        }

        private function endGift():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = ActionTweenType.GIFT;
            loc2 = MyLifeInstance.getInstance().getPlayer().getCharacter()["serverUserId"];
            loc3 = selectedFriend["bot"].serverUserId;
            actionTweenManager.makeActionTween(loc1, loc2, loc3);
            trackAction(_trackingLinks.gift.link, _trackingLinks.gift.client);
            return;
        }

        private function addAsyncActionListeners():void
        {
            asyncActionInterface.addEventListener(Event.CANCEL, asyncActionInterfaceCancelHandler, false, 0, true);
            asyncActionInterface.addEventListener(asyncActionInterface.EVENT_ACTION_BUTTON_CLICK, asyncActionInterfaceClickHandler, false, 0, true);
            asyncActionInterface.addEventListener(Event.CLOSE, asyncActionInterfaceClosed);
            return;
        }

        private function npcClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = undefined;
            loc2 = arg1.currentTarget as MovieClip;
            if (loc2)
            {
                loc3 = getNPCObject(null, loc2);
                if (loc3 != selectedFriend)
                {
                    asyncActionInterfaceCancelHandler();
                    selectedFriend = loc3;
                }
                if (loc3["bot"].isRezzedIn)
                {
                    arg1.stopPropagation();
                    this.showAsyncActionUI(loc3);
                }
            }
            return;
        }

        private function callSendActionExtension(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = 0;
            loc4 = null;
            loc3 = 0;
            loc5 = arg1;
            switch (loc5) 
            {
                case "gift":
                    loc3 = 500;
                    break;
                case "message":
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_MESSAGE"];
                    loc3 = 11000;
                    break;
                case "fight":
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_FIGHT"];
                    loc3 = 11000;
                    break;
                case "kiss":
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_KISS"];
                    loc3 = 11000;
                    break;
                case "dance":
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_DANCE"];
                    loc3 = 10500;
                    break;
                case "joke":
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_JOKE"];
                    loc3 = 500;
                    break;
                default:
                    loc2 = myLifeServer["ACTION_MANAGER_TYPE_NONE"];
                    loc3 = 500;
                    break;
            }
            if (loc2 && selectedFriend)
            {
                (loc4 = {}).recipientPlayerId = selectedFriend["data"].playerId;
                loc4.actionType = loc2;
                myLifeServer.addEventListener(MyLifeEvent.SEND_ACTION_COMPLETE, sendActionCompleteHandler, false, 0, true);
                myLifeServer.callExtension("ActionManager.sendAction", loc4);
            }
            if (!(this.selectedFriend["bot"] as AsyncFriend).saidStatus)
            {
                (this.selectedFriend["bot"] as AsyncFriend).setDelayedAction("sayStatus", loc3);
            }
            return;
        }

        private function asyncActionInterfaceClosed(arg1:flash.events.Event):void
        {
            var loc2:*;

            myLifeInstance.hideDialog(asyncActionInterface);
            loc2 = _visitMode ? "homeVisitor" : myLifeInstance.getZone()._apartmentMode ? "homeOwner" : "mapVisitor";
            this.myLifeInterface.interfaceHUD.setMode(loc2);
            removeAsyncActionListeners();
            asyncActionInterface = null;
            return;
        }

        private function checkReward(arg1:int):void
        {
            myLifeInstance.getServer().sendNotification(arg1, selectedFriend["data"].playerId);
            return;
        }

        private function getNPCObject(arg1:MyLife.NPC.SimpleNPC=null, arg2:flash.display.MovieClip=null, arg3:Number=-1):Object
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = undefined;
            loc4 = null;
            loc6 = arg1 ? 0 : arg2 ? 1 : 2;
            loc7 = false;
            loc8 = 0;
            while (loc8 < _npcList.length) 
            {
                loc5 = _npcList[loc8];
                loc9 = loc6;
                switch (loc9) 
                {
                    case 0:
                        loc7 = loc5["bot"] == arg1;
                        break;
                    case 1:
                        loc7 = loc5["avatar"] == arg2;
                        break;
                    case 2:
                        loc7 = loc5["id"] == arg3;
                        break;
                }
                if (loc7)
                {
                    loc4 = loc5;
                    break;
                }
                ++loc8;
            }
            return loc4;
        }

        private function closeAsyncResponseDlg(arg1:Boolean=false):void
        {
            if (_responseDlg)
            {
                _responseDlg.asyncFriend = null;
                _responseDlg.btnClose.removeEventListener(MouseEvent.CLICK, asyncResponseButtonDecline);
                _responseDlg.btnStay.removeEventListener(MouseEvent.CLICK, asyncResponseButtonDecline);
                _responseDlg.btnDance.removeEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                _responseDlg.btnFight.removeEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                _responseDlg.btnKiss.removeEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                _responseDlg.btnJoke.removeEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                MyLifeInstance.getInstance().hideDialog(_responseDlg);
                _responseDlg = null;
            }
            if (arg1)
            {
                myLifeInstance.displayStartUpDialogs();
            }
            return;
        }

        private function throwWaterballoonFromPlayerToNPC(arg1:MyLife.NPC.AsyncFriend):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = MyLifeInstance.getInstance().getPlayer().getCharacter();
            loc3 = loc2.serverUserId;
            loc4 = arg1.x;
            loc5 = arg1.y;
            (loc6 = myLifeInterface.interfaceHUD.waterBalloonManager).throwNewBalloon(loc3, loc4, loc5);
            return;
        }

        private function asyncResponseButtonAccept(arg1:flash.events.MouseEvent):void
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
            loc6 = false;
            loc7 = null;
            loc8 = 0;
            loc2 = _responseDlg.asyncFriend;
            loc3 = loc2["data"]["player_home_room"];
            closeAsyncResponseDlg();
            trackAction("1934", "1529");
            if (loc3 > 0)
            {
                MyLifeInstance.getInstance().getZone().joinHomeRoom(0, loc2["id"], loc3, 1);
            }
            else 
            {
                if (loc6 = (loc5 = loc2["data"]["room"]).charAt(0) == "H")
                {
                    loc7 = (loc5 = loc5.substr(1)).split("-");
                    loc8 = int(loc7[0]);
                    MyLifeInstance.getInstance().getZone().joinHomeRoom(0, loc2["id"], loc8, 1);
                }
                else 
                {
                    loc4 = "AP" + loc5 + "-" + loc2["id"];
                    MyLifeInstance.getInstance().getZone().join(loc4, 0);
                }
            }
            return;
        }

        private function showAsyncResponseDlg(arg1:String, arg2:*):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = arg2["data"].name;
            _responseDlg = new AsyncResponseInterface();
            _responseDlg.btnClose.addEventListener(MouseEvent.CLICK, asyncResponseButtonDecline);
            _responseDlg.btnStay.addEventListener(MouseEvent.CLICK, asyncResponseButtonDecline);
            _responseDlg.title.text = "Respond to " + loc3 + "?";
            _responseDlg.asyncFriend = arg2;
            loc4 = arg1;
            switch (loc4) 
            {
                case AsyncFriend.ACTION_ANIMATION:
                case "dance":
                    _responseDlg.message.text = "Would you like to bust a move back with " + loc3 + "?";
                    _responseDlg.btnDance.visible = true;
                    _responseDlg.btnDance.addEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                    break;
                case "fight":
                    _responseDlg.message.text = "Would you like to challenge " + loc3 + " again?";
                    _responseDlg.btnFight.visible = true;
                    _responseDlg.btnFight.addEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                    break;
                case "kiss":
                    _responseDlg.message.text = "Would you like to go kiss " + loc3 + " back?";
                    _responseDlg.btnKiss.visible = true;
                    _responseDlg.btnKiss.addEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                    break;
                case "joke":
                    _responseDlg.message.text = "Think you can tell " + loc3 + " a better joke?";
                    _responseDlg.btnJoke.visible = true;
                    _responseDlg.btnJoke.addEventListener(MouseEvent.CLICK, asyncResponseButtonAccept);
                    break;
            }
            MyLifeInstance.getInstance().showDialog(_responseDlg, true);
            return;
        }

        private function trackAction(arg1:String, arg2:String):void
        {
            if (_linkTracker && !myLifeInstance.runningLocal && MyLifeInstance.getInstance().myLifeConfiguration.platformType == "platformFacebook")
            {
                _linkTracker.setRandomActive();
                _linkTracker.track(arg1, arg2);
            }
            return;
        }

        public function clearDisabledPlayerId():void
        {
            this.disabledPlayerId = 0;
            return;
        }

        private function makeTitleOverlay(arg1:String):void
        {
            return;
        }

        private function showAsyncActionUI(arg1:Object=null):void
        {
            arg1 = arg1 || selectedFriend;
            if (!this.asyncActionInterface && arg1)
            {
                arg1["bot"].doAction("idle", false);
                asyncActionInterface = new AsyncActionInterface();
                asyncActionInterface.initialize(myLifeInstance, arg1["data"]);
                myLifeInstance.showDialog(asyncActionInterface, true);
                asyncActionInterface.show();
                if (asyncActionInterface)
                {
                    addAsyncActionListeners();
                }
                if (_visitMode)
                {
                    myLifeInterface.interfaceHUD.setMode("homeVisitorAsyncMenu");
                }
            }
            return;
        }

        private function endPostMessage():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = ActionTweenType.MESSAGE;
            loc2 = MyLifeInstance.getInstance().getPlayer().getCharacter()["serverUserId"];
            loc3 = selectedFriend["bot"].serverUserId;
            actionTweenManager.makeActionTween(loc1, loc2, loc3);
            trackAction(_trackingLinks.message.link, _trackingLinks.message.client);
            return;
        }

        private function laughTimerHandler(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc2 = arg1.currentTarget as DataTimer;
            loc4 = loc2.currentCount;
            switch (loc4) 
            {
                case 1:
                    myLifeInstance.player._character.sayMessage(loc2.data.joke[0], true);
                    break;
                case 2:
                case 3:
                case 4:
                case 6:
                case 7:
                case 8:
                case 10:
                    break;
                case 11:
                    myLifeInstance.player._character.sayMessage("", true);
                    break;
                case 5:
                    myLifeInstance.player._character.sayMessage(loc2.data.joke[1], true);
                    break;
                case 9:
                    myLifeInstance.player._character.sayMessage(loc2.data.joke[2], true);
                    break;
                default:
                    loc3 = (loc2.currentCount % 2) ? "E:22" : "E:11";
                    myLifeInstance.player._character.sayMessage(loc3, true);
                    if (loc2.data)
                    {
                        loc2.data.npc.sayMessage(loc2.data.funny ? loc3 : "E:18", true);
                    }
                    break;
            }
            return;
        }

        private function startDance(arg1:MyLife.NPC.AsyncFriend):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = 10000;
            loc3 = MyLifeInstance.getInstance().getPlayer().getCharacter();
            loc4 = loc3.doRandomDance();
            if (selectedFriend && arg1 && !selectedFriend["data"].isReplay)
            {
                arg1.doAction("dance");
            }
            else 
            {
                if (arg1)
                {
                    arg1.dance(loc4);
                    this.timeoutId = setTimeout(this.endReplay, loc2);
                }
            }
            return;
        }

        private function npcActionCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = undefined;
            loc4 = undefined;
            loc5 = NaN;
            loc2 = arg1.currentTarget as AsyncFriend;
            if (loc2)
            {
                loc3 = getNPCObject(loc2);
                if (loc3 && loc3["data"].isReplay)
                {
                    if (loc2.currentAction == AsyncFriend.ACTION_REZ_IN && loc3["data"]["replayAction"])
                    {
                        loc5 = ((loc4 = myLifeInstance.player._character).x > loc2.x) ? loc2.x + 150 : loc2.x - 150;
                        trace("x " + loc5);
                        loc4.moveTo(new Position(loc5, loc2.y));
                        loc4.addEventListener(SimpleNPC.CHARACTER_STOPPED, playerInPosition);
                    }
                    else 
                    {
                        if (loc2.currentAction != AsyncFriend.ACTION_REZ_OUT)
                        {
                            endReplay();
                        }
                        else 
                        {
                            this.endVisit(loc3, true);
                        }
                    }
                }
                else 
                {
                    if (loc3)
                    {
                        loc6 = loc2.currentAction;
                        switch (loc6) 
                        {
                            case AsyncFriend.ACTION_REZ_IN:
                                if (loc3["data"].playerId == this.lastPlayerId)
                                {
                                    loc2.doAction(AsyncFriend.ACTION_IDLE);
                                }
                                else 
                                {
                                    if (MissionManager.isOnMission)
                                    {
                                        dispatchEvent(new MyLifeEvent(MyLifeEvent.ASYNC_AVATAR_LOADED, loc3));
                                    }
                                    else 
                                    {
                                        this.showAsyncActionUI();
                                    }
                                }
                                break;
                            case AsyncFriend.ACTION_REZ_OUT:
                                this.endVisit(loc3, loc3["data"].isReplay);
                                break;
                            case AsyncFriend.ACTION_REACT_WATERBALLOON:
                                this.callSendActionExtension("fight");
                                break;
                            default:
                                loc2.doAction(AsyncFriend.ACTION_IDLE);
                                break;
                        }
                    }
                }
            }
            return;
        }

        private function closeMessagesDlg():void
        {
            _messagesDlg.removeEventListener(Event.CLOSE, messageDlgCloseHandler);
            _messagesDlg = null;
            myLifeInstance.displayStartUpDialogs();
            return;
        }

        private function newVisitTimerHandler(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (_npcList.length < MAX_NPCS)
            {
                if (Math2.random(10, 1) == 1)
                {
                    loc2 = selectFriendNPC();
                    loc3 = {};
                    if (loc2)
                    {
                        loc3.id = loc2.playerId;
                        loc3.data = loc2;
                        loc3["data"]["type"] = NPCManager.TYPE_ASYNC_FRIEND;
                        startVisit(loc3);
                    }
                }
            }
            return;
        }

        private function toolTipHidden(arg1:flash.display.MovieClip):void
        {
            arg1.scaleX = 0;
            arg1.scaleY = 0;
            arg1.alpha = 1;
            return;
        }

        public static function get instance():MyLife.AsyncVisitManager
        {
            if (!AsyncVisitManager._instance)
            {
                new AsyncVisitManager();
            }
            return AsyncVisitManager._instance;
        }

        
        {
            MAX_NPCS = 1;
            MIN_NPCS = 1;
            activeCount = 0;
            _visitMode = false;
            _useRezInAnim = true;
        }

        private const _asyncActionTracking:Object={"fight":{"link":"1818", "client":"1529"}, "kiss":{"link":"1817", "client":"1529"}, "dance":{"link":"1820", "client":"1479"}, "message":{"link":"1821", "client":"1479"}, "gift":{"link":"1822", "client":"1479"}, "joke":{"link":"1953", "client":"1529"}};

        private var asyncActionInterface:MyLife.Interfaces.AsyncActionInterface;

        private var npcManager:MyLife.NPC.NPCManager;

        private var lastPlayerId:Number;

        private var delayedStartTimers:Array;

        private var actionTweenManager:MyLife.ActionTweenManager;

        private var selectedFriend:Object=null;

        private var _responseDlg:MyLife.Interfaces.AsyncResponseInterface;

        private var myLifeServer:MyLife.Server;

        public var selectedAction:String;

        private var _messagesDlg:flash.display.MovieClip=null;

        private var jokeEmotes:Array;

        private var _trackingLinks:Object;

        private var myLifeInterface:MyLife.Interface;

        private var _showMessageDlg:Boolean=false;

        private var titleOverlay:MyLife.Interfaces.TitleOverlay;

        private var timeoutId:int;

        private var disabledPlayerId:Number;

        private var _newVisitTimer:flash.utils.Timer;

        private var myLifeInstance:flash.display.MovieClip;

        private static var _npcList:Array;

        private static var _linkTracker:MyLife.LinkTracker;

        private static var activeCount:int=0;

        private static var MAX_NPCS:int=1;

        private static var _visitMode:Boolean=false;

        private static var _instance:MyLife.AsyncVisitManager;

        private static var _useRezInAnim:Boolean=true;

        private static var MIN_NPCS:int=1;
    }
}
