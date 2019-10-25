package it.gotoandplay.smartfoxserver.http 
{
    public interface IHttpProtocolCodec
    {
        function decode(arg1:String):String;

        function encode(arg1:String, arg2:String):String;
    }
}
