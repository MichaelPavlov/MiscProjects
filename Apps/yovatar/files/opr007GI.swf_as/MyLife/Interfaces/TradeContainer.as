package MyLife.Interfaces 
{
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    
    public class TradeContainer extends flash.display.Sprite
    {
        public function TradeContainer()
        {
            super();
            this.init();
            return;
        }

        public function enable():void
        {
            var loc1:*;

            this.disableLayer.visible = false;
            btnPlus1000.visible = loc1 = true;
            btnPlus100.visible = loc1 = loc1;
            btnPlus10.visible = loc1 = loc1;
            btnPlus1.visible = loc1;
            this.addListeners();
            return;
        }

        public function setCheckBoxAgree(arg1:Boolean):void
        {
            this.isAgreed = arg1;
            this.checkBoxAgree.selected = arg1;
            return;
        }

        private function addListeners():void
        {
            this.removeListeners();
            this.btnPlus1.addEventListener(MouseEvent.CLICK, btnPlus1ClickHandler, false, 0, true);
            this.btnPlus10.addEventListener(MouseEvent.CLICK, btnPlus10ClickHandler, false, 0, true);
            this.btnPlus100.addEventListener(MouseEvent.CLICK, btnPlus100ClickHandler, false, 0, true);
            this.btnPlus1000.addEventListener(MouseEvent.CLICK, btnPlus1000ClickHandler, false, 0, true);
            this.checkBoxAgree.addEventListener(MouseEvent.CLICK, checkBoxClickHandler, false, 0, true);
            return;
        }

        public function checkMouseOverContainer():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc1 = false;
            loc2 = this.bg.getBounds(this);
            if (this.mouseX > loc2.left && this.mouseX < loc2.right)
            {
                if (this.mouseY > loc2.top && this.mouseY < loc2.bottom)
                {
                    loc1 = true;
                }
            }
            return loc1;
        }

        public function setTitle(arg1:String):void
        {
            this.txtTitle.htmlText = "<b>" + arg1 + "</b>";
            return;
        }

        private function getNextContainer():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = null;
            loc2 = null;
            loc3 = 0;
            loc5 = 0;
            loc4 = -1;
            loc5 = 0;
            while (loc5 < this.CONTAINER_COUNT) 
            {
                loc1 = this.containers[loc5];
                loc2 = loc1["imageContainer"];
                loc3 = loc2.numChildren;
                if (loc3 < 1)
                {
                    loc4 = loc5;
                    break;
                }
                ++loc5;
            }
            return loc4;
        }

        private function init():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = undefined;
            this.disableLayer.visible = false;
            this.disableLayer.mouseChildren = false;
            this.disableLayer.mouseEnabled = false;
            this.containers = new Array(this.CONTAINER_COUNT);
            loc2 = this.CONTAINER_COUNT;
            while (loc2--) 
            {
                loc1 = this[("tradeItemContainer" + loc2)];
                this.containers[loc2] = loc1;
                loc1["txtQuantity"].visible = false;
            }
            this.setCoins();
            this.items = {};
            checkBoxAgree = new CheckBox();
            cbContainer.addChild(checkBoxAgree);
            this.checkBoxAgree.useHandCursor = true;
            this.toolTip = new ToolTip();
            this.addChild(this.toolTip);
            this.addListeners();
            return;
        }

        private function btnPlus1ClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.addCoin(1);
            return;
        }

        private function btnPlus1000ClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.addCoin(1000);
            return;
        }

        public function addCoin(arg1:int=1):void
        {
            this.coinCount = this.coinCount + (arg1 >= 0) ? arg1 : -arg1;
            this.setCoinText(String(this.coinCount));
            this.dispatchEvent(new Event("coinUpdate"));
            return;
        }

        public function getCoins():int
        {
            return this.coinCount;
        }

        public function reset():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = null;
            loc3 = this.CONTAINER_COUNT;
            while (loc3--) 
            {
                loc1 = this.containers[loc3];
                loc2 = loc1["imageContainer"];
                if (loc2.numChildren)
                {
                    loc2.removeChildAt(0);
                }
                loc1["txtQuantity"].visible = false;
            }
            this.setCoins();
            this.items = {};
            return;
        }

        private function btnPlus100ClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.addCoin(100);
            return;
        }

        private function setCoinText(arg1:String):void
        {
            var loc2:*;

            this.txtCoins.text = arg1;
            loc2 = this.txtCoins.getCharBoundaries(0);
            this.coinIcon.x = this.txtCoins.x + loc2.left - 2;
            return;
        }

        private function removeListeners():void
        {
            this.btnPlus1.removeEventListener(MouseEvent.CLICK, btnPlus1ClickHandler);
            this.btnPlus10.removeEventListener(MouseEvent.CLICK, btnPlus10ClickHandler);
            this.btnPlus100.removeEventListener(MouseEvent.CLICK, btnPlus100ClickHandler);
            this.btnPlus1000.removeEventListener(MouseEvent.CLICK, btnPlus1000ClickHandler);
            this.checkBoxAgree.removeEventListener(MouseEvent.CLICK, checkBoxClickHandler);
            return;
        }

        private function checkBoxClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.isAgreed = this.checkBoxAgree.selected;
            this.dispatchEvent(new Event("agreeClick"));
            return;
        }

        public function disable(arg1:Boolean=false):void
        {
            var loc2:*;

            this.removeListeners();
            this.disableLayer.visible = true;
            this.disableLayer.mouseEnabled = false;
            btnPlus1000.visible = loc2 = false;
            btnPlus100.visible = loc2 = loc2;
            btnPlus10.visible = loc2 = loc2;
            btnPlus1.visible = loc2;
            this.txtAddCoins.visible = false;
            if (arg1)
            {
                this.checkBoxAgree.addEventListener(MouseEvent.CLICK, checkBoxClickHandler, false, 0, true);
            }
            this.checkBoxAgree.enabled = arg1;
            return;
        }

        public function addItem(arg1:flash.display.DisplayObject, arg2:*, arg3:String=""):Boolean
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc6 = null;
            loc7 = null;
            loc9 = null;
            loc10 = 0;
            loc11 = null;
            loc4 = true;
            loc5 = String(arg2);
            if (loc8 = this.items.hasOwnProperty(loc5))
            {
                loc6 = this.items[loc5];
                loc6.quantity = loc6.quantity + 1;
                (loc9 = (loc7 = this.containers[loc6.containerId])["txtQuantity"]).text = String(loc6.quantity);
                loc9.visible = true;
            }
            else 
            {
                if ((loc10 = this.getNextContainer()) >= 0)
                {
                    (loc6 = {}).itemId = arg2;
                    loc6.quantity = 1;
                    loc6.containerId = loc10;
                    loc6.name = arg3;
                    items[loc5] = loc6;
                    loc11 = (loc7 = this.containers[loc10])["imageContainer"];
                    arg1.width = PREVIEW_SIZE - (this.CONTAINER_PADDING << 1);
                    arg1.height = PREVIEW_SIZE - (this.CONTAINER_PADDING << 1);
                    arg1.y = loc12 = this.CONTAINER_PADDING;
                    arg1.x = loc12;
                    loc11.addChild(arg1);
                    loc7.txtName.text = arg3;
                    this.toolTip.addTool(loc11, arg3);
                }
                else 
                {
                    loc4 = false;
                }
            }
            return loc4;
        }

        public function setCoins(arg1:int=0):void
        {
            this.coinCount = (arg1 >= 0) ? arg1 : -arg1;
            this.setCoinText(String(this.coinCount));
            this.dispatchEvent(new Event("coinUpdate"));
            return;
        }

        private function btnPlus10ClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.addCoin(10);
            return;
        }

        public function getTradeData():Object
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = 0;
            loc5 = null;
            trace("getTradeData()");
            loc1 = {};
            loc1.coins = this.coinCount;
            loc2 = [];
            loc6 = 0;
            loc7 = items;
            for each (loc3 in loc7)
            {
                loc2.push(loc3);
            }
            loc2.sortOn("containerId", Array.DESCENDING | Array.NUMERIC);
            loc4 = loc2.length;
            while (loc4--) 
            {
                loc5 = loc2[loc4];
                loc2[loc4] = {"itemId":loc5.itemId, "quantity":loc5.quantity, "name":loc5.name};
            }
            loc1.items = loc2;
            return loc1;
        }

        private const CONTAINER_COUNT:int=6;

        private const CONTAINER_PADDING:int=4;

        private const PREVIEW_SIZE:int=50;

        public var isAgreed:Boolean;

        public var pid:*;

        public var btnPlus100:flash.display.SimpleButton;

        public var coinIcon:flash.display.MovieClip;

        private var containers:Array;

        public var btnPlus10:flash.display.SimpleButton;

        public var items:Object;

        public var bg:flash.display.MovieClip;

        public var tradeItemContainer0:flash.display.MovieClip;

        public var tradeItemContainer1:flash.display.MovieClip;

        public var txtTitle:flash.text.TextField;

        public var tradeItemContainer3:flash.display.MovieClip;

        public var tradeItemContainer4:flash.display.MovieClip;

        public var tradeItemContainer5:flash.display.MovieClip;

        public var tradeItemContainer6:flash.display.MovieClip;

        public var tradeItemContainer7:flash.display.MovieClip;

        public var tradeItemContainer8:flash.display.MovieClip;

        public var tradeItemContainer2:flash.display.MovieClip;

        public var disableLayer:flash.display.MovieClip;

        public var checkBoxAgree:fl.controls.CheckBox;

        public var btnPlus1:flash.display.SimpleButton;

        public var toolTip:MyLife.Interfaces.ToolTip;

        public var cbContainer:flash.display.MovieClip;

        public var txtAddCoins:flash.text.TextField;

        public var txtCoins:flash.text.TextField;

        public var btnPlus1000:flash.display.SimpleButton;

        private var coinCount:int;
    }
}
