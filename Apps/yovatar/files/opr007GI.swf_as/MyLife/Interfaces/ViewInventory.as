package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.UI.*;
    import fl.containers.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class ViewInventory extends flash.display.MovieClip
    {
        public function ViewInventory()
        {
            TabButtonNormal = ViewInventory_TabButtonNormal;
            TabButtonSelected = ViewInventory_TabButtonSelected;
            TabButtonOver = ViewInventory_TabButtonOver;
            _playerInventory = [];
            _itemPreviews = {"inUse":{}, "available":{}};
            loadPreviewIntoClipImageList = [];
            super();
            trace("ViewInventory Loaded");
            buttonGroup = new RadioButtonManager();
            btnAll = createToggleButton("All");
            btnClothes = createToggleButton("Clothes");
            btnClothes.x = btnAll.x + btnAll.width + 5;
            btnFurniture = createToggleButton("Furniture");
            btnFurniture.x = btnClothes.x + btnClothes.width + 5;
            btnConsumable = createToggleButton("Special");
            btnConsumable.x = btnFurniture.x + btnFurniture.width + 5;
            buttonGroup.addButton(btnAll);
            buttonGroup.addButton(btnClothes);
            buttonGroup.addButton(btnFurniture);
            buttonGroup.addButton(btnConsumable);
            tabGroupContainer.addChildAt(btnAll, 0);
            tabGroupContainer.addChildAt(btnClothes, 0);
            tabGroupContainer.addChildAt(btnFurniture, 0);
            tabGroupContainer.addChildAt(btnConsumable, 0);
            _currentFilter = 0;
            return;
        }

        private function disableInventoryItem(arg1:*):void
        {
            if (arg1)
            {
                arg1.mcLoading.visible = false;
                arg1.alpha = 0.25;
                arg1.mouseEnabled = false;
                arg1.enabled = false;
                arg1.buttonMode = false;
                arg1.removeEventListener(MouseEvent.CLICK, onPreviewItemClick);
            }
            return;
        }

        private function closeWindow():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = NaN;
            btnAll.visible = false;
            btnClothes.visible = false;
            btnFurniture.visible = false;
            btnConsumable.visible = false;
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            if (_showEatAnimationOnClose)
            {
                _showEatAnimationOnClose = false;
                loc1 = ActionTweenType.EAT;
                loc2 = _myLife.getPlayer().getCharacter()["serverUserId"];
                ActionTweenManager.instance.broadcastActionTween(loc1, loc2, loc2);
            }
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            dispatchEvent(new Event(Event.CLOSE));
            _myLife.hideDialog(arg1);
            alpha = 1;
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String, arg3:int=0, arg4:int=0):*
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc6 = undefined;
            loc7 = null;
            loc5 = getMovieChildren(arg1);
            loc8 = 0;
            loc9 = loc5;
            for each (loc6 in loc9)
            {
                arg1.removeChild(loc6);
            }
            (loc7 = new Loader()).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageIntoMovieClipError);
            loc7.load(new URLRequest(arg2));
            arg1.addChild(loc7);
            loc7.x = arg3;
            loc7.y = arg4;
            return;
        }

        private function cancelWindowButtonClick(arg1:flash.events.MouseEvent):void
        {
            removeListeners();
            closeWindow();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            addListeners();
            buttonGroup.selectButton(btnAll);
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

        public function destroy():void
        {
            _destroyed = true;
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private function inventoryRemoveItemHandler(arg1:MyLife.Events.InventoryEvent):void
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

            loc3 = undefined;
            loc4 = null;
            loc5 = undefined;
            loc6 = null;
            loc7 = null;
            loc8 = undefined;
            loc9 = null;
            loc2 = createNewItem(arg1.eventData);
            if (loc2)
            {
                loc3 = loc2.pid;
                loc4 = null;
                loc10 = 0;
                loc11 = _playerInventory;
                for each (loc5 in loc11)
                {
                    if (loc5.pid != loc3)
                    {
                        continue;
                    }
                    loc4 = loc5;
                    break;
                }
                if (loc4)
                {
                    _playerInventory.splice(_playerInventory.indexOf(loc4), 1);
                    loc6 = loc4.inUse ? "inUse" : "available";
                    if (_itemPreviews[loc6][loc2.id])
                    {
                        loc7 = _itemPreviews[loc6][loc2.id];
                        loc10 = 0;
                        loc11 = loc7.inventoryItem;
                        for each (loc8 in loc11)
                        {
                            if (loc8.pid != loc4.pid)
                            {
                                continue;
                            }
                            loc7.inventoryItem.splice(loc7.inventoryItem.indexOf(loc8), 1);
                            break;
                        }
                        if (loc7.count > 1)
                        {
                            loc7.count = (loc7.count - 1);
                        }
                        else 
                        {
                            if (itemInCurrentCategory(loc2))
                            {
                                _itemPreviews[loc6][loc2.id] = null;
                                loc9 = null;
                                if (_selectedButton == btnConsumable)
                                {
                                    loc9 = {"canConsume":"1"};
                                }
                                _displayedInventory = filterById(_currentFilter, loc9);
                                loadItemsIntoContainer();
                                if (containerScrollPane)
                                {
                                    containerScrollPane.refreshPane();
                                }
                            }
                        }
                    }
                }
            }
            return;
        }

        private function removeListeners():void
        {
            cancelWindowButton.removeEventListener(MouseEvent.CLICK, cancelWindowButtonClick);
            btnAll.removeEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnClothes.removeEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnFurniture.removeEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnConsumable.removeEventListener(MouseEvent.CLICK, filterInventoryHandler);
            InventoryManager.getInstance().removeEventListener(InventoryEvent.ADD_ITEM, inventoryAddItemHandler);
            InventoryManager.getInstance().removeEventListener(InventoryEvent.REMOVE_ITEM, inventoryRemoveItemHandler);
            return;
        }

        internal function getMovieChildren(arg1:flash.display.MovieClip):Array
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

        private function addListeners():void
        {
            cancelWindowButton.addEventListener(MouseEvent.CLICK, cancelWindowButtonClick);
            btnAll.addEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnClothes.addEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnFurniture.addEventListener(MouseEvent.CLICK, filterInventoryHandler);
            btnConsumable.addEventListener(MouseEvent.CLICK, filterInventoryHandler);
            InventoryManager.getInstance().addEventListener(InventoryEvent.ADD_ITEM, inventoryAddItemHandler);
            InventoryManager.getInstance().addEventListener(InventoryEvent.REMOVE_ITEM, inventoryRemoveItemHandler);
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            loadPlayerItems();
            return;
        }

        internal function loadItemsIntoContainer():void
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
            var loc12:*;
            var loc13:*;

            loc4 = undefined;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc1 = 0;
            loc2 = 0;
            _displayedInventory.sortOn(["name"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
            loc3 = 0;
            loc10 = 0;
            loc11 = _displayedInventory;
            for each (loc4 in loc11)
            {
                loc1 = loc3 % 6;
                loc2 = (loc3 - loc1) / 6;
                loc5 = loc4.inUse ? "inUse" : "available";
                if (_itemPreviews[loc5][loc4.id])
                {
                    if (!(loc6 = _itemPreviews[loc5][loc4.id]).parent)
                    {
                        previewContainer.addChild(loc6);
                        loc6.x = loc1 * loc6.width;
                        loc6.y = loc2 * loc6.height;
                        loc3 = (loc3 + 1);
                    }
                }
                else 
                {
                    loc6 = new ViewInventoryItemPreview();
                    _itemPreviews[loc5][loc4.id] = loc6;
                    loc6.inventoryItem = [];
                    previewContainer.addChild(loc6);
                    loc6.x = loc1 * loc6.width;
                    loc6.y = loc2 * loc6.height;
                    loc6.starterItem.visible = false;
                    loc6.nonRefundable.visible = false;
                    loc6.freeGift.visible = false;
                    loc12 = Number(loc4.startItem);
                    switch (loc12) 
                    {
                        case StartItemType.REMOVE_ONLY:
                            loc4.sellPrice = loc12 = 0;
                            loc4.price = loc12;
                            if (!loc4.inUse)
                            {
                                loc6.inUse.visible = false;
                                loc6.starterItem.visible = true;
                            }
                            break;
                        case StartItemType.LOCKED:
                            loc4.sellPrice = loc12 = 0;
                            loc4.price = loc12;
                            if (!loc4.inUse)
                            {
                                loc6.inUse.visible = false;
                                loc6.nonRefundable.visible = true;
                            }
                            break;
                        case StartItemType.TRADE_OR_REMOVE:
                            loc4.sellPrice = loc12 = 0;
                            loc4.price = loc12;
                            if (!loc4.inUse)
                            {
                                loc6.inUse.visible = false;
                                loc6.nonRefundable.visible = true;
                            }
                            break;
                        case StartItemType.FREE_GIFT:
                            loc4.sellPrice = loc12 = 0;
                            loc4.price = loc12;
                            if (!loc4.inUse)
                            {
                                loc6.inUse.visible = false;
                                loc6.freeGift.visible = true;
                            }
                            break;
                        default:
                            loc6.inUse.visible = loc4.inUse;
                            break;
                    }
                    loc6.txtName.text = loc4.name;
                    loc7 = getMovieChildren(loc6.previewImage);
                    loc12 = 0;
                    loc13 = loc7;
                    for each (loc8 in loc13)
                    {
                        loc6.previewImage.removeChild(loc8);
                    }
                    addPreviewItemHooks(loc6);
                    loc9 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + loc4.id + "_60_60.gif?v=" + MyLifeConfiguration.version;
                    AssetsManager.getInstance().loadImage(loc9, loc6.previewImage, imageLoadedCallback);
                    loc3 = (loc3 + 1);
                }
                loc6.count = loc6.count + 1;
                loc6.inventoryItem.push(loc4);
            }
            return;
        }

        private function loadPlayerItems():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = undefined;
            loc1 = InventoryManager.getPlayerInventory().slice();
            _inventoryInUseList = InventoryManager.getAllItemsInUse();
            loc4 = 0;
            loc5 = loc1;
            for each (loc2 in loc5)
            {
                loc3 = createNewItem(loc2);
                if (!loc3)
                {
                    continue;
                }
                _playerInventory.push(loc3);
            }
            _displayedInventory = _playerInventory.slice();
            btnConsumable.visible = filterById(-100, {"canConsume":"1"}).length > 0;
            loadItemsIntoContainer();
            putContainerIntoScrollPane();
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

        private function onPreviewItemRollOver(arg1:flash.events.MouseEvent):void
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

        private function putContainerIntoScrollPane():void
        {
            containerScrollPane = new ScrollPane();
            containerScrollPane.verticalScrollPolicy = ScrollPolicy.ON;
            containerScrollPane.horizontalScrollBar.visible = false;
            this.addChildAt(containerScrollPane, (getChildIndex(previewContainer) - 1));
            containerScrollPane.move(previewContainer.x, previewContainer.y);
            containerScrollPane.setSize(441, 263);
            containerScrollPane.source = previewContainer;
            return;
        }

        private function viewItemUseClick(arg1:flash.events.MouseEvent):void
        {
            MyLifeInstance.getInstance().getServer().callExtension("useItem", {"inventoryId":viewItemDetailsWindow.inventoryItem.pid});
            if (viewItemDetailsWindow.inventoryItem["metaData"] && !(String(viewItemDetailsWindow.inventoryItem.metaData).indexOf("Consummable") == -1))
            {
                _showEatAnimationOnClose = true;
            }
            viewItemCancelClick(null);
            return;
        }

        internal function addPreviewItemHooks(arg1:*):void
        {
            arg1.buttonMode = true;
            arg1.useHandCursor = true;
            arg1.addEventListener(MouseEvent.CLICK, onPreviewItemClick);
            arg1.addEventListener(MouseEvent.ROLL_OVER, onPreviewItemRollOver);
            arg1.addEventListener(MouseEvent.ROLL_OUT, onPreviewItemRollOut);
            return;
        }

        private function createNewItem(arg1:Object):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = undefined;
            loc5 = undefined;
            loc2 = null;
            if (!arg1.isHidden && arg1.playerId > 1 && !(arg1.parentCategoryId == InventoryManager.INVENTORY_HOMES) && !(arg1.parentCategoryId == InventoryManager.INVENTORY_GIFTWRAP))
            {
                loc3 = arg1.itemId;
                loc4 = arg1.playerItemId;
                loc2 = {"id":loc3, "categoryId":arg1.categoryId, "pid":loc4, "metaData":arg1.metaData, "parentCategoryId":arg1.parentCategoryId, "name":arg1.name, "sellPrice":Math.floor(arg1.price * 0.3), "startItem":arg1.startItem, "canConsume":arg1.can_consume == "1", "inUse":false};
                loc6 = 0;
                loc7 = _inventoryInUseList;
                for each (loc5 in loc7)
                {
                    if (loc4 != loc5.playerItemId)
                    {
                        continue;
                    }
                    loc2.inUse = true;
                    break;
                }
            }
            return loc2;
        }

        private function createToggleButton(arg1:String=null):MyLife.UI.ToggleButton
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = new TabButtonNormal();
            loc3 = new TabButtonSelected();
            loc4 = new TabButtonOver();
            (loc5 = new TabButtonSelected()).label.visible = false;
            loc5.label.autoSize = "left";
            loc5.label.text = " ";
            loc6 = new ToggleButton(loc2, loc3, loc5, loc4);
            if (arg1)
            {
                loc6.name = arg1;
                loc3.label.autoSize = "left";
                loc3.label.text = arg1;
                loc3.button.width = loc3.label.width + 20;
                loc2.label.autoSize = "left";
                loc2.label.text = arg1;
                loc4.label.autoSize = "left";
                loc4.label.text = arg1;
                loc2.button.width = loc7 = loc3.button.width;
                loc4.button.width = loc7 = loc7;
                loc5.button.width = loc7;
            }
            return loc6;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function viewItemCancelClick(arg1:flash.events.MouseEvent):void
        {
            if (viewItemDetailsWindow)
            {
                TweenLite.to(viewItemDetailsWindow, 0.5, {"alpha":0, "onComplete":removeChild, "onCompleteParams":[viewItemDetailsWindow]});
                viewItemDetailsWindow.btnCancel.removeEventListener(MouseEvent.CLICK, viewItemCancelClick);
                viewItemDetailsWindow.btnSell.removeEventListener(MouseEvent.CLICK, viewItemSellClick);
                viewItemDetailsWindow.btnUse.removeEventListener(MouseEvent.CLICK, viewItemUseClick);
                viewItemDetailsWindow = null;
            }
            currentPreviewItemClipParent = null;
            return;
        }

        private function inventoryAddItemHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc2 = createNewItem(arg1.eventData);
            if (loc2)
            {
                _playerInventory.push(loc2);
                loc3 = loc2.inUse ? "inUse" : "available";
                if (_itemPreviews[loc3][loc2.id])
                {
                    loc4 = _itemPreviews[loc3][loc2.id];
                    loc4.count = loc4.count + 1;
                    loc4.inventoryItem.push(loc2);
                }
                else 
                {
                    if (itemInCurrentCategory(loc2))
                    {
                        loc5 = null;
                        if (_selectedButton == btnConsumable)
                        {
                            loc5 = {"canConsume":"1"};
                        }
                        _displayedInventory = filterById(_currentFilter, loc5);
                        loadItemsIntoContainer();
                        if (containerScrollPane)
                        {
                            containerScrollPane.refreshPane();
                        }
                    }
                }
            }
            return;
        }

        internal function onPreviewItemClick(arg1:flash.events.MouseEvent):*
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

            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc2 = arg1.currentTarget as ViewInventoryItemPreview;
            loc3 = loc2.inventoryItem[0];
            currentPreviewItemClipParent = loc2;
            loc4 = new ViewInventoryItemDetails();
            addChild(loc4);
            loc4.txtItemName.text = loc2.txtName.text;
            if (loc2.count > 1)
            {
                loc4.txtItemName.appendText(" x" + loc2.count);
            }
            loc4.x = 326;
            loc4.y = 303;
            loc4.btnUse.visible = loc3.canConsume && !loc3.inUse;
            if (loc3["metaData"])
            {
                loc6 = String(loc3.metaData).split("|");
                loc9 = 0;
                loc10 = loc6;
                for each (loc7 in loc10)
                {
                    if ((loc8 = loc7.split(":"))[0] != "action")
                    {
                        continue;
                    }
                    loc4.btnUse.label.text = loc8[1];
                }
            }
            if (loc4.btnUse.visible != false)
            {
                loc4.btnSell.visible = false;
            }
            else 
            {
                loc4.picture.y = loc4.picture.y + 18;
                loc4.btnSell.y = loc4.btnSell.y + 28;
            }
            loc9 = Number(loc3.startItem);
            switch (loc9) 
            {
                case StartItemType.LOCKED:
                    loc4.btnUse.visible = false;
                    loc4.btnSell.visible = false;
                    break;
                case StartItemType.REMOVE_ONLY:
                case StartItemType.TRADE_OR_REMOVE:
                    loc4.btnSell.deleteMessage.visible = true;
                    loc4.btnSell.sellMessage.visible = false;
                    break;
                default:
                    if (!loc3.inUse)
                    {
                        if (loc3.sellPrice)
                        {
                            loc4.btnSell.sellMessage.txtPrice.text = loc3.sellPrice;
                            loc4.btnSell.deleteMessage.visible = false;
                            loc4.btnSell.sellMessage.visible = true;
                        }
                        else 
                        {
                            loc4.btnSell.deleteMessage.visible = true;
                            loc4.btnSell.sellMessage.visible = false;
                        }
                    }
                    break;
            }
            loc5 = "";
            if (loc3.categoryId == 2001 || loc3.categoryId == 2002)
            {
                loc5 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc3.id + "_110_80.gif";
                loadImageIntoMovieClip(loc4.picture.image, loc5, 10, (10));
            }
            else 
            {
                loc5 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc3.id + "_130_100.gif";
                loadImageIntoMovieClip(loc4.picture.image, loc5);
            }
            loc4.inventoryItem = loc3;
            loc4.previewItem = loc2;
            loc4.mcItemInUse.visible = loc3.inUse;
            loc4.btnSell.visible = loc4.btnSell.visible && !loc3.inUse;
            loc4.picture.y = loc4.picture.y + loc3.inUse ? 18 : 0;
            viewItemDetailsWindow = loc4;
            viewItemDetailsWindow.btnCancel.addEventListener(MouseEvent.CLICK, viewItemCancelClick);
            viewItemDetailsWindow.btnSell.addEventListener(MouseEvent.CLICK, viewItemSellClick);
            viewItemDetailsWindow.btnUse.addEventListener(MouseEvent.CLICK, viewItemUseClick);
            return;
        }

        private function viewItemSellClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc2 = Number(viewItemDetailsWindow.inventoryItem.startItem);
            if (loc2 != StartItemType.LOCKED)
            {
                loc3 = viewItemDetailsWindow.inventoryItem.sellPrice;
                loc4 = viewItemDetailsWindow.inventoryItem.name;
                InventoryManager.removeItemFromInventory(viewItemDetailsWindow.inventoryItem.pid);
                MyLifeInstance.getInstance().getServer().callExtension("sellInventoryItem", {"piid":viewItemDetailsWindow.inventoryItem.pid, "value":loc3});
                if (loc3)
                {
                    loc5 = "You Sold An Inventory Item";
                    loc6 = "You have received " + loc3 + " coins back for selling your \'" + loc4 + "\'.";
                    loc7 = "";
                }
                else 
                {
                    loc5 = "You Removed An Inventory Item";
                    loc6 = "Your \'" + loc4 + "\' has been removed.";
                }
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc5, "message":loc6, "icon":"coins", "metaData":{"coins":loc3}});
                viewItemCancelClick(null);
            }
            return;
        }

        private function onPreviewItemRollOut(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            loc2.filters = [];
            return;
        }

        private function onLoadImageIntoMovieClipError(arg1:flash.events.IOErrorEvent):*
        {
            return false;
        }

        private function filterInventoryHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = 0;
            loc3 = null;
            loc4 = arg1.currentTarget.name;
            switch (loc4) 
            {
                case btnAll.name:
                    loc2 = 0;
                    break;
                case btnClothes.name:
                    loc2 = -4;
                    break;
                case btnFurniture.name:
                    loc2 = 5;
                    break;
                case btnConsumable.name:
                    loc2 = -100;
                    loc3 = {"canConsume":"1"};
                    break;
                default:
                    return;
            }
            if (!(loc2 == _currentFilter) || !(_selectedButton == arg1.currentTarget))
            {
                _selectedButton = arg1.currentTarget;
                _currentFilter = loc2;
                _displayedInventory = _currentFilter ? filterById(_currentFilter, loc3) : MyLifeUtils.cloneObject(_playerInventory);
                loadItemsIntoContainer();
                if (containerScrollPane)
                {
                    containerScrollPane.refreshPane();
                }
            }
            return;
        }

        private function filterById(arg1:int, arg2:*=null):Array
        {
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

            loc6 = undefined;
            loc7 = undefined;
            loc8 = false;
            loc9 = undefined;
            loc3 = [];
            loc4 = true;
            loc5 = previewContainer.numChildren;
            while (loc5) 
            {
                loc5 = (loc5 - 1);
                (loc6 = previewContainer.removeChildAt(loc5)).count = 0;
                loc6.inventoryItem.splice(0);
            }
            if (arg1 != 0)
            {
                if (arg1 < 0)
                {
                    loc4 = false;
                    arg1 = arg1 * -1;
                }
                loc10 = 0;
                loc11 = _playerInventory;
                for each (loc7 in loc11)
                {
                    if (!(loc4 && loc7.parentCategoryId == arg1 || !loc4 && loc7.parentCategoryId <= arg1))
                    {
                        continue;
                    }
                    loc8 = arg2 ? false : true;
                    if (arg2)
                    {
                        loc12 = 0;
                        loc13 = arg2;
                        for (loc9 in loc13)
                        {
                            loc8 = loc7[loc9] && loc7[loc9] == arg2[loc9];
                        }
                    }
                    if (!loc8)
                    {
                        continue;
                    }
                    loc3.push(loc7);
                }
            }
            else 
            {
                loc3 = MyLifeUtils.cloneObject(_playerInventory);
            }
            return loc3;
        }

        private function itemInCurrentCategory(arg1:Object):Boolean
        {
            var loc2:*;

            loc2 = false;
            if (_currentFilter != 0)
            {
                if (_currentFilter > 0)
                {
                    loc2 = arg1.parentCategoryId == _currentFilter;
                }
                else 
                {
                    loc2 = arg1.parentCategoryId <= _currentFilter * -1;
                }
            }
            else 
            {
                loc2 = true;
            }
            if (loc2 && _selectedButton == btnConsumable)
            {
                loc2 = arg1.canConsume == "1";
            }
            return loc2;
        }

        public var txtWhatsNew:flash.text.TextField;

        private var _inventoryInUseList:*;

        public var previewContainer:flash.display.MovieClip;

        private var _displayedInventory:Array;

        private var _destroyed:Boolean=false;

        private var btnAll:MyLife.UI.ToggleButton;

        private var _showEatAnimationOnClose:Boolean=false;

        private var containerScrollPane:fl.containers.ScrollPane;

        public var tabGroupContainer:flash.display.MovieClip;

        private var _playerInventory:Array;

        private var _itemPreviews:Object;

        private var TabButtonSelected:Class;

        public var scrollUpdateText:fl.controls.UIScrollBar;

        private var loadPreviewIntoClipImageList:Array;

        private var btnClothes:MyLife.UI.ToggleButton;

        private var TabButtonNormal:Class;

        private var _maxWorkers:int=16;

        private var _currentFilter:int;

        private var _selectedButton:*;

        private var viewItemDetailsWindow:flash.display.MovieClip;

        public var cancelWindowButton:flash.display.SimpleButton;

        private var btnConsumable:MyLife.UI.ToggleButton;

        private var _myLife:flash.display.MovieClip;

        private var buttonGroup:MyLife.UI.RadioButtonManager;

        private var _curWorkers:int=0;

        private var btnFurniture:MyLife.UI.ToggleButton;

        private var TabButtonOver:Class;

        private var currentPreviewItemClipParent:flash.display.MovieClip;
    }
}
