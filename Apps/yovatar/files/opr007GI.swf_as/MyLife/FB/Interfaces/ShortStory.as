package MyLife.FB.Interfaces 
{
    public interface ShortStory
    {
        function getFeedObject():MyLife.FB.Interfaces.FeedObject;

        function addItem(arg1:MyLife.FB.Interfaces.FeedObject):int;

        function getPriority():int;

        function clear():void;

        function publish():void;
    }
}
