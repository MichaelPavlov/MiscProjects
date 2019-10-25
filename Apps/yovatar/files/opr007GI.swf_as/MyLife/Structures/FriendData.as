package MyLife.Structures 
{
    public class FriendData extends MyLife.Structures.UserData
    {
        public function FriendData(arg1:Number=0, arg2:Number=0, arg3:String="", arg4:Object=null, arg5:String="", arg6:String="", arg7:String="")
        {
            super(arg1, arg2, arg3, arg4);
            this.firstName = arg5;
            this.lastName = arg6;
            this.picUrl = arg7;
            return;
        }

        public var lastName:String;

        public var picUrl:String;

        public var firstName:String;
    }
}
