package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class BadgeAlertWindow extends flash.display.Sprite
    {
        public function BadgeAlertWindow(arg1:int, arg2:int)
        {
            _myLife = MyLifeInstance.getInstance();
            _badgeManager = BadgeManager.instance;
            super();
            this.visible = false;
            badgeType = arg1;
            badgeLevel = arg2;
            loadingAnimation.visible = true;
            loadingAnimation.play();
            loadBadgeImage();
            loadBadgeTitle();
            loadBadgeText();
            btnCloseWindow = TitleBar.btnCloseWindow;
            btnCloseWindow.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
            btnViewBadges.addEventListener(MouseEvent.CLICK, btnViewBadgesClickHandler);
            timeoutTimer = new Timer(10000);
            timeoutTimer.addEventListener("timer", imageTimeout);
            x = 200;
            y = 140;
            return;
        }

        private function loadBadgeImage():void
        {
            AssetsManager.getInstance().loadImage(_badgeManager.getLargeImageURL(badgeType, badgeLevel), null, onImageLoad);
            return;
        }

        private function imageTimeout(arg1:flash.events.TimerEvent):void
        {
            onImageLoad(null, null);
            return;
        }

        public function getBadgeType():int
        {
            return badgeType;
        }

        private function loadBadgeTitle():void
        {
            var loc1:*;

            loc1 = new TextFormat();
            loc1.bold = true;
            loc1.size = 18;
            WindowTitle.text = _badgeManager.getBadgeName(badgeType, badgeLevel);
            WindowTitle.setTextFormat(loc1);
            return;
        }

        private function btnViewBadgesClickHandler(arg1:flash.events.MouseEvent):void
        {
            onBtnCloseClick(null);
            _badgeManager.openBadgesWindow(_myLife.player._character);
            return;
        }

        private function onBtnCloseClick(arg1:flash.events.MouseEvent):void
        {
            (MyLifeInstance.getInstance() as MyLife).hideDialog(this);
            btnCloseWindow.removeEventListener(MouseEvent.CLICK, onBtnCloseClick);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE));
            return;
        }

        private function onImageLoad(arg1:Object, arg2:Object):void
        {
            var loc3:*;

            loc3 = null;
            if (arg1 != null)
            {
                loc3 = arg1 as Bitmap;
                BadgeContainer.addChild(loc3);
                loadingAnimation.stop();
                loadingAnimation.visible = false;
                loc3.x = (BadgeAlertWindow.LARGE_BADGE_WIDTH - loc3.width) / 2;
                loc3.y = (BadgeAlertWindow.LARGE_BADGE_HEIGHT - loc3.height) / 2;
            }
            this.visible = true;
            return;
        }

        public function hideViewButton():void
        {
            btnViewBadges.visible = false;
            btnViewBadges.removeEventListener(MouseEvent.CLICK, btnViewBadgesClickHandler);
            return;
        }

        public function getBadgeLevel():int
        {
            return badgeLevel;
        }

        private function loadBadgeText():void
        {
            BadgeText.text = "You have earned the " + _badgeManager.getBadgeLevelName(badgeLevel) + " " + _badgeManager.getBadgeName(badgeType) + " Badge.";
            badgeIntroText.text = _badgeManager.getBadgeIntro(badgeType, badgeLevel);
            badgeTitleText.text = _badgeManager.getBadgeName(badgeType, badgeLevel);
            return;
        }

        private function updateBadgeList():void
        {
            _myLife.getPlayer().getCharacter().updateBadgeList(badgeType, badgeLevel);
            return;
        }

        public static const LARGE_BADGE_WIDTH:int=150;

        public static const LARGE_BADGE_HEIGHT:int=150;

        public var badgeTitleText:flash.text.TextField;

        public var btnCloseWindow:flash.display.SimpleButton;

        public var BadgeText:flash.text.TextField;

        public var badgeIntroText:flash.text.TextField;

        private var badgeLevel:int;

        private var timeoutTimer:flash.utils.Timer;

        private var _myLife:flash.display.MovieClip;

        public var WindowTitle:flash.text.TextField;

        private var _badgeManager:MyLife.BadgeManager;

        public var loadingAnimation:flash.display.MovieClip;

        public var btnViewBadges:flash.display.SimpleButton;

        public var TitleBar:flash.display.MovieClip;

        private var badgeType:int;

        public var BadgeContainer:flash.display.Sprite;
    }
}
