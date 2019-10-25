package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    import MyLife.FB.Objects.*;
    
    public class ItemFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function ItemFeedStory()
        {
            super(this, ITEM_FEED_TYPE, SharedObjectManager.ITEM_FEED_DAILY);
            itemFeedList = new Array();
            return;
        }

        private function isBestItem(arg1:MyLife.FB.Objects.ItemFeedObject):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = true;
            loc4 = 0;
            loc5 = itemFeedList;
            for each (loc3 in loc5)
            {
                if (!(arg1.getPrice() < loc3.getPrice()))
                {
                    continue;
                }
                loc2 = false;
            }
            return loc2;
        }

        protected override function canShowFeed(arg1:Date):Boolean
        {
            return super.canShowFeed(arg1) && !(itemFeedList == null) && itemFeedList.length > 0;
        }

        private function getBestItem():MyLife.FB.Objects.ItemFeedObject
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = null;
            loc2 = null;
            loc3 = 0;
            loc4 = itemFeedList;
            for each (loc2 in loc4)
            {
                if (!(loc1 && loc2.getPrice() > loc1.getPrice()))
                {
                    continue;
                }
                loc1 = loc2;
            }
            return loc1;
        }

        private function isWorstItem(arg1:MyLife.FB.Objects.ItemFeedObject):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = true;
            loc4 = 0;
            loc5 = itemFeedList;
            for each (loc3 in loc5)
            {
                if (!(arg1.getPrice() > loc3.getPrice()))
                {
                    continue;
                }
                loc2 = false;
            }
            return loc2;
        }

        public override function addItem(arg1:MyLife.FB.Interfaces.FeedObject):int
        {
            if (canAddItem(arg1 as ItemFeedObject))
            {
                if (itemFeedList.length < MAX_LIST_LENGTH)
                {
                    itemFeedList.push(arg1);
                }
                else 
                {
                    itemFeedList[getWorstIndex()] = arg1;
                }
                if (isBestItem(arg1 as ItemFeedObject))
                {
                    this.feedObject = arg1 as ItemFeedObject;
                }
            }
            return itemFeedList.length;
        }

        private function canAddItem(arg1:MyLife.FB.Objects.ItemFeedObject):Boolean
        {
            return itemFeedList.length < MAX_LIST_LENGTH || !isWorstItem(arg1);
        }

        private function getWorstIndex():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc1 = 0;
            loc2 = -1;
            loc3 = 0;
            loc5 = 0;
            loc6 = itemFeedList;
            for each (loc4 in loc6)
            {
                if (loc4.getPrice() < loc2 && loc2 >= 0)
                {
                    loc2 = loc4.getPrice();
                    loc1 = loc3;
                }
                ++loc3;
            }
            return loc1;
        }

        
        {
            MAX_LIST_LENGTH = 1;
        }

        private var itemFeedList:Array;

        private static var MAX_LIST_LENGTH:*=1;
    }
}
