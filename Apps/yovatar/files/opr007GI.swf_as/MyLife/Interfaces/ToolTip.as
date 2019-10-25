package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class ToolTip extends flash.display.Sprite
    {
        public function ToolTip(arg1:uint=16777215, arg2:uint=0, arg3:Boolean=false, arg4:Boolean=false, arg5:Boolean=false, arg6:int=-10, arg7:int=18)
        {
            super();
            this.color = arg1;
            this.backgroundColor = arg2;
            this.persistent = arg3;
            this.relativeObject = arg4;
            this.longDelay = arg5;
            this.offsetX = arg6;
            this.offsetY = arg7;
            this.toolTipArray = [];
            this.makeTimer();
            this.makeBg();
            this.makeTextField();
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageListener);
            return;
        }

        private function filterLineBreaks(arg1:String):String
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = new RegExp("\\r\\n", "g");
            loc3 = new RegExp("\\r", "g");
            loc4 = new RegExp("\\n", "g");
            arg1 = arg1.replace(loc2, "\n");
            arg1 = arg1.replace(loc3, "\n");
            return arg1;
        }

        private function stageClickListener(arg1:flash.events.MouseEvent):void
        {
            if (!persistent)
            {
                this.myTimer.stop();
                this.visible = false;
            }
            return;
        }

        private function rollOutHandler(arg1:flash.events.Event):void
        {
            myTimer.stop();
            if (persistent)
            {
                this.visible = false;
            }
            return;
        }

        private function timerHandler(arg1:flash.events.Event):void
        {
            showTip();
            myTimer.stop();
            return;
        }

        private function removeFromStageListener(arg1:flash.events.Event):void
        {
            this.stage.removeEventListener(MouseEvent.CLICK, stageClickListener);
            return;
        }

        public function removeTool(arg1:flash.display.Sprite):void
        {
            var loc2:*;

            arg1.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            arg1.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            loc2 = this.toolTipArray.indexOf(arg1);
            if (loc2 > 0)
            {
                this.toolTipArray.splice(loc2, 1);
            }
            return;
        }

        private function makeBg():void
        {
            this.bg = new Shape();
            this.addChild(this.bg);
            return;
        }

        private function makeTip(arg1:String):void
        {
            var loc2:*;
            var loc3:*;

            this.textField.htmlText = arg1;
            loc2 = this.textField.height;
            loc3 = loc2 >> 1;
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(this.backgroundColor);
            this.bg.graphics.drawRoundRect(this.textField.x - this.PADDING, this.textField.y - this.PADDING, this.textField.width + this.PADDING * 2, this.textField.height + this.PADDING * 2, this.BG_CORNER_RADIUS, this.BG_CORNER_RADIUS);
            return;
        }

        public function addTool(arg1:*, arg2:String=""):void
        {
            var loc3:*;

            if (persistent)
            {
                arg1.addEventListener(MouseEvent.MOUSE_OVER, mouseMoveHandler);
            }
            else 
            {
                arg1.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            }
            arg1.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            loc3 = {};
            loc3.tool = arg1;
            loc3.tip = this.filterLineBreaks(arg2);
            toolTipArray.push(loc3);
            return;
        }

        public function clear():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = undefined;
            loc2 = null;
            loc3 = this.toolTipArray.length;
            while (loc3--) 
            {
                loc1 = this.toolTipArray[loc3].tool;
                loc1.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                loc1.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            }
            this.toolTipArray = [];
            lastTool = undefined;
            return;
        }

        private function showTip():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = null;
            loc2 = null;
            loc3 = null;
            loc4 = 0;
            loc5 = this.toolTipArray;
            for each (loc1 in loc5)
            {
                if (loc1.tool != this.lastTool)
                {
                    continue;
                }
                if (loc1 && loc1.tip)
                {
                    loc2 = loc1.tip;
                    this.makeTip(loc2);
                    if (relativeObject)
                    {
                        this.x = this.lastTool.x + offsetX;
                        this.y = this.lastTool.y + offsetY;
                    }
                    else 
                    {
                        this.x = this.parent.mouseX + this.offsetX;
                        this.y = this.parent.mouseY + this.offsetY;
                    }
                    loc3 = this.getBounds(this.stage);
                    if (loc3.right > this.stage.stageWidth)
                    {
                        this.x = this.x - (loc3.right - this.stage.stageWidth);
                    }
                    if (loc3.bottom > this.stage.stageHeight)
                    {
                        this.y = this.parent.mouseY - this.bg.height - 2;
                    }
                    this.visible = true;
                }
                break;
            }
            return;
        }

        public function setTip(arg1:*, arg2:String=""):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = 0;
            loc5 = toolTipArray;
            for each (loc3 in loc5)
            {
                if (loc3.tool != arg1)
                {
                    continue;
                }
                loc3.tip = this.filterLineBreaks(arg2);
                break;
            }
            return;
        }

        private function mouseMoveHandler(arg1:flash.events.MouseEvent):void
        {
            lastTool = arg1.currentTarget as Sprite;
            myTimer.reset();
            myTimer.start();
            this.visible = false;
            return;
        }

        private function makeTimer():void
        {
            if (longDelay)
            {
                myTimer = new Timer(this.LONG_TIMER_DELAY);
            }
            else 
            {
                myTimer = new Timer(this.TIMER_DELAY);
            }
            myTimer.addEventListener("timer", timerHandler);
            return;
        }

        private function addedToStageListener(arg1:flash.events.Event):void
        {
            this.stage.addEventListener(MouseEvent.CLICK, stageClickListener, false, 0, true);
            return;
        }

        private function makeTextField():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = getDefinitionByName(this.FONT_CLASSNAME);
            loc2 = new loc1();
            loc3 = loc2.fontName;
            (loc4 = new TextFormat()).align = this.FONT_ALIGN;
            loc4.color = this.color;
            loc4.font = loc3;
            loc4.size = this.FONT_SIZE;
            this.textField = new TextField();
            this.textField.embedFonts = true;
            this.textField.defaultTextFormat = loc4;
            this.textField.multiline = true;
            this.textField.htmlText = "";
            this.textField.autoSize = this.FONT_ALIGN;
            this.textField.selectable = false;
            this.textField.width = this.textField.textWidth;
            this.textField.height = this.textField.textHeight;
            this.addChild(this.textField);
            return;
        }

        private const LONG_TIMER_DELAY:int=250;

        private const OFFSETX:int=-10;

        private const OFFSETY:int=18;

        private const BG_CORNER_RADIUS:int=10;

        private const TIMER_DELAY:int=50;

        private const PADDING:int=1;

        private const FONT_CLASSNAME:String="MyLife.FontTahoma";

        private const FONT_ALIGN:String="center";

        private const FONT_SIZE:int=11;

        private var persistent:Boolean;

        private var relativeObject:Boolean;

        private var offsetX:int;

        private var offsetY:int;

        private var toolTipArray:Array;

        private var bg:flash.display.Shape;

        private var textField:flash.text.TextField;

        private var lastTool:flash.display.Sprite;

        private var backgroundColor:uint=0;

        private var color:uint=16777215;

        private var longDelay:Boolean;

        private var myTimer:flash.utils.Timer;
    }
}
