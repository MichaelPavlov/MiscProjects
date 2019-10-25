package MyLife.Interfaces.LeaderBoard 
{
    import MyLife.Assets.Avatar.*;
    import flash.display.*;
    import flash.events.*;
    
    public class PlayerCard extends flash.display.Sprite
    {
        public function PlayerCard()
        {
            super();
            inviteFriend.visible = false;
            loading.visible = false;
            friendPlaceholder = new Sprite();
            addChild(friendPlaceholder);
            inviteFriend.addEventListener(MouseEvent.CLICK, onInviteFriendClick, false, 0, true);
            return;
        }

        public function setFriend(arg1:MyLife.Interfaces.LeaderBoard.PlayerItem):void
        {
            while (friendPlaceholder.numChildren > 0) 
            {
                friendPlaceholder.removeChildAt(0);
            }
            friendPlaceholder.addChild(arg1);
            friendPlaceholder.visible = true;
            loading.visible = false;
            inviteFriend.visible = false;
            this.playerItem = arg1;
            return;
        }

        public function destroy():void
        {
            var loc1:*;

            if (!playerItem)
            {
                return;
            }
            loc1 = playerItem.getAvatarClip() as Avatar;
            if (loc1)
            {
                loc1.cleanUp();
            }
            return;
        }

        private function onInviteFriendClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new Event(INVITE_FRIEND_CLICK));
            return;
        }

        public function setInviteFriend():void
        {
            inviteFriend.visible = true;
            loading.visible = false;
            friendPlaceholder.visible = false;
            return;
        }

        public function getPlayerItem():MyLife.Interfaces.LeaderBoard.PlayerItem
        {
            return playerItem;
        }

        public function setLoading():void
        {
            loading.visible = true;
            inviteFriend.visible = false;
            friendPlaceholder.visible = false;
            return;
        }

        public static const INVITE_FRIEND_CLICK:String="playerCardOnInviteFriendClick";

        public var inviteFriend:flash.display.SimpleButton;

        private var playerItem:MyLife.Interfaces.LeaderBoard.PlayerItem;

        private var friendPlaceholder:flash.display.Sprite;

        public var loading:flash.display.MovieClip;
    }
}
