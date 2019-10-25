package it.gotoandplay.smartfoxserver.data 
{
    public class User extends Object
    {
        public function User(arg1:int, arg2:String)
        {
            super();
            this.id = arg1;
            this.name = arg2;
            this.variables = [];
            this.isSpec = false;
            this.isMod = false;
            return;
        }

        public function getName():String
        {
            return this.name;
        }

        public function clearVariables():void
        {
            this.variables = [];
            return;
        }

        public function getVariables():Array
        {
            return this.variables;
        }

        public function setModerator(arg1:Boolean):void
        {
            this.isMod = arg1;
            return;
        }

        public function isSpectator():Boolean
        {
            return this.isSpec;
        }

        public function getId():int
        {
            return this.id;
        }

        public function isModerator():Boolean
        {
            return this.isMod;
        }

        public function setVariables(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = 0;
            loc5 = arg1;
            for (loc2 in loc5)
            {
                loc3 = arg1[loc2];
                if (loc3 != null)
                {
                    this.variables[loc2] = loc3;
                    continue;
                }
                delete this.variables[loc2];
            }
            return;
        }

        public function getVariable(arg1:String):*
        {
            return this.variables[arg1];
        }

        public function setIsSpectator(arg1:Boolean):void
        {
            this.isSpec = arg1;
            return;
        }

        public function setPlayerId(arg1:int):void
        {
            this.pId = arg1;
            return;
        }

        public function getPlayerId():int
        {
            return this.pId;
        }

        private var isSpec:Boolean;

        private var pId:int;

        private var name:String;

        private var variables:Array;

        private var isMod:Boolean;

        private var id:int;
    }
}
