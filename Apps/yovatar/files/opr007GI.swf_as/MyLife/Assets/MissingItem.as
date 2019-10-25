package MyLife.Assets 
{
    import flash.display.*;
    
    public dynamic class MissingItem extends MyLife.Assets.SimpleItem
    {
        public function MissingItem()
        {
            super();
            itemImage.visible = false;
            return;
        }

        public var itemImage:flash.display.MovieClip;

        public var hitZone:flash.display.MovieClip;
    }
}
