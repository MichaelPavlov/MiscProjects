package caurina.transitions 
{
    public class PropertyInfoObj extends Object
    {
        public function PropertyInfoObj(arg1:Number, arg2:Number, arg3:Object, arg4:Number, arg5:Object, arg6:Boolean, arg7:Function, arg8:Array)
        {
            super();
            valueStart = arg1;
            valueComplete = arg2;
            originalValueComplete = arg3;
            arrayIndex = arg4;
            extra = arg5;
            isSpecialProperty = arg6;
            hasModifier = Boolean(arg7);
            modifierFunction = arg7;
            modifierParameters = arg8;
            return;
        }

        public function toString():String
        {
            var loc1:*;

            loc1 = "\n[PropertyInfoObj ";
            loc1 = loc1 + "valueStart:" + String(valueStart);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "valueComplete:" + String(valueComplete);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "originalValueComplete:" + String(originalValueComplete);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "arrayIndex:" + String(arrayIndex);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "extra:" + String(extra);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "isSpecialProperty:" + String(isSpecialProperty);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "hasModifier:" + String(hasModifier);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "modifierFunction:" + String(modifierFunction);
            loc1 = loc1 + ", ";
            loc1 = loc1 + "modifierParameters:" + String(modifierParameters);
            loc1 = loc1 + "]\n";
            return loc1;
        }

        public function clone():caurina.transitions.PropertyInfoObj
        {
            var loc1:*;

            loc1 = new PropertyInfoObj(valueStart, valueComplete, originalValueComplete, arrayIndex, extra, isSpecialProperty, modifierFunction, modifierParameters);
            return loc1;
        }

        public var modifierParameters:Array;

        public var isSpecialProperty:Boolean;

        public var valueComplete:Number;

        public var modifierFunction:Function;

        public var extra:Object;

        public var valueStart:Number;

        public var hasModifier:Boolean;

        public var arrayIndex:Number;

        public var originalValueComplete:Object;
    }
}
