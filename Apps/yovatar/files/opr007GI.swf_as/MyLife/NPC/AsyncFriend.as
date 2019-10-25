package MyLife.NPC 
{
    import MyLife.*;
    import MyLife.Interfaces.*;
    import MyLife.Utils.*;
    import fai.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.*;
    
    public class AsyncFriend extends MyLife.NPC.SimpleNPC
    {
        public function AsyncFriend(arg1:flash.display.MovieClip=null)
        {
            jokeEmotes = ["E:6", "E:10", "E:14", "E:19", "E:10", "E:14", "E:19", "E:10", "E:14", "E:19"];
            super(arg1);
            this.init();
            return;
        }

        public function doRandomAction():void
        {
            var loc1:*;

            loc1 = null;
            if (this.myLifePlayerId != MyLifeInstance.getInstance().getZone().getApartmentOwnerPlayerId())
            {
                if (Math2.random(10, 1) != 1)
                {
                };
            }
            else 
            {
                if (Math2.random(10, 1) == 1)
                {
                    loc1 = ACTION_SAY_STATUS;
                }
            }
            if (!loc1)
            {
                if (Math2.random(10, 1) != 1)
                {
                    if (Math2.random(10, 1) != 1)
                    {
                        if (Math2.random(8, 1) != 1)
                        {
                            if (Math2.random(2, 1) != 1)
                            {
                                loc1 = ACTION_FACE_DIRECTION;
                            }
                            else 
                            {
                                loc1 = ACTION_WALK;
                            }
                        }
                        else 
                        {
                            loc1 = ACTION_DANCE;
                        }
                    }
                    else 
                    {
                        loc1 = ACTION_THROW_WATERBALLOON;
                    }
                }
                else 
                {
                    loc1 = ACTION_TALK;
                }
            }
            this.doAction(loc1);
            return;
        }

        private function makeActionTween(arg1:String):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = this.serverUserId;
            loc3 = MyLifeInstance.getInstance().getPlayer().getCharacter()["serverUserId"];
            ActionTweenManager.instance.makeActionTween(arg1, loc2, loc3);
            return;
        }

        public function tellJokeToPlayer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            this._currentAction = ACTION_JOKE;
            loc1 = ["E:24", ""];
            loc2 = null;
            loc3 = false;
            loc4 = Math.random() * 100 % jokeEmotes.length;
            loc2 = jokeEmotes[loc4];
            loc1.push(loc2);
            loc3 = loc2 == "E:6";
            while (loc2 == jokeEmotes[loc4] || jokeEmotes[loc4] == "E:6") 
            {
                loc4 = Math.random() * 100 % jokeEmotes.length;
            }
            loc1[1] = jokeEmotes[loc4];
            if (!loc3)
            {
                loc3 = !(int(Math.random() * 100) % 5 == 1);
            }
            (loc5 = new DataTimer({"joke":loc1, "funny":loc3}, 500, 19)).addEventListener(TimerEvent.TIMER, laughTimerHandler);
            loc5.addEventListener(TimerEvent.TIMER_COMPLETE, laughTimerComplete);
            loc5.start();
            return;
        }

        public function get currentAction():String
        {
            return this._currentAction;
        }

        public function plainSayStatus():void
        {
            var loc1:*;

            loc1 = null;
            if (this.status == null)
            {
                MyLifeInstance.getInstance().server.addEventListener(MyLifeEvent.GET_STATUS_SUCCESS, sayStatusCompleteHandler);
                MyLifeInstance.getInstance().server.requestStatus(this.myLifePlayerId);
            }
            else 
            {
                loc1 = "C:";
                if (this.status != "")
                {
                    loc1 = loc1 + this.status;
                }
                else 
                {
                    loc1 = loc1 + DEFAULT_STATUS_TEXT;
                }
                sayMessage("C:" + DEFAULT_STATUS_HEADER, true);
                sayMessage(loc1, false);
            }
            return;
        }

        public function throwWaterballoonFromNPCToPlayer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = this.myPlayer.getCharacter();
            loc2 = loc1.x;
            loc3 = loc1.y;
            (loc4 = MyLifeInstance.getInstance().getInterface().interfaceHUD.waterBalloonManager).throwNewBalloon(this.serverUserId, loc2, loc3);
            this._currentAction = ACTION_THROW_WATERBALLOON;
            return;
        }

        private function init():void
        {
            this.myLifeZone = MyLifeInstance.getInstance().getZone();
            if (myLifeZone._zoneMovie.hasOwnProperty("NPC_HANDLERS"))
            {
                _specialNPCZone = myLifeZone._zoneMovie.NPC_HANDLERS;
            }
            this.myPlayer = MyLifeInstance.getInstance().getPlayer();
            this._currentAction = "";
            this.actionDelayTimer = new Timer(0, 1);
            this.idleTimer = new Timer(0, 1);
            this.addListeners();
            this.visible = false;
            return;
        }

        private function removeListeners():void
        {
            var loc1:*;

            MyLifeInstance.getInstance().getInterface().interfaceHUD.removeEventListener(MyLifeEvent.SEND_MESSAGE, sendMessageHandler);
            loc1 = MyLifeInstance.getInstance().getInterface().interfaceHUD.waterBalloonManager;
            loc1.removeEventListener(MyLifeEvent.PLAYER_WATERBALLOON_COMPLETE, waterBalloonCompleteHandler);
            return;
        }

        public function rezIn(arg1:Boolean=true):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc2 = false;
            loc3 = _specialNPCZone ? myLifeZone._zoneMovie.getRandomNPCPosition(this) : myLifeZone.findAvailablePosition(null, 1000, 165, 200, 490);
            if (loc3)
            {
                setPosition(new Position(loc3.x, loc3.y));
                this.visible = true;
                this.myLifeZone.resortDepths();
                if (arg1)
                {
                    this._renderClip.alpha = 0;
                    TweenLite.to(this._renderClip, 1.5, {"alpha":1});
                    loc5 = new (loc4 = getDefinitionByName(DEFENITION_NAME_REZINANIMATION) as Class)();
                    this.addChild(loc5);
                    (loc6 = new MovieClipPlayer(loc5)).addEventListener(Event.COMPLETE, rezInAnimationCompleteHandler, false, 0, true);
                    loc6.play();
                    MyLifeSoundController.getInstance().playLibrarySound("teleportSound");
                    this._currentAction = ACTION_REZ_IN;
                }
                else 
                {
                    this._isRezzedIn = true;
                    this.dispatchActionComplete();
                }
                loc2 = true;
            }
            return loc2;
        }

        public function rezOut():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            _renderClip.alpha = 1;
            TweenLite.to(_renderClip, 1, {"alpha":0});
            getNameTag().visible = false;
            loc1 = getDefinitionByName(DEFENITION_NAME_REZINANIMATION) as Class;
            loc2 = new loc1();
            addChild(loc2);
            loc3 = new MovieClipPlayer(loc2);
            loc3.addEventListener(Event.COMPLETE, rezOutAnimationCompleteHandler, false, 0, true);
            loc3.play();
            MyLifeSoundController.getInstance().playLibrarySound("teleportSound");
            this._currentAction = ACTION_REZ_OUT;
            return;
        }

        public function get saidStatus():Boolean
        {
            return this._saidStatus;
        }

        public function sendGiftFromNPCToPlayer():void
        {
            this.makeActionTween(ActionTweenType.GIFT);
            this._currentAction = ACTION_GIFT;
            return;
        }

        private function sayStatusCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            MyLifeInstance.getInstance().server.removeEventListener(MyLifeEvent.GET_STATUS_SUCCESS, sayStatusCompleteHandler);
            if (arg1.eventData.hasOwnProperty("status"))
            {
                this.status = arg1.eventData.status;
            }
            if (this.status != null)
            {
                sayStatus();
            }
            return;
        }

        private function actionDelayTimerCompleteHandler(arg1:flash.events.TimerEvent):void
        {
            this.doNextAction();
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
                    sayMessage(loc2.data.joke[0], true);
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
                    sayMessage("", true);
                    break;
                case 5:
                    sayMessage(loc2.data.joke[1], true);
                    break;
                case 9:
                    sayMessage(loc2.data.joke[2], true);
                    break;
                default:
                    loc3 = (loc2.currentCount % 2) ? "E:22" : "E:11";
                    sayMessage(loc3, true);
                    MyLifeInstance.getInstance().player._character.sayMessage(loc2.data.funny ? loc3 : "E:18", true);
                    break;
            }
            return;
        }

        protected override function getNameTagItems():Array
        {
            var loc1:*;

            loc1 = new Array();
            if (!achievementBadge)
            {
                renderDisplayBadge();
            }
            if (achievementBadge)
            {
                loc1.push(achievementBadge);
            }
            loc1.push(getNameTagTextField());
            loc1.push(getModBadge(4));
            return loc1;
        }

        public function setAvatarAction(arg1:Object):void
        {
            this.avatarAction = arg1;
            return;
        }

        public function sendKissFromNPCToPlayer():void
        {
            this.makeActionTween(ActionTweenType.KISS);
            this._currentAction = ACTION_KISS;
            return;
        }

        public function sayEmoticon(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = "E:";
            loc3 = loc2 + arg1;
            sayMessage(loc3);
            return;
        }

        private function waterBalloonCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            if (this._currentAction == ACTION_IDLE || this._currentAction == ACTION_REZ_IN)
            {
                this.setDelayedAction(ACTION_REACT_WATERBALLOON, this.DELAY_REACT_WATERBALLOON);
            }
            loc2 = MyLifeInstance.getInstance().getInterface().interfaceHUD.waterBalloonManager;
            loc2.removeEventListener(MyLifeEvent.PLAYER_WATERBALLOON_COMPLETE, waterBalloonCompleteHandler);
            return;
        }

        public override function sayMessage(arg1:*, arg2:Boolean=false):void
        {
            if (canSpeak)
            {
                super.sayMessage(arg1, arg2);
            }
            return;
        }

        private function laughTimerComplete(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as DataTimer;
            loc2.removeEventListener(TimerEvent.TIMER, laughTimerHandler);
            loc2.removeEventListener(TimerEvent.TIMER_COMPLETE, laughTimerComplete);
            MyLifeInstance.getInstance().player._character.sayMessage("", true);
            sayMessage("", true);
            loc2.data = null;
            dispatchActionComplete();
            return;
        }

        private function addListeners():void
        {
            this.actionDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, actionDelayTimerCompleteHandler, false, 0, true);
            this.idleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, idleTimerCompleteHandler, false, 0, true);
            MyLifeInstance.getInstance().getInterface().interfaceHUD.addEventListener(MyLifeEvent.SEND_MESSAGE, sendMessageHandler, false, 0, true);
            return;
        }

        public function get isRezzedIn():Boolean
        {
            return this._isRezzedIn;
        }

        public function doAction(arg1:String, arg2:Boolean=true):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = 0;
            trace("doAction " + arg1);
            loc5 = arg1;
            switch (loc5) 
            {
                case ACTION_REACT_WATERBALLOON:
                    this.faceDirection();
                    this._currentAction = arg1;
                    this.sayEmoticon(EMOTICON_HAPPY);
                    this.setDelayedAction(ACTION_THROW_WATERBALLOON, this.DELAY_THROW_WATERBALLOON);
                    this.dispatchActionComplete();
                    break;
                case ACTION_THROW_WATERBALLOON:
                    this.faceDirection();
                    this.throwWaterballoonFromNPCToPlayer();
                    this.doAction(ACTION_IDLE);
                    break;
                case ACTION_DANCE:
                    this.faceDirection();
                    this._currentAction = arg1;
                    this.dance();
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_DANCE);
                    break;
                case ACTION_TALK:
                    this.faceDirection();
                    this._currentAction = arg1;
                    this.talk();
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_TALK);
                    break;
                case ACTION_WALK:
                    this._currentAction = arg1;
                    loc3 = _specialNPCZone ? myLifeZone._zoneMovie.getRandomNPCPosition(this) : this.myLifeZone.getRandomAvailableIsoPos();
                    trace("asyncFriend walk action");
                    this.moveTo(loc3);
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_WALK);
                    break;
                case ACTION_RESPOND_MESSAGE:
                    this.respondMessage();
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_TALK);
                    break;
                case ACTION_FACE_DIRECTION:
                    this._currentAction = arg1;
                    if (Math2.random(6) != 1)
                    {
                        loc4 = Math2.random(1, 0);
                    }
                    else 
                    {
                        loc4 = Math2.random(3, 2);
                    }
                    this.faceDirection(loc4);
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_FACE_DIRECTION);
                    break;
                case ACTION_JOKE:
                    _currentAction = ACTION_JOKE;
                    tellJokeToPlayer();
                    break;
                case ACTION_SAY_STATUS:
                    this._currentAction = ACTION_SAY_STATUS;
                    this.sayStatus();
                    this.setDelayedAction(ACTION_IDLE, this.DELAY_AFTER_TALK);
                    break;
                case ACTION_ANIMATION:
                    this._currentAction = ACTION_ANIMATION;
                    if (this.avatarAction)
                    {
                        this.doAvatarAction(avatarAction.value.a, false, avatarAction.value.params);
                        addEventListener(MyLifeEvent.CHARACTER_ACTION_COMPLETE, actionCompleteHandler);
                    }
                    break;
                default:
                    this._currentAction = ACTION_IDLE;
                    this.actionDelayTimer.stop();
                    this.idleTimer.reset();
                    this.idleTimer.delay = Math2.random(this.IDLE_TIMER_DELAY_MAX, this.IDLE_TIMER_DELAY_MIN);
                    if (arg2)
                    {
                        idleTimer.start();
                    }
                    break;
            }
            return;
        }

        public function talk():void
        {
            var loc1:*;

            loc1 = Math2.random(24, 1);
            this.sayEmoticon(loc1);
            return;
        }

        public function faceDirection(arg1:int=1):void
        {
            this.changeDirection(arg1);
            return;
        }

        public function respondMessage(arg1:String=""):void
        {
            var loc2:*;

            loc2 = 0;
            this.lastReceivedMessage = arg1 || this.lastReceivedMessage;
            if (this.lastReceivedMessage)
            {
                this.lastReceivedMessage = this.lastReceivedMessage.toLowerCase();
                loc2 = 0;
                if (this.lastReceivedMessage.indexOf("yoville") >= 0)
                {
                    loc2 = 24;
                }
                else 
                {
                    if (this.lastReceivedMessage.indexOf(_characterName.toLowerCase()) >= 0)
                    {
                        loc2 = 9;
                    }
                    else 
                    {
                        if (this.lastReceivedMessage.indexOf("ninja") >= 0)
                        {
                            loc2 = 12;
                        }
                        else 
                        {
                            if (this.lastReceivedMessage.indexOf("kyle") >= 0)
                            {
                                loc2 = 5;
                            }
                            else 
                            {
                                if (this.lastReceivedMessage.indexOf("talk") >= 0)
                                {
                                    loc2 = 14;
                                }
                                else 
                                {
                                    if (this.lastReceivedMessage.indexOf("hi") >= 0)
                                    {
                                        loc2 = 19;
                                    }
                                    else 
                                    {
                                        if (this.lastReceivedMessage.indexOf("hello") >= 0)
                                        {
                                            loc2 = 19;
                                        }
                                        else 
                                        {
                                            if (this.lastReceivedMessage.indexOf("yadda") >= 0)
                                            {
                                                loc2 = 19;
                                            }
                                            else 
                                            {
                                                if (this.lastReceivedMessage.indexOf("lol") >= 0)
                                                {
                                                    loc2 = 11;
                                                }
                                                else 
                                                {
                                                    if (this.lastReceivedMessage.indexOf("lmao") >= 0)
                                                    {
                                                        loc2 = 11;
                                                    }
                                                    else 
                                                    {
                                                        if (this.lastReceivedMessage.indexOf("roflmao") >= 0)
                                                        {
                                                            loc2 = 11;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (loc2)
                {
                    this.sayEmoticon(loc2);
                }
                else 
                {
                    this.sayStatus();
                }
                this.lastReceivedMessage = "";
            }
            return;
        }

        public function dance(arg1:String=""):void
        {
            if (arg1 != "")
            {
                doAvatarAction(arg1);
            }
            else 
            {
                doRandomDance();
            }
            return;
        }

        public function renderDisplayBadge():void
        {
            var loc1:*;

            loc1 = 0;
            trace("AsyncFriend.renderDisplayBadge");
            if (!achievementBadge)
            {
                loc1 = int(FriendDataManager.getAppUserFriendData(myLifePlayerId).badge);
                achievementBadge = new AchievementBadge(this, myLifePlayerId, -1, -1, _characterName, true, false, 16768000, 0.9, loc1);
            }
            return;
        }

        private function dispatchActionComplete():void
        {
            this.dispatchEvent(new Event("actionComplete"));
            return;
        }

        private function actionCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            removeEventListener(MyLifeEvent.CHARACTER_ACTION_COMPLETE, actionCompleteHandler);
            dispatchEvent(new Event("actionComplete"));
            return;
        }

        public function sayStatus():void
        {
            plainSayStatus();
            return;
        }

        private function idleTimerCompleteHandler(arg1:flash.events.TimerEvent):void
        {
            this.doRandomAction();
            return;
        }

        public function set canSpeak(arg1:Boolean):void
        {
            _canSpeak = arg1;
            if (!arg1)
            {
                super.sayMessage("", true);
            }
            return;
        }

        public function waterBalloonTarget():void
        {
            var loc1:*;

            loc1 = MyLifeInstance.getInstance().getInterface().interfaceHUD.waterBalloonManager;
            loc1.addEventListener(MyLifeEvent.PLAYER_WATERBALLOON_COMPLETE, waterBalloonCompleteHandler, false, 0, true);
            return;
        }

        public function sendMessageFromNPCToPlayer():void
        {
            this.makeActionTween(ActionTweenType.MESSAGE);
            this._currentAction = ACTION_MESSAGE;
            return;
        }

        public function get canSpeak():Boolean
        {
            return _canSpeak;
        }

        public function disable():void
        {
            cleanUp();
            this.visible = false;
            this.removeListeners();
            if (idleTimer)
            {
                idleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, idleTimerCompleteHandler);
                idleTimer.stop();
                idleTimer = null;
            }
            if (actionDelayTimer)
            {
                actionDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, actionDelayTimerCompleteHandler);
                actionDelayTimer.stop();
                actionDelayTimer = null;
            }
            myLifeZone = null;
            myPlayer = null;
            return;
        }

        private function sendMessageHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData && arg1.eventData.msg)
            {
                this.lastReceivedMessage = arg1.eventData.msg;
                this.setDelayedAction(ACTION_RESPOND_MESSAGE, this.DELAY_RESPOND_MESSAGE);
            }
            return;
        }

        private function doNextAction(arg1:String=""):void
        {
            var loc2:*;

            loc2 = null;
            this.nextAction = arg1 || this.nextAction;
            if (this.nextAction)
            {
                loc2 = this.nextAction;
                this.nextAction = "";
                this.doAction(loc2);
            }
            return;
        }

        private function rezInAnimationCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.target as MovieClipPlayer;
            loc2.removeEventListener(Event.COMPLETE, rezInAnimationCompleteHandler);
            loc3 = loc2.movieClip;
            if (loc3.parent)
            {
                loc3.parent.removeChild(loc3);
            }
            this._isRezzedIn = true;
            this.dispatchActionComplete();
            return;
        }

        private function rezOutAnimationCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.target as MovieClipPlayer;
            loc2.removeEventListener(Event.COMPLETE, rezOutAnimationCompleteHandler);
            loc3 = loc2.movieClip;
            if (loc3.parent)
            {
                loc3.parent.removeChild(loc3);
            }
            this.disable();
            this.dispatchActionComplete();
            return;
        }

        public function setDelayedAction(arg1:String, arg2:int):void
        {
            this.nextAction = arg1;
            this.actionDelayTimer.reset();
            this.actionDelayTimer.delay = arg2;
            this.actionDelayTimer.start();
            return;
        }

        private const DELAY_AFTER_FACE_DIRECTION:int=100;

        private const DELAY_RESPOND_MESSAGE:int=1500;

        private const DEFENITION_NAME_REZINANIMATION:String="MyLife.NPC.RezInAnimation";

        private const IDLE_TIMER_DELAY_MIN:int=3000;

        private const IDLE_TIMER_DELAY_MAX:int=8000;

        private const DELAY_THROW_WATERBALLOON:int=1000;

        private const DELAY_REACT_WATERBALLOON:int=1000;

        private const DELAY_AFTER_DANCE:int=10000;

        private const DELAY_RECEIVE_WATERBALLOON:int=500;

        private const DELAY_AFTER_TALK:int=5000;

        private const EMOTICON_HAPPY:int=11;

        private const DELAY_AFTER_WALK:int=5000;

        private const EMOTICON_MAD:int=17;

        public static const ACTION_REACT_WATERBALLOON:String="reactWaterballoon";

        public static const ACTION_REZ_IN:String="rezIn";

        public static const ACTION_JOKE:String="joke";

        public static const ACTION_DANCE:String="dance";

        public static const ACTION_SAY_STATUS:String="sayStatus";

        public static const ACTION_TALK:String="talk";

        public static const ACTION_GIFT:String="gift";

        public static const ACTION_RESPOND_MESSAGE:String="respondMessage";

        private static const DEFAULT_STATUS_HEADER:String="Status (Offline): ";

        public static const ACTION_MESSAGE:String="message";

        public static const ACTION_FACE_DIRECTION:String="faceDirection";

        public static const ACTION_FIGHT:String="fight";

        public static const ACTION_REZ_OUT:String="rezOut";

        public static const ACTION_KISS:String="kiss";

        public static const ACTION_LEAVE:String="npcLeave";

        public static const ACTION_WALK:String="walk";

        public static const ACTION_ANIMATION:String="animation";

        public static const ACTION_THROW_WATERBALLOON:String="throwWaterballoon";

        private static const DEFAULT_STATUS_TEXT:String="Hey, check out my apartment!";

        public static const ACTION_IDLE:String="idle";

        private var nextAction:String;

        private var _currentAction:String;

        private var offlineImage:flash.display.Bitmap;

        private var jokeEmotes:Array;

        private var _isRezzedIn:Boolean;

        private var _canSpeak:Boolean=true;

        private var _specialNPCZone:Boolean=false;

        private var actionDelayTimer:flash.utils.Timer;

        private var lastReceivedMessage:String;

        private var myLifeZone:MyLife.Zone;

        private var myPlayer:MyLife.Player;

        private var achievementBadge:MyLife.Interfaces.AchievementBadge;

        private var idleTimer:flash.utils.Timer;

        private var _saidStatus:Boolean;

        private var status:String;

        private var avatarAction:Object;
    }
}
