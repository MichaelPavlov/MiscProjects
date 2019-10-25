package MyLife.Interfaces 
{
    import MyLife.*;
    import com.adobe.serialization.json.*;
    import fl.containers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class BuddyListViewer extends flash.display.MovieClip
    {
        public function BuddyListViewer()
        {
            var loc1:*;
            var loc2:*;

            buddyListCollection = [];
            super();
            this.initTextFields();
            this.blockedPlayerIds = [];
            btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick);
            btnImport.addEventListener(MouseEvent.CLICK, btnImportClickHandler);
            try
            {
                MyLifeInstance.getInstance().getServer().addEventListener(MyLifeEvent.BUDDYLIST_UPDATE, onUpdateBuddyListEvent);
            }
            catch (error:Error)
            {
                trace("BuddyListViewer() error=" + undefined);
            }
            buddyListNoBuddies.visible = true;
            addListContainerToScrollPane();
            updateBuddyList([]);
            pollServerTimer = new Timer(POLL_SERVER_INTERVAL);
            pollServerTimer.addEventListener("timer", pollServerTimerTick);
            return;
        }

        private function pollServerTimerTick(arg1:flash.events.TimerEvent):void
        {
            MyLifeInstance.getInstance().getServer().callExtension("getBuddyListUpdates", {});
            return;
        }

        private function disableButton(arg1:*, arg2:Boolean):void
        {
            arg1.mouseEnabled = !arg2;
            arg1.alpha = arg2 ? 0.3 : 1;
            return;
        }

        private function importFriendsError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = null;
            trace("importFriendsError: Error Importing Friends!");
            loc4 = MyLifeInstance.getInstance().getConfiguration();
            loc6 = loc4.platformType;
            switch (loc6) 
            {
                case "platformFacebook":
                    loc2 = "Import Facebook Friends";
                    loc3 = "We encountered a problem while importing your Facebook friends.";
                    break;
                case "platformMySpace":
                    loc2 = "Import MySpace Friends";
                    loc3 = "We encountered a problem while importing your MySpace friends.";
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc2 = "Import Tagged Friends";
                    loc3 = "We encountered a problem while importing your Tagged friends.";
                    break;
            }
            loc5 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc2, "message":loc3 + " Error Code 03.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            return;
        }

        private function btnBuddyVisitHomeClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget.parent.buddyObj;
            this.visible = false;
            MyLifeInstance.getInstance()._interface.showInterface("ViewHomes", {"playerId":loc2.buddyId});
            return;
        }

        public function addBlockedPlayer(arg1:*):void
        {
            var loc2:*;

            arg1 = String(arg1);
            loc2 = this.blockedPlayerIds.indexOf(arg1);
            if (loc2 < 0)
            {
                this.blockedPlayerIds.push(arg1);
            }
            MyLifeInstance.getInstance().server.callExtension("blockBuddy", {"playerId":arg1});
            return;
        }

        public function checkIfPlayerBlocked(arg1:*):Boolean
        {
            var loc2:*;
            var loc3:*;

            loc2 = false;
            loc3 = this.blockedPlayerIds.indexOf(String(arg1));
            if (loc3 >= 0)
            {
                loc2 = true;
            }
            return loc2;
        }

        private function btnCloseClick(arg1:flash.events.MouseEvent):void
        {
            deactivate();
            return;
        }

        public function removeBlockedPlayer(arg1:*):void
        {
            var loc2:*;

            arg1 = String(arg1);
            loc2 = this.blockedPlayerIds.indexOf(arg1);
            if (loc2 >= 0)
            {
                this.blockedPlayerIds.splice(loc2, 1);
            }
            MyLifeInstance.getInstance().server.callExtension("unBlockBuddy", {"playerId":arg1});
            return;
        }

        private function removeBuddyListItem(arg1:*):void
        {
            var loc2:*;

            trace("removeBuddyListItem(" + arg1 + ")");
            loc2 = buddyListCollection[arg1.buddyId];
            trace("buddyListItem = " + loc2);
            loc2.visible = false;
            return;
        }

        private function btnBuddyRemoveFromListClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget.parent.buddyObj;
            trace("Remove Buddy: " + loc2.name);
            loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Are You Sure?", "message":"Are you sure you want to remove " + loc2.name + " from your YoVille buddy list?", "metaData":{"buddyId":loc2.buddyId}, "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmRemoveBuddyDialogResoinse);
            return;
        }

        private function getCurrentInstanceId():*
        {
            return MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
        }

        private function confirmRemoveBuddyDialogResoinse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = undefined;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = arg1.eventData.metaData.buddyId;
                MyLifeInstance.getInstance().getServer().callExtension("removeBuddy", {"targetPlayerId":loc2});
            }
            return;
        }

        private function importFriendsSecurityError(arg1:flash.events.SecurityErrorEvent):void
        {
            var loc2:*;

            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Security Error Event", "message":"You are not allowed to access a url outside the sandbox.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            return;
        }

        private function importFriendsFromServer():void
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
            var loc10:*;
            var loc11:*;

            loc1 = null;
            loc4 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc1 = MyLifeInstance.getInstance().getConfiguration();
            loc2 = loc1.variables["global"]["game_server"];
            loc3 = "buddy_import.php?";
            loc11 = loc1.platformType;
            switch (loc11) 
            {
                case "platformFacebook":
                    loc8 = JSON.decode(loc1.variables["querystring"]["facebookJSON"]);
                    loc4 = "fb_sig_user=" + loc8.fb_sig_user + "&fb_sig_session_key=" + loc8.fb_sig_session_key;
                    break;
                case "platformMySpace":
                    loc9 = loc1.variables["querystring"]["opensocialJSON"];
                    loc10 = loc1.variables["querystring"]["oathJSON"];
                    loc4 = "opensocialJSON=" + loc9 + "&oauthJSON=" + loc10;
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc4 = MyLifeConfiguration.networkCredentials;
                    break;
            }
            loc5 = loc2 + loc3 + loc4 + "&r=" + Math.random();
            loc6 = new URLRequest(loc5);
            (loc7 = new URLLoader()).addEventListener(Event.COMPLETE, importFriendsComplete);
            loc7.addEventListener(IOErrorEvent.IO_ERROR, importFriendsError);
            loc7.addEventListener(SecurityErrorEvent.SECURITY_ERROR, importFriendsSecurityError);
            loc7.load(loc6);
            return;
        }

        private function onUpdateBuddyListEvent(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            trace("onUpdateBuddyListEvent()");
            loc2 = arg1.eventData as Array;
            if (loc2)
            {
                updateBuddyList(loc2);
            }
            return;
        }

        private function addNewBuddyToList(arg1:Object):void
        {
            var loc2:*;

            loc2 = null;
            buddyListNoBuddies.visible = false;
            containerScrollPane.visible = true;
            loc2 = new BuddyListViewerItem();
            loc2.lblName.text = arg1.name;
            if (arg1.instanceId != "0")
            {
                if (arg1.instanceId != getCurrentInstanceId())
                {
                    loc2.statusIcon.gotoAndStop(2);
                }
                else 
                {
                    loc2.statusIcon.gotoAndStop(1);
                }
            }
            else 
            {
                loc2.statusIcon.gotoAndStop(3);
                disableButton(loc2.btnBuddyVisitLocation, true);
            }
            loc2.btnBuddyVisitHome.addEventListener(MouseEvent.CLICK, btnBuddyVisitHomeClick);
            loc2.btnBuddyVisitLocation.addEventListener(MouseEvent.CLICK, btnBuddyVisitLocationClick);
            loc2.btnBuddyRemoveFromList.addEventListener(MouseEvent.CLICK, btnBuddyRemoveFromListClick);
            loc2.buddyObj = arg1;
            loc2.buddyName = arg1.name;
            loc2.isOnline = Number(arg1.instanceId) ? 1 : 0;
            loc2.x = 126.5;
            buddyListItemsContainer.addChild(loc2);
            buddyListCollection[arg1.buddyId] = loc2;
            return;
        }

        private function btnImportClickHandler(arg1:flash.events.MouseEvent):void
        {
            trace("calling externalInterface");
            importFriendsFromServer();
            return;
        }

        private function importFriendsComplete(arg1:flash.events.Event):void
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
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            trace("importFriendsComplete() json = " + arg1.target.data);
            loc5 = MyLifeInstance.getInstance().getConfiguration();
            loc13 = loc5.platformType;
            switch (loc13) 
            {
                case "platformFacebook":
                    loc2 = "Import Facebook Friends";
                    loc3 = "We encountered a problem while importing your Facebook friends.";
                    loc4 = "All of your Facebook friends with YoVille installed are already on your buddy list.";
                    break;
                case "platformMySpace":
                    loc2 = "Import MySpace Friends";
                    loc3 = "We encountered a problem while importing your MySpace friends.";
                    loc4 = "All of your MySpace friends with YoVille installed are already on your buddy list.";
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc2 = "Import Tagged Friends";
                    loc3 = "We encountered a problem while importing your Tagged friends.";
                    loc4 = "All of your Tagged friends with YoVille installed are already on your buddy list.";
                    break;
            }
            if (arg1.target.data.length != 0)
            {
                if ((loc8 = (loc7 = JSON.decode(arg1.target.data))[0]).result != 1)
                {
                    if (loc8.result != -1)
                    {
                        if (loc8.result != -2)
                        {
                            loc12 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc2, "message":loc3 + " Error Code 02.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
                        }
                        else 
                        {
                            loc11 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc2, "message":loc4 + " Invite more friends now and earn coins!", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
                        }
                    }
                    else 
                    {
                        loc10 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc2, "message":"None of your friends have YoVille! Invite them now and earn coins!", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
                    }
                }
                else 
                {
                    (loc9 = MyLifeInstance.getInstance().getInterface().showInterface("ImportFriendsDialog", {})).displayFriends(loc7);
                }
            }
            else 
            {
                loc6 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":loc2, "message":loc3 + " Error Code 01.", "buttons":[{"name":"CLOSE", "value":"BTN_CLOSE"}]});
            }
            return;
        }

        private function updateBuddyListItem(arg1:Object):void
        {
            var loc2:*;

            loc2 = buddyListCollection[arg1.buddyId];
            loc2.visible = true;
            if (arg1.instanceId != "0")
            {
                if (arg1.instanceId != getCurrentInstanceId())
                {
                    loc2.statusIcon.gotoAndStop(2);
                    disableButton(loc2.btnBuddyVisitLocation, false);
                }
                else 
                {
                    loc2.statusIcon.gotoAndStop(1);
                    disableButton(loc2.btnBuddyVisitLocation, false);
                }
            }
            else 
            {
                loc2.statusIcon.gotoAndStop(3);
                disableButton(loc2.btnBuddyVisitLocation, true);
            }
            loc2.buddyObj = arg1;
            loc2.isOnline = Number(arg1.instanceId) ? 1 : 0;
            return;
        }

        public function isPlayerABuddy(arg1:*):Boolean
        {
            if (buddyListCollection[arg1])
            {
                if (buddyListCollection[arg1].visible)
                {
                    return true;
                }
                return false;
            }
            return false;
        }

        private function addListContainerToScrollPane():void
        {
            containerScrollPane = new ScrollPane();
            addChild(containerScrollPane);
            containerScrollPane.move(0, 4);
            containerScrollPane.setSize(248, 295);
            containerScrollPane.source = buddyListItemsContainer;
            containerScrollPane.visible = false;
            return;
        }

        public function deactivate():void
        {
            this.visible = false;
            pollServerTimer.reset();
            return;
        }

        private function initTextFields():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc1 = null;
            loc2 = MyLifeConfiguration.getInstance();
            loc6 = loc2.platformType;
            switch (loc6) 
            {
                case loc2.PLATFORM_FACEBOOK:
                    loc1 = "Import Facebook Friends";
                    break;
                case loc2.PLATFORM_MYSPACE:
                    loc1 = "Import MySpace Friends";
                    break;
                case loc2.PLATFORM_TAGGED:
                    loc1 = "Import Tagged Friends";
                    break;
            }
            loc3 = Sprite(this.btnImport.upState).getChildAt(1) as TextField;
            loc4 = Sprite(this.btnImport.overState).getChildAt(1) as TextField;
            loc5 = Sprite(this.btnImport.downState).getChildAt(1) as TextField;
            loc5.text = loc6 = loc1 || "Import";
            loc4.text = loc6 = loc6;
            loc3.text = loc6;
            return;
        }

        private function btnBuddyVisitLocationClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc5 = NaN;
            loc6 = 0;
            trace("btnBuddyVisitLocationClick()");
            loc2 = arg1.currentTarget.parent.buddyObj;
            this.visible = false;
            if (loc2.roomName)
            {
                loc4 = loc2.name + " is currently on a different server than you.  Are you sure you want to change servers?";
                loc3 = loc2.roomName;
                if (loc3.substr(0, 1) != "h")
                {
                    loc6 = 0;
                    MyLifeInstance.getInstance().getZone().join(loc2.roomName, loc6, loc2.instanceId, loc4);
                }
                else 
                {
                    if (loc5 = Number(loc3.substr(1)))
                    {
                        MyLifeInstance.getInstance().getZone().joinHomeRoom(0, (0), loc5, 1, loc2.instanceId, loc4);
                    }
                }
            }
            return;
        }

        public function activate():void
        {
            MyLifeInstance.getInstance().getServer().callExtension("updateBuddyList", {});
            this.visible = true;
            pollServerTimer.start();
            return;
        }

        private function updateBuddyList(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            loc8 = arg1;
            for each (loc2 in loc8)
            {
                if (!loc2.instanceId)
                {
                    loc2.instanceId = "0";
                }
                if (loc2.roomName == "LOGOUT")
                {
                    loc2.roomName = "";
                    loc2.instanceId = "0";
                }
                if (!loc2.roomName)
                {
                    loc2.roomName = "";
                    loc2.instanceId = "0";
                }
                if (buddyListCollection[loc2.buddyId])
                {
                    if (loc2.roomName != "REMOVE")
                    {
                        updateBuddyListItem(loc2);
                    }
                    else 
                    {
                        removeBuddyListItem(loc2);
                    }
                    continue;
                }
                if (Boolean(Number(loc2.isBlocked)))
                {
                    if ((loc6 = this.blockedPlayerIds.indexOf(loc2.buddyId)) < 0)
                    {
                        this.blockedPlayerIds.push(String(loc2.buddyId));
                    }
                    continue;
                }
                if (loc2.roomName == "REMOVE")
                {
                    continue;
                }
                addNewBuddyToList(loc2);
            }
            loc3 = [];
            loc7 = 0;
            loc8 = buddyListCollection;
            for each (loc4 in loc8)
            {
                loc3.push(loc4);
            }
            loc3.sortOn(["isOnline", "buddyName"], [Array.DESCENDING | Array.NUMERIC, Array.CASEINSENSITIVE]);
            loc5 = 0;
            loc7 = 0;
            loc8 = loc3;
            for each (loc4 in loc8)
            {
                if (!loc4.visible)
                {
                    continue;
                }
                loc4.y = 9.5 + loc5 * 25;
                ++loc5;
            }
            containerScrollPane.update();
            return;
        }

        private static const POLL_SERVER_INTERVAL:Number=5 * 1000;

        private var pollServerTimer:flash.utils.Timer;

        public var buddyListItemsContainer:flash.display.MovieClip;

        private var buddyListCollection:Array;

        private var blockedPlayerIds:Array;

        public var btnImport:flash.display.SimpleButton;

        public var btnClose:flash.display.SimpleButton;

        private var containerScrollPane:fl.containers.ScrollPane;

        public var buddyListNoBuddies:flash.display.MovieClip;
    }
}
