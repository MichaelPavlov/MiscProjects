package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class ViewInventoryItemDetails extends flash.display.MovieClip
    {
        public function ViewInventoryItemDetails()
        {
            super();
            btnSell.mouseChildren = false;
            btnSell.buttonMode = true;
            btnSell.useHandCursor = true;
            btnUse.mouseChildren = false;
            btnUse.buttonMode = true;
            btnUse.useHandCursor = true;
            btnCancel.mouseChildren = false;
            btnCancel.buttonMode = true;
            btnCancel.useHandCursor = true;
            btnSell.label.visible = false;
            return;
        }

        public var txtPrice:flash.text.TextField;

        public var modal:flash.display.MovieClip;

        public var txtItemName:flash.text.TextField;

        public var inventoryItem:Object;

        public var coin:flash.display.MovieClip;

        public var btnSell:flash.display.MovieClip;

        public var btnCancel:flash.display.MovieClip;

        public var mcItemInUse:flash.display.MovieClip;

        public var btnUse:flash.display.MovieClip;

        public var previewItem:MyLife.Interfaces.ViewInventoryItemPreview;

        public var picture:flash.display.MovieClip;
    }
}
