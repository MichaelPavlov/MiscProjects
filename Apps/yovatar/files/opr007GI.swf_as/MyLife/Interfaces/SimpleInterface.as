package MyLife.Interfaces 
{
    import flash.display.*;
    
    public class SimpleInterface extends flash.display.MovieClip
    {
        public function SimpleInterface()
        {
            super();
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }
    }
}
