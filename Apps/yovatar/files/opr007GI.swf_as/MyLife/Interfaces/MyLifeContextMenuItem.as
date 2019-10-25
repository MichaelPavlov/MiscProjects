package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class MyLifeContextMenuItem extends flash.display.Sprite
    {
        public function MyLifeContextMenuItem(arg1:Object, arg2:Object=null)
        {
            style = {"myLifeContextMenu":{"borderRadius":0}, "myLifeContextMenuItem":{"width":134, "height":22, "font":"MyLife.FontTahoma", "fontSize":12, "textAlign":"left", "padding":3, "color":0, "backgroundColor":16777215, "backgroundAlpha":1, "hoverColor":16777215, "hoverBackgroundColor":255, "hoverBackgroundAlpha":1, "arrowColor":0, "arrowHoverColor":16777215, "arrowWidth":5, "arrowHeight":10, "categoryBackgroundColor":16777215}};
            super();
            this.itemData = arg1;
            this.value = arg1.value;
            this.setStyle(arg2);
            this.draw();
            this.mouseChildren = false;
            this._state = this.STATE_UP;
            return;
        }

        private function drawMeta(arg1:uint):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (!itemData.meta)
            {
                return;
            }
            loc2 = getDefinitionByName(this.style.myLifeContextMenuItem.font) as Class;
            loc3 = new loc2();
            loc4 = loc3.fontName;
            (loc5 = new TextFormat()).align = this.style.myLifeContextMenuItem.metaTextAlign || "left";
            loc5.color = arg1;
            loc5.font = loc4;
            loc5.size = this.style.myLifeContextMenuItem.metaFontSize || 10;
            if (metaField)
            {
                metaField.defaultTextFormat = loc5;
                metaField.htmlText = itemData.meta;
            }
            else 
            {
                metaField = new TextField();
                metaField.width = 0;
                metaField.embedFonts = true;
                metaField.defaultTextFormat = loc5;
                metaField.multiline = false;
                metaField.antiAliasType = AntiAliasType.ADVANCED;
                metaField.htmlText = itemData.meta;
                metaField.autoSize = TextFieldAutoSize.RIGHT;
                metaField.selectable = false;
                metaField.mouseEnabled = false;
                metaField.x = width - metaField.width - style.myLifeContextMenuItem.padding;
                metaField.y = style.myLifeContextMenuItem.height - metaField.height >> 1;
                addChild(metaField);
            }
            return;
        }

        private function drawOverState():void
        {
            this.drawBg(this.style.myLifeContextMenuItem.hoverBackgroundColor, style.myLifeContextMenuItem.hoverBackgroundColor);
            this.drawText(this.style.myLifeContextMenuItem.hoverColor);
            this.drawArrow(this.style.myLifeContextMenuItem.arrowHoverColor);
            this.makeContextMenu();
            return;
        }

        public function remove():void
        {
            this.removeContextMenu();
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            return;
        }

        public function get state():String
        {
            return this._state;
        }

        private function draw():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = 0;
            loc2 = NaN;
            if (this.itemData.contextMenuData)
            {
                loc1 = this.style.myLifeContextMenuItem.categoryBackgroundColor;
                loc2 = style.myLifeContextMenuItem.categoryBackgroundAlpha;
            }
            else 
            {
                loc1 = this.style.myLifeContextMenuItem.backgroundColor;
                loc2 = style.myLifeContextMenuItem.backgroundAlpha;
            }
            this.drawBg(loc1, loc2);
            this.drawIcon();
            this.drawText(this.style.myLifeContextMenuItem.color);
            drawMeta(style.myLifeContextMenuItem.metaColor);
            this.drawArrow(this.style.myLifeContextMenuItem.arrowColor);
            return;
        }

        private function drawText(arg1:uint):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = undefined;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = 0;
            if (this.itemData.text)
            {
                loc2 = getDefinitionByName(this.style.myLifeContextMenuItem.font) as Class;
                loc3 = new loc2();
                loc4 = loc3.fontName;
                (loc5 = new TextFormat()).align = this.style.myLifeContextMenuItem.textAlign;
                loc5.color = arg1;
                loc5.font = loc4;
                loc5.size = this.style.myLifeContextMenuItem.fontSize;
                if (this.textField)
                {
                    this.textField.defaultTextFormat = loc5;
                    this.textField.htmlText = this.itemData.text;
                }
                else 
                {
                    loc6 = this.style.myLifeContextMenuItem.padding;
                    if (this.icon)
                    {
                        loc6 = loc6 + this.icon.x + this.icon.width;
                    }
                    this.textField = new TextField();
                    this.textField.embedFonts = true;
                    this.textField.defaultTextFormat = loc5;
                    this.textField.multiline = false;
                    this.textField.antiAliasType = AntiAliasType.ADVANCED;
                    this.textField.htmlText = this.itemData.text;
                    this.textField.autoSize = this.style.myLifeContextMenuItem.textAlign;
                    this.textField.selectable = false;
                    this.textField.mouseEnabled = false;
                    this.textField.width = this.textField.textWidth;
                    this.textField.height = this.textField.textHeight;
                    this.textField.x = loc6;
                    this.textField.y = this.style.myLifeContextMenuItem.height - this.textField.height >> 1;
                    this.addChild(this.textField);
                }
            }
            return;
        }

        public function set state(arg1:String):void
        {
            var loc2:*;

            this._state = arg1;
            loc2 = this._state;
            switch (loc2) 
            {
                case this.STATE_UP:
                    this.drawUpState();
                    break;
                case this.STATE_OVER:
                    this.drawOverState();
                    break;
            }
            return;
        }

        public function get menu():MyLife.Interfaces.MyLifeContextMenu
        {
            return parent ? parent as MyLifeContextMenu : null;
        }

        private function makeContextMenu():void
        {
            var loc1:*;

            loc1 = null;
            if (!this.myLifeContextMenu)
            {
                if (this.itemData.contextMenuData)
                {
                    this.myLifeContextMenu = new MyLifeContextMenu(this.itemData.contextMenuData.itemDataArray, this.itemData.contextMenuData.style || this.style);
                    this.myLifeContextMenu.x = this.x + this.style.myLifeContextMenuItem.width - this.style.myLifeContextMenuItem.padding * 2 + this.style.myLifeContextMenuItem.arrowWidth;
                    this.myLifeContextMenu.y = this.y + this.style.myLifeContextMenuItem.padding + style.myLifeContextMenu.borderRadius * 0.5 + height - myLifeContextMenu.height;
                    this.parent.addChild(this.myLifeContextMenu);
                    loc1 = this.myLifeContextMenu.getBounds(this.stage);
                    if (loc1.right > this.stage.stageWidth)
                    {
                        this.myLifeContextMenu.x = this.x - this.style.myLifeContextMenuItem.width + this.style.myLifeContextMenuItem.padding * 4;
                    }
                    if (loc1.bottom > this.stage.stageHeight)
                    {
                        this.myLifeContextMenu.y = this.y + this.height - this.myLifeContextMenu.height - this.style.myLifeContextMenuItem.padding;
                    }
                }
            }
            return;
        }

        private function drawArrow(arg1:uint):void
        {
            if (this.itemData.contextMenuData)
            {
                if (!this.arrow)
                {
                    this.arrow = new Shape();
                    this.addChild(this.arrow);
                }
                this.arrow.graphics.clear();
                this.arrow.graphics.beginFill(arg1);
                this.arrow.graphics.lineTo(0, this.style.myLifeContextMenuItem.arrowHeight);
                this.arrow.graphics.lineTo(this.style.myLifeContextMenuItem.arrowWidth, this.style.myLifeContextMenuItem.arrowHeight >> 1);
                this.arrow.graphics.endFill();
                this.arrow.x = menu ? menu.itemWidth : width - style.myLifeContextMenuItem.padding - arrow.width;
                this.arrow.y = this.style.myLifeContextMenuItem.height - this.arrow.height >> 1;
            }
            return;
        }

        private function drawIcon():void
        {
            var IconClass:Class;
            var loc1:*;
            var loc2:*;

            IconClass = null;
            if (itemData.icon)
            {
                try
                {
                    IconClass = getDefinitionByName(itemData.icon) as Class;
                    this.icon = new IconClass();
                    this.icon.x = this.style.myLifeContextMenuItem.padding;
                    this.icon.y = this.style.myLifeContextMenuItem.height - icon.height >> 1;
                    this.addChild(icon);
                }
                catch (e:Error)
                {
                    trace("MyLifeContextMenuItem drawIcon() Error:" + undefined);
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

        private function drawBg(arg1:uint, arg2:Number=1):void
        {
            if (!this.bg)
            {
                this.bg = new Shape();
                this.addChildAt(this.bg, 0);
            }
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(arg1, arg2);
            this.bg.graphics.drawRect(0, (0), style.myLifeContextMenuItem.width, height || 20);
            this.bg.graphics.endFill();
            return;
        }

        private function drawUpState():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = 0;
            loc2 = NaN;
            if (this.itemData.contextMenuData)
            {
                loc1 = this.style.myLifeContextMenuItem.categoryBackgroundColor;
                loc2 = style.myLifeContextMenuItem.categoryBackgroundAlpha;
            }
            else 
            {
                loc1 = this.style.myLifeContextMenuItem.backgroundColor;
                loc2 = style.myLifeContextMenuItem.backgroundAlpha;
            }
            this.drawBg(loc1, loc2);
            this.drawText(this.style.myLifeContextMenuItem.color);
            this.drawArrow(this.style.myLifeContextMenuItem.arrowColor);
            this.removeContextMenu();
            return;
        }

        private function removeContextMenu():void
        {
            if (this.myLifeContextMenu)
            {
                this.myLifeContextMenu.remove();
                this.myLifeContextMenu = null;
            }
            return;
        }

        public const STATE_OVER:String="over";

        public const STATE_UP:String="up";

        private var style:Object;

        private var bg:flash.display.Shape;

        public var myLifeContextMenu:MyLife.Interfaces.MyLifeContextMenu;

        private var arrow:flash.display.Shape;

        private var textField:flash.text.TextField;

        private var itemData:Object;

        private var _state:String;

        private var metaField:flash.text.TextField;

        public var value:*;

        private var icon:flash.display.DisplayObject;
    }
}
