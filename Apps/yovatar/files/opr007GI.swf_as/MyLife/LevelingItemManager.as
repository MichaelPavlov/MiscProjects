package MyLife 
{
    public class LevelingItemManager extends Object
    {
        public function LevelingItemManager()
        {
            super();
            init();
            return;
        }

        private function init():void
        {
            setupEventListeners();
            return;
        }

        private function replaceLevellingItem(arg1:int, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            if (arg1 && arg2)
            {
                InventoryManager.removeItemFromInventory(arg1);
                InventoryManager.addItemToInventory(arg2);
            }
            loc3 = InventoryManager.getAllItemsInUse();
            loc4 = 0;
            loc6 = 0;
            loc7 = loc3;
            for each (loc5 in loc7)
            {
                if (arg1 && loc5.hasOwnProperty("playerItemId"))
                {
                    if (int(loc5["playerItemId"]) == arg1)
                    {
                        loc3[loc4] = arg2;
                        InventoryManager.setItemsInUse(loc3);
                        break;
                    }
                }
                ++loc4;
            }
            return;
        }

        private function setupEventListeners():void
        {
            (MyLifeInstance.getInstance() as MyLife).getServer().addEventListener(MyLifeEvent.LEVELING_ITEM_REPLACE, levelingItemReplaceHandler);
            return;
        }

        private function levelingItemReplaceHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = null;
            if (InventoryManager.ready)
            {
                if (arg1 && arg1.eventData)
                {
                    if (arg1.eventData.hasOwnProperty("playerItemId"))
                    {
                        loc2 = arg1.eventData["playerItemId"];
                    }
                    if (arg1.eventData.hasOwnProperty("item"))
                    {
                        loc3 = arg1.eventData["item"];
                    }
                    replaceLevellingItem(loc2, loc3);
                }
            }
            return;
        }

        public static function get instance():MyLife.LevelingItemManager
        {
            if (!_instance)
            {
                _instance = new LevelingItemManager();
            }
            return _instance;
        }

        private static var _instance:MyLife.LevelingItemManager;
    }
}
