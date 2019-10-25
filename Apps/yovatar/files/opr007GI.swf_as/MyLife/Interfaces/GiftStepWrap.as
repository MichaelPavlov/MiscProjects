package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Utils.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class GiftStepWrap extends flash.display.MovieClip
    {
        public function GiftStepWrap()
        {
            _inventoryCollection = [];
            super();
            scrollLeft.addEventListener(MouseEvent.CLICK, scrollLeftClick);
            scrollRight.addEventListener(MouseEvent.CLICK, scrollRightClick);
            cancelWindowButton.addEventListener(MouseEvent.CLICK, cancelWindowButtonClickHandler, false, 0, true);
            previousButton.addEventListener(MouseEvent.CLICK, previousButtonClickHandler, false, 0, true);
            return;
        }

        private function scrollRightClick(arg1:flash.events.MouseEvent):*
        {
            scrollItemBar(-ITEMS_PER_PAGE);
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function getPatternImageByItemId(arg1:*):*
        {
            var loc2:*;

            loc2 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1 + "_110_80.gif";
            return loc2;
        }

        private function closeWindow():*
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String):*
        {
            var loc3:*;

            loc3 = new Loader();
            loc3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageIntoMovieClipError);
            loc3.load(new URLRequest(arg2));
            arg1.addChild(loc3);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc6 = null;
            _myLife = arg1;
            setupWrapperSelectorPanel();
            loc3 = [{"itemId":25587}, {"itemId":25588}, {"itemId":25589}];
            loc7 = 0;
            loc8 = loc3;
            for each (loc4 in loc8)
            {
                this.addItemToPanelPatternBar(loc4.itemId);
            }
            this.scrollItemBar(0);
            this.giftData = arg2.giftData || {};
            if (this.giftData.previousStep != "ViewStoreInventory")
            {
                previousButton.visible = true;
            }
            else 
            {
                previousButton.visible = false;
            }
            if (this.giftData.previewImage)
            {
                (loc6 = this.giftData.previewImage).x = this.giftPreview.width - loc6.width >> 1;
                loc6.y = this.giftPreview.height - loc6.height >> 1;
                this.giftPreview.Image.addChild(loc6);
            }
            else 
            {
                loadItemPreview(this.giftData.itemId);
            }
            loc5 = this.giftPreview.numChildren;
            this.giftPreview.removeChildAt((loc5 - 1));
            this.giftPreview.removeChildAt(loc5 - 2);
            if (this.giftData.playerItemId)
            {
                this.nextButton.visible = false;
                this.sendGiftButton.addEventListener(MouseEvent.CLICK, sendGiftButtonClickHandler, false, 0, true);
            }
            else 
            {
                this.sendGiftButton.visible = false;
                this.nextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler, false, 0, true);
            }
            return;
        }

        private function enableButton(arg1:*, arg2:*):*
        {
            arg1.mouseEnabled = arg2;
            arg1.alpha = arg2 ? 1 : 0.2;
            return;
        }

        private function cancelWindowButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.giftData.onCancel)
            {
                this.giftData.onCancel();
            }
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE, {"interfaceType":InterfaceTypes.GIFT_WINDOW}));
            closeWindow();
            return;
        }

        private function setupWrapperSelectorPanel():*
        {
            previewCount = 0;
            if (patternBar.originX)
            {
                patternBar.x = patternBar.originX;
            }
            else 
            {
                patternBar.originX = patternBar.x;
            }
            scrollLeft.addEventListener(MouseEvent.CLICK, scrollLeftClick);
            scrollRight.addEventListener(MouseEvent.CLICK, scrollRightClick);
            return;
        }

        private function addItemToPanelPatternBar(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = new PatternPreview();
            loc3 = patternBar;
            loc2.buttonMode = true;
            if (previewCount != 0)
            {
                loc2.PatternPreviewSelected.visible = false;
            }
            else 
            {
                defaultWrapId = arg1;
                loc2.PatternPreviewSelected.visible = true;
            }
            loc2.x = previewCount * 120;
            loc2.itemId = arg1;
            loc2.addEventListener(MouseEvent.CLICK, patternPreviewClickHandler);
            loc3.addChild(loc2);
            loc4 = getPatternImageByItemId(arg1);
            loadImageIntoMovieClip(loc2.Image, loc4);
            previewCount++;
            return loc2;
        }

        private function checkPreloadedImagesComplete():*
        {
            var loc1:*;
            var loc2:*;

            if (!(--_preloadItemsLeftToLoad <= 0))
            {
            };
            return;
        }

        private function onPreloadImageError(arg1:flash.events.IOErrorEvent):*
        {
            this.checkPreloadedImagesComplete();
            return false;
        }

        private function onPreloadImageComplete(arg1:flash.events.Event):void
        {
            this.checkPreloadedImagesComplete();
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function selectItem(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc3 = undefined;
            if (arg1.PatternPreviewSelected.visible)
            {
                return;
            }
            loc4 = 0;
            loc5 = DisplayObjectContainerUtils.getChildren(patternBar);
            for each (loc2 in loc5)
            {
                loc2.PatternPreviewSelected.visible = false;
            }
            arg1.PatternPreviewSelected.visible = true;
            loc3 = getPatternImageByItemId(arg1.itemId);
            DisplayObjectContainerUtils.removeChildren(this.giftPreview.Image);
            loadImageIntoMovieClip(this.giftPreview.Image, loc3);
            this.giftData.giftWrapItemId = arg1.itemId;
            return;
        }

        private function previousButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            trace("PREVIOUS BUTTON CLICK");
            if (!this.isButtonsDeactivated)
            {
                if (this.giftData.previousStep)
                {
                    trace(this.giftData.previousStep);
                    this._myLife._interface.showInterface(this.giftData.previousStep, {"giftData":giftData});
                    this.unloadInterface(this);
                }
                else 
                {
                    this._myLife._interface.showInterface("GiftStepInventory", {"giftData":giftData});
                    this.unloadInterface(this);
                }
            }
            return;
        }

        private function removeDisplayObjectFromParent(arg1:flash.display.DisplayObject):*
        {
            if (arg1.parent)
            {
                arg1.parent.removeChild(arg1);
            }
            return;
        }

        private function nextButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        private function preloadImage(arg1:String):*
        {
            var loc2:*;

            loc2 = new Loader();
            loc2.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreloadImageComplete);
            loc2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreloadImageError);
            loc2.load(new URLRequest(arg1));
            return;
        }

        private function patternPreviewClickHandler(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget;
            loc3 = loc2.parent.parent;
            this.selectItem(loc2);
            trace("selectedPattern " + loc2);
            return;
        }

        private function onLoadImageIntoMovieClipError(arg1:flash.events.IOErrorEvent):*
        {
            return false;
        }

        private function sendGiftCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = NaN;
            loc9 = NaN;
            trace("sendGiftCompleteHandler()");
            loc2 = arg1.eventData || {};
            this._myLife.server.removeEventListener(MyLifeEvent.SEND_ACTION_COMPLETE, sendGiftCompleteHandler);
            loc3 = Boolean(Number(arg1.eventData.success || 0));
            if (loc3)
            {
                InventoryManager.removeItemFromInventory(this.giftData.playerItemId);
                loc4 = "Gift Sent";
                loc5 = "Your gift has been sent";
                if (this.giftData.recipientName)
                {
                    loc5 = loc5 + " to " + this.giftData.recipientName;
                }
                loc5 = loc5 + ".";
                if (!this.giftData.recipientServerUserId)
                {
                    this.giftData.recipientServerUserId = this._myLife.zone.getPlayerServerUserIdFromPlayerId(this.giftData.recipientPlayerId);
                }
                if (this.giftData.recipientServerUserId)
                {
                    (loc6 = {}).senderName = this.giftData.senderName;
                    _myLife.server.sendPlayerToPlayerEvent(this.giftData.recipientServerUserId, "GIFT", "RECEIVED", loc6);
                    loc7 = ActionTweenType.GIFT;
                    loc8 = this._myLife.player._character.serverUserId;
                    loc9 = this.giftData.recipientServerUserId;
                    ActionTweenManager.instance.broadcastActionTween(loc7, loc8, loc9);
                }
                if (this.giftData.recipientServerUserId || this.giftData.isAsyncVisit)
                {
                    loc5 = "";
                }
            }
            else 
            {
                loc4 = "Gift Sending Failed";
                loc5 = "Sorry, your gift did not get received.";
            }
            if (loc5)
            {
                this._myLife._interface.showInterface("GenericDialog", {"title":loc4, "message":loc5});
            }
            if (loc3)
            {
                if (this.giftData.onComplete)
                {
                    this.giftData.onComplete();
                }
                else 
                {
                    if (!giftData.recipientServerUserId)
                    {
                        _myLife.getServer().sendNotification(MyLifeInstance.getInstance().server.ACTION_MANAGER_TYPE_GIFT, this.giftData.recipientPlayerId);
                    }
                }
                this._myLife._interface.unloadInterface(this);
            }
            else 
            {
                this.isButtonsDeactivated = false;
                if (this.giftData.onCancel)
                {
                    this.giftData.onCancel();
                }
            }
            return;
        }

        private function sendGiftButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = null;
            trace("sendGiftButtonClickHandler()");
            if (!this.isButtonsDeactivated)
            {
                this.giftData.message = this.noteTextField.text;
                if (!this.giftData.giftWrapItemId)
                {
                    this.giftData.giftWrapItemId = this.defaultWrapId;
                }
                this.isButtonsDeactivated = true;
                loc2 = {};
                loc2.recipientPlayerId = this.giftData.recipientPlayerId;
                trace(loc2.recipientPlayerId);
                loc2.playerItemId = this.giftData.playerItemId;
                loc2.giftWrapItemId = this.giftData.giftWrapItemId;
                loc2.message = this.giftData.message;
                loc2.actionType = this._myLife.server.ACTION_MANAGER_TYPE_GIFT;
                this._myLife.server.addEventListener(MyLifeEvent.SEND_ACTION_COMPLETE, sendGiftCompleteHandler, false, 0, true);
                this._myLife.server.callExtension("ActionManager.sendAction", loc2);
            }
            return;
        }

        private function loadItemPreview(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1 + "_60_60.gif?v=" + MyLifeConfiguration.version;
            loc3 = new Loader();
            loc3.load(new URLRequest(loc2));
            trace("GPW " + loc3.width);
            trace("GPH " + loc3.height);
            loc4 = 60;
            loc3.x = this.giftPreview.width - loc4 >> 1;
            loc3.y = this.giftPreview.height - loc4 >> 1;
            this.giftPreview.Image.addChild(loc3);
            return;
        }

        private function scrollItemBar(arg1:int):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = Math.round((patternBar.x - patternBar.originX) / 120);
            loc3 = loc2 + arg1;
            if (loc3 > 0)
            {
                loc3 = 0;
            }
            loc4 = patternBar.originX + 120 * loc3;
            TweenLite.to(patternBar, 0.5, {"x":loc4});
            if (loc3 >= 0)
            {
                scrollLeft.mouseEnabled = false;
                scrollLeft.alpha = 0.3;
            }
            else 
            {
                scrollLeft.mouseEnabled = true;
                scrollLeft.alpha = 1;
            }
            if (loc4 + patternBar.width - patternBar.originX < 360)
            {
                scrollRight.mouseEnabled = false;
                scrollRight.alpha = 0.3;
            }
            else 
            {
                scrollRight.mouseEnabled = true;
                scrollRight.alpha = 1;
            }
            return;
        }

        private function scrollLeftClick(arg1:flash.events.MouseEvent):*
        {
            scrollItemBar(ITEMS_PER_PAGE);
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private function hideMovieClip(arg1:*):*
        {
            arg1.visible = false;
            return;
        }

        private const ITEMS_PER_SCROLL:int=3;

        private const ITEMS_PER_PAGE:int=3;

        public var noteTextField:flash.text.TextField;

        public var scrollLeft:flash.display.SimpleButton;

        public var nextButton:flash.display.SimpleButton;

        public var previousButton:flash.display.SimpleButton;

        private var selectedPlayerItemId:Number;

        private var selectedItemId:Number;

        private var _scrollOffset:int=0;

        private var _preloadItemsLeftToLoad:int=0;

        private var defaultWrapId:Number;

        private var previewCount:int;

        public var sendGiftButton:flash.display.SimpleButton;

        public var scrollRight:flash.display.SimpleButton;

        private var wrapCounter:Number=0;

        private var _inventoryCollection:Array;

        public var cancelWindowButton:flash.display.SimpleButton;

        public var patternBar:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        public var giftPreview:flash.display.MovieClip;

        private var isButtonsDeactivated:Boolean=false;

        public var giftData:Object;
    }
}
