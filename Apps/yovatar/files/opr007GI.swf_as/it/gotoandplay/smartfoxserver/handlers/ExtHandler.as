package it.gotoandplay.smartfoxserver.handlers 
{
    import it.gotoandplay.smartfoxserver.*;
    import it.gotoandplay.smartfoxserver.data.*;
    import it.gotoandplay.smartfoxserver.util.*;
    
    public class ExtHandler extends Object implements it.gotoandplay.smartfoxserver.handlers.IMessageHandler
    {
        public function ExtHandler(arg1:it.gotoandplay.smartfoxserver.SmartFoxClient)
        {
            super();
            this.sfs = arg1;
            return;
        }

        private function updateSingleRoom(arg1:Object):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = 0;
            sfs.clearRoomList();
            loc4 = sfs.getAllRooms();
            loc3 = int(arg1.dataObj.roomId);
            loc5 = new Room(loc3, arg1.dataObj.name, int(arg1.dataObj.maxUsers), int(arg1.dataObj.maxSpecs), arg1.dataObj.isTemp, arg1.dataObj.isGame, arg1.dataObj.isPrivate, arg1.dataObj.isLimbo, int(arg1.dataObj.userCount), int(arg1.dataObj.specCount));
            loc4[loc3] = loc5;
            arg1 = {};
            arg1.roomList = loc4;
            loc2 = new SFSEvent(SFSEvent.onRoomListUpdate, arg1);
            sfs.dispatchEvent(loc2);
            return;
        }

        public function handleMessage(arg1:Object, arg2:String):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc8 = null;
            loc9 = null;
            if (arg2 != SmartFoxClient.XTMSG_TYPE_XML)
            {
                if (arg2 != SmartFoxClient.XTMSG_TYPE_JSON)
                {
                    if (arg2 == SmartFoxClient.XTMSG_TYPE_STR)
                    {
                        loc3 = {};
                        loc3.dataObj = arg1;
                        loc3.type = arg2;
                        loc4 = new SFSEvent(SFSEvent.onExtensionResponse, loc3);
                        sfs.dispatchEvent(loc4);
                    }
                }
                else 
                {
                    loc3 = {};
                    loc3.dataObj = arg1.o;
                    loc3.type = arg2;
                    if (loc3.dataObj._cmd != "updateSingleRoom")
                    {
                        loc4 = new SFSEvent(SFSEvent.onExtensionResponse, loc3);
                        sfs.dispatchEvent(loc4);
                    }
                    else 
                    {
                        updateSingleRoom(loc3);
                    }
                }
            }
            else 
            {
                loc6 = (loc5 = arg1 as XML).body.action;
                loc7 = int(loc5.body.id);
                if (loc6 == "xtRes")
                {
                    loc8 = loc5.body.toString();
                    loc9 = ObjectSerializer.getInstance().deserialize(loc8);
                    loc3 = {};
                    loc3.dataObj = loc9;
                    loc3.type = arg2;
                    if (loc3.dataObj._cmd != "updateSingleRoom")
                    {
                        loc4 = new SFSEvent(SFSEvent.onExtensionResponse, loc3);
                        sfs.dispatchEvent(loc4);
                    }
                    else 
                    {
                        updateSingleRoom(loc3);
                    }
                }
            }
            return;
        }

        private var sfs:it.gotoandplay.smartfoxserver.SmartFoxClient;
    }
}
