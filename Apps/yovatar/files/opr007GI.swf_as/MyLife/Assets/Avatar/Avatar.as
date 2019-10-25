package MyLife.Assets.Avatar 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Assets.Avatar.Effects.*;
    import MyLife.Events.*;
    import MyLife.Utils.*;
    import flash.display.*;
    
    public class Avatar extends flash.display.MovieClip
    {
        public function Avatar()
        {
            super();
            if (registeredAnimations == false)
            {
                ActionLibrary.registerAnimationClipClass(robotDanceFront, "robotDanceFront");
                ActionLibrary.registerAnimationClipClass(jumpingJacksFront, "jumpingJacksFront");
                ActionLibrary.registerAnimationClipClass(armShuffleFront, "armShuffleFront");
                ActionLibrary.registerAnimationClipClass(mysticLevitationFront, "mysticLevitationFront");
                ActionLibrary.registerAnimationClipClass(jumpAndSwingFront, "jumpAndSwingFront");
                ActionLibrary.registerAnimationClipClass(powerJumpFront, "powerJumpFront");
                ActionLibrary.registerAnimationClipClass(youDaBombFront, "youDaBombFront");
                ActionLibrary.registerAnimationClipClass(walkFront, "walkFront");
                ActionLibrary.registerAnimationClipClass(walkBack, "walkBack");
                ActionLibrary.registerAnimationClipClass(standFront, "standFront");
                ActionLibrary.registerAnimationClipClass(standBack, "standBack");
                ActionLibrary.registerAnimationClipClass(sitFront, "sitFront");
                ActionLibrary.registerAnimationClipClass(sitBack, "sitBack");
                registeredAnimations = true;
            }
            clothingConflictManager = new ClothingConflictManager(this);
            return;
        }

        public function getCurrentAvatarClothes():Object
        {
            var loc1:*;

            loc1 = clothingConflictManager.getFormattedClothingList();
            if (loc1["body"] == null)
            {
                loc1["body"] = {"itemId":gender};
            }
            return loc1;
        }

        public function setZzzStatus(arg1:Boolean):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1 != true)
            {
                removeEffect();
            }
            else 
            {
                loc2 = new zzzAnimation() as MovieClip;
                loc2.scaleX = (avatarClip.scaleX < 0) ? -1 : 1;
                addEffect(loc2);
            }
            return;
        }

        public function onAllClothesLoaded():*
        {
            renderClothes(currentClothes, true);
            this.visible = true;
            dispatchEvent(new AvatarLoadEvent(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE));
            return;
        }

        private function onLoadTempCostume(arg1:MyLife.Events.AssetManagerEvent):*
        {
            if (arg1.asset.itemId == temporaryCostume.itemId)
            {
                trace("removing costume listener");
                AssetsManager.getInstance().removeEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onLoadTempCostume);
                clothingConflictManager.addClothingItem(temporaryCostume);
                trace("costumeLoaded");
            }
            return;
        }

        public function getCurrentAvatarClothingItem(arg1:String):Object
        {
            if (currentClothes[arg1] == undefined)
            {
                return false;
            }
            return currentClothes[arg1];
        }

        public function initAvatar(arg1:Number, arg2:Number):void
        {
            var loc3:*;

            this.scaleY = loc3 = arg2;
            this.scaleX = loc3;
            this.gender = arg1;
            return;
        }

        public function doAvatarAction(arg1:String=null):void
        {
            if (localAnimation != null)
            {
                localAnimation.stop();
            }
            if (arg1 != null)
            {
                localAnimation = new AnimationAction(arg1, this);
                localAnimation.start();
            }
            return;
        }

        public function cleanUp():void
        {
            removeEffect();
            avatarFrontClip = null;
            avatarBackClip = null;
            if (localAnimation != null)
            {
                localAnimation.stop();
            }
            localAnimation = null;
            clothesLoader = null;
            clothingConflictManager = null;
            if (clothingConflictManager != null)
            {
                clothingConflictManager.cleanUp();
            }
            clothingConflictManager = null;
            avatarClip = null;
            currentClothes = null;
            return;
        }

        public function setParentCharacter(arg1:flash.display.MovieClip):void
        {
            parentCharacter = arg1;
            return;
        }

        public function addEffect(arg1:flash.display.MovieClip):void
        {
            removeEffect();
            effect = arg1;
            this.addChild(effect);
            return;
        }

        private function transferClipsToNewAnimation(arg1:flash.display.MovieClip, arg2:flash.display.MovieClip):*
        {
            var childClip:flash.display.MovieClip;
            var destinationAnimation:flash.display.MovieClip;
            var destinationChild:flash.display.MovieClip;
            var i:int;
            var loc3:*;
            var loc4:*;
            var sourceAnimation:flash.display.MovieClip;
            var sourceChild:flash.display.MovieClip;

            sourceChild = null;
            destinationChild = null;
            childClip = null;
            sourceAnimation = arg1;
            destinationAnimation = arg2;
            if (sourceAnimation == null || destinationAnimation == null)
            {
                return;
            }
            i = 0;
            while (i < sourceAnimation.numChildren) 
            {
                sourceChild = sourceAnimation.getChildAt(i) as MovieClip;
                try
                {
                    destinationChild = destinationAnimation.getChildByName(sourceChild.name) as MovieClip;
                }
                catch (error:*)
                {
                };
                if (destinationChild != null)
                {
                    DisplayObjectContainerUtils.removeChildren(destinationChild);
                    while (sourceChild.numChildren > 0) 
                    {
                        childClip = sourceChild.getChildAt(0) as MovieClip;
                        if (childClip == null)
                        {
                            continue;
                        }
                        destinationChild[childClip.name] = childClip;
                        destinationChild.addChild(childClip);
                    }
                }
                i = (i + 1);
            }
            return;
        }

        public function loadAvatarClothes(arg1:Object, arg2:Boolean=false, arg3:Object=null):*
        {
            var loc4:*;
            var loc5:*;

            loc5 = null;
            this.visible = arg2;
            loc4 = getClothingFileArray(arg1);
            temporaryCostume = arg3;
            if (temporaryCostume != null)
            {
                loc5 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["avatar_asset_path"] + temporaryCostume.filename + ".swf";
                loc4.push({"url":loc5, "itemId":temporaryCostume.itemId, "filename":temporaryCostume.filename});
            }
            currentClothes = arg1;
            if (loc4.length != 0)
            {
                clothesLoader = new AssetListLoader();
                clothesLoader.loadAssets(loc4, onAllClothesLoaded);
            }
            else 
            {
                this.onAllClothesLoaded();
            }
            return;
        }

        public function renderClothes(arg1:Object, arg2:Boolean=false):*
        {
            trace("renderClothes " + arg2 + " " + temporaryCostume);
            if (arg2 == false)
            {
                temporaryCostume = null;
            }
            currentClothes = arg1;
            if (avatarClip != null)
            {
                clothingConflictManager.renderClothes(arg1);
            }
            else 
            {
                avatarBackClip = ActionLibrary.getAnimationClipInstance("standBack");
                avatarBackClip.chest.skin.gotoAndStop(gender);
                avatarBackClip.leftUpperArm.skin.gotoAndStop(gender);
                avatarBackClip.rightUpperArm.skin.gotoAndStop(gender);
                avatarBackClip.leftForeArm.skin.gotoAndStop(gender);
                avatarBackClip.rightForeArm.skin.gotoAndStop(gender);
                setAnimationClip(ActionLibrary.getAnimationClipInstance("standFront"), 0);
            }
            if (arg2 == true && !(temporaryCostume == null))
            {
                clothingConflictManager.addClothingItem(temporaryCostume);
            }
            return;
        }

        public function getDirection():Number
        {
            return currentDirection;
        }

        public function doRandomDance():void
        {
            var loc1:*;
            var loc2:*;

            loc2 = null;
            loc1 = Math.round(Math.random() * 3);
            if (loc1 != 0)
            {
                if (loc1 != 1)
                {
                    if (loc1 != 2)
                    {
                        if (loc1 == 3)
                        {
                            loc2 = "JUMPING_JACKS_LOOP";
                        }
                    }
                    else 
                    {
                        loc2 = "ARM_SHUFFLE_LOOP";
                    }
                }
                else 
                {
                    loc2 = "JUMP_AND_SWING_LOOP";
                }
            }
            else 
            {
                loc2 = "ROBOT_DANCE_LOOP";
            }
            doAvatarAction(loc2);
            return;
        }

        public function isFront():Boolean
        {
            return currentDirection == MyLifeInstance.LEFT_FRONT || currentDirection == MyLifeInstance.RIGHT_FRONT;
        }

        public function changeDirection(arg1:Number):void
        {
            if (localAnimation == null)
            {
                this.setAnimationClip(ActionLibrary.getAnimationClipInstance("standFront"), arg1);
            }
            else 
            {
                localAnimation.changeDirection(arg1);
            }
            return;
        }

        public function removeEffect():void
        {
            if (effect != null)
            {
                if (effect.hasOwnProperty("destroy"))
                {
                    effect.destroy();
                }
                if (effect.parent != null)
                {
                    effect.parent.removeChild(effect);
                }
                effect = null;
            }
            return;
        }

        public function getGender():Number
        {
            return gender;
        }

        public function setAnimationClip(arg1:flash.display.MovieClip, arg2:Number):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            removeEffect();
            if (avatarClip == null)
            {
                loc3 = this.currentClothes;
            }
            else 
            {
                if (avatarClip.parent != null)
                {
                    avatarClip.parent.removeChild(avatarClip);
                }
                avatarClip = null;
            }
            currentDirection = arg2;
            loc4 = arg2 == MyLifeInstance.LEFT_FRONT || arg2 == MyLifeInstance.RIGHT_FRONT;
            loc5 = arg2 == MyLifeInstance.LEFT_FRONT || arg2 == MyLifeInstance.RIGHT_BACK;
            avatarClip = arg1;
            if (loc4)
            {
                if (avatarFrontClip == null)
                {
                    this.avatarFrontClip = avatarClip;
                    this.clothingConflictManager.renderClothes(loc3);
                    avatarClip.chest.skin.gotoAndStop(gender);
                    avatarClip.leftUpperArm.skin.gotoAndStop(gender);
                    avatarClip.rightUpperArm.skin.gotoAndStop(gender);
                    avatarClip.leftForeArm.skin.gotoAndStop(gender);
                    avatarClip.rightForeArm.skin.gotoAndStop(gender);
                }
                else 
                {
                    transferClipsToNewAnimation(avatarFrontClip, avatarClip);
                    this.avatarFrontClip = avatarClip;
                }
            }
            else 
            {
                if (avatarBackClip == null)
                {
                    this.avatarBackClip = avatarClip;
                    this.clothingConflictManager.renderClothes(loc3);
                    avatarClip.chest.skin.gotoAndStop(gender);
                    avatarClip.leftUpperArm.skin.gotoAndStop(gender);
                    avatarClip.rightUpperArm.skin.gotoAndStop(gender);
                    avatarClip.leftForeArm.skin.gotoAndStop(gender);
                    avatarClip.rightForeArm.skin.gotoAndStop(gender);
                }
                else 
                {
                    transferClipsToNewAnimation(avatarBackClip, avatarClip);
                    this.avatarBackClip = avatarClip;
                }
            }
            if (avatarClip != null)
            {
                avatarClip.scaleX = Math.abs(avatarClip.scaleX) * loc5 ? -1 : 1;
                this.addChild(avatarClip);
                addEffectForDefaultAnimation();
            }
            return;
        }

        private function addEffectForDefaultAnimation():void
        {
            var loc1:*;

            loc1 = null;
            if (avatarClip as mysticLevitationFront)
            {
                loc1 = new SummonStarsAnimation() as MovieClip;
            }
            else 
            {
                if (avatarClip as powerJumpFront)
                {
                    loc1 = new BigJumpExplosion([13, 58], avatarClip, -1) as MovieClip;
                }
                else 
                {
                    if (avatarClip as youDaBombFront)
                    {
                        loc1 = new FireAnimation() as MovieClip;
                    }
                }
            }
            if (loc1 != null)
            {
                loc1.scaleX = 5;
                loc1.scaleY = 5;
                addEffect(loc1);
            }
            return;
        }

        public function renderItem(arg1:Object, arg2:Boolean=false):*
        {
            var loc3:*;

            loc3 = null;
            if (arg2 != false)
            {
                trace("adding costume listener");
                temporaryCostume = arg1;
                AssetsManager.getInstance().addEventListener(AssetManagerEvent.ASSETLOAD_SUCCESS, onLoadTempCostume);
                loc3 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["avatar_asset_path"] + temporaryCostume.filename + ".swf";
                AssetsManager.getInstance().loadAsset({"url":loc3, "itemId":temporaryCostume.itemId, "filename":temporaryCostume.filename});
            }
            else 
            {
                this.clothingConflictManager.addClothingItem(arg1);
            }
            return;
        }

        private static function getClothingFileArray(arg1:Object):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc2 = [];
            if (arg1 == null)
            {
                return loc2;
            }
            loc6 = 0;
            loc7 = arg1;
            for (loc3 in loc7)
            {
                if (arg1[loc3].itemId == null && !(arg1[loc3].id == null))
                {
                    arg1[loc3].itemId = arg1[loc3].id;
                }
                if (arg1[loc3].metaData == null && !(arg1[loc3].meta_data == null))
                {
                    arg1[loc3].metaData = arg1[loc3].meta_data;
                }
                if (arg1[loc3].g == null && !(arg1[loc3].gender == null))
                {
                    arg1[loc3].g = arg1[loc3].gender;
                }
                if (!(arg1[loc3].filename == null) && !(arg1[loc3].filename == ""))
                {
                    loc4 = arg1[loc3].filename;
                }
                if (loc4 == null)
                {
                    continue;
                }
                loc5 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["avatar_asset_path"] + loc4 + ".swf";
                loc2.push({"url":loc5, "itemId":arg1[loc3].itemId, "filename":loc4});
            }
            return loc2;
        }

        
        {
            registeredAnimations = false;
        }

        public static const FaceBack:Class=Avatar_FaceBack;

        public static const FemaleChestShirtBack:Class=Avatar_FemaleChestShirtBack;

        public static const HairBack:Class=Avatar_HairBack;

        public static const FemaleNoseFront:Class=Avatar_FemaleNoseFront;

        public static const youDaBombFront:Class=Avatar_youDaBombFront;

        public static const jumpAndSwingFront:Class=Avatar_jumpAndSwingFront;

        public static const RightEarFront:Class=Avatar_RightEarFront;

        public static const RightThighPantsBack:Class=Avatar_RightThighPantsBack;

        public static const PelvisPantsBack:Class=Avatar_PelvisPantsBack;

        public static const powerJumpFront:Class=Avatar_powerJumpFront;

        public static const FemaleChestShirtFront:Class=Avatar_FemaleChestShirtFront;

        public static const jumpingJacksFront:Class=Avatar_jumpingJacksFront;

        public static const MaleEyeBrowsFront:Class=Avatar_MaleEyeBrowsFront;

        public static const MaleChestShirtBack:Class=Avatar_MaleChestShirtBack;

        public static const FaceFront:Class=Avatar_FaceFront;

        public static const FemaleMouthFront:Class=Avatar_FemaleMouthFront;

        public static const MaleMouthFront:Class=Avatar_MaleMouthFront;

        public static const FemaleEyeBrowsFront:Class=Avatar_FemaleEyeBrowsFront;

        public static const MaleEyesFront:Class=Avatar_MaleEyesFront;

        public static const LeftThighPantsFront:Class=Avatar_LeftThighPantsFront;

        public static const LeftEarBack:Class=Avatar_LeftEarBack;

        public static const robotDanceFront:Class=Avatar_robotDanceFront;

        public static const RightEarBack:Class=Avatar_RightEarBack;

        public static const armShuffleFront:Class=Avatar_armShuffleFront;

        public static const HairFront:Class=Avatar_HairFront;

        public static const LeftEarFront:Class=Avatar_LeftEarFront;

        public static const RightThighPantsFront:Class=Avatar_RightThighPantsFront;

        public static const mysticLevitationFront:Class=Avatar_mysticLevitationFront;

        public static const MaleChestShirtFront:Class=Avatar_MaleChestShirtFront;

        public static const walkBack:Class=Avatar_walkBack;

        public static const FemaleEyesFront:Class=Avatar_FemaleEyesFront;

        public static const PelvisPantsFront:Class=Avatar_PelvisPantsFront;

        public static const walkFront:Class=Avatar_walkFront;

        public static const standBack:Class=Avatar_standBack;

        public static const MaleNoseFront:Class=Avatar_MaleNoseFront;

        public static const zzzAnimation:Class=Avatar_zzzAnimation;

        public static const sitFront:Class=Avatar_sitFront;

        public static const standFront:Class=Avatar_standFront;

        public static const LeftThighPantsBack:Class=Avatar_LeftThighPantsBack;

        public static const sitBack:Class=Avatar_sitBack;

        public var avatarFrontClip:flash.display.MovieClip;

        private var gender:Number;

        private var currentDirection:Number=-1;

        public var avatarClip:flash.display.MovieClip;

        private var currentClothes:Object;

        public var avatarBackClip:flash.display.MovieClip;

        private var effect:flash.display.MovieClip;

        private var clothingConflictManager:MyLife.Assets.Avatar.ClothingConflictManager;

        private var temporaryCostume:Object;

        private var localAnimation:MyLife.Assets.Avatar.AvatarActions.AnimationAction;

        public var parentCharacter:flash.display.MovieClip;

        private var clothesLoader:MyLife.AssetListLoader;

        private static var registeredAnimations:Boolean=false;
    }
}
