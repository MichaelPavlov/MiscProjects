package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class FactoryWorkDialog extends flash.display.MovieClip
    {
        public function FactoryWorkDialog()
        {
            super();
            btnHireCrew.buttonMode = true;
            btnHireCrew.mouseChildren = false;
            btnHireCrew.useHandCursor = true;
            btnHelpRequest.buttonMode = true;
            btnHelpRequest.mouseChildren = false;
            btnHelpRequest.useHandCursor = true;
            return;
        }

        private function unloadInterface():void
        {
            dispatchEvent(new Event(Event.CLOSE));
            MyLifeInstance.getInstance().getInterface().unloadInterface(this);
            return;
        }

        private function btnCloseHandler(arg1:flash.events.MouseEvent):void
        {
            title.visible = false;
            message.visible = false;
            btnHelpRequest.text.visible = false;
            btnHireCrew.text.visible = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":cleanUp});
            return;
        }

        public function cleanUp():void
        {
            btnClose.removeEventListener(MouseEvent.CLICK, btnCloseHandler);
            unloadInterface();
            if (_feedTimer)
            {
                _feedTimer.stop();
                _feedTimer.data = null;
                _feedTimer.removeEventListener(TimerEvent.TIMER, countDownHandler);
                _feedTimer = null;
            }
            if (_workTimer)
            {
                _workTimer.stop();
                _workTimer.data = null;
                _workTimer.removeEventListener(TimerEvent.TIMER, countDownHandler);
                _workTimer = null;
            }
            return;
        }

        private function updateCountDown(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            if (Number(arg1.timeLeft) >= 0)
            {
                loc2 = "";
                loc3 = Math.floor(arg1.timeLeft / 3600) % 24;
                loc4 = Math.floor(arg1.timeLeft / 60) % 60;
                loc5 = arg1.timeLeft % 60;
                loc2 = String((loc3 < 10) ? "0" + loc3 : loc3);
                loc2 = loc2 + ":";
                loc2 = loc2 + String((loc4 < 10) ? "0" + loc4 : loc4);
                loc2 = loc2 + ":";
                loc2 = loc2 + String((loc5 < 10) ? "0" + loc5 : loc5);
                loc7 = ((loc6 = arg1).timeLeft - 1);
                loc6.timeLeft = loc7;
                arg1.textField.text = arg1.messageTemplate.replace("[[count_down]]", loc2);
            }
            return;
        }

        private function countDownHandler(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as DataTimer;
            if (loc2)
            {
                updateCountDown(loc2.data);
            }
            return;
        }

        public function close():void
        {
            btnCloseHandler(null);
            return;
        }

        public function initialize(arg1:*=null, arg2:*=null):void
        {
            var loc3:*;

            loc3 = null;
            btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
            if (arg2)
            {
                message.text = arg2["workMessage"] || "";
                title.text = arg2["title"] || "";
                if (arg2["workTimeLeft"])
                {
                    loc3 = {"timeLeft":Number(arg2["workTimeLeft"]), "messageTemplate":arg2["workMessage"], "textField":message};
                    _workTimer = new DataTimer(loc3, 1000);
                    _workTimer.addEventListener(TimerEvent.TIMER, countDownHandler);
                    _workTimer.start();
                    updateCountDown(loc3);
                }
                if (arg2["feedTimeLeft"])
                {
                    btnHelpRequest.mouseEnabled = false;
                    btnHelpRequest.buttonGraphic.visible = false;
                    TextField(btnHelpRequest.text).textColor = 3953021;
                    loc3 = {"timeLeft":Number(arg2["feedTimeLeft"]), "messageTemplate":arg2["feedMessage"], "textField":btnHelpRequest.text};
                    _feedTimer = new DataTimer(loc3, 1000);
                    _feedTimer.addEventListener(TimerEvent.TIMER, countDownHandler);
                    _feedTimer.start();
                    updateCountDown(loc3);
                }
                else 
                {
                    btnHelpRequest.text.text = arg2["feedMessage"] || "";
                }
                if (arg2["crewCount"] >= 50)
                {
                    btnHireCrew.mouseEnabled = false;
                    btnHireCrew.buttonGraphic.visible = false;
                    TextField(btnHireCrew.text).textColor = 3953021;
                }
                btnHireCrew.text.text = arg2["recruitMessage"] || "";
            }
            return;
        }

        public var message:flash.text.TextField;

        private var _feedTimer:MyLife.Utils.DataTimer;

        public var btnHireCrew:flash.display.MovieClip;

        public var btnHelpRequest:flash.display.MovieClip;

        private var _workTimer:MyLife.Utils.DataTimer;

        public var btnClose:flash.display.SimpleButton;

        public var title:flash.text.TextField;
    }
}
