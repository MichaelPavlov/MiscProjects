package com.UI {
	import com.data.CustomLoader;
	import com.data.DataHolder;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author ...
	 */
	
	[Event("allPartsLoaded", type = "flash.events.Event")]
	[Event("startPreload", type = "flash.events.Event")]
	
	public class Avatar extends Sprite {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public var head:DisplayObject;
		public var rightForeArm:DisplayObject;
		public var rightUpperArm:DisplayObject;
		public var rightHand:DisplayObject;
		public var chest:DisplayObject;
		public var pelvis:DisplayObject;
		public var rightFoot:DisplayObject;
		public var rightThigh:DisplayObject;
		public var rightCalf:DisplayObject;
		public var leftFoot:DisplayObject;
		public var leftThigh:DisplayObject;
		public var leftCalf:DisplayObject;
		public var leftForeArm:DisplayObject;
		public var leftUpperArm:DisplayObject;
		public var leftHand:DisplayObject;
		public var capeBack:DisplayObject;
		public var hairBack:DisplayObject;
		public var dressCalf:DisplayObject;
		public var dressThigh:DisplayObject;		
		public var avatarPreview:DisplayObject;
		private var avatarClip:MovieClip;
		
		private var allParts:Array;		
		
		
		private var skinFillColor:Number;
		private var skinOutlineColor:Number;
		
		private var defaultParts:Array = ["pants", "shirt", "eyes", "eyebrows", "mouth", "nose", "ears", "face", "hair"];
		private var itemsToPutOn:Object = new Object();
		private var putedOnItems:Object = new Object();
		private var itemsToPutOff:Object = new Object();
		private var loadedItems:int = 0;
		private var itemsToLoad:int = 0;
		private var defaultClothing:Object;
		private var dress:Boolean = false;
		
		private var sessId:Number;
		
		//private var timer:Timer = new Timer(15000);
		private var preloaderTimeoutId:uint;
		
		
		
		
		public function Avatar() {			
			avatarClip = avatarPreview as MovieClip;			
		}
		
		public function init():void {
			this.setAllPartsList();			
			this.updateGenderView();
			this.loadDefaultItems();			
			this.update();
		}
		
		private function update():void {
			this.checkMissingRequiredClothes();
			this.renderAvatar();
		}
		
		private function updateGenderView():void {
			avatarClip.chest.skin.gotoAndStop(dataHolder.gender);
			avatarClip.leftUpperArm.skin.gotoAndStop(dataHolder.gender);
			avatarClip.rightUpperArm.skin.gotoAndStop(dataHolder.gender);
			avatarClip.leftForeArm.skin.gotoAndStop(dataHolder.gender);
			avatarClip.rightForeArm.skin.gotoAndStop(dataHolder.gender);
		}
		
		private function loadDefaultItems():void {
			var partName:String;
			/*for (var partName:String in defaultClothing) {
				putedOnItems[partName] = defaultClothing[partName];
			}*/
			itemsToPutOn = new Object();
			for (var i:int = 0; i < dataHolder.avatarDefaultAssets.length; i++) {
				if (dataHolder.avatarDefaultAssets[i] == "" || dataHolder.avatarDefaultAssets[i] == null) {
					continue;
				}
				if (dataHolder.avatarDefaultAssets[i].categoryId == 1000) {
					this.loadSkinColors(dataHolder.avatarDefaultAssets[i]);
				} else {
					partName = this.convertLabelToSaveReadyLabel(dataHolder.avatarDefaultAssets[i].category);
					itemsToPutOn[partName] = dataHolder.avatarDefaultAssets[i];
				}
				
				
				
			}
		}
		
		private function loadSkinColors($dataObject:Object):void {
			var colors:Object = convertMetaDataStringToObject($dataObject.metaData);
			skinFillColor = Number("0x" + colors.Fill);
			skinOutlineColor = Number("0x" + colors.Outline);
		}
		
		public function addItem($dataObject:Object):void {
			trace ("ADD ITEM");
			itemsToPutOn = new Object();
			
			if ($dataObject.categoryId == 1000) {
				this.loadSkinColors($dataObject);
				this.tintSkin();
				return;
			}
			
			var partName:String;
			partName = this.convertLabelToSaveReadyLabel($dataObject.category);
			
			itemsToPutOn[partName] = $dataObject;
			
			
			
			if (dress && partName == "shirt") {
				itemsToPutOn["pants"] = defaultClothing["pants"];
				dress = false;
				this.putOffItem(putedOnItems["pants"]);
				putedOnItems["pants"].putedOnParts = null;
			} else if (dress && partName == "pants") {
				itemsToPutOn["shirt"] = defaultClothing["shirt"];
				dress = false;
				this.putOffItem(putedOnItems["pants"]);
				putedOnItems["pants"].putedOnParts = null;
			} 
			if ($dataObject.name == "None") {
				//trace("NONE");
				if (dress) {
					itemsToPutOn["pants"] = defaultClothing["pants"];
					itemsToPutOn["shirt"] = defaultClothing["shirt"];
					dress = false;
				}				
			}
			
			
			
			this.checkMissingRequiredClothes();			
			
			this.putOnClothes();
			
		}
		
		private function putOffItem($dataObject:Object):void {			
			if (!$dataObject || !$dataObject.putedOnParts) {
				return;			
			} else {
				var containerClip:MovieClip;			
				for (var i:int = 0; i < $dataObject.putedOnParts.length; i++) {
					containerClip = $dataObject.putedOnParts[i];
					while (containerClip.numChildren) containerClip.removeChildAt(0);
				}
			}
		}
		
		private function renderAvatar():void {
			this.clearAllClothes();
			this.putOnClothes();
			
			/*for (var partName:String in itemsToPutOn) {
				if (itemsToPutOn[partName].category != "Dresses") {
					itemsToLoad++;
				}
				this.loadAsset(itemsToPutOn[partName]);				
			}*/
			
		}
		
		private function putOnClothes():void {
			itemsToLoad = 0;
			loadedItems = 0;
			var $sessId:Number = Math.random();
			this.sessId = $sessId;
			
			trace ("");
			trace ("____________________________________");
			trace ("____________________________________");
			
			
			
			for (var partName:String in itemsToPutOn) {
				itemsToPutOn[partName].sessId = $sessId;
				trace (itemsToLoad + "   " + loadedItems + "   " + itemsToPutOn[partName].category);
				if (itemsToPutOn[partName].categoryId == 1000) {
					this.loadSkinColors(itemsToPutOn[partName]);
					this.tintSkin();
					continue;
				}
				if (itemsToPutOn[partName].asset) {
					this.putOnItem(itemsToPutOn[partName]);					
				} else {
					this.loadAsset(itemsToPutOn[partName]);	
				}
				itemsToLoad++;
			}
			trace ("____________________________________");
			if (itemsToLoad > 2) {				
				this.alpha = 0;
				preloaderTimeoutId = setTimeout(this.loadRandomItems, DataHolder.PRELOADER_TIMEOUT);
				this.dispatchEvent(new Event("startPreload"));
			}
		}
		
		public function tintSkin():void {
			//trace ("TINT SKIN");
            var fillColor:Number;
            var outlineColor:Number;
            if (avatarClip == null) {
                return;
            }
            if (isNaN(skinFillColor)) {
                skinFillColor = 16768169;
            }
            if (isNaN(skinOutlineColor)) {
                skinOutlineColor = 8086080;
            }
            //fillColor = (skinChangeItemId == -1) ? skinFillColor : tempSkinFillColor;
            //outlineColor = (skinChangeItemId == -1) ? skinOutlineColor : tempSkinOutlineColor;
            colorClip(avatarClip.chest.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightUpperArm.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightForeArm.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightHand.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftUpperArm.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftForeArm.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftHand.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.pelvis.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightThigh.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightCalf.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.rightFoot.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftThigh.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftCalf.skin, skinFillColor, skinOutlineColor);
            colorClip(avatarClip.leftFoot.skin, skinFillColor, skinOutlineColor);
            if (avatarClip.head.leftEar.numChildren > 0 && !(avatarClip.head.leftEar.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.leftEar.getChildAt(0).skin, skinFillColor, skinOutlineColor);
            }
            if (avatarClip.head.rightEar.numChildren > 0 && !(avatarClip.head.rightEar.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.rightEar.getChildAt(0).skin, skinFillColor, skinOutlineColor);
            }
            if (avatarClip.head.face.numChildren > 0 && !(avatarClip.head.face.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.face.getChildAt(0).skin, skinFillColor, skinOutlineColor);
				//trace (avatarClip.head.face.getChildAt(0).skin);
            }
            if (!(avatarClip.head.eyes == null) && avatarClip.head.eyes.numChildren > 0 && !(avatarClip.head.eyes.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.eyes.getChildAt(0).skin, skinFillColor, skinOutlineColor);
            }
            if (!(avatarClip.head.mouth == null) && avatarClip.head.mouth.numChildren > 0 && !(avatarClip.head.mouth.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.mouth.getChildAt(0).skin, skinFillColor, skinOutlineColor);
            }
            if (!(avatarClip.head.nose == null) && avatarClip.head.nose.numChildren > 0 && !(avatarClip.head.nose.getChildAt(0).skin == null)) {
                colorClip(avatarClip.head.nose.getChildAt(0).skin, skinFillColor, skinOutlineColor);
            }
            return;
        }
		
		private function setAllPartsList():void {
            var aChest:Array = aChest = new Array();
            var aPants:Array = aPants = new Array();
            var aEar:Array = aEar = new Array();
            var aFace:Array = aFace = new Array();
            var aHair:Array = aHair = new Array();
			
			allParts = new Array();
			allParts.push( { "partName":"LeftThighPants", "containerClip":"leftThigh.clothing" } );
            allParts.push( { "partName":"RightThighPants", "containerClip":"rightThigh.clothing" } );
            allParts.push( { "partName":"RightCalfPants", "containerClip":"rightCalf.clothing" } );
            allParts.push( { "partName":"LeftCalfPants", "containerClip":"leftCalf.clothing" } );
            allParts.push( { "partName":"PelvisPants", "containerClip":"pelvis.clothing" } );
            allParts.push( { "partName":"LeftUpperArmShirt", "containerClip":"leftUpperArm.clothing" } );
            allParts.push( { "partName":"RightUpperArmShirt", "containerClip":"rightUpperArm.clothing" } );
            allParts.push( { "partName":"RightForeArmShirt", "containerClip":"rightForeArm.clothing" } );
            allParts.push( { "partName":"LeftForeArmShirt", "containerClip":"leftForeArm.clothing" } );
            allParts.push( { "partName":"ChestShirt", "containerClip":"chest.clothing" } );
            allParts.push( { "partName":"LeftUpperArmJacket", "containerClip":"leftUpperArm.jacket" } );
            allParts.push( { "partName":"RightUpperArmJacket", "containerClip":"rightUpperArm.jacket" } );
            allParts.push( { "partName":"RightForeArmJacket", "containerClip":"rightForeArm.jacket" } );
            allParts.push( { "partName":"LeftForeArmJacket", "containerClip":"leftForeArm.jacket" } );
            allParts.push( { "partName":"ChestJacket", "containerClip":"chest.jacket" } );
            allParts.push( { "partName":"DressThighDress", "containerClip":"dressThigh.clothing" } );
            allParts.push( { "partName":"DressCalfDress", "containerClip":"dressCalf.clothing" } );
            allParts.push( { "partName":"Hair", "containerClip":"head.hair" } );
            allParts.push( { "partName":"HairBack", "containerClip":"hairBack" } );           
            allParts.push( { "partName":"LeftFootShoe", "containerClip":"leftFoot.clothing" } );
            allParts.push( { "partName":"RightFootShoe", "containerClip":"rightFoot.clothing" } );
            allParts.push( { "partName":"Eyes", "containerClip":"head.eyes" } );
            allParts.push( { "partName":"EyeBrows", "containerClip":"head.eyebrows" } );
            allParts.push( { "partName":"Mouth", "containerClip":"head.mouth" } );
            allParts.push( { "partName":"Nose", "containerClip":"head.nose" } );
            allParts.push( { "partName":"FacialHair", "containerClip":"head.facialHair" } );
            allParts.push( { "partName":"Glasses", "containerClip":"head.glasses" } );
            allParts.push( { "partName":"Hat", "containerClip":"head.hat" } );
            allParts.push( { "partName":"LeftEar", "containerClip":"head.leftEar" } );
            allParts.push( { "partName":"RightEar", "containerClip":"head.rightEar" } );
            allParts.push( { "partName":"Face", "containerClip":"head.face" } );
            allParts.push( { "partName":"RightHandItem", "containerClip":"rightHand.item" } );
            allParts.push( { "partName":"LeftHandItem", "containerClip":"leftHand.item" } );
            allParts.push( { "partName":"Makeup", "containerClip":"head.makeup" } );
			
			defaultClothing = new Object();
			if (dataHolder.gender == 1) {
				defaultClothing["shirt"] = { "itemId":"1108", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:BE2A2A|Outline:681111", "filename":"FemaleTank" };
                defaultClothing["pants"] = { "itemId":"1003", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:000000|Outline:BCBCBC", "filename":"FemalePants" };
                defaultClothing["shoes"] = { "itemId":"1500", "categoryId":"105", "category":"Shoes", "name":"White Shoes", "metaData":"Fill:F5FBFC|Outline:CEDADC", "filename":"Heels" };
                defaultClothing["hair"] = { "itemId":"300", "categoryId":"1003", "category":"Hair", "name":"Short Blond Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"FlippedLongHairColor" };				
                defaultClothing["eyes"] = { "itemId":"100", "categoryId":"1001", "category":"Eyes", "name":"Green Eyes", "metaData":"Fill:39B54A", "filename":"FemaleEyes1" };
				defaultClothing["eyebrows"] = { "itemId":"700", "categoryId":"1007", "category":"Eye Brows", "name":"Eye Brows", "metaData":"Fill:634E30", "filename":"Eyebrows017Color" };
				defaultClothing["mouth"] = { "itemId":"200", "categoryId":"1002", "category":"Mouth", "name":"Red Lips", "metaData":"Fill:C1272D", "filename":"Mouth001Color" };
				defaultClothing["nose"] = { "itemId":"400", "categoryId":"1004", "category":"Nose", "name":"Nose", "metaData":"", "filename":"Nose001" };
				defaultClothing["ears"] = { "itemId":"801", "categoryId":"1008", "category":"Ears", "name":"Ears", "metaData":"", "filename":"UnisexEar1" };
				defaultClothing["face"] = { "itemId":"906", "categoryId":"1009", "category":"Face Shapes", "name":"Face", "metaData":"", "filename":"UnisexFace6" };
            } else {
                defaultClothing["shirt"] = { "itemId":"1143", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:CC5656|Outline:713232", "filename":"MaleTank" };
                defaultClothing["pants"] = { "itemId":"1030", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:212121|Outline:BCBCBC", "filename":"MalePants" };
                defaultClothing["shoes"] = { "itemId":"1501", "categoryId":"105", "category":"Shoes", "name":"Black Shoes", "metaData":"Fill:000000|Outline:FFFFFF", "filename":"MaleShoes" };
                defaultClothing["hair"] = { "itemId":"301", "categoryId":"1003", "category":"Hair", "name":"Spiky Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"ShortTosseledHairColor" };				
				defaultClothing["eyes"] ={ "itemId":"104", "categoryId":"1001", "category":"Eyes", "name":"Blue Eyes", "metaData":"Fill:0099FE", "filename":"MaleEyes1" };
				defaultClothing["eyebrows"] = { "itemId":"700", "categoryId":"1007", "category":"Eye Brows", "name":"Eye Brows", "metaData":"Fill:634E30", "filename":"Eyebrows017Color" };
				defaultClothing["mouth"] = { "itemId":"209", "categoryId":"1002", "category":"Mouth", "name":"Mouth", "metaData":"", "filename":"Mouth008" };
				defaultClothing["nose"] = { "itemId":"401", "categoryId":"1004", "category":"Nose", "name":"Nose", "metaData":"", "filename":"Nose002" };
				defaultClothing["ears"] = { "itemId":"806", "categoryId":"1008", "category":"Ears", "name":"Ears", "metaData":"", "filename":"UnisexEar6" };
				defaultClothing["face"] = { "itemId":"901", "categoryId":"1009", "category":"Face Shapes", "name":"Face", "metaData":"", "filename":"UnisexFace2" };
				
            }
        }
		
		public function loadAsset($dataObject:Object):void {
			
			if ($dataObject.hasOwnProperty("filename") && $dataObject.filename != "") {
				//trace ($dataObject.filename);
				var url:String;
				if (dataHolder.gender == 2) {
					url = DataHolder.URL_MALE_ASSETS_PATH + "/avatar_assets/" + $dataObject.filename + ".swf";
				} else if (dataHolder.gender == 1) {
					url = DataHolder.URL_FEMALE_ASSETS_PATH + "/avatar_assets/" + $dataObject.filename + ".swf";
				}
				new CustomLoader(url, putOnItem, $dataObject);
			}
		}
		
		private function putOnItem($dataObject:Object):void {
			if ($dataObject.sessId != sessId) {
				return;
			}
			
			loadedItems++;
			if ($dataObject.categoryId == 1000) {
				this.loadSkinColors($dataObject);
				return;
			}
			
			var partName:String = this.convertLabelToSaveReadyLabel($dataObject.category);			
			
			this.putOffItem(putedOnItems[partName]);
			
			if ($dataObject.name == "None") {
				
				return;
			}
			
			if ($dataObject.category == "Dresses") {
				this.putOffItem(putedOnItems["shirt"]);
				dress = true;
			}
			
			if (!putedOnItems[partName]) {
				putedOnItems[partName] = { };
			}
			
			
			
			
			putedOnItems[partName] = $dataObject;
			putedOnItems[partName].putedOnParts = new Array();
			
			var containerClip:MovieClip;
			var lf:LoaderInfo = LoaderInfo($dataObject.asset);
			var asset:MovieClip;
			var containerName:String;
			var className:String;
			
			//trace ("partName:  " + partName);
			
			for (var i:int = 0; i < allParts.length; i++) {
				className = "MyLife.Assets." + $dataObject.filename + "." + allParts[i].partName + "Front";
				containerName = allParts[i].containerClip;
				containerClip = this.getContainerClip(containerName, avatarClip);				
				if (lf.applicationDomain.hasDefinition(className)) {					
					var Asset:Class = (lf.applicationDomain.getDefinition(className)) as Class;
					asset = new Asset() as MovieClip;
					containerClip.addChild(asset);
					if (partName == "pants" || partName == "shirt") {
						//trace (className + "  " + containerClip);
					}					
					putedOnItems[partName].putedOnParts.push(containerClip);
					if ($dataObject.hasOwnProperty("metaData") && $dataObject.metaData != "") {
						var colors:Object = convertMetaDataStringToObject($dataObject.metaData);
						var tempSkinFillColor:Number = Number("0x" + colors.Fill);
						var tempSkinOutlineColor:Number = Number("0x" + colors.Outline);
						this.colorClip(asset, tempSkinFillColor, tempSkinOutlineColor);
					}
					
				}
			}
			
			
			//loadedItems++;
			trace (itemsToLoad + "   " + loadedItems + "   " + itemsToPutOn[partName].category);	
			if (itemsToLoad == loadedItems) {
				clearTimeout(preloaderTimeoutId);				
				if (this.alpha != 1) {
					TweenLite.to(this, 0.75, { "alpha":1 } );
				}				
				this.dispatchEvent(new Event("allPartsLoaded"));				
			}
			this.tintSkin();
		}
		
		private function getContainerClip($containerName:String, $parentClip:MovieClip):MovieClip {
			
            if ($parentClip == null) {
                return null;
            }
            var index:int = $containerName.indexOf(".", 0);
            if (index == -1) {
                return $parentClip.getChildByName($containerName) as MovieClip;
            }
            var firstClip:String = $containerName.substring(0, index);
            var secondClip:String = $containerName.substring(index + 1, $containerName.length);
            return getContainerClip(secondClip, $parentClip.getChildByName(firstClip) as MovieClip);
        }
		
		private function colorClip($clip:MovieClip, $colorFill:Number=NaN, $colorOutline:Number=NaN):void {
            var tmpClip:MovieClip;
            var colorTransform:ColorTransform;

            if ($clip == null) {
                return;
            }
            tmpClip = ($clip.color != null) ? $clip.color : $clip;
            if ((colorTransform = getColorTransform($colorFill, $colorOutline)) != null) {
                tmpClip.transform.colorTransform = colorTransform;
            }
            return;
        }
		
		private function getColorTransform(arg1:Number=NaN, arg2:Number=NaN):ColorTransform {
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
            if (!isNaN(arg1) && isNaN(arg2)) {
                loc3 = ((arg1 & 16711680) >> 16) / 255;
                loc4 = ((arg1 & 65280) >> 8) / 255;
                loc5 = (arg1 & 255) / 255;
                return new ColorTransform(loc3, loc4, loc5, 1, 0, (0), (0));
            }
            if (!isNaN(arg1) && !isNaN(arg2)) {
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
		
		private function convertMetaDataStringToObject($metadata:String):Object {
            var tmpObject:Object = new Object();
            var tmpArray1:Array = new Array();
            var i:int = 0;
            var tmpArray2:Array = new Array();
            if ($metadata == null || $metadata == "") {
                return tmpObject;
            }
            tmpArray1 = $metadata.split("|");
			var name:String;
            while (i < tmpArray1.length) {
                if ((tmpArray2 = tmpArray1[i].split(":")).length == 2) {
					name = tmpArray2[0]
                    tmpObject[name] = tmpArray2[1];
                }
                i++;
            }
            return tmpObject;
        }
		
		/*private function addToLoadQueue($dataObject:Object):void {
			queue.push($dataObject);
			if (queue.length == 1) {
				this.loadAsset(queue[0]);
			}
		}
		
		private function removeFromQueue($dataObject:Object):void {
			for (var i:int = 0; i < queue.length; i++) {
				if (queue[i] == $dataObject) {
					queue.splice(i, 1);
				}
			}        
			this.loadAsset(queue[0]);
		}*/
		
		private function checkMissingRequiredClothes():void {			
			var partName:String;
			for (var i:int = 0; i < defaultParts.length; i++) {
				partName = defaultParts[i];				
				if ((putedOnItems[partName] == null && itemsToPutOn[partName] == null) || (itemsToPutOn[partName] && itemsToPutOn[partName].name == "None")) {
					trace ("None");
					itemsToPutOn[partName] = defaultClothing[partName];
				}
			}
			
		}
		
		private function clearAllClothes():void {
            var allViews:Array = new Array();
            var containerClip:MovieClip;
            allViews = DataHolder.ALL_VIEWS
            
			for (var i:int = 0; i < allViews.length; i++) {
				if ((containerClip = getContainerClip(allViews[i].containerClip, avatarClip)) != null) {
					while (containerClip.numChildren) containerClip.removeChildAt(0);
                }
			}
            return;
        }
		
		public function loadRandomItems():void {
			var tmpArray:Array;
			var itemNum:int;
			//var categoryNum:int;
			var partName:String;
			itemsToPutOn = new Object();
			//categoryNum = Math.floor(dataHolder.itemsObject.length * Math.random());
			for (var name:String in dataHolder.itemsObject) {
				if (dataHolder.itemsObject[name] is Array) {
					tmpArray = dataHolder.itemsObject[name];
					itemNum = Math.floor(tmpArray.length * Math.random());
					partName = this.convertLabelToSaveReadyLabel(tmpArray[itemNum].category);
					if (!itemsToPutOn[partName]) {
						itemsToPutOn[partName] = tmpArray[itemNum];
					}
					
				}				
			}
			this.checkMissingRequiredClothes();
			this.putOnClothes();
		}
		
		
		private function convertLabelToSaveReadyLabel($clothing:String):String {
			//trace ($clothing);
            var convertedLabel:String = "";
            if ($clothing == "PelvisPants" || $clothing == "Pants" || $clothing == "Dresses" || $clothing == "Skirts" || $clothing == "Costumes" || $clothing == "Shorts" || $clothing == "Swimwear") {
                convertedLabel = "pants";
            } else {
                if ($clothing == "ChestShirt" || $clothing == "Shirts") {
                    convertedLabel = "shirt";
                } else {
                    if ($clothing == "ChestJacket" || $clothing == "Jackets") {
                        convertedLabel = "jacket";
                    } else {
                        if ($clothing != "Eyes") {
                            if ($clothing != "Eye Brows") {
                                if ($clothing != "Mouth") {
                                    if ($clothing == "FacialHair" || $clothing == "Facial Hair") {
                                        convertedLabel = "facialhair";
                                    } else {
                                        if ($clothing != "Nose") {
                                            if ($clothing != "Hair") {
                                                if ($clothing != "Glasses") {
                                                    if ($clothing == "Hat" || $clothing == "Hats") {
                                                        convertedLabel = "hat";
                                                    } else {
                                                        if ($clothing == "LeftEar" || $clothing == "Ears" || $clothing == "RightEar") {
															convertedLabel = "ears";
														} else {
                                                            if ($clothing == "Face" || $clothing == "Face Shapes") {
																convertedLabel = "face";
															} else {
                                                                if ($clothing == "LeftFootShoe" || $clothing == "Shoes" || $clothing == "RightFootShoe") {
                                                                    convertedLabel = "shoes";
                                                                } else {
                                                                    if ($clothing == "Necklace" || $clothing == "ChestNecklace") {
                                                                        convertedLabel = "necklace";
                                                                    } else {
                                                                        if ($clothing == "RightHandItem" || $clothing == "Purse" || $clothing == "LeftHandItem") {
                                                                            convertedLabel = "purse";
                                                                        } else {
                                                                            if ($clothing != "Makeup") {
                                                                                if ($clothing == "Gloves" || $clothing == "LeftHandGlove" || $clothing == "RightHandGlove") {
                                                                                    convertedLabel = "gloves";
                                                                                } else {
                                                                                    if ($clothing == "Rings" || "LeftHandRing" || $clothing == "RightHandRing") {
                                                                                        convertedLabel = "ring";
                                                                                    } else {
                                                                                        if ($clothing != "LeftForeArmBracelet") {
                                                                                            if ($clothing != "RightForeArmBracelet") {
                                                                                                if ($clothing == "Scarf" || $clothing == "ChestScarf") {
                                                                                                    convertedLabel = "scarf";
                                                                                                }
                                                                                            } else {
                                                                                                convertedLabel = "bracelet";
                                                                                            }
                                                                                        } else {
                                                                                            convertedLabel = "bracelet";
                                                                                        }
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                convertedLabel = "makeup";
                                                                            }
                                                                        }
                                                                    }
                                                                }
															}
                                                        } 
                                                    }
                                                } else {
                                                    convertedLabel = "glasses";
                                                }
                                            } else {
                                                convertedLabel = "hair";
                                            }
                                        } else {
                                            convertedLabel = "nose";
                                        }
                                    }
                                } else {
                                    convertedLabel = "mouth";
                                }
                            } else {
                                convertedLabel = "eyebrows";
                            }
                        } else {
                            convertedLabel = "eyes";
                        }
                    }
                }
            }
			//trace (convertedLabel);
            return convertedLabel;
        }
	}
	
}