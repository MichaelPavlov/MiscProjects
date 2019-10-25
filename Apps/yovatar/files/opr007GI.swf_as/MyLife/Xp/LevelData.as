package MyLife.Xp 
{
    public class LevelData extends Object
    {
        public function LevelData(arg1:int, arg2:int, arg3:String)
        {
            super();
            setLevel(arg1);
            setThreshold(arg2);
            setName(arg3);
            return;
        }

        public function getName():String
        {
            return name;
        }

        public function setLevel(arg1:int):void
        {
            this.level = arg1;
            return;
        }

        public function setThreshold(arg1:int):void
        {
            this.threshold = arg1;
            return;
        }

        public function setName(arg1:String):void
        {
            this.name = arg1;
            return;
        }

        public function getLevel():int
        {
            return level;
        }

        public function getThreshold():int
        {
            return threshold;
        }

        private var level:int;

        private var threshold:int;

        private var name:String;
    }
}
