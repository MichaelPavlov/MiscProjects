package MyLife.Assets.Avatar.AvatarActions 
{
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    
    public class AvatarAction extends flash.events.EventDispatcher
    {
        public function AvatarAction(arg1:String, arg2:flash.display.MovieClip, arg3:Object, arg4:Number=2, arg5:Boolean=false)
        {
            super();
            this.actionId = arg1;
            this.actionParams = arg3;
            this.avatarClip = arg2;
            this.characterClip = arg2.parentCharacter;
            this.interruptionType = arg4;
            this.isWaiting = arg5;
            return;
        }

        public function stop():void
        {
            avatarClip.removeEventListener(Event.ENTER_FRAME, updateAction);
            return;
        }

        public function cleanUp():void
        {
            if (avatarClip != null)
            {
                avatarClip.removeEventListener(Event.ENTER_FRAME, updateAction);
            }
            avatarClip = null;
            characterClip = null;
            actionParams = null;
            return;
        }

        protected function onActionComplete():void
        {
            avatarClip.removeEventListener(Event.ENTER_FRAME, updateAction);
            dispatchEvent(new AvatarActionEvent(AvatarActionEvent.ACTION_COMPLETE, this.actionId, 0, this.actionParams, ""));
            return;
        }

        public function getActionParams():Object
        {
            return actionParams;
        }

        public function getInterruptionType():Number
        {
            return interruptionType;
        }

        protected function updateAction(arg1:flash.events.Event):void
        {
            return;
        }

        public function getActionId():String
        {
            return this.actionId;
        }

        public function start():void
        {
            avatarClip.addEventListener(Event.ENTER_FRAME, updateAction);
            return;
        }

        public function isAvatarWaiting():Boolean
        {
            return isWaiting;
        }

        public function resume():void
        {
            start();
            return;
        }

        public function changeDirection(arg1:Number):void
        {
            return;
        }

        public function getCharacter():flash.display.MovieClip
        {
            return characterClip;
        }

        public function pause():void
        {
            stop();
            return;
        }

        public static const INTERRUPTION_DO_NEVER:Number=1;

        public static const INTERRUPTION_DO_LATER:Number=0;

        public static const INTERRUPTION_DO_NOW:Number=2;

        protected var isWaiting:Boolean;

        protected var avatarClip:flash.display.MovieClip;

        protected var characterClip:flash.display.MovieClip;

        protected var actionParams:Object;

        protected var interruptionType:Number;

        protected var actionId:String;
    }
}
