package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class BadgeInfoBox extends flash.display.Sprite
    {
        public function BadgeInfoBox(arg1:int=-1, arg2:Array=null, arg3:Array=null, arg4:int=-1, arg5:int=-1)
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = null;
            _myLife = MyLifeInstance.getInstance();
            _variables = _myLife.myLifeConfiguration.variables;
            _badgeManager = BadgeManager.instance;
            super();
            badgeType = arg1;
            score = arg4;
            threshold = arg5;
            loadedImageCount = 0;
            maxLevel = -1;
            loc7 = 0;
            loc8 = arg2;
            for each (loc6 in loc8)
            {
                if (!(loc6[1] > maxLevel))
                {
                    continue;
                }
                maxLevel = loc6[1];
            }
            this.badgeList = arg2;
            this.missingBadgeList = arg3;
            LoadBadgeText();
            return;
        }

        public function LoadBadgeText():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = new TextFormat();
            loc1.bold = true;
            loc1.size = 13;
            BadgeTitleField.text = _badgeManager.getBadgeName(badgeType, maxLevel);
            BadgeTitleField.setTextFormat(loc1);
            BadgeDescriptionField.text = ParseDescription(_badgeManager.getBadgeDescription(badgeType, maxLevel), [threshold]);
            loc2 = (score as Number) / (threshold as Number);
            loc3 = loc2 * 100;
            if (loc3 > 100)
            {
                loc3 = 100;
            }
            BadgeProgressField.text = loc3 + "%";
            BadgeScoreField.text = "Best: " + score;
            return;
        }

        public function LoadBadgeImages():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = null;
            loc2 = null;
            maxLevel = -1;
            loc3 = 0;
            loc4 = badgeList;
            for each (loc1 in loc4)
            {
                LoadBadgeImage(loc1[0], loc1[1]);
            }
            loc3 = 0;
            loc4 = missingBadgeList;
            for each (loc2 in loc4)
            {
                LoadMissingBadgeImage(loc2[0], loc2[1]);
            }
            return;
        }

        public function LoadMissingBadgeImage(arg1:int, arg2:int):void
        {
            LoadBadgeImageHelper(arg1, arg2, MissingBadgeImageComplete, MissingBadgeImageError);
            return;
        }

        public function LoadBadgeImage(arg1:int, arg2:int):void
        {
            LoadBadgeImageHelper(arg1, arg2, BadgeImageComplete, BadgeImageError);
            return;
        }

        public function MissingBadgeImageComplete(arg1:flash.events.Event, arg2:flash.display.Bitmap=null, arg3:int=-1):void
        {
            BadgeImageCompleteHelper(arg1, MISSING_BADGE_OPACITY, arg2, arg3);
            return;
        }

        public function MissingBadgeImageError(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, MissingBadgeImageComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, MissingBadgeImageError);
            return;
        }

        public function BadgeImageError(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as AssetLoader;
            loc2.removeEventListener(Event.COMPLETE, BadgeImageComplete);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, BadgeImageError);
            return;
        }

        public function ParseDescription(arg1:String, arg2:Array):String
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = "#NUM#";
            loc4 = "";
            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            loc6 = arg1.indexOf(loc3, loc5);
            while (loc6 >= 0) 
            {
                loc4 = (loc4 = loc4 + arg1.substring(loc5, loc6)) + arg2[loc7];
                loc5 = loc6 + loc3.length;
                loc6 = arg1.indexOf(loc3, loc5);
                ++loc7;
            }
            return loc4 = loc4 + arg1.substring(loc5, arg1.length);
        }

        public function BadgeImageComplete(arg1:flash.events.Event, arg2:flash.display.Bitmap=null, arg3:int=-1):void
        {
            BadgeImageCompleteHelper(arg1, 1, arg2, arg3);
            return;
        }

        public function LoadBadgeImageHelper(arg1:int, arg2:int, arg3:Function, arg4:Function):void
        {
            var loc5:*;
            var loc6:*;

            loc6 = null;
            if ((loc5 = _badgeManager.getSmallImageURL(arg1, arg2)) == null)
            {
                return;
            }
            if (_badgeManager.imageCache.hasOwnProperty(loc5))
            {
                arg3(null, _badgeManager.imageCache[loc5], arg2);
            }
            else 
            {
                (loc6 = new AssetLoader(loc5, null, {"path":loc5, "level":arg2})).addEventListener(Event.COMPLETE, arg3);
                loc6.addEventListener(IOErrorEvent.IO_ERROR, arg4);
            }
            return;
        }

        public function PlaceBadge(arg1:flash.display.Bitmap, arg2:int=-1):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = 0;
            loc4 = 0;
            if (arg2 >= 0)
            {
                loc4 = arg2;
                loc5 = loc4;
                switch (loc5) 
                {
                    case 0:
                        BadgeL1.addChild(arg1);
                        break;
                    case 1:
                        BadgeL2.addChild(arg1);
                        break;
                    case 2:
                        BadgeL3.addChild(arg1);
                        break;
                    case 3:
                        BadgeL4.addChild(arg1);
                        break;
                    case 4:
                        BadgeL5.addChild(arg1);
                        break;
                }
            }
            return;
        }

        public function BadgeImageCompleteHelper(arg1:flash.events.Event, arg2:Number=1, arg3:flash.display.Bitmap=null, arg4:int=-1):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = null;
            loc6 = 0;
            loc7 = null;
            if (arg1 != null)
            {
                (loc7 = arg1.currentTarget as AssetLoader).removeEventListener(Event.COMPLETE, MissingBadgeImageComplete);
                loc7.removeEventListener(IOErrorEvent.IO_ERROR, MissingBadgeImageError);
                loc5 = loc7.content as Bitmap;
                if (loc7.context)
                {
                    _badgeManager.imageCache[loc7.context["path"]] = loc5;
                    loc6 = loc7.context["level"];
                }
            }
            else 
            {
                loc5 = arg3;
                loc6 = arg4;
            }
            loc5.alpha = arg2;
            PlaceBadge(loc5, loc6);
            loadedImageCount++;
            if (loadedImageCount == NUM_LEVELS)
            {
                this.dispatchEvent(new MyLifeEvent(MyLifeEvent.BADGE_INFO_BOX_LOADING_COMPLETE, {"badgeType":badgeType}));
            }
            return;
        }

        public const NUM_LEVELS:int=5;

        public const MISSING_BADGE_OPACITY:Number=0.15;

        private var maxLevel:int;

        public var BadgeDescriptionField:flash.text.TextField;

        public var BadgeProgressField:flash.text.TextField;

        private var score:int;

        public var imageUrl:String="";

        private var missingBadgeList:Array;

        public var BadgeL2:flash.display.Sprite;

        public var BadgeL3:flash.display.Sprite;

        public var BadgeL4:flash.display.Sprite;

        public var BadgeL5:flash.display.Sprite;

        public var BadgeL1:flash.display.Sprite;

        private var loadedImageCount:int;

        private var badgeList:Array;

        public var BadgeTitleField:flash.text.TextField;

        private var _myLife:*;

        private var _badgeManager:MyLife.BadgeManager;

        private var threshold:int;

        public var BadgeScoreField:flash.text.TextField;

        private var _variables:Object;

        private var badgeType:int;
    }
}
