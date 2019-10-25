package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class BadgeFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function BadgeFeedStory()
        {
            super(this, BADGE_FEED_TYPE, SharedObjectManager.BADGE_FEED_DAILY);
            return;
        }
    }
}
