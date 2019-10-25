package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.Utils.*;
    import fl.containers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class GiftStepInventory extends flash.display.MovieClip
    {
        public function GiftStepInventory()
        {
            loadPreviewIntoClipImageList = [];
            super();
            trace("ViewInventory Loaded");
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function closeWindow():void
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        public function destroy():void
        {
            destroyed = true;
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String, arg3:int=0, arg4:int=0):void
        {
            var loc5:*;

            DisplayObjectContainerUtils.removeChildren(arg1);
            (loc5 = new Loader()).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageIntoMovieClipError);
            loc5.load(new URLRequest(arg2));
            arg1.addChild(loc5);
            loc5.x = arg3;
            loc5.y = arg4;
            return;
        }

        private function onLoadPreviewIntoClipIOError(arg1:flash.events.IOErrorEvent):void
        {
            loadNextPreviewIntoClip();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            this.giftData = arg2.giftData || {};
            if (this.giftData.recipientName)
            {
                this.titleTextField.text = "Give " + this.giftData.recipientName + " a Gift";
            }
            cancelWindowButton.addEventListener(MouseEvent.CLICK, cancelWindowButtonClickHandler, false, 0, true);
            nextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler, false, 0, true);
            purchaseButton.addEventListener(MouseEvent.CLICK, purchaseButtonClickHandler, false, 0, true);
            if (InventoryManager.ready)
            {
                loadPlayerItems();
            }
            else 
            {
                InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
                InventoryManager.loadInventory();
            }
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

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            loadPlayerItems();
            return;
        }

        private function loadItemsIntoContainer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = undefined;
            loc6 = undefined;
            loc7 = null;
            loc1 = 0;
            loc2 = 0;
            inventoryList.sortOn(["categoryId", "name"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
            loc3 = 0;
            loc8 = 0;
            loc9 = inventoryList;
            for each (loc4 in loc9)
            {
                loc5 = loc4.itemId;
                loc6 = loc4.playerItemId;
                loc1 = loc3 % 6;
                loc2 = (loc3 - loc1) / 6;
                loc7 = new ViewInventoryItemPreview();
                previewContainer.addChild(loc7);
                loc7.inUse.visible = false;
                loc7.starterItem.visible = false;
                loc7.nonRefundable.visible = false;
                loc7.freeGift.visible = false;
                loc7.x = loc1 * loc7.width;
                loc7.y = loc2 * loc7.height + 2;
                loc7.txtName.text = loc4.name;
                loc7.inventoryItem = {"id":loc5, "pid":loc6, "inUse":loc4.inUse, "name":loc4.name};
                loadPreviewIntoClipImageList.push({"img":loc7.previewImage, "id":loc5});
                DisplayObjectContainerUtils.removeChildren(loc7.previewImage);
                addPreviewItemHooks(loc7);
                ++loc3;
            }
            curWorkers = 0;
            while (curWorkers < maxWorkers) 
            {
                loadNextPreviewIntoClip();
            }
            return;
        }

        private function loadPlayerItems():void
        {
            inventoryList = InventoryManager.getTradableInventory();
            if (inventoryList && inventoryList.length)
            {
                this.defaultTextField.visible = false;
                loadItemsIntoContainer();
                putContainerIntoScrollPane();
            }
            else 
            {
                closeWindow();
                openGiftStore();
            }
            return;
        }

        private function putContainerIntoScrollPane():void
        {
            containerScrollPane = new ScrollPane();
            this.addChild(containerScrollPane);
            containerScrollPane.move(this.containerBg.x, this.containerBg.y);
            containerScrollPane.setSize(this.containerBg.width, this.containerBg.height);
            containerScrollPane.source = previewContainer;
            return;
        }

        private function onPreviewItemRollOver(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as MovieClip;
            if (loc2 != this.selectedItem)
            {
                this.addGlow(loc2, 16768000);
            }
            return;
        }

        private function addPreviewItemHooks(arg1:*):void
        {
            arg1.buttonMode = true;
            arg1.useHandCursor = true;
            arg1.addEventListener(MouseEvent.CLICK, onPreviewItemClick);
            arg1.addEventListener(MouseEvent.ROLL_OVER, onPreviewItemRollOver);
            arg1.addEventListener(MouseEvent.ROLL_OUT, onPreviewItemRollOut);
            return;
        }

        private function removeGlow(arg1:flash.display.DisplayObject):void
        {
            arg1.filters = [];
            return;
        }

        public function cleanUp():void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function onPreviewItemClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            trace("onPreviewItemClick()");
            if (this.selectedItem)
            {
                this.removeGlow(this.selectedItem);
            }
            loc2 = arg1.currentTarget as MovieClip;
            trace("\t\tpreviewItem.playerItemId = " + loc2.inventoryItem.pid);
            this.selectedItem = loc2;
            this.giftData.previewImage = this.selectedItem.previewImage;
            this.giftData.playerItemId = this.selectedItem.inventoryItem.pid;
            this.addGlow(this.selectedItem, 16711680);
            return;
        }

        private function onLoadImageIntoMovieClipError(arg1:flash.events.IOErrorEvent):void
        {
            return;
        }

        private function nextButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            if (this.selectedItem)
            {
                loc2 = {};
                loc2.giftData = this.giftData;
                this._myLife._interface.showInterface("GiftStepWrap", loc2);
                this.unloadInterface(this);
            }
            else 
            {
                loc3 = "Select An Item";
                loc4 = "Please select an item from your inventory to continue.";
                this._myLife._interface.showInterface("GenericDialog", {"title":loc3, "message":loc4});
            }
            return;
        }

        private function addGlow(arg1:flash.display.DisplayObject, arg2:uint):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = new GlowFilter();
            loc3.inner = true;
            loc3.color = arg2;
            loc3.blurY = loc4 = 6;
            loc3.blurX = loc4;
            arg1.filters = [loc3];
            return;
        }

        private function onPreviewItemRollOut(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as MovieClip;
            if (loc2 != this.selectedItem)
            {
                this.removeGlow(loc2);
            }
            return;
        }

        public function openGiftStore():void
        {
            var loc1:*;

            loc1 = {};
            loc1.storeId = 1018;
            loc1.giftData = {};
            loc1.giftData.recipientName = this.giftData.recipientName;
            loc1.giftData.recipientPlayerId = this.giftData.recipientPlayerId;
            _myLife._interface.showInterface("ViewStoreInventory", loc1);
            return;
        }

        private function onLoadPreviewIntoClipComplete(arg1:flash.events.Event):void
        {
            loadNextPreviewIntoClip();
            return;
        }

        private function purchaseButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            closeWindow();
            openGiftStore();
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private function loadNextPreviewIntoClip():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            if (destroyed)
            {
                return;
            }
            if (loadPreviewIntoClipImageList.length == 0)
            {
                curWorkers++;
                return;
            }
            loc1 = null;
            loc2 = 0;
            loc3 = loadPreviewIntoClipImageList.shift();
            if (loc3)
            {
                loc1 = loc3.img;
                loc2 = loc3.id;
            }
            if (!(loc1 == null) && loc2 > 0)
            {
                loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc2 + "_60_60.gif?v=" + MyLifeConfiguration.version;
                (loc5 = new Loader()).contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPreviewIntoClipComplete);
                loc5.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadPreviewIntoClipIOError);
                loc5.load(new URLRequest(loc4));
                curWorkers++;
                loc1.addChild(loc5);
            }
            return;
        }

        private const START_ITEM_FOR_SALE:Number=0;

        private const START_ITEM_LOCKED:Number=3;

        private const START_ITEM_REMOVE_ONLY:Number=1;

        private const START_ITEM_TRADE_OR_REMOVE:Number=2;

        public var nextButton:flash.display.SimpleButton;

        public var purchaseButton:flash.display.SimpleButton;

        public var previewContainer:flash.display.MovieClip;

        private var inventoryList:Array;

        public var defaultTextField:flash.text.TextField;

        private var destroyed:Boolean=false;

        public var containerBg:flash.display.MovieClip;

        private var maxWorkers:int=16;

        private var containerScrollPane:fl.containers.ScrollPane;

        private var loadPreviewIntoClipImageList:Array;

        public var titleTextField:flash.text.TextField;

        public var cancelWindowButton:flash.display.SimpleButton;

        private var selectedItem:flash.display.MovieClip;

        public var stepTextField:flash.text.TextField;

        private var curWorkers:int=0;

        private var _myLife:flash.display.MovieClip;

        public var giftData:Object;

        private var currentPreviewItemClipParent:flash.display.MovieClip;
    }
}
