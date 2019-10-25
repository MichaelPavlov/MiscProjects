package MyLife 
{
    import MyLife.Assets.*;
    import MyLife.Clothes.*;
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class AssetsManager extends flash.events.EventDispatcher
    {
        public function AssetsManager()
        {
            _assets = {};
            _promoAds = {};
            _idToFileNameMap = {};
            super();
            return;
        }

        private function get config():MyLife.MyLifeConfiguration
        {
            return MyLifeConfiguration.getInstance();
        }

        private function assetLoadingComplete(arg1:flash.events.Event):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.LOADING_DONE, arg1.currentTarget.content));
            LoadingStatus.getInstance().setProgress(100, (100));
            return;
        }

        private function actionLoadingError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, actionLoadingComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, actionLoadingError);
            loc3 = null;
            if (loc2.context)
            {
                loc4 = null;
                loc3 = loc2.context["context"];
                loc4 = loc2.context["callback"];
                loc2.context["context"] = null;
                loc2.context["callback"] = null;
                loc2.context = null;
                if (loc4 != null)
                {
                    loc4.call(null, null, loc3);
                }
            }
            loc3 = loc3 ? loc3 : loc2.context;
            dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ACTIONLOAD_ERROR, null, loc3));
            loc2.cleanUp();
            return;
        }

        private function itemAssetIOError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc3 = loc2.context;
            loc3.status = STATUS_FILE_FAILED;
            loc2.cleanUp();
            loc2.removeEventListener(Event.COMPLETE, itemAssetLoadingComplete);
            loc2.removeEventListener(ProgressEvent.PROGRESS, itemAssetLoadingStatus);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, itemAssetIOError);
            if (loc3 && loc3.hasOwnProperty("loader"))
            {
                loc3.loader = null;
                delete loc3.loader;
            }
            loc5 = 0;
            loc6 = loc3.itemIds;
            for each (loc4 in loc6)
            {
                trace("itemAssetIOError " + loc4 + " " + loc3.filename);
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSETLOAD_ERROR, this.getItemAsset(loc3, loc4)));
            }
            return;
        }

        public function newAvatarInstance():*
        {
            var loc1:*;
            var loc2:*;

            loc1 = "MyLife.Assets.Avatar.Avatar";
            loc2 = getDefinitionByName(loc1) as Class;
            return new loc2();
        }

        private function itemAssetLoadingStatus(arg1:flash.events.ProgressEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.currentTarget as AssetLoader;
            loc3 = loc2.context;
            loc4 = arg1.bytesLoaded + "/" + arg1.bytesTotal;
            return;
        }

        public function getAssetInstanceByItemId(arg1:*, arg2:*, arg3:*=null, arg4:Boolean=false):*
        {
            var AssetClass:Class;
            var asset:Object;
            var className:String;
            var filename:String;
            var itemAsset:Object;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var pAllowNull:Boolean=false;
            var pItemId:*;
            var pPlayerItemId:*=null;
            var pView:*;
            var retVal:*;
            var view:String;

            retVal = undefined;
            itemAsset = null;
            view = null;
            className = null;
            AssetClass = null;
            pItemId = arg1;
            pView = arg2;
            pPlayerItemId = arg3;
            pAllowNull = arg4;
            retVal = null;
            pItemId = String(pItemId);
            filename = this._idToFileNameMap[pItemId];
            if (filename == null)
            {
                return pAllowNull ? null : getMissingItem(pPlayerItemId);
            }
            asset = this._assets[filename];
            if (asset == null)
            {
                return getMissingItem(pPlayerItemId);
            }
            itemAsset = this.getItemAsset(asset, pItemId);
            view = (pView as String) ? pView : "Front";
            if (pView != -1)
            {
                if (pView >= 2)
                {
                    view = "Back";
                }
            }
            else 
            {
                view = "Preview";
            }
            className = itemAsset.itemData ? itemAsset.itemData.className : null;
            if (className)
            {
                if (!itemAsset.itemData.isInteractive)
                {
                    className = className + "." + view;
                }
                try
                {
                    AssetClass = getDefinitionByName(className) as Class;
                    retVal = new AssetClass();
                    if (itemAsset.itemData.isInteractive)
                    {
                        retVal.init();
                    }
                    retVal.itemData = itemAsset.itemData;
                    retVal.playerItemId = pPlayerItemId;
                    if (itemAsset.itemData.isInteractive)
                    {
                        retVal.showView(view);
                    }
                }
                catch (e:*)
                {
                    if (!pAllowNull)
                    {
                        view = "Front";
                        className = itemAsset.itemData ? itemAsset.itemData.className : null;
                        className = className + "." + view;
                        try
                        {
                            AssetClass = getDefinitionByName(className) as Class;
                            retVal = new AssetClass();
                            if (itemAsset.itemData.isInteractive)
                            {
                                retVal.init();
                            }
                            retVal.itemData = itemAsset.itemData;
                            retVal.playerItemId = pPlayerItemId;
                            if (itemAsset.itemData.isInteractive)
                            {
                                retVal.showView(view);
                            }
                        }
                        catch (e:*)
                        {
                        };
                    }
                }
            }
            if (!retVal && !pAllowNull)
            {
                return getMissingItem(pPlayerItemId);
            }
            return retVal;
        }

        public function loadImage(arg1:String, arg2:Object=null, arg3:Function=null):void
        {
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = null;
            if (arg1)
            {
                loc4 = {"context":arg2, "callback":arg3};
                loc5 = new AssetLoader(arg1, null, loc4);
                loc4.loader = loc5;
                loc5.addEventListener(Event.COMPLETE, imageLoadingComplete);
                loc5.addEventListener(IOErrorEvent.IO_ERROR, imageLoadingError);
            }
            else 
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.IMAGELOAD_ERROR, null, arg2));
                if (arg3 != null)
                {
                    arg3.call(null, null, arg2);
                }
            }
            return;
        }

        public function getClothingPartList(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            arg1 = String(arg1);
            loc2 = this._idToFileNameMap[arg1];
            loc3 = this._assets[loc2];
            if (loc3 != null)
            {
                if ((loc4 = this.getItemAsset(loc3, arg1)) == null)
                {
                    return null;
                }
                if (!(loc4.itemData == null) && !(loc4.itemData.supportedViews == null))
                {
                    return loc4.itemData.supportedViews;
                }
                return SimpleClothingItem.ALL_VIEWS;
            }
            return null;
        }

        private function getMovieChildrenFloorBlocks(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = [];
            loc4 = 0;
            loc5 = getMovieChildren(arg1);
            for each (loc3 in loc5)
            {
                if (!(loc3.width == 30 && loc3.height == 15))
                {
                    continue;
                }
                loc2.push(loc3);
            }
            return loc2;
        }

        private function promoLoaderComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = undefined;
            loc4 = null;
            loc2 = arg1.target as AssetLoader;
            if (loc2)
            {
                loc3 = loc2.content;
                loc4 = loc2.context["url"];
                _promoAds[loc4] = loc3;
                loc2.removeEventListener(Event.COMPLETE, promoLoaderComplete);
                loc2.removeEventListener(IOErrorEvent.IO_ERROR, promoLoaderError);
                loc2.cleanUp();
            }
            return;
        }

        public function getPromoAd(arg1:String):flash.display.DisplayObject
        {
            return getInstance()._promoAds[arg1];
        }

        public function getItemLoadStatus(arg1:Object):Number
        {
            var loc2:*;

            loc2 = _idToFileNameMap[arg1];
            if (loc2 == null)
            {
                return STATUS_FILE_LOAD_NOT_ATTEMPTED;
            }
            if (_assets[loc2] == null)
            {
                return STATUS_FILE_LOAD_NOT_ATTEMPTED;
            }
            return _assets[loc2].status;
        }

        private function getMissingItem(arg1:*=null):MyLife.Assets.MissingItem
        {
            var loc2:*;

            loc2 = new MissingItem();
            loc2.itemData = {};
            loc2.playerItemId = arg1;
            return loc2;
        }

        public function load():void
        {
            assetLoadingComplete(null);
            return;
        }

        private function getItemAsset(arg1:Object, arg2:Object):Object
        {
            var loc3:*;

            loc3 = new Object();
            loc3.itemId = arg2;
            if (arg1.itemData != null)
            {
                loc3.itemData = MyLifeUtils.cloneObject(arg1.itemData);
                loc3.itemData.itemId = arg2;
            }
            return loc3;
        }

        public function doesViewExist(arg1:String, arg2:String):Boolean
        {
            var asset:Object;
            var assetClass:Class;
            var className:String;
            var filename:String;
            var loc3:*;
            var loc4:*;
            var pItemId:String;
            var view:String;

            assetClass = null;
            pItemId = arg1;
            view = arg2;
            filename = this._idToFileNameMap[pItemId];
            if (filename == null)
            {
                return false;
            }
            asset = this._assets[filename];
            if (asset == null)
            {
                return false;
            }
            className = asset.itemData ? asset.itemData.className : null;
            if (className == null)
            {
                return false;
            }
            className = className + "." + view;
            try
            {
                assetClass = getDefinitionByName(className) as Class;
            }
            catch (error:Error)
            {
                return false;
            }
            return true;
        }

        public function loadAsset(arg1:Object, arg2:String="item_asset_path"):Boolean
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = null;
            loc4 = null;
            loc6 = null;
            loc7 = null;
            if (arg1.hasOwnProperty("filename") || arg2 == "avatar_asset_path")
            {
                loc3 = arg1.itemId;
                loc4 = arg1.filename;
            }
            else 
            {
                if (arg1.hasOwnProperty("itemId"))
                {
                    loc4 = loc8 = String(arg1.itemId);
                    loc3 = loc8;
                }
                else 
                {
                    loc4 = loc8 = String(arg1);
                    loc3 = loc8;
                }
            }
            if (!loc4 || loc4 == "")
            {
                if (arg2 == "avatar_asset_path")
                {
                    dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSETLOAD_SUCCESS, arg1));
                    return true;
                }
                loc4 = String(loc3);
            }
            if ((loc5 = _assets[loc4]) != null)
            {
                if (loc5.status != STATUS_FILE_LOADING)
                {
                    if (loc5.status != STATUS_FILE_LOADED)
                    {
                        if (loc5.status == STATUS_FILE_FAILED)
                        {
                            if (loc5.itemIds.indexOf(loc3) == -1)
                            {
                                loc5.itemIds.push(loc3);
                                _idToFileNameMap[loc3] = loc4;
                            }
                            dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSETLOAD_ERROR, getItemAsset(loc5, loc3)));
                        }
                    }
                    else 
                    {
                        if (loc5.itemIds.indexOf(loc3) == -1)
                        {
                            loc5.itemIds.push(loc3);
                            _idToFileNameMap[loc3] = loc4;
                        }
                        dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSETLOAD_SUCCESS, getItemAsset(loc5, loc3)));
                    }
                }
                else 
                {
                    if (loc5.itemIds.indexOf(loc3) == -1)
                    {
                        loc5.itemIds.push(loc3);
                        _idToFileNameMap[loc3] = loc4;
                    }
                }
            }
            else 
            {
                (loc5 = new Object()).filename = loc4;
                loc5.status = STATUS_FILE_LOADING;
                loc5.itemIds = [loc3];
                _idToFileNameMap[loc3] = loc4;
                _assets[loc4] = loc5;
                loc6 = (loc6 = arg1.hasOwnProperty("url") ? arg1["url"] : config.variables["global"][arg2] + loc4 + ".swf") + config.assetVersionParam;
                (loc7 = new AssetLoader(loc6, new LoaderContext(false, ApplicationDomain.currentDomain), loc5)).addEventListener(Event.COMPLETE, itemAssetLoadingComplete);
                loc7.addEventListener(ProgressEvent.PROGRESS, itemAssetLoadingStatus);
                loc7.addEventListener(IOErrorEvent.IO_ERROR, itemAssetIOError);
                _assets[loc4].loader = loc7;
            }
            return true;
        }

        public function preloadPromos():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc1 = config.variables["promos"];
            loc2 = loc1 ? loc1["DEFAULT"] : null;
            if (loc2)
            {
                loc6 = 0;
                loc7 = loc2;
                for each (loc3 in loc7)
                {
                    if (!(loc4 = loc3["url"]))
                    {
                        continue;
                    }
                    if (loc4.substr(0, 4) != "http")
                    {
                        loc4 = config.variables["global"]["asset_path"] + loc4 + config.assetVersionParam;
                    }
                    (loc5 = new AssetLoader(loc4, null, loc3)).addEventListener(Event.COMPLETE, promoLoaderComplete);
                    loc5.addEventListener(IOErrorEvent.IO_ERROR, promoLoaderError);
                }
            }
            return;
        }

        private function imageLoadingError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, imageLoadingComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadingError);
            loc3 = null;
            if (loc2.context)
            {
                loc4 = null;
                loc3 = loc2.context["context"];
                loc4 = loc2.context["callback"];
                if (loc2.context["loader"])
                {
                    delete loc2.context["loader"];
                }
                loc2.context["context"] = null;
                loc2.context["callback"] = null;
                loc2.context = null;
                if (loc4 != null)
                {
                    loc4.call(null, null, loc3);
                }
            }
            loc3 = loc3 ? loc3 : loc2.context;
            dispatchEvent(new AssetManagerEvent(AssetManagerEvent.IMAGELOAD_ERROR, null, loc3));
            loc2.cleanUp();
            return;
        }

        private function getMovieChildren(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc4 = null;
            loc2 = new Array();
            if (arg1)
            {
                loc3 = 0;
                while (loc3 < arg1.numChildren) 
                {
                    loc4 = arg1.getChildAt(loc3);
                    loc2.unshift(loc4);
                    ++loc3;
                }
            }
            return loc2;
        }

        private function promoLoaderError(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target as AssetLoader;
            if (loc2)
            {
                loc2.cleanUp();
                loc2.removeEventListener(Event.COMPLETE, promoLoaderComplete);
                loc2.removeEventListener(IOErrorEvent.IO_ERROR, promoLoaderError);
            }
            return;
        }

        private function itemAssetLoadingComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc3 = loc2.context;
            if ((loc4 = loc2.content).hasOwnProperty("getItemData"))
            {
                loc3.itemData = loc4.getItemData();
            }
            if (loc3.itemData == null)
            {
                loc3.itemData = new Object();
            }
            loc3.itemData.filename = loc3.filename;
            loc3.status = STATUS_FILE_LOADED;
            if (loc3.itemData.className != null)
            {
                if (loc3.itemData.className == "MyLife.Assets.SimpleItem" || loc3.itemData.className == "MyLife.Assets.ActiveItem")
                {
                    loc3.itemData.className = "MyLife.Assets." + loc3.filename;
                }
            }
            else 
            {
                if (loc3.itemIds.length == 1 && loc3.filename == String(loc3.itemIds[0]))
                {
                    loc3.itemData.className = "MyLife.Assets.Item_" + loc3.filename;
                }
                else 
                {
                    loc3.itemData.className = "MyLife.Assets." + loc3.filename;
                }
            }
            if (!loc3.itemData.hasOwnProperty("isProp"))
            {
                if (getMovieChildrenFloorBlocks(getAssetInstanceByItemId(loc3.itemIds[0], 0)).length > 0)
                {
                    loc3.itemData.isProp = false;
                }
                else 
                {
                    loc3.itemData.isProp = true;
                }
            }
            _assets[loc3.itemData.filename] = loc3;
            loc2.cleanUp();
            loc2.removeEventListener(Event.COMPLETE, itemAssetLoadingComplete);
            loc2.removeEventListener(ProgressEvent.PROGRESS, itemAssetLoadingStatus);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, itemAssetIOError);
            if (loc3 && loc3.hasOwnProperty("loader"))
            {
                loc3.loader = null;
                delete loc3.loader;
            }
            loc6 = 0;
            loc7 = loc3.itemIds;
            for each (loc5 in loc7)
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSETLOAD_SUCCESS, this.getItemAsset(loc3, loc5)));
            }
            return;
        }

        private function imageLoadingComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, imageLoadingComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadingError);
            loc3 = null;
            if (loc2.context)
            {
                loc4 = null;
                loc3 = loc2.context["context"];
                loc4 = loc2.context["callback"];
                if (loc2.context["loader"])
                {
                    delete loc2.context["loader"];
                }
                loc2.context["context"] = null;
                loc2.context["callback"] = null;
                loc2.context = null;
                if (loc4 != null)
                {
                    loc4.call(null, loc2.content, loc3);
                }
            }
            loc3 = loc3 ? loc3 : loc2.context;
            if (loc2.content)
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.IMAGELOAD_SUCCESS, loc2.content, loc3));
            }
            else 
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.IMAGELOAD_ERROR, null, loc3));
            }
            loc2.cleanUp();
            return;
        }

        public function loadAction(arg1:String, arg2:Object=null, arg3:Function=null):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            if (arg1)
            {
                loc4 = config.variables["global"]["avatar_asset_path"] + "actions/" + arg1 + ".swf" + config.assetVersionParam;
                loc5 = {"context":arg2, "callback":arg3};
                (loc6 = new AssetLoader(loc4, null, loc5)).addEventListener(Event.COMPLETE, actionLoadingComplete);
                loc6.addEventListener(IOErrorEvent.IO_ERROR, actionLoadingError);
            }
            else 
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ACTIONLOAD_ERROR, new LoaderContext(false, ApplicationDomain.currentDomain), arg2));
                if (arg3 != null)
                {
                    arg3.call(null, null, arg2);
                }
            }
            return;
        }

        private function assetLoadingStatus(arg1:flash.events.ProgressEvent):void
        {
            var loc2:*;

            loc2 = arg1.bytesLoaded / arg1.bytesTotal * 100;
            LoadingStatus.getInstance().setProgress(loc2, 100);
            return;
        }

        private function actionLoadingComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, actionLoadingComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, actionLoadingError);
            loc3 = null;
            if (loc2.context)
            {
                loc4 = null;
                loc3 = loc2.context["context"];
                loc4 = loc2.context["callback"];
                loc2.context["context"] = null;
                loc2.context["callback"] = null;
                loc2.context = null;
                if (loc4 != null)
                {
                    loc4.call(null, loc2.content, loc3);
                }
            }
            loc3 = loc3 ? loc3 : loc2.context;
            if (loc2.content)
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ACTIONLOAD_SUCCESS, loc2.content, loc3));
            }
            else 
            {
                dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ACTIONLOAD_ERROR, null, loc3));
            }
            loc2.cleanUp();
            return;
        }

        public static function getInstance():MyLife.AssetsManager
        {
            if (!_instance)
            {
                _instance = new AssetsManager();
            }
            return _instance;
        }

        public static const STATUS_FILE_FAILED:Number=2;

        public static const STATUS_FILE_LOAD_NOT_ATTEMPTED:Number=3;

        public static const STATUS_FILE_LOADING:Number=0;

        public static const STATUS_FILE_LOADED:Number=1;

        private var _promoAds:Object;

        private var _idToFileNameMap:Object;

        private var _assets:Object;

        private static var _instance:MyLife.AssetsManager;
    }
}
