package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class MysteryBoxDialog extends flash.display.MovieClip
    {
        public function MysteryBoxDialog()
        {
            var loc1:*;

            BoxAnim = MysteryBoxDialog_BoxAnim;
            super();
            title.visible = false;
            image.visible = false;
            txtItemName.visible = false;
            mcRare.visible = false;
            mcUncommon.visible = false;
            mcCommon.visible = false;
            mcRareTeaser.visible = false;
            image.mouseEnabled = loc1 = false;
            image.mouseChildren = loc1;
            animContainer.mouseEnabled = loc1 = false;
            animContainer.mouseChildren = loc1;
            return;
        }

        private function updateDialog():void
        {
            var loc1:*;

            title.text = "Congratulations!";
            txtItemName.visible = true;
            loc1 = _rarity;
            switch (loc1) 
            {
                case "Common":
                    mcCommon.visible = true;
                    break;
                case "Uncommon":
                    mcUncommon.visible = true;
                    break;
                case "Rare":
                    mcRare.visible = true;
                    break;
            }
            mcRareTeaser.visible = !mcRare.visible;
            btnClose.alpha = 1;
            btnClose.mouseEnabled = true;
            btnBuy.alpha = 1;
            btnBuy.mouseEnabled = true;
            return;
        }

        private function changeImageHandler(arg1:flash.events.Event):void
        {
            image.visible = true;
            TweenLite.to(image, 0.75, {"alpha":1});
            return;
        }

        public function cleanUp():void
        {
            btnClose.removeEventListener(MouseEvent.CLICK, btnCloseHandler);
            btnBuy.removeEventListener(MouseEvent.CLICK, btnBuyHandler);
            _newItem = null;
            _boxItem = null;
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, boxLoadedHandler);
            if (_boxObj)
            {
                if (animContainer.contains(_boxObj))
                {
                    animContainer.removeChild(_boxObj);
                }
                _boxObj.removeEventListener(Event.CHANGE, changeImageHandler);
                _boxObj.removeEventListener(Event.COMPLETE, animCompleteHandler);
                _boxObj = null;
            }
            while (image.numChildren) 
            {
                image.removeChildAt(0);
            }
            return;
        }

        public function initialize(arg1:*=null, arg2:*=null):void
        {
            var loc3:*;

            loc3 = null;
            if (arg2)
            {
                btnClose.alpha = 0.5;
                btnClose.mouseEnabled = false;
                btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
                btnBuy.alpha = 0.5;
                btnBuy.mouseEnabled = false;
                btnBuy.addEventListener(MouseEvent.CLICK, btnBuyHandler);
                _newItem = arg2.newItem;
                _boxItem = arg2["boxItem"];
                if (arg2.hasOwnProperty("playAnim"))
                {
                    _playAnim = arg2.playAnim;
                }
                if (arg2.rarity)
                {
                    _rarity = arg2.rarity;
                }
                txtItemName.text = "You got the " + _newItem.name + "!";
                loc3 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg2.newItem.itemId + "_130_100.gif?v=" + MyLifeConfiguration.version;
                AssetsManager.getInstance().loadImage(loc3, image, imageLoadedCallback);
                AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, boxLoadedHandler);
                AssetsManager.getInstance().loadAsset(_boxItem);
            }
            return;
        }

        private function dialogVisible():void
        {
            title.visible = true;
            if (_playAnim)
            {
                _boxObj.playAnim(_rarity);
            }
            else 
            {
                updateDialog();
            }
            return;
        }

        private function boxLoadedHandler(arg1:MyLife.Events.AssetManagerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, boxLoadedHandler);
            _boxObj = AssetsManager.getInstance().getAssetInstanceByItemId(_boxItem.itemId, 0);
            loc2 = _boxObj.numChildren;
            while (loc2) 
            {
                loc2 = (loc2 - 1);
                loc3 = _boxObj.getChildAt(loc2);
                if (!(!(loc3.name == "itemImage") && !(loc3.name == "scrollerContainer")))
                {
                    continue;
                }
                loc3.visible = false;
            }
            _boxObj.addEventListener(Event.CHANGE, changeImageHandler);
            _boxObj.addEventListener(Event.COMPLETE, animCompleteHandler);
            _boxLoaded = true;
            checkLoadComplete();
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:*):void
        {
            if (arg1)
            {
                arg2.addChild(arg1);
            }
            _imageLoaded = true;
            checkLoadComplete();
            return;
        }

        private function checkLoadComplete():void
        {
            if (_imageLoaded && _boxLoaded)
            {
                image.alpha = _playAnim ? 0 : 1;
                animContainer.addChild(_boxObj);
                _boxObj.visible = _playAnim;
                image.visible = !_playAnim;
                dialogVisible();
            }
            return;
        }

        private function animCompleteHandler(arg1:flash.events.Event):void
        {
            animContainer.removeChild(_boxObj);
            updateDialog();
            return;
        }

        private function btnCloseHandler(arg1:flash.events.MouseEvent):void
        {
            cleanUp();
            dispatchEvent(new Event(Event.CLOSE));
            title.visible = false;
            txtItemName.visible = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":MyLifeInstance.getInstance().getInterface().unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function btnBuyHandler(arg1:flash.events.MouseEvent):void
        {
            ViewStoreInventory.getInstance().doBuyItem(_boxItem.itemId);
            btnCloseHandler(null);
            return;
        }

        private var _imageLoaded:Boolean=false;

        private var _playAnim:Boolean=true;

        public var mcRareTeaser:flash.display.MovieClip;

        public var btnBuy:flash.display.SimpleButton;

        private var _boxObj:*;

        public var txtItemName:flash.text.TextField;

        private var _rarity:String;

        public var mcRare:flash.display.MovieClip;

        public var image:flash.display.MovieClip;

        public var title:flash.text.TextField;

        public var mcCommon:flash.display.MovieClip;

        private var _newItem:Object;

        private var BoxAnim:Class;

        private var _boxLoaded:Boolean=false;

        public var animContainer:flash.display.MovieClip;

        public var mcUncommon:flash.display.MovieClip;

        public var btnClose:flash.display.SimpleButton;

        private var _boxItem:*;
    }
}
