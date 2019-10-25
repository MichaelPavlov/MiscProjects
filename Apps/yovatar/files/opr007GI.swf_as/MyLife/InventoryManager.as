package MyLife 
{
    import MyLife.Events.*;
    import flash.events.*;
    
    public class InventoryManager extends flash.events.EventDispatcher
    {
        public function InventoryManager()
        {
            super();
            MyLifeInstance.getInstance().getServer().addEventListener(ServerEvent.PLAYER_ACTIVATED, activationHandler);
            return;
        }

        public function getInventoryNotInUse(arg1:Number=0, arg2:Number=0):Array
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

            loc6 = false;
            loc7 = 0;
            loc8 = null;
            loc9 = null;
            loc3 = MyLifeUtils.cloneObject(getPlayerInventory());
            loc4 = [];
            loc5 = getAllItemsInUse();
            loc10 = 0;
            loc11 = loc3;
            for each (loc9 in loc11)
            {
                loc6 = false;
                loc7 = loc9.playerItemId;
                loc12 = 0;
                loc13 = loc5;
                for each (loc8 in loc13)
                {
                    if (!(loc7 == loc8.playerItemId || arg1 && !(arg1 == loc8.categoryId) || arg2 && !(arg2 == loc8.itemId)))
                    {
                        continue;
                    }
                    loc5.splice(loc5.indexOf(loc8), 1);
                    loc6 = true;
                    break;
                }
                if (loc6)
                {
                    continue;
                }
                loc4.push(loc9);
            }
            return loc4;
        }

        public static function getPlayerInventory(arg1:int=0, arg2:Boolean=false, arg3:int=0):Array
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc7 = null;
            if (!ready)
            {
                return null;
            }
            if (arg1 == 0 && arg2 == false)
            {
                return getPlayerInventoryWithExclusions(INVENTORY_ANIMATIONS);
            }
            loc4 = [];
            loc6 = 0;
            loc8 = 0;
            loc9 = _currentInventory;
            for each (loc7 in loc9)
            {
                if (!(parseInt(loc7.parentCategoryId) == arg1 || parseInt(loc7.parentCategoryId) == arg3))
                {
                    continue;
                }
                if (arg2)
                {
                    (loc5 = {}).category = loc7.category;
                    loc5.item_category_id = loc7.categoryId;
                    loc5.meta_data = loc7.metaData;
                    loc5.item_id = loc7.itemId;
                    loc5.player_item_id = loc7.playerItemId;
                    loc5.name = loc7.name;
                    loc5.player = loc7.playerId;
                    loc5.gender = loc7.g;
                    loc5.filename = loc7.filename;
                }
                else 
                {
                    loc5 = loc7;
                }
                loc4.push(loc5);
            }
            return loc4;
        }

        private static function inventoryLoadedHandler(arg1:MyLife.Events.ServerEvent):void
        {
            _loading = false;
            setItemsInUse(arg1.eventData["itemsInUse"]);
            importInventory(arg1.eventData["inventory"]);
            return;
        }

        public static function getAllItemsInUse():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc1 = _itemsInUseList.slice();
            if (_currentClothing)
            {
                loc5 = 0;
                loc6 = _currentClothing;
                for each (loc2 in loc6)
                {
                    loc3 = {};
                    loc3.itemId = loc2.id;
                    loc3.playerItemId = loc2.playerItemid || 0;
                    if (!loc3.playerItemId)
                    {
                        loc7 = 0;
                        loc8 = _currentInventory;
                        for each (loc4 in loc8)
                        {
                            if (loc3.itemId != loc4.itemId)
                            {
                                continue;
                            }
                            loc3.playerItemId = loc4.playerItemId;
                            loc2.playerItemId = loc4.playerItemId;
                            if (loc2.itemData)
                            {
                                loc2.itemData.isUsingTempPlayerItemId = true;
                            }
                            else 
                            {
                                trace("2 no item data");
                            }
                            break;
                        }
                    }
                    loc1.push(loc3);
                }
            }
            return loc1;
        }

        private static function activationHandler(arg1:MyLife.Events.ServerEvent):void
        {
            if (!_ready && arg1.eventData.hasOwnProperty("inventoy"))
            {
                importInventory(arg1.eventData.inventoy);
            }
            return;
        }

        public static function getInventoryItem(arg1:*):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            if (!ready)
            {
                return null;
            }
            loc3 = 0;
            loc4 = _currentInventory;
            for each (loc2 in loc4)
            {
                if (String(loc2.playerItemId) == String(arg1))
                {
                    break;
                }
                loc2 = null;
            }
            return loc2;
        }

        public static function removeItemFromInventory(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            loc2 = null;
            if (ready)
            {
                loc4 = 0;
                loc5 = _currentInventory;
                for each (loc3 in loc5)
                {
                    if (loc3.playerItemId != arg1)
                    {
                        continue;
                    }
                    loc2 = loc3;
                    break;
                }
                if (loc2)
                {
                    _currentInventory.splice(_currentInventory.indexOf(loc2), 1);
                    _instance.dispatchEvent(new InventoryEvent(InventoryEvent.REMOVE_ITEM, loc2));
                }
            }
            else 
            {
                if (_loading)
                {
                    _pendingChanges.push({"action":"REMOVE", "item":arg1});
                }
            }
            return;
        }

        public static function setItemsInUse(arg1:*):void
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

            loc4 = null;
            loc6 = null;
            loc7 = undefined;
            loc8 = null;
            loc2 = [];
            loc3 = [];
            loc5 = {};
            loc9 = 0;
            loc10 = arg1;
            for each (loc6 in loc10)
            {
                if (loc6.hasOwnProperty("playerItemId"))
                {
                    loc4 = String(loc6.playerItemId);
                    if (loc5[loc4] || loc6.playerItemId == 0)
                    {
                        loc6.playerItemId = 0;
                        loc3.push(loc6);
                    }
                    else 
                    {
                        loc5[loc4] = true;
                        loc6.isEquipped = true;
                        loc2.push(loc6);
                    }
                    continue;
                }
                if (loc6.hasOwnProperty("itemId"))
                {
                    loc3.push({"itemId":loc6.itemId, "playerItemId":0});
                    continue;
                }
                loc3.push({"itemId":loc6, "playerItemId":0});
            }
            if (ready)
            {
                loc9 = 0;
                loc10 = loc3;
                for each (loc6 in loc10)
                {
                    loc7 = loc6.itemId;
                    loc11 = 0;
                    loc12 = _currentInventory;
                    for each (loc8 in loc12)
                    {
                        if (loc7 != loc8.itemId)
                        {
                            continue;
                        }
                        loc4 = String(loc8.playerItemId);
                        if (!(!loc5[loc4] && !(loc4 == "0")))
                        {
                            continue;
                        }
                        loc5[loc4] = true;
                        loc6.playerItemId = loc8.playerItemId;
                        if (loc6.itemData)
                        {
                            loc6.itemData.isUsingTempPlayerItemId = true;
                        }
                        else 
                        {
                            trace("no item data");
                        }
                        loc2.push(loc6);
                        break;
                    }
                }
            }
            else 
            {
                _pendingChanges.push({"action":"IN_USE", "items":arg1});
            }
            _itemsInUseList = loc2;
            return;
        }

        public static function getInstance():MyLife.InventoryManager
        {
            if (!_instance)
            {
                _instance = new InventoryManager();
            }
            return _instance;
        }

        public static function get ready():Boolean
        {
            return _ready;
        }

        public static function addItemToInventory(arg1:Object):void
        {
            if (ready)
            {
                _currentInventory.push(arg1);
                _instance.dispatchEvent(new InventoryEvent(InventoryEvent.ADD_ITEM, arg1));
            }
            else 
            {
                if (_loading)
                {
                    _pendingChanges.push({"action":"ADD", "item":arg1});
                }
            }
            return;
        }

        public static function loadInventory():void
        {
            if (!ready)
            {
                _loading = true;
                MyLifeInstance.getInstance().getServer().addEventListener(ServerEvent.LOAD_INVENTORY_COMPLETE, inventoryLoadedHandler);
                MyLifeInstance.getInstance().getServer().callExtension("InventoryManager.getInventory");
            }
            return;
        }

        public static function getTradableInventory():Array
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

            loc4 = false;
            loc5 = 0;
            loc6 = null;
            loc7 = null;
            if (!ready)
            {
                return null;
            }
            loc1 = _currentInventory.slice();
            loc2 = [];
            loc3 = getAllItemsInUse();
            loc8 = 0;
            loc9 = loc1;
            for each (loc7 in loc9)
            {
                loc4 = false;
                if (!loc7.isHidden && loc7.playerId > 1 && !(loc7.parentCategoryId == INVENTORY_GIFTWRAP) && !(loc7.parentCategoryId == INVENTORY_HOMES) && !(Number(loc7.startItem) == StartItemType.REMOVE_ONLY) && !(Number(loc7.startItem) == StartItemType.LOCKED))
                {
                    loc5 = loc7.playerItemId;
                    loc10 = 0;
                    loc11 = loc3;
                    for each (loc6 in loc11)
                    {
                        if (loc5 != loc6.playerItemId)
                        {
                            continue;
                        }
                        loc3.splice(loc3.indexOf(loc6), 1);
                        loc4 = true;
                        break;
                    }
                }
                else 
                {
                    loc4 = true;
                }
                if (loc4)
                {
                    continue;
                }
                loc2.push(loc7);
            }
            return loc2;
        }

        private static function importInventory(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc3 = null;
            _currentInventory = [];
            loc4 = 0;
            loc5 = arg1;
            for each (loc2 in loc5)
            {
                if (loc2["must_consume"] == "1")
                {
                    continue;
                }
                _currentInventory.push(loc2);
            }
            _ready = true;
            label265: while (_pendingChanges.length) 
            {
                loc3 = _pendingChanges.shift();
                loc4 = loc3.action;
                switch (loc4) 
                {
                    case "ADD":
                        addItemToInventory(loc3.item);
                        continue label265;
                    case "REMOVE":
                        removeItemFromInventory(loc3.item);
                        continue label265;
                    case "CLOTHES":
                        setClothingInUse(loc3.clothing);
                        continue label265;
                    case "IN_USE":
                        setItemsInUse(loc3.items);
                        continue label265;
                }
            }
            _instance.dispatchEvent(new InventoryEvent(InventoryEvent.READY));
            return;
        }

        public static function setClothingInUse(arg1:Object):void
        {
            if (ready)
            {
                _currentClothing = arg1;
            }
            else 
            {
                _pendingChanges.push({"action":"CLOTHES", "clothing":arg1});
            }
            return;
        }

        public static function setInventoryItemProperty(arg1:*, arg2:String, arg3:*):Object
        {
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = _currentInventory.length;
            while (loc5--) 
            {
                if (_currentInventory[loc5]["playerItemId"] != arg1)
                {
                    continue;
                }
                _currentInventory[loc5][arg2] = arg3;
                loc4 = _currentInventory[loc5];
                break;
            }
            return loc4;
        }

        private static function getPlayerInventoryWithExclusions(... rest):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = null;
            if (!ready)
            {
                return null;
            }
            loc2 = _currentInventory.concat();
            if (rest != null)
            {
                loc6 = 0;
                loc7 = rest;
                for each (loc3 in loc7)
                {
                    loc4 = 0;
                    loc8 = 0;
                    loc9 = _currentInventory;
                    for each (loc5 in loc9)
                    {
                        if (loc5.parentCategoryId == loc3)
                        {
                            loc2.splice(loc4, 1);
                            continue;
                        }
                        ++loc4;
                    }
                }
            }
            return loc2;
        }

        
        {
            _ready = false;
            _loading = false;
            _currentInventory = null;
            _itemsInUseList = [];
            _pendingChanges = [];
            _currentClothing = null;
        }

        public static const INVENTORY_FOOD:Number=6;

        public static const INVENTORY_APPEARANCE:Number=1;

        public static const INVENTORY_ACCESSORIES:Number=2;

        public static const INVENTORY_FURNITURE:Number=5;

        public static const INVENTORY_HOMES:Number=7;

        public static const INVENTORY_ANIMATIONS:Number=2050;

        public static const INVENTORY_GIFTWRAP:Number=2037;

        public static const INVENTORY_CLOTHING:Number=3;

        public static const INVENTORY_ACTIVATEABLE:Number=8;

        public static const INVENTORY_COSTUMES:Number=4;

        private static var _pendingChanges:Array;

        private static var _itemsInUseList:Array;

        private static var _currentInventory:Array=null;

        private static var _currentClothing:Object=null;

        private static var _ready:Boolean=false;

        private static var _instance:MyLife.InventoryManager;

        private static var _loading:Boolean=false;
    }
}
