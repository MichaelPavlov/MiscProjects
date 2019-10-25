package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    
    public class AchievementBadge extends MyLife.Interfaces.Badge
    {
        public function AchievementBadge(arg1:flash.display.MovieClip=null, arg2:int=-1, arg3:int=-1, arg4:int=-1, arg5:String=null, arg6:Boolean=true, arg7:Boolean=false, arg8:Number=34002, arg9:Number=1, arg10:int=-1)
        {
            _myLife = MyLifeInstance.getInstance();
            _badgeManager = BadgeManager.instance;
            super();
            _character = arg1;
            if (_character)
            {
                playerId = _character.myLifePlayerId;
            }
            else 
            {
                playerId = arg2;
            }
            bgClick.width = 0;
            bgClick.height = 0;
            badgeType = arg3;
            badgeLevel = arg4;
            this.showDefault = arg7;
            this.highlightColor = arg8;
            this.scaleFactor = arg9;
            this.clickable = arg6;
            _linkTracker = new LinkTracker();
            configureLinkTracker();
            if (!(_character == null) && _character._characterName)
            {
                characterName = _character._characterName;
            }
            else 
            {
                if (arg5 != null)
                {
                    characterName = arg5;
                }
            }
            if (arg3 >= 0 && arg4 >= 0)
            {
                loadDisplayBadgeFromParams(arg3, arg4);
            }
            else 
            {
                if (arg10 >= 0)
                {
                    loadDisplayBadgeFromId(arg10);
                }
            }
            BadgeManager.instance.addEventListener(MyLifeEvent.BADGE_MANAGER_INITIALIZED, loadDisplayBadgeHandler);
            return;
        }

        private function loadDisplayBadge():void
        {
            var loc1:*;

            loc1 = null;
            if (_character != null)
            {
                loc1 = _character.DisplayBadge;
            }
            loadDisplayBadgeFromParams(loc1[0], loc1[1]);
            return;
        }

        public function update():void
        {
            loadDisplayBadge();
            return;
        }

        private function loadDisplayBadgeHandler(arg1:MyLife.MyLifeEvent):void
        {
            loadDisplayBadge();
            return;
        }

        public function loadDisplayBadgeFromId(arg1:int):void
        {
            loadDisplayBadgeFromParams(_badgeManager.getBadgeTypeFromId(arg1), _badgeManager.getBadgeLevelFromId(arg1));
            return;
        }

        private function onImageLoad(arg1:Object, arg2:Object):void
        {
            var childExists:Boolean;
            var content:Object;
            var context:Object;
            var count:int;
            var image:flash.display.Bitmap;
            var loc3:*;
            var loc4:*;

            content = arg1;
            context = arg2;
            trace("onImageLoad");
            image = content as Bitmap;
            if (image)
            {
                image.scaleX = scaleFactor;
                image.scaleY = scaleFactor;
            }
            childExists = true;
            count = 0;
            while (childExists) 
            {
                try
                {
                    if (getChildAt(count) != bgClick)
                    {
                        this.removeChildAt(count);
                    }
                }
                catch (err:Error)
                {
                    childExists = false;
                }
                count = (count + 1);
            }
            if (image)
            {
                bgClick.width = image.width;
                bgClick.height = image.height;
                this.addChild(image);
            }
            if (this._character != null)
            {
                _character.renderCharacterName();
            }
            return;
        }

        public function configureLinkTracker():void
        {
            var loc1:*;

            if (!_linkTracker)
            {
                _linkTracker = new LinkTracker();
            }
            loc1 = false;
            if (playerId == _myLife.player._playerId)
            {
                loc1 = true;
            }
            if (_myLife.player.SHOW_BADGE)
            {
                if (loc1)
                {
                    this.ltLink = LTLINK_SELF_B;
                    this.ltClient = LTCLIENT_SELF_B;
                }
                else 
                {
                    this.ltLink = LTLINK_OTHERS_B;
                    this.ltClient = LTCLIENT_OTHERS_B;
                }
            }
            else 
            {
                if (loc1)
                {
                    this.ltLink = LTLINK_SELF;
                    this.ltClient = LTCLIENT_SELF;
                }
                else 
                {
                    this.ltLink = LTLINK_OTHERS;
                    this.ltClient = LTCLIENT_OTHERS;
                }
            }
            return;
        }

        public function hasImage():Boolean
        {
            return !(this.getChildAt(0) == null);
        }

        public function setPlayer(arg1:flash.display.MovieClip=null, arg2:int=-1):void
        {
            if (arg1)
            {
                _character = arg1;
                playerId = arg1.myLifePlayerId;
            }
            else 
            {
                playerId = arg2;
            }
            configureLinkTracker();
            return;
        }

        private function onBadgeClick(arg1:flash.events.MouseEvent):void
        {
            if (playerId >= 0 && characterName)
            {
                _badgeManager.openBadgesWindow(null, playerId, characterName);
            }
            else 
            {
                if (_character != null)
                {
                    _badgeManager.openBadgesWindow(_character);
                }
            }
            arg1.stopPropagation();
            trackAction();
            return;
        }

        public function dispose():void
        {
            this.removeEventListener(MyLifeEvent.BADGE_CLICK_EVENT, onBadgeClick);
            this.removeEventListener(MouseEvent.CLICK, onBadgeClick);
            this.removeEventListener(MouseEvent.MOUSE_OVER, onBadgeOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onBadgeOut);
            return;
        }

        private function onBadgeOut(arg1:flash.events.MouseEvent):void
        {
            filters = [];
            return;
        }

        public function trackAction():void
        {
            trace("Badge Click: (" + ltLink + ", " + ltClient + ")");
            if (_linkTracker)
            {
                _linkTracker.setRandomActive();
                _linkTracker.track(ltLink, ltClient);
            }
            return;
        }

        public function loadDisplayBadgeFromParams(arg1:int, arg2:int):void
        {
            var loc3:*;

            loc3 = _badgeManager.getMicroImageURL(arg1, arg2);
            badgeType = arg1;
            badgeLevel = arg2;
            if (loc3)
            {
                if (showDefault || badgeType >= 0 && badgeLevel >= 0)
                {
                    if (clickable)
                    {
                        this.buttonMode = true;
                        this.useHandCursor = true;
                        this.addEventListener(MyLifeEvent.BADGE_CLICK_EVENT, onBadgeClick);
                        this.addEventListener(MouseEvent.CLICK, onBadgeClick);
                        this.addEventListener(MouseEvent.MOUSE_OVER, onBadgeOver);
                        this.addEventListener(MouseEvent.MOUSE_OUT, onBadgeOut);
                    }
                    AssetsManager.getInstance().loadImage(loc3, null, onImageLoad);
                }
            }
            return;
        }

        private function onBadgeOver(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = new GlowFilter();
            loc2.color = highlightColor;
            loc2.blurY = loc3 = 15;
            loc2.blurX = loc3;
            filters = [loc2];
            return;
        }

        
        {
            LTCLIENT_OTHERS = "1533";
            LTLINK_OTHERS = "2226";
            LTCLIENT_SELF = "1533";
            LTLINK_SELF = "2225";
            LTCLIENT_OTHERS_B = "1533";
            LTLINK_OTHERS_B = "2235";
            LTCLIENT_SELF_B = "1533";
            LTLINK_SELF_B = "2234";
        }

        public var bgClick:flash.display.Sprite;

        private var showDefault:Boolean;

        private var highlightColor:Number;

        private var characterName:String;

        private var playerId:int;

        private var _linkTracker:MyLife.LinkTracker;

        private var badgeLevel:int;

        private var ltLink:String;

        private var _myLife:flash.display.MovieClip;

        private var clickable:Boolean;

        private var _character:flash.display.MovieClip;

        private var _badgeManager:MyLife.BadgeManager;

        private var ltClient:String;

        private var scaleFactor:Number;

        private var badgeType:int;

        public static var LTLINK_OTHERS:String="2226";

        public static var LTLINK_OTHERS_B:String="2235";

        public static var LTLINK_SELF:String="2225";

        public static var LTLINK_SELF_B:String="2234";

        public static var LTCLIENT_OTHERS:String="1533";

        public static var LTCLIENT_SELF:String="1533";

        public static var LTCLIENT_OTHERS_B:String="1533";

        public static var LTCLIENT_SELF_B:String="1533";
    }
}
