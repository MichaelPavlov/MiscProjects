package MyLife.UI 
{
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    
    public class ToggleButton extends flash.display.Sprite implements MyLife.UI.IToggleButton
    {
        public function ToggleButton(arg1:flash.display.DisplayObject=null, arg2:flash.display.DisplayObject=null, arg3:flash.display.DisplayObject=null, arg4:flash.display.DisplayObject=null)
        {
            var loc5:*;

            super();
            this.hitTestContainer = new Sprite();
            this.hitTestContainer.addEventListener(MouseEvent.CLICK, this.hitTestContainerClickHandler, false, 0, true);
            this.hitTestContainer.useHandCursor = loc5 = true;
            this.hitTestContainer.buttonMode = loc5;
            this.hitTestContainer.mouseChildren = false;
            this.hitTestContainer.alpha = 0;
            this.addChild(this.hitTestContainer);
            this.stateContainer = new Sprite();
            this.stateContainer.mouseEnabled = false;
            this.addChildAt(this.stateContainer, 0);
            if (arg2)
            {
                this.selectedState = arg2;
            }
            if (arg1)
            {
                this.deselectedState = arg1;
            }
            if (arg3)
            {
                this.hitTestState = arg3;
            }
            if (arg4)
            {
                overState = arg4;
                addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
                addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            }
            this.currentState = ToggleButtonState.DESELECTED;
            this._isSelected = false;
            return;
        }

        public function set overState(arg1:flash.display.DisplayObject):void
        {
            _overState = arg1;
            if (overState)
            {
                addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
                addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            }
            return;
        }

        public function select():void
        {
            if (!this._isSelected)
            {
                this._isSelected = true;
                this.currentState = ToggleButtonState.SELECTED;
                this.dispatchEvent(new ToggleEvent(ToggleEvent.SELECTED));
                this.dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE));
            }
            return;
        }

        public function get hitTestState():flash.display.DisplayObject
        {
            return this._hitTestState;
        }

        public function set isSelected(arg1:Boolean):void
        {
            if (arg1)
            {
                this.select();
            }
            else 
            {
                this.deselect();
            }
            return;
        }

        public function toggle():void
        {
            this.isSelected = !this.isSelected;
            _previousState = isSelected ? ToggleButtonState.SELECTED : ToggleButtonState.DESELECTED;
            return;
        }

        public function get deselectedState():flash.display.DisplayObject
        {
            return this._deselectedState;
        }

        public function set hitTestState(arg1:flash.display.DisplayObject):void
        {
            this._hitTestState = arg1;
            if (this.hitTestContainer.numChildren)
            {
                this.hitTestContainer.removeChildAt(0);
            }
            this.hitTestContainer.addChild(this._hitTestState);
            return;
        }

        protected function hitTestContainerClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.toggle();
            return;
        }

        public function get overState():flash.display.DisplayObject
        {
            return _overState;
        }

        public function deselect():void
        {
            if (this._isSelected)
            {
                this._isSelected = false;
                this.currentState = ToggleButtonState.DESELECTED;
                this.dispatchEvent(new ToggleEvent(ToggleEvent.DESELECTED));
                this.dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE));
            }
            return;
        }

        public function get currentState():String
        {
            return this._currentState;
        }

        protected function rollOverHandler(arg1:flash.events.MouseEvent):void
        {
            if (currentState != ToggleButtonState.OVER)
            {
                _previousState = currentState;
            }
            currentState = ToggleButtonState.OVER;
            return;
        }

        public function set deselectedState(arg1:flash.display.DisplayObject):void
        {
            this._deselectedState = arg1;
            if (this._deselectedState.parent)
            {
                this._deselectedState.parent.removeChild(this._deselectedState);
            }
            return;
        }

        public function set selectedState(arg1:flash.display.DisplayObject):void
        {
            this._selectedState = arg1;
            if (this._selectedState.parent)
            {
                this._selectedState.parent.removeChild(this._selectedState);
            }
            return;
        }

        public function get isSelected():Boolean
        {
            return this._isSelected;
        }

        protected function rollOutHandler(arg1:flash.events.MouseEvent):void
        {
            currentState = _previousState;
            _previousState = null;
            return;
        }

        public function get selectedState():flash.display.DisplayObject
        {
            return this._selectedState;
        }

        public function set currentState(arg1:String):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            if (this._currentState != arg1)
            {
                this._currentState = arg1;
                if (this.stateContainer.numChildren)
                {
                    this.stateContainer.removeChildAt(0);
                }
                loc3 = arg1;
                switch (loc3) 
                {
                    case ToggleButtonState.SELECTED:
                        loc2 = this._selectedState;
                        break;
                    case ToggleButtonState.DESELECTED:
                        loc2 = this._deselectedState;
                        break;
                    case ToggleButtonState.OVER:
                        loc2 = overState;
                        break;
                }
                if (loc2)
                {
                    this.stateContainer.addChild(loc2);
                }
            }
            return;
        }

        protected var _isSelected:Boolean;

        protected var _previousState:String;

        protected var _deselectedState:flash.display.DisplayObject;

        protected var _overState:flash.display.DisplayObject;

        protected var _hitTestState:flash.display.DisplayObject;

        protected var stateContainer:flash.display.Sprite;

        protected var _currentState:String;

        protected var hitTestContainer:flash.display.Sprite;

        protected var _selectedState:flash.display.DisplayObject;
    }
}
