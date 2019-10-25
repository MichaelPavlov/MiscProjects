package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.events.*;
    import gs.*;
    
    public class ConfirmPurchaseWithOpen extends MyLife.Interfaces.ViewInventoryItemDetails
    {
        public function ConfirmPurchaseWithOpen()
        {
            super();
            mcItemInUse.visible = false;
            btnSell.deleteMessage.visible = false;
            btnSell.sellMessage.visible = false;
            btnSell.label.text = "Send as Gift";
            btnSell.label.visible = true;
            btnCancel.label.text = "Save For Later";
            modal.visible = false;
            x = 326;
            y = 303;
            return;
        }

        public function initialize(arg1:*=null, arg2:*=null):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            inventoryItem = arg2.item;
            if (inventoryItem["metaData"])
            {
                loc4 = String(inventoryItem.metaData).split("|");
                loc7 = 0;
                loc8 = loc4;
                for each (loc5 in loc8)
                {
                    if ((loc6 = loc5.split(":"))[0] != "action")
                    {
                        continue;
                    }
                    btnUse.label.text = loc6[1];
                }
            }
            txtItemName.text = inventoryItem.name + " Purchased";
            loc3 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + inventoryItem.itemId + "_130_100.gif";
            AssetsManager.getInstance().loadImage(loc3, picture.image, imageLoadedCallback);
            addListeners();
            return;
        }

        private function btnCancelHandler(arg1:flash.events.MouseEvent):void
        {
            removeListeners();
            inventoryItem = null;
            btnUse.label.visible = false;
            btnSell.label.visible = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":unloadInterface});
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

        private function unloadInterface():void
        {
            MyLifeInstance.getInstance().getInterface().unloadInterface(this);
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }

        private function removeListeners():void
        {
            btnUse.removeEventListener(MouseEvent.CLICK, btnUseHandler);
            btnSell.removeEventListener(MouseEvent.CLICK, btnSellHandler);
            btnCancel.removeEventListener(MouseEvent.CLICK, btnCancelHandler);
            return;
        }

        private function btnSellHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = {};
            loc2.giftData = {};
            loc2.giftData.senderName = MyLifeInstance.getInstance().getPlayer()._character._characterName;
            loc2.giftData.playerItemId = inventoryItem.playerItemId;
            loc2.giftData.itemId = inventoryItem.itemId;
            MyLifeInstance.getInstance().getInterface().showInterface("GiftListViewer", loc2);
            btnCancelHandler(null);
            return;
        }

        private function addListeners():void
        {
            btnUse.addEventListener(MouseEvent.CLICK, btnUseHandler);
            btnSell.addEventListener(MouseEvent.CLICK, btnSellHandler);
            btnCancel.addEventListener(MouseEvent.CLICK, btnCancelHandler);
            return;
        }

        private function btnUseHandler(arg1:flash.events.MouseEvent):void
        {
            MyLifeInstance.getInstance().getServer().callExtension("useItem", {"inventoryId":inventoryItem.playerItemId});
            if (inventoryItem["metaData"] && !(String(inventoryItem.metaData).indexOf("Consummable") == -1))
            {
                dispatchEvent(new MyLifeEvent(MyLifeEvent.USE_FOOD_ITEM));
            }
            btnCancelHandler(null);
            return;
        }
    }
}
