package com.adobe.serialization.json 
{
    import flash.utils.*;
    
    public class JSONEncoder extends Object
    {
        public function JSONEncoder(arg1:*)
        {
            super();
            jsonString = convertToString(arg1);
            return;
        }

        private function escapeString(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = null;
            loc6 = null;
            loc7 = null;
            loc2 = "";
            loc4 = arg1.length;
            loc5 = 0;
            while (loc5 < loc4) 
            {
                loc3 = arg1.charAt(loc5);
                loc8 = loc3;
                switch (loc8) 
                {
                    case "\"":
                        loc2 = loc2 + "\\\"";
                        break;
                    case "\\":
                        loc2 = loc2 + "\\\\";
                        break;
                    case "":
                        loc2 = loc2 + "\\b";
                        break;
                    case "":
                        loc2 = loc2 + "\\f";
                        break;
                    case "\n":
                        loc2 = loc2 + "\\n";
                        break;
                    case "\r":
                        loc2 = loc2 + "\\r";
                        break;
                    case "\t":
                        loc2 = loc2 + "\\t";
                        break;
                    default:
                        if (loc3 < " ")
                        {
                            loc7 = ((loc6 = loc3.charCodeAt(0).toString(16)).length != 2) ? "000" : "00";
                            loc2 = loc2 + "\\u" + loc7 + loc6;
                        }
                        else 
                        {
                            loc2 = loc2 + loc3;
                        }
                }
                ++loc5;
            }
            return "\"" + loc2 + "\"";
        }

        private function arrayToString(arg1:Array):String
        {
            var loc2:*;
            var loc3:*;

            loc2 = "";
            loc3 = 0;
            while (loc3 < arg1.length) 
            {
                if (loc2.length > 0)
                {
                    loc2 = loc2 + ",";
                }
                loc2 = loc2 + convertToString(arg1[loc3]);
                ++loc3;
            }
            return "[" + loc2 + "]";
        }

        public function getString():String
        {
            return jsonString;
        }

        private function objectToString(arg1:Object):String
        {
            var classInfo:XML;
            var key:String;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var o:Object;
            var s:String;
            var v:XML;
            var value:Object;

            value = null;
            key = null;
            v = null;
            o = arg1;
            s = "";
            classInfo = describeType(o);
            if (classInfo.name.toString() != "Object")
            {
                loc3 = 0;
                loc6 = 0;
                loc7 = classInfo;
                loc5 = new XMLList("");
                for each (loc8 in loc7)
                {
                    with (loc9 = loc8)
                    {
                        if (name() == "variable" || name() == "accessor")
                        {
                            loc5[loc6] = loc8;
                        }
                    }
                }
                loc4 = loc5;
                for each (v in loc4)
                {
                    if (s.length > 0)
                    {
                        s = s + ",";
                    }
                    s = s + escapeString(v.name.toString()) + ":" + convertToString(o[v.name]);
                }
            }
            else 
            {
                loc3 = 0;
                loc4 = o;
                for (key in loc4)
                {
                    value = o[key];
                    if (value as Function)
                    {
                        continue;
                    }
                    if (s.length > 0)
                    {
                        s = s + ",";
                    }
                    s = s + escapeString(key) + ":" + convertToString(value);
                }
            }
            return "{" + s + "}";
        }

        private function convertToString(arg1:*):String
        {
            if (arg1 as String)
            {
                return escapeString(arg1 as String);
            }
            if (arg1 as Number)
            {
                return isFinite(arg1 as Number) ? arg1.toString() : "null";
            }
            if (arg1 as Boolean)
            {
                return arg1 ? "true" : "false";
            }
            if (arg1 as Array)
            {
                return arrayToString(arg1 as Array);
            }
            if (arg1 as Object && !(arg1 == null))
            {
                return objectToString(arg1);
            }
            return "null";
        }

        private var jsonString:String;
    }
}
