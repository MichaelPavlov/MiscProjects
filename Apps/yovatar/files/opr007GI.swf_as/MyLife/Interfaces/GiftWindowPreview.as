package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class GiftWindowPreview extends flash.display.MovieClip
    {
        public function GiftWindowPreview()
        {
            super();
            return;
        }

        public var previewImage:flash.display.MovieClip;

        public var mcLoading:flash.display.MovieClip;

        public var giftData:Object;

        public var txtName:flash.text.TextField;
    }
}
