package MyLife.Components 
{
    import fl.controls.*;
    import fl.controls.listClasses.*;
    import flash.events.*;
    
    public class CustomCheckBoxCellRenderer extends fl.controls.CheckBox implements fl.controls.listClasses.ICellRenderer
    {
        public function CustomCheckBoxCellRenderer()
        {
            super();
            focusEnabled = false;
            return;
        }

        public override function set selected(arg1:Boolean):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = this.parent.parent.parent as DataGrid;
            loc3 = loc2.getColumnAt(0).dataField;
            super.selected = _data[loc3] == true;
            _rowSelected = arg1;
            loc2.clearSelection();
            return;
        }

        public override function setSize(arg1:Number, arg2:Number):void
        {
            super.setSize(arg1, arg2);
            return;
        }

        protected override function toggleSelected(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = this.parent.parent.parent as DataGrid;
            loc3 = loc2.getColumnAt(0).dataField;
            if (arg1.target.selected)
            {
                _data[loc3] = false;
            }
            else 
            {
                _data[loc3] = true;
            }
            return;
        }

        public function set listData(arg1:fl.controls.listClasses.ListData):void
        {
            _listData = arg1;
            label = _showLabel ? _listData.label : "";
            setStyle("icon", _listData.icon);
            return;
        }

        public function set data(arg1:Object):void
        {
            _data = arg1;
            return;
        }

        public function get listData():fl.controls.listClasses.ListData
        {
            return _listData;
        }

        public function get data():Object
        {
            return _data;
        }

        public override function get selected():Boolean
        {
            return super.selected;
        }

        protected var _listData:fl.controls.listClasses.ListData;

        protected var _data:Object;

        protected var _rowSelected:Boolean;

        protected var _showLabel:Boolean=true;
    }
}
