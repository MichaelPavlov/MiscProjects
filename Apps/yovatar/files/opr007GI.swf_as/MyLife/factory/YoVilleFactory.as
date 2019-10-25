package MyLife.factory 
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class YoVilleFactory extends flash.display.MovieClip
    {
        public function YoVilleFactory()
        {
            super();
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stop();
            init();
            return;
        }

        private function init():void
        {
            _preloader = new PreloaderStatus();
            addChild(_preloader);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            return;
        }

        private function initApp():void
        {
            var loc1:*;
            var loc2:*;

            loc2 = null;
            loc1 = Class(getDefinitionByName("YoVilleApp"));
            if (loc1)
            {
                loc2 = new loc1(loaderInfo.parameters);
                addChild(loc2 as DisplayObject);
            }
            return;
        }

        private function onEnterFrame(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = NaN;
            if (framesLoaded != totalFrames)
            {
                loc2 = Math.ceil(root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal * 100);
                _preloader.progressBar.gotoAndStop(loc2);
                _preloader.taskPercent.text = loc2.toString() + " %";
            }
            else 
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                removeChild(_preloader);
                nextFrame();
                initApp();
            }
            return;
        }

        private var _preloader:MyLife.factory.PreloaderStatus;
    }
}
