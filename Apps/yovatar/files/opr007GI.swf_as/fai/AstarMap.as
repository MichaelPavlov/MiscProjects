package fai 
{
    public class AstarMap extends fai.Map
    {
        public function AstarMap()
        {
            super();
            return;
        }

        public function removeNode(arg1:Number, arg2:fai.AstarNode):void
        {
            var loc3:*;

            loc3 = NaN;
            if (find(arg1))
            {
                if (values[index_].pos.isequal(arg2.pos))
                {
                    keys.splice(index_, 1);
                    values.splice(index_, 1);
                }
                else 
                {
                    loc3 = (index_ - 1);
                    while (loc3 >= 0 && values[loc3].f == arg1) 
                    {
                        if (values[loc3].pos.isequal(arg2.pos))
                        {
                            keys.splice(loc3, 1);
                            values.splice(loc3, 1);
                            return;
                        }
                        loc3 = (loc3 - 1);
                    }
                    loc3 = index_ + 1;
                    while (loc3 < keys.length && values[loc3].f == arg1) 
                    {
                        if (values[loc3].pos.isequal(arg2.pos))
                        {
                            keys.splice(loc3, 1);
                            values.splice(loc3, 1);
                            return;
                        }
                        loc3 = (loc3 + 1);
                    }
                }
            }
            return;
        }
    }
}
