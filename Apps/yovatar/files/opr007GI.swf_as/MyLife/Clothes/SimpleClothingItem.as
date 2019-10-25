package MyLife.Clothes 
{
    import flash.display.*;
    import flash.utils.*;
    
    public class SimpleClothingItem extends flash.display.MovieClip
    {
        public function SimpleClothingItem()
        {
            super();
            return;
        }

        public function getItemData():Object
        {
            var assetClass:Class;
            var className:String;
            var fileName:String;
            var i:int;
            var itemData:Object;
            var lastSlashIndex:Number;
            var loc1:*;
            var loc2:*;
            var startIndex:Number;
            var supportedViews:Array;
            var url:String;

            className = null;
            assetClass = null;
            supportedViews = new Array();
            url = this.root.loaderInfo.url;
            lastSlashIndex = url.lastIndexOf("/");
            startIndex = (lastSlashIndex != -1) ? lastSlashIndex + 1 : 0;
            fileName = url.substring(startIndex, url.indexOf(".swf"));
            i = 0;
            while (i < ALL_VIEWS.length) 
            {
                className = "MyLife.Assets." + fileName + "." + ALL_VIEWS[i].className;
                try
                {
                    assetClass = getDefinitionByName(className) as Class;
                }
                catch (error:Error)
                {
                    assetClass = null;
                }
                if (assetClass)
                {
                    supportedViews.push(ALL_VIEWS[i]);
                }
                i = (i + 1);
            }
            itemData = {};
            itemData.supportedViews = supportedViews;
            itemData.isInactive = !Boolean(supportedViews.length);
            return itemData;
        }

        public static const ALL_VIEWS:Array=[{"className":"LeftThighPantsFront", "containerClip":"leftThigh.clothing"}, {"className":"LeftThighPantsBack", "containerClip":"leftThigh.clothing"}, {"className":"RightThighPantsFront", "containerClip":"rightThigh.clothing"}, {"className":"RightThighPantsBack", "containerClip":"rightThigh.clothing"}, {"className":"LeftCalfPantsFront", "containerClip":"leftCalf.clothing"}, {"className":"LeftCalfPantsBack", "containerClip":"leftCalf.clothing"}, {"className":"RightCalfPantsFront", "containerClip":"rightCalf.clothing"}, {"className":"RightCalfPantsBack", "containerClip":"rightCalf.clothing"}, {"className":"LeftUpperArmShirtFront", "containerClip":"leftUpperArm.clothing"}, {"className":"LeftUpperArmShirtBack", "containerClip":"leftUpperArm.clothing"}, {"className":"RightUpperArmShirtFront", "containerClip":"rightUpperArm.clothing"}, {"className":"RightUpperArmShirtBack", "containerClip":"rightUpperArm.clothing"}, {"className":"LeftForeArmShirtFront", "containerClip":"leftForeArm.clothing"}, {"className":"LeftForeArmShirtBack", "containerClip":"leftForeArm.clothing"}, {"className":"RightForeArmShirtFront", "containerClip":"rightForeArm.clothing"}, {"className":"RightForeArmShirtBack", "containerClip":"rightForeArm.clothing"}, {"className":"LeftUpperArmJacketFront", "containerClip":"leftUpperArm.jacket"}, {"className":"LeftUpperArmJacketBack", "containerClip":"leftUpperArm.jacket"}, {"className":"RightUpperArmJacketFront", "containerClip":"rightUpperArm.jacket"}, {"className":"RightUpperArmJacketBack", "containerClip":"rightUpperArm.jacket"}, {"className":"LeftForeArmJacketFront", "containerClip":"leftForeArm.jacket"}, {"className":"LeftForeArmJacketBack", "containerClip":"leftForeArm.jacket"}, {"className":"RightForeArmJacketFront", "containerClip":"rightForeArm.jacket"}, {"className":"RightForeArmJacketBack", "containerClip":"rightForeArm.jacket"}, {"className":"ChestShirtFront", "containerClip":"chest.clothing"}, {"className":"ChestShirtBack", "containerClip":"chest.clothing"}, {"className":"ChestJacketFront", "containerClip":"chest.jacket"}, {"className":"ChestJacketBack", "containerClip":"chest.jacket"}, {"className":"PelvisPantsFront", "containerClip":"pelvis.clothing"}, {"className":"PelvisPantsBack", "containerClip":"pelvis.clothing"}, {"className":"DressThighDressFront", "containerClip":"dressThigh.clothing"}, {"className":"DressThighDressBack", "containerClip":"dressThigh.clothing"}, {"className":"DressCalfDressFront", "containerClip":"dressCalf.clothing"}, {"className":"DressCalfDressBack", "containerClip":"dressCalf.clothing"}, {"className":"HairFront", "containerClip":"head.hair"}, {"className":"HairBack", "containerClip":"head.hair"}, {"className":"HairBackFront", "containerClip":"hairBack.hair"}, {"className":"LeftFootShoeFront", "containerClip":"leftFoot.clothing"}, {"className":"LeftFootShoeBack", "containerClip":"leftFoot.clothing"}, {"className":"RightFootShoeFront", "containerClip":"rightFoot.clothing"}, {"className":"RightFootShoeBack", "containerClip":"rightFoot.clothing"}, {"className":"LeftCalfShoeFront", "containerClip":"leftCalf.shoe"}, {"className":"LeftCalfShoeBack", "containerClip":"leftCalf.shoe"}, {"className":"RightCalfShoeFront", "containerClip":"rightCalf.shoe"}, {"className":"RightCalfShoeBack", "containerClip":"rightCalf.shoe"}, {"className":"LeftThighShoeFront", "containerClip":"leftThigh.shoe"}, {"className":"LeftThighShoeBack", "containerClip":"leftThigh.shoe"}, {"className":"RightThighShoeFront", "containerClip":"rightThigh.shoe"}, {"className":"RightThighShoeBack", "containerClip":"rightThigh.shoe"}, {"className":"LeftEarFront", "containerClip":"head.leftEar"}, {"className":"LeftEarBack", "containerClip":"head.leftEar"}, {"className":"RightEarFront", "containerClip":"head.rightEar"}, {"className":"RightEarBack", "containerClip":"head.rightEar"}, {"className":"LeftEarringFront", "containerClip":"head.leftEarring"}, {"className":"LeftEarringBack", "containerClip":"head.leftEarring"}, {"className":"RightEarringFront", "containerClip":"head.rightEarring"}, {"className":"RightEarringBack", "containerClip":"head.rightEarring"}, {"className":"LeftHandItemFront", "containerClip":"leftHand.item"}, {"className":"LeftHandItemBack", "containerClip":"leftHand.item"}, {"className":"RightHandItemFront", "containerClip":"rightHand.item"}, {"className":"RightHandItemBack", "containerClip":"rightHand.item"}, {"className":"LeftHandGloveFront", "containerClip":"leftHand.glove"}, {"className":"LeftHandGloveBack", "containerClip":"leftHand.glove"}, {"className":"RightHandGloveFront", "containerClip":"rightHand.glove"}, {"className":"RightHandGloveBack", "containerClip":"rightHand.glove"}, {"className":"LeftHandBraceletFront", "containerClip":"leftHand.bracelet"}, {"className":"LeftHandBraceletBack", "containerClip":"leftHand.bracelet"}, {"className":"RightHandBraceletFront", "containerClip":"rightHand.bracelet"}, {"className":"RightHandBraceletBack", "containerClip":"rightHand.bracelet"}, {"className":"LeftHandRingFront", "containerClip":"leftHand.ring"}, {"className":"LeftHandRingBack", "containerClip":"leftHand.ring"}, {"className":"RightHandRingFront", "containerClip":"rightHand.ring"}, {"className":"RightHandRingBack", "containerClip":"rightHand.ring"}, {"className":"EyesFront", "containerClip":"head.eyes"}, {"className":"EyeBrowsFront", "containerClip":"head.eyebrows"}, {"className":"NoseFront", "containerClip":"head.nose"}, {"className":"MouthFront", "containerClip":"head.mouth"}, {"className":"FacialHairFront", "containerClip":"head.facialHair"}, {"className":"GlassesFront", "containerClip":"head.glasses"}, {"className":"HatFront", "containerClip":"head.hat"}, {"className":"HatBack", "containerClip":"head.hat"}, {"className":"MakeupFront", "containerClip":"head.makeup"}, {"className":"FaceFront", "containerClip":"head.face"}, {"className":"FaceBack", "containerClip":"head.face"}, {"className":"ChestScarfFront", "containerClip":"chest.scarf"}, {"className":"ChestScarfBack", "containerClip":"chest.scarf"}, {"className":"ChestNecklaceFront", "containerClip":"chest.necklace"}, {"className":"ChestNecklaceBack", "containerClip":"chest.necklace"}, {"className":"CapeBackFront", "containerClip":"capeBack.cape"}, {"className":"CapeBackBack", "containerClip":"capeBack.cape"}, {"className":"CapeFront", "containerClip":"chest.cape"}];
    }
}
