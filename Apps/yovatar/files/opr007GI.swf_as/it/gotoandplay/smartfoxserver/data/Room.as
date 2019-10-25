package it.gotoandplay.smartfoxserver.data 
{
    public class Room extends Object
    {
        public function Room(arg1:int, arg2:String, arg3:int, arg4:int, arg5:Boolean, arg6:Boolean, arg7:Boolean, arg8:Boolean, arg9:int=0, arg10:int=0)
        {
            super();
            this.id = arg1;
            this.name = arg2;
            this.maxSpectators = arg4;
            this.maxUsers = arg3;
            this.temp = arg5;
            this.game = arg6;
            this.priv = arg7;
            this.limbo = arg8;
            this.userCount = arg9;
            this.specCount = arg10;
            this.userList = [];
            this.variables = [];
            return;
        }

        public function getUser(arg1:*):it.gotoandplay.smartfoxserver.data.User
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc2 = null;
            if (typeof arg1 != "number")
            {
                if (typeof arg1 == "string")
                {
                    loc5 = 0;
                    loc6 = userList;
                    for (loc3 in loc6)
                    {
                        if ((loc4 = this.userList[loc3]).getName() != arg1)
                        {
                            continue;
                        }
                        loc2 = loc4;
                        break;
                    }
                }
            }
            else 
            {
                loc2 = userList[arg1];
            }
            return loc2;
        }

        public function setUserCount(arg1:int):void
        {
            this.userCount = arg1;
            return;
        }

        public function getMyPlayerIndex():int
        {
            return this.myPlayerIndex;
        }

        public function removeUser(arg1:int):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = userList[arg1];
            if (this.game && loc2.isSpectator())
            {
                specCount--;
            }
            else 
            {
                userCount--;
            }
            delete userList[arg1];
            return;
        }

        public function addUser(arg1:it.gotoandplay.smartfoxserver.data.User, arg2:int):void
        {
            var loc3:*;
            var loc4:*;

            userList[arg2] = arg1;
            if (this.game && arg1.isSpectator())
            {
                specCount++;
            }
            else 
            {
                userCount++;
            }
            return;
        }

        public function getUserCount():int
        {
            return this.userCount;
        }

        public function getId():int
        {
            return this.id;
        }

        public function setIsLimbo(arg1:Boolean):void
        {
            this.limbo = arg1;
            return;
        }

        public function getVariables():Array
        {
            return variables;
        }

        public function isLimbo():Boolean
        {
            return this.limbo;
        }

        public function getMaxUsers():int
        {
            return this.maxUsers;
        }

        public function getMaxSpectators():int
        {
            return this.maxSpectators;
        }

        public function getName():String
        {
            return this.name;
        }

        public function isPrivate():Boolean
        {
            return this.priv;
        }

        public function setSpectatorCount(arg1:int):void
        {
            this.specCount = arg1;
            return;
        }

        public function clearVariables():void
        {
            this.variables = [];
            return;
        }

        public function isTemp():Boolean
        {
            return this.temp;
        }

        public function setVariables(arg1:Array):void
        {
            this.variables = arg1;
            return;
        }

        public function getSpectatorCount():int
        {
            return this.specCount;
        }

        public function getVariable(arg1:String):*
        {
            return variables[arg1];
        }

        public function setMyPlayerIndex(arg1:int):void
        {
            this.myPlayerIndex = arg1;
            return;
        }

        public function isGame():Boolean
        {
            return this.game;
        }

        public function clearUserList():void
        {
            this.userList = [];
            this.userCount = 0;
            this.specCount = 0;
            return;
        }

        public function getUserList():Array
        {
            return this.userList;
        }

        private var maxSpectators:int;

        private var maxUsers:int;

        private var userList:Array;

        private var name:String;

        private var userCount:int;

        private var specCount:int;

        private var temp:Boolean;

        private var limbo:Boolean;

        private var id:int;

        private var myPlayerIndex:int;

        private var game:Boolean;

        private var variables:Array;

        private var priv:Boolean;
    }
}
