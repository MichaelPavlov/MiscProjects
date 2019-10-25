package it.gotoandplay.smartfoxserver 
{
    import com.adobe.serialization.json.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import it.gotoandplay.smartfoxserver.data.*;
    import it.gotoandplay.smartfoxserver.handlers.*;
    import it.gotoandplay.smartfoxserver.http.*;
    import it.gotoandplay.smartfoxserver.util.*;
    
    public class SmartFoxClient extends flash.events.EventDispatcher
    {
        public function SmartFoxClient(arg1:Boolean=false)
        {
            _httpPollSpeed = DEFAULT_POLL_SPEED;
            super();
            this.majVersion = 1;
            this.minVersion = 5;
            this.subVersion = 4;
            this.activeRoomId = -1;
            this.debug = arg1;
            this.messageHandlers = [];
            setupMessageHandlers();
            socketConnection = new Socket();
            socketConnection.addEventListener(Event.CONNECT, handleSocketConnection);
            socketConnection.addEventListener(Event.CLOSE, handleSocketDisconnection);
            socketConnection.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
            socketConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
            socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            httpConnection = new HttpConnection();
            httpConnection.addEventListener(HttpEvent.onHttpConnect, handleHttpConnect);
            httpConnection.addEventListener(HttpEvent.onHttpClose, handleHttpClose);
            httpConnection.addEventListener(HttpEvent.onHttpData, handleHttpData);
            httpConnection.addEventListener(HttpEvent.onHttpError, handleHttpError);
            byteBuffer = new ByteArray();
            return;
        }

        private function getXmlUserVariable(arg1:Object):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc2 = "<vars>";
            loc7 = 0;
            loc8 = arg1;
            for (loc6 in loc8)
            {
                loc3 = arg1[loc6];
                loc5 = typeof loc3;
                loc4 = null;
                if (loc5 != "boolean")
                {
                    if (loc5 != "number")
                    {
                        if (loc5 != "string")
                        {
                            if (loc3 == null && loc5 == "object" || loc5 == "undefined")
                            {
                                loc4 = "x";
                                loc3 = "";
                            }
                        }
                        else 
                        {
                            loc4 = "s";
                        }
                    }
                    else 
                    {
                        loc4 = "n";
                    }
                }
                else 
                {
                    loc4 = "b";
                    loc3 = loc3 ? "1" : "0";
                }
                if (loc4 == null)
                {
                    continue;
                }
                loc2 = loc2 + "<var n=\'" + loc6 + "\' t=\'" + loc4 + "\'><![CDATA[" + loc3 + "]]></var>";
            }
            loc2 = loc2 + "</vars>";
            return loc2;
        }

        private function jsonReceived(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = JSON.decode(arg1);
            loc3 = loc2["t"];
            if ((loc4 = messageHandlers[loc3]) != null)
            {
                loc4.handleMessage(loc2["b"], XTMSG_TYPE_JSON);
            }
            return;
        }

        private function onConfigLoadFailure(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {"message":arg1.text};
            loc3 = new SFSEvent(SFSEvent.onConfigLoadFailure, loc2);
            dispatchEvent(loc3);
            return;
        }

        public function getActiveRoom():it.gotoandplay.smartfoxserver.data.Room
        {
            return roomList[activeRoomId];
        }

        public function getBuddyRoom(arg1:Object):void
        {
            if (arg1.id != -1)
            {
                send({"t":"sys", "bid":arg1.id}, "roomB", -1, "<b id=\'" + arg1.id + "\' />");
            }
            return;
        }

        private function checkBuddyDuplicates(arg1:String):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = false;
            loc4 = 0;
            loc5 = buddyList;
            for each (loc3 in loc5)
            {
                if (loc3.name != arg1)
                {
                    continue;
                }
                loc2 = true;
                break;
            }
            return loc2;
        }

        private function handleHttpClose(arg1:it.gotoandplay.smartfoxserver.http.HttpEvent):void
        {
            var loc2:*;

            initialize();
            loc2 = new SFSEvent(SFSEvent.onConnectionLost, {});
            dispatchEvent(loc2);
            return;
        }

        private function getXmlRoomVariable(arg1:Object):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = arg1.name.toString();
            loc3 = arg1.val;
            loc4 = arg1.priv ? "1" : "0";
            loc5 = arg1.persistent ? "1" : "0";
            loc6 = null;
            if ((loc7 = typeof loc3) != "boolean")
            {
                if (loc7 != "number")
                {
                    if (loc7 != "string")
                    {
                        if (loc3 == null && loc7 == "object" || loc7 == "undefined")
                        {
                            loc6 = "x";
                            loc3 = "";
                        }
                    }
                    else 
                    {
                        loc6 = "s";
                    }
                }
                else 
                {
                    loc6 = "n";
                }
            }
            else 
            {
                loc6 = "b";
                loc3 = loc3 ? "1" : "0";
            }
            if (loc6 != null)
            {
                return "<var n=\'" + loc2 + "\' t=\'" + loc6 + "\' pr=\'" + loc4 + "\' pe=\'" + loc5 + "\'><![CDATA[" + loc3 + "]]></var>";
            }
            return "";
        }

        public function getBuddyById(arg1:int):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = buddyList;
            for each (loc2 in loc4)
            {
                if (loc2.id != arg1)
                {
                    continue;
                }
                return loc2;
            }
            return null;
        }

        private function handleSocketDisconnection(arg1:flash.events.Event):void
        {
            var loc2:*;

            initialize();
            loc2 = new SFSEvent(SFSEvent.onConnectionLost, {});
            dispatchEvent(loc2);
            return;
        }

        private function handleSocketError(arg1:flash.events.SecurityErrorEvent):void
        {
            debugMessage("Socket Error: " + arg1.text);
            return;
        }

        private function xmlReceived(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = new XML(arg1);
            loc3 = loc2.t;
            loc4 = loc2.body.action;
            loc5 = loc2.body.r;
            if ((loc6 = messageHandlers[loc3]) != null)
            {
                loc6.handleMessage(loc2, XTMSG_TYPE_XML);
            }
            return;
        }

        public function switchSpectator(arg1:int=-1):void
        {
            if (arg1 == -1)
            {
                arg1 = activeRoomId;
            }
            send({"t":"sys"}, "swSpec", arg1, "");
            return;
        }

        public function roundTripBench():void
        {
            this.benchStartTime = getTimer();
            send({"t":"sys"}, "roundTrip", activeRoomId, "");
            return;
        }

        private function handleHttpError(arg1:it.gotoandplay.smartfoxserver.http.HttpEvent):void
        {
            trace("HttpError");
            if (!connected)
            {
                dispatchConnectionError();
            }
            return;
        }

        public function joinRoom(arg1:*, arg2:String="", arg3:Boolean=false, arg4:Boolean=false, arg5:int=-1):void
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;

            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = 0;
            loc12 = null;
            loc6 = -1;
            loc7 = arg3 ? 1 : 0;
            if (!this.changingRoom)
            {
                if (typeof arg1 != "number")
                {
                    if (typeof arg1 == "string")
                    {
                        loc13 = 0;
                        loc14 = roomList;
                        for each (loc8 in loc14)
                        {
                            if (loc8.getName() != arg1)
                            {
                                continue;
                            }
                            loc6 = loc8.getId();
                            break;
                        }
                    }
                }
                else 
                {
                    loc6 = int(arg1);
                }
                if (loc6 == -1)
                {
                    debugMessage("SmartFoxError: requested room to join does not exist!");
                }
                else 
                {
                    loc9 = {"t":"sys"};
                    loc10 = arg4 ? "0" : "1";
                    loc11 = (arg5 > -1) ? arg5 : activeRoomId;
                    if (activeRoomId == -1)
                    {
                        loc10 = "0";
                        loc11 = -1;
                    }
                    loc12 = "<room id=\'" + loc6 + "\' pwd=\'" + arg2 + "\' spec=\'" + loc7 + "\' leave=\'" + loc10 + "\' old=\'" + loc11 + "\' />";
                    send(loc9, "joinRoom", activeRoomId, loc12);
                    changingRoom = true;
                }
            }
            return;
        }

        public function get httpPollSpeed():int
        {
            return this._httpPollSpeed;
        }

        public function uploadFile(arg1:flash.net.FileReference, arg2:int=-1, arg3:String="", arg4:int=-1):void
        {
            if (arg2 == -1)
            {
                arg2 = this.myUserId;
            }
            if (arg3 == "")
            {
                arg3 = this.myUserName;
            }
            if (arg4 == -1)
            {
                arg4 = this.httpPort;
            }
            arg1.upload(new URLRequest("http://" + this.ipAddress + ":" + arg4 + "/default/Upload.py?id=" + arg2 + "&nick=" + arg3));
            debugMessage("[UPLOAD]: http://" + this.ipAddress + ":" + arg4 + "/default/Upload.py?id=" + arg2 + "&nick=" + arg3);
            return;
        }

        private function debugMessage(arg1:String):void
        {
            var loc2:*;

            loc2 = null;
            if (this.debug)
            {
                trace(arg1);
                loc2 = new SFSEvent(SFSEvent.onDebugMessage, {"message":arg1});
                dispatchEvent(loc2);
            }
            return;
        }

        private function makeXmlHeader(arg1:Object):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = "<msg";
            loc4 = 0;
            loc5 = arg1;
            for (loc3 in loc5)
            {
                loc2 = loc2 + " " + loc3 + "=\'" + arg1[loc3] + "\'";
            }
            loc2 = loc2 + ">";
            return loc2;
        }

        public function getRoomByName(arg1:String):it.gotoandplay.smartfoxserver.data.Room
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = null;
            loc4 = 0;
            loc5 = roomList;
            for each (loc3 in loc5)
            {
                if (loc3.getName() != arg1)
                {
                    continue;
                }
                loc2 = loc3;
                break;
            }
            return loc2;
        }

        public function loadBuddyList():void
        {
            send({"t":"sys"}, "loadB", -1, "");
            return;
        }

        private function handleSocketConnection(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {"t":"sys"};
            loc3 = "<ver v=\'" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "\' />";
            send(loc2, "verChk", 0, loc3);
            return;
        }

        public function set httpPollSpeed(arg1:int):void
        {
            if (arg1 >= 0 && arg1 <= 10000)
            {
                this._httpPollSpeed = arg1;
            }
            return;
        }

        public function leaveRoom(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {"t":"sys"};
            loc3 = "<rm id=\'" + arg1 + "\' />";
            send(loc2, "leaveRoom", arg1, loc3);
            return;
        }

        private function strReceived(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.substr(1, arg1.length - 2).split(MSG_STR);
            loc3 = loc2[0];
            if ((loc4 = messageHandlers[loc3]) != null)
            {
                loc4.handleMessage(loc2.splice(1, (loc2.length - 1)), XTMSG_TYPE_STR);
            }
            return;
        }

        private function addMessageHandler(arg1:String, arg2:it.gotoandplay.smartfoxserver.handlers.IMessageHandler):void
        {
            if (this.messageHandlers[arg1] != null)
            {
                debugMessage("Warning, message handler called: " + arg1 + " already exist!");
            }
            else 
            {
                this.messageHandlers[arg1] = arg2;
            }
            return;
        }

        public function getAllRooms():Array
        {
            return roomList;
        }

        public function getRoom(arg1:int):it.gotoandplay.smartfoxserver.data.Room
        {
            return roomList[arg1];
        }

        private function tryBlueBoxConnection(arg1:flash.events.ErrorEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = 0;
            if (connected)
            {
                dispatchEvent(arg1);
                debugMessage("[WARN] Connection error: " + arg1.text);
            }
            else 
            {
                if (smartConnect)
                {
                    debugMessage("Socket connection failed. Trying BlueBox");
                    isHttpMode = true;
                    loc2 = (blueBoxIpAddress == null) ? ipAddress : blueBoxIpAddress;
                    loc3 = (blueBoxPort == 0) ? httpPort : blueBoxPort;
                    httpConnection.connect(loc2, loc3);
                }
                else 
                {
                    dispatchConnectionError();
                }
            }
            return;
        }

        private function handleSocketData(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = 0;
            loc2 = socketConnection.bytesAvailable;
            while (--loc2 >= 0) 
            {
                loc3 = socketConnection.readByte();
                if (loc3 != 0)
                {
                    byteBuffer.writeByte(loc3);
                    continue;
                }
                handleMessage(byteBuffer.toString());
                byteBuffer = new ByteArray();
            }
            return;
        }

        public function setBuddyVariables(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc2 = {"t":"sys"};
            loc3 = "<vars>";
            loc6 = 0;
            loc7 = arg1;
            for (loc4 in loc7)
            {
                loc5 = arg1[loc4];
                if (myBuddyVars[loc4] == loc5)
                {
                    continue;
                }
                myBuddyVars[loc4] = loc5;
                loc3 = loc3 + "<var n=\'" + loc4 + "\'><![CDATA[" + loc5 + "]]></var>";
            }
            loc3 = loc3 + "</vars>";
            this.send(loc2, "setBvars", -1, loc3);
            return;
        }

        private function handleSecurityError(arg1:flash.events.SecurityErrorEvent):void
        {
            tryBlueBoxConnection(arg1);
            return;
        }

        private function handleIOError(arg1:flash.events.IOErrorEvent):void
        {
            tryBlueBoxConnection(arg1);
            return;
        }

        private function dispatchConnectionError():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = {};
            loc1.success = false;
            loc1.error = "I/O Error";
            loc2 = new SFSEvent(SFSEvent.onConnection, loc1);
            dispatchEvent(loc2);
            return;
        }

        public function login(arg1:String, arg2:String, arg3:String):void
        {
            var loc4:*;
            var loc5:*;

            loc4 = {"t":"sys"};
            loc5 = "<login z=\'" + arg1 + "\'><nick><![CDATA[" + arg2 + "]]></nick><pword><![CDATA[" + arg3 + "]]></pword></login>";
            send(loc4, "login", 0, loc5);
            return;
        }

        public function __logout():void
        {
            initialize(true);
            return;
        }

        private function setupMessageHandlers():void
        {
            sysHandler = new SysHandler(this);
            extHandler = new ExtHandler(this);
            addMessageHandler("sys", sysHandler);
            addMessageHandler("xt", extHandler);
            return;
        }

        public function autoJoin():void
        {
            var loc1:*;

            loc1 = {"t":"sys"};
            this.send(loc1, "autoJoin", this.activeRoomId ? this.activeRoomId : -1, "");
            return;
        }

        private function onConfigLoadSuccess(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc2 = arg1.target as URLLoader;
            loc3 = new XML(loc2.data);
            this.blueBoxIpAddress = loc5 = loc3.ip;
            this.ipAddress = loc5;
            this.port = int(loc3.port);
            this.defaultZone = loc3.zone;
            if (loc3.blueBoxIpAddress != undefined)
            {
                this.blueBoxIpAddress = loc3.blueBoxIpAddress;
            }
            if (loc3.blueBoxPort != undefined)
            {
                this.blueBoxPort = loc3.blueBoxPort;
            }
            if (loc3.debug != undefined)
            {
                this.debug = (loc3.debug.toLowerCase() != "true") ? false : true;
            }
            if (loc3.smartConnect != undefined)
            {
                this.smartConnect = (loc3.smartConnect.toLowerCase() != "true") ? false : true;
            }
            if (loc3.httpPort != undefined)
            {
                this.httpPort = int(loc3.httpPort);
            }
            if (loc3.httpPollSpeed != undefined)
            {
                this.httpPollSpeed = int(loc3.httpPollSpeed);
            }
            if (loc3.rawProtocolSeparator != undefined)
            {
                rawProtocolSeparator = loc3.rawProtocolSeparator;
            }
            if (autoConnectOnConfigSuccess)
            {
                this.connect(ipAddress, port);
            }
            else 
            {
                loc4 = new SFSEvent(SFSEvent.onConfigLoadSuccess, {});
                dispatchEvent(loc4);
            }
            return;
        }

        private function send(arg1:Object, arg2:String, arg3:Number, arg4:String):void
        {
            var loc5:*;

            loc5 = (loc5 = makeXmlHeader(arg1)) + "<body action=\'" + arg2 + "\' r=\'" + arg3 + "\'>" + arg4 + "</body>" + closeHeader();
            debugMessage("[Sending]: " + loc5 + "\n");
            if (isHttpMode)
            {
                httpConnection.send(loc5);
            }
            else 
            {
                writeToSocket(loc5);
            }
            return;
        }

        public function logout():void
        {
            var loc1:*;

            loc1 = {"t":"sys"};
            send(loc1, "logout", -1, "");
            return;
        }

        public function getRoomList():void
        {
            var loc1:*;

            loc1 = {"t":"sys"};
            send(loc1, "getRmList", activeRoomId, "");
            return;
        }

        public function getConnectionMode():String
        {
            var loc1:*;

            loc1 = CONNECTION_MODE_DISCONNECTED;
            if (this.isConnected)
            {
                if (this.isHttpMode)
                {
                    loc1 = CONNECTION_MODE_HTTP;
                }
                else 
                {
                    loc1 = CONNECTION_MODE_SOCKET;
                }
            }
            return loc1;
        }

        public function disconnect():void
        {
            connected = false;
            if (isHttpMode)
            {
                httpConnection.close();
            }
            else 
            {
                socketConnection.close();
            }
            sysHandler.dispatchDisconnection();
            return;
        }

        public function clearRoomList():void
        {
            this.roomList = [];
            return;
        }

        public function sendJson(arg1:String):void
        {
            debugMessage("[Sending - JSON]: " + arg1 + "\n");
            if (isHttpMode)
            {
                httpConnection.send(arg1);
            }
            else 
            {
                writeToSocket(arg1);
            }
            return;
        }

        public function setRoomVariables(arg1:Array, arg2:int=-1, arg3:Boolean=true):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = null;
            loc6 = null;
            if (arg2 == -1)
            {
                arg2 = activeRoomId;
            }
            loc4 = {"t":"sys"};
            if (arg3)
            {
                loc5 = "<vars>";
            }
            else 
            {
                loc5 = "<vars so=\'0\'>";
            }
            loc7 = 0;
            loc8 = arg1;
            for each (loc6 in loc8)
            {
                loc5 = loc5 + getXmlRoomVariable(loc6);
            }
            loc5 = loc5 + "</vars>";
            send(loc4, "setRvars", arg2, loc5);
            return;
        }

        public function addBuddy(arg1:String):void
        {
            var loc2:*;

            loc2 = null;
            if (!(arg1 == myUserName) && !checkBuddyDuplicates(arg1))
            {
                loc2 = "<n>" + arg1 + "</n>";
                send({"t":"sys"}, "addB", -1, loc2);
            }
            return;
        }

        private function initialize(arg1:Boolean=false):void
        {
            this.changingRoom = false;
            this.amIModerator = false;
            this.playerId = -1;
            this.activeRoomId = -1;
            this.myUserId = -1;
            this.myUserName = "";
            this.roomList = [];
            this.buddyList = [];
            this.myBuddyVars = [];
            if (!arg1)
            {
                this.connected = false;
                this.isHttpMode = false;
            }
            return;
        }

        public function getVersion():String
        {
            return this.majVersion + "." + this.minVersion + "." + this.subVersion;
        }

        public function setUserVariables(arg1:Object, arg2:int=-1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            if (arg2 == -1)
            {
                arg2 = activeRoomId;
            }
            loc3 = {"t":"sys"};
            (loc5 = (loc4 = getActiveRoom()).getUser(myUserId)).setVariables(arg1);
            loc6 = getXmlUserVariable(arg1);
            send(loc3, "setUvars", arg2, loc6);
            return;
        }

        public function sendPrivateMessage(arg1:String, arg2:int, arg3:int=-1):void
        {
            var loc4:*;
            var loc5:*;

            if (arg3 == -1)
            {
                arg3 = activeRoomId;
            }
            loc4 = {"t":"sys"};
            loc5 = "<txt rcp=\'" + arg2 + "\'><![CDATA[" + Entities.encodeEntities(arg1) + "]]></txt>";
            send(loc4, "prvMsg", arg3, loc5);
            return;
        }

        public function getBuddyByName(arg1:String):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = buddyList;
            for each (loc2 in loc4)
            {
                if (loc2.name != arg1)
                {
                    continue;
                }
                return loc2;
            }
            return null;
        }

        private function closeHeader():String
        {
            return "</msg>";
        }

        public function sendPublicMessage(arg1:String, arg2:int=-1):void
        {
            var loc3:*;
            var loc4:*;

            if (arg2 == -1)
            {
                arg2 = activeRoomId;
            }
            loc3 = {"t":"sys"};
            loc4 = "<txt><![CDATA[" + Entities.encodeEntities(arg1) + "]]></txt>";
            send(loc3, "pubMsg", arg2, loc4);
            return;
        }

        public function clearBuddyList():void
        {
            var loc1:*;
            var loc2:*;

            buddyList = [];
            send({"t":"sys"}, "clearB", -1, "");
            loc1 = {};
            loc1.list = buddyList;
            loc2 = new SFSEvent(SFSEvent.onBuddyList, loc1);
            dispatchEvent(loc2);
            return;
        }

        public function sendString(arg1:String):void
        {
            debugMessage("[Sending - STR]: " + arg1 + "\n");
            if (isHttpMode)
            {
                httpConnection.send(arg1);
            }
            else 
            {
                writeToSocket(arg1);
            }
            return;
        }

        public function removeBuddy(arg1:String):void
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

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc2 = false;
            loc9 = 0;
            loc10 = buddyList;
            for (loc4 in loc10)
            {
                loc3 = buddyList[loc4];
                if (loc3.name != arg1)
                {
                    continue;
                }
                delete buddyList[loc4];
                loc2 = true;
                break;
            }
            if (loc2)
            {
                loc5 = {"t":"sys"};
                loc6 = "<n>" + arg1 + "</n>";
                send(loc5, "remB", -1, loc6);
                (loc7 = {}).list = buddyList;
                loc8 = new SFSEvent(SFSEvent.onBuddyList, loc7);
                dispatchEvent(loc8);
            }
            return;
        }

        public function setBuddyBlockStatus(arg1:String, arg2:Boolean):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc3 = getBuddyByName(arg1);
            if (loc3 != null)
            {
                if (loc3.blocked != arg2)
                {
                    loc3.isBlocked = arg2;
                    loc4 = "<n x=\'" + arg2 ? "1" : "0" + "\'>" + arg1 + "</n>";
                    send({"t":"sys"}, "setB", -1, loc4);
                    (loc5 = {}).buddy = loc3;
                    loc6 = new SFSEvent(SFSEvent.onBuddyListUpdate, loc5);
                    dispatchEvent(loc6);
                }
            }
            return;
        }

        private function handleMessage(arg1:String):void
        {
            var loc2:*;

            if (arg1 != "ok")
            {
                debugMessage("[ RECEIVED ]: " + arg1 + ", (len: " + arg1.length + ")");
            }
            loc2 = arg1.charAt(0);
            if (loc2 != MSG_XML)
            {
                if (loc2 != MSG_STR)
                {
                    if (loc2 == MSG_JSON)
                    {
                        jsonReceived(arg1);
                    }
                }
                else 
                {
                    strReceived(arg1);
                }
            }
            else 
            {
                xmlReceived(arg1);
            }
            return;
        }

        public function getUploadPath():String
        {
            return "http://" + this.ipAddress + ":" + this.httpPort + "/default/uploads/";
        }

        private function handleHttpData(arg1:it.gotoandplay.smartfoxserver.http.HttpEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = 0;
            loc2 = arg1.params.data as String;
            loc3 = loc2.split("\n");
            if (loc3[0] != "")
            {
                loc5 = 0;
                while (loc5 < (loc3.length - 1)) 
                {
                    if ((loc4 = loc3[loc5]).length > 0)
                    {
                        handleMessage(loc4);
                    }
                    ++loc5;
                }
                if (this._httpPollSpeed > 0)
                {
                    setTimeout(this.handleDelayedPoll, this._httpPollSpeed);
                }
                else 
                {
                    handleDelayedPoll();
                }
            }
            return;
        }

        public function loadConfig(arg1:String="config.xml", arg2:Boolean=true):void
        {
            var loc3:*;

            this.autoConnectOnConfigSuccess = arg2;
            loc3 = new URLLoader();
            loc3.addEventListener(Event.COMPLETE, onConfigLoadSuccess);
            loc3.addEventListener(IOErrorEvent.IO_ERROR, onConfigLoadFailure);
            loc3.load(new URLRequest(arg1));
            return;
        }

        public function sendXtMessage(arg1:String, arg2:String, arg3:*, arg4:String="xml", arg5:int=-1):void
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = NaN;
            loc11 = null;
            loc12 = null;
            loc13 = null;
            if (arg5 == -1)
            {
                arg5 = activeRoomId;
            }
            if (arg4 != XTMSG_TYPE_XML)
            {
                if (arg4 != XTMSG_TYPE_STR)
                {
                    if (arg4 == XTMSG_TYPE_JSON)
                    {
                        (loc11 = {}).x = arg1;
                        loc11.c = arg2;
                        loc11.r = arg5;
                        loc11.p = arg3;
                        (loc12 = {}).t = "xt";
                        loc12.b = loc11;
                        loc13 = JSON.encode(loc12);
                        sendJson(loc13);
                    }
                }
                else 
                {
                    loc9 = MSG_STR + "xt" + MSG_STR + arg1 + MSG_STR + arg2 + MSG_STR + arg5 + MSG_STR;
                    loc10 = 0;
                    while (loc10 < arg3.length) 
                    {
                        loc9 = loc9 + arg3[loc10].toString() + MSG_STR;
                        loc10 = (loc10 + 1);
                    }
                    sendString(loc9);
                }
            }
            else 
            {
                loc6 = {"t":"xt"};
                loc7 = {"name":arg1, "cmd":arg2, "param":arg3};
                loc8 = "<![CDATA[" + ObjectSerializer.getInstance().serialize(loc7) + "]]>";
                send(loc6, "xtReq", arg5, loc8);
            }
            return;
        }

        public function set rawProtocolSeparator(arg1:String):void
        {
            if (!(arg1 == "<") && !(arg1 == "{"))
            {
                MSG_STR = arg1;
            }
            return;
        }

        private function writeToSocket(arg1:String):void
        {
            var loc2:*;

            loc2 = new ByteArray();
            loc2.writeMultiByte(arg1, "utf-8");
            loc2.writeByte(0);
            socketConnection.writeBytes(loc2);
            socketConnection.flush();
            return;
        }

        public function sendObjectToGroup(arg1:Object, arg2:Array, arg3:int=-1):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            if (arg3 == -1)
            {
                arg3 = activeRoomId;
            }
            loc4 = "";
            loc8 = 0;
            loc9 = arg2;
            for (loc5 in loc9)
            {
                if (isNaN(arg2[loc5]))
                {
                    continue;
                }
                loc4 = loc4 + arg2[loc5] + ",";
            }
            loc4 = loc4.substr(0, (loc4.length - 1));
            arg1._$$_ = loc4;
            loc6 = {"t":"sys"};
            loc7 = "<![CDATA[" + ObjectSerializer.getInstance().serialize(arg1) + "]]>";
            send(loc6, "asObjG", arg3, loc7);
            return;
        }

        public function get rawProtocolSeparator():String
        {
            return MSG_STR;
        }

        public function getRandomKey():void
        {
            send({"t":"sys"}, "rndK", -1, "");
            return;
        }

        public function sendObject(arg1:Object, arg2:int=-1):void
        {
            var loc3:*;
            var loc4:*;

            if (arg2 == -1)
            {
                arg2 = activeRoomId;
            }
            loc3 = "<![CDATA[" + ObjectSerializer.getInstance().serialize(arg1) + "]]>";
            loc4 = {"t":"sys"};
            send(loc4, "asObj", arg2, loc3);
            return;
        }

        public function connect(arg1:String, arg2:int=9339):void
        {
            if (connected)
            {
                debugMessage("*** ALREADY CONNECTED ***");
            }
            else 
            {
                initialize();
                this.ipAddress = arg1;
                this.port = arg2;
                socketConnection.connect(arg1, arg2);
            }
            return;
        }

        public function sendBuddyPermissionResponse(arg1:Boolean, arg2:String):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = {"t":"sys"};
            loc4 = "<n res=\'" + arg1 ? "g" : "r" + "\'>" + arg2 + "</n>";
            send(loc3, "bPrm", -1, loc4);
            return;
        }

        public function sendModeratorMessage(arg1:String, arg2:String, arg3:int=-1):void
        {
            var loc4:*;
            var loc5:*;

            loc4 = {"t":"sys"};
            loc5 = "<txt t=\'" + arg2 + "\' id=\'" + arg3 + "\'><![CDATA[" + Entities.encodeEntities(arg1) + "]]></txt>";
            send(loc4, "modMsg", activeRoomId, loc5);
            return;
        }

        public function getBenchStartTime():int
        {
            return this.benchStartTime;
        }

        public function createRoom(arg1:Object, arg2:int=-1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc9 = null;
            if (arg2 == -1)
            {
                arg2 = activeRoomId;
            }
            loc3 = {"t":"sys"};
            loc4 = arg1.isGame ? "1" : "0";
            loc5 = "1";
            loc6 = (arg1.maxUsers != null) ? String(arg1.maxUsers) : "0";
            loc7 = (arg1.maxSpectators != null) ? String(arg1.maxSpectators) : "0";
            if (arg1.isGame && !(arg1.exitCurrent == null))
            {
                loc5 = arg1.exitCurrent ? "1" : "0";
            }
            loc8 = (loc8 = (loc8 = (loc8 = "<room tmp=\'1\' gam=\'" + loc4 + "\' spec=\'" + loc7 + "\' exit=\'" + loc5 + "\'>") + "<name><![CDATA[" + (arg1.name != null) ? arg1.name : "" + "]]></name>") + "<pwd><![CDATA[" + (arg1.password != null) ? arg1.password : "" + "]]></pwd>") + "<max>" + loc6 + "</max>";
            if (arg1.uCount != null)
            {
                loc8 = loc8 + "<uCnt>" + arg1.uCount ? "1" : "0" + "</uCnt>";
            }
            if (arg1.extension != null)
            {
                loc8 = (loc8 = loc8 + "<xt n=\'" + arg1.extension.name) + "\' s=\'" + arg1.extension.script + "\' />";
            }
            if (arg1.vars != null)
            {
                loc8 = loc8 + "<vars>";
                loc10 = 0;
                loc11 = arg1.vars;
                for (loc9 in loc11)
                {
                    loc8 = loc8 + getXmlRoomVariable(arg1.vars[loc9]);
                }
                loc8 = loc8 + "</vars>";
            }
            else 
            {
                loc8 = loc8 + "<vars></vars>";
            }
            loc8 = loc8 + "</room>";
            send(loc3, "createRoom", arg2, loc8);
            return;
        }

        private function handleDelayedPoll():void
        {
            httpConnection.send(HTTP_POLL_REQUEST);
            return;
        }

        private function handleHttpConnect(arg1:it.gotoandplay.smartfoxserver.http.HttpEvent):void
        {
            this.handleSocketConnection(null);
            connected = true;
            httpConnection.send(HTTP_POLL_REQUEST);
            return;
        }

        public function set isConnected(arg1:Boolean):void
        {
            this.connected = arg1;
            return;
        }

        public function get isConnected():Boolean
        {
            return this.connected;
        }

        
        {
            MSG_STR = "%";
            MIN_POLL_SPEED = 0;
            DEFAULT_POLL_SPEED = 750;
            MAX_POLL_SPEED = 10000;
            HTTP_POLL_REQUEST = "poll";
        }

        public static const CONNECTION_MODE_HTTP:String="http";

        private static const MSG_JSON:String="{";

        public static const MODMSG_TO_USER:String="u";

        public static const XTMSG_TYPE_XML:String="xml";

        private static const MSG_XML:String="<";

        public static const MODMSG_TO_ROOM:String="r";

        private static const EOM:int=0;

        public static const XTMSG_TYPE_STR:String="str";

        public static const CONNECTION_MODE_SOCKET:String="socket";

        public static const MODMSG_TO_ZONE:String="z";

        public static const CONNECTION_MODE_DISCONNECTED:String="disconnected";

        public static const XTMSG_TYPE_JSON:String="json";

        private var autoConnectOnConfigSuccess:Boolean=false;

        private var connected:Boolean;

        private var benchStartTime:int;

        public var myUserId:int;

        private var _httpPollSpeed:int;

        private var minVersion:Number;

        private var roomList:Array;

        public var httpPort:int=8080;

        public var blueBoxPort:Number=0;

        public var debug:Boolean;

        private var byteBuffer:flash.utils.ByteArray;

        private var subVersion:Number;

        public var port:int=9339;

        public var buddyList:Array;

        private var httpConnection:it.gotoandplay.smartfoxserver.http.HttpConnection;

        public var defaultZone:String;

        private var messageHandlers:Array;

        private var isHttpMode:Boolean=false;

        private var majVersion:Number;

        private var socketConnection:flash.net.Socket;

        public var blueBoxIpAddress:String;

        private var sysHandler:it.gotoandplay.smartfoxserver.handlers.SysHandler;

        public var myUserName:String;

        public var myBuddyVars:Array;

        public var ipAddress:String;

        public var playerId:int;

        public var smartConnect:Boolean=true;

        public var amIModerator:Boolean;

        private var extHandler:it.gotoandplay.smartfoxserver.handlers.ExtHandler;

        public var changingRoom:Boolean;

        public var activeRoomId:int;

        private static var MAX_POLL_SPEED:Number=10000;

        private static var DEFAULT_POLL_SPEED:Number=750;

        private static var MIN_POLL_SPEED:Number=0;

        private static var HTTP_POLL_REQUEST:String="poll";

        private static var MSG_STR:String="%";
    }
}
