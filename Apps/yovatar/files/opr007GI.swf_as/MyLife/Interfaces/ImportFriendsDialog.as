package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Components.*;
    import fl.controls.*;
    import fl.controls.dataGridClasses.*;
    import fl.data.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class ImportFriendsDialog extends flash.display.MovieClip
    {
        public function ImportFriendsDialog()
        {
            super();
            friendsDG = new DataGrid();
            friendsDG.width = 350;
            friendsDG.height = 180;
            friendsDG.x = 135;
            friendsDG.y = 218;
            addChild(friendsDG);
            cancelImportFriendsButton.addEventListener(MouseEvent.CLICK, cancelImportFriendsButtonClick);
            addFriendsButton.addEventListener(MouseEvent.CLICK, addFriendsButtonClick);
            return;
        }

        private function cancelImportFriendsButtonClick(arg1:flash.events.MouseEvent):void
        {
            friendsDG.removeAll();
            friendsDG.removeAllColumns();
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[this]});
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        public function exportFriendsErrorHandler(arg1:flash.events.IOErrorEvent):Boolean
        {
            var loc2:*;

            trace("exportFriendsErrorHandler: Error Exporting Friends!");
            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"ERROR: Export Facebook Friends", "message":"We encountered a problem while exporting your Facebook friends.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            return false;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            friendsArray = new Array();
            this.initTextFields();
            return;
        }

        public function addFriendsButtonClick(arg1:flash.events.MouseEvent):*
        {
            if (friendsArray.length > 0)
            {
                exportFriendsToServer();
                friendsDG.removeAll();
                friendsDG.removeAllColumns();
                addFriendsButton.alpha = 0.5;
                addFriendsButton.mouseEnabled = false;
                TweenLite.to(this, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[this]});
            }
            else 
            {
                mesgTxt.htmlText = "<font color=\'#FF0000\'>Please select a friend and try again!</font>";
            }
            return;
        }

        public function isFriendSelected(arg1:Number):Number
        {
            var loc2:*;
            var loc3:*;

            loc2 = -1;
            loc3 = 0;
            while (loc3 < friendsArray.length) 
            {
                if (friendsArray[loc3] == arg1)
                {
                    loc2 = loc3;
                    break;
                }
                ++loc3;
            }
            return loc2;
        }

        public function exportFriendsCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc2 = null;
            loc3 = null;
            loc9 = null;
            trace("exportFriendsCompleteHandler()");
            loc4 = _myLife.getConfiguration();
            loc5 = MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
            loc6 = _myLife.getPlayer()._playerId;
            loc7 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["canvas_path"];
            loc8 = MyLifeInstance.getInstance().zone._zoneName;
            loc10 = loc4.platformType;
            switch (loc10) 
            {
                case "platformFacebook":
                    loc2 = loc7 + "index.php?autologin=1&i=" + loc5 + "&d=" + loc8;
                    loc3 = "_parent";
                    break;
                case "platformMySpace":
                    loc2 = "http://profile.myspace.com/Modules/Applications/Pages/Canvas.aspx?appId=111238";
                    loc3 = "_top";
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc9 = new RegExp("fb", "g");
                    loc2 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
                    loc2 = loc2.replace(loc9, "tg");
                    loc2 = loc2 + "tagged_redirect.php";
                    loc2 = loc2 + "?autologin=1&i=" + loc5 + "&d=" + loc8;
                    loc3 = "_top";
                    break;
            }
            if (_myLife)
            {
                _myLife.navigateToURL(loc2, loc3);
            }
            return;
        }

        public function onFriendsListClick(arg1:flash.events.Event):void
        {
            var loc2:*;

            trace("onFriendsListClick: " + arg1.target.selectedItem.PLAYER_ID);
            loc2 = isFriendSelected(arg1.target.selectedItem.PLAYER_ID);
            if (arg1.target.selectedItem.FLAG != true)
            {
                if (loc2 != -1)
                {
                    trace("unselect");
                    friendsArray.splice(loc2, 1);
                }
            }
            else 
            {
                if (loc2 == -1)
                {
                    trace("select");
                    friendsArray.push(arg1.target.selectedItem.PLAYER_ID);
                }
            }
            mesgTxt.htmlText = "<font color=\'#000000\'>Adding friends to your buddy list will refresh this page.</font>";
            trace("friends: " + friendsArray.toString());
            return;
        }

        private function initTextFields():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = _myLife.getConfiguration();
            loc3 = loc2.platformType;
            switch (loc3) 
            {
                case "platformFacebook":
                    loc1 = "Import your Facebook friends with YoVille to your buddy list!";
                    break;
                case "platformMySpace":
                    loc1 = "Import your MySpace friends with YoVille to your buddy list!";
                    break;
                case loc2.PLATFORM_TAGGED:
                    loc1 = "Import your Tagged friends with YoVille to your buddy list!";
                    break;
            }
            this.instructionsTextField.text = loc1;
            return;
        }

        public function displayFriends(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = null;
            loc8 = null;
            loc2 = new DataGridColumn("FLAG");
            loc2.headerText = "FLAG";
            loc2.sortable = false;
            loc2.sortOptions = Array.CASEINSENSITIVE;
            loc2.visible = false;
            loc3 = new DataGridColumn("NAME");
            loc3.headerText = "Select Your Friends";
            loc3.sortable = false;
            loc3.sortOptions = Array.CASEINSENSITIVE;
            loc3.cellRenderer = CustomCheckBoxCellRenderer;
            (loc4 = new DataGridColumn("FACEBOOK_ID")).headerText = "FACEBOOK_ID";
            loc4.sortable = false;
            loc4.sortOptions = Array.CASEINSENSITIVE;
            loc4.visible = false;
            (loc5 = new DataGridColumn("PLAYER_ID")).headerText = "PLAYER_ID";
            loc5.sortable = false;
            loc5.sortOptions = Array.CASEINSENSITIVE;
            loc5.visible = false;
            friendsDG.removeAll();
            friendsDG.removeAllColumns();
            friendsDG.addColumn(loc2);
            friendsDG.addColumn(loc3);
            friendsDG.addColumn(loc4);
            friendsDG.addColumn(loc5);
            friendsDG.showHeaders = true;
            friendsDG.getColumnAt(1).editable = false;
            friendsDG.editable = false;
            friendsDG.dataProvider = new DataProvider();
            loc6 = 1;
            while (loc6 < arg1.length) 
            {
                loc8 = (loc7 = arg1[loc6]).first_name + " " + loc7.last_name + " (" + loc7.name + ")";
                friendsDG.dataProvider.addItem({"NAME":loc8, "FACEBOOK_ID":loc7.facebook_id, "PLAYER_ID":loc7.player_id, "FLAG":false});
                ++loc6;
            }
            friendsDG.addEventListener(Event.CHANGE, onFriendsListClick);
            friendsDG.invalidate();
            friendsArray.splice(0);
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        private function hideMovieClip(arg1:*):void
        {
            arg1.visible = false;
            return;
        }

        public function exportFriendsToServer():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_server"];
            loc2 = loc1 + "buddy_import_post.php?r=" + Math.random();
            trace("EXPORT URL: " + loc2);
            loc3 = new URLVariables();
            loc3.playerId = _myLife.getPlayer()._playerId;
            loc3.friends = friendsArray.toString();
            (loc4 = new URLRequest(loc2)).method = URLRequestMethod.POST;
            loc4.data = loc3;
            (loc5 = new URLLoader()).addEventListener(Event.COMPLETE, exportFriendsCompleteHandler);
            loc5.addEventListener(IOErrorEvent.IO_ERROR, exportFriendsErrorHandler);
            loc5.load(loc4);
            return;
        }

        public var friendsArray:Array;

        public var addFriendsButton:flash.display.SimpleButton;

        private var friendsDG:fl.controls.DataGrid;

        public var mesgTxt:flash.text.TextField;

        private var _myLife:flash.display.MovieClip;

        public var instructionsTextField:flash.text.TextField;

        public var cancelImportFriendsButton:flash.display.SimpleButton;
    }
}
