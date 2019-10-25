package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class BadgeFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function BadgeFeedObject(arg1:int, arg2:String, arg3:String, arg4:int)
        {
            super();
            this.playerId = arg1;
            this.badgeName = arg2;
            this.badgePic = arg3;
            this.badgeId = arg4;
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
            loc1.badgename = badgeName;
            loc1.badgepic = badgePic;
            loc1.badgeid = badgeId;
            return JSON.encode(loc1);
        }

        private var badgePic:String;

        private var badgeName:String;

        private var playerId:int;

        private var badgeId:int;
    }
}
