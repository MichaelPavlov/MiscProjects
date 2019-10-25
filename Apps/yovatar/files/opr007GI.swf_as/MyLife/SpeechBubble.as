package MyLife 
{
    import MyLife.Interfaces.*;
    import MyLife.Utils.Math.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class SpeechBubble extends flash.display.MovieClip
    {
        public function SpeechBubble(arg1:flash.display.MovieClip)
        {
            messagesList = new Array();
            cleanupTimer = new Timer(1250);
            super();
            cleanupTimer.addEventListener("timer", cleanupMessages);
            cleanupTimer.start();
            render();
            return;
        }

        public function remove():void
        {
            messagesList.splice(0);
            cleanupTimer.stop();
            cleanupTimer.removeEventListener("timer", cleanupMessages);
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            return;
        }

        private function drawBubbleText():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = NaN;
            loc6 = null;
            loc7 = 0;
            bubbleHeight = MIN_HEIGHT;
            bubbleWidth = MIN_WIDTH;
            loc1 = 0;
            loc8 = 0;
            loc9 = messagesList;
            label605: for each (loc2 in loc9)
            {
                if (!(loc2.msg && loc2.age <= MESSAGE_LIFE))
                {
                    continue;
                }
                loc10 = loc2.msg.substr(0, 2);
                switch (loc10) 
                {
                    case "C:":
                    case "P:":
                        loc3 = new TextFormat();
                        loc3.font = "Tahoma";
                        loc3.align = "center";
                        loc3.size = 12;
                        if (loc2.msg.substr(0, 2) != "P:")
                        {
                            loc3.color = 3355443;
                        }
                        else 
                        {
                            loc3.color = 11141120;
                            loc3.italic = true;
                        }
                        (loc4 = new TextField()).selectable = false;
                        loc4.wordWrap = true;
                        loc4.multiline = true;
                        loc4.embedFonts = true;
                        loc4.defaultTextFormat = loc3;
                        loc4.antiAliasType = AntiAliasType.ADVANCED;
                        loc4.text = loc2.msg.substr(2);
                        loc4.width = MAX_WIDTH - TEXT_PADDING * 2;
                        loc4.height = MAX_HEIGHT;
                        if ((loc5 = loc4.textWidth + TEXT_PADDING * 4 + 8) < MIN_WIDTH)
                        {
                            loc5 = MIN_WIDTH;
                        }
                        else 
                        {
                            if (loc5 > MAX_WIDTH)
                            {
                                loc5 = MAX_WIDTH;
                            }
                        }
                        if (loc5 > bubbleWidth)
                        {
                            bubbleWidth = loc5;
                        }
                        loc4.x = -bubbleWidth / 2 + ARROW_SIZE + TEXT_PADDING;
                        loc4.width = bubbleWidth - TEXT_PADDING * 2;
                        loc4.height = loc4.textHeight + 4;
                        loc1 = loc1 + TEXT_PADDING + loc4.height;
                        loc4.y = (-ARROW_SIZE - loc1 - 1);
                        _bubbleClip.addChild(loc4);
                        continue label605;
                    case "E:":
                        loc1 = loc1 + 40;
                        loc6 = new EmoticonStripClip();
                        loc7 = Number(loc2.msg.substr(2));
                        loc6.gotoAndStop(loc7);
                        loc6.x = -8;
                        loc6.y = -loc1 - 20;
                        _bubbleClip.addChild(loc6);
                        continue label605;
                    default:
                        trace("Unhandled Message Type: " + loc2.msg.substr(0, 2));
                }
            }
            bubbleHeight = loc1 + TEXT_PADDING;
            return;
        }

        public function sayMessage(arg1:*, arg2:Boolean=false):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            if (arg1 as DisplayObject)
            {
                loc3 = arg1;
                arg1 = null;
                arg2 = true;
            }
            messagesList.unshift({"msg":arg1, "age":0});
            loc4 = arg2 ? 1 : 3;
            if (!arg1 && loc4 == 1)
            {
                loc4 = 0;
            }
            while (messagesList.length > loc4) 
            {
                messagesList.pop();
            }
            render();
            if (loc3)
            {
                messagesList.unshift({"age":0});
                renderObjectBubble(loc3);
            }
            return;
        }

        private function render():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            if (_bubbleClip != null)
            {
                removeChild(_bubbleClip);
                while (_bubbleClip.numChildren) 
                {
                    _bubbleClip.removeChildAt(0);
                }
            }
            loc1 = 0;
            loc3 = 0;
            loc4 = messagesList;
            for each (loc2 in loc4)
            {
                if (loc2.age <= MESSAGE_LIFE)
                {
                    loc1 = (loc1 + 1);
                    continue;
                }
                loc2.msg = "";
            }
            if (loc1 > 0)
            {
                _bubbleClip = new MovieClip();
                _bubbleClip.alpha = 0.9;
                addChild(_bubbleClip);
                drawBubbleText();
                drawBubble();
            }
            else 
            {
                _bubbleClip = null;
            }
            return;
        }

        private function renderObjectBubble(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;

            loc2 = null;
            if (_bubbleClip != null)
            {
                removeChild(_bubbleClip);
            }
            _bubbleClip = new MovieClip();
            _bubbleClip.alpha = 0.9;
            if (arg1.height > MAX_HEIGHT || arg1.width > MAX_WIDTH)
            {
                loc2 = FitToDimensions.fitToDimensions(arg1.width, arg1.height, MAX_WIDTH, MAX_HEIGHT, FitToDimensions.CONSTRAIN_MAXIMUM);
                arg1.width = loc2.width;
                arg1.height = loc2.height;
                arg1.x = (MAX_WIDTH - loc2.width) / 2;
                arg1.y = (MAX_HEIGHT - loc2.height) / 2;
            }
            bubbleWidth = arg1.width + 10;
            bubbleHeight = arg1.height + 10;
            arg1.x = ARROW_SIZE;
            arg1.y = -bubbleHeight / 2 - ARROW_SIZE;
            _bubbleClip.addChild(arg1);
            drawBubble();
            addChild(_bubbleClip);
            return;
        }

        private function drawBubble():void
        {
            var loc1:*;

            loc1 = new Shape();
            loc1.graphics.beginFill(16777215);
            loc1.graphics.lineStyle(1, 11184810);
            loc1.graphics.drawRoundRect(-bubbleWidth / 2 + ARROW_SIZE, -bubbleHeight - ARROW_SIZE, bubbleWidth, bubbleHeight, 20);
            loc1.graphics.endFill();
            loc1.graphics.beginFill(16777215);
            loc1.graphics.lineStyle(1, 11184810);
            loc1.graphics.moveTo(0, (0));
            loc1.graphics.lineTo(ARROW_SIZE * 0.5, -ARROW_SIZE);
            loc1.graphics.lineStyle(0, 16711680, 0);
            loc1.graphics.lineTo(ARROW_SIZE * 0.5, -ARROW_SIZE - 0.8);
            loc1.graphics.lineTo(ARROW_SIZE * 1.75, -ARROW_SIZE - 0.8);
            loc1.graphics.lineTo(ARROW_SIZE * 1.75, -ARROW_SIZE);
            loc1.graphics.lineStyle(1, 11184810);
            loc1.graphics.lineTo(0, (0));
            loc1.graphics.endFill();
            _bubbleClip.addChildAt(loc1, 0);
            return;
        }

        public function cleanupMessages(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc2 = false;
            loc4 = 0;
            loc5 = messagesList;
            for each (loc3 in loc5)
            {
                loc7 = ((loc6 = loc3).age + 1);
                loc6.age = loc7;
                if (!(loc3.age > MESSAGE_LIFE && !(loc3.msg == "")))
                {
                    continue;
                }
                loc2 = true;
            }
            if (loc2)
            {
                render();
            }
            return;
        }

        private const MAX_HEIGHT:int=140;

        private const ARROW_SIZE:int=15;

        private const MIN_WIDTH:int=50;

        private const TEXT_PADDING:int=3;

        private const MESSAGE_LIFE:int=8;

        private const MAX_WIDTH:int=200;

        private const MIN_HEIGHT:int=25;

        private var cleanupTimer:flash.utils.Timer;

        private var messagesList:Array;

        public var sortOrder:int=0;

        private var bubbleHeight:Number=25;

        private var bubbleWidth:Number=50;

        private var _bubbleClip:flash.display.MovieClip;

        private var _myLife:flash.display.MovieClip;
    }
}
