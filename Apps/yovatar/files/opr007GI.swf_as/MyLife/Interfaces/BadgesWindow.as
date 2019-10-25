package MyLife.Interfaces 
{
    import MyLife.*;
    import fl.containers.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class BadgesWindow extends flash.display.Sprite
    {
        public function BadgesWindow(arg1:MyLife.Character=null, arg2:int=-1, arg3:String=null)
        {
            _tempBadgeList = [[0, 1, 2, 3], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4]];
            _badgeManager = BadgeManager.instance;
            _myLife = MyLifeInstance.getInstance();
            super();
            BadgeInfoContainer = BadgeScrollOrigin.BadgeInfoContainer;
            if (arg1 != null)
            {
                characterName = arg1._characterName;
                playerId = arg1.myLifePlayerId;
            }
            if (arg2 >= 0)
            {
                playerId = arg2;
            }
            if (arg3 != null)
            {
                characterName = arg3;
            }
            WindowTitle.text = characterName + "\'s Badges";
            btnCloseWindow = TitleBar.btnCloseWindow;
            btnCloseWindow.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
            loadingAnimation.play();
            infoBoxArray = new Array();
            infoBoxCompleteCount = 0;
            x = 40;
            y = 125;
            _myLife.server.addEventListener(MyLifeEvent.GET_PLAYER_BADGE_LIST_COMPLETE, getPlayerBadgeListCompleteHandler);
            addEventListener(MyLifeEvent.BADGE_INFO_BOX_LOADING_COMPLETE, infoBoxCompleteHandler);
            btnUpArrow.visible = false;
            btnDownArrow.visible = false;
            if (arg1 == null)
            {
                _badgeManager.getPlayerBadgesById(playerId);
            }
            else 
            {
                _badgeManager.getPlayerBadges(arg1);
            }
            return;
        }

        private function initScrollPane():void
        {
            badgeScrollPane = new ScrollPane();
            badgeScrollPane.move(0, (0));
            badgeScrollPane.setSize(BadgeMask.width, BadgeMask.height);
            badgeScrollPane.setStyle("upSkin", BackgroundClip);
            badgeScrollPane.source = BadgeInfoContainer;
            BadgeInfoContainer.x = 50;
            BadgeMask.addChild(badgeScrollPane);
            LoadingBG.visible = false;
            badgeScrollPane.update();
            return;
        }

        private function pageUp(arg1:flash.events.MouseEvent):void
        {
            page(BadgesWindow.SCROLL_UP);
            return;
        }

        private function showBadges(arg1:Array=null):void
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
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;

            loc5 = 0;
            loc8 = null;
            loc9 = null;
            loc10 = 0;
            loc11 = 0;
            loc12 = 0;
            loc13 = 0;
            loc14 = null;
            loc15 = null;
            loc16 = null;
            loc17 = 0;
            loc18 = 0;
            loc19 = null;
            loc20 = null;
            loc2 = _badgeManager.TotalBadgeList;
            loc3 = new Array(loc2.length);
            loc4 = new Array(loc2.length);
            if (arg1)
            {
                playerBadgeList = new Array(loc2.length);
                loc21 = 0;
                loc22 = arg1;
                for each (loc9 in loc22)
                {
                    if (loc9 == null)
                    {
                        continue;
                    }
                    loc10 = loc9.maxLevel;
                    loc11 = loc9.badgeType;
                    loc12 = loc9.threshold;
                    loc13 = loc9.badgeProgress;
                    loc3[loc11] = loc12;
                    loc4[loc11] = loc13;
                    loc5 = 0;
                    playerBadgeList[loc11] = new Array();
                    while (loc5 <= loc10) 
                    {
                        playerBadgeList[loc11].push(loc5);
                        ++loc5;
                    }
                }
            }
            loc5 = 0;
            loc6 = 0;
            scrollPosition = 0;
            loc7 = scrollPosition;
            while (loc5 < playerBadgeList.length && loc7 < playerBadgeList.length) 
            {
                addEventListener(MyLifeEvent.BADGE_INFO_BOX_LOADING_COMPLETE, infoBoxCompleteHandler, false, 99999);
                addEventListener(MyLifeEvent.BADGE_INFO_BOX_LOADING_COMPLETE, infoBoxCompleteHandler, true, 99999);
                loc14 = playerBadgeList[loc7] as Array;
                loc15 = new Array();
                loc16 = new Array();
                loc21 = 0;
                loc22 = _badgeManager.TotalBadgeList[loc7];
                for each (loc17 in loc22)
                {
                    loc18 = _badgeManager.getBadgeLevelFromId(loc17);
                    if (!loc14 || loc14.indexOf(loc18) < 0)
                    {
                        loc16.push(new Array(loc7, loc18));
                        continue;
                    }
                    loc15.push(new Array(loc7, loc18));
                }
                if (loc15.length > 0 || loc16.length > 0)
                {
                    loc8 = new BadgeInfoBox(loc7, loc15, loc16, loc4[loc7], loc3[loc7]);
                    if (loc7 == 0)
                    {
                        (loc19 = new BadgeInfoBox(0, [], [], 0, (0))).y = 0;
                        loc19.visible = false;
                        BadgeInfoContainer.addChild(loc19);
                    }
                    loc8.visible = false;
                    loc8.y = _infoBoxSpacing / 2 + _infoBoxSpacing * loc6;
                    BadgeInfoContainer.addChild(loc8);
                    infoBoxArray.push(loc8);
                    ++loc6;
                }
                ++loc5;
                loc7 = loc5 + scrollPosition;
            }
            if (loc6 > BadgesWindow.MAX_ROWS)
            {
                (loc20 = new BadgeInfoBox(0, [], [], 0, (0))).y = _infoBoxSpacing + _infoBoxSpacing * (loc6 - 1);
                loc20.visible = false;
                BadgeInfoContainer.addChild(loc20);
                BadgeInfoContainer.setChildIndex(loc20, 0);
            }
            loc21 = 0;
            loc22 = infoBoxArray;
            for each (loc8 in loc22)
            {
                loc8.LoadBadgeImages();
            }
            initScrollPane();
            return;
        }

        private function page(arg1:int):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = scrollPosition;
            if (arg1 == BadgesWindow.SCROLL_DOWN)
            {
                scrollPosition = scrollPosition + BadgesWindow.MAX_ROWS;
                if (scrollPosition > getMaxScrollPosition())
                {
                    scrollPosition = getMaxScrollPosition();
                }
            }
            if (arg1 == BadgesWindow.SCROLL_UP)
            {
                scrollPosition = (scrollPosition - 1);
                if (scrollPosition < 0)
                {
                    scrollPosition = 0;
                }
            }
            loc2 = loc5 = scrollPosition - loc2;
            loc2 = Math.abs(loc5);
            loc3 = _infoBoxSpacing * scrollPosition;
            loc4 = 0.75 * loc2 / BadgesWindow.MAX_ROWS;
            TweenLite.to(BadgeInfoContainer, loc4, {"y":-loc3, "ease":Linear.easeInOut});
            updateScrollButtons();
            return;
        }

        private function updateScrollButtons():void
        {
            if (scrollPosition != 0)
            {
                btnUpArrow.visible = true;
            }
            else 
            {
                btnUpArrow.visible = false;
            }
            if (scrollPosition >= getMaxScrollPosition())
            {
                btnDownArrow.visible = false;
            }
            else 
            {
                btnDownArrow.visible = true;
            }
            return;
        }

        public function getPlayerBadgeListCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = arg1.eventData.playerBadgeData as Array;
            showBadges(loc2);
            return;
        }

        private function showInfoBoxes():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            TweenLite.to(loadingAnimation, 0.5, {"alpha":0, "onComplete":closeLoadingAnim});
            loc2 = 0;
            loc3 = infoBoxArray;
            for each (loc1 in loc3)
            {
                loc1.alpha = 0;
                loc1.visible = true;
                TweenLite.to(loc1, 0.5, {"alpha":1});
            }
            return;
        }

        private function onBtnCloseClick(arg1:flash.events.MouseEvent):void
        {
            (MyLifeInstance.getInstance() as MyLife).hideDialog(this);
            btnCloseWindow.removeEventListener(MouseEvent.CLICK, onBtnCloseClick);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE));
            return;
        }

        private function pageDown(arg1:flash.events.MouseEvent):void
        {
            page(BadgesWindow.SCROLL_DOWN);
            return;
        }

        private function closeLoadingAnim():void
        {
            loadingAnimation.stop();
            loadingAnimation.visible = false;
            return;
        }

        public function infoBoxCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            infoBoxCompleteCount++;
            if (infoBoxCompleteCount == infoBoxArray.length)
            {
                showInfoBoxes();
                removeEventListener(MyLifeEvent.BADGE_INFO_BOX_LOADING_COMPLETE, infoBoxCompleteHandler);
            }
            return;
        }

        private function getMaxScrollPosition():int
        {
            var loc1:*;

            loc1 = _badgeManager.TotalBadgeList.length - BadgesWindow.MAX_ROWS;
            if (loc1 < 0)
            {
                loc1 = 0;
            }
            return loc1;
        }

        private function initScroll():void
        {
            scrollPosition = 0;
            updateScrollButtons();
            return;
        }

        
        {
            MAX_ROWS = 6;
            SCROLL_UP = 0;
            SCROLL_DOWN = 1;
        }

        private var playerBadgeList:Array;

        public var btnDownArrow:flash.display.SimpleButton;

        public var btnCloseWindow:flash.display.SimpleButton;

        public var BadgeMask:flash.display.Sprite;

        private var scrollPosition:int;

        private var infoBoxCompleteCount:int;

        private var infoBoxArray:Array;

        public var loadingAnimation:flash.display.MovieClip;

        public var BadgeInfoContainer:flash.display.MovieClip;

        public var btnUpArrow:flash.display.SimpleButton;

        public var WindowTitle:flash.text.TextField;

        public var TitleBar:flash.display.MovieClip;

        public var BackgroundClip:flash.display.Sprite;

        public var modalMask:flash.display.MovieClip;

        public var characterName:String;

        private var badgeScrollPane:fl.containers.ScrollPane;

        public var LoadingBG:flash.display.Sprite;

        public var playerId:int;

        private var _infoBoxSpacing:int=50;

        private var _myLife:flash.display.MovieClip;

        private var _badgeManager:MyLife.BadgeManager;

        private var _tempBadgeList:Array;

        public var BadgeScrollOrigin:flash.display.MovieClip;

        private static var SCROLL_DOWN:int=1;

        private static var MAX_ROWS:int=6;

        private static var SCROLL_UP:int=0;
    }
}
