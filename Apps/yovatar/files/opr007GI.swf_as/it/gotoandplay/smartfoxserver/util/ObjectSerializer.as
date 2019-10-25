package it.gotoandplay.smartfoxserver.util 
{
    public class ObjectSerializer extends Object
    {
        public function ObjectSerializer(arg1:Boolean=false)
        {
            super();
            this.tabs = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
            setDebug(arg1);
            return;
        }

        public function serialize(arg1:Object):String
        {
            var loc2:*;

            loc2 = {};
            obj2xml(arg1, loc2);
            return loc2.xmlStr;
        }

        private function xml2obj(arg1:XML, arg2:Object):void
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
            var loc12:*;
            var loc13:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc3 = 0;
            loc4 = arg1.children();
            loc12 = 0;
            loc13 = loc4;
            for each (loc6 in loc13)
            {
                if ((loc5 = loc6.name().toString()) == "obj")
                {
                    loc7 = loc6.o;
                    if ((loc8 = loc6.t) != "a")
                    {
                        if (loc8 == "o")
                        {
                            arg2[loc7] = {};
                        }
                    }
                    else 
                    {
                        arg2[loc7] = [];
                    }
                    xml2obj(loc6, arg2[loc7]);
                    continue;
                }
                if (loc5 != "var")
                {
                    continue;
                }
                loc9 = loc6.n;
                loc10 = loc6.t;
                loc11 = loc6.toString();
                if (loc10 == "b")
                {
                    arg2[loc9] = (loc11 != "0") ? true : false;
                    continue;
                }
                if (loc10 == "n")
                {
                    arg2[loc9] = Number(loc11);
                    continue;
                }
                if (loc10 == "s")
                {
                    arg2[loc9] = loc11;
                    continue;
                }
                if (loc10 != "x")
                {
                    continue;
                }
                arg2[loc9] = null;
            }
            return;
        }

        private function setDebug(arg1:Boolean):void
        {
            this.debug = arg1;
            if (this.debug)
            {
                this.eof = "\n";
            }
            else 
            {
                this.eof = "";
            }
            return;
        }

        private function encodeEntities(arg1:String):String
        {
            return arg1;
        }

        private function obj2xml(arg1:Object, arg2:Object, arg3:int=0, arg4:String=""):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = undefined;
            if (arg3 != 0)
            {
                if (this.debug)
                {
                    arg2.xmlStr = arg2.xmlStr + this.tabs.substr(0, arg3);
                }
                loc6 = (arg1 as Array) ? "a" : "o";
                arg2.xmlStr = arg2.xmlStr + "<obj t=\'" + loc6 + "\' o=\'" + arg4 + "\'>" + this.eof;
            }
            else 
            {
                arg2.xmlStr = "<dataObj>" + this.eof;
            }
            loc9 = 0;
            loc10 = arg1;
            for (loc5 in loc10)
            {
                loc7 = typeof arg1[loc5];
                loc8 = arg1[loc5];
                if (loc7 == "boolean" || loc7 == "number" || loc7 == "string" || loc7 == "null")
                {
                    if (loc7 != "boolean")
                    {
                        if (loc7 != "null")
                        {
                            if (loc7 == "string")
                            {
                                loc8 = Entities.encodeEntities(loc8);
                            }
                        }
                        else 
                        {
                            loc7 = "x";
                            loc8 = "";
                        }
                    }
                    else 
                    {
                        loc8 = Number(loc8);
                    }
                    if (this.debug)
                    {
                        arg2.xmlStr = arg2.xmlStr + this.tabs.substr(0, arg3 + 1);
                    }
                    arg2.xmlStr = arg2.xmlStr + "<var n=\'" + loc5 + "\' t=\'" + loc7.substr(0, 1) + "\'>" + loc8 + "</var>" + this.eof;
                    continue;
                }
                if (loc7 != "object")
                {
                    continue;
                }
                obj2xml(loc8, arg2, arg3 + 1, loc5);
                if (this.debug)
                {
                    arg2.xmlStr = arg2.xmlStr + this.tabs.substr(0, arg3 + 1);
                }
                arg2.xmlStr = arg2.xmlStr + "</obj>" + this.eof;
            }
            if (arg3 == 0)
            {
                arg2.xmlStr = arg2.xmlStr + "</dataObj>" + this.eof;
            }
            return;
        }

        public function deserialize(arg1:String):Object
        {
            var loc2:*;
            var loc3:*;

            loc2 = new XML(arg1);
            loc3 = {};
            xml2obj(loc2, loc3);
            return loc3;
        }

        public static function getInstance(arg1:Boolean=false):it.gotoandplay.smartfoxserver.util.ObjectSerializer
        {
            if (instance == null)
            {
                instance = new ObjectSerializer(arg1);
            }
            return instance;
        }

        private var eof:String;

        private var debug:Boolean;

        private var tabs:String;

        private static var instance:it.gotoandplay.smartfoxserver.util.ObjectSerializer;
    }
}
