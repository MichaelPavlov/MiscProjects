package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class GenericDialog extends flash.display.MovieClip
    {
        public function GenericDialog()
        {
            _metaData = {};
            super();
            modalMask.buttonMode = true;
            modalMask.enabled = false;
            icon_coins.visible = false;
            icon_loading.visible = false;
            return;
        }

        private function autoCloseTimerTick(arg1:flash.events.TimerEvent):*
        {
            var alreadyUnloaded:Boolean;
            var e:flash.events.TimerEvent;
            var loc2:*;
            var loc3:*;

            e = arg1;
            autoCloseTimer.stop();
            autoCloseTimer.removeEventListener("timer", autoCloseTimerTick);
            alreadyUnloaded = false;
            try
            {
                _myLife._interface.unloadInterface(this);
            }
            catch (e:Error)
            {
                alreadyUnloaded = true;
            }
            if (!alreadyUnloaded)
            {
                dispatchEvent(new MyLifeEvent(MyLifeEvent.DIALOG_RESPONSE, {"userResponse":autoCloseCMD, "metaData":_metaData}, false));
            }
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function setupButtons(arg1:Array, arg2:Boolean=false):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc6 = undefined;
            loc7 = null;
            loc8 = null;
            loc9 = undefined;
            loc3 = 0;
            loc4 = [dialogButton1, dialogButton2, dialogButton3];
            if ((loc5 = arg1).length == 0)
            {
                if (arg2)
                {
                    loc5 = [];
                }
                else 
                {
                    loc5 = [{"name":"OK", "value":"BTN_OK"}];
                }
            }
            loc3 = 0;
            while (loc3 < loc5.length) 
            {
                loc6 = loc5[loc3];
                loc7 = "OK";
                loc8 = "BTN_OK";
                if (loc6.name)
                {
                    loc7 = loc6.name;
                }
                if (loc6.value)
                {
                    loc8 = loc6.value;
                }
                (loc9 = loc4[((loc5.length - 1) - loc3)]).buttonText.text = loc7;
                loc9.buttonValue = loc8;
                loc9.hitZone.addEventListener(MouseEvent.CLICK, selectDialogButton);
                ++loc3;
            }
            loc3 = loc5.length;
            while (loc3 < 3) 
            {
                loc4[loc3].visible = false;
                ++loc3;
            }
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
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
                message.text = "Are you sure?";
            }
            if (arg2.buttons)
            {
                setupButtons(arg2.buttons);
            }
            else 
            {
                if (arg2.noButtons)
                {
                    setupButtons([], true);
                }
                else 
                {
                    setupButtons([]);
                }
            }
            if (arg2.metaData)
            {
                _metaData = arg2.metaData;
            }
            if (arg2.icon)
            {
                enableIconMode(arg2.icon);
            }
            if (arg2.autoClose)
            {
                autoCloseTimer = new Timer(arg2.autoClose * 1000, 1);
                autoCloseTimer.addEventListener("timer", autoCloseTimerTick);
                autoCloseTimer.start();
            }
            if (arg2.autoCloseCMD)
            {
                autoCloseCMD = arg2.autoCloseCMD;
            }
            _metaData.parentClip = this;
            hide();
            _myLife.addChild(this);
            return;
        }

        private function enableIconMode(arg1:String):*
        {
            message.x = message.x + 100;
            message.width = message.width - 100;
            if (arg1 == "coins")
            {
                icon_coins.visible = true;
            }
            if (arg1 == "loading")
            {
                icon_loading.visible = true;
            }
            return;
        }

        private function selectDialogButton(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            if (autoCloseTimer)
            {
                autoCloseTimer.stop();
                autoCloseTimer.removeEventListener("timer", autoCloseTimerTick);
            }
            loc2 = arg1.currentTarget;
            _myLife._interface.unloadInterface(this);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.DIALOG_RESPONSE, {"userResponse":loc2.parent.buttonValue, "metaData":_metaData}, false));
            return;
        }

        public var icon_coins:flash.display.MovieClip;

        public var message:flash.text.TextField;

        public var dialogButton1:flash.display.MovieClip;

        public var title:flash.text.TextField;

        public var dialogButton3:flash.display.MovieClip;

        public var dialogButton2:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        private var _metaData:Object;

        private var autoCloseCMD:String="BTN_OK";

        public var icon_loading:flash.display.MovieClip;

        public var modalMask:flash.display.MovieClip;

        private var autoCloseTimer:flash.utils.Timer;
    }
}
