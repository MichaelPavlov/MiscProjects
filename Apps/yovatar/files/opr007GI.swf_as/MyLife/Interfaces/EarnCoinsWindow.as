package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    
    public class EarnCoinsWindow extends flash.display.MovieClip
    {
        public function EarnCoinsWindow()
        {
            super();
            trace("EarnCoinsWindow Loaded");
            cancelFeedbackButton.addEventListener(MouseEvent.CLICK, cancelFeedbackButtonClick);
            return;
        }

        private function hideMovieClip(arg1:*):*
        {
            arg1.visible = false;
            return;
        }

        private function cancelFeedbackButtonClick(arg1:flash.events.MouseEvent):*
        {
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[this]});
            return;
        }

        public var cancelFeedbackButton:flash.display.SimpleButton;

        public var stepFive:flash.display.MovieClip;
    }
}
