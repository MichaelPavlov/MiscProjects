package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class ApartmentFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function ApartmentFeedStory()
        {
            super(this, APARTMENT_FEED_TYPE, SharedObjectManager.APARTMENT_FEED_DAILY);
            return;
        }
    }
}
