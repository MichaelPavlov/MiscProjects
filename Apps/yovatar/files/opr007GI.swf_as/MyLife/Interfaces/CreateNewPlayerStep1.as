package MyLife.Interfaces 
{
    import MyLife.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class CreateNewPlayerStep1 extends flash.display.MovieClip
    {
        public function CreateNewPlayerStep1()
        {
            super();
            trace("CreateNewPlayerStep1 Class Initialized");
            setupGenderSelector(select_female, 1);
            setupGenderSelector(select_male, 2);
            inputNameBox.gotoAndStop(1);
            selectGenderErrorOutline.visible = false;
            cancelButton.addEventListener(MouseEvent.CLICK, cancelCreateNewPlayer);
            nextButton.addEventListener(MouseEvent.CLICK, gotoCreateNewPlayerNextStep);
            nameInput.addEventListener(FocusEvent.FOCUS_IN, nameInputFocusIn);
            nameInput.addEventListener(FocusEvent.FOCUS_OUT, nameInputFocusOut);
            nameInput.addEventListener(TextEvent.TEXT_INPUT, nameInputUpdated);
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        public function hide():void
        {
            _myLife.debug("Hide CreateNewPlayerStep1");
            MovieClip(this).visible = false;
            return;
        }

        private function nameInputUpdated(arg1:flash.events.TextEvent):*
        {
            inputNameBox.gotoAndStop(1);
            return;
        }

        private function showCreateStep2(arg1:flash.display.MovieClip, arg2:*):*
        {
            unloadInterface(arg1);
            arg2.loadAvatarPreview();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            if (arg2.showCancel)
            {
                cancelButton.visible = true;
            }
            else 
            {
                cancelButton.visible = false;
            }
            if (arg2.nameSelected)
            {
                nameInput.text = arg2.nameSelected;
            }
            if (arg2.selectedGender)
            {
                selectNewGender(arg2.selectedGender);
            }
            playerParams = arg2;
            return;
        }

        private function setupGenderSelector(arg1:flash.display.MovieClip, arg2:int):*
        {
            arg1.gotoAndStop((arg2 - 1) * 2 + 1);
            arg1._gender = arg2;
            arg1.buttonMode = true;
            arg1.useHandCursor = true;
            arg1.addEventListener(MouseEvent.CLICK, selectNewGenderClick);
            return;
        }

        private function onNextStepConfirmed():*
        {
            var loc1:*;

            playerParams.showCancel = cancelButton.visible;
            playerParams.nameSelected = StringUtils.trim(nameInput.text);
            if (selectedGender != playerParams.selectedGender)
            {
                playerParams.currentClothes = null;
                playerParams.clothingSet = false;
                playerParams.appearanceSet = false;
            }
            if (FIRST_SHOW == true)
            {
                FIRST_SHOW = false;
                trace("tracking proceed to change appaerance");
                if (_myLife.myLifeConfiguration.platformType != "platformFacebook")
                {
                    this._myLife.linkTracker.track("2036", "1372");
                }
                else 
                {
                    this._myLife.linkTracker.track("1537", "1479");
                }
            }
            playerParams.selectedGender = selectedGender;
            playerParams.nextStep = 2;
            loc1 = _myLife._interface.showInterface("CreateNewPlayerStep2", playerParams);
            loc1.x = -loc1.width;
            this.visible = false;
            TweenLite.to(loc1, 0.75, {"x":0, "ease":Back.easeOut, "onComplete":showCreateStep2, "onCompleteParams":[this, loc1]});
            nextButton.enabled = false;
            nextButton.mouseEnabled = false;
            return;
        }

        private function confirmCancelDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = _myLife._interface.showInterface("SelectPlayer", {});
                TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
                TweenLite.to(loc2, 0.75, {"alpha":1});
                loc2.alpha = 0;
                loc2.loadPlayerProfiles();
            }
            return;
        }

        private function nameInputFocusIn(arg1:flash.events.FocusEvent):*
        {
            var loc2:*;

            loc2 = StringUtils.trim(nameInput.text);
            if (loc2 == DEFAULT_NAME)
            {
                nameInput.text = "";
            }
            return;
        }

        private function gotoCreateNewPlayerNextStep(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc4 = null;
            loc5 = null;
            loc3 = StringUtils.trim(nameInput.text);
            if (loc3 == DEFAULT_NAME)
            {
                loc3 = "";
            }
            if (loc3 == "")
            {
                inputNameBox.gotoAndStop(2);
                loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Please Fix The Following Problem", "message":"Please select a name for your new player."});
                bounceClipInViaY(loc2);
                return;
            }
            inputNameBox.gotoAndStop(1);
            if (selectedGender == 0)
            {
                selectGenderErrorOutline.visible = true;
                loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Please Fix The Following Problem", "message":"Please select a gender for your new player."});
                bounceClipInViaY(loc2);
                return;
            }
            if (!(selectedGender == playerParams.selectedGender) && (playerParams.appearanceSet == true || playerParams.clothingSet == true))
            {
                loc4 = [{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}];
                (loc5 = _myLife._interface.showInterface("GenericDialog", {"title":"Confirm Gender Change", "message":"If you change your player\'s gender you will lose all your changes so far. Do you want to continue?", "buttons":loc4})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, onConfirmGenderChangeResponse);
                return;
            }
            onNextStepConfirmed();
            return;
        }

        private function selectNewGenderClick(arg1:flash.events.MouseEvent):*
        {
            if (_myLife.myLifeConfiguration.platformType != "platformFacebook")
            {
                this._myLife.linkTracker.track("2035", "1372");
            }
            else 
            {
                this._myLife.linkTracker.track("1536", "1479");
            }
            selectNewGender(arg1.currentTarget._gender);
            return;
        }

        private function cancelCreateNewPlayer(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Are You Sure You Want To Cancel?", "message":"Are you sure you want to discard the changes you have made?", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmCancelDialogResponse);
            bounceClipInViaY(loc2);
            return;
        }

        private function selectNewGender(arg1:int):*
        {
            selectGenderErrorOutline.visible = false;
            selectedGender = arg1;
            if (arg1 != 1)
            {
                if (arg1 == 2)
                {
                    select_female.gotoAndStop(1);
                    select_male.gotoAndStop(4);
                }
            }
            else 
            {
                select_female.gotoAndStop(2);
                select_male.gotoAndStop(3);
            }
            return;
        }

        private function nameInputFocusOut(arg1:flash.events.FocusEvent):*
        {
            var loc2:*;

            loc2 = StringUtils.trim(nameInput.text);
            if (loc2 == "")
            {
                nameInput.text = DEFAULT_NAME;
            }
            return;
        }

        private function bounceClipInViaY(arg1:flash.display.MovieClip):*
        {
            TweenLite.to(arg1, 0.75, {"alpha":1, "y":arg1.y, "ease":Bounce.easeOut});
            arg1.alpha = 0;
            arg1.y = -arg1.height;
            return;
        }

        private function onConfirmGenderChangeResponse(arg1:MyLife.MyLifeEvent):*
        {
            var loc2:*;

            loc2 = arg1.eventData.userResponse;
            if (loc2 != "BTN_YES")
            {
                if (loc2 == "BTN_NO")
                {
                    if (selectedGender != 1)
                    {
                        selectNewGender(1);
                    }
                    else 
                    {
                        selectNewGender(2);
                    }
                }
            }
            else 
            {
                onNextStepConfirmed();
            }
            return;
        }

        public function show():void
        {
            _myLife.debug("Show CreateNewPlayerStep1");
            MovieClip(this).visible = true;
            return;
        }

        
        {
            FIRST_SHOW = true;
        }

        private const DEFAULT_NAME:String="Enter Player Name";

        public var nextButton:flash.display.SimpleButton;

        private var playerParams:Object;

        public var cancelButton:flash.display.SimpleButton;

        public var inputNameBox:flash.display.MovieClip;

        public var selectGenderErrorOutline:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        public var select_female:flash.display.MovieClip;

        public var select_male:flash.display.MovieClip;

        private var selectedGender:int=0;

        public var nameInput:flash.text.TextField;

        private static var FIRST_SHOW:Boolean=true;
    }
}
