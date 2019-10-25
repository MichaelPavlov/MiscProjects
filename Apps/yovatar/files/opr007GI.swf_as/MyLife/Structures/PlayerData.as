package MyLife.Structures 
{
    public class PlayerData extends MyLife.Structures.FriendData
    {
        public function PlayerData(arg1:Number=0, arg2:Number=0, arg3:String="", arg4:Object=null, arg5:String="", arg6:String="", arg7:MyLife.Structures.StatsData=null, arg8:Number=0)
        {
            super(arg1, arg2, arg3, arg4, arg5, arg6);
            this.statsData = arg7 || new StatsData();
            this.coins = arg8;
            return;
        }

        public var statsData:MyLife.Structures.StatsData;

        public var coins:Number;
    }
}
