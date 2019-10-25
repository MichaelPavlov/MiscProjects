package MyLife 
{
    public class StringUtils extends Object
    {
        public function StringUtils()
        {
            super();
            return;
        }

        private static function _swapCase(arg1:String, ... rest):String
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = arg1.toLowerCase();
            loc4 = arg1.toUpperCase();
            loc5 = arg1;
            switch (loc5) 
            {
                case loc3:
                    return loc4;
                case loc4:
                    return loc3;
                default:
                    return arg1;
            }
        }

        public static function isEmpty(arg1:String):Boolean
        {
            if (arg1 == null)
            {
                return true;
            }
            return !arg1.length;
        }

        public static function remove(arg1:String, arg2:String, arg3:Boolean=true):String
        {
            var loc4:*;
            var loc5:*;

            if (arg1 == null)
            {
                return "";
            }
            loc4 = escapePattern(arg2);
            loc5 = arg3 ? "g" : "ig";
            return arg1.replace(new RegExp(loc4, loc5), "");
        }

        public static function countOf(arg1:String, arg2:String, arg3:Boolean=true):uint
        {
            var loc4:*;
            var loc5:*;

            if (arg1 == null)
            {
                return 0;
            }
            loc4 = escapePattern(arg2);
            loc5 = arg3 ? "g" : "ig";
            return arg1.match(new RegExp(loc4, loc5)).length;
        }

        public static function between(arg1:String, arg2:String, arg3:String):String
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc6 = 0;
            loc4 = "";
            if (arg1 == null)
            {
                return loc4;
            }
            if ((loc5 = arg1.indexOf(arg2)) != -1)
            {
                loc5 = loc5 + arg2.length;
                if ((loc6 = arg1.indexOf(arg3, loc5)) != -1)
                {
                    loc4 = arg1.substr(loc5, loc6 - loc5);
                }
            }
            return loc4;
        }

        public static function padRight(arg1:String, arg2:String, arg3:uint):String
        {
            var loc4:*;

            loc4 = arg1;
            while (loc4.length < arg3) 
            {
                loc4 = loc4 + arg2;
            }
            return loc4;
        }

        public static function isNumeric(arg1:String):Boolean
        {
            var loc2:*;

            if (arg1 == null)
            {
                return false;
            }
            loc2 = new RegExp("^[-+]?\\d*\\.?\\d+(?:[eE][-+]?\\d+)?$");
            return loc2.test(arg1);
        }

        public static function block(arg1:String, arg2:uint, arg3:String="."):Array
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc8 = null;
            loc4 = new Array();
            if (arg1 == null || !contains(arg1, arg3))
            {
                return loc4;
            }
            loc5 = 0;
            loc6 = arg1.length;
            loc7 = new RegExp("[^" + escapePattern(arg3) + "]+$");
            while (loc5 < loc6) 
            {
                loc8 = arg1.substr(loc5, arg2);
                if (!contains(loc8, arg3))
                {
                    loc4.push(truncate(loc8, loc8.length));
                    loc5 = loc5 + loc8.length;
                }
                loc8 = loc8.replace(loc7, "");
                loc4.push(loc8);
                loc5 = loc5 + loc8.length;
            }
            return loc4;
        }

        public static function trim(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.replace(new RegExp("^\\s+|\\s+$", "g"), "");
        }

        public static function beginsWith(arg1:String, arg2:String):Boolean
        {
            if (arg1 == null)
            {
                return false;
            }
            return arg1.indexOf(arg2) == 0;
        }

        public static function stripTags(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.replace(new RegExp("<\\/?[^>]+>", "igm"), "");
        }

        public static function afterLast(arg1:String, arg2:String):String
        {
            var loc3:*;

            if (arg1 == null)
            {
                return "";
            }
            loc3 = arg1.lastIndexOf(arg2);
            if (loc3 == -1)
            {
                return "";
            }
            loc3 = loc3 + arg2.length;
            return arg1.substr(loc3);
        }

        private static function _minimum(arg1:uint, arg2:uint, arg3:uint):uint
        {
            return Math.min(arg1, Math.min(arg2, Math.min(arg3, arg1)));
        }

        private static function escapePattern(arg1:String):String
        {
            return arg1.replace(new RegExp("(\\]|\\[|\\{|\\}|\\(|\\)|\\*|\\+|\\?|\\.|\\\\)", "g"), "\\$1");
        }

        public static function removeExtraWhitespace(arg1:String):String
        {
            var loc2:*;

            if (arg1 == null)
            {
                return "";
            }
            loc2 = trim(arg1);
            return loc2.replace(new RegExp("\\s+", "g"), " ");
        }

        public static function trimRight(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.replace(new RegExp("\\s+$"), "");
        }

        public static function endsWith(arg1:String, arg2:String):Boolean
        {
            return arg1.lastIndexOf(arg2) == arg1.length - arg2.length;
        }

        public static function contains(arg1:String, arg2:String):Boolean
        {
            if (arg1 == null)
            {
                return false;
            }
            return !(arg1.indexOf(arg2) == -1);
        }

        public static function properCase(arg1:String):String
        {
            var loc2:*;

            if (arg1 == null)
            {
                return "";
            }
            loc2 = arg1.toLowerCase().replace(new RegExp("\\b([^.?;!]+)"), capitalize);
            return loc2.replace(new RegExp("\\b[i]\\b"), "I");
        }

        public static function trimLeft(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.replace(new RegExp("^\\s+"), "");
        }

        public static function similarity(arg1:String, arg2:String):Number
        {
            var loc3:*;
            var loc4:*;

            loc3 = editDistance(arg1, arg2);
            if ((loc4 = Math.max(arg1.length, arg2.length)) == 0)
            {
                return 100;
            }
            return (1 - loc3 / loc4) * 100;
        }

        public static function wordCount(arg1:String):uint
        {
            if (arg1 == null)
            {
                return 0;
            }
            return arg1.match(new RegExp("\\b\\w+\\b", "g")).length;
        }

        public static function editDistance(arg1:String, arg2:String):uint
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc3 = 0;
            loc5 = 0;
            loc8 = 0;
            loc9 = null;
            loc10 = null;
            if (arg1 == null)
            {
                arg1 = "";
            }
            if (arg2 == null)
            {
                arg2 = "";
            }
            if (arg1 == arg2)
            {
                return 0;
            }
            loc4 = new Array();
            loc6 = arg1.length;
            loc7 = arg2.length;
            if (loc6 == 0)
            {
                return loc7;
            }
            if (loc7 == 0)
            {
                return loc6;
            }
            loc3 = 0;
            while (loc3 <= loc6) 
            {
                loc4[loc3] = new Array();
                loc3 = (loc3 + 1);
            }
            loc3 = 0;
            while (loc3 <= loc6) 
            {
                loc4[loc3][0] = loc3;
                loc3 = (loc3 + 1);
            }
            loc8 = 0;
            while (loc8 <= loc7) 
            {
                loc4[0][loc8] = loc8;
                loc8 = (loc8 + 1);
            }
            loc3 = 1;
            while (loc3 <= loc6) 
            {
                loc9 = arg1.charAt((loc3 - 1));
                loc8 = 1;
                while (loc8 <= loc7) 
                {
                    loc10 = arg2.charAt((loc8 - 1));
                    if (loc9 != loc10)
                    {
                        loc5 = 1;
                    }
                    else 
                    {
                        loc5 = 0;
                    }
                    loc4[loc3][loc8] = _minimum(loc4[(loc3 - 1)][loc8] + 1, loc4[loc3][(loc8 - 1)] + 1, loc4[(loc3 - 1)][(loc8 - 1)] + loc5);
                    loc8 = (loc8 + 1);
                }
                loc3 = (loc3 + 1);
            }
            return loc4[loc6][loc7];
        }

        public static function hasText(arg1:String):Boolean
        {
            var loc2:*;

            loc2 = removeExtraWhitespace(arg1);
            return !!loc2.length;
        }

        public static function reverse(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.split("").reverse().join("");
        }

        public static function swapCase(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.replace(new RegExp("(\\w)"), _swapCase);
        }

        public static function capitalize(arg1:String, ... rest):String
        {
            var loc3:*;

            loc3 = trimLeft(arg1);
            trace("capl", rest[0]);
            if (rest[0] === true)
            {
                return loc3.replace(new RegExp("^.|\\b.", "g"), _upperCase);
            }
            return loc3.replace(new RegExp("(^\\w)"), _upperCase);
        }

        public static function truncate(arg1:String, arg2:uint, arg3:String="..."):String
        {
            var loc4:*;

            if (arg1 == null)
            {
                return "";
            }
            arg2 = arg2 - arg3.length;
            if ((loc4 = arg1).length > arg2)
            {
                loc4 = loc4.substr(0, arg2);
                if (new RegExp("[^\\s]").test(arg1.charAt(arg2)))
                {
                    loc4 = trimRight(loc4.replace(new RegExp("\\w+$|\\s+$"), ""));
                }
                loc4 = loc4 + arg3;
            }
            return loc4;
        }

        public static function reverseWords(arg1:String):String
        {
            if (arg1 == null)
            {
                return "";
            }
            return arg1.split(new RegExp("\\s+")).reverse().join("");
        }

        public static function beforeFirst(arg1:String, arg2:String):String
        {
            var loc3:*;

            if (arg1 == null)
            {
                return "";
            }
            loc3 = arg1.indexOf(arg2);
            if (loc3 == -1)
            {
                return "";
            }
            return arg1.substr(0, loc3);
        }

        private static function _upperCase(arg1:String, ... rest):String
        {
            trace("cap latter ", arg1);
            return arg1.toUpperCase();
        }

        public static function afterFirst(arg1:String, arg2:String):String
        {
            var loc3:*;

            if (arg1 == null)
            {
                return "";
            }
            loc3 = arg1.indexOf(arg2);
            if (loc3 == -1)
            {
                return "";
            }
            loc3 = loc3 + arg2.length;
            return arg1.substr(loc3);
        }

        public static function beforeLast(arg1:String, arg2:String):String
        {
            var loc3:*;

            if (arg1 == null)
            {
                return "";
            }
            loc3 = arg1.lastIndexOf(arg2);
            if (loc3 == -1)
            {
                return "";
            }
            return arg1.substr(0, loc3);
        }

        public static function padLeft(arg1:String, arg2:String, arg3:uint):String
        {
            var loc4:*;

            loc4 = arg1;
            while (loc4.length < arg3) 
            {
                loc4 = arg2 + loc4;
            }
            return loc4;
        }

        public static function quote(arg1:String):String
        {
            var loc2:*;

            loc2 = new RegExp("[\\\\\"\\r\\n]", "g");
            return "\"" + arg1.replace(loc2, _quote) + "\"";
        }

        private static function _quote(arg1:String, ... rest):String
        {
            var loc3:*;

            loc3 = arg1;
            switch (loc3) 
            {
                case "\\":
                    return "\\\\";
                case "\r":
                    return "\\r";
                case "\n":
                    return "\\n";
                case "\"":
                    return "\\\"";
                default:
                    return "";
            }
        }
    }
}
