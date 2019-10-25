package com.adobe.serialization.json 
{
    public class JSONDecoder extends Object
    {
        public function JSONDecoder(arg1:String)
        {
            super();
            tokenizer = new JSONTokenizer(arg1);
            nextToken();
            value = parseValue();
            return;
        }

        private function parseObject():Object
        {
            var loc1:*;
            var loc2:*;

            loc2 = null;
            loc1 = new Object();
            nextToken();
            if (token.type == JSONTokenType.RIGHT_BRACE)
            {
                return loc1;
            }
            for (;;) 
            {
                if (token.type == JSONTokenType.STRING)
                {
                    loc2 = String(token.value);
                    nextToken();
                    if (token.type != JSONTokenType.COLON)
                    {
                        tokenizer.parseError("Expecting : but found " + token.value);
                    }
                    else 
                    {
                        nextToken();
                        loc1[loc2] = parseValue();
                        nextToken();
                        if (token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            return loc1;
                        }
                        if (token.type != JSONTokenType.COMMA)
                        {
                            tokenizer.parseError("Expecting } or , but found " + token.value);
                        }
                        else 
                        {
                            nextToken();
                        }
                    }
                    continue;
                }
                tokenizer.parseError("Expecting string but found " + token.value);
            }
            return null;
        }

        private function parseValue():Object
        {
            var loc1:*;

            if (token == null)
            {
                return null;
            }
            loc1 = token.type;
            switch (loc1) 
            {
                case JSONTokenType.LEFT_BRACE:
                    return parseObject();
                case JSONTokenType.LEFT_BRACKET:
                    return parseArray();
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                    return token.value;
                default:
                    tokenizer.parseError("Unexpected " + token.value);
            }
            return null;
        }

        private function nextToken():com.adobe.serialization.json.JSONToken
        {
            var loc1:*;

            token = loc1 = tokenizer.getNextToken();
            return loc1;
        }

        public function getValue():*
        {
            return value;
        }

        private function parseArray():Array
        {
            var loc1:*;

            loc1 = new Array();
            nextToken();
            if (token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return loc1;
            }
            for (;;) 
            {
                loc1.push(parseValue());
                nextToken();
                if (token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return loc1;
                }
                if (token.type == JSONTokenType.COMMA)
                {
                    nextToken();
                    continue;
                }
                tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
            return null;
        }

        private var value:*;

        private var tokenizer:com.adobe.serialization.json.JSONTokenizer;

        private var token:com.adobe.serialization.json.JSONToken;
    }
}
