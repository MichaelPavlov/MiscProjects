package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class StandardDialog extends flash.display.MovieClip
    {
        public function StandardDialog(arg1:flash.display.MovieClip, arg2:String, arg3:int=-1, arg4:int=-1, arg5:int=320, arg6:int=300, arg7:Boolean=true)
        {
            var loc8:*;

            CloseWindowButton = StandardDialog_CloseWindowButton;
            super();
            this.x = arg5;
            this.y = arg6;
            this.content = arg1;
            this.dialogBackground = new StandardDialogBg();
            dialogBackground.visible = arg7;
            dialogBackground.width = (arg3 != -1) ? arg3 : arg1.width;
            dialogBackground.height = (arg4 != -1) ? arg4 : arg1.height + TITLE_BAR_HEIGHT;
            addChild(dialogBackground);
            (loc8 = new TextFormat()).font = "Tahoma";
            loc8.align = "center";
            loc8.size = 23;
            loc8.color = 0;
            this.titleText = new TextField();
            titleText.autoSize = TextFieldAutoSize.CENTER;
            titleText.text = arg2;
            titleText.embedFonts = true;
            titleText.setTextFormat(loc8);
            titleText.width = titleText.textWidth + 50;
            titleText.x = -titleText.width / 2;
            titleText.y = -dialogBackground.height / 2 + TITLE_BAR_HEIGHT / 3;
            addChild(titleText);
            this.contentContainer = new Sprite();
            contentContainer.x = -dialogBackground.width * 0.5;
            contentContainer.y = titleText.y + arg2 ? titleText.height : 0;
            addChild(contentContainer);
            contentContainer.addChild(arg1);
            this.btnCloseWindow = new CloseWindowButton();
            btnCloseWindow.x = dialogBackground.width / 2 - btnCloseWindow.width / 4;
            btnCloseWindow.y = -dialogBackground.height / 2 + btnCloseWindow.height / 4 + 10;
            btnCloseWindow.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
            addChild(btnCloseWindow);
            if (arg1)
            {
                arg1.addEventListener(Event.CLOSE, onContentClose, false, 0, true);
            }
            return;
        }

        public function getContent():flash.display.MovieClip
        {
            return content;
        }

        private function onBtnCloseClick(arg1:flash.events.MouseEvent=null):void
        {
            MyLifeInstance.getInstance().hideDialog(this);
            btnCloseWindow.removeEventListener(MouseEvent.CLICK, onBtnCloseClick);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE));
            return;
        }

        public function show(arg1:Boolean=false, arg2:Boolean=false, arg3:Boolean=false):void
        {
            MyLifeInstance.getInstance().showDialog(this, arg1, arg2, arg3);
            return;
        }

        private function onContentClose(arg1:flash.events.Event):void
        {
            onBtnCloseClick();
            return;
        }

        
        {
            TITLE_BAR_HEIGHT = 20;
        }

        private var titleText:flash.text.TextField;

        private var contentContainer:flash.display.Sprite;

        private var btnCloseWindow:flash.display.SimpleButton;

        private var dialogBackground:MyLife.Interfaces.StandardDialogBg;

        private var content:flash.display.MovieClip;

        private var CloseWindowButton:Class;

        private static var TITLE_BAR_HEIGHT:int=20;
    }
}
