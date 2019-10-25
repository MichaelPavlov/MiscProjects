package MyLife.Utils 
{
    import flash.utils.*;
    
    public class DataTimer extends flash.utils.Timer
    {
        public function DataTimer(arg1:Object, arg2:Number, arg3:int=0)
        {
            data = arg1;
            super(arg2, arg3);
            return;
        }

        public var data:Object=null;
    }
}
