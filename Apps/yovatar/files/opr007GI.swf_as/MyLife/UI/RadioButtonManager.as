package MyLife.UI 
{
    import MyLife.Events.*;
    import flash.events.*;
    
    public class RadioButtonManager extends flash.events.EventDispatcher
    {
        public function RadioButtonManager(arg1:Array=null)
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            super();
            this.buttons = [];
            loc3 = 0;
            loc4 = arg1;
            for each (loc2 in loc4)
            {
                this.addButton(loc2);
            }
            return;
        }

        public function selectButtonById(arg1:int):void
        {
            var loc2:*;

            loc2 = this.buttons[arg1];
            this.selectButton(loc2);
            return;
        }

        public function clear():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = this.buttons;
            for each (loc1 in loc3)
            {
                loc1.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
            }
            this.buttons = [];
            return;
        }

        public function selectButton(arg1:MyLife.UI.IToggleButton):void
        {
            if (this.lastSelected != arg1)
            {
                if (this.lastSelected)
                {
                    this.lastSelected.isSelected = false;
                }
                this.lastSelected = arg1;
                this.lastSelected.isSelected = true;
                this.dispatchEvent(new Event(Event.SELECT));
            }
            return;
        }

        private function buttonClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as IToggleButton;
            if (loc2 != lastSelected)
            {
                selectButton(loc2);
            }
            else 
            {
                loc2.toggle();
            }
            return;
        }

        public function removeButton(arg1:MyLife.UI.IToggleButton):void
        {
            var loc2:*;

            loc2 = this.buttons.indexOf(arg1);
            if (loc2 >= 0)
            {
                arg1.removeEventListener(MouseEvent.CLICK, this.buttonClickHandler);
                this.buttons.splice(loc2, 1);
            }
            return;
        }

        public function addButton(arg1:MyLife.UI.IToggleButton):void
        {
            arg1.addEventListener(MouseEvent.CLICK, this.buttonClickHandler, false, 0, true);
            this.buttons.push(arg1);
            return;
        }

        public function get selected():MyLife.UI.IToggleButton
        {
            return lastSelected;
        }

        private var buttons:Array;

        private var lastSelected:MyLife.UI.IToggleButton;

        private var selectedEvent:MyLife.Events.ToggleEvent;
    }
}
