package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class XPFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function XPFeedObject(arg1:int, arg2:String, arg3:String, arg4:int, arg5:String, arg6:String)
        {
            super();
            playerId = arg1;
            title = arg2;
            type = arg3;
            itemID = arg4;
            body = arg5;
            otype = arg6;
            return;
        }

        public function getArgs():String
        {
            var loc1:*;

            loc1 = {"titleobject":title, "type":type, "itemnum":itemID, "bodyobject":body, "otype":otype};
            return JSON.encode(loc1);
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        private var body:String="";

        private var playerId:int=0;

        private var otype:String="";

        private var itemID:int=0;

        private var type:String="level";

        private var title:String="";
    }
}
