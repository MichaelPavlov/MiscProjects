package MyLife.Structures 
{
    public class UserData extends Object
    {
        public function UserData(arg1:Number=0, arg2:Number=0, arg3:String="", arg4:Object=null)
        {
            super();
            this.playerId = arg1;
            this.gender = arg2;
            this.name = arg3;
            this.clothesData = arg4 || {};
            return;
        }

        public var gender:Number;

        public var clothesData:Object;

        public var name:String;

        public var playerId:Number;
    }
}
