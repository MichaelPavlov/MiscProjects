package MyLife.Events 
{
    import MyLife.*;
    import flash.events.*;
    
    public class AssetManagerEvent extends MyLife.MyLifeEvent
    {
        public function AssetManagerEvent(arg1:String, arg2:Object=null, arg3:Object=null, arg4:Boolean=true)
        {
            super(arg1, arg2, arg4);
            asset = arg2;
            context = arg3;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new AssetManagerEvent(type, asset, context, bubbles);
        }

        public static const ACTIONLOAD_SUCCESS:String="AM_ACTION_LOAD_COMPLETE";

        public static const ACTIONLOAD_ERROR:String="AM_ACTION_LOAD_ERROR";

        public static const IMAGELOAD_ERROR:String="AM_IMAGELOAD_ERROR";

        public static const IMAGELOAD_SUCCESS:String="AM_IMAGELOAD_SUCCESS";

        public static const ASSETLOAD_SUCCESS:String="MLE_ASSET_LOAD_COMPLETE";

        public static const ASSETLOAD_ERROR:String="MLE_ASSET_LOAD_ERROR";

        public var asset:Object=null;

        public var context:Object=null;
    }
}
