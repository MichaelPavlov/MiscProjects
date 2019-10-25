package MyLife.Xp 
{
    public class Reward extends Object
    {
        public function Reward(arg1:MyLife.Xp.RewardType, arg2:int, arg3:Object)
        {
            super();
            setRewardType(arg1);
            setRewardId(arg2);
            setRewardObject(arg3);
            return;
        }

        public function getRewardId():int
        {
            return rewardId;
        }

        public function getRewardObject():Object
        {
            return rewardObject;
        }

        public function setRewardType(arg1:MyLife.Xp.RewardType):void
        {
            this.rewardType = arg1;
            return;
        }

        public function setRewardId(arg1:int):void
        {
            this.rewardId = arg1;
            return;
        }

        public function setRewardObject(arg1:Object):void
        {
            this.rewardObject = arg1;
            return;
        }

        public function getRewardName():String
        {
            if (getRewardObject())
            {
                return getRewardObject().name;
            }
            return null;
        }

        public function getRewardType():MyLife.Xp.RewardType
        {
            return rewardType;
        }

        public static const ITEM:String="ITEM";

        private var rewardType:MyLife.Xp.RewardType;

        private var rewardId:int;

        private var rewardObject:Object;
    }
}
