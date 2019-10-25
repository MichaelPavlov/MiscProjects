package MyLife.Xp 
{
    public class ProgressData extends Object
    {
        public function ProgressData(arg1:int, arg2:int, arg3:int, arg4:int)
        {
            super();
            setPlayerId(arg1);
            setXpCount(arg2);
            setMaxLevel(arg3);
            setThreshold(arg4);
            return;
        }

        public function getXpCount():int
        {
            return xp_count;
        }

        public function setMaxLevel(arg1:int):void
        {
            if (arg1 < 1)
            {
                this.max_level = 1;
            }
            else 
            {
                this.max_level = arg1;
            }
            return;
        }

        public function getThreshold():int
        {
            return threshold;
        }

        public function setThreshold(arg1:int):void
        {
            this.threshold = arg1;
            return;
        }

        public function getPlayerId():int
        {
            return playerId;
        }

        public function setXpCount(arg1:int):void
        {
            this.xp_count = arg1;
            return;
        }

        public function getMaxLevel():int
        {
            return max_level;
        }

        public function setPlayerId(arg1:int):void
        {
            this.playerId = arg1;
            return;
        }

        private var xp_count:int;

        private var max_level:int;

        private var threshold:int;

        private var playerId:int;
    }
}
