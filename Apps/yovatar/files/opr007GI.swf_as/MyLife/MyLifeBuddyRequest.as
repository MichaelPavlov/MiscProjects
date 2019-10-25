package MyLife 
{
    import flash.display.*;
    
    public class MyLifeBuddyRequest extends Object
    {
        public function MyLifeBuddyRequest()
        {
            newBuddyDialogRequestColection = new Array();
            waitingForMeToAcceptNewRequest = new Array();
            super();
            if (_instance != null)
            {
                throw new Error("Please use getInstance() to access class.");
            }
            return;
        }

        public function sendNewBuddyRequest(arg1:*):*
        {
            var loc2:*;

            newBuddyRequestUserServerId = arg1;
            if (waitingForMeToAcceptNewRequest[arg1])
            {
                return;
            }
            sendPlayerToPlayerEvent(arg1, "new_buddy", {});
            loc2 = getPlayerName(arg1);
            if (loc2 != "")
            {
                newBuddyRequestDialog = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":"Please wait for " + loc2 + " to accept your buddy request...", "metaData":{"userServerId":arg1}, "icon":"loading", "buttons":[{"name":"Cancel Request", "value":"BTN_CANCEL"}]});
                newBuddyRequestDialog.addEventListener(MyLifeEvent.DIALOG_RESPONSE, newBuddyRequestDialogResponse);
            }
            else 
            {
                MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":"The player you asked has left the room."});
            }
            resetIgnoreStatus();
            return;
        }

        private function getPlayerName(arg1:*):*
        {
            var loc2:*;

            loc2 = "";
            if (arg1 && MyLifeInstance.getInstance() && MyLifeInstance.getInstance().getZone())
            {
                loc2 = MyLifeInstance.getInstance().getZone().getCharacterName(arg1);
            }
            return loc2;
        }

        public function removeBlockedPlayer(arg1:flash.display.MovieClip):void
        {
            var loc2:*;

            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Unblock Player", "message":"Are you sure you want to unblock this player?", "metaData":{"character":arg1}, "buttons":[{"name":"Cancel", "value":"BTN_NO"}, {"name":"Ok", "value":"BTN_YES"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmUnblockDialogHandler, false, 0, true);
            return;
        }

        private function confirmUnblockDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = undefined;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = arg1.eventData.metaData.character;
                loc2.isBlocked = false;
                loc3 = loc2.myLifePlayerId;
                MyLifeInstance.getInstance().getInterface().interfaceHUD.buddyListViewer.removeBlockedPlayer(loc3);
            }
            return;
        }

        private function cancelNewBuddyRequest(arg1:*):*
        {
            newBuddyRequestUserServerId = 0;
            sendPlayerToPlayerEvent(arg1, "deny_request", {});
            return;
        }

        public function handleEvent(arg1:Object):void
        {
            var loc2:*;

            MyLifeUtils.deepTrace(arg1);
            loc2 = arg1.params.action;
            switch (loc2) 
            {
                case "new_buddy":
                    handleNewBuddyRequest(arg1.sender);
                    break;
                case "deny_request":
                    handleDenyBuddyRequest(arg1.sender);
                    break;
                case "accept_request":
                    handleAcceptBuddyRequest(arg1.sender);
                    break;
                default:
                    break;
            }
            return;
        }

        private function resetIgnoreStatus():*
        {
            buddyRequestIgnoreCount = 0;
            autoIgnoreAllRequests = false;
            return;
        }

        public function handleAcceptBuddyRequest(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var userServerId:*;

            userServerId = arg1;
            trace("handleAcceptBuddyRequest: " + userServerId + " / " + getPlayerName(userServerId));
            try
            {
                MyLifeInstance.getInstance().getInterface().unloadInterface(newBuddyRequestDialog);
                newBuddyRequestDialog = null;
                if (newBuddyRequestUserServerId == userServerId)
                {
                    newBuddyRequestUserServerId = 0;
                }
                waitingForMeToAcceptNewRequest[userServerId] = false;
                MyLifeInstance.getInstance().getServer().callExtension("createBuddyPair", {"target":userServerId});
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function addBlockedPlayer(arg1:flash.display.MovieClip):void
        {
            var loc2:*;

            loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Block Player", "message":"Are you sure you want to block this player?", "metaData":{"character":arg1}, "buttons":[{"name":"Cancel", "value":"BTN_NO"}, {"name":"Ok", "value":"BTN_YES"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmBlockDialogHandler, false, 0, true);
            return;
        }

        public function handleDenyBuddyRequest(arg1:*):void
        {
            var loc2:*;
            var loc3:*;
            var userPlayerName:*;
            var userServerId:*;

            userServerId = arg1;
            trace("handleDenyBuddyRequest: " + userServerId + " / " + getPlayerName(userServerId));
            userPlayerName = getPlayerName(userServerId);
            if (newBuddyRequestUserServerId != userServerId)
            {
                if (waitingForMeToAcceptNewRequest[userServerId])
                {
                    if (newBuddyDialogRequestColection[userServerId])
                    {
                        MyLifeInstance.getInstance().getInterface().unloadInterface(newBuddyDialogRequestColection[userServerId]);
                        newBuddyDialogRequestColection[userServerId] = null;
                    }
                    if (userPlayerName != "")
                    {
                        MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":userPlayerName + " canceled the buddy request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                    }
                    waitingForMeToAcceptNewRequest[userServerId] = false;
                }
            }
            else 
            {
                try
                {
                    MyLifeInstance.getInstance().getInterface().unloadInterface(newBuddyRequestDialog);
                }
                catch (e:Error)
                {
                };
                newBuddyRequestDialog = null;
                if (userPlayerName != "")
                {
                    MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":userPlayerName + " declined your buddy request.", "autoClose":20, "buttons":[{"name":"OK", "value":"BTN_OK"}]});
                }
            }
            return;
        }

        public function getActiveGameCount():int
        {
            return 0;
        }

        public function getActiveWindowCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc1 = 0;
            if (newBuddyRequestDialog)
            {
                ++loc1;
            }
            loc3 = 0;
            loc4 = newBuddyDialogRequestColection;
            for each (loc2 in loc4)
            {
                if (!loc2)
                {
                    continue;
                }
                ++loc1;
            }
            return loc1;
        }

        public function handleNewBuddyRequest(arg1:*):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            trace("handleNewBuddyRequest: " + arg1 + " / " + getPlayerName(arg1));
            if (autoIgnoreAllRequests)
            {
                waitingForMeToAcceptNewRequest[arg1] = false;
                sendPlayerToPlayerEvent(arg1, "deny_request", {});
                return;
            }
            loc2 = getPlayerName(arg1);
            if (loc2 != "")
            {
                if (buddyRequestIgnoreCount < 2)
                {
                    loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":loc2 + " has requested to add you as a buddy.  Do you want to accept this buddy request?", "metaData":{"userServerId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}]});
                }
                else 
                {
                    loc3 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"New Buddy Request", "message":loc2 + " has requested to add you as a buddy.  Do you want to accept this buddy request?", "metaData":{"userServerId":arg1}, "autoClose":30, "autoCloseCMD":"BTN_NO", "buttons":[{"name":"Accept Request", "value":"BTN_YES"}, {"name":"Decline", "value":"BTN_NO"}, {"name":"Ignore All", "value":"BTN_IGNORE"}]});
                }
                loc3.addEventListener(MyLifeEvent.DIALOG_RESPONSE, newBuddyDialogRequestResponse);
                newBuddyDialogRequestColection[arg1] = loc3;
                waitingForMeToAcceptNewRequest[arg1] = true;
            }
            return;
        }

        private function newBuddyRequestDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            if (newBuddyRequestDialog)
            {
                newBuddyRequestDialog.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, newBuddyRequestDialogResponse);
                newBuddyRequestDialog = null;
            }
            loc2 = arg1.eventData.metaData.userServerId;
            if (arg1.eventData.userResponse == "BTN_CANCEL")
            {
                cancelNewBuddyRequest(loc2);
            }
            return;
        }

        private function sendPlayerToPlayerEvent(arg1:int, arg2:String, arg3:Object):*
        {
            MyLifeInstance.getInstance().getServer().sendPlayerToPlayerEvent(arg1, "BUDDYLIST", arg2, arg3);
            return;
        }

        private function newBuddyDialogRequestResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.eventData.metaData.userServerId;
            if (newBuddyDialogRequestColection[loc2])
            {
                newBuddyDialogRequestColection[loc2].removeEventListener(MyLifeEvent.DIALOG_RESPONSE, newBuddyDialogRequestResponse);
                newBuddyDialogRequestColection[loc2] = null;
            }
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                sendPlayerToPlayerEvent(loc2, "deny_request", {});
                if (arg1.eventData.userResponse == "BTN_IGNORE")
                {
                    autoIgnoreAllRequests = true;
                }
                buddyRequestIgnoreCount++;
            }
            else 
            {
                if (newBuddyRequestUserServerId == loc2)
                {
                    newBuddyRequestUserServerId = 0;
                }
                waitingForMeToAcceptNewRequest[loc2] = false;
                sendPlayerToPlayerEvent(loc2, "accept_request", {});
            }
            return;
        }

        private function confirmBlockDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = undefined;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = arg1.eventData.metaData.character;
                loc2.isBlocked = true;
                loc3 = loc2.myLifePlayerId;
                MyLifeInstance.getInstance().getInterface().interfaceHUD.buddyListViewer.addBlockedPlayer(loc3);
            }
            return;
        }

        public static function getInstance():MyLife.MyLifeBuddyRequest
        {
            return _instance;
        }

        private static const _instance:MyLife.MyLifeBuddyRequest=new MyLifeBuddyRequest();

        private var newBuddyRequestDialog:flash.display.MovieClip;

        private var waitingForMeToAcceptNewRequest:Array;

        private var autoIgnoreAllRequests:Boolean=false;

        private var newBuddyDialogRequestColection:Array;

        private var buddyRequestIgnoreCount:int=0;

        private var newBuddyRequestUserServerId:int=0;
    }
}
