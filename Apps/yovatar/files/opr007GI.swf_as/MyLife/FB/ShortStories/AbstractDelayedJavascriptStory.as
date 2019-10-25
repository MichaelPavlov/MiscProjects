package MyLife.FB.ShortStories 
{
    import MyLife.FB.Interfaces.*;
    import flash.utils.*;
    
    public class AbstractDelayedJavascriptStory extends MyLife.FB.ShortStories.AbstractJavascriptStory implements MyLife.FB.Interfaces.ShortStory
    {
        public function AbstractDelayedJavascriptStory(arg1:MyLife.FB.ShortStories.AbstractJavascriptStory, arg2:String, arg3:String, arg4:int=5, arg5:int=1000)
        {
            super(arg1, arg2, arg3, arg4);
            this.delay = arg5;
            return;
        }

        public function delayedPublish():void
        {
            clearTimeout(feedInterval);
            super.publish();
            return;
        }

        public override function publish():void
        {
            if (getFeedObject())
            {
                feedInterval = setTimeout(delayedPublish, delay);
            }
            return;
        }

        protected var delay:int;

        private var feedInterval:Number;
    }
}
