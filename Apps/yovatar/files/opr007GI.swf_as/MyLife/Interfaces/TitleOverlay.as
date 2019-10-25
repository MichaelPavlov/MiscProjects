package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    import gs.*;
    
    public class TitleOverlay extends flash.display.MovieClip
    {
        public function TitleOverlay()
        {
            super();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            _myLife.addChild(this);
            if (arg2)
            {
                if (arg2.title)
                {
                    this.titleTextField.text = arg2.title;
                }
            }
            this.hide();
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        public function closeWindow():*
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        public function show():void
        {
            this.visible = true;
            this.alpha = 0;
            TweenLite.to(this, 1, {"alpha":1});
            return;
        }

        public var titleTextField:flash.text.TextField;

        private var _myLife:flash.display.MovieClip;
    }
}
