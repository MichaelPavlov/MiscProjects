package it.gotoandplay.smartfoxserver.handlers 
{
    import flash.utils.*;
    import it.gotoandplay.smartfoxserver.*;
    import it.gotoandplay.smartfoxserver.data.*;
    import it.gotoandplay.smartfoxserver.util.*;
    
    public class SysHandler extends Object implements it.gotoandplay.smartfoxserver.handlers.IMessageHandler
    {
        public function SysHandler(arg1:it.gotoandplay.smartfoxserver.SmartFoxClient)
        {
            super();
            this.sfs = arg1;
            handlersTable = [];
            handlersTable["apiOK"] = this.handleApiOK;
            handlersTable["apiKO"] = this.handleApiKO;
            handlersTable["logOK"] = this.handleLoginOk;
            handlersTable["logKO"] = this.handleLoginKo;
            handlersTable["logout"] = this.handleLogout;
            handlersTable["rmList"] = this.handleRoomList;
            handlersTable["uCount"] = this.handleUserCountChange;
            handlersTable["joinOK"] = this.handleJoinOk;
            handlersTable["joinKO"] = this.handleJoinKo;
            handlersTable["uER"] = this.handleUserEnterRoom;
            handlersTable["userGone"] = this.handleUserLeaveRoom;
            handlersTable["pubMsg"] = this.handlePublicMessage;
            handlersTable["prvMsg"] = this.handlePrivateMessage;
            handlersTable["dmnMsg"] = this.handleAdminMessage;
            handlersTable["modMsg"] = this.handleModMessage;
            handlersTable["dataObj"] = this.handleASObject;
            handlersTable["rVarsUpdate"] = this.handleRoomVarsUpdate;
            handlersTable["roomAdd"] = this.handleRoomAdded;
            handlersTable["roomDel"] = this.handleRoomDeleted;
            handlersTable["rndK"] = this.handleRandomKey;
            handlersTable["roundTripRes"] = this.handleRoundTripBench;
            handlersTable["uVarsUpdate"] = this.handleUserVarsUpdate;
            handlersTable["createRmKO"] = this.handleCreateRoomError;
            handlersTable["bList"] = this.handleBuddyList;
            handlersTable["bUpd"] = this.handleBuddyListUpdate;
            handlersTable["bAdd"] = this.handleBuddyAdded;
            handlersTable["roomB"] = this.handleBuddyRoom;
            handlersTable["leaveRoom"] = this.handleLeaveRoom;
            handlersTable["swSpec"] = this.handleSpectatorSwitched;
            handlersTable["bPrm"] = this.handleAddBuddyPermission;
            handlersTable["remB"] = this.handleRemoveBuddy;
            return;
        }

        private function populateVariables(arg1:Array, arg2:Object, arg3:Array=null):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = 0;
            loc9 = arg2.vars["var"];
            for each (loc4 in loc9)
            {
                loc5 = loc4.n;
                loc6 = loc4.t;
                loc7 = loc4;
                if (arg3 != null)
                {
                    arg3.push(loc5);
                    arg3[loc5] = true;
                }
                if (loc6 == "b")
                {
                    arg1[loc5] = (loc7 != "1") ? false : true;
                    continue;
                }
                if (loc6 == "n")
                {
                    arg1[loc5] = Number(loc7);
                    continue;
                }
                if (loc6 == "s")
                {
                    arg1[loc5] = loc7;
                    continue;
                }
                if (loc6 != "x")
                {
                    continue;
                }
                delete arg1[loc5];
            }
            return;
        }

        private function handleRoomDeleted(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = int(arg1.body.rm.id);
            loc3 = sfs.getAllRooms();
            (loc4 = {}).room = loc3[loc2];
            delete loc3[loc2];
            loc5 = new SFSEvent(SFSEvent.onRoomDeleted, loc4);
            sfs.dispatchEvent(loc5);
            return;
        }

        public function handleAdminMessage(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = arg1.body.txt;
            (loc5 = {}).message = Entities.decodeEntities(loc4);
            loc6 = new SFSEvent(SFSEvent.onAdminMessage, loc5);
            sfs.dispatchEvent(loc6);
            return;
        }

        public function handleUserVarsUpdate(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = sfs.getRoom(loc2).getUser(loc3);
            loc5 = [];
            if (arg1.body.vars.toString().length > 0)
            {
                populateVariables(loc4.getVariables(), arg1.body, loc5);
            }
            (loc6 = {}).user = loc4;
            loc6.changedVars = loc5;
            loc7 = new SFSEvent(SFSEvent.onUserVariablesUpdate, loc6);
            sfs.dispatchEvent(loc7);
            return;
        }

        private function handleCreateRoomError(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.body.room.e;
            loc3 = {};
            loc3.error = loc2;
            loc4 = new SFSEvent(SFSEvent.onCreateRoomError, loc3);
            sfs.dispatchEvent(loc4);
            return;
        }

        public function handlePrivateMessage(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = arg1.body.txt;
            loc5 = sfs.getRoom(loc2).getUser(loc3);
            (loc6 = {}).message = Entities.decodeEntities(loc4);
            loc6.sender = loc5;
            loc6.roomId = loc2;
            loc6.userId = loc3;
            loc7 = new SFSEvent(SFSEvent.onPrivateMessage, loc6);
            sfs.dispatchEvent(loc7);
            return;
        }

        private function handleBuddyRoom(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = arg1.body.br.r;
            loc3 = loc2.split(",");
            loc4 = 0;
            while (loc4 < loc3.length) 
            {
                loc3[loc4] = int(loc3[loc4]);
                ++loc4;
            }
            (loc5 = {}).idList = loc3;
            loc6 = new SFSEvent(SFSEvent.onBuddyRoom, loc5);
            sfs.dispatchEvent(loc6);
            return;
        }

        public function handleLogout(arg1:Object):void
        {
            var loc2:*;

            sfs.__logout();
            loc2 = new SFSEvent(SFSEvent.onLogout, {});
            sfs.dispatchEvent(loc2);
            return;
        }

        public function handleUserCountChange(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = null;
            loc7 = null;
            loc2 = int(arg1.body.u);
            loc3 = int(arg1.body.s);
            loc4 = int(arg1.body.r);
            if ((loc5 = sfs.getAllRooms()[loc4]) != null)
            {
                loc5.setUserCount(loc2);
                loc5.setSpectatorCount(loc3);
                (loc6 = {}).room = loc5;
                loc7 = new SFSEvent(SFSEvent.onUserCountChange, loc6);
                sfs.dispatchEvent(loc7);
            }
            return;
        }

        private function handleRandomKey(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.body.k.toString();
            loc3 = {};
            loc3.key = loc2;
            loc4 = new SFSEvent(SFSEvent.onRandomKey, loc3);
            sfs.dispatchEvent(loc4);
            return;
        }

        public function handlePublicMessage(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = arg1.body.txt;
            loc5 = sfs.getRoom(loc2).getUser(loc3);
            (loc6 = {}).message = Entities.decodeEntities(loc4);
            loc6.sender = loc5;
            loc6.roomId = loc2;
            loc7 = new SFSEvent(SFSEvent.onPublicMessage, loc6);
            sfs.dispatchEvent(loc7);
            return;
        }

        public function handleUserEnterRoom(arg1:Object):void
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

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.u.i);
            loc4 = arg1.body.u.n;
            loc5 = arg1.body.u.m == "1";
            loc6 = arg1.body.u.s == "1";
            loc7 = (arg1.body.u.p == null) ? -1 : int(arg1.body.u.p);
            loc8 = arg1.body.u.vars["var"];
            loc9 = sfs.getRoom(loc2);
            (loc10 = new User(loc3, loc4)).setModerator(loc5);
            loc10.setIsSpectator(loc6);
            loc10.setPlayerId(loc7);
            loc9.addUser(loc10, loc3);
            if (arg1.body.u.vars.toString().length > 0)
            {
                populateVariables(loc10.getVariables(), arg1.body.u);
            }
            (loc11 = {}).roomId = loc2;
            loc11.user = loc10;
            loc12 = new SFSEvent(SFSEvent.onUserEnterRoom, loc11);
            sfs.dispatchEvent(loc12);
            return;
        }

        public function dispatchDisconnection():void
        {
            var loc1:*;

            loc1 = new SFSEvent(SFSEvent.onConnectionLost, null);
            sfs.dispatchEvent(loc1);
            return;
        }

        private function handleRemoveBuddy(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc2 = arg1.body.n.toString();
            loc3 = null;
            loc7 = 0;
            loc8 = sfs.buddyList;
            for (loc4 in loc8)
            {
                loc3 = sfs.buddyList[loc4];
                if (loc3.name != loc2)
                {
                    continue;
                }
                delete sfs.buddyList[loc4];
                (loc5 = {}).list = sfs.buddyList;
                loc6 = new SFSEvent(SFSEvent.onBuddyList, loc5);
                sfs.dispatchEvent(loc6);
                break;
            }
            return;
        }

        private function handleAddBuddyPermission(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {};
            loc2.sender = arg1.body.n.toString();
            loc2.message = "";
            if (arg1.body.txt != undefined)
            {
                loc2.message = Entities.decodeEntities(arg1.body.txt);
            }
            loc3 = new SFSEvent(SFSEvent.onBuddyPermissionRequest, loc2);
            sfs.dispatchEvent(loc3);
            return;
        }

        public function handleLoginOk(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = int(arg1.body.login.id);
            loc3 = int(arg1.body.login.mod);
            loc4 = arg1.body.login.n;
            sfs.amIModerator = loc3 == 1;
            sfs.myUserId = loc2;
            sfs.myUserName = loc4;
            sfs.playerId = -1;
            (loc5 = {}).success = true;
            loc5.name = loc4;
            loc5.error = "";
            loc6 = new SFSEvent(SFSEvent.onLogin, loc5);
            sfs.dispatchEvent(loc6);
            sfs.getRoomList();
            return;
        }

        private function handleBuddyListUpdate(arg1:Object):void
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

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = false;
            loc8 = null;
            loc9 = null;
            loc2 = {};
            loc3 = null;
            if (arg1.body.b == null)
            {
                loc2.error = arg1.body.err.toString();
                loc3 = new SFSEvent(SFSEvent.onBuddyListError, loc2);
                sfs.dispatchEvent(loc3);
            }
            else 
            {
                (loc4 = {}).isOnline = (arg1.body.b.s != "1") ? false : true;
                loc4.name = arg1.body.b.n.toString();
                loc4.id = arg1.body.b.i;
                loc4.isBlocked = (arg1.body.b.x != "1") ? false : true;
                loc5 = arg1.body.b.vs;
                loc6 = null;
                loc7 = false;
                loc10 = 0;
                loc11 = sfs.buddyList;
                for (loc8 in loc11)
                {
                    if ((loc6 = sfs.buddyList[loc8]).name != loc4.name)
                    {
                        continue;
                    }
                    sfs.buddyList[loc8] = loc4;
                    loc4.isBlocked = loc6.isBlocked;
                    loc4.variables = loc6.variables;
                    if (loc5.toString().length > 0)
                    {
                        loc12 = 0;
                        loc13 = loc5.v;
                        for each (loc9 in loc13)
                        {
                            loc4.variables[loc9.n.toString()] = loc9.toString();
                        }
                    }
                    loc7 = true;
                    break;
                }
                if (loc7)
                {
                    loc2.buddy = loc4;
                    loc3 = new SFSEvent(SFSEvent.onBuddyListUpdate, loc2);
                    sfs.dispatchEvent(loc3);
                }
            }
            return;
        }

        public function handleRoomVarsUpdate(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = sfs.getRoom(loc2);
            loc5 = [];
            if (arg1.body.vars.toString().length > 0)
            {
                populateVariables(loc4.getVariables(), arg1.body, loc5);
            }
            (loc6 = {}).room = loc4;
            loc6.changedVars = loc5;
            loc7 = new SFSEvent(SFSEvent.onRoomVariablesUpdate, loc6);
            sfs.dispatchEvent(loc7);
            return;
        }

        public function handleRoomList(arg1:Object):void
        {
            var loc2:*;
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
            loc6 = 0;
            loc7 = null;
            sfs.clearRoomList();
            loc2 = sfs.getAllRooms();
            loc8 = 0;
            loc9 = arg1.body.rmList.rm;
            for each (loc3 in loc9)
            {
                loc6 = int(loc3.id);
                loc7 = new Room(loc6, loc3.n, int(loc3.maxu), int(loc3.maxs), loc3.temp == "1", loc3.game == "1", loc3.priv == "1", loc3.lmb == "1", int(loc3.ucnt), int(loc3.scnt));
                if (loc3.vars.toString().length > 0)
                {
                    populateVariables(loc7.getVariables(), loc3);
                }
                loc2[loc6] = loc7;
            }
            (loc4 = {}).roomList = loc2;
            loc5 = new SFSEvent(SFSEvent.onRoomListUpdate, loc4);
            sfs.dispatchEvent(loc5);
            return;
        }

        private function handleBuddyAdded(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = null;
            loc2 = {};
            loc2.isOnline = (arg1.body.b.s != "1") ? false : true;
            loc2.name = arg1.body.b.n.toString();
            loc2.id = arg1.body.b.i;
            loc2.isBlocked = (arg1.body.b.x != "1") ? false : true;
            loc2.variables = {};
            loc3 = arg1.body.b.vs;
            if (loc3.toString().length > 0)
            {
                loc7 = 0;
                loc8 = loc3.v;
                for each (loc6 in loc8)
                {
                    loc2.variables[loc6.n.toString()] = loc6.toString();
                }
            }
            sfs.buddyList.push(loc2);
            (loc4 = {}).list = sfs.buddyList;
            loc5 = new SFSEvent(SFSEvent.onBuddyList, loc4);
            sfs.dispatchEvent(loc5);
            return;
        }

        private function handleRoomAdded(arg1:Object):void
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

            loc2 = int(arg1.body.rm.id);
            loc3 = arg1.body.rm.name;
            loc4 = int(arg1.body.rm.max);
            loc5 = int(arg1.body.rm.spec);
            loc6 = (arg1.body.rm.temp != "1") ? false : true;
            loc7 = (arg1.body.rm.game != "1") ? false : true;
            loc8 = (arg1.body.rm.priv != "1") ? false : true;
            loc9 = (arg1.body.rm.limbo != "1") ? false : true;
            loc10 = new Room(loc2, loc3, loc4, loc5, loc6, loc7, loc8, loc9);
            (loc11 = sfs.getAllRooms())[loc2] = loc10;
            if (arg1.body.rm.vars.toString().length > 0)
            {
                populateVariables(loc10.getVariables(), arg1.body.rm);
            }
            (loc12 = {}).room = loc10;
            loc13 = new SFSEvent(SFSEvent.onRoomAdded, loc12);
            sfs.dispatchEvent(loc13);
            return;
        }

        public function handleUserLeaveRoom(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = int(arg1.body.user.id);
            loc3 = int(arg1.body.r);
            loc5 = (loc4 = sfs.getRoom(loc3)).getUser(loc2).getName();
            loc4.removeUser(loc2);
            (loc6 = {}).roomId = loc3;
            loc6.userId = loc2;
            loc6.userName = loc5;
            loc7 = new SFSEvent(SFSEvent.onUserLeaveRoom, loc6);
            sfs.dispatchEvent(loc7);
            return;
        }

        private function handleSpectatorSwitched(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = 0;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.pid.id);
            loc4 = sfs.getRoom(loc2);
            if (loc3 > 0)
            {
                loc4.setUserCount(loc4.getUserCount() + 1);
                loc4.setSpectatorCount((loc4.getSpectatorCount() - 1));
            }
            if (arg1.body.pid.u == undefined)
            {
                sfs.playerId = loc3;
                (loc7 = {}).success = sfs.playerId > 0;
                loc7.newId = sfs.playerId;
                loc7.room = loc4;
                loc8 = new SFSEvent(SFSEvent.onSpectatorSwitched, loc7);
                sfs.dispatchEvent(loc8);
            }
            else 
            {
                loc5 = int(arg1.body.pid.u);
                if ((loc6 = loc4.getUser(loc5)) != null)
                {
                    loc6.setIsSpectator(false);
                    loc6.setPlayerId(loc3);
                }
            }
            return;
        }

        private function handleLeaveRoom(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = int(arg1.body.rm.id);
            loc3 = {};
            loc3.roomId = loc2;
            loc4 = new SFSEvent(SFSEvent.onRoomLeft, loc3);
            sfs.dispatchEvent(loc4);
            return;
        }

        public function handleLoginKo(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {};
            loc2.success = false;
            loc2.error = arg1.body.login.e;
            loc3 = new SFSEvent(SFSEvent.onLogin, loc2);
            sfs.dispatchEvent(loc3);
            return;
        }

        public function handleModMessage(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = arg1.body.txt;
            loc5 = null;
            if ((loc6 = sfs.getRoom(loc2)) != null)
            {
                loc5 = sfs.getRoom(loc2).getUser(loc3);
            }
            (loc7 = {}).message = Entities.decodeEntities(loc4);
            loc7.sender = loc5;
            loc8 = new SFSEvent(SFSEvent.onModeratorMessage, loc7);
            sfs.dispatchEvent(loc8);
            return;
        }

        public function handleApiOK(arg1:Object):void
        {
            var loc2:*;

            sfs.isConnected = true;
            loc2 = new SFSEvent(SFSEvent.onConnection, {"success":true});
            sfs.dispatchEvent(loc2);
            return;
        }

        private function handleRoundTripBench(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = getTimer();
            loc3 = loc2 - sfs.getBenchStartTime();
            (loc4 = {}).elapsed = loc3;
            loc5 = new SFSEvent(SFSEvent.onRoundTripResponse, loc4);
            sfs.dispatchEvent(loc5);
            return;
        }

        public function handleJoinOk(arg1:Object):void
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
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;

            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = 0;
            loc12 = false;
            loc13 = false;
            loc14 = 0;
            loc15 = null;
            loc2 = int(arg1.body.r);
            loc3 = arg1.body;
            loc4 = arg1.body.uLs.u;
            loc5 = int(arg1.body.pid.id);
            sfs.activeRoomId = loc2;
            (loc6 = sfs.getRoom(loc2)).clearUserList();
            sfs.playerId = loc5;
            loc6.setMyPlayerIndex(loc5);
            if (loc3.vars.toString().length > 0)
            {
                loc6.clearVariables();
                populateVariables(loc6.getVariables(), loc3);
            }
            loc16 = 0;
            loc17 = loc4;
            for each (loc7 in loc17)
            {
                loc10 = loc7.n;
                loc11 = int(loc7.i);
                loc12 = (loc7.m != "1") ? false : true;
                loc13 = (loc7.s != "1") ? false : true;
                loc14 = (loc7.p != null) ? int(loc7.p) : -1;
                (loc15 = new User(loc11, loc10)).setModerator(loc12);
                loc15.setIsSpectator(loc13);
                loc15.setPlayerId(loc14);
                if (loc7.vars.toString().length > 0)
                {
                    populateVariables(loc15.getVariables(), loc7);
                }
                loc6.addUser(loc15, loc11);
            }
            sfs.changingRoom = false;
            (loc8 = {}).room = loc6;
            loc9 = new SFSEvent(SFSEvent.onJoinRoom, loc8);
            sfs.dispatchEvent(loc9);
            return;
        }

        public function handleApiKO(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {};
            loc2.success = false;
            loc2.error = "API are obsolete, please upgrade";
            loc3 = new SFSEvent(SFSEvent.onConnection, loc2);
            sfs.dispatchEvent(loc3);
            return;
        }

        public function handleASObject(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = int(arg1.body.r);
            loc3 = int(arg1.body.user.id);
            loc4 = arg1.body.dataObj;
            loc5 = sfs.getRoom(loc2).getUser(loc3);
            loc6 = ObjectSerializer.getInstance().deserialize(new XML(loc4));
            (loc7 = {}).obj = loc6;
            loc7.sender = loc5;
            loc8 = new SFSEvent(SFSEvent.onObjectReceived, loc7);
            sfs.dispatchEvent(loc8);
            return;
        }

        private function handleBuddyList(arg1:Object):void
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
            var loc14:*;

            loc4 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc2 = arg1.body.bList;
            loc3 = arg1.body.mv;
            loc5 = {};
            loc6 = null;
            if (!(loc2 == null) && !(loc2.b.length == null))
            {
                if (!(loc3 == null) && loc3.toString().length > 0)
                {
                    loc11 = 0;
                    loc12 = loc3.v;
                    for each (loc7 in loc12)
                    {
                        sfs.myBuddyVars[loc7.n.toString()] = loc7.toString();
                    }
                }
                if (loc2.toString().length > 0)
                {
                    loc11 = 0;
                    loc12 = loc2.b;
                    for each (loc8 in loc12)
                    {
                        (loc4 = {}).isOnline = (loc8.s != "1") ? false : true;
                        loc4.name = loc8.n.toString();
                        loc4.id = loc8.i;
                        loc4.isBlocked = (loc8.x != "1") ? false : true;
                        loc4.variables = {};
                        if ((loc9 = loc8.vs).toString().length > 0)
                        {
                            loc13 = 0;
                            loc14 = loc9.v;
                            for each (loc10 in loc14)
                            {
                                loc4.variables[loc10.n.toString()] = loc10.toString();
                            }
                        }
                        sfs.buddyList.push(loc4);
                    }
                }
                loc5.list = sfs.buddyList;
                loc6 = new SFSEvent(SFSEvent.onBuddyList, loc5);
                sfs.dispatchEvent(loc6);
            }
            else 
            {
                loc5.error = arg1.body.err.toString();
                loc6 = new SFSEvent(SFSEvent.onBuddyListError, loc5);
                sfs.dispatchEvent(loc6);
            }
            return;
        }

        public function handleJoinKo(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            sfs.changingRoom = false;
            loc2 = {};
            loc2.error = arg1.body.error.msg;
            loc3 = new SFSEvent(SFSEvent.onJoinRoomError, loc2);
            sfs.dispatchEvent(loc3);
            return;
        }

        public function handleMessage(arg1:Object, arg2:String):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = arg1 as XML;
            loc4 = loc3.body.action;
            if ((loc5 = handlersTable[loc4]) == null)
            {
                trace("Unknown sys command: " + loc4);
            }
            else 
            {
                loc5.apply(this, [arg1]);
            }
            return;
        }

        private var sfs:it.gotoandplay.smartfoxserver.SmartFoxClient;

        private var handlersTable:Array;
    }
}
