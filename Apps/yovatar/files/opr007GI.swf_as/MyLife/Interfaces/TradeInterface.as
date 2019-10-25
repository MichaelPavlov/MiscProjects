package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class TradeInterface extends flash.display.MovieClip
    {
        public function TradeInterface()
        {
            super();
            return;
        }

        private function newDragItemMouseDown(arg1:flash.events.MouseEvent):void
        {
            arg1.currentTarget.activated = true;
            arg1.currentTarget.startDragPoint = new Point(this.mouseX, this.mouseY);
            arg1.currentTarget.addEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP, false, 0, true);
            arg1.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove, false, 0, true);
            return;
        }

        private function tradeItemMouseUpHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = false;
            loc7 = null;
            trace("tradeItemMouseUpHandler()");
            tradeItem.visible = false;
            tradeItem.stopDrag();
            tradeItem.removeEventListener(MouseEvent.MOUSE_MOVE, tradeItemMouseMoveHandler);
            tradeItem.removeEventListener(MouseEvent.MOUSE_UP, tradeItemMouseUpHandler);
            loc2 = this.tradeContainer0.checkMouseOverContainer();
            if (loc2)
            {
                loc3 = this.tradeItemData.image as Bitmap;
                loc4 = loc3.bitmapData;
                loc5 = new Bitmap(loc4);
                if (loc6 = this.tradeContainer0.addItem(loc5, this.tradeItemData.itemId, this.tradeItemData.name))
                {
                    loc7 = this.tradeContainer0.getTradeData();
                    this.sendTradeDataInit();
                }
                else 
                {
                    this.txtStatusMessage.htmlText = "<font color=\'#990000\'><b>All trade containers are full</b></font>";
                    this.addNewItemToItemBar(this.tradeItemData.itemId, this.tradeItemData.childIndex, true);
                }
            }
            else 
            {
                this.addNewItemToItemBar(this.tradeItemData.itemId, this.tradeItemData.childIndex, true);
            }
            return;
        }

        private function checkCompleteTrade():void
        {
            trace("checkCompleteTrade");
            if (this.tradeContainer0.isAgreed && this.tradeContainer1.isAgreed)
            {
                this.txtStatusMessage.htmlText = "<b>Processing Trade...</b>";
                this.sendCompletedTrade();
            }
            return;
        }

        private function previewsComplete():void
        {
            if (this.otherPlayerTradeData)
            {
                this.checkOtherPlayerDataLoad();
            }
            else 
            {
                if (!this.isTrayComplete)
                {
                    this.makeTray();
                }
            }
            return;
        }

        private function sendTradeData():void
        {
            var loc1:*;

            loc1 = this.tradeContainer0.getTradeData();
            TradeManager.sendTradeData(loc1);
            return;
        }

        private function tradeItemMouseMoveHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = this.tradeContainer0.checkMouseOverContainer();
            if (loc2)
            {
                tradeItem.alpha = 1;
            }
            else 
            {
                tradeItem.alpha = 0.5;
            }
            return;
        }

        private function scrollLeftClick(arg1:flash.events.MouseEvent):void
        {
            _scrollOffset = _scrollOffset - ITEMS_PER_SCROLL;
            updateScrollBars();
            return;
        }

        private function cancelButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            TradeManager.cancelTrade();
            return;
        }

        private function shiftBarItems(arg1:Boolean=true, arg2:int=0):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = undefined;
            loc6 = NaN;
            loc3 = _scrollOffset - ITEMS_PER_PAGE;
            loc4 = loc3 + ITEMS_PER_PAGE * 2;
            loc7 = 0;
            loc8 = getMovieChildren(ItemBar);
            for each (loc5 in loc8)
            {
                if (!loc5.active)
                {
                    continue;
                }
                if (!(loc5.childIndex >= arg2))
                {
                    continue;
                }
                loc5.alpha = 1;
                loc10 = ((loc9 = loc5).childIndex + 1);
                loc9.childIndex = loc10;
                loc6 = loc5.childIndex * (loc5.width + ITEM_PADDING);
                if (arg1)
                {
                    if (loc5.childIndex < loc3 || loc5.childIndex > loc4)
                    {
                        loc5.x = loc6;
                    }
                    else 
                    {
                        TweenLite.to(loc5, 0.5, {"x":loc6});
                    }
                    continue;
                }
                loc5.x = loc6;
            }
            return;
        }

        private function scrollRightClick(arg1:flash.events.MouseEvent):void
        {
            _scrollOffset = _scrollOffset + ITEMS_PER_SCROLL;
            updateScrollBars();
            return;
        }

        private function sendAgreementInit():void
        {
            clearTimeout(timeoutId);
            this.timeoutId = setTimeout(sendAgreement, SETTIMEOUT_DELAY);
            return;
        }

        private function enableButton(arg1:*, arg2:Boolean):void
        {
            arg1.mouseEnabled = arg2;
            arg1.alpha = arg2 ? 1 : 0.2;
            return;
        }

        private function sendCompletedTrade():void
        {
            var loc1:*;

            loc1 = new Array(2);
            loc1[0] = this.rawTradeData;
            loc1[1] = this.otherPlayerRawTradeData;
            TradeManager.sendCompletedTrade({"trade":loc1});
            return;
        }

        private function loadPreviewImages():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = 0;
            loc2 = null;
            loc3 = 0;
            loc4 = this.itemIdLoadList;
            for each (loc1 in loc4)
            {
                loc2 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc1 + "_60_60.gif";
                AssetsManager.getInstance().loadImage(loc2, inventoryItems[loc1], loadImageCallback);
            }
            return;
        }

        private function resetTradeText():void
        {
            this.txtTitle.htmlText = "Secure Trade";
            this.txtStatusMessage.htmlText = "";
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            makeInventoryList();
            loadPreviews();
            return;
        }

        private function removeClipFromParentDisplay(arg1:flash.display.DisplayObject):void
        {
            if (arg1.parent)
            {
                arg1.parent.removeChild(arg1);
            }
            return;
        }

        private function newDragItemMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = NaN;
            if (arg1.buttonDown && arg1.currentTarget.activated)
            {
                loc2 = Math.abs(this.mouseX - arg1.currentTarget.startDragPoint.x) + Math.abs(this.mouseY - arg1.currentTarget.startDragPoint.y);
                if (loc2 > 5 && !this.tradeContainer0.isAgreed)
                {
                    arg1.currentTarget.activated = false;
                    arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP);
                    arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove);
                    this.makeTradeItem(arg1.currentTarget.itemId, arg1.currentTarget.childIndex);
                    removeItemFromBar(arg1.currentTarget.childIndex);
                }
            }
            return;
        }

        private function coinUpdateHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = this._myLife.player.getCoinBalance();
            loc3 = this.tradeContainer0.getCoins();
            if (loc3 > loc2)
            {
                this.tradeContainer0.setCoins(loc2);
            }
            this.sendTradeDataInit();
            return;
        }

        private function loadPreviews():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc1 = {};
            loc3 = this.itemIdLoadList.length;
            while (loc3--) 
            {
                loc2 = this.itemIdLoadList[loc3];
                loc1[loc2] = true;
            }
            this.itemIdLoadList = [];
            loc4 = 0;
            loc5 = loc1;
            for (loc2 in loc5)
            {
                this.itemIdLoadList.push(loc2);
            }
            this.loadPreviewImages();
            return;
        }

        private function addListeners():void
        {
            this.scrollLeft.addEventListener(MouseEvent.CLICK, scrollLeftClick, false, 0, true);
            this.scrollRight.addEventListener(MouseEvent.CLICK, scrollRightClick, false, 0, true);
            this.cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler, false, 0, true);
            return;
        }

        public function setOtherPlayerTradeData(arg1:Object):void
        {
            var loc2:*;

            trace("setOtherPlayerTradeData()");
            loc2 = true;
            if (this.otherPlayerTradeData)
            {
                loc2 = this.checkTradeScam(arg1, this.otherPlayerTradeData);
            }
            trace("isValid = " + loc2);
            if (loc2)
            {
                this.otherPlayerTradeData = arg1;
                this.resetTradeText();
                if (this.otherPlayerTradeData.items.length)
                {
                    if (this.isTrayComplete)
                    {
                        this.checkOtherPlayerDataLoad();
                    }
                }
                else 
                {
                    if (this.otherPlayerTradeData.coins)
                    {
                        this.tradeContainer1.setCoins(this.otherPlayerTradeData.coins);
                    }
                    else 
                    {
                        this.showScamText();
                    }
                }
            }
            else 
            {
                TradeManager.cancelTradeScam();
            }
            return;
        }

        private function checkOtherPlayerDataLoad():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = false;
            loc5 = 0;
            loc1 = this.otherPlayerTradeData.items;
            loc2 = loc1.length;
            if (this.otherPlayerTradeData.loaded)
            {
                this.tradeContainer1.reset();
                while (loc2--) 
                {
                    loc3 = loc1[loc2];
                    loc5 = loc3.quantity;
                    while (loc5--) 
                    {
                        this.tradeContainer1.addItem(this.inventoryItems[loc3.itemId].image, loc3.itemId, loc3.name);
                    }
                }
                this.tradeContainer1.setCoins(this.otherPlayerTradeData.coins);
                if (!this.isTrayComplete)
                {
                    this.makeTray();
                }
            }
            else 
            {
                this.itemIdLoadList = [];
                if (loc2)
                {
                    while (loc2--) 
                    {
                        loc3 = loc1[loc2];
                        this.itemIdLoadList.push(Number(loc3.itemId));
                        if (this.inventoryItems[loc3.itemId])
                        {
                            continue;
                        }
                        this.inventoryItems[loc3.itemId] = {"itemId":loc3.itemId, "isForOtherPlayer":true};
                    }
                    this.loadPreviewImages();
                }
                this.otherPlayerTradeData.loaded = true;
            }
            return;
        }

        private function getMovieChildren(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
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

        public function initialize(arg1:flash.display.MovieClip, arg2:Object=null):void
        {
            var loc3:*;

            this._myLife = arg1;
            isCostumesDisabled = !Boolean(Number(arg1.myLifeConfiguration.variables["global"]["costumesEnabled"]));
            tradeContainer0 = new TradeContainer();
            container0.addChild(tradeContainer0);
            tradeContainer1 = new TradeContainer();
            container1.addChild(tradeContainer1);
            this.tradeContainer0.setTitle("You Offer:");
            this.tradeContainer0.addEventListener("coinUpdate", coinUpdateHandler, false, 0, true);
            this.tradeContainer0.addEventListener("agreeClick", agreeClickHandler, false, 0, true);
            loc3 = arg2.otherPlayerName || "Other Player";
            this.tradeContainer1.setTitle(loc3 + " Offers:");
            this.tradeContainer1.disable();
            this.txtStatusMessage.text = "";
            this.txtTrayMessage.mouseEnabled = false;
            if (InventoryManager.ready)
            {
                makeInventoryList();
                loadPreviews();
            }
            else 
            {
                InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
                InventoryManager.loadInventory();
            }
            addListeners();
            return;
        }

        private function makeTray():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc1 = null;
            loc3 = 0;
            loc4 = 0;
            loc2 = 0;
            loc5 = 0;
            loc6 = this.inventoryList;
            for each (loc1 in loc6)
            {
                if (loc1.isForOtherPlayer)
                {
                    continue;
                }
                addNewItemToItemBar(loc1.itemId, loc2, false);
                ++loc2;
            }
            loc3 = 4 - ItemBar.numChildren;
            loc4 = -1;
            while (loc3 > 0) 
            {
                loc3 = (loc3 - 1);
                addNewItemToItemBar(loc4, loc2, false);
                loc4 = (loc4 - 1);
            }
            this.isTrayComplete = true;
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        private function makeTradeItem(arg1:*, arg2:int=0):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = 0;
            this.tradeItemData = this.inventoryItems[arg1];
            this.tradeItemData.childIndex = arg2;
            loc3 = this.tradeItemData.image as Bitmap;
            loc4 = loc3.bitmapData;
            loc5 = new Bitmap(loc4);
            loc5.x = -(loc5.width >> 1);
            loc5.y = -(loc5.height >> 1);
            if (this.tradeItem)
            {
                if ((loc6 = this.getChildIndex(this.tradeItem)) >= 0)
                {
                    this.removeChildAt(loc6);
                }
            }
            tradeItem = new Sprite();
            tradeItem.addChild(loc5);
            tradeItem.useHandCursor = loc7 = true;
            tradeItem.buttonMode = loc7;
            tradeItem.alpha = 0.5;
            tradeItem.startDrag(true);
            tradeItem.addEventListener(MouseEvent.MOUSE_MOVE, tradeItemMouseMoveHandler, false, 0, true);
            tradeItem.addEventListener(MouseEvent.MOUSE_UP, tradeItemMouseUpHandler, false, 0, true);
            this.addChild(tradeItem);
            return;
        }

        private function makeInventoryList():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            trace("makeInventoryList");
            inventoryList = MyLifeUtils.cloneObject(InventoryManager.getTradableInventory());
            itemIdLoadList = [];
            inventoryItems = {};
            loc2 = 0;
            loc3 = inventoryList;
            for each (loc1 in loc3)
            {
                itemIdLoadList.push(loc1.itemId);
                inventoryItems[loc1.itemId] = loc1;
            }
            if (!this.inventoryList.length)
            {
                this.txtTrayMessage.htmlText = "<b>No Tradable Items Available</b>";
                isTrayComplete = true;
            }
            return;
        }

        private function updateScrollBars():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = undefined;
            loc1 = _scrollOffset;
            loc2 = _scrollOffset + ITEMS_PER_PAGE;
            loc3 = 45 + -_scrollOffset * 140;
            loc4 = 0;
            loc7 = 0;
            loc8 = getMovieChildren(ItemBar);
            for each (loc5 in loc8)
            {
                if (loc5.itemId > 0)
                {
                    loc4 = (loc4 + 1);
                }
                if (loc5.childIndex < loc1 - ITEMS_PER_PAGE || loc5.childIndex > loc2 + ITEMS_PER_PAGE)
                {
                    loc5.visible = false;
                    continue;
                }
                loc5.visible = true;
            }
            TweenLite.to(ItemBar, 0.5, {"x":loc3});
            if (_scrollOffset <= 0)
            {
                enableButton(scrollLeft, false);
            }
            else 
            {
                enableButton(scrollLeft, true);
            }
            if (loc2 >= loc4)
            {
                enableButton(scrollRight, false);
            }
            else 
            {
                enableButton(scrollRight, true);
            }
            if (loc4 == loc1)
            {
                if (_scrollOffset > 0)
                {
                    _scrollOffset = _scrollOffset - ITEMS_PER_SCROLL;
                    updateScrollBars();
                }
            }
            loc6 = false;
            loc7 = 0;
            loc8 = getMovieChildren(ItemBar);
            for each (loc5 in loc8)
            {
                if (!(loc5.itemId > 0 && loc5.active))
                {
                    continue;
                }
                loc6 = true;
                break;
            }
            if (loc6)
            {
                this.txtTrayMessage.text = "";
            }
            else 
            {
                this.txtTrayMessage.htmlText = "<b>No Tradable Items Available</b>";
            }
            return;
        }

        private function checkTradeScam(arg1:Object, arg2:Object):Boolean
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc4 = null;
            loc5 = null;
            loc6 = false;
            trace("checkTradeScam()");
            loc3 = !tradeContainer1.isAgreed;
            if (arg1.coins < arg2.coins)
            {
                loc3 = false;
            }
            loc7 = 0;
            loc8 = arg2.items;
            for each (loc5 in loc8)
            {
                loc6 = false;
                loc9 = 0;
                loc10 = arg1.items;
                for each (loc4 in loc10)
                {
                    if (Number(loc4.itemId) != Number(loc5.itemId))
                    {
                        continue;
                    }
                    if (Number(loc4.quantity) >= Number(loc5.quantity))
                    {
                        loc6 = true;
                    }
                    break;
                }
                if (loc6)
                {
                    continue;
                }
                loc3 = false;
            }
            return loc3;
        }

        private function sendAgreement():void
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
            var loc10:*;
            var loc11:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = undefined;
            loc8 = undefined;
            loc9 = 0;
            loc10 = 0;
            loc11 = 0;
            loc1 = this.tradeContainer0.isAgreed;
            this.rawTradeData = {};
            if (loc1)
            {
                loc2 = [];
                loc3 = this.tradeContainer0.getTradeData();
                loc4 = loc3.items;
                loc10 = this.inventoryList.length;
                while (loc10--) 
                {
                    (loc6 = this.inventoryList[loc10]).taken = false;
                }
                loc10 = loc4.length;
                while (loc10--) 
                {
                    loc7 = (loc5 = loc4[loc10]).itemId;
                    loc9 = loc5.quantity;
                    while (loc9--) 
                    {
                        loc11 = this.inventoryList.length;
                        while (loc11--) 
                        {
                            if (!(!(loc6 = this.inventoryList[loc11]).taken && loc6.itemId == loc7))
                            {
                                continue;
                            }
                            loc8 = loc6.playerItemId;
                            loc2.push({"item_id":loc7, "piid":loc8});
                            loc6.taken = true;
                            continue;
                        }
                    }
                }
                this.rawTradeData.coins = loc3.coins;
                this.rawTradeData.items = loc2;
                this.rawTradeData.isAgree = 1;
            }
            else 
            {
                this.rawTradeData.isAgree = 0;
            }
            TradeManager.sendAgreement(rawTradeData);
            if (loc1)
            {
                this.checkCompleteTrade();
            }
            return;
        }

        private function checkTradeMatch(arg1:Object, arg2:Object):Boolean
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            trace("checkTradeMatch()");
            loc3 = true;
            if (arg1.coins != arg2.coins)
            {
                loc3 = false;
            }
            loc4 = {};
            loc5 = 0;
            loc9 = 0;
            loc10 = arg1.items;
            for each (loc6 in loc10)
            {
                if (loc4[loc6.item_id])
                {
                    loc4[loc6.item_id] = loc4[loc6.item_id] + 1;
                    continue;
                }
                loc4[loc6.item_id] = 1;
                loc5 = loc5 + 1;
            }
            if (loc5 != arg2.items.length)
            {
                loc3 = false;
            }
            else 
            {
                if (arg2.items.length >= 1)
                {
                    loc8 = arg2.items.length;
                    while (loc8--) 
                    {
                        if (!(!(loc7 = loc4[arg2.items[loc8].itemId]) || !(loc7 == arg2.items[loc8].quantity)))
                        {
                            continue;
                        }
                        loc3 = false;
                    }
                }
            }
            return loc3;
        }

        private function removeItemFromBar(arg1:int, arg2:Boolean=true):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = undefined;
            loc6 = NaN;
            loc3 = _scrollOffset - ITEMS_PER_PAGE;
            loc4 = loc3 + ITEMS_PER_PAGE * 2;
            loc7 = 0;
            loc8 = getMovieChildren(ItemBar);
            for each (loc5 in loc8)
            {
                if (loc5.childIndex < arg1)
                {
                    continue;
                }
                if (loc5.childIndex == arg1)
                {
                    loc5.visible = true;
                    loc5.alpha = 1;
                    loc5.active = false;
                    loc5.childIndex = -1;
                    TweenLite.to(loc5, 0.25, {"alpha":0, "onComplete":removeClipFromParentDisplay, "onCompleteParams":[loc5]});
                    continue;
                }
                if (!(loc5.childIndex > arg1))
                {
                    continue;
                }
                loc10 = ((loc9 = loc5).childIndex - 1);
                loc9.childIndex = loc10;
                loc6 = loc5.childIndex * (loc5.width + ITEM_PADDING);
                if (arg2)
                {
                    if (loc5.childIndex < loc3 || loc5.childIndex > loc4)
                    {
                        loc5.x = loc6;
                    }
                    else 
                    {
                        TweenLite.to(loc5, 0.5, {"x":loc6});
                    }
                    continue;
                }
                loc5.x = loc6;
            }
            updateScrollBars();
            return;
        }

        private function addNewItemToItemBar(arg1:*, arg2:int=0, arg3:Boolean=true):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            arg2 = arg2 || _scrollOffset;
            this.shiftBarItems(arg3, arg2);
            (loc4 = new RoomItemSelectorBarItem()).x = arg2 * (loc4.width + ITEM_PADDING);
            loc4.itemId = arg1;
            loc4.childIndex = arg2;
            loc4.active = true;
            if (arg1 > 0)
            {
                if (loc6 = (loc5 = this.inventoryItems[arg1]).image as Bitmap)
                {
                    loc7 = loc6.bitmapData;
                    loc8 = new Bitmap(loc7, "never", true);
                    loc8.x = -loc8.width >> 1;
                    loc8.y = -loc8.height >> 1;
                    loc4.previewBox.addChild(loc8);
                }
                else 
                {
                    if (!MyLifeConfiguration.getInstance().runningLocal)
                    {
                        ExceptionLogger.logException("BAD ITEM LOAD: PlayerID(" + MyLifeConfiguration.getInstance().playerId + "), ItemId(" + arg1 + "), PlayerItemId(" + loc5["playerItemId"] + ")", "TradeInterfaceError");
                        return;
                    }
                }
                loc4.txtName.text = loc5.name;
                loc4.buttonMode = true;
                loc4.activated = false;
                loc4.addEventListener(MouseEvent.MOUSE_DOWN, newDragItemMouseDown, false, 0, true);
            }
            else 
            {
                loc4.buttonMode = false;
                loc4.txtName.text = "";
                loc4.bg.alpha = 0.5;
            }
            ItemBar.addChild(loc4);
            if (arg3)
            {
                loc4.alpha = 0;
                TweenLite.to(loc4, 1, {"alpha":1});
            }
            updateScrollBars();
            return;
        }

        private function showScamText():void
        {
            this.txtTitle.htmlText = "<font color=\'#ff0000\'><b>SCAM ALERT! THE OTHER PLAYER IS NOT TRADING ANYTHING!</b></font>";
            this.txtStatusMessage.htmlText = "<font color=\'#990000\'><b>Click the cancel button to prevent giving away your stuff.</b></font>";
            return;
        }

        private function agreeClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = false;
            loc2 = this.tradeContainer0.isAgreed;
            if (loc2)
            {
                loc3 = true;
                this.tradeContainer0.disable(loc3);
                this.resetTradeText();
                if (!this.tradeContainer1.isAgreed)
                {
                    this.txtStatusMessage.htmlText = "<b>Waiting for other player to agree</b>";
                }
                if (!this.otherPlayerTradeData)
                {
                    this.showScamText();
                }
            }
            else 
            {
                this.resetTradeText();
                this.tradeContainer0.enable();
            }
            this.sendAgreementInit();
            return;
        }

        private function newDragItemMouseUP(arg1:flash.events.MouseEvent):void
        {
            arg1.currentTarget.activated = false;
            arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP);
            arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove);
            return;
        }

        private function loadImageCallback(arg1:*, arg2:*):void
        {
            var loc3:*;

            loc3 = 0;
            if (arg1)
            {
                arg2["image"] = arg1;
            }
            else 
            {
                if (this.otherPlayerTradeData)
                {
                    if (this.otherPlayerTradeData.items && this.otherPlayerTradeData.items.length)
                    {
                        this.otherPlayerTradeData.loaded = false;
                        if (this.isTrayComplete)
                        {
                            this.checkOtherPlayerDataLoad();
                        }
                    }
                    if (this.otherPlayerTradeData.coins)
                    {
                        this.tradeContainer1.setCoins(this.otherPlayerTradeData.coins);
                    }
                }
            }
            if (itemIdLoadList && itemIdLoadList.length)
            {
                loc3 = itemIdLoadList.indexOf(Number(arg2.itemId));
                if (loc3 >= 0)
                {
                    itemIdLoadList.splice(loc3, 1);
                }
                if (!this.itemIdLoadList.length)
                {
                    this.previewsComplete();
                }
            }
            return;
        }

        public function setOtherPlayerAgreement(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = false;
            if (!this.otherPlayerTradeData)
            {
                setOtherPlayerTradeData(arg1);
            }
            loc2 = Boolean(Number(arg1.isAgree));
            if (loc2)
            {
                loc3 = this.checkTradeMatch(arg1, this.otherPlayerTradeData);
                trace("isMatch = " + loc3);
                if (loc3)
                {
                    this.otherPlayerRawTradeData = arg1;
                    this.tradeContainer1.setCheckBoxAgree(loc2);
                    this.checkCompleteTrade();
                }
                else 
                {
                    TradeManager.cancelTradeScam();
                }
            }
            else 
            {
                tradeContainer1.setCheckBoxAgree(loc2);
            }
            return;
        }

        private function sendTradeDataInit():void
        {
            clearTimeout(timeoutId);
            this.timeoutId = setTimeout(sendTradeData, SETTIMEOUT_DELAY);
            return;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }

        private const ITEM_PADDING:int=10;

        private const ITEMS_PER_PAGE:int=4;

        private const ITEMS_PER_SCROLL:int=4;

        private const SETTIMEOUT_DELAY:int=500;

        private var tradeItem:flash.display.Sprite;

        private var inventoryList:Array;

        private var otherPlayerTradeData:Object;

        public var otherPlayerRawTradeData:Object;

        private var _scrollOffset:int=0;

        public var txtStatusMessage:flash.text.TextField;

        private var inventoryItems:Object;

        public var txtTitle:flash.text.TextField;

        public var scrollRight:flash.display.SimpleButton;

        private var itemIdLoadList:Array;

        public var cancelButton:flash.display.SimpleButton;

        public var tradeContainer1:MyLife.Interfaces.TradeContainer;

        public var container0:flash.display.MovieClip;

        public var container1:flash.display.MovieClip;

        private var isTrayComplete:Boolean;

        public var tradeContainer0:MyLife.Interfaces.TradeContainer;

        private var timeoutId:int;

        public var ItemBar:flash.display.MovieClip;

        private var tradeItemData:Object;

        public var rawTradeData:Object;

        private var _myLife:flash.display.MovieClip;

        public var txtTrayMessage:flash.text.TextField;

        public var scrollLeft:flash.display.SimpleButton;

        private var isCostumesDisabled:Boolean=true;
    }
}
