package MyLife.Interfaces 
{
    import MyLife.*;
    import fl.controls.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class ChatWindowHistory extends flash.display.MovieClip
    {
        public function ChatWindowHistory()
        {
            messageHistoryList = [];
            super();
            btnShowChatLog.addEventListener(MouseEvent.CLICK, btnShowChatLogClick);
            btnHideChatLog.addEventListener(MouseEvent.CLICK, btnHideChatLogClick);
            chatScroller = new UIScrollBar();
            chatScroller.height = 100;
            showChatHistory(false);
            chatScrollerContainer.addChild(chatScroller);
            chatScroller.scrollTarget = txtChatLog;
            updateHistoryWindow();
            return;
        }

        private function btnHideChatLogClick(arg1:flash.events.MouseEvent):*
        {
            showChatHistory(false);
            return;
        }

        internal function htmlEntities(arg1:*):*
        {
            return arg1.replace(new RegExp("<", "g"), "&lt;").replace(new RegExp(">", "g"), "&gt;");
        }

        private function btnShowChatLogClick(arg1:flash.events.MouseEvent):void
        {
            showChatHistory(true);
            return;
        }

        public function logChatMessage(arg1:*, arg2:*):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = arg2.substr(2);
            loc5 = (loc4 = arg2.substr(0, 2)) == "P:";
            this.messageHistoryList.push({"s":arg1, "m":loc3, "p":loc5});
            if ((loc6 = this.messageHistoryList.length) > this.maxMessages)
            {
                this.messageHistoryList.shift();
            }
            updateHistoryWindow();
            return;
        }

        private function updateHistoryWindow(arg1:Boolean=false):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = undefined;
            loc5 = undefined;
            if (btnShowChatLog.visible)
            {
                return;
            }
            loc2 = "";
            loc3 = false;
            if (txtChatLog.numLines > 6)
            {
                if (txtChatLog.numLines - txtChatLog.scrollV > 5)
                {
                    loc3 = true;
                }
            }
            if (arg1)
            {
                loc3 = false;
            }
            loc2 = "<font color=\'#CEDBFD\'>Chat Log Started...</font>";
            loc6 = 0;
            loc7 = messageHistoryList;
            for each (loc4 in loc7)
            {
                if (loc4.p)
                {
                    loc2 = loc2 + "\n<font color=\'#8C1CFD\'><b>" + htmlEntities(loc4.s) + "</b></font>: <i><font color=\'#8C1CFD\'>" + htmlEntities(loc4.m) + "</font></i>";
                    continue;
                }
                loc2 = loc2 + "\n<font color=\'#CEDBFD\'><b>" + htmlEntities(loc4.s) + "</b></font><font color=\'#E7ECFE\'>: " + htmlEntities(loc4.m) + "</font>";
            }
            txtChatLog.htmlText = loc2;
            if (!loc3)
            {
                loc5 = txtChatLog.numLines;
                txtChatLog.scrollV = loc5;
            }
            if (txtChatLog.numLines < 7)
            {
                chatScroller.visible = false;
            }
            else 
            {
                chatScroller.visible = true;
            }
            chatScroller.update();
            return;
        }

        private function showChatHistory(arg1:*):*
        {
            btnShowChatLog.visible = !arg1;
            btnHideChatLog.visible = arg1;
            ChatWindowHistoryBG.visible = arg1;
            txtChatLog.visible = arg1;
            chatScroller.visible = arg1;
            if (arg1)
            {
                updateHistoryWindow(true);
            }
            return;
        }

        private var _myLife:flash.display.MovieClip;

        private var messageHistoryList:Array;

        public var chatScrollerContainer:flash.display.MovieClip;

        public var maxMessages:int=100;

        public var ChatWindowHistoryBG:flash.display.MovieClip;

        public var chatScroller:fl.controls.UIScrollBar;

        public var btnShowChatLog:flash.display.SimpleButton;

        public var btnHideChatLog:flash.display.SimpleButton;

        public var txtChatLog:flash.text.TextField;
    }
}
