package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class ViewInventoryItemPreview extends flash.display.MovieClip
    {
        public function ViewInventoryItemPreview()
        {
            super();
            txtQuantity.visible = false;
            return;
        }

        public function get count():int
        {
            return _count;
        }

        public function set count(arg1:int):void
        {
            _count = arg1;
            txtQuantity.text = "x" + _count;
            txtQuantity.visible = _count > 1;
            return;
        }

        public var starterItem:flash.display.MovieClip;

        public var inUse:flash.display.MovieClip;

        public var txtName:flash.text.TextField;

        public var mcLoading:flash.display.MovieClip;

        public var inventoryItem:Object;

        private var _count:int=0;

        public var previewImage:flash.display.MovieClip;

        public var txtQuantity:flash.text.TextField;

        public var freeGift:flash.display.MovieClip;

        public var nonRefundable:flash.display.MovieClip;
    }
}
