package MyLife.Structures 
{
    public class StatsData extends Object
    {
        public function StatsData(arg1:Number=0, arg2:Number=0, arg3:Number=0)
        {
            super();
            this.energyLevel = arg1;
            this.speedLevel = arg2;
            this.drinksLevel = arg3;
            return;
        }

        public var drinksLevel:Number;

        public var energyLevel:Number;

        public var speedLevel:Number;
    }
}
