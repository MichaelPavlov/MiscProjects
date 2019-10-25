package MyLife.Interfaces 
{
    import MyLife.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class ScratcherWindow extends flash.display.MovieClip
    {
        public function ScratcherWindow()
        {
            GoldPot = ScratcherWindow_GoldPot;
            super();
            x = 80;
            y = 125;
            scratchers = [shamrock1, shamrock2, shamrock3, shamrock4, shamrock5];
            sparklyPlayer = new MovieClipPlayer(sparklies);
            sparklyPlayer.movieClip.visible = false;
            coinPlayer = new MovieClipPlayer(coinAnim);
            coinAnim.visible = false;
            reminderPlayer = new MovieClipPlayer(comeBackAnim);
            comeBackAnim.visible = false;
            noticeWindow.visible = false;
            noticeWindow.btnCloseWindow.addEventListener(MouseEvent.CLICK, onNoticeWindowCloseClick, false, 0, true);
            clicker.useHandCursor = false;
            btnCloseWindow.addEventListener(MouseEvent.CLICK, onBtnCloseClick, false, 0, true);
            rewardWindow.btnCloseWindow.addEventListener(MouseEvent.CLICK, onBtnCloseClick, false, 0, true);
            return;
        }

        private function setScratcherIcon(arg1:flash.display.MovieClip, arg2:String="coins"):void
        {
            var loc3:*;

            loc3 = arg2;
            switch (loc3) 
            {
                case RARE:
                    arg1.iconSet.gotoAndStop(1);
                    break;
                case COINS:
                    arg1.iconSet.gotoAndStop(2);
                    break;
                case ITEM:
                    arg1.iconSet.gotoAndStop(3);
                    break;
            }
            return;
        }

        private function onScratcherClickToScratch(arg1:flash.events.MouseEvent):void
        {
            scratchAndInvalidate(arg1.currentTarget as MovieClip);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            _linkTracker = new LinkTracker();
            _myLife = arg1 as MyLife;
            (rewardWindow.rewardDescription as TextField).autoSize = TextFieldAutoSize.CENTER;
            rewardWindow.visible = false;
            loc3 = 0;
            loc4 = scratchers;
            for each (loc2 in loc4)
            {
                setScratcherStatus(loc2);
                setScratcherIcon(loc2);
            }
            _myLife.server.addEventListener(MyLifeEvent.SCRATCHER_DATA_COMPLETE, onScratcherDataLoad, false, 0, true);
            _myLife.server.callExtension("ScratcherManager.checkTicket");
            return;
        }

        private function scratcherSetup(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc2 = arg1.progression;
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                loc5 = loc2[loc3];
                switch (loc5) 
                {
                    case "C":
                        setScratcherIcon(scratchers[loc3], COINS);
                        break;
                    case "U":
                        setScratcherIcon(scratchers[loc3], ITEM);
                        break;
                    case "R":
                        setScratcherIcon(scratchers[loc3], RARE);
                        break;
                }
                if (loc3 < (loc2.length - 1) || arg1.alreadyAdvanced == 1)
                {
                    setScratcherStatus(scratchers[loc3], true);
                }
                else 
                {
                    lastScratcher = scratchers[loc3];
                    clicker.addEventListener(MouseEvent.CLICK, onClickerClick, false, 0, true);
                    scratchers[loc3].addEventListener(MouseEvent.CLICK, onScratcherClickToScratch, false, 0, true);
                    scratchers[loc3].buttonMode = true;
                }
                ++loc3;
            }
            _trackedScratcherPosition = loc2.length;
            _trackedScratcherItem = loc2[(loc2.length - 1)];
            if (arg1["alreadyAdvanced"] != 1)
            {
                trackLink();
            }
            sparklyPlayer.addEventListener(Event.COMPLETE, onSparklyAnimationComplete, false, 0, true);
            if (arg1.won == 1 && !(arg1["alreadyAdvanced"] == 1))
            {
                if (arg1.reward.numCoins)
                {
                    rewardWindow.rewardDescription.text = "You won " + arg1.reward.numCoins + " coins!";
                    rewardWindow.rewardPlaceholder.addChild(new GoldPot() as Sprite);
                    updateCoinsByAmount = arg1.reward.numCoins;
                }
                else 
                {
                    if (arg1.reward.itemId)
                    {
                        loc4 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg1.reward.itemId + "_130_100.gif?v=" + MyLifeConfiguration.version;
                        InventoryManager.addItemToInventory(arg1.reward);
                        AssetsManager.getInstance().loadImage(loc4, rewardWindow.rewardPlaceholder, imageLoadedCallback);
                        rewardWindow.rewardDescription.text = "You won a " + arg1.reward.name + "!";
                    }
                }
            }
            else 
            {
                if (arg1.alreadyAdvanced == 1)
                {
                    setScratchInvalidForAll();
                }
            }
            return;
        }

        private function showRewardWindow():void
        {
            var loc1:*;

            _myLife._interface.interfaceHUD.txtCoinCount.text = (_myLife.getPlayer().getCoinBalance() + updateCoinsByAmount).toString();
            rewardWindow.alpha = 0;
            rewardWindow.scaleY = loc1 = 0;
            rewardWindow.scaleX = loc1;
            rewardWindow.visible = true;
            Tweener.addTween(rewardWindow, {"alpha":1, "scaleX":1, "scaleY":1, "time":1, "transition":"easeOutElastic"});
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:*):void
        {
            if (arg1)
            {
                arg2.addChild(arg1);
            }
            return;
        }

        private function scratchAndInvalidate(arg1:flash.display.MovieClip):void
        {
            arg1.removeEventListener(MouseEvent.CLICK, onScratcherClickToScratch);
            clicker.removeEventListener(MouseEvent.CLICK, onClickerClick);
            scratchScratcher(arg1);
            setScratchInvalidForAll();
            return;
        }

        private function setScratcherStatus(arg1:flash.display.MovieClip, arg2:Boolean=false):void
        {
            arg1.gotoAndStop(arg2 ? arg1.totalFrames : 1);
            return;
        }

        private function setScratchInvalidForAll():void
        {
            var loc1:*;

            loc1 = 0;
            while (loc1 < scratchers.length) 
            {
                (scratchers[loc1] as MovieClip).addEventListener(MouseEvent.CLICK, onScratcherClickToNotify, false, 0, true);
                ++loc1;
            }
            clicker.addEventListener(MouseEvent.CLICK, onScratcherClickToNotify, false, 0, true);
            return;
        }

        private function onScratcherAnimationComplete(arg1:flash.events.Event):void
        {
            var loc2:*;

            (arg1.currentTarget as MovieClipPlayer).removeEventListener(Event.COMPLETE, onScratcherAnimationComplete);
            loc2 = (arg1.currentTarget as MovieClipPlayer).movieClip;
            sparklies.x = loc2.x + (loc2.width >> 1);
            sparklies.y = loc2.y + (loc2.height >> 1);
            sparklies.visible = true;
            sparklyPlayer.play();
            return;
        }

        private function onScratcherClickToNotify(arg1:flash.events.MouseEvent):void
        {
            trace("no more scratchie anymore!");
            noticeWindow.visible = true;
            return;
        }

        private function scratchScratcher(arg1:flash.display.MovieClip):void
        {
            if (arg1.currentFrame == arg1.totalFrames)
            {
                return;
            }
            arg1.buttonMode = false;
            scratcherPlayer = new MovieClipPlayer(arg1);
            scratcherPlayer.addEventListener(Event.COMPLETE, onScratcherAnimationComplete, false, 0, true);
            scratcherPlayer.play();
            coinAnim.x = arg1.x;
            coinAnim.y = arg1.y;
            coinAnim.visible = true;
            coinPlayer.play();
            return;
        }

        private function onClickerClick(arg1:flash.events.MouseEvent):void
        {
            scratchAndInvalidate(lastScratcher);
            return;
        }

        private function onBtnCloseClick(arg1:flash.events.MouseEvent):void
        {
            btnCloseWindow.removeEventListener(MouseEvent.CLICK, onBtnCloseClick);
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface});
            return;
        }

        private function onNoticeWindowCloseClick(arg1:flash.events.MouseEvent):void
        {
            noticeWindow.visible = false;
            return;
        }

        private function trackLink():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            trace("tracking link with position:" + _trackedScratcherPosition + " and item:" + _trackedScratcherItem);
            if (_linkTracker && !_myLife.runningLocal)
            {
                _linkTracker.setRandomActive();
                loc1 = "";
                loc2 = _trackedScratcherPosition;
                switch (loc2) 
                {
                    case 1:
                        loc1 = "2677";
                        break;
                    case 2:
                        loc1 = "2678";
                        break;
                    case 3:
                        loc1 = "2679";
                        break;
                    case 4:
                        loc1 = "2680";
                        break;
                    case 5:
                        loc1 = "2681";
                        break;
                }
                _linkTracker.track(loc1, "1533");
            }
            return;
        }

        private function onScratcherDataLoad(arg1:MyLife.MyLifeEvent=null):void
        {
            var loc2:*;

            loc2 = arg1.eventData;
            scratcherSetup(loc2);
            return;
        }

        private function onSparklyAnimationComplete(arg1:flash.events.Event):void
        {
            sparklyPlayer.removeEventListener(Event.COMPLETE, onSparklyAnimationComplete);
            if (_trackedScratcherPosition != 5)
            {
                comeBackAnim.visible = true;
                reminderPlayer.play();
            }
            else 
            {
                showRewardWindow();
            }
            return;
        }

        private function unloadInterface():void
        {
            dispatchEvent(new Event(Event.CLOSE));
            if (_myLife)
            {
                _myLife._interface.unloadInterface(this);
            }
            return;
        }

        private static const COINS:String="coins";

        private static const RARE:String="rare";

        private static const ITEM:String="item";

        public var btnCloseWindow:flash.display.SimpleButton;

        private var _linkTracker:MyLife.LinkTracker;

        private var sparklyPlayer:MyLife.MovieClipPlayer;

        private var _trackedScratcherItem:String;

        private var lastScratcher:flash.display.MovieClip;

        private var scratchers:Array;

        private var GoldPot:Class;

        public var clicker:flash.display.SimpleButton;

        public var comeBackAnim:flash.display.MovieClip;

        private var _trackedScratcherPosition:int;

        public var sparklies:flash.display.MovieClip;

        public var coinAnim:flash.display.MovieClip;

        public var shamrock1:flash.display.MovieClip;

        public var shamrock2:flash.display.MovieClip;

        public var shamrock3:flash.display.MovieClip;

        public var shamrock4:flash.display.MovieClip;

        public var shamrock5:flash.display.MovieClip;

        private var coinPlayer:MyLife.MovieClipPlayer;

        public var backdrop:flash.display.MovieClip;

        public var LoadingBG:flash.display.MovieClip;

        private var _myLife:MyLife.MyLife;

        public var noticeWindow:flash.display.MovieClip;

        private var scratcherPlayer:MyLife.MovieClipPlayer;

        private var reminderPlayer:MyLife.MovieClipPlayer;

        private var updateCoinsByAmount:int=0;

        public var rewardWindow:flash.display.MovieClip;
    }
}
