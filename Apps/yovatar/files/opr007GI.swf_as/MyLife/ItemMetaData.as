package MyLife 
{
    public class ItemMetaData extends Object
    {
        public function ItemMetaData(arg1:Object)
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            super();
            if (arg1 as String)
            {
                loc2 = arg1 as String;
            }
            else 
            {
                loc3 = arg1;
                if (loc3.hasOwnProperty("metaData"))
                {
                    loc2 = loc3.metaData as String;
                }
                else 
                {
                    if (arg1.hasOwnProperty("meta_data"))
                    {
                        loc2 = loc3.meta_data as String;
                    }
                }
            }
            if (loc2)
            {
                data = parseMetaDataString(loc2);
            }
            else 
            {
                data = [];
            }
            return;
        }

        public function getProperty(arg1:String):String
        {
            if (data.hasOwnProperty(arg1))
            {
                return data[arg1] as String;
            }
            return null;
        }

        private function parseMetaDataString(arg1:String):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc2 = [];
            loc3 = [];
            if (arg1 && arg1.indexOf("|") < 0)
            {
                loc2 = arg1.split("|");
            }
            else 
            {
                if (arg1)
                {
                    if (arg1.indexOf(":") >= 0)
                    {
                        loc2.push(arg1);
                    }
                }
            }
            if (loc2)
            {
                loc6 = 0;
                loc7 = loc2;
                for each (loc4 in loc7)
                {
                    if (loc4.indexOf(":") < 0)
                    {
                        throw new Error("Invalid Item Meta Data String: " + arg1);
                    }
                    if ((loc5 = loc4.split(":")).length < 2)
                    {
                        throw new Error("Invalid Item Meta Data String: " + arg1);
                    }
                    loc3[loc5[0]] = loc5[1];
                }
            }
            return loc3;
        }

        public function hasProperty(arg1:String):Boolean
        {
            return data.hasOwnProperty(arg1);
        }

        private var data:Array;
    }
}
