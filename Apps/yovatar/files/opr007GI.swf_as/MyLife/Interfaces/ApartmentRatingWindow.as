package MyLife.Interfaces 
{
    import MyLife.*;
    import com.adobe.serialization.json.*;
    import fl.containers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    public class ApartmentRatingWindow extends flash.display.MovieClip
    {
        public function ApartmentRatingWindow()
        {
            super();
            scrollPane = new ScrollPane();
            scrollPane.move(20, 10);
            scrollPane.setSize(360, 270);
            addChild(scrollPane);
            initialize();
            return;
        }

        private function initialize():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc4 = null;
            loc10 = null;
            loc11 = null;
            loc1 = MyLifeInstance.getInstance() as MyLife;
            loc2 = loc1.myLifeConfiguration;
            loc3 = loc2.platformType;
            loc5 = loc1.myLifeConfiguration.variables["global"]["game_control_server"];
            loc6 = "buddies=0&timeFrame=3";
            if (loc3 != "platformFacebook")
            {
                if (loc3 != "platformMySpace")
                {
                    if (loc3 == MyLifeConfiguration.getInstance().PLATFORM_TAGGED)
                    {
                        loc5 = loc5.replace(new RegExp("fb", "g"), "tg");
                        loc6 = loc6 + "&" + MyLifeConfiguration.networkCredentials;
                    }
                }
                else 
                {
                    loc5 = loc5.replace(new RegExp("fb", "g"), "ms");
                    loc10 = loc2.variables["querystring"]["opensocialJSON"];
                    loc11 = loc2.variables["querystring"]["oathJSON"];
                    loc6 = loc6 + "&opensocialJSON=" + loc10 + "&oathJSON=" + loc11;
                }
            }
            else 
            {
                loc4 = JSON.decode(loc2.variables["querystring"]["facebookJSON"]);
                loc6 = loc6 + "&fb_sig_user=" + loc4.fb_sig_user + "&fb_sig_session_key=" + loc4.fb_sig_session_key;
            }
            loc7 = loc5 + "get_top_rooms.php?" + loc6 + "&r=" + Math.random();
            (loc8 = new URLRequest(loc7)).method = URLRequestMethod.POST;
            (loc9 = new URLLoader()).addEventListener(Event.COMPLETE, onDataLoadComplete);
            loc9.addEventListener(ErrorEvent.ERROR, onDataLoadError);
            loc9.load(loc8);
            return;
        }

        private function onDataLoadComplete(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, onDataLoadComplete);
            loc2.removeEventListener(ErrorEvent.ERROR, onDataLoadError);
            populate(loc2.data as String);
            return;
        }

        private function onDataLoadError(arg1:flash.events.Event):void
        {
            var loc2:*;

            trace("ApartmentRatingWindow :: Failed to load friend data.");
            loc2 = arg1.target as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, onDataLoadComplete);
            loc2.removeEventListener(ErrorEvent.ERROR, onDataLoadError);
            return;
        }

        private function populate(arg1:String):void
        {
            var allPlayersData:Array;
            var i:int;
            var itemList:flash.display.Sprite;
            var json:String;
            var loc2:*;
            var loc3:*;
            var newItem:MyLife.Interfaces.ApartmentRatingItem;
            var top:int;

            allPlayersData = null;
            newItem = null;
            json = arg1;
            if (json && !(json == "") && !(json == "null"))
            {
                try
                {
                    allPlayersData = JSON.decode(json);
                }
                catch (e:Error)
                {
                    allPlayersData = [];
                }
            }
            allPlayersData = allPlayersData || [];
            allPlayersData.sortOn("rating", Array.DESCENDING | Array.NUMERIC);
            itemList = new Sprite();
            top = 0;
            i = 0;
            while (i < allPlayersData.length) 
            {
                newItem = new ApartmentRatingItem(allPlayersData[i], i + 1);
                newItem.y = top;
                newItem.buttonMode = true;
                newItem.addEventListener(MouseEvent.CLICK, onApartmentRatingItemClick, false, 0, true);
                itemList.addChild(newItem);
                top = top + ITEM_HEIGHT;
                i = (i + 1);
            }
            scrollPane.source = itemList;
            return;
        }

        private function onApartmentRatingItemClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            dispatchEvent(new Event(Event.CLOSE));
            loc2 = arg1.currentTarget as ApartmentRatingItem;
            loc3 = MyLifeInstance.getInstance() as MyLife;
            loc4 = loc3.getConfiguration().variables["querystring"]["defaultInstance"];
            loc5 = "This room is located on a different server than you. Are you sure you want to change servers?";
            loc6 = "AP" + loc2.playerRoom + "-" + loc2.playerId;
            loc3.getZone().join(loc6, 0, loc4, loc5);
            return;
        }

        public static const ITEM_HEIGHT:int=70;

        private var scrollPane:fl.containers.ScrollPane;
    }
}
