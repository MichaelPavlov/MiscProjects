package MyLife.Components 
{
    import fl.controls.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class ComboBox2 extends fl.controls.ComboBox
    {
        public function ComboBox2()
        {
            super();
            return;
        }

        protected function mouseOutHandler(arg1:flash.events.MouseEvent):void
        {
            clearTimeout(this.closeTimeoutId);
            this.closeTimeoutId = setTimeout(close, closeTimeoutDelay);
            return;
        }

        protected function mouseOverHandler(arg1:flash.events.MouseEvent):void
        {
            clearTimeout(this.closeTimeoutId);
            return;
        }

        public override function open():void
        {
            this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.dropdown.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            this.dropdown.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            super.open();
            return;
        }

        public override function close():void
        {
            this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.dropdown.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            this.dropdown.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            super.close();
            return;
        }

        protected const closeTimeoutDelay:int=1000;

        protected var closeTimeoutId:int;
    }
}
