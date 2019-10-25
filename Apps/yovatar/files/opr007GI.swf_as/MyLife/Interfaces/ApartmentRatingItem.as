package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    
    public class ApartmentRatingItem extends flash.display.Sprite
    {
        public function ApartmentRatingItem(arg1:Object, arg2:int=1)
        {
            var loc3:*;
            var loc4:*;

            super();
            this.userData = arg1;
            playerId = arg1["player"];
            playerRoom = arg1["room"];
            roomNameTxt.htmlText = playerRoom;
            playerNameTxt.htmlText = "<b>" + arg1["name"] + "</b>";
            rankingTxt.htmlText = "<b>" + StringUtils.getRankString(arg2) + "</b>";
            roomRatingTxt.htmlText = "<b>" + arg1["rating"] + "</b>";
            if (playerRoom.search(new RegExp(" ", "gi")) != -1)
            {
                playerRoom = "Living";
            }
            loc3 = parseInt(playerId);
            FriendDataManager.loadFriendAvatarHead(loc3, avatarContainer, onAvatarLoad, 0, arg1.clothing);
            (loc4 = new Loader()).contentLoaderInfo.addEventListener(Event.COMPLETE, onApartmentImageLoadSuccess, false, 0, true);
            loc4.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onApartmentImageLoadError, false, 0, true);
            loc4.load(new URLRequest(getPlayerImageUrl(arg1["player"])));
            return;
        }

        private function onApartmentImageLoadError(arg1:flash.events.IOErrorEvent):void
        {
            trace("ApartmentRatingItem :: unable to load preview");
            return;
        }

        private function onApartmentImageLoadSuccess(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.currentTarget.loader as Loader;
            loc3 = loc2.content;
            loc3.width = 90;
            loc3.height = 60;
            previewPlaceholder.addChild(loc3);
            return;
        }

        private function getPlayerImageUrl(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = playerRoom || "Living";
            loc3 = APARTMENT_IMAGES_URL;
            loc5 = (loc4 = String(arg1)).split("");
            loc6 = loc3;
            loc7 = 0;
            while (loc7 < 4) 
            {
                loc6 = loc6 + loc5[loc7] + "/";
                ++loc7;
            }
            return loc6 = loc6 + arg1 + "-" + loc2 + ".jpg";
        }

        private function onAvatarLoad(arg1:flash.display.DisplayObject, arg2:flash.display.DisplayObjectContainer):void
        {
            arg1.scaleX = arg1.scaleX * 0.2;
            arg1.scaleY = arg1.scaleY * 0.2;
            arg2.addChild(arg1);
            trace("what");
            return;
        }

        public static const APARTMENT_IMAGES_URL:String="http://yo.static.yoville.com/images/nas/images/";

        public var playerRoom:String;

        public var playerNameTxt:flash.text.TextField;

        public var avatarContainer:flash.display.MovieClip;

        public var roomNameTxt:flash.text.TextField;

        public var previewPlaceholder:flash.display.MovieClip;

        private var userData:Object;

        public var roomRatingTxt:flash.text.TextField;

        public var rankingTxt:flash.text.TextField;

        public var playerId:String;
    }
}
