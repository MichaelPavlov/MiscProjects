package MyLife 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    
    public class AssetLoader extends flash.events.EventDispatcher
    {
        public function AssetLoader(arg1:String, arg2:flash.system.LoaderContext=null, arg3:Object=null)
        {
            super();
            context = arg3;
            _loader = new Loader();
            _loaderInfo = _loader.contentLoaderInfo;
            _loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
            _loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
            _loaderInfo.addEventListener(Event.INIT, loaderCompleteHandler);
            if (arg2 == null)
            {
                arg2 = new LoaderContext();
            }
            arg2.checkPolicyFile = true;
            _loader.load(new URLRequest(arg1), arg2);
            return;
        }

        private function loaderProgressHandler(arg1:flash.events.ProgressEvent):void
        {
            dispatchEvent(arg1);
            return;
        }

        public function cleanUp():void
        {
            _loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
            _loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
            _loaderInfo.removeEventListener(Event.INIT, loaderCompleteHandler);
            _loader = null;
            _loaderInfo = null;
            content = null;
            context = null;
            return;
        }

        private function loaderIOErrorHandler(arg1:flash.events.IOErrorEvent):void
        {
            _loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
            _loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
            _loaderInfo.removeEventListener(Event.INIT, loaderCompleteHandler);
            dispatchEvent(arg1);
            return;
        }

        private function loaderCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var pEvent:flash.events.Event;

            pEvent = arg1;
            _loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
            _loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
            _loaderInfo.removeEventListener(Event.INIT, loaderCompleteHandler);
            try
            {
                content = _loaderInfo.content;
            }
            catch (e:SecurityError)
            {
                content = _loader;
            }
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }

        private var _loaderInfo:flash.display.LoaderInfo;

        public var content:*=null;

        public var context:Object=null;

        private var _loader:flash.display.Loader;
    }
}
