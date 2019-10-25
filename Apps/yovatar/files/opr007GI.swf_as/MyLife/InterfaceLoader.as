package MyLife 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    
    public class InterfaceLoader extends flash.events.EventDispatcher
    {
        public function InterfaceLoader(arg1:flash.display.MovieClip)
        {
            super();
            _myLife = arg1;
            return;
        }

        private function interfaceLoadingStatus(arg1:flash.events.ProgressEvent):*
        {
            var loc2:*;

            loc2 = arg1.bytesLoaded / arg1.bytesTotal * 100;
            _myLife.loadingStatus.setProgress(loc2, 100);
            return;
        }

        private function interfaceLoadingComplete(arg1:flash.events.Event):*
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.LOADING_DONE, arg1.currentTarget.content));
            _myLife.loadingStatus.setProgress(100, (100));
            return;
        }

        public function load():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            _myLife.loadingStatus.setTask("Loading Interface...");
            _myLife.loadingStatus.setProgress(0, 100);
            loc1 = new Loader();
            loc2 = _myLife.myLifeConfiguration.variables["querystring"]["static_base_url"] + "Interface.swf" + _myLife.runningLocal ? "" : "?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
            loc3 = new URLRequest(loc2);
            loc1.contentLoaderInfo.addEventListener(Event.COMPLETE, interfaceLoadingComplete);
            loc1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, interfaceLoadingStatus);
            loc4 = new LoaderContext(false, ApplicationDomain.currentDomain);
            loc1.load(loc3, loc4);
            return;
        }

        private var _myLife:flash.display.MovieClip;
    }
}
