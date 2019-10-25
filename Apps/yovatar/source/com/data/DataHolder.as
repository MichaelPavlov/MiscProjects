package com.data {
	
	public class DataHolder {
		
		import com.assets.classes.*
		import com.UI.Avatar;
		import flash.display.MovieClip;
		
		public static const DEBUG_MODE:Boolean = false;
		public static const ALL_VIEWS:Array = [ { "className":"LeftThighPantsFront", "containerClip":"leftThigh.clothing" }, { "className":"RightThighPantsFront", "containerClip":"rightThigh.clothing" }, { "className":"LeftCalfPantsFront", "containerClip":"leftCalf.clothing" }, { "className":"RightCalfPantsFront", "containerClip":"rightCalf.clothing" }, { "className":"LeftUpperArmShirtFront", "containerClip":"leftUpperArm.clothing" }, { "className":"RightUpperArmShirtFront", "containerClip":"rightUpperArm.clothing" }, { "className":"LeftForeArmShirtFront", "containerClip":"leftForeArm.clothing" }, { "className":"RightForeArmShirtFront", "containerClip":"rightForeArm.clothing" }, { "className":"LeftUpperArmJacketFront", "containerClip":"leftUpperArm.jacket" }, { "className":"RightUpperArmJacketFront", "containerClip":"rightUpperArm.jacket" }, { "className":"LeftForeArmJacketFront", "containerClip":"leftForeArm.jacket" }, { "className":"RightForeArmJacketFront", "containerClip":"rightForeArm.jacket" }, { "className":"ChestShirtFront", "containerClip":"chest.clothing" }, { "className":"ChestJacketFront", "containerClip":"chest.jacket" }, { "className":"PelvisPantsFront", "containerClip":"pelvis.clothing" }, { "className":"DressThighDressFront", "containerClip":"dressThigh.clothing" }, { "className":"DressCalfDressFront", "containerClip":"dressCalf.clothing" }, { "className":"HairFront", "containerClip":"head.hair" }, { "className":"HairBackFront", "containerClip":"hairBack.hair" }, { "className":"LeftFootShoeFront", "containerClip":"leftFoot.clothing" }, { "className":"RightFootShoeFront", "containerClip":"rightFoot.clothing" }, { "className":"LeftCalfShoeFront", "containerClip":"leftCalf.shoe" }, { "className":"RightCalfShoeFront", "containerClip":"rightCalf.shoe" }, { "className":"LeftThighShoeFront", "containerClip":"leftThigh.shoe" }, { "className":"RightThighShoeFront", "containerClip":"rightThigh.shoe" }, { "className":"LeftEarFront", "containerClip":"head.leftEar" }, { "className":"RightEarFront", "containerClip":"head.rightEar" }, { "className":"LeftEarringFront", "containerClip":"head.leftEarring" }, { "className":"RightEarringFront", "containerClip":"head.rightEarring" }, { "className":"LeftHandItemFront", "containerClip":"leftHand.item" }, { "className":"RightHandItemFront", "containerClip":"rightHand.item" }, { "className":"LeftHandGloveFront", "containerClip":"leftHand.glove" }, { "className":"RightHandGloveFront", "containerClip":"rightHand.glove" }, { "className":"LeftHandBraceletFront", "containerClip":"leftHand.bracelet" }, { "className":"RightHandBraceletFront", "containerClip":"rightHand.bracelet" }, { "className":"LeftHandRingFront", "containerClip":"leftHand.ring" }, { "className":"RightHandRingFront", "containerClip":"rightHand.ring" }, { "className":"EyesFront", "containerClip":"head.eyes" }, { "className":"EyeBrowsFront", "containerClip":"head.eyebrows" }, { "className":"NoseFront", "containerClip":"head.nose" }, { "className":"MouthFront", "containerClip":"head.mouth" }, { "className":"FacialHairFront", "containerClip":"head.facialHair" }, { "className":"GlassesFront", "containerClip":"head.glasses" }, { "className":"HatFront", "containerClip":"head.hat" }, { "className":"MakeupFront", "containerClip":"head.makeup" }, { "className":"FaceFront", "containerClip":"head.face" }, { "className":"ChestScarfFront", "containerClip":"chest.scarf" }, { "className":"ChestNecklaceFront", "containerClip":"chest.necklace" }, { "className":"CapeBackFront", "containerClip":"capeBack.cape" }, { "className":"CapeFront", "containerClip":"chest.cape" } ];
		
		public static const URL_MALE_DATA:String = "male_data.json";
		public static const URL_FEMALE_DATA:String = "female_data.json";
		
		public static const URL_MALE_ASSETS_PATH:String = "male";
		public static const URL_FEMALE_ASSETS_PATH:String = "female";
		
		public static const URL_PHP_FILE_SEND_PATH:String = "jpg_encoder_download.php";
		
		public static const GENDER_MALE:int = 2;
		public static const GENDER_FEMALE:int = 1;
		
		public static const PRELOADER_TIMEOUT:uint = 4000;
		
		public static const INVENTORY_FOOD:Number=6;
        public static const INVENTORY_APPEARANCE:Number=1;
		public static const INVENTORY_ACCESSORIES:Number=2;
		public static const INVENTORY_CLOTHING:Number = 3;
		public static const INVENTORY_COSTUMES:Number = 4;
		
		public static const TYPE_MALE_CLOTHES:Array = [];
		public static const TYPE_FEMALE_CLOTHES:Array = [];
		
		public static const TYPE_APPEARANCE_CLOTHES:Array = ["eyes", "hair", "mouth", "eye brows", "nose", "ears", "skin", "face shapes"];
		
        public static const FemaleNoseFront:Class = FemaleNoseFront;
        public static const RightEarFront:Class = RightEarFront;
        public static const FemaleChestShirtFront:Class = FemaleChestShirtFront;
        public static const MaleEyeBrowsFront:Class = MaleEyeBrowsFront;
        public static const FaceFront:Class = FaceFront;
        public static const FemaleMouthFront:Class = FemaleMouthFront;
        public static const MaleMouthFront:Class = MaleMouthFront;
        public static const FemaleEyeBrowsFront:Class = FemaleEyeBrowsFront;
        public static const MaleEyesFront:Class = MaleEyesFront;
        public static const LeftThighPantsFront:Class = LeftThighPantsFront;
        public static const HairFront:Class = HairFront;
        public static const LeftEarFront:Class = LeftEarFront;
        public static const RightThighPantsFront:Class = RightThighPantsFront;
        public static const MaleChestShirtFront:Class = MaleChestShirtFront;
        public static const FemaleEyesFront:Class = FemaleEyesFront;
        public static const PelvisPantsFront:Class = PelvisPantsFront;
        public static const MaleNoseFront:Class = MaleNoseFront;
		
		public static var dataHolder:DataHolder;
		
		public var gender:int;
		public var playerName:String;
		
		private var _inventoryData:Array;
		private var _avatarDefaultAssets:Array;
		private var _defaultAppearanceData:Array;
		public var playerID:int = 0;
		
		public var avatarHandler:Avatar;
		
		public var clientInfo:Object = new Object();
		public var itemsObject:Object;
		
		public function DataHolder() {
			if (dataHolder) {
				throw new Error( "Only one DataHolder instance should be instantiated" );
			}
		}
		
		public static function getInstance():DataHolder {
			if (dataHolder == null) {
				dataHolder = new DataHolder();
			}
			return dataHolder;
		}
		
		public static function addZerro($value:String):String{
			if ($value.length == 1) {
				return '0'+ $value
			} else {
				return $value
			}
		}		
		
		public static function secondsToTime($nSeconds:Number):String {
			var time = $nSeconds;
			if (isNaN(time)) time = 0;
			var min  = Math.floor( time / 60);
			var sec  = Math.floor(time-min * 60);
			sec = addZerro(String(sec));
			min = addZerro(String(min));
			return min+':'+sec
		}
		
		/*
		public function set defaultdefaultAppearanceData(value:Array):void {			
            for each (var i in value) {
				trace (i);               
            }			
			_defaultAppearanceData = value;
		}
		
		public function get defaultdefaultAppearanceData():Array {
			return _defaultAppearanceData;
		}
		*/
		
		public function set avatarDefaultAssets(value:Array):void {
			_avatarDefaultAssets = value;
		}
		
		public function get avatarDefaultAssets():Array {
			return _avatarDefaultAssets;
		}
		
		public function set inventoryData(value:Array):void {
			
			/*for(var i:String in value[1]) {
				trace (i)
			}*/
			_inventoryData = value;
		}
		
		public function get inventoryData():Array {
			return _inventoryData;
		}
		
		public function getAvatarAssets($categories:Array):Object {			
			var aTmp:Array = new Array();
			
			for (var i:int = 0; i < _inventoryData.length; i++) {
				for (var j:int = 0; j < $categories.length; j++) {
					if (_inventoryData[i].hasOwnProperty("parentCategoryId") && _inventoryData[i].hasOwnProperty("g")) {
						if (_inventoryData[i].g != this.gender) {
							continue;
						}
						//trace ($categories[j] +"   "+_inventoryData[i].parentCategoryId+"   "+($categories[j] == _inventoryData[i].parentCategoryId));
						if ($categories[j] == _inventoryData[i].parentCategoryId) {
							aTmp.push(_inventoryData[i]);
						}
					}
				}				
			}			
			return sortObjectsToArray(aTmp);
		}
		
		public function getAvatarDefaultAssets():void {			
			/*var aTmp:Array = new Array();
			
			for (var i:int = 0; i < _inventoryData.length; i++) {
				for (var j:int = 0; j < $categories.length; j++) {
					if (_inventoryData[i].hasOwnProperty("parentCategoryId") && _inventoryData[i].hasOwnProperty("g")) {
						if (_inventoryData[i].g != this.gender) {
							continue;
						}
						//trace ($categories[j] +"   "+_inventoryData[i].parentCategoryId+"   "+($categories[j] == _inventoryData[i].parentCategoryId));
						if ($categories[j] == _inventoryData[i].parentCategoryId) {
							aTmp.push(_inventoryData[i]);
						}
					}
				}				
			}			
			return sortObjectsToArray(aTmp);*/
		}
		
		public function sortObjectsToArray($objects:Array):Object {
			var oTmp:Object = new Object();
			var categoryName:String;
			var categoryId:String;
			for (var i:int = 0; i < $objects.length; i++) {
				categoryName = "category_"+$objects[i].categoryId;
				categoryId = $objects[i].categoryId;
				if (!oTmp[categoryName]) {
					oTmp[categoryName] = new Array();
					if ($objects[i].parentCategoryId != DataHolder.INVENTORY_APPEARANCE || $objects[i].categoryId == 1005 || $objects[i].categoryId == 1006) {
						oTmp[categoryName].push(this.getNoneObject($objects[i]));
					}
					oTmp[categoryName].label = $objects[i].category;
					oTmp[categoryName].categoryId = categoryId;
				}
				oTmp[categoryName].push($objects[i]);
				//$objects[i].category;
			}
			i++
			/*var aTmp:Array = new Array();
			
			for (var name:String in oTmp) {
				aTmp.push(oTmp[name]);
			}*/
			return oTmp;
		}
		
		public function getNoneObject($proto:Object):Object {
			var oNone:Object = new Object();
			oNone.category = $proto.category;
            oNone.categoryId = $proto.categoryId;
            oNone.name = "None";
            oNone.asset = { };
            oNone.player = 0;
            oNone.sortOrder = 0;
            oNone.itemId = 0;
            oNone.playerItemId = 0;
            oNone.metadata = "";
            return oNone;
		}
		
		public function convertIdToCategory():void {
			
		}
		
		/*public function getRandomItems(): {
			var tmpArray:Array;
			for (var name:String in itemsObject) {
				if (itemsObject[name] is Array) {
					tmpArray = itemsObject[name];					
				}				
			}			
		}*/
		
		private function getDefaultClothing():Object {
            var obj:Object = new Object();
            
            if (gender != 1) {
                obj["101"] = {"itemId":"1143", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:CC5656|Outline:713232", "filename":"MaleTank"};
                obj["100"] = {"itemId":"1030", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:212121|Outline:BCBCBC", "filename":"MalePants"};
                obj["105"] = {"itemId":"1501", "categoryId":"105", "category":"Shoes", "name":"Black Shoes", "metaData":"Fill:000000|Outline:FFFFFF", "filename":"MaleShoes"};
                obj["1003"] = {"itemId":"301", "categoryId":"1003", "catergory":"Hair", "name":"Spiky Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"ShortTosseledHairColor"};
            } else {
                obj["101"] = {"itemId":"1108", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:BE2A2A|Outline:681111", "filename":"FemaleTank"};
                obj["100"] = {"itemId":"1003", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:000000|Outline:BCBCBC", "filename":"FemalePants"};
                obj["105"] = {"itemId":"1500", "categoryId":"105", "catergory":"Shoes", "name":"White Shoes", "metaData":"Fill:F5FBFC|Outline:CEDADC", "filename":"Heels"};
                obj["1003"] = {"itemId":"300", "categoryId":"1003", "catergory":"Hair", "name":"Short Blond Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"FlippedLongHairColor"};
            }
            return obj;
        }
		
		public function getCountries():Array {
			var arr:Array = new Array();
			arr.push("Afghanistan")
			arr.push("Albania")
			arr.push("Algeria")
			arr.push("Andorra")
			arr.push("Angola")
			arr.push("Antigua & Deps")
			arr.push("Argentina")
			arr.push("Armenia")
			arr.push("Australia")
			arr.push("Austria")
			arr.push("Azerbaijan")
			arr.push("Bahamas")
			arr.push("Bahrain")
			arr.push("Bangladesh")
			arr.push("Barbados")
			arr.push("Belarus")
			arr.push("Belgium")
			arr.push("Belize")
			arr.push("Benin")
			arr.push("Bhutan")
			arr.push("Bolivia")
			arr.push("Bosnia Herzegovina")
			arr.push("Botswana")
			arr.push("Brazil")
			arr.push("Brunei")
			arr.push("Bulgaria")
			arr.push("Burkina")
			arr.push("Burundi")
			arr.push("Cambodia")
			arr.push("Cameroon")
			arr.push("Canada")
			arr.push("Cape Verde")
			arr.push("Central African Rep")
			arr.push("Chad")
			arr.push("Chile")
			arr.push("China")
			arr.push("Colombia")
			arr.push("Comoros")
			arr.push("Congo")
			arr.push("Congo {Democratic Rep}")
			arr.push("Costa Rica")
			arr.push("Croatia")
			arr.push("Cuba")
			arr.push("Cyprus")
			arr.push("Czech Republic")
			arr.push("Denmark")
			arr.push("Djibouti")
			arr.push("Dominica")
			arr.push("Dominican Republic")
			arr.push("East Timor")
			arr.push("Ecuador")
			arr.push("Egypt")
			arr.push("El Salvador")
			arr.push("Equatorial Guinea")
			arr.push("Eritrea")
			arr.push("Estonia")
			arr.push("Ethiopia")
			arr.push("Fiji")
			arr.push("Finland")
			arr.push("France")
			arr.push("Gabon")
			arr.push("Gambia")
			arr.push("Georgia")
			arr.push("Germany")
			arr.push("Ghana")
			arr.push("Greece")
			arr.push("Grenada")
			arr.push("Guatemala")
			arr.push("Guinea")
			arr.push("Guinea-Bissau")
			arr.push("Guyana")
			arr.push("Haiti")
			arr.push("Honduras")
			arr.push("Hungary")
			arr.push("Iceland")
			arr.push("India")
			arr.push("Indonesia")
			arr.push("Iran")
			arr.push("Iraq")
			arr.push("Ireland {Republic}")
			arr.push("Israel")
			arr.push("Italy")
			arr.push("Ivory Coast")
			arr.push("Jamaica")
			arr.push("Japan")
			arr.push("Jordan")
			arr.push("Kazakhstan")
			arr.push("Kenya")
			arr.push("Kiribati")
			arr.push("Korea North")
			arr.push("Korea South")
			arr.push("Kosovo")
			arr.push("Kuwait")
			arr.push("Kyrgyzstan")
			arr.push("Laos")
			arr.push("Latvia")
			arr.push("Lebanon")
			arr.push("Lesotho")
			arr.push("Liberia")
			arr.push("Libya")
			arr.push("Liechtenstein")
			arr.push("Lithuania")
			arr.push("Luxembourg")
			arr.push("Macedonia")
			arr.push("Madagascar")
			arr.push("Malawi")
			arr.push("Malaysia")
			arr.push("Maldives")
			arr.push("Mali")
			arr.push("Malta")
			arr.push("Montenegro")
			arr.push("Marshall Islands")
			arr.push("Mauritania")
			arr.push("Mauritius")
			arr.push("Mexico")
			arr.push("Micronesia")
			arr.push("Moldova")
			arr.push("Monaco")
			arr.push("Mongolia")
			arr.push("Morocco")
			arr.push("Mozambique")
			arr.push("Myanmar, {Burma}")
			arr.push("Namibia")
			arr.push("Nauru")
			arr.push("Nepal")
			arr.push("Netherlands")
			arr.push("New Zealand")
			arr.push("Nicaragua")
			arr.push("Niger")
			arr.push("Nigeria")
			arr.push("Norway")
			arr.push("Oman")
			arr.push("Pakistan")
			arr.push("Palau")
			arr.push("Panama")
			arr.push("Papua New Guinea")
			arr.push("Paraguay")
			arr.push("Peru")
			arr.push("Philippines")
			arr.push("Poland")
			arr.push("Portugal")
			arr.push("Qatar")
			arr.push("Romania")
			arr.push("Russian Federation")
			arr.push("Rwanda")
			arr.push("St Kitts & Nevis")
			arr.push("St Lucia")
			arr.push("Saint Vincent & the Grenadines")
			arr.push("Samoa")
			arr.push("San Marino")
			arr.push("Sao Tome & Principe")
			arr.push("Saudi Arabia")
			arr.push("Senegal")
			arr.push("Serbia")
			arr.push("Seychelles")
			arr.push("Sierra Leone")
			arr.push("Singapore")
			arr.push("Slovakia")
			arr.push("Slovenia")
			arr.push("Solomon Islands")
			arr.push("Somalia")
			arr.push("South Africa")
			arr.push("Spain")
			arr.push("Sri Lanka")
			arr.push("Sudan")
			arr.push("Suriname")
			arr.push("Swaziland")
			arr.push("Sweden")
			arr.push("Switzerland")
			arr.push("Syria")
			arr.push("Taiwan")
			arr.push("Tajikistan")
			arr.push("Tanzania")
			arr.push("Thailand")
			arr.push("Togo")
			arr.push("Tonga")
			arr.push("Trinidad & Tobago")
			arr.push("Tunisia")
			arr.push("Turkey")
			arr.push("Turkmenistan")
			arr.push("Tuvalu")
			arr.push("Uganda")
			arr.push("Ukraine")
			arr.push("United Arab Emirates")
			arr.push("United Kingdom")
			arr.push("United States")
			arr.push("Uruguay")
			arr.push("Uzbekistan")
			arr.push("Vanuatu")
			arr.push("Vatican City")
			arr.push("Venezuela")
			arr.push("Vietnam")
			arr.push("Yemen")
			arr.push("Zambia")
			arr.push("Zimbabwe")	
			
			return arr;
		}	
		
	}
}