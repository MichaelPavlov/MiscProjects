package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class RacingFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function RacingFeedObject(arg1:int)
        {
            super();
            this.playerId = arg1;
            return;
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        public function getArgs():String
        {
            return JSON.encode(new Object());
        }

        internal var playerId:int;
    }
}
