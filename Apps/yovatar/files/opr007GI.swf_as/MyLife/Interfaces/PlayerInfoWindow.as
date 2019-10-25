package MyLife.Interfaces 
{
    import MyLife.*;
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class PlayerInfoWindow extends flash.display.MovieClip
    {
        public function PlayerInfoWindow()
        {
            dragMouseOffset = [0, (0)];
            initPlayerObject = {};
            super();
            return;
        }

        private function rotateAvatarRightClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = avatarPreview.previewClip.getDirection();
            loc3 = loc2;
            if (loc2 != MyLifeInstance.LEFT_FRONT)
            {
                if (loc2 != MyLifeInstance.RIGHT_FRONT)
                {
                    if (loc2 != MyLifeInstance.RIGHT_BACK)
                    {
                        loc3 = MyLifeInstance.LEFT_FRONT;
                    }
                    else 
                    {
                        loc3 = MyLifeInstance.LEFT_BACK;
                    }
                }
                else 
                {
                    loc3 = MyLifeInstance.RIGHT_BACK;
                }
            }
            else 
            {
                loc3 = MyLifeInstance.RIGHT_FRONT;
            }
            setNewAvatarAction(loc3);
            return;
        }

        private function getPlayerInfoSecurityError(arg1:flash.events.SecurityErrorEvent):void
        {
            var loc2:*;

            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Security Error Event", "message":"You are not allowed to access a url outside the sandbox.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            return;
        }

        private function onFinishNewAvatarBlur():void
        {
            _rotating = false;
            return;
        }

        private function rotateAvatarLeftClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = avatarPreview.previewClip.getDirection();
            loc3 = loc2;
            if (loc2 != MyLifeInstance.LEFT_FRONT)
            {
                if (loc2 != MyLifeInstance.LEFT_BACK)
                {
                    if (loc2 != MyLifeInstance.RIGHT_BACK)
                    {
                        loc3 = MyLifeInstance.LEFT_FRONT;
                    }
                    else 
                    {
                        loc3 = MyLifeInstance.RIGHT_FRONT;
                    }
                }
                else 
                {
                    loc3 = MyLifeInstance.RIGHT_BACK;
                }
            }
            else 
            {
                loc3 = MyLifeInstance.LEFT_BACK;
            }
            setNewAvatarAction(loc3);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            initPlayerObject = MyLifeUtils.cloneObject(arg2);
            playerId = initPlayerObject.selectedPlayerId;
            playerGender = initPlayerObject.selectedGender;
            playerName = initPlayerObject.selectedName;
            playerClothing = initPlayerObject.selectedClothes;
            playerLevel = initPlayerObject.selectedLevel;
            PlayerNameTxt.text = playerName;
            PlayerInfoTxt.text = "";
            levelTxt.text = "Level " + playerLevel;
            initEventListeners();
            getPlayerInfoFromServer();
            return;
        }

        private function getPlayerInfoFromServer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = null;
            loc3 = null;
            loc1 = "player_info.php?player_id=" + playerId;
            if (_myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"])
            {
                loc2 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"]);
                loc8 = 0;
                loc9 = loc2;
                for (loc3 in loc9)
                {
                    loc1 = loc1 + "&" + loc3 + "=" + loc2[loc3];
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"])
            {
                loc2 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"]);
                loc8 = 0;
                loc9 = loc2;
                for (loc3 in loc9)
                {
                    loc1 = loc1 + "&" + loc3 + "=" + loc2[loc3];
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"])
            {
                loc2 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"]);
                loc8 = 0;
                loc9 = loc2;
                for (loc3 in loc9)
                {
                    loc1 = loc1 + "&" + loc3 + "=" + loc2[loc3];
                }
            }
            loc5 = (loc4 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"]) + loc1;
            trace("PLAYER INFO URL: " + loc5);
            loc6 = new URLRequest(loc5);
            (loc7 = new URLLoader()).addEventListener(Event.COMPLETE, getPlayerInfoComplete);
            loc7.addEventListener(IOErrorEvent.IO_ERROR, getPlayerInfoError);
            loc7.addEventListener(SecurityErrorEvent.SECURITY_ERROR, getPlayerInfoSecurityError);
            loc7.load(loc6);
            return;
        }

        public function setCharacterInstance(arg1:MyLife.Character):void
        {
            character = arg1;
            return;
        }

        private function onStageMouseUp(arg1:flash.events.MouseEvent):void
        {
            arg1.stopPropagation();
            windowDragMode = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onWindowStartDrag);
            return;
        }

        private function onWindowStartDrag(arg1:flash.events.MouseEvent):void
        {
            windowDragMode = true;
            dragMouseOffset = [stage.mouseX - this.x, stage.mouseY - this.y];
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onWindowStartDrag);
            stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
            return;
        }

        public function hide():void
        {
            _myLife.debug("Hide View Player Info");
            MovieClip(this).visible = false;
            return;
        }

        private function onFinishAvatarBlur(arg1:int):void
        {
            avatarPreview.previewClip.changeDirection(arg1);
            TweenFilterLite.to(avatarPreview.previewClip, 0.15, {"type":"Blur", "blurX":0, "quality":2, "onComplete":onFinishNewAvatarBlur});
            return;
        }

        private function getPlayerInfoError(arg1:flash.events.IOErrorEvent):Boolean
        {
            trace("getPlayerInfoError: Error Retrieving Player Info!");
            PlayerInfoTxt.text = "";
            return false;
        }

        private function closeButtonClick(arg1:flash.events.MouseEvent):void
        {
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        public function loadAvatarPreview():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = _myLife.assetsLoader.newAvatarInstance();
            avatarPreview.addChild(loc1);
            avatarPreview.previewClip = loc1;
            loc2 = 0.45;
            avatarPreview.previewClip.x = 75;
            avatarPreview.previewClip.y = 250;
            avatarPreview.previewClip.initAvatar(playerGender, loc2);
            avatarPreview.previewClip.renderClothes(playerClothing);
            avatarPreview.previewClip.doAvatarAction(0);
            loc1.visible = true;
            avatarPreview.LoadingAnimation.visible = false;
            return;
        }

        private function setNewAvatarAction(arg1:int):void
        {
            if (_rotating)
            {
                return;
            }
            _rotating = true;
            TweenFilterLite.to(avatarPreview.previewClip, 0.15, {"type":"Blur", "blurX":25, "quality":2, "onComplete":onFinishAvatarBlur, "onCompleteParams":[arg1]});
            return;
        }

        private function initEventListeners():void
        {
            windowDragMode = false;
            closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);
            RotatePlayerControlSet.rotateRight.addEventListener(MouseEvent.CLICK, rotateAvatarRightClick);
            RotatePlayerControlSet.rotateLeft.addEventListener(MouseEvent.CLICK, rotateAvatarLeftClick);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onWindowStartDrag);
            this.buttonMode = true;
            this.useHandCursor = true;
            return;
        }

        private function onStageMouseMove(arg1:flash.events.MouseEvent):void
        {
            this.x = stage.mouseX - dragMouseOffset[0];
            this.y = stage.mouseY - dragMouseOffset[1];
            if (this.x < MIN_X)
            {
                this.x = MIN_X;
            }
            if (this.y < MIN_Y)
            {
                this.y = MIN_Y;
            }
            if (this.x > MAX_X - this.width)
            {
                this.x = MAX_X - this.width;
            }
            if (this.y > MAX_Y - this.height)
            {
                this.y = MAX_Y - this.height;
            }
            arg1.stopPropagation();
            arg1.updateAfterEvent();
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            character.resetPopupCollection();
            return;
        }

        public function show():void
        {
            _myLife.debug("Show View Player Info");
            MovieClip(this).visible = true;
            return;
        }

        private function getPlayerInfoComplete(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            trace("getPlayerInfoComplete() json = " + arg1.target.data);
            PlayerInfoTxt.text = "";
            if (arg1.target.data.length > 0)
            {
                loc2 = JSON.decode(arg1.target.data);
                loc3 = loc2[0];
                if (loc3.result == 1)
                {
                    PlayerInfoTxt.text = loc2[1].description;
                }
            }
            return;
        }

        private const MIN_X:int=0;

        private const MIN_Y:int=86;

        private const MAX_X:int=641;

        private const MAX_Y:int=541;

        public var playerGender:int;

        private var windowDragMode:Boolean=false;

        public var playerClothing:Array;

        public var playerName:String="";

        public var RotatePlayerControlSet:flash.display.MovieClip;

        public var playerLevel:int;

        public var PlayerNameTxt:flash.text.TextField;

        public var PlayerInfoTxt:flash.text.TextField;

        public var character:MyLife.Character;

        public var avatarPreview:flash.display.MovieClip;

        private var initPlayerObject:Object;

        private var _rotating:Boolean=false;

        private var dragMouseOffset:Array;

        public var closeButton:flash.display.SimpleButton;

        public var levelTxt:flash.text.TextField;

        public var playerId:String="";

        private var _myLife:flash.display.MovieClip;
    }
}
