package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.text.*;
    
    public dynamic class FriendUnit extends flash.display.MovieClip
    {
        public function FriendUnit()
        {
            super();
            return;
        }

        public var playerId:Object;

        public var mcLoading:flash.display.MovieClip;

        public var friendName:flash.text.TextField;

        public var friendImage:flash.display.MovieClip;
    }
}
