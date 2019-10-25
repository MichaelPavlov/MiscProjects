package com.shurba.abigroup {
	import com.greensock.TweenLite;
	import com.shurba.components.carousel.Carousel;
	import com.shurba.components.carousel.CarouselEvent;
	import com.shurba.components.carousel.CarouselParameters;
	import com.shurba.components.carousel.CarouselThumbnail;
	import com.shurba.components.carousel.ThumbVO;
	import com.shurba.media.ImageViewer;
	import com.shurba.media.ImageViewerEvent;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {	
		private const DEFAULT_THUMB_WIDTH:Number = 100;
		private const DEFAULT_THUMB_HEIGHT:Number = 95;
		private const DEFAULT_CAROUSEL_WIDTH:Number = 963;
		private const DEFAULT_CAROUSEL_HEIGHT:Number = 98;
		private const DEFAULT_THUMB_GAP:Number = 10;
		private const XML_PATH:String = 'data/gallery.xml';
		
		private var xmlLoader:XMLLoader;
		public var carousel:Carousel;
		public var imageViewer:ImageViewer;
		
		public var maskClip:Sprite;
		public var preloader:Sprite;
		
		private var scrollTimer:Timer = new Timer(5000);
		
		private var bImageLoaded:Boolean = false;
		
		public function DocumentClass() {
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			new ApplyStandartOptions(this);
			
			this.mask = maskClip;
			this.loadXML();
			
		}
		
		private function addListeners():void {
			carousel.addEventListener(CarouselEvent.ITEM_SELECT, carouselItemSelectHandler, false, 0, true);
			imageViewer.addEventListener(MouseEvent.CLICK, imageClickHandler, false, 0, true);
			imageViewer.addEventListener("imageLoadComplete", imageLoadCompleteHandler, false, 0, true);
			
			scrollTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		}
		
		private function timerHandler(e:TimerEvent):void {			
			scrollTimer.stop();
			carousel.selectNext()
		}
		
		private function imageLoadCompleteHandler(e:Event):void {
			imageViewer.fadeIn();
			bImageLoaded = true;
			
			scrollTimer.reset();
			scrollTimer.start();
		}
		
		private function mouseOverHandler(e:MouseEvent):void {			
			scrollTimer.stop();			
		}
		
		private function mouseLeaveHandler(e:Event):void {
			scrollTimer.reset();
			scrollTimer.start();
			//carousel.bMoveFlag = true;
		}
		
		private function loadXML():void {
			xmlLoader = new XMLLoader(XML_PATH, xmlLoaded);
		}
		
		private function xmlLoaded($xml:XML):void {
			carousel = new Carousel();			
			carousel.dataProvider = this.parseXML($xml);
			this.addChild(carousel);
			carousel.width = stage.stageWidth;
			carousel.height = DEFAULT_CAROUSEL_HEIGHT;
			carousel.x = 0;
			carousel.y = stage.stageHeight - DEFAULT_CAROUSEL_HEIGHT;
			
			imageViewer = new ImageViewer();
			imageViewer.buttonMode = true;
			this.addChild(imageViewer);
			
			addListeners();
			
			carousel.selectFirstItem();
		}
		
		private function imageClickHandler(e:MouseEvent):void {
			var request:URLRequest = new URLRequest(carousel.selectedItem.dataProvider.link);
			navigateToURL(request, "_self");
		}
		
		private function carouselItemSelectHandler(e:CarouselEvent):void {
			TweenLite.to(imageViewer, 0.5, { alpha:0, onComplete:function():void {imageViewer.source = e.data.imageUrl}} );
			bImageLoaded = false;
		}
		
		private function parseXML($xml:XML):CarouselParameters {
			var xList:XMLList = $xml.images.children();			
			
			var carouselParams:CarouselParameters = new CarouselParameters();
			carouselParams.thumbFolder = String($xml.@thumbFolder);
			carouselParams.fullFolder = String($xml.@fullFolder);
			
			if ($xml.@thumbBorder == "true") {
				carouselParams.thumbBorder = true;
				carouselParams.thumbBorderColor = int($xml.@thumbBorderColor);
			} else {
				carouselParams.thumbBorder = false;
			}
			
			if ($xml.@thumbsGap != "" || $xml.@thumbsGap != undefined) {
				carouselParams.thumbsGap = int($xml.@thumbsGap);			
			} else {
				carouselParams.thumbsGap = DEFAULT_THUMB_GAP;
			}
			
			if ($xml.@thumbHeight != "" || $xml.@thumbHeight != undefined) {
				carouselParams.thumbHeight = Number($xml.@thumbHeight);			
			} else {
				carouselParams.thumbHeight = DEFAULT_THUMB_HEIGHT;
			}
			
			if ($xml.@thumbWidth != "" || $xml.@thumbWidth != undefined) {
				carouselParams.thumbWidth = Number($xml.@thumbWidth);			
			} else {
				carouselParams.thumbWidth = DEFAULT_THUMB_WIDTH
			}
			
			
			carouselParams.thumbsData = [];
			
			for (var i:Number = 0; i < xList.length(); i++) {
				var obj:ThumbVO = new ThumbVO();
				obj.thumbUrl = carouselParams.thumbFolder + "/" + xList[i].@thumbUrl;				
				obj.imageUrl = carouselParams.fullFolder + "/" + xList[i].@imageUrl;				
				obj.thumbBorderColor = carouselParams.thumbBorderColor;
				obj.thumbBorder = carouselParams.thumbBorder;
				obj.width = carouselParams.thumbWidth;
				obj.height = carouselParams.thumbHeight;
				obj.description = xList[i].@description;
				obj.link = xList[i].@link;
				carouselParams.thumbsData.push(obj);
			}
			
			return carouselParams;
		}
		
	}

}