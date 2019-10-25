package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class AppearanceFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function AppearanceFeedObject(arg1:int)
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

        private var playerId:int;
    }
}
