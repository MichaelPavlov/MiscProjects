package MyLife 
{
    import flash.display.*;
    import flash.events.*;
    
    public class MovieClipPlayer extends flash.events.EventDispatcher
    {
        public function MovieClipPlayer(arg1:flash.display.MovieClip)
        {
            super();
            this._movieClip = arg1;
            this._movieClip.stop();
            return;
        }

        public function get movieClip():flash.display.MovieClip
        {
            return this._movieClip;
        }

        public function play():void
        {
            this._movieClip.play();
            this._movieClip.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }

        private function enterFrameHandler(arg1:flash.events.Event):void
        {
            this.checkComplete();
            return;
        }

        private function checkComplete():void
        {
            var loc1:*;

            loc1 = null;
            if (this._movieClip.currentFrame >= this._movieClip.totalFrames)
            {
                this.stop();
                loc1 = new Event(Event.COMPLETE);
                this.dispatchEvent(loc1);
            }
            return;
        }

        public function stop():void
        {
            this._movieClip.stop();
            this._movieClip.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }

        public function clearClip():void
        {
            _movieClip.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            _movieClip = null;
            return;
        }

        private var _movieClip:flash.display.MovieClip;
    }
}
