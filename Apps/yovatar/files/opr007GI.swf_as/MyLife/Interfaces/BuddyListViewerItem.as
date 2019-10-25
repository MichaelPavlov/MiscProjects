package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public class BuddyListViewerItem extends flash.display.MovieClip
    {
        public function BuddyListViewerItem()
        {
            super();
            return;
        }

        public var btnBuddyVisitHome:flash.display.SimpleButton;

        public var lblName:flash.text.TextField;

        public var isOnline:Boolean=false;

        public var btnBuddyRemoveFromList:flash.display.SimpleButton;

        public var statusIcon:flash.display.MovieClip;

        public var buddyName:String;

        public var buddyObj:Object;

        public var btnBuddyVisitLocation:flash.display.SimpleButton;
    }
}
