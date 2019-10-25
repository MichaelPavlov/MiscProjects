package MyLife.Assets 
{
    import MyLife.*;
    import flash.display.*;
    import flash.utils.*;
    
    public class InteractiveItem extends MyLife.Assets.SimpleItem
    {
        public function InteractiveItem()
        {
            super();
            return;
        }

        public function init():void
        {
            this.getItemData();
            this.className = this.itemData.className;
            return;
        }

        public function clearViews():void
        {
            var loc1:*;

            loc1 = this.numChildren;
            while (loc1--) 
            {
                this.removeChildAt(0);
            }
            this.currentView = null;
            return;
        }

        public function register():void
        {
            this.zim = ZoneItemManager.instance;
            if (!this.zim.disabled)
            {
                this.zim.registerItem(this);
                this.isRegistered = true;
            }
            return;
        }

        public function showView(arg1:String="Front"):void
        {
            var ViewClass:Object;
            var loc2:*;
            var loc3:*;
            var viewClassName:String;
            var viewInstance:flash.display.MovieClip;
            var viewName:String="Front";

            viewClassName = null;
            viewInstance = null;
            ViewClass = null;
            viewName = arg1;
            this.clearViews();
            this.currentViewName = viewName;
            viewClassName = this.className + "." + this.currentViewName;
            try
            {
                try
                {
                    ViewClass = getDefinitionByName(viewClassName);
                }
                catch (error:*)
                {
                    this.currentViewName = "Front";
                    viewClassName = this.className + "." + this.currentViewName;
                    ViewClass = getDefinitionByName(viewClassName);
                }
                viewInstance = new ViewClass() as MovieClip;
                initView(viewInstance);
            }
            catch (error:*)
            {
                trace("error = " + undefined);
            }
            return;
        }

        public function unregister():void
        {
            this.zim.removeItem(this);
            return;
        }

        public override function getItemData():Object
        {
            if (!this.itemData)
            {
                this.itemData = super.getItemData();
                this.itemData.isInteractive = true;
                this.itemData.isProp = false;
            }
            return this.itemData;
        }

        protected function initView(arg1:flash.display.MovieClip):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = 0;
            if (this.currentViewName != "Preview")
            {
                loc3 = arg1.numChildren;
                while (loc3--) 
                {
                    loc2 = arg1.getChildAt(0);
                    this.addChild(loc2);
                }
                this.itemImage = arg1["itemImage"];
                this.hitZone = arg1["hitZone"];
                this.itemMask = arg1["itemMask"];
                if (!this.isRegistered)
                {
                    this.register();
                }
            }
            else 
            {
                this.addChild(arg1);
            }
            return;
        }

        public function activate():void
        {
            this.isActivated = true;
            return;
        }

        public function deactivate():void
        {
            this.isActivated = false;
            return;
        }

        public var clickEvent:Boolean;

        public var loaded:Boolean;

        public var itemImage:flash.display.MovieClip;

        public var isox:Number;

        public var isoy:Number;

        public var itemId:*;

        public var childIndex:*;

        protected var zim:MyLife.ZoneItemManager;

        public var itemMask:flash.display.MovieClip;

        public var className:String;

        public var rotationView:int;

        public var currentView:flash.display.MovieClip;

        public var isActivated:Boolean;

        public var isRegistered:Boolean;

        public var playerItemId:*;

        public var sortOrder:int;

        public var isInteractive:Boolean=true;

        public var itemData:Object;

        public var hitZone:flash.display.MovieClip;

        public var currentViewName:String;

        public var inactive:Boolean;

        public var depth_value:int;

        public var isoOffset:Object;

        public var r:int;
    }
}
