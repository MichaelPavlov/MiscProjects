package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class EventLink extends flash.display.MovieClip
    {
        public function EventLink()
        {
            var loc1:*;

            super();
            this.textField = this.getChildAt(1) as TextField;
            this.textField.autoSize = TextFieldAutoSize.CENTER;
            this.bg = this.getChildAt(0) as Shape;
            this.buttonMode = loc1 = true;
            this.useHandCursor = loc1;
            this.mouseChildren = false;
            this.hide();
            return;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        public function activate(arg1:Object):void
        {
            var loc2:*;

            loc2 = null;
            this.eventData = arg1 || {};
            if (this.eventData.hostName)
            {
                loc2 = this.eventData.hostName + "\'s ";
            }
            else 
            {
                loc2 = "Event: ";
            }
            if (this.eventData.title)
            {
                loc2 = loc2 + "<u>" + this.eventData.title + "</u>";
                this.title = loc2;
                this.show();
            }
            return;
        }

        public function set title(arg1:String):void
        {
            this.textField.htmlText = arg1;
            this.bg.width = this.textField.width + this.PADDING * 2;
            return;
        }

        public function deactivate():void
        {
            this.hide();
            return;
        }

        public function get title():String
        {
            return this.textField.text;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }

        protected const PADDING:int=4;

        public var eventData:Object;

        protected var bg:flash.display.Shape;

        protected var textField:flash.text.TextField;
    }
}
