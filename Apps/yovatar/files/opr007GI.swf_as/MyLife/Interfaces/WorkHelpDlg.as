package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class WorkHelpDlg extends flash.display.MovieClip
    {
        public function WorkHelpDlg()
        {
            super();
            btnWork.buttonMode = true;
            btnWork.mouseChildren = false;
            btnWork.useHandCursor = true;
            return;
        }

        private function setButtonText(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = btnWork["buttonTextField"] as TextField;
            loc3 = btnWork["buttonGraphic"] as MovieClip;
            loc2.htmlText = "<b>" + arg1 + "</b>";
            loc4 = loc2.textWidth + 40;
            loc3.width = (loc4 < MAX_BUTTON_WIDTH) ? loc4 : MAX_BUTTON_WIDTH;
            loc2.width = loc3.width - 20;
            loc3.x = -loc3.width / 2;
            loc2.x = -loc2.width / 2;
            return;
        }

        public function close():void
        {
            btnCloseHandler(null);
            return;
        }

        private function unloadInterface():void
        {
            dispatchEvent(new Event(Event.CLOSE));
            MyLifeInstance.getInstance().getInterface().unloadInterface(this);
            return;
        }

        public function cleanUp():void
        {
            if (_countDownTimer)
            {
                _countDownTimer.stop();
                _countDownTimer.removeEventListener(TimerEvent.TIMER, countDownHandler);
                _countDownTimer = null;
            }
            btnClose.removeEventListener(MouseEvent.CLICK, btnCloseHandler);
            unloadInterface();
            return;
        }

        public function initialize(arg1:*=null, arg2:*=null):void
        {
            var loc3:*;

            loc3 = null;
            btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
            if (arg2)
            {
                title.text = arg2["title"] || "";
                message.text = arg2["message"] || "";
                if (!(message.text.indexOf("[[count_down]]") == -1) && arg2["timeLeft"])
                {
                    createCountDown(message.text, Number(arg2["timeLeft"]));
                }
                loc3 = arg2["btnText"] || "Work Now";
                setButtonText(loc3);
            }
            else 
            {
                setButtonText("Work Now");
            }
            return;
        }

        private function countDownHandler(arg1:flash.events.TimerEvent):void
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
            if (Number(_timeLeft) >= 0)
            {
                loc2 = "";
                loc3 = Math.floor(_timeLeft / 3600) % 24;
                loc4 = Math.floor(_timeLeft / 60) % 60;
                loc5 = _timeLeft % 60;
                loc2 = String((loc3 < 10) ? "0" + loc3 : loc3);
                loc2 = loc2 + ":";
                loc2 = loc2 + String((loc4 < 10) ? "0" + loc4 : loc4);
                loc2 = loc2 + ":";
                loc2 = loc2 + String((loc5 < 10) ? "0" + loc5 : loc5);
                _timeLeft--;
                message.text = _messageTemplate.replace("[[count_down]]", loc2);
            }
            return;
        }

        private function createCountDown(arg1:String, arg2:Number):void
        {
            _countDownTimer = new Timer(1000);
            _messageTemplate = arg1;
            _timeLeft = arg2;
            _countDownTimer.addEventListener(TimerEvent.TIMER, countDownHandler);
            _countDownTimer.start();
            countDownHandler(new TimerEvent(TimerEvent.TIMER));
            return;
        }

        private function btnCloseHandler(arg1:flash.events.MouseEvent):void
        {
            title.visible = false;
            message.visible = false;
            btnWork["buttonTextField"].visible = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":cleanUp});
            return;
        }

        private static const MAX_BUTTON_WIDTH:int=220;

        private var _messageTemplate:String;

        public var message:flash.text.TextField;

        private var _timeLeft:Number;

        public var btnWork:flash.display.MovieClip;

        private var _countDownTimer:flash.utils.Timer;

        public var btnClose:flash.display.SimpleButton;

        public var title:flash.text.TextField;
    }
}
