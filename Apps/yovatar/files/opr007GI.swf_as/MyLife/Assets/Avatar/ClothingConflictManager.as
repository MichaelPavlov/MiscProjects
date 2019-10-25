package MyLife.Assets.Avatar 
{
    import MyLife.*;
    import MyLife.Clothes.*;
    import MyLife.Utils.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class ClothingConflictManager extends Object
    {
        public function ClothingConflictManager(arg1:MyLife.Assets.Avatar.Avatar)
        {
            super();
            categoryToIDMapping = new Object();
            clothingList = new Object();
            renderedPartList = new Object();
            this.avatar = arg1;
            if (defaultClothing == null)
            {
                setAllPartsList();
            }
            clearAllClothes(arg1.avatarFrontClip);
            clearAllClothes(arg1.avatarBackClip);
            return;
        }

        private function renderDefaultClothing(arg1:String, arg2:Boolean):void
        {
            var loc3:*;
            var loc4:*;

            if (arg2)
            {
                if (!(categoryToIDMapping[arg1] == null || categoryToIDMapping[arg1].itemId == 0 || categoryToIDMapping[arg1].itemId == null))
                {
                    return;
                }
            }
            loc3 = defaultClothing[arg1];
            if (arg1 == "shirt")
            {
                isWearingSwimsuitTop = false;
            }
            if (arg1 == "pants")
            {
                isWearingSwimsuitBottom = false;
            }
            if (loc3 == null)
            {
                if (!(categoryToIDMapping[arg1] == null) && !(categoryToIDMapping[arg1].itemId == null))
                {
                    removeClothingItem(categoryToIDMapping[arg1].itemId);
                }
                return;
            }
            if ((loc4 = getPartList(loc3)).length > 0)
            {
                clothingList[loc3.itemId] = loc4;
                categoryToIDMapping[arg1] = loc3;
            }
            return;
        }

        public function addClothingItem(arg1:Object, arg2:Boolean=true):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            if (arg1.itemId == null || isNaN(arg1.itemId))
            {
                if (arg1.id)
                {
                    arg1.itemId = arg1.id;
                    delete arg1.id;
                }
            }
            if (arg1.categoryId == null || isNaN(arg1.categoryId))
            {
                if (arg1.item_category_id)
                {
                    arg1.categoryId = arg1.item_category_id;
                    delete arg1.item_category_id;
                }
            }
            if (arg1.metaData == null)
            {
                if (arg1.meta_data)
                {
                    arg1.metaData = arg1.meta_data;
                    delete arg1.meta_data;
                }
            }
            if (arg1.itemId != 0)
            {
                if (arg1.categoryId != 1000)
                {
                    if (!((loc6 = getPartList(arg1)) == null) && loc6.length > 0)
                    {
                        loc3 = (arg1.metaData != null) ? arg1.metaData : arg1.meta_data;
                        if ((loc4 = convertMetaDataStringToObject(loc3)).SkinFill && loc4.SkinOutline)
                        {
                            tempSkinFillColor = Number("0x" + loc4.SkinFill);
                            tempSkinOutlineColor = Number("0x" + loc4.SkinOutline);
                            skinChangeItemId = arg1.itemId;
                        }
                        clothingList[arg1.itemId] = loc6;
                    }
                }
                else 
                {
                    categoryToIDMapping["skin"] = arg1;
                    if (arg1.gender == null)
                    {
                        arg1.gender = 1;
                    }
                    if (isNaN(avatar.getGender()) || avatar.getGender() == 0)
                    {
                        avatar.initAvatar(arg1.gender, avatar.scaleX);
                    }
                    categoryToIDMapping["body"] = arg1;
                    loc3 = (arg1.metaData != null) ? arg1.metaData : arg1.meta_data;
                    loc4 = convertMetaDataStringToObject(loc3);
                    skinFillColor = Number("0x" + loc4.Fill);
                    skinOutlineColor = Number("0x" + loc4.Outline);
                }
            }
            else 
            {
                loc5 = convertLabelToSaveReadyLabel(arg1.category);
                renderDefaultClothing(loc5, false);
            }
            if (arg2)
            {
                completeRendering();
            }
            return;
        }

        public function cleanUp():void
        {
            clothingList = null;
            renderedPartList = null;
            categoryToIDMapping = null;
            avatar = null;
            defaultClothing = null;
            return;
        }

        private function getContainerClip(arg1:String, arg2:flash.display.MovieClip):flash.display.MovieClip
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (arg2 == null)
            {
                return null;
            }
            loc3 = arg1.indexOf(".", 0);
            if (loc3 == -1)
            {
                return arg2.getChildByName(arg1) as MovieClip;
            }
            loc4 = arg1.substring(0, loc3);
            loc5 = arg1.substring(loc3 + 1, arg1.length);
            return getContainerClip(loc5, arg2.getChildByName(loc4) as MovieClip);
        }

        private function setCategoryIDMapping(arg1:String, arg2:Object):void
        {
            var loc3:*;

            loc3 = convertLabelToSaveReadyLabel(arg1);
            if (loc3 != null)
            {
                this.categoryToIDMapping[loc3] = arg2;
            }
            return;
        }

        private function clearAllClothes(arg1:flash.display.MovieClip):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            this.categoryToIDMapping = new Object();
            this.clothingList = new Object();
            this.renderedPartList = new Object();
            loc2 = SimpleClothingItem.ALL_VIEWS;
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                if ((loc4 = getContainerClip(loc2[loc3].containerClip, arg1)) != null)
                {
                    if (loc4.numChildren > 0)
                    {
                        DisplayObjectContainerUtils.removeChildren(loc4);
                    }
                }
                loc3 = (loc3 + 1);
            }
            return;
        }

        private function addPart(arg1:String, arg2:String, arg3:Number, arg4:flash.display.MovieClip, arg5:Object):Boolean
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = (arg4 != avatar.avatarFrontClip) ? "Back" : "Front";
            loc7 = getContainerClip(arg2, arg4);
            if ((loc8 = getClothingClip(arg3, loc6, arg1)) != null)
            {
                replaceClothingOnPart(loc7, loc8, arg3, arg5);
                return true;
            }
            return false;
        }

        public function tintSkin(arg1:flash.display.MovieClip):void
        {
            var loc2:*;
            var loc3:*;

            if (arg1 == null)
            {
                return;
            }
            if (isNaN(skinFillColor))
            {
                skinFillColor = 16768169;
            }
            if (isNaN(skinOutlineColor))
            {
                skinOutlineColor = 8086080;
            }
            loc2 = (skinChangeItemId == -1) ? skinFillColor : tempSkinFillColor;
            loc3 = (skinChangeItemId == -1) ? skinOutlineColor : tempSkinOutlineColor;
            colorClip(arg1.chest.skin, loc2, loc3);
            colorClip(arg1.rightUpperArm.skin, loc2, loc3);
            colorClip(arg1.rightForeArm.skin, loc2, loc3);
            colorClip(arg1.rightHand.skin, loc2, loc3);
            colorClip(arg1.leftUpperArm.skin, loc2, loc3);
            colorClip(arg1.leftForeArm.skin, loc2, loc3);
            colorClip(arg1.leftHand.skin, loc2, loc3);
            colorClip(arg1.pelvis.skin, loc2, loc3);
            colorClip(arg1.rightThigh.skin, loc2, loc3);
            colorClip(arg1.rightCalf.skin, loc2, loc3);
            colorClip(arg1.rightFoot.skin, loc2, loc3);
            colorClip(arg1.leftThigh.skin, loc2, loc3);
            colorClip(arg1.leftCalf.skin, loc2, loc3);
            colorClip(arg1.leftFoot.skin, loc2, loc3);
            if (arg1.head.leftEar.numChildren > 0 && !(arg1.head.leftEar.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.leftEar.getChildAt(0).skin, loc2, loc3);
            }
            if (arg1.head.rightEar.numChildren > 0 && !(arg1.head.rightEar.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.rightEar.getChildAt(0).skin, loc2, loc3);
            }
            if (arg1.head.face.numChildren > 0 && !(arg1.head.face.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.face.getChildAt(0).skin, loc2, loc3);
            }
            if (!(arg1.head.eyes == null) && arg1.head.eyes.numChildren > 0 && !(arg1.head.eyes.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.eyes.getChildAt(0).skin, loc2, loc3);
            }
            if (!(arg1.head.mouth == null) && arg1.head.mouth.numChildren > 0 && !(arg1.head.mouth.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.mouth.getChildAt(0).skin, loc2, loc3);
            }
            if (!(arg1.head.nose == null) && arg1.head.nose.numChildren > 0 && !(arg1.head.nose.getChildAt(0).skin == null))
            {
                colorClip(arg1.head.nose.getChildAt(0).skin, loc2, loc3);
            }
            return;
        }

        private function completeRendering():void
        {
            replaceMissingRequiredClothes();
            tintSkin(avatar.avatarFrontClip);
            tintSkin(avatar.avatarBackClip);
            return;
        }

        private function convertMetaDataStringToObject(arg1:String):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = null;
            loc2 = new Object();
            if (arg1 == null || arg1 == "")
            {
                return loc2;
            }
            loc3 = arg1.split("|");
            loc4 = 0;
            while (loc4 < loc3.length) 
            {
                if ((loc5 = loc3[loc4].split(":")).length == 2)
                {
                    loc2[loc5[0]] = loc5[1];
                }
                loc4 = (loc4 + 1);
            }
            return loc2;
        }

        public function removeClothingItem(arg1:Number):*
        {
            var loc2:*;
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
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = false;
            loc2 = clothingList[arg1];
            if (loc2 == null)
            {
                return;
            }
            loc3 = {};
            loc4 = 0;
            while (loc4 < loc2.length) 
            {
                loc5 = loc2[loc4];
                loc7 = (loc6 = splitClassNameIntoPartNameAndDirection(loc5.className))[0];
                loc9 = ((loc8 = loc6[1]) != "Front") ? avatar.avatarBackClip : avatar.avatarFrontClip;
                loc10 = getContainerClip(loc5.containerClip, loc9);
                loc11 = false;
                if (!(loc10 == null) && loc10.itemId == arg1)
                {
                    loc10.itemId = 0;
                    DisplayObjectContainerUtils.removeChildren(loc10);
                    loc11 = true;
                }
                if (loc11)
                {
                    if (loc3[loc7] == null)
                    {
                        setCategoryIDMapping(loc7, null);
                        delete renderedPartList[loc5.partName];
                        if (arg1 == skinChangeItemId)
                        {
                            skinChangeItemId = -1;
                            tempSkinFillColor = -1;
                            tempSkinOutlineColor = -1;
                        }
                        loc3[loc7] = loc7;
                    }
                }
                loc4 = (loc4 + 1);
            }
            delete clothingList[arg1];
            return;
        }

        public function renderClothes(arg1:Object=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            if (arg1 == null)
            {
                arg1 = MyLifeUtils.cloneObject(this.categoryToIDMapping);
            }
            clearAllClothes(avatar.avatarFrontClip);
            clearAllClothes(avatar.avatarBackClip);
            skinChangeItemId = -1;
            tempSkinFillColor = -1;
            tempSkinOutlineColor = -1;
            loc4 = 0;
            loc5 = arg1;
            for (loc2 in loc5)
            {
                loc3 = arg1[loc2];
                if (loc3 == null)
                {
                    continue;
                }
                addClothingItem(loc3, false);
            }
            completeRendering();
            return;
        }

        private function colorClip(arg1:flash.display.Sprite, arg2:Number=NaN, arg3:Number=NaN):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            if (arg1 == null)
            {
                return;
            }
            loc5 = ((loc4 = arg1.getChildByName("color")) != null) ? loc4 as Sprite : arg1;
            if ((loc6 = getColorTransform(arg2, arg3)) != null)
            {
                loc5.transform.colorTransform = loc6;
            }
            return;
        }

        private function getPartList(arg1:Object):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
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

            loc5 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            loc13 = null;
            loc14 = null;
            loc2 = arg1.itemId;
            loc3 = (arg1.metaData != null) ? arg1.metaData : arg1.meta_data;
            loc4 = convertMetaDataStringToObject(loc3);
            if (loc2 < 0)
            {
                loc8 = defaultParts[(-loc2)];
                loc5 = MyLifeUtils.cloneObject(defaultClothing[loc8].parts);
            }
            else 
            {
                loc5 = MyLifeUtils.cloneObject(MyLifeInstance.getInstance().assetsLoader.getClothingPartList(loc2));
            }
            if (loc5 == null)
            {
                return null;
            }
            loc6 = {};
            loc7 = 0;
            while (loc7 < loc5.length) 
            {
                loc10 = (loc9 = splitClassNameIntoPartNameAndDirection(loc5[loc7].className))[0];
                loc12 = ((loc11 = loc9[1]) != "Front") ? avatar.avatarBackClip : avatar.avatarFrontClip;
                loc13 = getContainerClip(loc5[loc7].containerClip, loc12);
                if ((loc14 = getClothingClip(loc2, loc11, loc10)) == null)
                {
                    loc5.splice(loc7, 1);
                    loc7 = (loc7 - 1);
                }
                else 
                {
                    if (loc6[loc10] == null)
                    {
                        loc6[loc10] = loc10;
                        if (renderedPartList[loc10] != null)
                        {
                            removeClothingItem(renderedPartList[loc10]);
                        }
                        if (loc10 == "ChestShirt")
                        {
                            isWearingSwimsuitTop = arg1.categoryId == 2020;
                        }
                        if (loc10 == "PelvisPants")
                        {
                            isWearingSwimsuitBottom = arg1.categoryId == 2020;
                        }
                        setCategoryIDMapping(loc10, arg1);
                        renderedPartList[loc10] = loc2;
                    }
                    if (loc13 != null)
                    {
                        replaceClothingOnPart(loc13, loc14, loc2, loc4);
                    }
                }
                loc7 = (loc7 + 1);
            }
            return loc5;
        }

        private function convertLabelToSaveReadyLabel(arg1:String):String
        {
            var loc2:*;

            loc2 = null;
            if (arg1 == "PelvisPants" || arg1 == "Pants" || arg1 == "Dresses" || arg1 == "Skirts" || arg1 == "Costumes")
            {
                loc2 = "pants";
            }
            else 
            {
                if (arg1 == "ChestShirt" || arg1 == "Shirts")
                {
                    loc2 = "shirt";
                }
                else 
                {
                    if (arg1 == "ChestJacket" || arg1 == "Jackets")
                    {
                        loc2 = "jacket";
                    }
                    else 
                    {
                        if (arg1 != "Eyes")
                        {
                            if (arg1 != "EyeBrows")
                            {
                                if (arg1 != "Mouth")
                                {
                                    if (arg1 == "FacialHair" || arg1 == "Facial Hair")
                                    {
                                        loc2 = "facialhair";
                                    }
                                    else 
                                    {
                                        if (arg1 != "Nose")
                                        {
                                            if (arg1 != "Hair")
                                            {
                                                if (arg1 != "Glasses")
                                                {
                                                    if (arg1 == "Hat" || arg1 == "Hats")
                                                    {
                                                        loc2 = "hat";
                                                    }
                                                    else 
                                                    {
                                                        if (arg1 != "LeftEar")
                                                        {
                                                            if (arg1 != "Face")
                                                            {
                                                                if (arg1 == "LeftFootShoe" || arg1 == "Shoes" || arg1 == "RightFootShoe")
                                                                {
                                                                    loc2 = "shoes";
                                                                }
                                                                else 
                                                                {
                                                                    if (arg1 == "Necklace" || arg1 == "ChestNecklace")
                                                                    {
                                                                        loc2 = "necklace";
                                                                    }
                                                                    else 
                                                                    {
                                                                        if (arg1 == "RightHandItem" || arg1 == "Purse" || arg1 == "LeftHandItem")
                                                                        {
                                                                            loc2 = "purse";
                                                                        }
                                                                        else 
                                                                        {
                                                                            if (arg1 != "Makeup")
                                                                            {
                                                                                if (arg1 == "Gloves" || arg1 == "LeftHandGlove" || arg1 == "RightHandGlove")
                                                                                {
                                                                                    loc2 = "gloves";
                                                                                }
                                                                                else 
                                                                                {
                                                                                    if (arg1 == "Rings" || "LeftHandRing" || arg1 == "RightHandRing")
                                                                                    {
                                                                                        loc2 = "ring";
                                                                                    }
                                                                                    else 
                                                                                    {
                                                                                        if (arg1 != "LeftForeArmBracelet")
                                                                                        {
                                                                                            if (arg1 != "RightForeArmBracelet")
                                                                                            {
                                                                                                if (arg1 == "Scarf" || arg1 == "ChestScarf")
                                                                                                {
                                                                                                    loc2 = "scarf";
                                                                                                }
                                                                                            }
                                                                                            else 
                                                                                            {
                                                                                                loc2 = "bracelet";
                                                                                            }
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            loc2 = "bracelet";
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            else 
                                                                            {
                                                                                loc2 = "makeup";
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            else 
                                                            {
                                                                loc2 = "face";
                                                            }
                                                        }
                                                        else 
                                                        {
                                                            loc2 = "ears";
                                                        }
                                                    }
                                                }
                                                else 
                                                {
                                                    loc2 = "glasses";
                                                }
                                            }
                                            else 
                                            {
                                                loc2 = "hair";
                                            }
                                        }
                                        else 
                                        {
                                            loc2 = "nose";
                                        }
                                    }
                                }
                                else 
                                {
                                    loc2 = "mouth";
                                }
                            }
                            else 
                            {
                                loc2 = "eyebrows";
                            }
                        }
                        else 
                        {
                            loc2 = "eyes";
                        }
                    }
                }
            }
            return loc2;
        }

        public function getFormattedClothingList():Object
        {
            return this.categoryToIDMapping;
        }

        private function getClothingClip(arg1:Number, arg2:String, arg3:String):flash.display.Sprite
        {
            var className:String;
            var clothingClass:Class;
            var clothingClip:flash.display.Sprite;
            var direction:String;
            var genderString:String;
            var id:Number;
            var loc4:*;
            var loc5:*;
            var name:String;
            var partName:String;

            clothingClip = null;
            genderString = null;
            className = null;
            clothingClass = null;
            name = null;
            id = arg1;
            direction = arg2;
            partName = arg3;
            if (id < 0)
            {
                try
                {
                    genderString = "";
                    if (partName == "ChestShirt" || partName == "Eyes" || partName == "Mouth" || partName == "Nose" || partName == "EyeBrows")
                    {
                        genderString = (this.avatar.getGender() != 1) ? "Male" : "Female";
                    }
                    className = genderString + partName + direction;
                    clothingClass = Avatar[className];
                    clothingClip = new clothingClass() as Sprite;
                }
                catch (error:Error)
                {
                    clothingClip = null;
                }
            }
            else 
            {
                name = partName + direction;
                clothingClip = MyLifeInstance.getInstance().assetsLoader.getAssetInstanceByItemId(id, name, null, true);
            }
            return clothingClip;
        }

        private function replaceClothingOnPart(arg1:flash.display.MovieClip, arg2:flash.display.Sprite, arg3:Number, arg4:Object=null):*
        {
            var loc5:*;
            var loc6:*;

            loc5 = NaN;
            loc6 = NaN;
            if (arg1 == null)
            {
                return;
            }
            if (arg1.numChildren > 0)
            {
                DisplayObjectContainerUtils.removeChildren(arg1);
            }
            if (arg2 != null)
            {
                arg1.itemId = arg3;
                if (arg4.Fill != null)
                {
                    loc5 = Number("0x" + arg4.Fill);
                    loc6 = Number("0x" + arg4.Outline);
                    colorClip(arg2, loc5, loc6);
                }
                arg1.addChild(arg2);
                arg1.parent.cacheAsBitmap = true;
            }
            else 
            {
                arg1.itemId = 0;
            }
            return;
        }

        private function replaceMissingRequiredClothes():void
        {
            var loc1:*;

            loc1 = 1;
            while (loc1 < defaultParts.length) 
            {
                renderDefaultClothing(defaultParts[loc1], true);
                loc1 = (loc1 + 1);
            }
            return;
        }

        private function splitClassNameIntoPartNameAndDirection(arg1:String):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = null;
            loc4 = null;
            loc2 = arg1.lastIndexOf("Front");
            if (loc2 != -1)
            {
                loc3 = "Front";
            }
            else 
            {
                loc2 = arg1.lastIndexOf("Back");
                if (loc2 != -1)
                {
                    loc3 = "Back";
                }
            }
            if (loc3 == null)
            {
                loc4 = arg1;
            }
            else 
            {
                loc4 = arg1.substring(0, loc2);
            }
            return [loc4, loc3];
        }

        private function getColorTransform(arg1:Number=NaN, arg2:Number=NaN):flash.geom.ColorTransform
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
            var loc12:*;
            var loc13:*;
            var loc14:*;

            loc3 = NaN;
            loc4 = NaN;
            loc5 = NaN;
            loc6 = NaN;
            loc7 = NaN;
            loc8 = NaN;
            loc9 = NaN;
            loc10 = NaN;
            loc11 = NaN;
            loc12 = NaN;
            loc13 = NaN;
            loc14 = NaN;
            if (!isNaN(arg1) && isNaN(arg2))
            {
                loc3 = ((arg1 & 16711680) >> 16) / 255;
                loc4 = ((arg1 & 65280) >> 8) / 255;
                loc5 = (arg1 & 255) / 255;
                return new ColorTransform(loc3, loc4, loc5, 1, 0, (0), (0));
            }
            if (!isNaN(arg1) && !isNaN(arg2))
            {
                loc6 = (arg1 & 16711680) >> 16;
                loc7 = (arg1 & 65280) >> 8;
                loc8 = arg1 & 255;
                loc9 = (arg2 & 16711680) >> 16;
                loc10 = (arg2 & 65280) >> 8;
                loc11 = arg2 & 255;
                loc12 = (loc6 - loc9) / 255;
                loc13 = (loc7 - loc10) / 255;
                loc14 = (loc8 - loc11) / 255;
                return new ColorTransform(loc12, loc13, loc14, 1, loc9, loc10, loc11, 0);
            }
            return null;
        }

        private static function setAllPartsList():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = new Array();
            loc2 = new Array();
            loc3 = new Array();
            loc4 = new Array();
            loc5 = new Array();
            defaultClothing = new Object();
            loc2.push({"className":"LeftThighPantsFront", "containerClip":"leftThigh.clothing"});
            loc2.push({"className":"LeftThighPantsBack", "containerClip":"leftThigh.clothing"});
            loc2.push({"className":"RightThighPantsFront", "containerClip":"rightThigh.clothing"});
            loc2.push({"className":"RightThighPantsBack", "containerClip":"rightThigh.clothing"});
            loc2.push({"className":"PelvisPantsFront", "containerClip":"pelvis.clothing"});
            loc2.push({"className":"PelvisPantsBack", "containerClip":"pelvis.clothing"});
            defaultClothing["pants"] = {"itemId":-1, "parts":loc2};
            loc1.push({"className":"ChestShirtFront", "containerClip":"chest.clothing"});
            loc1.push({"className":"ChestShirtBack", "containerClip":"chest.clothing"});
            defaultClothing["shirt"] = {"itemId":-2, "parts":loc1};
            loc5.push({"className":"HairFront", "containerClip":"head.hair"});
            loc5.push({"className":"HairBack", "containerClip":"head.hair"});
            defaultClothing["hair"] = {"itemId":-9, "parts":loc5};
            defaultClothing["eyes"] = {"itemId":-3, "parts":[{"className":"EyesFront", "containerClip":"head.eyes"}]};
            defaultClothing["eyebrows"] = {"itemId":-4, "parts":[{"className":"EyeBrowsFront", "containerClip":"head.eyebrows"}]};
            defaultClothing["mouth"] = {"itemId":-5, "parts":[{"className":"MouthFront", "containerClip":"head.mouth"}]};
            defaultClothing["nose"] = {"itemId":-6, "parts":[{"className":"NoseFront", "containerClip":"head.nose"}]};
            loc3.push({"className":"LeftEarFront", "containerClip":"head.leftEar"});
            loc3.push({"className":"LeftEarBack", "containerClip":"head.leftEar"});
            loc3.push({"className":"RightEarFront", "containerClip":"head.rightEar"});
            loc3.push({"className":"RightEarBack", "containerClip":"head.rightEar"});
            defaultClothing["ears"] = {"itemId":-7, "parts":loc3};
            loc4.push({"className":"FaceFront", "containerClip":"head.face"});
            loc4.push({"className":"FaceBack", "containerClip":"head.face"});
            defaultClothing["face"] = {"itemId":-8, "parts":loc4};
            return;
        }

        
        {
            defaultParts = ["", "pants", "shirt", "eyes", "eyebrows", "mouth", "nose", "ears", "face", "hair"];
        }

        private var isWearingSwimsuitTop:Boolean;

        private var renderedPartList:Object;

        private var tempSkinOutlineColor:Number=-1;

        private var clothingList:Object;

        private var avatar:MyLife.Assets.Avatar.Avatar;

        private var skinFillColor:Number;

        private var skinOutlineColor:Number;

        private var tempSkinFillColor:Number=-1;

        private var isWearingSwimsuitBottom:Boolean;

        private var categoryToIDMapping:Object;

        private var skinChangeItemId:Number=-1;

        private static var defaultClothing:Object;

        private static var defaultParts:Array;
    }
}
