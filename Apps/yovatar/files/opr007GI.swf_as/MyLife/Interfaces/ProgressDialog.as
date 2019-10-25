package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class ProgressDialog extends flash.display.MovieClip
    {
        public function ProgressDialog()
        {
            _postData = [];
            super();
            modalMask.buttonMode = true;
            modalMask.enabled = false;
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            if (arg2.title)
            {
                title.text = arg2.title;
            }
            else 
            {
                title.text = _myLife.myLifeConfiguration.variables["global"]["APPNAME"];
            }
            if (arg2.message)
            {
                message.text = arg2.message;
            }
            else 
            {
                message.text = "Loading...";
            }
            if (arg2.keepWindowOpen)
            {
                _keepWindowOpen = arg2.keepWindowOpen;
            }
            hide();
            _myLife.addChild(this);
            if (arg2.url)
            {
                _url = arg2.url;
            }
            if (arg2.postData)
            {
                _postData = arg2.postData;
            }
            if (arg2.delay)
            {
                _delay = arg2.delay;
            }
            if (!(_url == "" && arg2.keepWindowOpen))
            {
                delayTimer = new Timer(_delay, 1);
                delayTimer.addEventListener(TimerEvent.TIMER, delayTimerNotify);
                delayTimer.start();
            }
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function onLoaderError(arg1:flash.events.IOErrorEvent):*
        {
            trace("onLoaderError");
            _response = "Error Contacting The Server";
            progressActionComplete();
            return false;
        }

        public function progressActionComplete():*
        {
            if (!_keepWindowOpen)
            {
                _myLife._interface.unloadInterface(this);
            }
            dispatchEvent(new MyLifeEvent(MyLifeEvent.PROGRESS_COMPLETE, {"success":_success, "response":_response}, false));
            return;
        }

        private function delayTimerNotify(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            delayTimer.removeEventListener(TimerEvent.TIMER, delayTimerNotify);
            loc2 = new URLVariables();
            loc6 = 0;
            loc7 = _postData;
            for each (loc3 in loc7)
            {
                loc2[loc3.name] = loc3.value;
            }
            (loc4 = new URLRequest(_url)).data = loc2;
            loc4.method = URLRequestMethod.POST;
            (loc5 = new URLLoader()).addEventListener(Event.COMPLETE, onLoaderComplete);
            loc5.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            loc5.load(loc4);
            return;
        }

        private function onLoaderComplete(arg1:flash.events.Event):*
        {
            _success = true;
            _response = arg1.target.data;
            progressActionComplete();
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private var delayTimer:flash.utils.Timer;

        private var _success:Boolean=false;

        public var message:flash.text.TextField;

        private var _postData:Array;

        private var _delay:int=2000;

        public var title:flash.text.TextField;

        private var _keepWindowOpen:Boolean=false;

        private var _response:String="";

        private var _myLife:flash.display.MovieClip;

        private var _url:String="";

        public var modalMask:flash.display.MovieClip;
    }
}
