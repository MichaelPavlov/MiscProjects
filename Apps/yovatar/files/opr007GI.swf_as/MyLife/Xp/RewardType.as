package MyLife.Xp 
{
    import MyLife.Utils.*;
    
    public class RewardType extends MyLife.Utils.Enum
    {
        public function RewardType(arg1:int)
        {
            super();
            this.value = arg1;
            return;
        }

        public function compare(arg1:MyLife.Xp.RewardType):Boolean
        {
            return value == arg1.getValue();
        }

        public function getValue():int
        {
            return value;
        }

        public function toString():String
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = true;
            switch (loc2) 
            {
                case compare(NONE):
                    loc1 = "NONE";
                    break;
                case compare(ACTION):
                    loc1 = "ACTION";
                    break;
                case compare(DANCE):
                    loc1 = "DANCE";
                    break;
                case compare(ITEM):
                    loc1 = "ITEM";
                    break;
                case compare(ACCESSORY):
                    loc1 = "ACCESSORY";
                    break;
                case compare(LEVELING_ITEM):
                    loc1 = "LEVELING_ITEM";
                    break;
                case compare(ROOM_GRANT):
                    loc1 = "ROOM_GRANT";
                    break;
                case compare(LEVELING_ROOM_GRANT):
                    loc1 = "LEVELING_ROOM_GRANT";
                    break;
                default:
                    break;
            }
            return loc1;
        }

        
        {
            initEnum(RewardType);
        }

        public static const POSE:MyLife.Xp.RewardType=new RewardType(3);

        public static const ACCESSORY:MyLife.Xp.RewardType=new RewardType(5);

        public static const DANCE:MyLife.Xp.RewardType=new RewardType(2);

        public static const LEVELING_ITEM:MyLife.Xp.RewardType=new RewardType(6);

        public static const ACTION:MyLife.Xp.RewardType=new RewardType(1);

        public static const NONE:MyLife.Xp.RewardType=new RewardType(-1);

        public static const LEVELING_ROOM_GRANT:MyLife.Xp.RewardType=new RewardType(8);

        public static const ITEM:MyLife.Xp.RewardType=new RewardType(4);

        public static const ROOM_GRANT:MyLife.Xp.RewardType=new RewardType(7);

        private var value:int;
    }
}
