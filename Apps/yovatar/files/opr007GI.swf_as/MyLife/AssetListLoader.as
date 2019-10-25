package MyLife 
{
    import MyLife.Events.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class AssetListLoader extends Object
    {
        public function AssetListLoader()
        {
            super();
            return;
        }

        private function onFinishedLoadingAssetList(arg1:flash.events.TimerEvent=null):void
        {
            allDoneCallBack.call();
            cancel();
            return;
        }

        public function loadAssets(arg1:Array, arg2:Function, arg3:Number=15000, arg4:String=null):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            showLoadStatus = !(arg4 == null);
            if (showLoadStatus)
            {
                MyLifeInstance.getInstance().loadingStatus.setTask(arg4);
                MyLifeInstance.getInstance().loadingStatus.setProgress(0, 100);
            }
            assetLoadStatus = new Object();
            itemsToLoad = loc6 = arg1.length;
            numRequestedItems = loc6;
            this.allDoneCallBack = arg2;
            MyLifeInstance.getInstance().assetsLoader.addEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onAssetLoadCompleted);
            MyLifeInstance.getInstance().assetsLoader.addEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onAssetLoadCompleted);
            loadTimer = new Timer(arg3);
            loadTimer.addEventListener(TimerEvent.TIMER, onFinishedLoadingAssetList);
            loadTimer.start();
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                if (assetLoadStatus[arg1[loc5].itemId] != null)
                {
                    loc8 = ((loc6 = assetLoadStatus)[(loc7 = arg1[loc5].itemId)] + 1);
                    loc6[loc7] = loc8;
                }
                else 
                {
                    assetLoadStatus[arg1[loc5].itemId] = 1;
                }
                MyLifeInstance.getInstance().assetsLoader.loadAsset(arg1[loc5]);
                loc5 = (loc5 + 1);
            }
            return;
        }

        private function onAssetLoadCompleted(arg1:MyLife.Events.AssetManagerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = NaN;
            loc3 = NaN;
            if (assetLoadStatus[arg1.eventData.itemId] != null)
            {
                loc2 = assetLoadStatus[arg1.eventData.itemId];
                delete assetLoadStatus[arg1.eventData.itemId];
                itemsToLoad = itemsToLoad - loc2;
                if (showLoadStatus)
                {
                    loc3 = Math.round((numRequestedItems - itemsToLoad) / numRequestedItems * 100);
                    MyLifeInstance.getInstance().loadingStatus.setProgress(loc3);
                }
                if (itemsToLoad != 0)
                {
                    loadTimer.reset();
                    loadTimer.start();
                }
                else 
                {
                    onFinishedLoadingAssetList();
                }
            }
            return;
        }

        public function cancel():void
        {
            MyLifeInstance.getInstance().assetsLoader.removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onAssetLoadCompleted);
            MyLifeInstance.getInstance().assetsLoader.removeEventListener(AssetManagerEvent.ASSETLOAD_ERROR, onAssetLoadCompleted);
            loadTimer.stop();
            loadTimer.removeEventListener(TimerEvent.TIMER, onFinishedLoadingAssetList);
            loadTimer = null;
            allDoneCallBack = null;
            return;
        }

        private static const TIME_OUT:Number=30;

        private var itemsToLoad:Number;

        private var allDoneCallBack:Function;

        private var assetLoadStatus:Object;

        private var showLoadStatus:Boolean;

        private var numRequestedItems:Number;

        private var loadTimer:flash.utils.Timer;
    }
}
