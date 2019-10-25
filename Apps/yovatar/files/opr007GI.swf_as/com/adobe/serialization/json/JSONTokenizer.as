package com.adobe.serialization.json 
{
    public class JSONTokenizer extends Object
    {
        public function JSONTokenizer(arg1:String)
        {
            super();
            jsonString = arg1;
            loc = 0;
            nextChar();
            return;
        }

        private function skipComments():void
        {
            var loc1:*;

            if (ch == "/")
            {
                nextChar();
                loc1 = ch;
                switch (loc1) 
                {
                    case "/":
                        do 
                        {
                            nextChar();
                        }
                        while (!(ch == "\n") && !(ch == ""));
                        nextChar();
                        break;
                    case "*":
                        nextChar();
                        for (;;) 
                        {
                            if (ch != "*")
                            {
                                nextChar();
                            }
                            else 
                            {
                                nextChar();
                                if (ch == "/")
                                {
                                    nextChar();
                                    break;
                                }
                            }
                            if (ch != "")
                            {
                                continue;
                            }
                            parseError("Multi-line comment not closed");
                        }
                        break;
                    default:
                        parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
                }
            }
            return;
        }

        private function isDigit(arg1:String):Boolean
        {
            return arg1 >= "0" && arg1 <= "9";
        }

        private function readString():com.adobe.serialization.json.JSONToken
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = 0;
            loc1 = new JSONToken();
            loc1.type = JSONTokenType.STRING;
            loc2 = "";
            nextChar();
            while (!(ch == "\"") && !(ch == "")) 
            {
                if (ch != "\\")
                {
                    loc2 = loc2 + ch;
                }
                else 
                {
                    nextChar();
                    loc5 = ch;
                    switch (loc5) 
                    {
                        case "\"":
                            loc2 = loc2 + "\"";
                            break;
                        case "/":
                            loc2 = loc2 + "/";
                            break;
                        case "\\":
                            loc2 = loc2 + "\\";
                            break;
                        case "b":
                            loc2 = loc2 + "";
                            break;
                        case "f":
                            loc2 = loc2 + "";
                            break;
                        case "n":
                            loc2 = loc2 + "\n";
                            break;
                        case "r":
                            loc2 = loc2 + "\r";
                            break;
                        case "t":
                            loc2 = loc2 + "\t";
                            break;
                        case "u":
                            loc3 = "";
                            loc4 = 0;
                            while (loc4 < 4) 
                            {
                                if (!isHexDigit(nextChar()))
                                {
                                    parseError(" Excepted a hex digit, but found: " + ch);
                                }
                                loc3 = loc3 + ch;
                                ++loc4;
                            }
                            loc2 = loc2 + String.fromCharCode(parseInt(loc3, 16));
                            break;
                        default:
                            loc2 = loc2 + "\\" + ch;
                    }
                }
                nextChar();
            }
            if (ch == "")
            {
                parseError("Unterminated string literal");
            }
            nextChar();
            loc1.value = loc2;
            return loc1;
        }

        private function nextChar():String
        {
            var loc1:*;
            var loc2:*;

            ch = loc1 = jsonString.charAt(loc++);
            return loc1;
        }

        public function getNextToken():com.adobe.serialization.json.JSONToken
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc1 = new JSONToken();
            skipIgnored();
            loc5 = ch;
            switch (loc5) 
            {
                case "{":
                    loc1.type = JSONTokenType.LEFT_BRACE;
                    loc1.value = "{";
                    nextChar();
                    break;
                case "}":
                    loc1.type = JSONTokenType.RIGHT_BRACE;
                    loc1.value = "}";
                    nextChar();
                    break;
                case "[":
                    loc1.type = JSONTokenType.LEFT_BRACKET;
                    loc1.value = "[";
                    nextChar();
                    break;
                case "]":
                    loc1.type = JSONTokenType.RIGHT_BRACKET;
                    loc1.value = "]";
                    nextChar();
                    break;
                case ",":
                    loc1.type = JSONTokenType.COMMA;
                    loc1.value = ",";
                    nextChar();
                    break;
                case ":":
                    loc1.type = JSONTokenType.COLON;
                    loc1.value = ":";
                    nextChar();
                    break;
                case "t":
                    loc2 = "t" + nextChar() + nextChar() + nextChar();
                    if (loc2 != "true")
                    {
                        parseError("Expecting \'true\' but found " + loc2);
                    }
                    else 
                    {
                        loc1.type = JSONTokenType.TRUE;
                        loc1.value = true;
                        nextChar();
                    }
                    break;
                case "f":
                    loc3 = "f" + nextChar() + nextChar() + nextChar() + nextChar();
                    if (loc3 != "false")
                    {
                        parseError("Expecting \'false\' but found " + loc3);
                    }
                    else 
                    {
                        loc1.type = JSONTokenType.FALSE;
                        loc1.value = false;
                        nextChar();
                    }
                    break;
                case "n":
                    if ((loc4 = "n" + nextChar() + nextChar() + nextChar()) != "null")
                    {
                        parseError("Expecting \'null\' but found " + loc4);
                    }
                    else 
                    {
                        loc1.type = JSONTokenType.NULL;
                        loc1.value = null;
                        nextChar();
                    }
                    break;
                case "\"":
                    loc1 = readString();
                    break;
                default:
                    if (isDigit(ch) || ch == "-")
                    {
                        loc1 = readNumber();
                    }
                    else 
                    {
                        if (ch == "")
                        {
                            return null;
                        }
                        parseError("Unexpected " + ch + " encountered");
                    }
            }
            return loc1;
        }

        private function skipWhite():void
        {
            while (isWhiteSpace(ch)) 
            {
                nextChar();
            }
            return;
        }

        public function parseError(arg1:String):void
        {
            throw new JSONParseError(arg1, loc, jsonString);
        }

        private function isWhiteSpace(arg1:String):Boolean
        {
            return arg1 == " " || arg1 == "\t" || arg1 == "\n";
        }

        private function skipIgnored():void
        {
            skipWhite();
            skipComments();
            skipWhite();
            return;
        }

        private function isHexDigit(arg1:String):Boolean
        {
            var loc2:*;

            loc2 = arg1.toUpperCase();
            return isDigit(arg1) || loc2 >= "A" && loc2 <= "F";
        }

        private function readNumber():com.adobe.serialization.json.JSONToken
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = new JSONToken();
            loc1.type = JSONTokenType.NUMBER;
            loc2 = "";
            if (ch == "-")
            {
                loc2 = loc2 + "-";
                nextChar();
            }
            if (!isDigit(ch))
            {
                parseError("Expecting a digit");
            }
            if (ch != "0")
            {
                while (isDigit(ch)) 
                {
                    loc2 = loc2 + ch;
                    nextChar();
                }
            }
            else 
            {
                loc2 = loc2 + ch;
                nextChar();
                if (isDigit(ch))
                {
                    parseError("A digit cannot immediately follow 0");
                }
            }
            if (ch == ".")
            {
                loc2 = loc2 + ".";
                nextChar();
                if (!isDigit(ch))
                {
                    parseError("Expecting a digit");
                }
                while (isDigit(ch)) 
                {
                    loc2 = loc2 + ch;
                    nextChar();
                }
            }
            if (ch == "e" || ch == "E")
            {
                loc2 = loc2 + "e";
                nextChar();
                if (ch == "+" || ch == "-")
                {
                    loc2 = loc2 + ch;
                    nextChar();
                }
                if (!isDigit(ch))
                {
                    parseError("Scientific notation number needs exponent value");
                }
                while (isDigit(ch)) 
                {
                    loc2 = loc2 + ch;
                    nextChar();
                }
            }
            loc3 = Number(loc2);
            if (isFinite(loc3) && !isNaN(loc3))
            {
                loc1.value = loc3;
                return loc1;
            }
            parseError("Number " + loc3 + " is not valid!");
            return null;
        }

        private var loc:int;

        private var ch:String;

        private var obj:Object;

        private var jsonString:String;
    }
}
