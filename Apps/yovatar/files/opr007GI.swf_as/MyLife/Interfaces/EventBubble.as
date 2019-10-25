package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class EventBubble extends flash.display.MovieClip
    {
        public function EventBubble()
        {
            super();
            this.makeListeners();
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        protected function btnEditClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.dispatchEvent(new Event("editClick"));
            this.hide();
            return;
        }

        protected function makeListeners():void
        {
            this.btnEdit.addEventListener(MouseEvent.CLICK, btnEditClickHandler, false, 0, true);
            this.btnEndEvent.addEventListener(MouseEvent.CLICK, btnEndEventClickHandler, false, 0, true);
            this.btnX.addEventListener(MouseEvent.CLICK, btnXClickHandler, false, 0, true);
            return;
        }

        public function deactivate():void
        {
            this.hide();
            return;
        }

        protected function btnEndEventClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.dispatchEvent(new Event("endClick"));
            this.hide();
            return;
        }

        public function activate(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            this.eventData = arg1 || {};
            this.title.text = "Event: " + this.eventData.title;
            this.description.text = this.eventData.desc;
            loc2 = MyLifeInstance.getInstance().getPlayer()._playerId;
            loc3 = loc2 == arg1.pid;
            this.btnEndEvent.visible = loc4 = loc3;
            this.btnEdit.visible = loc4;
            this.show();
            return;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }

        protected function btnXClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.hide();
            return;
        }

        public var btnX:flash.display.SimpleButton;

        public var eventData:Object;

        public var btnEdit:flash.display.SimpleButton;

        public var title:flash.text.TextField;

        public var btnEndEvent:flash.display.SimpleButton;

        public var description:flash.text.TextField;
    }
}
