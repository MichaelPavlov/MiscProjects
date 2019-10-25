package MyLife.Xp 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Events.*;
    import MyLife.NPC.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class XpNewLevelDialog extends flash.display.MovieClip
    {
        public function XpNewLevelDialog(arg1:int, arg2:String, arg3:String, arg4:MyLife.Xp.Reward)
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;

            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = 0;
            loc11 = null;
            loc12 = null;
            loc13 = null;
            loc14 = null;
            super();
            this.level = arg1;
            this.levelName = arg3;
            this.reward = arg4;
            levelContainer["levelText"].text = arg1;
            levelContainer.scaleY = loc15 = 0;
            levelContainer.scaleX = loc15;
            loc5 = "";
            loc6 = "";
            loc15 = arg4.getRewardType().getValue();
            switch (loc15) 
            {
                case RewardType.ITEM.getValue():
                    loc5 = "item";
                    loc6 = "received a new item";
                    break;
                case RewardType.ACTION.getValue():
                    loc6 = "learned a new action";
                    loc5 = "action";
                    break;
                case RewardType.ACCESSORY.getValue():
                    loc6 = "received a new accessory";
                    loc5 = "accessory";
                    break;
                case RewardType.DANCE.getValue():
                    loc6 = "learned a new dance";
                    loc5 = "dance";
                    break;
                case RewardType.POSE.getValue():
                    loc6 = "learned a new pose";
                    loc5 = "pose";
                    break;
                case RewardType.LEVELING_ROOM_GRANT.getValue():
                case RewardType.LEVELING_ITEM.getValue():
                    if (loc7 = new ItemMetaData(arg4.getRewardObject()))
                    {
                        loc6 = loc7.hasProperty("prev") ? "received an upgrade" : "received an upgradeable item";
                        loc5 = loc7.hasProperty("prev") ? "upgrade" : "upgradeable item";
                    }
                    break;
                case RewardType.ROOM_GRANT.getValue():
                    loc6 = "received an apartment upgrade";
                    loc5 = "apartment upgrade";
                    break;
            }
            loc15 = arg4.getRewardType().getValue();
            switch (loc15) 
            {
                case RewardType.ACTION.getValue():
                    trace("action");
                case RewardType.DANCE.getValue():
                    trace("dance");
                case RewardType.POSE.getValue():
                    trace("pose");
                    loc8 = ActionLibrary.makeAnimItem(arg4.getRewardObject());
                    animationData = loc8.value;
                    previewAvatar = new SimpleNPC(null, -1);
                    previewAvatar.scaleX = previewAvatar.scaleX * 1.5;
                    previewAvatar.scaleY = previewAvatar.scaleY * 1.5;
                    previewAvatar.y = previewAvatar.y + 70;
                    previewAvatar.addEventListener(MouseEvent.CLICK, onAvatarClick, false, 0, true);
                    loc9 = (MyLifeInstance.getInstance() as MyLife).getPlayer().currentClothing;
                    loc10 = (MyLifeInstance.getInstance() as MyLife).getPlayer().getGender();
                    loc11 = (MyLifeInstance.getInstance() as MyLife).getPlayer().getPlayerName();
                    previewAvatar.setCharacterProperties(loc9, loc10, loc11);
                    previewAvatar.getNameTag().visible = false;
                    previewAvatar.addEventListener(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, characterLoadCompleteHandler);
                    previewAvatar.loadCharacterClothing(loc9);
                    break;
                case RewardType.ACCESSORY.getValue():
                    trace("accessory");
                case RewardType.LEVELING_ROOM_GRANT.getValue():
                    trace("levelingRoomGrant");
                case RewardType.LEVELING_ITEM.getValue():
                    trace("levelingItem");
                case RewardType.ITEM.getValue():
                    trace("item");
                    loc12 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg4.getRewardId() + "_130_100.gif?v=" + MyLifeConfiguration.version;
                    AssetsManager.getInstance().loadImage(loc12, imageContainer, imageLoadedCallback);
                    break;
                case RewardType.ROOM_GRANT.getValue():
                    trace("room grant");
                    loc13 = MyLifeConfiguration.getInstance().variables["global"]["item_image_path"] + arg4.getRewardId() + "_130_100.gif?v=" + MyLifeConfiguration.version;
                    AssetsManager.getInstance().loadImage(loc13, imageContainer, imageLoadedCallback);
                    break;
                default:
                    trace("default");
                    break;
            }
            if (loc5 == "reward")
            {
                loc6 = "upgraded to";
            }
            if (arg3 && !(arg3 == ""))
            {
                rewardText.htmlText = "You have earned the title <b><font color=\"#59A8FF\">" + arg3 + "</font></b> and ";
            }
            else 
            {
                rewardText.y = rewardText.y + 20;
                rewardText.htmlText = "You have ";
            }
            rewardText.htmlText = rewardText.htmlText + loc6 + "!<br /><b>" + arg4.getRewardObject().name + "</b>";
            if (arg4.getRewardType().getValue() == RewardType.LEVELING_ITEM.getValue() || arg4.getRewardType().getValue() == RewardType.LEVELING_ROOM_GRANT.getValue() || arg4.getRewardType().getValue() == RewardType.ROOM_GRANT.getValue())
            {
                loc14 = arg4.getRewardObject();
                descriptionText.condenseWhite = true;
                if (loc14.hasOwnProperty("description"))
                {
                    descriptionText.htmlText = (loc14["description"] as String).replace(new RegExp("\\r\\n", "gi"), " ");
                    if (arg4.getRewardType().getValue() == RewardType.ROOM_GRANT.getValue())
                    {
                        descriptionText.htmlText = descriptionText.htmlText + " <a href=\"event:visitRoom\">Visit your " + loc14["name"] + " now!</a>";
                        roomFilename = loc14["filename"];
                        descriptionText.addEventListener(TextEvent.LINK, onDescriptionLinkClick, false, 0, true);
                    }
                }
            }
            else 
            {
                descriptionText.visible = false;
            }
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
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

        private function onDescriptionLinkClick(arg1:flash.events.TextEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = MyLifeInstance.getInstance() as MyLife;
            loc3 = roomFilename + "-" + loc2.getPlayer().getPlayerId();
            loc2.getZone().join(loc3, 1);
            return;
        }

        public function getLevel():int
        {
            return level;
        }

        private function onAvatarClick(arg1:flash.events.MouseEvent):void
        {
            playAction();
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

        private function onAddedToStage(arg1:flash.events.Event):void
        {
            Tweener.addTween(levelContainer, {"time":2, "scaleX":1, "scaleY":1, "transition":"easeOutElastic"});
            return;
        }

        private var previewAvatar:MyLife.NPC.SimpleNPC;

        private var level:int;

        private var roomFilename:String;

        private var animationData:Object;

        public var descriptionText:flash.text.TextField;

        public var levelContainer:flash.display.MovieClip;

        public var imageContainer:flash.display.Sprite;

        private var levelName:String;

        private var reward:MyLife.Xp.Reward;

        public var rewardText:flash.text.TextField;
    }
}
