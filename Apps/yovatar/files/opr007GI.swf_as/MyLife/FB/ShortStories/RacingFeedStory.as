package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class RacingFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function RacingFeedStory()
        {
            super(this, RACING_FEED_TYPE, SharedObjectManager.RACING_FEED_DAILY);
            return;
        }
    }
}
