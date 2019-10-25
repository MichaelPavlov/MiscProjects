package MyLife.Assets 
{
    public class InteractiveActionItem extends MyLife.Assets.InteractiveItem
    {
        public function InteractiveActionItem()
        {
            super();
            return;
        }

        public function setRoomVariable(arg1:String, arg2:Object, arg3:Boolean=true):void
        {
            this.zim.setRoomVariable(this.playerItemId + "." + arg1, arg2, arg3);
            return;
        }

        protected function dispatchActionEvent(arg1:Number, arg2:Object=null):void
        {
            arg2.piid = this.playerItemId;
            arg2.posId = Number(Math.round(this.x) + "" + Math.round(this.y));
            this.zim.getProp("server").callExtension("sendJSON", {"uid":arg1, "a":arg2});
            return;
        }

        public function doItemAction(arg1:Number, arg2:Boolean=false, arg3:Object=null):void
        {
            if (arg2)
            {
                dispatchActionEvent(arg1, arg3);
            }
            return;
        }

        public function getRoomVariable(arg1:*):Object
        {
            return this.zim.getRoomVariable(this.playerItemId + "." + arg1);
        }
    }
}
