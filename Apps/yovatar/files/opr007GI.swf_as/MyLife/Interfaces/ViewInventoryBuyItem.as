package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class ViewInventoryBuyItem extends flash.display.MovieClip
    {
        public function ViewInventoryBuyItem()
        {
            super();
            trace("ViewInventoryBuyItem Loaded");
            btnCancel.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenCancelButtonClick);
            btnBuy.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenBuyButtonClick);
            return;
        }

        private function closeWindow():void
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String, arg3:int=0, arg4:int=0):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = null;
            loc5 = getMovieChildren(arg1);
            loc7 = 0;
            loc8 = loc5;
            for each (loc6 in loc8)
            {
                arg1.removeChild(loc6);
            }
            _myLife.assetsLoader.loadImage(arg2, {"clip":arg1, "x":arg3, "y":arg4}, imageLoadedCallback);
            return;
        }

        private function cancelWindowButtonClick(arg1:flash.events.MouseEvent):void
        {
            closeWindow();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip=null, arg2:Object=null):void
        {
            _myLife = arg1;
            StoreListingItemPicture.toGoClip.visible = false;
            if (arg2 == null)
            {
                storeFlag = true;
            }
            else 
            {
                this.x = 320;
                this.y = 240;
                storeFlag = false;
                itemSetup(arg2);
            }
            toGoClip = StoreListingItemPicture.toGoClip;
            btnCancel.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenCancelButtonClick);
            btnBuy.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenBuyButtonClick);
            return;
        }

        private function inventoryBuyItemScreenCancelButtonClick(arg1:flash.events.MouseEvent):void
        {
            closeWindow();
            return;
        }

        private function getMovieChildren(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
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

        private function imageLoadedCallback(arg1:*, arg2:Object):void
        {
            if (arg1 && arg2)
            {
                arg1.x = arg2.x;
                arg1.y = arg2.y;
                arg2.clip.addChild(arg1);
            }
            return;
        }

        private function itemSetup(arg1:Object):*
        {
            if (arg1.itemData)
            {
                setupWindow(arg1.itemData);
            }
            return;
        }

        private function doBuyItem(arg1:int):void
        {
            ViewStoreInventory.getInstance().doBuyItem(arg1, storeId);
            closeWindow();
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        private function setupWindow(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = false;
            loc3 = null;
            loc4 = null;
            if (arg1.itemId)
            {
                loc2 = parseInt(arg1.cash, 10) > 0;
                this.mcMoneyIcon.visible = !loc2;
                this.mcCashIcon.visible = loc2;
                this.txtItemName.text = arg1.name;
                this.txtPrice.text = loc2 ? arg1.cash : arg1.price;
                this.visible = true;
                this.currentItemId = arg1.itemId;
                this.btnCancel.mouseEnabled = true;
                this.btnBuy.mouseEnabled = true;
                this.btnCancel.alpha = 1;
                this.btnBuy.alpha = 1;
                if (arg1.metaData)
                {
                    if (arg1.metaData.energy)
                    {
                        this.customDataTxt.visible = true;
                        this.customIcon.visible = true;
                        this.customDataTxt.textColor = 10027008;
                        this.customDataTxt.text = "+" + arg1.metaData.energy + " Energy";
                        this.customIcon.addChild(new PlusHeart());
                    }
                    else 
                    {
                        if (arg1.metaData.drunk)
                        {
                            this.customDataTxt.visible = true;
                            this.customIcon.visible = true;
                            this.customDataTxt.textColor = 12953;
                            this.customDataTxt.text = "+" + arg1.metaData.drunk + " Dizzy";
                            this.customIcon.addChild(new PlusDizzy());
                        }
                        else 
                        {
                            this.customDataTxt.visible = false;
                            this.customIcon.visible = false;
                            this.customDataTxt.text = "";
                        }
                    }
                }
                else 
                {
                    this.customDataTxt.visible = false;
                    this.customIcon.visible = false;
                    this.customDataTxt.text = "";
                }
                if (arg1.crewMembers > 0)
                {
                    loc4 = "Member";
                    if (arg1.crewMembers > 1)
                    {
                        loc4 = loc4 + "s";
                    }
                    this.txtCrewMembers.htmlText = "Requires " + arg1.crewMembers + " Crew " + loc4 + " To Purchase";
                    this.txtCrewMembers.visible = true;
                }
                else 
                {
                    this.txtCrewMembers.visible = false;
                }
                if (this.storeId != this.STORE_ID_REALTY_OFFICE)
                {
                    if (arg1.categoryId == 2001 || arg1.categoryId == 2002)
                    {
                        loc3 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_110_80.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                        loadImageIntoMovieClip(this.StoreListingItemPicture.image, loc3, 10, (10));
                    }
                    else 
                    {
                        loc3 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_130_100.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                        loadImageIntoMovieClip(this.StoreListingItemPicture.image, loc3);
                    }
                }
                else 
                {
                    loc3 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_280_190.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                    loadImageIntoMovieClip(this.StoreListingItemPicture.image, loc3);
                }
            }
            return;
        }

        private function inventoryBuyItemScreenBuyButtonClick(arg1:flash.events.MouseEvent):void
        {
            this.btnCancel.mouseEnabled = false;
            this.btnBuy.mouseEnabled = false;
            this.btnCancel.alpha = 0.5;
            this.btnBuy.alpha = 0.5;
            doBuyItem(this.currentItemId);
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            dispatchEvent(new Event(Event.CLOSE));
            MyLifeInstance.getInstance().getInterface().unloadInterface(arg1);
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        
        {
            PlusHeart = ViewInventoryBuyItem_PlusHeart;
            PlusDizzy = ViewInventoryBuyItem_PlusDizzy;
            EnergyMeter = ViewInventoryBuyItem_EnergyMeter;
        }

        private const STORE_ID_REALTY_OFFICE:int=1013;

        private const CATEGORY_ID_HOMES:int=2029;

        private static const YO_CASH_BUY:String="BTN_BUY_YOCASH";

        private static const PLATFORM_MYSPACE:String="platformMySpace";

        private static const PLATFORM_FACEBOOK:String="platformFacebook";

        private static const YO_CASH_EARN:String="BTN_EARN_YOCASH";

        public var mcCashIcon:flash.display.MovieClip;

        public var customIcon:flash.display.MovieClip;

        public var btnBuy:flash.display.SimpleButton;

        private var showEatAnimationOnStoreClose:Boolean;

        public var toGoClip:flash.display.MovieClip;

        public var customDataTxt:flash.text.TextField;

        public var txtPrice:flash.text.TextField;

        public var mcItemBG:flash.display.MovieClip;

        public var storeId:int=0;

        public var txtItemName:flash.text.TextField;

        public var mcMoneyIcon:flash.display.MovieClip;

        public var currentItemId:*;

        public var StoreListingItemPicture:flash.display.MovieClip;

        private var storeFlag:Boolean;

        private var _myLife:flash.display.MovieClip;

        public var txtCrewMembers:flash.text.TextField;

        public var btnCancel:flash.display.SimpleButton;

        public static var EnergyMeter:Class;

        public static var PlusHeart:Class;

        public static var PlusDizzy:Class;
    }
}
