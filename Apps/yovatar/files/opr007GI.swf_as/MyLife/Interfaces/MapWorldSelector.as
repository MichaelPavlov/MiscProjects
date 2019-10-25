package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    
    public class MapWorldSelector extends flash.display.MovieClip
    {
        public function MapWorldSelector()
        {
            hotSpotList = [];
            super();
            btnCloseWindow.addEventListener(MouseEvent.CLICK, btnMapWorldCloseWindow);
            loadHotSpots();
            activateHotSpots();
            return;
        }

        private function btnMapWorldCloseWindow(arg1:flash.events.MouseEvent):*
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE, {}, false));
            return;
        }

        internal function getMovieChildren(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = undefined;
            loc2 = new Array();
            loc3 = 0;
            while (loc3 < arg1.numChildren) 
            {
                loc4 = arg1.getChildAt(loc3);
                loc2.unshift(loc4);
                ++loc3;
            }
            return loc2;
        }

        public function setYouAreHereLocation(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc3 = undefined;
            loc4 = 0;
            loc5 = getMovieChildren(YouAreHereLocations);
            for each (loc2 in loc5)
            {
                loc2.visible = false;
            }
            loc3 = StringUtils.beforeFirst(arg1, "-");
            if (loc3 == "")
            {
                loc3 = arg1;
            }
            if (YouAreHereLocations[loc3])
            {
                YouAreHereLocations[loc3].visible = true;
            }
            return;
        }

        private function rollZoneClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = getListItemFromRollZone(arg1.currentTarget);
            if (loc2.triggerZone)
            {
                trace(loc2.triggerZone);
                dispatchEvent(new MyLifeEvent(MyLifeEvent.JOIN_ZONE, {"zone":loc2.triggerZone}, true));
            }
            return;
        }

        private function loadHotSpots():*
        {
            hotSpotList.push({"rollZone":MW_HL_Bank, "triggerZone":"BankExterior"});
            hotSpotList.push({"rollZone":MW_HL_Beach, "triggerZone":"BeachExterior"});
            hotSpotList.push({"rollZone":MW_HL_Carnival, "triggerZone":""});
            hotSpotList.push({"rollZone":MW_HL_Casino, "triggerZone":"CasinoExterior"});
            hotSpotList.push({"rollZone":MW_HL_CoffeeShop, "triggerZone":"CoffeeshopExterior"});
            hotSpotList.push({"rollZone":MW_HL_Apartment, "triggerZone":"CondoExterior"});
            hotSpotList.push({"rollZone":MW_HL_Diner, "triggerZone":"DinerExterior"});
            hotSpotList.push({"rollZone":MW_HL_Factory, "triggerZone":"FactoryExterior"});
            hotSpotList.push({"rollZone":MW_HL_Clothing, "triggerZone":"FashionExterior"});
            hotSpotList.push({"rollZone":MW_HL_Furniture, "triggerZone":"FurnitureExterior"});
            hotSpotList.push({"rollZone":MW_HL_GiftStore, "triggerZone":"GiftshopExterior"});
            hotSpotList.push({"rollZone":MW_HL_Gym, "triggerZone":"GymExterior"});
            hotSpotList.push({"rollZone":MW_HL_Houses, "triggerZone":"HousesExterior"});
            hotSpotList.push({"rollZone":MW_HL_NightClub, "triggerZone":"NightclubExterior"});
            hotSpotList.push({"rollZone":MW_HL_PetStore, "triggerZone":"PetStoreExterior"});
            hotSpotList.push({"rollZone":MW_HL_Realty, "triggerZone":"RealtorExterior"});
            hotSpotList.push({"rollZone":MW_HL_Amusement, "triggerZone":"AmusementExterior"});
            hotSpotList.push({"rollZone":MW_HL_YoDepot, "triggerZone":"YoDepotExterior"});
            return;
        }

        private function activateHotSpots():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = hotSpotList;
            for each (loc1 in loc3)
            {
                loc1.rollZone.addEventListener(MouseEvent.CLICK, rollZoneClick);
            }
            return;
        }

        private function getListItemFromRollZone(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = hotSpotList;
            for each (loc2 in loc4)
            {
                if (loc2.rollZone != arg1)
                {
                    continue;
                }
                return loc2;
            }
            return;
        }

        public var MW_HL_Realty:flash.display.SimpleButton;

        public var MW_HL_Apartment:flash.display.SimpleButton;

        public var MW_HL_Amusement:flash.display.SimpleButton;

        public var MW_HL_Gym:flash.display.SimpleButton;

        public var MW_HL_YoDepot:flash.display.SimpleButton;

        public var btnCloseWindow:flash.display.SimpleButton;

        public var MW_HL_Bank:flash.display.SimpleButton;

        private var hotSpotList:Array;

        public var MW_HL_Houses:flash.display.SimpleButton;

        private var mapWorldCoundChannel:*;

        public var MW_HL_Beach:flash.display.SimpleButton;

        public var animatedMapWorldScene:flash.display.MovieClip;

        public var MW_HL_Carnival:flash.display.SimpleButton;

        public var MW_HL_CoffeeShop:flash.display.SimpleButton;

        public var MW_HL_Furniture:flash.display.SimpleButton;

        public var MW_HL_Diner:flash.display.SimpleButton;

        public var MW_HL_Casino:flash.display.SimpleButton;

        public var MW_HL_NightClub:flash.display.SimpleButton;

        public var MW_HL_Factory:flash.display.SimpleButton;

        public var MW_HL_PetStore:flash.display.SimpleButton;

        public var MW_HL_GiftStore:flash.display.SimpleButton;

        public var MW_HL_Clothing:flash.display.SimpleButton;

        public var YouAreHereLocations:flash.display.MovieClip;
    }
}
