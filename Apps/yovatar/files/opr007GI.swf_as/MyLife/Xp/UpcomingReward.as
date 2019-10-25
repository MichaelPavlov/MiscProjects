package MyLife.Xp 
{
    public class UpcomingReward extends Object
    {
        public function UpcomingReward(arg1:int, arg2:MyLife.Xp.Reward, arg3:MyLife.Xp.RewardType)
        {
            super();
            setLevel(arg1);
            setReward(arg2);
            setCriteria(arg3);
            return;
        }

        public function setCriteria(arg1:MyLife.Xp.RewardType):void
        {
            this.criteria = arg1;
            return;
        }

        public function setLevel(arg1:int):void
        {
            this.level = arg1;
            return;
        }

        public function getReward():MyLife.Xp.Reward
        {
            return reward;
        }

        public function getLevel():int
        {
            return level;
        }

        public function setReward(arg1:MyLife.Xp.Reward):void
        {
            this.reward = arg1;
            return;
        }

        public function getCriteria():MyLife.Xp.RewardType
        {
            return criteria;
        }

        private var level:int;

        private var reward:MyLife.Xp.Reward;

        private var criteria:MyLife.Xp.RewardType;
    }
}
