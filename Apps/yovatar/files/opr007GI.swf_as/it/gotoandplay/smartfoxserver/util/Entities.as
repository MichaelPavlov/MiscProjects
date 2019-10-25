package it.gotoandplay.smartfoxserver.util 
{
    public class Entities extends Object
    {
        public function Entities()
        {
            super();
            return;
        }

        public static function decodeEntities(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc2 = "";
            while (loc7 < arg1.length) 
            {
                loc3 = arg1.charAt(loc7);
                if (loc3 != "&")
                {
                    loc2 = loc2 + loc3;
                }
                else 
                {
                    loc4 = loc3;
                    do 
                    {
                        ++loc7;
                        loc5 = arg1.charAt(loc7);
                        loc4 = loc4 + loc5;
                    }
                    while (!(loc5 == ";") && loc7 < arg1.length);
                    if ((loc6 = ascTabRev[loc4]) == null)
                    {
                        loc2 = loc2 + String.fromCharCode(getCharCode(loc4));
                    }
                    else 
                    {
                        loc2 = loc2 + loc6;
                    }
                }
                ++loc7;
            }
            return loc2;
        }

        public static function encodeEntities(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = 0;
            loc2 = "";
            loc3 = 0;
            while (loc3 < arg1.length) 
            {
                loc4 = arg1.charAt(loc3);
                if ((loc5 = arg1.charCodeAt(loc3)) == 9 || loc5 == 10 || loc5 == 13)
                {
                    loc2 = loc2 + loc4;
                }
                else 
                {
                    if (loc5 >= 32 && loc5 <= 126)
                    {
                        if (ascTab[loc4] == null)
                        {
                            loc2 = loc2 + loc4;
                        }
                        else 
                        {
                            loc2 = loc2 + ascTab[loc4];
                        }
                    }
                    else 
                    {
                        loc2 = loc2 + loc4;
                    }
                }
                ++loc3;
            }
            return loc2;
        }

        public static function getCharCode(arg1:String):Number
        {
            var loc2:*;

            loc2 = arg1.substr(3, arg1.length);
            loc2 = loc2.substr(0, (loc2.length - 1));
            return Number("0x" + loc2);
        }

        
        {
            ascTab = [];
            ascTab[">"] = "&gt;";
            ascTab["<"] = "&lt;";
            ascTab["&"] = "&amp;";
            ascTab["\'"] = "&apos;";
            ascTab["\""] = "&quot;";
            ascTabRev = [];
            ascTabRev["&gt;"] = ">";
            ascTabRev["&lt;"] = "<";
            ascTabRev["&amp;"] = "&";
            ascTabRev["&apos;"] = "\'";
            ascTabRev["&quot;"] = "\"";
            hexTable = new Array();
            hexTable["0"] = 0;
            hexTable["1"] = 1;
            hexTable["2"] = 2;
            hexTable["3"] = 3;
            hexTable["4"] = 4;
            hexTable["5"] = 5;
            hexTable["6"] = 6;
            hexTable["7"] = 7;
            hexTable["8"] = 8;
            hexTable["9"] = 9;
            hexTable["A"] = 10;
            hexTable["B"] = 11;
            hexTable["C"] = 12;
            hexTable["D"] = 13;
            hexTable["E"] = 14;
            hexTable["F"] = 15;
        }

        private static var hexTable:Array;

        private static var ascTab:Array;

        private static var ascTabRev:Array;
    }
}
