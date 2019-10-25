package 
{
    import MyLife.*;
    import com.flashdynamix.utils.*;
    import flash.display.*;
    import flash.events.*;
    
    public class YoVilleApp extends flash.display.MovieClip
    {
        public function YoVilleApp(arg1:Object)
        {
            super();
            _myLife = new MyLife();
            addChild(_myLife);
            _myLife.init(arg1);
            addEventListener(Event.ADDED_TO_STAGE, addedToStageToHandler, false, 0, true);
            return;
        }

        private function makeProfiler():void
        {
            SWFProfiler.init(stage, this);
            return;
        }

        private function addedToStageToHandler(arg1:flash.events.Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageToHandler);
            makeProfiler();
            return;
        }

        private var _myLife:MyLife.MyLife=null;
    }
}
