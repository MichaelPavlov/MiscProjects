package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.Utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import gs.*;
    
    public class AppearanceItemButton extends flash.events.EventDispatcher
    {
        public function AppearanceItemButton(arg1:flash.display.MovieClip, arg2:Object=null, arg3:Number=-1)
        {
            super();
            this.itemButton = arg1;
            setAppearanceObject(arg2, arg3);
            return;
        }

        private function loadPreviewImage():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            loc1 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["item_image_path"] + appearanceObject.itemId + "_60_60.gif?v=" + MyLifeConfiguration.version;
            loc2 = new Loader();
            loc2.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreviewImageLoaded);
            loc2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
            loc2.load(new URLRequest(loc1));
            loc4 = 0;
            loc5 = DisplayObjectContainerUtils.getChildren(itemButton.SelectionItemPlaceholderImage);
            for each (loc3 in loc5)
            {
                itemButton.SelectionItemPlaceholderImage.removeChild(loc3);
            }
            itemButton.LoadingAnimation.gotoAndPlay(1);
            itemButton.LoadingAnimation.visible = true;
            itemButton.SelectionItemPlaceholderImage.visible = false;
            itemButton.SelectionItemPlaceholderImage.addChild(loc2);
            return;
        }

        public function setAppearanceObject(arg1:Object, arg2:Number):void
        {
            var loc3:*;

            this.appearanceObject = arg1;
            this.itemListIndex = arg2;
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onItemLoaded);
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onItemError);
            itemButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
            isPreviewImageLoaded = false;
            isItemLoaded = false;
            loc3 = AssetsManager.STATUS_FILE_LOAD_NOT_ATTEMPTED;
            itemButton.SelectionItemPlaceholderImage.visible = false;
            if (arg1 == null)
            {
                itemButton.visible = false;
            }
            else 
            {
                itemButton.visible = true;
                itemButton.itemName.text = arg1.name;
                itemButton.itemPrice.text = "";
                if (arg1.itemId == 0 || arg1.filename == null || arg1.filename == "")
                {
                    loc3 = AssetsManager.STATUS_FILE_LOADED;
                }
                else 
                {
                    loc3 = AssetsManager.getInstance().getItemLoadStatus(arg1.itemId);
                }
                if (loc3 != AssetsManager.STATUS_FILE_LOADED)
                {
                    if (loc3 != AssetsManager.STATUS_FILE_LOAD_NOT_ATTEMPTED)
                    {
                        if (loc3 != AssetsManager.STATUS_FILE_LOADING)
                        {
                            itemButton.LoadingAnimation.gotoAndPlay(1);
                            itemButton.LoadingAnimation.visible = true;
                        }
                        else 
                        {
                            loadPreviewImage();
                            AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onItemLoaded);
                            AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onItemError);
                        }
                    }
                    else 
                    {
                        loadPreviewImage();
                        AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onItemLoaded);
                        AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onItemError);
                        AssetsManager.getInstance().loadAsset(arg1, "avatar_asset_path");
                    }
                }
                else 
                {
                    isItemLoaded = true;
                    loadPreviewImage();
                    activateButton();
                }
            }
            return;
        }

        public function showButton(arg1:Boolean):*
        {
            itemButton.visible = arg1;
            return;
        }

        private function onPreviewImageLoaded(arg1:flash.events.Event):*
        {
            var loc2:*;

            arg1.target.removeEventListener(Event.COMPLETE, onPreviewImageLoaded);
            arg1.target.removeEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
            isPreviewImageLoaded = true;
            loc2 = arg1.currentTarget.content.parent;
            loc2.x = -loc2.width / 2;
            loc2.y = -loc2.height / 2;
            itemButton.SelectionItemPlaceholderImage.alpha = 0;
            if (isItemLoaded)
            {
                itemButton.LoadingAnimation.visible = false;
                itemButton.SelectionItemPlaceholderImage.visible = true;
                TweenLite.to(itemButton.SelectionItemPlaceholderImage, 0.75, {"alpha":1});
            }
            return;
        }

        private function activateButton():void
        {
            itemButton.addEventListener(MouseEvent.CLICK, onButtonClick);
            return;
        }

        private function onItemError(arg1:MyLife.Events.AssetManagerEvent):*
        {
            if (arg1.asset.itemId != this.appearanceObject.itemId)
            {
                return;
            }
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onItemLoaded);
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onItemError);
            return;
        }

        private function onButtonClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new Event("APPEARANCE_ITEM_BUTTON_CLICK"));
            return;
        }

        public function getAppearanceObject():Object
        {
            return appearanceObject;
        }

        public function getIndex():Number
        {
            return itemListIndex;
        }

        private function onPreviewImageError(arg1:flash.events.Event):*
        {
            arg1.target.removeEventListener(Event.COMPLETE, onPreviewImageLoaded);
            arg1.target.removeEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
            return;
        }

        private function onItemLoaded(arg1:MyLife.Events.AssetManagerEvent):void
        {
            if (arg1.asset.itemId != this.appearanceObject.itemId)
            {
                return;
            }
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onItemLoaded);
            AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onItemError);
            isItemLoaded = true;
            if (isPreviewImageLoaded)
            {
                itemButton.LoadingAnimation.visible = false;
                itemButton.SelectionItemPlaceholderImage.visible = true;
                TweenLite.to(itemButton.SelectionItemPlaceholderImage, 0.75, {"alpha":1});
            }
            activateButton();
            return;
        }

        private var itemListIndex:Number;

        private var isItemLoaded:Boolean;

        private var appearanceObject:Object;

        private var itemButton:flash.display.MovieClip;

        private var isPreviewImageLoaded:Boolean;
    }
}
