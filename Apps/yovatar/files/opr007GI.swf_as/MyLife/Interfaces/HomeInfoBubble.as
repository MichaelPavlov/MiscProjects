package MyLife.Interfaces 
{
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class HomeInfoBubble extends flash.display.MovieClip
    {
        public function HomeInfoBubble()
        {
            super();
            checkBox = new CheckBox();
            cbContainer.addChild(checkBox);
            this.makeListeners();
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

        public function get title():String
        {
            return this.titleTextField.text;
        }

        protected function makeListeners():void
        {
            this.btnCancel.addEventListener(MouseEvent.CLICK, btnCancelClickHandler, false, 0, true);
            this.btnSave.addEventListener(MouseEvent.CLICK, btnSaveClickHandler, false, 0, true);
            this.btnX.addEventListener(MouseEvent.CLICK, btnXClickHandler, false, 0, true);
            return;
        }

        public function deactivate():void
        {
            this.hide();
            return;
        }

        public function get isDefault():Boolean
        {
            return this.checkBox.selected;
        }

        public function activate(arg1:Object):void
        {
            trace("HomeInfoBubble() activate()");
            this.data = arg1 || {};
            this.titleTextField.text = this.data.title || "Home Name";
            this.titleTextField.selectable = Boolean(this.data.playerItemId);
            this.checkBox.selected = Boolean(this.data.isDefault);
            this.show();
            return;
        }

        protected function btnSaveClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.dispatchEvent(new Event(this.EVENT_SAVE_CLICKED));
            this.hide();
            return;
        }

        protected function btnXClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.hide();
            return;
        }

        protected function btnCancelClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.dispatchEvent(new Event(this.EVENT_CANCEL_CLICKED));
            this.hide();
            return;
        }

        public const EVENT_CANCEL_CLICKED:String="cancelClick";

        public const EVENT_SAVE_CLICKED:String="saveClick";

        public var btnSave:flash.display.SimpleButton;

        public var data:Object;

        public var btnCancel:flash.display.SimpleButton;

        public var titleTextField:flash.text.TextField;

        public var cbContainer:flash.display.MovieClip;

        public var checkBox:fl.controls.CheckBox;

        public var btnX:flash.display.SimpleButton;

        private var playerHomeId:int=0;
    }
}
