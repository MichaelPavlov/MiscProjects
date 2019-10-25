package caurina.transitions 
{
    public class SpecialProperty extends Object
    {
        public function SpecialProperty(arg1:Function, arg2:Function, arg3:Array=null, arg4:Function=null)
        {
            super();
            getValue = arg1;
            setValue = arg2;
            parameters = arg3;
            preProcess = arg4;
            return;
        }

        public function toString():String
        {
            var loc1:*;

            loc1 = "";
            loc1 = loc1 + "[SpecialProperty ";
            loc1 = loc1 + "getValue:" + String(getValue);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "setValue:" + String(setValue);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "parameters:" + String(parameters);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "preProcess:" + String(preProcess);
            loc1 = loc1 + "]";
            return loc1;
        }

        public var parameters:Array;

        public var getValue:Function;

        public var preProcess:Function;

        public var setValue:Function;
    }
}
