package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    
    public class FeedbackWindow extends flash.display.MovieClip
    {
        public function FeedbackWindow()
        {
            hotSpotList = [];
            super();
            cancelFeedbackButton.addEventListener(MouseEvent.CLICK, cancelFeedbackButtonClick);
            sendFeedbackButton.addEventListener(MouseEvent.CLICK, sendFeedbackButtonClick);
            StarRatingFeedback.addEventListener(MouseEvent.CLICK, StarRatingFeedbackClick);
            StarRatingFeedback.addEventListener(MouseEvent.MOUSE_MOVE, StarRatingFeedbackRollOver);
            StarRatingFeedback.addEventListener(MouseEvent.ROLL_OUT, StarRatingFeedbackRollOut);
            StarRatingFeedback.buttonMode = true;
            return;
        }

        private function hideMovieClip(arg1:*):*
        {
            arg1.visible = false;
            return;
        }

        private function sendFeedbackButtonClick(arg1:flash.events.MouseEvent):*
        {
            sendFeedbackButton.alpha = 0.5;
            sendFeedbackButton.mouseEnabled = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[this]});
            _myLife._interface.showInterface("GenericDialog", {"title":"Thank You For Your Feedback", "message":"Thank you for providing us with your feedback.\nWe use these suggestions to continually improve our product."});
            if (!(currentStarRating == 0 && txtSubject.text == "" && txtBody.text == ""))
            {
                _myLife.server.callExtension("sendFeedback", {"rating":currentStarRating, "subject":txtSubject.text, "message":txtBody.text});
            }
            return;
        }

        private function setStarRating(arg1:int):*
        {
            StarRatingFeedback.gotoAndStop(arg1 + 1);
            return;
        }

        private function StarRatingFeedbackClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = StarRatingFeedback.x - arg1.stageX;
            loc3 = Math.abs(Math.floor(loc2 / StarRatingFeedback.width * 5));
            currentStarRating = loc3;
            setStarRating(currentStarRating);
            return;
        }

        private function cancelFeedbackButtonClick(arg1:flash.events.MouseEvent):*
        {
            txtSubject.visible = false;
            txtBody.visible = false;
            TweenLite.to(this, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[this]});
            return;
        }

        private function StarRatingFeedbackRollOut(arg1:flash.events.MouseEvent):*
        {
            setStarRating(currentStarRating);
            return;
        }

        private function StarRatingFeedbackRollOver(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = StarRatingFeedback.x - arg1.stageX;
            loc3 = Math.abs(Math.floor(loc2 / StarRatingFeedback.width * 5));
            setStarRating(loc3);
            return;
        }

        public function resetForm(arg1:flash.display.MovieClip):*
        {
            _myLife = arg1;
            txtSubject.visible = true;
            txtBody.visible = true;
            txtSubject.text = "";
            txtBody.text = "";
            sendFeedbackButton.alpha = 1;
            sendFeedbackButton.mouseEnabled = true;
            currentStarRating = 0;
            setStarRating(currentStarRating);
            return;
        }

        public var StarRatingFeedback:flash.display.MovieClip;

        public var txtSubject:flash.text.TextField;

        private var _myLife:flash.display.MovieClip;

        private var hotSpotList:Array;

        private var currentStarRating:Number=0;

        public var cancelFeedbackButton:flash.display.SimpleButton;

        public var txtBody:flash.text.TextField;

        private var mapWorldCoundChannel:*;

        public var sendFeedbackButton:flash.display.SimpleButton;
    }
}
