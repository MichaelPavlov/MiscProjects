package MyLife.factory 
{
    import flash.display.*;
    import flash.text.*;
    
    public class PreloaderStatus extends flash.display.Sprite
    {
        public function PreloaderStatus()
        {
            super();
            return;
        }

        public var taskPercent:flash.text.TextField;

        public var loadingBG:flash.display.MovieClip;

        public var task:flash.text.TextField;

        public var progressBar:flash.display.MovieClip;
    }
}
