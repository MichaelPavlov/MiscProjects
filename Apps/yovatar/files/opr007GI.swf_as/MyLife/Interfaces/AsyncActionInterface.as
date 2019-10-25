package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class AsyncActionInterface extends MyLife.Interfaces.TweenButtonDialog
    {
        public function AsyncActionInterface()
        {
            super();
            return;
        }

        private function exitButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.closeWindow();
            this.dispatchEvent(new Event(Event.CANCEL));
            return;
        }

        private function danceButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_DANCE;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        public function closeWindow():void
        {
            this.removeListeners();
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        public function get currentSelectedAction():String
        {
            return this._currentSelectedAction;
        }

        private function messageButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_MESSAGE;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        private function giftButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_GIFT;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        private function removeListeners():void
        {
            helpButton.removeEventListener(MouseEvent.MOUSE_OVER, helpButtonMouseOverHandler);
            helpButton.removeEventListener(MouseEvent.MOUSE_OUT, helpButtonMouseOutHandler);
            fightButton.removeEventListener(MouseEvent.CLICK, fightButtonClickHandler);
            danceButton.removeEventListener(MouseEvent.CLICK, danceButtonClickHandler);
            messageButton.removeEventListener(MouseEvent.CLICK, messageButtonClickHandler);
            giftButton.removeEventListener(MouseEvent.CLICK, giftButtonClickHandler);
            kissButton.removeEventListener(MouseEvent.CLICK, kissButtonClickHandler);
            jokeButton.removeEventListener(MouseEvent.CLICK, jokeButtonClickHandler);
            exitButton.removeEventListener(MouseEvent.CLICK, exitButtonClickHandler);
            removeButtonListeners(fightButton);
            removeButtonListeners(danceButton);
            removeButtonListeners(messageButton);
            removeButtonListeners(giftButton);
            removeButtonListeners(kissButton);
            removeButtonListeners(jokeButton);
            return;
        }

        private function helpButtonMouseOutHandler(arg1:flash.events.MouseEvent):void
        {
            this.helpPanel.visible = false;
            return;
        }

        private function addListeners():void
        {
            this.helpButton.addEventListener(MouseEvent.MOUSE_OVER, helpButtonMouseOverHandler, false, 0, true);
            this.helpButton.addEventListener(MouseEvent.MOUSE_OUT, helpButtonMouseOutHandler, false, 0, true);
            fightButton.addEventListener(MouseEvent.CLICK, fightButtonClickHandler, false, 0, true);
            addButtonListeners(fightButton);
            danceButton.addEventListener(MouseEvent.CLICK, danceButtonClickHandler, false, 0, true);
            addButtonListeners(danceButton);
            messageButton.addEventListener(MouseEvent.CLICK, messageButtonClickHandler, false, 0, true);
            addButtonListeners(messageButton);
            kissButton.addEventListener(MouseEvent.CLICK, kissButtonClickHandler, false, 0, true);
            addButtonListeners(kissButton);
            jokeButton.addEventListener(MouseEvent.CLICK, jokeButtonClickHandler, false, 0, true);
            addButtonListeners(jokeButton);
            exitButton.addEventListener(MouseEvent.CLICK, exitButtonClickHandler, false, 0, true);
            if (giftButton.alpha == 1)
            {
                giftButton.addEventListener(MouseEvent.CLICK, giftButtonClickHandler, false, 0, true);
                addButtonListeners(giftButton);
            }
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            _myLife.addChild(this);
            playerId = arg2["playerId"];
            if (arg2)
            {
                if (arg2.clothing)
                {
                    this.createAvatarInstance(arg2.clothing);
                }
                if (arg2.name)
                {
                    this.titleTextField.text = "What Would You Like To Do With " + arg2.name + "?";
                }
            }
            this.helpPanel.visible = false;
            this.addListeners();
            this.hide();
            return;
        }

        private function kissButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_KISS;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        private function helpButtonMouseOverHandler(arg1:flash.events.MouseEvent):void
        {
            this.helpPanel.visible = true;
            return;
        }

        private function fightButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_FIGHT;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        private function jokeButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this._currentSelectedAction = ACTION_JOKE;
            this.dispatchEvent(new Event(this.EVENT_ACTION_BUTTON_CLICK));
            return;
        }

        private function createAvatarInstance(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            trace("createAvatarInstance()");
            loc2 = 0.45;
            loc3 = 0;
            loc4 = 60;
            loc5 = "MyLife.Assets.Avatar.Avatar";
            loc7 = new (loc6 = getDefinitionByName(loc5) as Class)();
            this.avatarHeadContainer.addChild(loc7);
            loc7.initAvatar(0, 1);
            loc7.renderClothes(arg1);
            loc7.doAvatarAction("0");
            loc7.visible = true;
            loc8 = loc7.getChildAt(0)["head"];
            loc8.scaleY = loc9 = loc2;
            loc8.scaleX = loc9;
            this.avatarHeadContainer.removeChild(loc7);
            this.avatarHeadContainer.addChild(loc8);
            loc8.x = loc3;
            loc8.y = loc4;
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            dispatchEvent(new Event(Event.CLOSE));
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        public function show():void
        {
            this.visible = true;
            this.alpha = 0;
            TweenLite.to(this, 1, {"alpha":1});
            return;
        }

        public const EVENT_ACTION_BUTTON_CLICK:String="actionButtonClick";

        public static const ACTION_KISS:String="kiss";

        public static const ACTION_JOKE:String="joke";

        public static const ACTION_DANCE:String="dance";

        public static const ACTION_FIGHT:String="fight";

        public static const ACTION_GIFT:String="gift";

        public static const ACTION_MESSAGE:String="message";

        public var giftButton:flash.display.SimpleButton;

        public var helpPanel:flash.display.MovieClip;

        public var danceButton:flash.display.SimpleButton;

        public var kissButton:flash.display.SimpleButton;

        private var _currentSelectedAction:String;

        public var helpButton:flash.display.SimpleButton;

        public var titleTextField:flash.text.TextField;

        public var messageButton:flash.display.SimpleButton;

        public var playerId:Number=-1;

        public var fightButton:flash.display.SimpleButton;

        public var avatarHeadContainer:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        public var exitButton:flash.display.SimpleButton;

        public var jokeButton:flash.display.SimpleButton;
    }
}
