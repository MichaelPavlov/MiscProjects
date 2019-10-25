package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import gs.*;
    
    public class RoomItemSelector extends flash.display.MovieClip
    {
        public function RoomItemSelector()
        {
            _inventoryCollection = [];
            _itemsToLoad = [];
            super();
            scrollLeft.addEventListener(MouseEvent.CLICK, scrollLeftClick);
            scrollRight.addEventListener(MouseEvent.CLICK, scrollRightClick);
            btnSetFloorAndWall.addEventListener(MouseEvent.CLICK, btnSetFloorAndWallClick);
            ItemBar.childWidth = 140;
            SetFloorAndWallMenu.visible = false;
            AllInventoryItemsInUse.visible = false;
            return;
        }

        private function newDragItemMouseDown(arg1:flash.events.MouseEvent):void
        {
            arg1.currentTarget.activated = true;
            arg1.currentTarget.startDragPoint = new Point(this.mouseX, this.mouseY);
            arg1.currentTarget.addEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP);
            arg1.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove);
            return;
        }

        private function getPatternImageByItemId(arg1:Number):String
        {
            var loc2:*;

            loc2 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1 + "_110_80.gif";
            return loc2;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String):void
        {
            var loc3:*;

            loc3 = new Loader();
            loc3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageIntoMovieClipError);
            loc3.load(new URLRequest(arg2));
            arg1.addChild(loc3);
            return;
        }

        private function shiftBarItems(arg1:Boolean=true, arg2:*=0):*
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
            loc6 = undefined;
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
                loc6 = loc5.childIndex * ItemBar.childWidth;
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

        public function initialize(arg1:flash.display.MovieClip):void
        {
            _myLife = arg1;
            return;
        }

        private function furnitureFilesLoaded():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            _furnitureList = null;
            loc1 = 0;
            loc5 = 0;
            loc6 = _itemsToLoad;
            for each (loc2 in loc6)
            {
                addNewItemToItemBar(loc2.playerItemId, loc1, false);
                ++loc1;
            }
            _itemsToLoad.splice(0);
            loc3 = 4 - ItemBar.numChildren;
            loc4 = -1;
            while (loc3 > 0) 
            {
                loc3 = (loc3 - 1);
                addNewItemToItemBar(loc4, loc1, false);
                loc4 = (loc4 - 1);
            }
            return;
        }

        private function enableButton(arg1:*, arg2:Boolean):void
        {
            arg1.mouseEnabled = arg2;
            arg1.alpha = arg2 ? 1 : 0.2;
            return;
        }

        public function loadInventory():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc3 = null;
            loc1 = getMovieChildren(ItemBar);
            loc4 = 0;
            loc5 = loc1;
            for each (loc2 in loc5)
            {
                ItemBar.removeChild(loc2);
            }
            _scrollOffset = 0;
            loc3 = _myLife.zone.getZoneMovieObject();
            initFloorAndWallSelector(loc3.currentWallPattern, loc3.currentFloorPattern);
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

        private function preloadFloorAndWallComplete():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = undefined;
            _preloadItemsLeftToLoad--;
            if (_preloadItemsLeftToLoad <= 0)
            {
                loc1 = _myLife.zone.getZoneMovieObject();
                loc1.setFloor(SetFloorAndWallMenu.FloorPattern.selectedPatternItemId);
                loc1.setWall(SetFloorAndWallMenu.WallPattern.selectedPatternItemId);
                TweenLite.to(SetFloorAndWallMenu, 0.3, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[SetFloorAndWallMenu]});
            }
            return;
        }

        private function addItemToPanelPatternBar(arg1:*, arg2:Number):MyLife.Interfaces.PatternPreview
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = new PatternPreview();
            loc4 = arg1.patternBar;
            loc3.buttonMode = true;
            loc3.PatternPreviewSelected.visible = false;
            loc3.x = arg1.previewCount * 120;
            loc3.itemId = arg2;
            loc3.addEventListener(MouseEvent.CLICK, patternPreviewClick);
            loc4.addChild(loc3);
            loc5 = getPatternImageByItemId(arg2);
            loadImageIntoMovieClip(loc3.Image, loc5);
            if (arg1.previewCount == 0)
            {
                selectPanelPatternItem(arg1, loc3);
                arg1.originalPatternItemId = arg1.selectedPatternItemId;
            }
            loc7 = ((loc6 = arg1).previewCount + 1);
            loc6.previewCount = loc7;
            return loc3;
        }

        private function loadPlayerItems():void
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

            loc1 = null;
            loc6 = null;
            loc7 = false;
            loc8 = false;
            loc9 = null;
            loc2 = [];
            loc3 = [];
            loc4 = MyLifeUtils.cloneObject(InventoryManager.getPlayerInventory(InventoryManager.INVENTORY_FURNITURE, false, InventoryManager.INVENTORY_FOOD));
            loc5 = MyLifeUtils.cloneObject(InventoryManager.getAllItemsInUse()) as Array;
            loc10 = 0;
            loc11 = loc4;
            for each (loc1 in loc11)
            {
                loc1.inUse = false;
                loc12 = 0;
                loc13 = loc5;
                for each (loc6 in loc13)
                {
                    if (loc1.playerItemId != loc6.playerItemId)
                    {
                        continue;
                    }
                    loc1.inUse = true;
                    break;
                }
            }
            loc10 = 0;
            loc11 = loc4;
            for each (loc1 in loc11)
            {
                _inventoryCollection[loc1.playerItemId] = loc1;
                if (loc1.inUse)
                {
                    continue;
                }
                if (!(loc1.category == "Walls") && !(loc1.category == "Floors"))
                {
                    if (!(Number(loc1.parentCategoryId) == InventoryManager.INVENTORY_FOOD) || loc1.can_consume == "1")
                    {
                        _itemsToLoad.push(loc1);
                    }
                    continue;
                }
                if (loc3[loc1.itemId])
                {
                    continue;
                }
                loc1.sortOrder = loc1.itemId;
                if (loc1.itemId == _currentWallId || loc1.itemId == _currentFloorId)
                {
                    loc1.sortOrder = 0;
                }
                loc2.push(loc1);
                loc3[loc1.itemId] = true;
            }
            _furnitureList = new AssetListLoader();
            _furnitureList.loadAssets(_itemsToLoad, furnitureFilesLoaded);
            loc3.splice(0);
            loc2.sortOn("sortOrder", Array.NUMERIC);
            loc7 = true;
            loc8 = true;
            loc10 = 0;
            loc11 = loc2;
            for each (loc9 in loc11)
            {
                if (loc9.category == "Walls")
                {
                    loc7 = false;
                    addItemToPanelPatternBar(SetFloorAndWallMenu.WallPattern, loc9.itemId);
                    continue;
                }
                if (loc9.category != "Floors")
                {
                    continue;
                }
                loc8 = false;
                addItemToPanelPatternBar(SetFloorAndWallMenu.FloorPattern, loc9.itemId);
            }
            if (loc7)
            {
                addItemToPanelPatternBar(SetFloorAndWallMenu.WallPattern, -1);
            }
            if (loc8)
            {
                addItemToPanelPatternBar(SetFloorAndWallMenu.FloorPattern, -1);
            }
            scrollPanelPatternBar(SetFloorAndWallMenu.WallPattern, 0);
            scrollPanelPatternBar(SetFloorAndWallMenu.FloorPattern, 0);
            return;
        }

        private function removeClipFromParentDisplay(arg1:flash.display.DisplayObject):flash.display.DisplayObject
        {
            if (arg1.parent)
            {
                arg1.parent.removeChild(arg1);
            }
            return arg1;
        }

        private function panelScrollRightClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            loc2 = loc2.parent;
            scrollPanelPatternBar(loc2, -3);
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            loadPlayerItems();
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

        private function onPreloadImageComplete(arg1:flash.events.Event):void
        {
            preloadFloorAndWallComplete();
            return;
        }

        private function newDragItemMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = NaN;
            loc3 = null;
            if (arg1.buttonDown && arg1.currentTarget.activated)
            {
                loc2 = Math.abs(this.mouseX - arg1.currentTarget.startDragPoint.x) + Math.abs(this.mouseY - arg1.currentTarget.startDragPoint.y);
                if (loc2 > 5)
                {
                    arg1.currentTarget.activated = false;
                    arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP);
                    arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove);
                    loc3 = arg1.currentTarget;
                    dispatchEvent(new MyLifeEvent(MyLifeEvent.START_NEW_ITEM_DRAG, {"itemId":loc3.itemId, "childIndex":loc3.childIndex, "playerItemId":loc3.playerItemId}));
                    removeItemFromBar(arg1.currentTarget.childIndex);
                }
            }
            return;
        }

        public function btnSetFloorAndWallClick(arg1:flash.events.MouseEvent=null):void
        {
            SetFloorAndWallMenu.visible = true;
            SetFloorAndWallMenu.alpha = 0;
            TweenLite.to(SetFloorAndWallMenu, 0.5, {"alpha":1});
            return;
        }

        private function SetFloorAndWallMenuSaveClick(arg1:flash.events.MouseEvent=null):*
        {
            SetFloorAndWallMenu.disableMask.visible = true;
            SetFloorAndWallMenu.pleaseWait.visible = true;
            SetFloorAndWallMenu.btnSaveChanges.visible = false;
            SetFloorAndWallMenu.btnCancel.visible = false;
            _preloadItemsLeftToLoad = 2;
            preloadImage(getPatternImageByItemId(SetFloorAndWallMenu.WallPattern.selectedPatternItemId));
            preloadImage(getPatternImageByItemId(SetFloorAndWallMenu.FloorPattern.selectedPatternItemId));
            return;
        }

        private function onPreloadImageError(arg1:flash.events.IOErrorEvent):void
        {
            preloadFloorAndWallComplete();
            return;
        }

        public function addNewItemToItemBar(arg1:*, arg2:*=0, arg3:Boolean=true, arg4:*=0):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            if (!arg2)
            {
                arg2 = 0;
            }
            if (arg2 == 0)
            {
                arg2 = _scrollOffset;
            }
            if (arg1 > 0 && !_inventoryCollection[arg1])
            {
                return;
            }
            loc9 = 0;
            loc10 = getMovieChildren(ItemBar);
            for each (loc5 in loc10)
            {
                if (loc5.playerItemId != arg1)
                {
                    continue;
                }
                trace("Item already exists in inventory.");
                return;
            }
            shiftBarItems(arg3, arg2);
            loc6 = new RoomItemSelectorBarItem();
            (loc7 = this._inventoryCollection[arg1] || {"itemId":0, "name":""}).inItemBar = true;
            arg4 = loc7.itemId;
            loc6.x = arg2 * ItemBar.childWidth;
            loc6.itemId = arg4;
            loc6.childIndex = arg2;
            loc6.active = true;
            loc6.playerItemId = arg1;
            if (arg4 > 0)
            {
                loc8 = AssetsManager.getInstance().getAssetInstanceByItemId(arg4, -1);
                loc6.previewBox.addChild(loc8);
                loc6.txtName.text = loc7.name;
                loc6.buttonMode = true;
                loc6.activated = false;
                loc6.addEventListener(MouseEvent.MOUSE_DOWN, newDragItemMouseDown);
            }
            else 
            {
                loc6.buttonMode = false;
                loc6.txtName.text = "";
                loc6.bg.alpha = 0.5;
            }
            ItemBar.addChild(loc6);
            if (arg3)
            {
                loc6.alpha = 0;
                TweenLite.to(loc6, 1, {"alpha":1});
            }
            updateScrollBars();
            return;
        }

        private function selectPanelPatternItem(arg1:*, arg2:*):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = undefined;
            loc5 = undefined;
            if (arg2.PatternPreviewSelected.visible)
            {
                return;
            }
            loc6 = 0;
            loc7 = getMovieChildren(arg1.patternBar);
            for each (loc3 in loc7)
            {
                loc3.PatternPreviewSelected.visible = false;
            }
            arg2.PatternPreviewSelected.visible = true;
            loc4 = getPatternImageByItemId(arg2.itemId);
            loc6 = 0;
            loc7 = getMovieChildren(arg1.currentPattern.Image);
            for each (loc5 in loc7)
            {
                arg1.currentPattern.Image.removeChild(loc5);
            }
            loadImageIntoMovieClip(arg1.currentPattern.Image, loc4);
            arg1.selectedPatternItemId = arg2.itemId;
            return;
        }

        public function cleanUp():void
        {
            if (_furnitureList)
            {
                _furnitureList.cancel();
                _furnitureList = null;
            }
            _itemsToLoad.splice(0);
            scrollLeft.removeEventListener(MouseEvent.CLICK, scrollLeftClick);
            scrollRight.removeEventListener(MouseEvent.CLICK, scrollRightClick);
            btnSetFloorAndWall.removeEventListener(MouseEvent.CLICK, btnSetFloorAndWallClick);
            SetFloorAndWallMenu.btnSaveChanges.removeEventListener(MouseEvent.CLICK, SetFloorAndWallMenuSaveClick);
            SetFloorAndWallMenu.btnCancel.removeEventListener(MouseEvent.CLICK, SetFloorAndWallMenuCancelClick);
            SetFloorAndWallMenu.WallPattern.scrollLeft.removeEventListener(MouseEvent.CLICK, panelScrollLeftClick);
            SetFloorAndWallMenu.WallPattern.scrollRight.removeEventListener(MouseEvent.CLICK, panelScrollRightClick);
            SetFloorAndWallMenu.FloorPattern.scrollLeft.removeEventListener(MouseEvent.CLICK, panelScrollLeftClick);
            SetFloorAndWallMenu.FloorPattern.scrollRight.removeEventListener(MouseEvent.CLICK, panelScrollRightClick);
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            return;
        }

        private function preloadImage(arg1:String):void
        {
            var loc2:*;

            loc2 = new Loader();
            loc2.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreloadImageComplete);
            loc2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreloadImageError);
            loc2.load(new URLRequest(arg1));
            return;
        }

        private function initFloorAndWallSelector(arg1:*=-1, arg2:*=-1):void
        {
            _currentWallId = arg1;
            _currentFloorId = arg2;
            setupFloorAndWallSelectorPanel(SetFloorAndWallMenu.WallPattern, "Wall Pattern");
            setupFloorAndWallSelectorPanel(SetFloorAndWallMenu.FloorPattern, "Floor Pattern");
            SetFloorAndWallMenu.disableMask.visible = false;
            SetFloorAndWallMenu.btnSaveChanges.visible = true;
            SetFloorAndWallMenu.btnCancel.visible = true;
            SetFloorAndWallMenu.pleaseWait.visible = false;
            SetFloorAndWallMenu.btnSaveChanges.addEventListener(MouseEvent.CLICK, SetFloorAndWallMenuSaveClick);
            SetFloorAndWallMenu.btnCancel.addEventListener(MouseEvent.CLICK, SetFloorAndWallMenuCancelClick);
            return;
        }

        public function updateScrollBars():void
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
                    ++loc4;
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
                AllInventoryItemsInUse.visible = false;
            }
            else 
            {
                AllInventoryItemsInUse.visible = true;
            }
            return;
        }

        private function panelScrollLeftClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            loc2 = loc2.parent;
            scrollPanelPatternBar(loc2, 3);
            return;
        }

        public function SetFloorAndWallMenuCancelClick(arg1:flash.events.MouseEvent=null):*
        {
            TweenLite.to(SetFloorAndWallMenu, 0.3, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[SetFloorAndWallMenu]});
            return;
        }

        private function removeItemFromBar(arg1:*, arg2:Boolean=true):*
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
            loc6 = undefined;
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
                loc6 = loc5.childIndex * ItemBar.childWidth;
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

        private function onLoadImageIntoMovieClipError(arg1:flash.events.IOErrorEvent):void
        {
            return;
        }

        private function setupFloorAndWallSelectorPanel(arg1:*, arg2:*):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            arg1.txtType.text = arg2;
            arg1.previewCount = 0;
            arg1.selectedPatternItemId = -1;
            if (arg1.patternBar.originX)
            {
                arg1.patternBar.x = arg1.patternBar.originX;
            }
            else 
            {
                arg1.patternBar.originX = arg1.patternBar.x;
            }
            loc4 = 0;
            loc5 = getMovieChildren(arg1.patternBar);
            for each (loc3 in loc5)
            {
                removeClipFromParentDisplay(loc3);
            }
            arg1.scrollLeft.addEventListener(MouseEvent.CLICK, panelScrollLeftClick);
            arg1.scrollRight.addEventListener(MouseEvent.CLICK, panelScrollRightClick);
            arg1.currentPattern.PatternPreviewSelected.visible = false;
            return;
        }

        private function newDragItemMouseUP(arg1:flash.events.MouseEvent):void
        {
            arg1.currentTarget.activated = false;
            arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, newDragItemMouseUP);
            arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, newDragItemMouseMove);
            return;
        }

        private function patternPreviewClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget as DisplayObject;
            loc3 = loc2.parent.parent;
            selectPanelPatternItem(loc3, loc2);
            return;
        }

        private function scrollRightClick(arg1:flash.events.MouseEvent):void
        {
            _scrollOffset = _scrollOffset + ITEMS_PER_SCROLL;
            updateScrollBars();
            return;
        }

        private function scrollPanelPatternBar(arg1:*, arg2:*):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = arg1.patternBar;
            if ((loc5 = (loc4 = Math.round((loc3.x - loc3.originX) / 120)) + arg2) > 0)
            {
                loc5 = 0;
            }
            loc6 = loc3.originX + 120 * loc5;
            TweenLite.to(loc3, 0.5, {"x":loc6});
            if (loc5 >= 0)
            {
                arg1.scrollLeft.mouseEnabled = false;
                arg1.scrollLeft.alpha = 0.3;
            }
            else 
            {
                arg1.scrollLeft.mouseEnabled = true;
                arg1.scrollLeft.alpha = 1;
            }
            if (loc6 + loc3.width - loc3.originX < 360)
            {
                arg1.scrollRight.mouseEnabled = false;
                arg1.scrollRight.alpha = 0.3;
            }
            else 
            {
                arg1.scrollRight.mouseEnabled = true;
                arg1.scrollRight.alpha = 1;
            }
            return;
        }

        private function scrollLeftClick(arg1:flash.events.MouseEvent):void
        {
            _scrollOffset = _scrollOffset - ITEMS_PER_SCROLL;
            updateScrollBars();
            return;
        }

        private function hideMovieClip(arg1:*):*
        {
            arg1.visible = false;
            return;
        }

        private const ITEMS_PER_SCROLL:Number=4;

        private const ITEMS_PER_PAGE:Number=4;

        public var btnSaveChanges:flash.display.SimpleButton;

        public var btnSetFloorAndWall:flash.display.SimpleButton;

        private var _preloadItemsLeftToLoad:int=0;

        private var _scrollOffset:int=0;

        private var _itemsToLoad:Array;

        private var _currentFloorId:Number=-1;

        private var _furnitureList:MyLife.AssetListLoader;

        public var scrollRight:flash.display.SimpleButton;

        private var _inventoryCollection:Array;

        private var _currentWallId:Number=-1;

        public var ItemBar:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        public var btnCancelChanges:flash.display.SimpleButton;

        public var scrollLeft:flash.display.SimpleButton;

        public var SetFloorAndWallMenu:flash.display.MovieClip;

        public var AllInventoryItemsInUse:flash.display.MovieClip;
    }
}
