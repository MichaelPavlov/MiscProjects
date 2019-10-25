package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class MessageFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function MessageFeedObject(arg1:int, arg2:int, arg3:String)
        {
            super();
            this.playerId = arg1;
            this.recipientPlayerId = arg2;
            this.message = arg3;
            return;
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        public function getArgs():String
        {
            var loc1:*;

            loc1 = new Object();
            loc1.pid = this.recipientPlayerId;
            loc1.message = this.message;
            return JSON.encode(loc1);
        }

        internal var recipientPlayerId:int;

        internal var message:String;

        internal var playerId:int;
    }
}
