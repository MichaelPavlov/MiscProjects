package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class ApartmentFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function ApartmentFeedObject(arg1:int, arg2:String, arg3:Boolean=false)
        {
            super();
            playerId = arg1;
            roomId = arg2;
            isHome = arg3;
            return;
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        public function getArgs():String
        {
            var loc1:*;

            loc1 = {};
            loc1.roomid = roomId;
            loc1.ishome = isHome;
            return JSON.encode(loc1);
        }

        private var playerId:int;

        private var roomId:String;

        private var isHome:Boolean=false;
    }
}
