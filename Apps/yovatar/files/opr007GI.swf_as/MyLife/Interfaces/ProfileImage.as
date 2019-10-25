package MyLife.Interfaces 
{
    import MyLife.Utils.Math.*;
    import flash.display.*;
    
    public class ProfileImage extends flash.display.MovieClip
    {
        public function ProfileImage()
        {
            super();
            return;
        }

        public function cleanUp():void
        {
            var loc1:*;

            loc1 = imageContainer.numChildren;
            while (loc1) 
            {
                imageContainer.removeChildAt(0);
                loc1 = (loc1 - 1);
            }
            return;
        }

        public function addImage(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = null;
            if (arg1)
            {
                loc2 = imageContainer.numChildren;
                while (loc2) 
                {
                    imageContainer.removeChildAt(0);
                    loc2 = (loc2 - 1);
                }
                loc3 = FitToDimensions.fitToDimensions(arg1.width, arg1.height, 50, (50), FitToDimensions.CONSTRAIN_MAXIMUM);
                arg1.x = -25;
                arg1.y = -25;
                arg1.width = loc3.width;
                arg1.height = loc3.height;
                if (arg1.width < 50)
                {
                    arg1.x = arg1.x + (50 - loc3.width) / 2;
                }
                if (arg1.height < 50)
                {
                    arg1.y = arg1.y + (50 - loc3.height) / 2;
                }
                imageContainer.addChild(arg1);
                placeHolder.visible = false;
            }
            return;
        }

        public var placeHolder:flash.display.MovieClip;

        public var imageContainer:flash.display.MovieClip;
    }
}
