package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.events.*;
    
    public class MyLifeContextMenu extends flash.display.Sprite
    {
        public function MyLifeContextMenu(arg1:Array, arg2:Object=null)
        {
            style = {"myLifeContextMenu":{"backgroundColor":16777215, "borderColor":3355443, "borderRadius":0, "borderWidth":1, "dividerColor":13421772, "dividerWidth":1, "dividerPadding":3}};
            super();
            this.items = [];
            this.itemDataArray = arg1;
            this.setStyle(arg2);
            this.draw();
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
            return;
        }

        public function remove():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            if (this.parent && !(this.parent["constructor"] == this["constructor"]))
            {
                this.dispatchCompleteEvent();
            }
            this.removeListeners();
            if (items)
            {
                loc2 = 0;
                loc3 = this.items;
                for each (loc1 in loc3)
                {
                    loc1.remove();
                }
                items.splice(0);
            }
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            return;
        }

        private function mouseOverHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            if (arg1.target.parent == this && arg1.target.hasOwnProperty("state"))
            {
                loc3 = 0;
                loc4 = items;
                for each (loc2 in loc4)
                {
                    if (loc2 != arg1.target)
                    {
                        loc2.state = loc2.STATE_UP;
                        continue;
                    }
                    loc2.state = loc2.STATE_OVER;
                }
            }
            return;
        }

        private function draw():void
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

            loc1 = null;
            loc2 = null;
            loc5 = null;
            loc6 = NaN;
            loc7 = 0;
            loc3 = style.myLifeContextMenu.borderWidth;
            loc4 = style.myLifeContextMenu.borderRadius;
            loc8 = 0;
            loc9 = this.itemDataArray;
            for each (loc2 in loc9)
            {
                loc1 = new MyLifeContextMenuItem(loc2, style);
                loc1.y = loc1.y + this.height;
                this.items.push(loc1);
                this.addChild(loc1);
            }
            (loc5 = new Shape()).graphics.lineStyle(this.style.myLifeContextMenu.dividerWidth, this.style.myLifeContextMenu.dividerColor);
            loc7 = this.itemDataArray.length;
            loc8 = 0;
            loc9 = this.items;
            for each (loc1 in loc9)
            {
                loc1.y = loc1.y + (loc4 >> 1);
                if (!--loc7)
                {
                    continue;
                }
                loc6 = loc1.y + loc1.height;
                loc5.graphics.moveTo(this.style.myLifeContextMenu.dividerPadding, loc6);
                loc5.graphics.lineTo(this.width - this.style.myLifeContextMenu.dividerPadding, loc6);
            }
            this.addChild(loc5);
            this.bg = new Shape();
            this.bg.graphics.lineStyle(loc3, this.style.myLifeContextMenu.borderColor);
            this.bg.graphics.beginFill(this.style.myLifeContextMenu.backgroundColor, style.myLifeContextMenu.alpha || 1);
            bg.graphics.drawRoundRect(-loc3, -loc3, width + loc3, height + loc3 + loc4, loc4, loc4);
            this.bg.graphics.endFill();
            this.addChildAt(this.bg, 0);
            return;
        }

        private function dispatchCompleteEvent():void
        {
            var loc1:*;

            loc1 = new Event(Event.COMPLETE);
            this.dispatchEvent(loc1);
            return;
        }

        private function removeListeners():void
        {
            this.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            if (this.parent && !(this.parent["constructor"] == this["constructor"]))
            {
                this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            }
            return;
        }

        private function addListeners():void
        {
            this.addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
            if (this.parent && !(this.parent["constructor"] == this["constructor"]))
            {
                this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true);
            }
            return;
        }

        private function addedToStageHandler(arg1:flash.events.Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            this.addListeners();
            return;
        }

        private function mouseClickHandler(arg1:flash.events.Event):void
        {
            if (this.parent && !(this.parent["constructor"] == this["constructor"]))
            {
                if (arg1.target.hasOwnProperty("value"))
                {
                    this.value = arg1.target.value;
                    this.remove();
                }
            }
            return;
        }

        private function setStyle(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = null;
            if (arg1)
            {
                loc4 = 0;
                loc5 = arg1;
                for (loc2 in loc5)
                {
                    this.style[loc2] = this.style[loc2] || {};
                    loc6 = 0;
                    loc7 = arg1[loc2];
                    for (loc3 in loc7)
                    {
                        this.style[loc2][loc3] = arg1[loc2][loc3];
                    }
                }
            }
            return;
        }

        private function stageMouseMoveHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.stage)
            {
                if (this.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true))
                {
                    _onMenu = true;
                }
                else 
                {
                    if (_onMenu)
                    {
                        this.remove();
                    }
                }
            }
            return;
        }

        public function get itemWidth():Number
        {
            return _itemWidth;
        }

        public override function addChild(arg1:flash.display.DisplayObject):flash.display.DisplayObject
        {
            if (arg1 as MyLifeContextMenuItem)
            {
                _itemWidth = Math.max(_itemWidth, arg1.width);
            }
            return super.addChild(arg1);
        }

        private var items:Array;

        private var bg:flash.display.Shape;

        private var style:Object;

        private var _itemWidth:Number=0;

        public var value:*;

        private var itemDataArray:Array;

        private var _onMenu:Boolean=false;
    }
}
