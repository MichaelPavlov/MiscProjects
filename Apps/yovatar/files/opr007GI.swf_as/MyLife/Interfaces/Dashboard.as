package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.NPC.*;
    import MyLife.Utils.*;
    import fl.controls.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class Dashboard extends flash.display.MovieClip
    {
        public function Dashboard()
        {
            _showDaily = new CheckBox();
            friends = [];
            super();
            rightArrow.visible = false;
            leftArrow.visible = false;
            return;
        }

        private function scrollRightHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            _offset--;
            if (_offset < 0)
            {
                _offset = (friends.length - 1);
            }
            displayFriends();
            return;
        }

        public function closeWindow():void
        {
            this.removeListeners();
            defaultBody.visible = false;
            avatarBody.visible = false;
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function cancelButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.closeWindow();
            this.dispatchEvent(new Event(Event.CANCEL));
            return;
        }

        private function avatarMouseOutHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = arg1.currentTarget.player;
            if (loc2 && loc2["profileImage"])
            {
                TweenLite.to(loc2["profileImage"], 0.25, {"alpha":0, "onComplete":toolTipHidden, "onCompleteParams":[loc2["profileImage"]]});
            }
            else 
            {
                loc3 = arg1.currentTarget.getChildAt(0) as SimpleNPC;
                arg1.currentTarget.removeChild(loc3.getSpeechBubble());
                images.addChild(MovieClip(loc3.getSpeechBubble().getChildAt(0)).getChildAt(1));
            }
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            avatarBody.visible = false;
            if (arg2)
            {
                if (arg2.visitsLeft)
                {
                    if (arg2.visitsLeft > 1 || arg2.visitsLeft == 0)
                    {
                        this.visitsLeftTextField.text = arg2.visitsLeft + " Left Today";
                    }
                    else 
                    {
                        this.visitsLeftTextField.visible = false;
                    }
                }
                else 
                {
                    this.visitsLeftTextField.visible = false;
                }
            }
            _showDaily.selected = SharedObjectManager.getValue(SharedObjectManager.DASHBOARD_DAILY);
            this.addListeners();
            this.hide();
            _linkTracker = new LinkTracker();
            if (1 || arg2.visitsLeft == 20)
            {
                images.visible = false;
                defaultBody.visible = false;
                avatarBody.visible = true;
                if (FriendDataManager.ready)
                {
                    friendDataReady(null);
                }
                else 
                {
                    FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, friendDataReady);
                }
            }
            return;
        }

        private function avatarClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = null;
            loc6 = null;
            avatarMouseOutHandler(arg1);
            closeWindow();
            loc2 = arg1.currentTarget["player"];
            loc3 = loc2["player_home_room"];
            loc4 = parseInt(loc2["default_home"]);
            if (loc2)
            {
                loc5 = _myLife as MyLife;
                if (_linkTracker && !_myLife.runningLocal)
                {
                    _linkTracker.setRandomActive();
                    _linkTracker.track("2053", "1529");
                }
                if (loc4)
                {
                    loc5.getZone().joinHomeRoom(loc4, loc2["playerId"]);
                }
                else 
                {
                    loc6 = "APLiving-" + loc2["playerId"];
                    loc5.getZone().join(loc6, 0);
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

        private function addFriendToContainer(arg1:Object, arg2:flash.display.MovieClip):void
        {
            var loc3:*;

            if (arg2.numChildren)
            {
                DisplayObjectContainerUtils.removeChildren(arg2);
            }
            loc3 = new SimpleNPC(_myLife, -1);
            loc3.setCharacterProperties(arg1.clothing, arg1.gender, arg1.name);
            loc3.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, onCharacterLoadingDone);
            loc3.loadCharacterClothing(arg1.clothing);
            arg2.addChild(loc3);
            arg2.player = arg1;
            addFriendImage(arg1, arg2);
            return;
        }

        private function removeListeners():void
        {
            _showDaily.removeEventListener(Event.CHANGE, checkBoxHandler);
            FriendDataManager.instance.removeEventListener(FriendDataManager.EVENT_READY, friendDataReady);
            avatar1.removeEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar1.removeEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar1.removeEventListener(MouseEvent.CLICK, avatarClickHandler);
            avatar2.removeEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar2.removeEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar2.removeEventListener(MouseEvent.CLICK, avatarClickHandler);
            avatar3.removeEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar3.removeEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar3.removeEventListener(MouseEvent.CLICK, avatarClickHandler);
            rightArrow.removeEventListener(MouseEvent.CLICK, scrollRightHandler);
            leftArrow.removeEventListener(MouseEvent.CLICK, scrollLeftHandler);
            this.cancelButton.removeEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
            return;
        }

        private function addListeners():void
        {
            _showDaily.addEventListener(Event.CHANGE, checkBoxHandler);
            avatar1.addEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar1.addEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar1.addEventListener(MouseEvent.CLICK, avatarClickHandler);
            avatar2.addEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar2.addEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar2.addEventListener(MouseEvent.CLICK, avatarClickHandler);
            avatar3.addEventListener(MouseEvent.ROLL_OUT, avatarMouseOutHandler);
            avatar3.addEventListener(MouseEvent.ROLL_OVER, avatarMouseOverHandler);
            avatar3.addEventListener(MouseEvent.CLICK, avatarClickHandler);
            this.cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler, false, 0, true);
            return;
        }

        private function checkBoxHandler(arg1:flash.events.Event):void
        {
            SharedObjectManager.setValue(SharedObjectManager.DASHBOARD_DAILY, _showDaily.selected);
            return;
        }

        private function friendDataReady(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            FriendDataManager.instance.removeEventListener(FriendDataManager.EVENT_READY, friendDataReady);
            friends = FriendDataManager.getAppUserFriendData(0, true) as Array;
            loc2 = null;
            loc3 = friends.length;
            while (loc3) 
            {
                loc3 = (loc3 - 1);
                loc2 = friends[loc3];
                if (loc2["playerId"] != _myLife.player.getPlayerId())
                {
                    continue;
                }
                friends.splice(loc3, 1);
                break;
            }
            displayFriends();
            return;
        }

        private function scrollLeftHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            _offset++;
            if (_offset >= friends.length)
            {
                _offset = 0;
            }
            displayFriends();
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        private function speak(arg1:MyLife.NPC.SimpleNPC):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = 0;
            loc2 = new MovieClip();
            loc3 = null;
            while (!loc3) 
            {
                loc4 = Math.random() * images.numChildren;
                loc3 = images.getChildAt(loc4);
                if (!(loc3.name == "kiss" && arg1.gender == _myLife.player.getGender() || loc3 as Shape))
                {
                    continue;
                }
                loc3 = null;
            }
            loc3.x = 0;
            loc3.y = 0;
            loc2.addChild(loc3);
            arg1.getSpeechBubble().sayMessage(loc2);
            arg1.parent.addChild(arg1.getSpeechBubble());
            return;
        }

        private function avatarMouseOverHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget.getChildAt(0) as SimpleNPC;
            loc3 = arg1.currentTarget.player;
            if (loc3 && loc3["profileImage"])
            {
                loc3["profileImage"].y = loc2.y - loc2.height - 10;
                TweenLite.to(loc3["profileImage"], 0.5, {"scaleX":1, "scaleY":1, "ease":Bounce.easeOut});
            }
            else 
            {
                speak(loc2);
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

        private function setupArrows():void
        {
            rightArrow.visible = true;
            leftArrow.visible = true;
            rightArrow.addEventListener(MouseEvent.CLICK, scrollRightHandler);
            leftArrow.addEventListener(MouseEvent.CLICK, scrollLeftHandler);
            return;
        }

        private function displayFriends():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = null;
            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            if (friends.length)
            {
                loc1 = null;
                loc2 = null;
                if (friends.length > 3)
                {
                    setupArrows();
                    loc3 = 0;
                    while (loc3 < 3) 
                    {
                        if ((loc4 = _offset + loc3) >= friends.length)
                        {
                            loc4 = loc4 - friends.length;
                        }
                        loc2 = friends[loc4];
                        addFriendToContainer(loc2, this[("avatar" + loc3 + 1)]);
                        ++loc3;
                    }
                }
                else 
                {
                    if (friends.length != 1)
                    {
                        addFriendToContainer(friends[0], avatar1);
                        addFriendToContainer(friends[1], avatar3);
                    }
                    else 
                    {
                        addFriendToContainer(friends[0], avatar2);
                    }
                }
            }
            else 
            {
                avatarBody.visible = false;
                images.visible = true;
                defaultBody.visible = true;
            }
            return;
        }

        private function onCharacterLoadingDone(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;

            loc2 = arg1.target as SimpleNPC;
            loc2.y = 63;
            loc2.visible = true;
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            dispatchEvent(new Event(Event.CLOSE));
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function addFriendImage(arg1:Object, arg2:flash.display.MovieClip):void
        {
            if (arg1 && arg1.hasOwnProperty("pic_url"))
            {
                if (!arg1.hasOwnProperty("profileImage"))
                {
                    arg1["profileImage"] = new ProfileImage();
                    AssetsManager.getInstance().loadImage(arg1["pic_url"], arg1["profileImage"], imageLoadedCallback);
                    arg1["profileImage"].scaleX = 0;
                    arg1["profileImage"].scaleY = 0;
                }
                arg2.addChild(arg1["profileImage"]);
            }
            return;
        }

        public function show():void
        {
            this.visible = true;
            this.alpha = 0;
            TweenLite.to(this, 1, {"alpha":1});
            if (_linkTracker && !MyLifeConfiguration.getInstance().runningLocal)
            {
                _linkTracker.setRandomActive();
                _linkTracker.track("2647", "555");
            }
            return;
        }

        public var avatar3:flash.display.MovieClip;

        public var defaultBody:flash.display.MovieClip;

        private var friends:Array;

        public var avatarBody:flash.display.MovieClip;

        private var _showDaily:fl.controls.CheckBox;

        public var checkBoxContainer:flash.display.MovieClip;

        private var _linkTracker:MyLife.LinkTracker;

        private var _offset:int=0;

        public var leftArrow:flash.display.SimpleButton;

        public var cancelButton:flash.display.SimpleButton;

        public var rightArrow:flash.display.SimpleButton;

        public var visitsLeftTextField:flash.text.TextField;

        private var _myLife:flash.display.MovieClip;

        public var images:flash.display.MovieClip;

        public var avatar2:flash.display.MovieClip;

        public var avatar1:flash.display.MovieClip;
    }
}
