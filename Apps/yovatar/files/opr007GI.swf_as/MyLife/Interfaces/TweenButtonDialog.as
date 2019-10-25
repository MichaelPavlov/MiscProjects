package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    
    public class TweenButtonDialog extends flash.display.MovieClip
    {
        public function TweenButtonDialog()
        {
            super();
            return;
        }

        protected function buttonMouseOverHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = null;
            loc4 = 0;
            loc5 = 0;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc2 = arg1.currentTarget as SimpleButton;
            if (loc2)
            {
                loc3 = arg1.buttonDown ? loc2.downState : loc2.overState;
                loc4 = loc3["numChildren"];
                loc5 = 0;
                while (loc5 < loc4) 
                {
                    if (loc7 = (loc6 = loc3["getChildAt"]).call(loc3, loc5) as MovieClip)
                    {
                        (loc8 = new MovieClipPlayer(loc7)).play();
                    }
                    ++loc5;
                }
            }
            return;
        }

        protected function buttonMouseDownHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc2 = arg1.currentTarget as SimpleButton;
            if (loc2)
            {
                loc3 = loc2.downState["numChildren"];
                loc4 = 0;
                while (loc4 < loc3) 
                {
                    if (loc6 = (loc5 = loc2.downState["getChildAt"]).call(loc2.downState, loc4) as MovieClip)
                    {
                        (loc7 = new MovieClipPlayer(loc6)).play();
                    }
                    ++loc4;
                }
            }
            return;
        }

        protected function removeButtonListeners(arg1:flash.display.SimpleButton):void
        {
            arg1.removeEventListener(MouseEvent.MOUSE_OVER, buttonMouseOverHandler);
            arg1.removeEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDownHandler);
            arg1.removeEventListener(MouseEvent.MOUSE_OUT, buttonMouseOutHandler);
            arg1.removeEventListener(MouseEvent.MOUSE_UP, buttonMouseUpHandler);
            return;
        }

        protected function buttonMouseUpHandler(arg1:flash.events.MouseEvent):void
        {
            buttonMouseOverHandler(arg1);
            return;
        }

        protected function addButtonListeners(arg1:flash.display.SimpleButton):void
        {
            arg1.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOverHandler);
            arg1.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDownHandler);
            arg1.addEventListener(MouseEvent.MOUSE_OUT, buttonMouseOutHandler);
            arg1.addEventListener(MouseEvent.MOUSE_UP, buttonMouseUpHandler);
            return;
        }

        protected function buttonMouseOutHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc2 = arg1.currentTarget as SimpleButton;
            if (loc2 && arg1.buttonDown)
            {
                loc3 = loc2.overState["numChildren"];
                loc4 = 0;
                while (loc4 < loc3) 
                {
                    if (loc6 = (loc5 = loc2.overState["getChildAt"]).call(loc2.overState, loc4) as MovieClip)
                    {
                        (loc7 = new MovieClipPlayer(loc6)).play();
                    }
                    ++loc4;
                }
            }
            return;
        }
    }
}
