package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class MysteryFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function MysteryFeedObject(arg1:int, arg2:int, arg3:String)
        {
            super();
            this.playerId = arg1;
            this.itemId = arg2;
            this.itemName = arg3;
            return;
        }

        public function getArgs():String
        {
            var loc1:*;

            loc1 = new Object();
            loc1.itemnum = itemId;
            loc1.itemname = itemName;
            return JSON.encode(loc1);
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        internal var itemId:int;

        internal var playerId:int;

        internal var itemName:String;
    }
}
