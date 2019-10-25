package MyLife.UI 
{
    import flash.display.*;
    
    public interface IToggleButton
    {
        function get isSelected():Boolean;

        function set isSelected(arg1:Boolean):void;

        function get hitTestState():flash.display.DisplayObject;

        function addEventListener(arg1:String, arg2:Function, arg3:Boolean=false, arg4:int=0, arg5:Boolean=false):void;

        function set currentState(arg1:String):void;

        function set deselectedState(arg1:flash.display.DisplayObject):void;

        function set selectedState(arg1:flash.display.DisplayObject):void;

        function toggle():void;

        function get deselectedState():flash.display.DisplayObject;

        function get selectedState():flash.display.DisplayObject;

        function set hitTestState(arg1:flash.display.DisplayObject):void;

        function removeEventListener(arg1:String, arg2:Function, arg3:Boolean=false):void;

        function get currentState():String;
    }
}
