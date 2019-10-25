package MyLife.Interfaces 
{
    import MyLife.*;
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    
    public class SelectPlayer extends flash.display.MovieClip
    {
        public function SelectPlayer()
        {
            super();
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function selectPlayer(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget.parent.playerOffset;
            loc3 = arg1.currentTarget.parent.playerRecord.playerId;
            dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAYER_SELECTED, {"playerId":loc3, "selectPlayerInterface":this}, false));
            return;
        }

        private function createNewPlayer(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("CreateNewPlayerStep1", {"showCancel":true});
            TweenLite.to(loc2, 0.75, {"alpha":1, "onComplete":unloadInterface, "onCompleteParams":[this]});
            loc2.alpha = 0;
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            playerSelectionList = [playerSelect1, playerSelect2, playerSelect3];
            this.addEventListener(MyLifeEvent.PLAYER_SELECTED, _myLife.onPlayerSelected);
            resetPlayerProfiles();
            return;
        }

        private function deletePlayerConfirmStep1(arg1:Object):*
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("GenericDialog", {"metaData":arg1, "title":"Are You Sure You Want To Continue?", "message":"Are you sure you want to delete your player named \'" + arg1.name + "\'?", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, deletePlayerConfirmStep2);
            bounceClipInViaY(loc2);
            return;
        }

        private function deletePlayerConfirmStep3(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = arg1.eventData.metaData;
            if (arg1.eventData.userResponse != "BTN_YES")
            {
            };
            return;
        }

        private function deletePlayerConfirmStep2(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = arg1.eventData.metaData;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc3 = _myLife._interface.showInterface("GenericDialog", {"metaData":loc2, "title":"THIS CANNOT BE UNDONE!", "message":"PLAYER DELETIONS ARE PERMANENT AND CANNOT BE UNDONE. ARE YOU SURE YOU WANT TO DELETE YOUR PLAYER NAMED \'" + loc2.name + "\'?", "buttons":[{"name":"Yes I am Sure", "value":"BTN_YES"}, {"name":"NO DON\'T DELETE", "value":"BTN_NO"}]});
                loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, deletePlayerConfirmStep3);
                bounceClipInViaY(loc3);
            }
            return;
        }

        private function resetPlayerProfiles():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc4 = undefined;
            loc1 = 0;
            loc3 = getPlayersJSONObj();
            loc5 = 0;
            loc6 = loc3;
            for each (loc4 in loc6)
            {
                loc2 = playerSelectionList[loc1];
                loc2.activePlayer = true;
                loc2.playerName.text = "Loading...";
                loc2.money.text = "";
                loc2.playerOffset = loc1;
                loc2.playerRecord = loc4;
                loc2.gender = loc4.gender;
                loc2.playerClothes = loc4.clothes;
                ++loc1;
            }
            loc5 = 0;
            loc6 = playerSelectionList;
            for each (loc2 in loc6)
            {
                loc2.hitZone.visible = false;
                loc2.hitZoneCreateNew.visible = false;
                if (!loc2.activePlayer)
                {
                    loc2.playerName.text = "Create A New Player";
                    loc2.money.text = "";
                    loc2.avatarPreview.visible = false;
                    loc2.removeChild(loc2.deletePlayerButton);
                    loc2.hitZoneCreateNew.addEventListener(MouseEvent.CLICK, createNewPlayer);
                    loc2.hitZoneCreateNew.visible = true;
                    continue;
                }
                loc2.removeChild(loc2.ClickHereNewPlayerText);
                loc2.deletePlayerButton.visible = false;
            }
            selectPlayerRollZone.addEventListener(MouseEvent.MOUSE_OVER, hideDeletePlayerButton);
            return;
        }

        private function showDeletePlayerButton(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.target.parent;
            if (_lastPlayerHighlighted && _lastPlayerHighlighted.deletePlayerButton)
            {
                _lastPlayerHighlighted.deletePlayerButton.visible = false;
            }
            if (loc2.deletePlayerButton)
            {
                _lastPlayerHighlighted = loc2;
                loc2.deletePlayerButton.visible = true;
            }
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private function hideDeletePlayerButton(arg1:flash.events.MouseEvent):*
        {
            if (_lastPlayerHighlighted && _lastPlayerHighlighted.deletePlayerButton)
            {
                _lastPlayerHighlighted.deletePlayerButton.visible = false;
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

        private function loadAvatarPreview(arg1:flash.display.MovieClip):*
        {
            var loc2:*;

            loc2 = _myLife.assetsLoader.newAvatarInstance();
            arg1.hitZone.visible = true;
            arg1.avatarPreview.LoadingAnimation.visible = false;
            arg1.avatarPreview.addChild(loc2);
            arg1.previewClip = loc2;
            arg1.previewClip.initAvatar(arg1.gender, 0.38);
            arg1.previewClip.setAvatarClothes(arg1.playerClothes);
            arg1.previewClip.renderAvatarAction(1);
            arg1.previewClip.x = 0;
            arg1.previewClip.y = 100;
            return;
        }

        public function loadPlayerProfiles():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = undefined;
            loc4 = undefined;
            loc1 = getPlayersJSONObj();
            loc2 = 0;
            loc5 = 0;
            loc6 = playerSelectionList;
            for each (loc4 in loc6)
            {
                if (loc4.activePlayer)
                {
                    loc4.hitZone.addEventListener(MouseEvent.CLICK, selectPlayer);
                    loc4.deletePlayerButton.addEventListener(MouseEvent.CLICK, deletePlayerClick);
                    loc4.hitZone.visible = false;
                }
                loc4.hitZone.addEventListener(MouseEvent.MOUSE_OVER, showDeletePlayerButton);
            }
            loc5 = 0;
            loc6 = loc1;
            for each (loc3 in loc6)
            {
                loc4 = playerSelectionList[loc2];
                loadAvatarPreview(loc4);
                loc4.playerName.text = loc4.playerRecord.name;
                loc4.money.text = "$" + loc4.playerRecord.money;
                ++loc2;
            }
            return;
        }

        private function getPlayersJSONObj():Object
        {
            var loc1:*;

            loc1 = null;
            loc1 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["playersJSON"]);
            return loc1;
        }

        private function deletePlayerClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.target.parent.playerRecord.playerId;
            deletePlayerConfirmStep1(arg1.target.parent.playerRecord);
            return;
        }

        public var playerSelect1:flash.display.MovieClip;

        public var playerSelect2:flash.display.MovieClip;

        public var playerSelect3:flash.display.MovieClip;

        public var selectPlayerRollZone:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;

        private var playerSelectionList:Array;

        private var _lastPlayerHighlighted:flash.display.MovieClip;
    }
}
