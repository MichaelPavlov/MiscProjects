package MyLife.FB.ShortStories 
{
    import MyLife.*;
    import MyLife.FB.Interfaces.*;
    
    public class MessageFeedStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function MessageFeedStory()
        {
            super(this, MESSAGE_FEED_TYPE, SharedObjectManager.MESSAGE_FEED_DAILY);
            return;
        }
    }
}
