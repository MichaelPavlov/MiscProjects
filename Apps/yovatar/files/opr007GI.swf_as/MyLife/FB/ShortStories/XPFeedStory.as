package MyLife.FB.ShortStories 
{
    import MyLife.FB.*;
    import MyLife.FB.Interfaces.*;
    
    public class XPFeedStory extends MyLife.FB.ShortStories.AbstractDelayedJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function XPFeedStory()
        {
            super(this, XP_FEED_TYPE, null, ShortStoryPublisher.PUBLISH_FIRST);
            return;
        }

        protected override function canShowFeed(arg1:Date):Boolean
        {
            return true;
        }
    }
}
