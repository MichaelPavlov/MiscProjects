package com.webtako.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.Font;
	
	public class FlashUtil {
		//public static const TEXT_FONT:MyFont = new MyFont();
		public static const TRANSITION_TYPE:String = "easeOutQuart";
		public static const TRANSITION_TIME:Number = 1.0;
		public static const DEFAULT_ALPHA:Number = 0.75;
		public static const ALIGN_TOP:String = "TOP";
		public static const ALIGN_RIGHT:String = "RIGHT";
		public static const ALIGN_BOTTOM:String = "BOTTOM";
		public static const ALIGN_LEFT:String = "LEFT";
		public static const ALIGN_CENTER:String = "CENTER";
		
		private static var instance:FlashUtil;
		private static var allowInstantiation:Boolean = false;
		
		/*[Embed(systemFont='Arial', fontName='ArialGreek' , unicodeRange='U+0021-U+0451', mimeType='application/x-font')]
		public var ArialGreek:Class;*/
		
		public var TEXT_FONT1:Font;
		
		public function FlashUtil():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use FlashUtil.getInstance() instead of new.")
			}
			//this.TEXT_FONT1 = new ArialGreek();
		}
		
		public static function getInstance():FlashUtil {
			if (instance == null) {
				allowInstantiation = true;
            	instance = new FlashUtil();
            	allowInstantiation = false;				
	        }
    		return instance;
		}
		
		public static function getStringParam(param:String, defaultValue:String):String {
			if (!isNullEmptyString(param)) {
				return param;
			}
			return defaultValue;
		}
		
		public static function getBooleanParam(param:String, defaultValue:Boolean):Boolean {
			if (!isNullEmptyString(param)) {
				if (param == "true") {
					return true;
				}
				else if (param == "false") {
					return false;
				} 
			}
			return defaultValue;	
		}
		
		public static function getNumberParam(param:String, defaultValue:Number):Number {
			if (!isNullEmptyString(param) && !isNaN(Number(param))) {
				return Number(param);
			}
			return defaultValue;
		}
		
		public static function getUintParam(param:String, defaultValue:uint):uint {
			if (!isNullEmptyString(param) && !isNaN(uint(param))) {
				return uint(param);
			}
			return defaultValue;
		}
		
		public static function isNullEmptyString(str:String):Boolean {
			if (str == null || str.length == 0) {
				return true;
			}
			return false;
		}
		
		public static function shuffleArray(array:Array):Array {
			var len:Number = array.length - 1;
			
			for (var i:uint = 0; i < len; i++) {
				var ri:uint = Math.round(Math.random() * len);
				var temp:* = array[i];

				array[i] = array[ri];
				array[ri] = temp;
			}
			return array;
		}
		
		public static function setColor(mc:MovieClip, color:uint):void {
			var colorTransform:ColorTransform = mc.transform.colorTransform;
			colorTransform.color = color;
			mc.transform.colorTransform = colorTransform;	
		}
		
		public static function initMask(obj:Sprite, objWidth:Number, objHeight:Number):void {
			var maskSprite:Sprite = new Sprite();
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(0, 0, objWidth, objHeight);	
			maskSprite.graphics.endFill();
			
			obj.mask = maskSprite;
			obj.addChild(maskSprite);	
		}
		
		public static function getCenter(containerSize:Number, contentSize:Number):Number {
			return Math.round((containerSize - contentSize)/2);		
		}

		//convert delay time to milliseconds
		public static function secondsToMilliseconds(seconds:Number):Number {
			if (seconds < 1) {
				return 0;
			}
			return (seconds * 1000);
		}
	}
}