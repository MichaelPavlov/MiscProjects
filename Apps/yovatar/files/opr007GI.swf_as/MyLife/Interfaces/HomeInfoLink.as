package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class HomeInfoLink extends flash.display.MovieClip
    {
        public function HomeInfoLink()
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

            this.data = arg1 || {};
            this.isDefault = this.data.isDefault;
            this.title = this.data.title;
            loc2 = "";
            if (this.data.playerName)
            {
                loc2 = this.data.playerName + " ";
            }
            if (this.data.title)
            {
                loc2 = loc2 + this.data.title;
            }
            else 
            {
                loc2 = loc2 + "Home";
            }
            if (this.data.isOwner)
            {
                loc2 = "<u>" + loc2 + "</u>";
                this.useHandCursor = true;
            }
            else 
            {
                this.useHandCursor = false;
            }
            this.textField.htmlText = loc2;
            this.bg.width = this.textField.width + this.PADDING * 2;
            this.show();
            return;
        }

        public function deactivate():void
        {
            this.hide();
            return;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }

        protected const PADDING:int=4;

        protected var bg:flash.display.Shape;

        protected var textField:flash.text.TextField;

        public var isDefault:Boolean;

        public var title:String;

        public var data:Object;
    }
}
