package MyLife.Xp 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Events.*;
    import MyLife.NPC.*;
    import flash.display.*;
    import flash.text.*;
    
    public class XpNextLevelDialog extends flash.display.MovieClip
    {
        public function XpNextLevelDialog(arg1:int, arg2:MyLife.Xp.Reward)
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            super();
            this.nextThreshold = arg1;
            this.nextReward = arg2;
            loc3 = arg2.getRewardType();
            loc4 = arg2.getRewardType().toString();
            nextLevelText.text = arg1 + " YoPoints";
            nextUpgradeText.text = arg2.getRewardName() || "";
            loc11 = arg2.getRewardType().getValue();
            switch (loc11) 
            {
                case RewardType.ACTION.getValue():
                    trace("action");
                case RewardType.DANCE.getValue():
                    trace("dance");
                case RewardType.POSE.getValue():
                    trace("pose");
                    loc5 = ActionLibrary.makeAnimItem(arg2.getRewardObject());
                    animationData = loc5.value;
                    previewAvatar = new SimpleNPC(null, -1);
                    previewAvatar.scaleX = previewAvatar.scaleX * 1.5;
                    previewAvatar.scaleY = previewAvatar.scaleY * 1.5;
                    previewAvatar.y = previewAvatar.y + 70;
                    loc6 = (MyLifeInstance.getInstance() as MyLife).getPlayer().currentClothing;
                    loc7 = (MyLifeInstance.getInstance() as MyLife).getPlayer().getGender();
                    loc8 = (MyLifeInstance.getInstance() as MyLife).getPlayer().getPlayerName();
                    previewAvatar.setCharacterProperties(loc6, loc7, loc8);
                    previewAvatar.getNameTag().visible = false;
                    previewAvatar.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, characterLoadCompleteHandler);
                    previewAvatar.loadCharacterClothing(loc6);
                    break;
                case RewardType.ACCESSORY.getValue():
                    trace("accessory");
                case RewardType.LEVELING_ROOM_GRANT.getValue():
                    trace("levelingRoomGrant");
                case RewardType.LEVELING_ITEM.getValue():
                    trace("levelingItem");
                case RewardType.ITEM.getValue():
                    trace("item");
                    loc9 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg2.getRewardId() + "_130_100.gif?v=" + MyLifeConfiguration.version;
                    AssetsManager.getInstance().loadImage(loc9, imageContainer, imageLoadedCallback);
                    break;
                case RewardType.ROOM_GRANT.getValue():
                    trace("room grant");
                    loc10 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg2.getRewardId() + "_130_100.gif?v=" + MyLifeConfiguration.version;
                    AssetsManager.getInstance().loadImage(loc10, imageContainer, imageLoadedCallback);
                    break;
                default:
                    trace("default");
                    break;
            }
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:*):void
        {
            var loc3:*;

            loc3 = NaN;
            if (arg1 != null)
            {
                arg2.addChild(arg1);
                loc3 = 1;
                if (arg1.width > 130)
                {
                    loc3 = 130 / arg1.width;
                    arg1.width = 130;
                }
                if (loc3 != 1)
                {
                    arg1.height = arg1.height * loc3;
                }
                arg1.x = -arg1.width / 2;
                arg1.y = -arg1.height / 2;
            }
            return;
        }

        public function playAction():void
        {
            var loc1:*;

            loc1 = null;
            if (imageContainer.numChildren && imageContainer.getChildAt(0) as SimpleNPC)
            {
                loc1 = imageContainer.getChildAt(0) as SimpleNPC;
                if (animationData)
                {
                    loc1.doAvatarAction(animationData.a, false, animationData["params"]);
                }
                else 
                {
                    loc1.doAvatarAction(AnimationAction.YOU_DA_BOMB);
                }
            }
            return;
        }

        private function characterLoadCompleteHandler(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;

            loc2 = arg1.target as SimpleNPC;
            imageContainer.addChild(loc2);
            playAction();
            return;
        }

        private var previewAvatar:MyLife.NPC.SimpleNPC;

        private var nextReward:MyLife.Xp.Reward;

        public var imageContainer:flash.display.MovieClip;

        private var animationData:Object;

        public var nextUpgradeText:flash.text.TextField;

        private var nextThreshold:int;

        public var nextLevelText:flash.text.TextField;
    }
}
