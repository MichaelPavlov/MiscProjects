package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Utils.*;
    import fl.containers.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class GiftWindow extends MyLife.Interfaces.SimpleInterface
    {
        public function GiftWindow()
        {
            loadPreviewIntoClipImageList = [];
            super();
            trace("GiftWindow");
            this.hide();
            return;
        }

        public function destroy():*
        {
            destroyed = true;
            return;
        }

        private function getPlayerGiftsCompleteHandler(arg1:MyLife.MyLifeEvent=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = null;
            loc6 = null;
            trace("getPlayerGiftsCompleteHandler()");
            loc2 = arg1.eventData || {};
            _myLife.server.removeEventListener(MyLifeEvent.GET_ACTIONS_COMPLETE, getPlayerGiftsCompleteHandler);
            this.loadingTextField.visible = false;
            loc3 = loc2.actionData || [];
            if ((loc4 = loc3.length) <= 0)
            {
                this.defaultTextField.visible = true;
            }
            else 
            {
                this._myLife._interface.interfaceHUD.setGiftCount(loc4);
            }
            if (loc3.length)
            {
                this.loadItemsIntoContainer(loc3);
                this.putContainerIntoScrollPane();
                loc7 = 0;
                loc8 = loc3;
                for each (loc5 in loc8)
                {
                    if (!(loc6 = InventoryManager.getInventoryItem(loc5.playerItemId)))
                    {
                        continue;
                    }
                    loc6.isHidden = true;
                }
            }
            this.show();
            return;
        }

        private function closeWindow():*
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function onLoadPreviewIntoClipIOError(arg1:flash.events.IOErrorEvent):*
        {
            this.loadNextPreviewIntoClip();
            return false;
        }

        public override function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            _myLife.addChild(this);
            this.playerId = arg2.playerId || this._myLife.player._playerId;
            this.getGiftData();
            this.addListeners();
            if (arg2.title)
            {
                this.titleTextField.text = arg2.title;
            }
            this.defaultTextField.visible = false;
            return;
        }

        private function cancelWindowButtonClick(arg1:flash.events.MouseEvent):*
        {
            closeWindow();
            return;
        }

        private function addListeners():void
        {
            this.cancelWindowButton.addEventListener(MouseEvent.CLICK, this.cancelWindowButtonClick, false, 0, true);
            return;
        }

        private function previewItemRollOverHandler(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.currentTarget;
            loc3 = new GlowFilter();
            loc3.inner = true;
            loc3.color = 16768000;
            loc3.blurY = loc4 = 6;
            loc3.blurX = loc4;
            loc2.filters = [loc3];
            return;
        }

        private function loadItemsIntoContainer(arg1:Array):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc6 = 0;
            trace("\tloadItemsIntoContainer()");
            loc2 = 0;
            loc3 = 0;
            loc7 = arg1.length;
            loc6 = 0;
            while (loc6 < loc7) 
            {
                loc5 = arg1[loc6];
                loc2 = loc6 % maxColumn;
                loc3 = (loc6 - loc2) / maxColumn;
                loc4 = new GiftWindowPreview();
                previewContainer.addChild(loc4);
                loc4.x = loc2 * (loc4.width + colSpacing);
                loc4.y = loc3 * (loc4.height + colSpacing);
                loc4.txtName.text = loc5.fromPlayerName;
                loc4.giftData = loc5;
                this.loadPreviewIntoClipImageList.push({"img":loc4.previewImage, "id":loc5.giftWrapItemId});
                DisplayObjectContainerUtils.removeChildren(loc4.previewImage);
                loc4.buttonMode = true;
                loc4.useHandCursor = true;
                loc4.addEventListener(MouseEvent.CLICK, previewItemClickHandler);
                loc4.addEventListener(MouseEvent.ROLL_OVER, previewItemRollOverHandler);
                loc4.addEventListener(MouseEvent.ROLL_OUT, previewItemRollOutHandler);
                ++loc6;
            }
            this.curWorkers = 0;
            while (this.curWorkers < this.maxWorkers) 
            {
                this.loadNextPreviewIntoClip();
            }
            return;
        }

        private function putContainerIntoScrollPane():*
        {
            containerScrollPane = new ScrollPane();
            this.addChild(containerScrollPane);
            containerScrollPane.move(this.containerBg.x, this.containerBg.y);
            containerScrollPane.setSize(this.containerBg.width, this.containerBg.height);
            containerScrollPane.source = previewContainer;
            return;
        }

        private function previewItemClickHandler(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = arg1.currentTarget as GiftWindowPreview;
            loc3 = loc2.giftData;
            this.removePreviewItem(loc2);
            loc4 = this._myLife._interface.interfaceHUD.getGiftCount();
            this._myLife._interface.interfaceHUD.setGiftCount((loc4 - 1));
            (loc5 = this._myLife._interface.showInterface("GiftWindowOpen", loc3)).addEventListener(Event.COMPLETE, giftWindowOpenCompleteHandler, false, 0, true);
            loc5.addEventListener(MyLifeEvent.SEND_THANK_YOU_GIFT, giftWindowSendGiftHandler, false, 0, true);
            this.titleTextField.visible = false;
            return;
        }

        private function giftWindowOpenCompleteHandler(arg1:flash.events.Event):void
        {
            this.titleTextField.visible = true;
            if (previewContainer.numChildren == 0)
            {
                closeWindow();
            }
            return;
        }

        private function getMovieChildren(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = undefined;
            loc2 = new Array();
            loc3 = 0;
            while (loc3 < arg1.numChildren) 
            {
                loc4 = arg1.getChildAt(loc3);
                loc2.unshift(loc4);
                ++loc3;
            }
            return loc2;
        }

        private function previewItemRollOutHandler(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            loc2.filters = [];
            return;
        }

        private function removePreviewItem(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            trace("removePreviewItem()");
            this.previewContainer.removeChild(arg1);
            loc2 = 0;
            loc3 = 0;
            if (loc4 = this.previewContainer.numChildren)
            {
                while (loc4--) 
                {
                    arg1 = this.previewContainer.getChildAt(loc4);
                    loc2 = loc4 % maxColumn;
                    loc3 = (loc4 - loc2) / maxColumn;
                    arg1.x = loc2 * (arg1.width + colSpacing);
                    arg1.y = loc3 * (arg1.height + colSpacing);
                }
            }
            else 
            {
                this.defaultTextField.visible = true;
                this.visible = false;
            }
            return;
        }

        private function setTitleText(arg1:String):void
        {
            this.titleTextField.text = arg1;
            return;
        }

        private function getGiftData():void
        {
            var loc1:*;

            this.loadingTextField.visible = true;
            loc1 = this._myLife.server.ACTION_MANAGER_TYPE_GIFT;
            this._myLife.server.addEventListener(MyLifeEvent.GET_ACTIONS_COMPLETE, getPlayerGiftsCompleteHandler, false, 0, true);
            this._myLife.server.callExtension("ActionManager.getActions", {"actionType":loc1, "playerId":this.playerId});
            return;
        }

        private function giftWindowSendGiftHandler(arg1:MyLife.MyLifeEvent):void
        {
            this.unloadInterface(this);
            return;
        }

        private function onLoadPreviewIntoClipComplete(arg1:flash.events.Event):void
        {
            this.loadNextPreviewIntoClip();
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            var loc2:*;

            dispatchEvent(new Event(Event.CLOSE));
            loc2 = this._myLife._interface.interfaceHUD.getGiftCount();
            if (loc2 && this._myLife.zone._apartmentMode)
            {
                if (this._myLife.zone.getApartmentOwnerPlayerId() == this._myLife.player._playerId)
                {
                    this._myLife._interface.interfaceHUD.setupGiveGift(true, true, loc2);
                }
            }
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function loadNextPreviewIntoClip():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc4 = undefined;
            loc5 = null;
            if (destroyed)
            {
                return;
            }
            if (!loadPreviewIntoClipImageList || loadPreviewIntoClipImageList.length == 0)
            {
                curWorkers++;
                return;
            }
            loc1 = null;
            loc3 = loadPreviewIntoClipImageList.shift();
            if (loc3)
            {
                loc1 = loc3.img;
                loc2 = String(loc3.id);
            }
            if (!(loc1 == null) && loc2)
            {
                loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc2 + "_110_80.gif";
                (loc5 = new Loader()).contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPreviewIntoClipComplete);
                loc5.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadPreviewIntoClipIOError);
                loc5.load(new URLRequest(loc4));
                loc7 = ((loc6 = this).curWorkers + 1);
                loc6.curWorkers = loc7;
                loc1.addChild(loc5);
            }
            else 
            {
                curWorkers++;
            }
            return;
        }

        private const colSpacing:int=5;

        private const maxColumn:int=3;

        public var defaultTextField:flash.text.TextField;

        public var previewContainer:flash.display.MovieClip;

        private var destroyed:*=false;

        public var containerBg:flash.display.MovieClip;

        public var instructionsTextField:flash.text.TextField;

        private var maxWorkers:int=16;

        private var containerScrollPane:fl.containers.ScrollPane;

        public var scrollUpdateText:fl.controls.UIScrollBar;

        private var loadPreviewIntoClipImageList:Array;

        public var titleTextField:flash.text.TextField;

        private var viewItemDetailsWindow:flash.display.MovieClip;

        public var cancelWindowButton:flash.display.SimpleButton;

        private var curWorkers:int=0;

        private var _myLife:flash.display.MovieClip;

        private var playerId:int;

        public var loadingTextField:flash.text.TextField;

        private var currentPreviewItemClipParent:flash.display.MovieClip;
    }
}
