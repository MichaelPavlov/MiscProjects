package MyLife.FB.Objects 
{
    import MyLife.FB.Interfaces.*;
    import com.adobe.serialization.json.*;
    
    public class ItemFeedObject extends Object implements MyLife.FB.Interfaces.FeedObject
    {
        public function ItemFeedObject(arg1:int, arg2:int, arg3:String, arg4:int)
        {
            super();
            this.playerId = arg1;
            this.itemId = arg2;
            this.itemName = arg3;
            this.price = arg4;
            return;
        }

        public function getItemId():int
        {
            return itemId;
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        public function getArgs():String
        {
            var loc1:*;

            loc1 = new Object();
            loc1.itemnum = this.itemId;
            loc1.itemname = this.itemName;
            return JSON.encode(loc1);
        }

        public function getItemName():String
        {
            return itemName;
        }

        public function getPrice():int
        {
            return price;
        }

        internal var playerId:int;

        internal var price:int;

        internal var itemId:int;

        internal var itemName:String;
    }
}
