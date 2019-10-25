package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class AppearanceFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function AppearanceFeedStory()
        {
            super(this, APPEARANCE_FEED_TYPE, SharedObjectManager.APPEARANCE_FEED_DAILY);
            return;
        }
    }
}
