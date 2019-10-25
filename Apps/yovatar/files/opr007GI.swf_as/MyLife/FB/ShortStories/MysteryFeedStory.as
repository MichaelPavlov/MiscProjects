package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class MysteryFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function MysteryFeedStory()
        {
            super(this, MYSTERY_FEED_TYPE, SharedObjectManager.MYSTERY_FEED_DAILY);
            return;
        }
    }
}
