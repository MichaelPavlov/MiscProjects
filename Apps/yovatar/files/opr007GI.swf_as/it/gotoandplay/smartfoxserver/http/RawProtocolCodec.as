package it.gotoandplay.smartfoxserver.http 
{
    public class RawProtocolCodec extends Object implements it.gotoandplay.smartfoxserver.http.IHttpProtocolCodec
    {
        public function RawProtocolCodec()
        {
            super();
            return;
        }

        public function decode(arg1:String):String
        {
            var loc2:*;

            loc2 = null;
            if (arg1.charAt(0) == HttpConnection.HANDSHAKE_TOKEN)
            {
                loc2 = arg1.substr(1, SESSION_ID_LEN);
            }
            return loc2;
        }

        public function encode(arg1:String, arg2:String):String
        {
            return (arg1 != null) ? arg1 : "" + arg2;
        }

        private static const SESSION_ID_LEN:int=32;
    }
}
