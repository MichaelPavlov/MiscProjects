package MyLife.Utils 
{
    public class StringUtils extends Object
    {
        public function StringUtils()
        {
            super();
            return;
        }

        public static function getRankString(arg1:int):*
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = arg1.toString();
            if (arg1 > 100 || arg1 == 0)
            {
                return loc2;
            }
            loc3 = loc2.charAt((loc2.length - 1));
            if (loc3 == "1")
            {
                if (arg1 == 11)
                {
                    return "11th";
                }
                return loc2 + "st";
            }
            if (loc3 == "2")
            {
                if (arg1 == 12)
                {
                    return "12th";
                }
                return loc2 + "nd";
            }
            if (loc3 == "3")
            {
                if (arg1 == 13)
                {
                    return "13th";
                }
                return loc2 + "rd";
            }
            return loc2 + "th";
        }
    }
}
