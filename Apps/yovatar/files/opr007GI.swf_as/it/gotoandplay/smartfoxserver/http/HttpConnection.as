package it.gotoandplay.smartfoxserver.http 
{
    import flash.events.*;
    import flash.net.*;
    
    public class HttpConnection extends flash.events.EventDispatcher
    {
        public function HttpConnection()
        {
            super();
            codec = new RawProtocolCodec();
            urlLoaderFactory = new LoaderFactory(handleResponse, handleIOError);
            return;
        }

        public function close():void
        {
            send(DISCONNECT);
            return;
        }

        public function getSessionId():String
        {
            return this.sessionId;
        }

        private function handleIOError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = {};
            loc2.message = arg1.text;
            loc3 = new HttpEvent(HttpEvent.onHttpError, loc2);
            dispatchEvent(loc3);
            return;
        }

        public function send(arg1:String):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (connected || !connected && arg1 == HANDSHAKE || !connected && arg1 == "poll")
            {
                loc2 = new URLVariables();
                loc2[paramName] = codec.encode(this.sessionId, arg1);
                urlRequest.data = loc2;
                if (arg1 != "poll")
                {
                    trace("[ Send ]: " + urlRequest.data);
                }
                loc3 = urlLoaderFactory.getLoader();
                loc3.data = loc2;
                loc3.load(urlRequest);
            }
            return;
        }

        public function connect(arg1:String, arg2:int=8080):void
        {
            this.ipAddr = arg1;
            this.port = arg2;
            this.webUrl = "http://" + this.ipAddr + ":" + this.port + "/" + servletUrl;
            this.sessionId = null;
            urlRequest = new URLRequest(webUrl);
            urlRequest.method = URLRequestMethod.POST;
            send(HANDSHAKE);
            return;
        }

        private function handleResponse(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc2 = arg1.target as URLLoader;
            loc3 = loc2.data as String;
            loc5 = {};
            if (loc3.charAt(0) != HANDSHAKE_TOKEN)
            {
                if (loc3.indexOf(CONN_LOST) != 0)
                {
                    loc5.data = loc3;
                    loc4 = new HttpEvent(HttpEvent.onHttpData, loc5);
                }
                else 
                {
                    loc5.data = {};
                    loc4 = new HttpEvent(HttpEvent.onHttpClose, loc5);
                }
                dispatchEvent(loc4);
            }
            else 
            {
                if (sessionId != null)
                {
                    trace("**ERROR** SessionId is being rewritten");
                }
                else 
                {
                    sessionId = codec.decode(loc3);
                    connected = true;
                    loc5.sessionId = this.sessionId;
                    loc5.success = true;
                    loc4 = new HttpEvent(HttpEvent.onHttpConnect, loc5);
                    dispatchEvent(loc4);
                }
            }
            return;
        }

        public function isConnected():Boolean
        {
            return this.connected;
        }

        private static const servletUrl:String="BlueBox/HttpBox.do";

        public static const HANDSHAKE_TOKEN:String="#";

        private static const HANDSHAKE:String="connect";

        private static const DISCONNECT:String="disconnect";

        private static const CONN_LOST:String="ERR#01";

        private static const paramName:String="sfsHttp";

        private var urlRequest:flash.net.URLRequest;

        private var port:int;

        private var urlLoaderFactory:it.gotoandplay.smartfoxserver.http.LoaderFactory;

        private var connected:Boolean=false;

        private var sessionId:String;

        private var ipAddr:String;

        private var webUrl:String;

        private var codec:it.gotoandplay.smartfoxserver.http.IHttpProtocolCodec;
    }
}
