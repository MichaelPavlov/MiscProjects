package MyLife.Interfaces.LeaderBoard 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.Interfaces.*;
    import MyLife.Utils.Math.*;
    import MyLife.Xp.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class PlayerItem extends flash.display.MovieClip
    {
        public function PlayerItem()
        {
            super();
            image.gotoAndStop(1);
            return;
        }

        private function getRoomImageUrl(arg1:*, arg2:*, arg3:*):String
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = MyLifeInstance.getInstance().getConfiguration().variables["global"]["new_upload_server"] + "images/";
            loc6 = (loc5 = String(arg1)).split("");
            loc7 = loc4;
            loc8 = 0;
            while (loc8 < (loc6.length - 1)) 
            {
                loc7 = loc7 + loc6[loc8] + "/";
                ++loc8;
            }
            if (arg3 > 0)
            {
                loc7 = loc7 + arg1 + "-h" + arg3 + ".jpg";
            }
            else 
            {
                loc7 = loc7 + arg1 + "-" + arg2 + ".jpg";
            }
            return loc7;
        }

        public function getDefaultHome():int
        {
            return defaultHome;
        }

        private function onAvatarMaximize(arg1:fl.transitions.TweenEvent):void
        {
            avatarClip.scaleY = avatarClip.scaleX;
            avatarScaleTween.removeEventListener(TweenEvent.MOTION_CHANGE, onAvatarScaleChange);
            avatarScaleTween.removeEventListener(TweenEvent.MOTION_FINISH, onAvatarMaximize);
            return;
        }

        private function loadImage(arg1:String):void
        {
            if (arg1 == "" || arg1 == null)
            {
                return;
            }
            MyLifeInstance.getInstance().assetsLoader.loadImage(arg1, null, imageLoadedCallback);
            return;
        }

        private function removeListeners():void
        {
            this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            return;
        }

        private function addListeners():void
        {
            this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            BadgeManager.instance.addEventListener(MyLifeEvent.DISPLAY_BADGE_UPDATED, loadBadgeHandler);
            return;
        }

        private function onXpManagerInitialize(arg1:MyLife.Xp.XpManagerEvent):void
        {
            setLevel(XpManager.instance.getPlayerProgress().getMaxLevel());
            return;
        }

        private function createAvatarInstance(arg1:Object):void
        {
            if (arg1 == null)
            {
                return;
            }
            avatarClip = AssetsManager.getInstance().newAvatarInstance();
            avatarClip.x = this.width / 2 + 6;
            avatarClip.y = this.getBounds(this).bottom - 20;
            if (avatarClip.numChildren > 0)
            {
                avatarClip.removeChildAt(0);
            }
            this.addChild(avatarClip);
            avatarClip.initAvatar(0, 0.17);
            avatarClip.addEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, onAvatarLoaded);
            avatarClip.loadAvatarClothes(arg1);
            return;
        }

        private function loadBadgeHandler(arg1:MyLife.MyLifeEvent):void
        {
            BadgeManager.instance.removeEventListener(MyLifeEvent.BADGE_MANAGER_INITIALIZED, loadBadgeHandler);
            loadBadge(badgeId);
            return;
        }

        public function getPlayerID():uint
        {
            return playerId;
        }

        private function imageLoadedCallback(arg1:*, arg2:*=null):void
        {
            var loc3:*;

            loc3 = null;
            if (arg1)
            {
                loc3 = FitToDimensions.fitToDimensions(arg1.width, arg1.height, image.width, image.height, FitToDimensions.CONSTRAIN_MAXIMUM);
                arg1.width = loc3.width;
                arg1.height = loc3.height;
                arg1.x = (image.width - loc3.width) / 2;
                arg1.y = (image.height - loc3.height) / 2;
                if (image.numChildren)
                {
                    image.getChildAt(0).visible = false;
                }
                image.addChild(arg1);
            }
            return;
        }

        private function onAvatarLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            avatarClip.doAvatarAction("0");
            dispatchEvent(new AvatarLoadEvent(arg1.type, arg1.eventData));
            addListeners();
            return;
        }

        public function getAvatarClip():flash.display.MovieClip
        {
            return avatarClip;
        }

        public function setLevel(arg1:int):void
        {
            levelTxt.text = arg1.toString();
            return;
        }

        public function getPlayerHomeRoomID():uint
        {
            return playerHomeRoomId;
        }

        public function cleanUp():void
        {
            removeListeners();
            avatarClip.cleanUp();
            return;
        }

        private function onXpManagerNewLevel(arg1:MyLife.Xp.XpManagerEvent):void
        {
            if (arg1.data.hasOwnProperty("level"))
            {
                setLevel(int(arg1.data.level));
            }
            return;
        }

        private function loadBadge(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = 0;
            loc6 = 0;
            loc2 = BadgeManager.instance.getBadgeTypeFromId(arg1);
            loc3 = BadgeManager.instance.getBadgeLevelFromId(arg1);
            if (arg1 == null || arg1 < 0 || playerId == MyLifeInstance.getInstance().player._playerId)
            {
                loc2 = MyLifeInstance.getInstance().player._badgeType;
                loc3 = MyLifeInstance.getInstance().player._badgeLevel;
            }
            if (badge.numChildren)
            {
                badge.removeChildAt(0);
            }
            if (loc2 >= 0 && loc3 >= 0)
            {
                loc5 = int(loc2);
                loc6 = int(loc3);
                loc4 = new AchievementBadge(null, playerId, loc5, loc6, avatarName);
                badge.addChild(loc4);
            }
            return;
        }

        private function onAvatarScaleChange(arg1:fl.transitions.TweenEvent):void
        {
            avatarClip.scaleY = avatarClip.scaleX;
            return;
        }

        private function onMouseOut(arg1:flash.events.MouseEvent):void
        {
            nameTxt.text = playerName;
            if (avatarClip == null)
            {
                return;
            }
            avatarClip.doAvatarAction("0");
            if (!(avatarScaleTween == null) && avatarScaleTween.isPlaying)
            {
                avatarScaleTween.fforward();
            }
            avatarScaleTween = new Tween(avatarClip, "scaleX", Regular.easeOut, avatarClip.scaleX, 0.17, 0.2, true);
            avatarScaleTween.addEventListener(TweenEvent.MOTION_CHANGE, onAvatarScaleChange);
            avatarScaleTween.addEventListener(TweenEvent.MOTION_FINISH, onAvatarMinimize);
            return;
        }

        private function onXpManagerNewXp(arg1:MyLife.Xp.XpManagerEvent):void
        {
            if (arg1.data.hasOwnProperty("progressArray"))
            {
                xpTxt.htmlText = "<b>" + arg1.data["progressArray"]["xp_count"] + "</b>";
            }
            return;
        }

        public function populate(arg1:Object):void
        {
            var loc2:*;

            playerName = (arg1.first_name != null) ? arg1.first_name : "?";
            avatarName = (arg1.name != null) ? arg1.name : "?";
            playerId = arg1.player;
            roomName = arg1.room;
            defaultHome = parseInt(arg1.default_home);
            playerHomeRoomId = (arg1.is_home_room != 1) ? 0 : arg1.player_home_room;
            this.mouseChildren = true;
            this.useHandCursor = true;
            this.buttonMode = true;
            if (playerId == (MyLifeInstance.getInstance() as MyLife).getPlayer().getPlayerId())
            {
                (MyLifeInstance.getInstance() as MyLife).getServer().addEventListener(XpManagerEvent.XP_MANAGER_NEW_LEVEL, onXpManagerNewLevel, false, 0, true);
                (MyLifeInstance.getInstance() as MyLife).getServer().addEventListener(XpManagerEvent.XP_MANAGER_UPDATE_PROGRESS, onXpManagerNewXp, false, 0, true);
            }
            loc2 = new TextFormat();
            loc2.letterSpacing = 1;
            rankTxt.text = String(arg1.rank);
            xpTxt.htmlText = "<b>" + arg1.xp_count + "</b>";
            xpTxt.setTextFormat(loc2);
            if (XpManager.instance.isInitialized())
            {
                setLevel(XpManager.instance.getLevelFromXp(parseInt(arg1.xp)).getLevel());
            }
            else 
            {
                XpManager.instance.addEventListener(XpManagerEvent.XP_MANAGER_INITIALIZED, onXpManagerInitialize);
            }
            createAvatarInstance(arg1.clothing);
            if (avatarClip != null)
            {
                setChildIndex(avatarClip, (getChildIndex(xpTxt) - 1));
            }
            if (arg1.isFriend != true)
            {
                nameTxt.text = avatarName;
                playerName = avatarName;
                image.gotoAndStop("room");
            }
            else 
            {
                image.gotoAndStop("friend");
                nameTxt.text = playerName;
            }
            if (arg1.pic_url == null)
            {
                image.visible = false;
                avatarClip.x = avatarClip.x - 6;
            }
            else 
            {
                image.visible = true;
                loadImage(arg1.pic_url);
            }
            if (arg1.badge != null)
            {
                this.badgeId = arg1.badge;
            }
            else 
            {
                this.badgeId = -1;
            }
            if (BadgeManager.instance.isInitialized())
            {
                loadBadge(arg1.badge);
            }
            else 
            {
                BadgeManager.instance.addEventListener(MyLifeEvent.BADGE_MANAGER_INITIALIZED, loadBadgeHandler);
            }
            return;
        }

        private function badgeLoadedCallback(arg1:*, arg2:*=null):void
        {
            if (arg1)
            {
                arg1.x = 0;
                arg1.y = 0;
                if (badge.numChildren)
                {
                    badge.removeChildAt(0);
                }
                badge.addChild(arg1);
            }
            return;
        }

        private function onAvatarMinimize(arg1:fl.transitions.TweenEvent):void
        {
            avatarClip.scaleY = avatarClip.scaleX;
            avatarScaleTween.removeEventListener(TweenEvent.MOTION_CHANGE, onAvatarScaleChange);
            avatarScaleTween.removeEventListener(TweenEvent.MOTION_FINISH, onAvatarMinimize);
            return;
        }

        private function onMouseOver(arg1:flash.events.MouseEvent):void
        {
            nameTxt.text = avatarName;
            if (avatarClip == null)
            {
                return;
            }
            avatarClip.doRandomDance();
            if (!(avatarScaleTween == null) && avatarScaleTween.isPlaying)
            {
                avatarScaleTween.fforward();
            }
            avatarScaleTween = new Tween(avatarClip, "scaleX", Regular.easeOut, avatarClip.scaleX, 0.2, 0.2, true);
            avatarScaleTween.addEventListener(TweenEvent.MOTION_CHANGE, onAvatarScaleChange);
            avatarScaleTween.addEventListener(TweenEvent.MOTION_FINISH, onAvatarMaximize);
            return;
        }

        public function getRoomName():String
        {
            return roomName;
        }

        private var avatarScaleTween:fl.transitions.Tween;

        private var avatarName:String;

        private var roomName:String;

        private var playerName:String;

        public var badge:flash.display.MovieClip;

        public var rankTxt:flash.text.TextField;

        private var badgeId:int;

        private var loadingClip:flash.display.MovieClip;

        private var defaultHome:int;

        private var avatarClip:flash.display.MovieClip;

        public var levelTxt:flash.text.TextField;

        private var playerHomeRoomId:uint;

        public var image:flash.display.MovieClip;

        private var playerId:uint;

        public var xpTxt:flash.text.TextField;

        public var nameTxt:flash.text.TextField;

        private static var tempClothingObject:Object;
    }
}
