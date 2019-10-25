package com.webtako.flash {
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MasterSlide extends Slide {	
		public static const CONTENT_LOADED:String 	= "contentLoaded";
		public static const CONTENT_STORED:String 	= "contentStored";
		public static const ZOOM_IN:String 	= "zoomIn";
		public static const ZOOM_OUT:String = "zoomOut";
		public static const CURSOR_XOFFSET:Number = 5;
		public static const CURSOR_PLUS:uint  = 1;
		public static const CURSOR_MINUS:uint = 2;
		
		private var _categoryId:int;
		private var _contentMap:Object;		
		private var _prevContent:ContentContainer;
		private var _currContent:ContentContainer;
		private var _zoomin:Boolean;
		private var _cursor:MovieClip;
		
		public function MasterSlide(areaWidth:Number, areaHeight:Number, preloaderColor:uint = 0x0066FF, preloaderSize:Number = 40) {
			//init properties
			this._categoryId = -1;
			this._zoomin = false;
			
			//init cursor
			this._cursor = new Cursor();
			this._cursor.alpha = 0;
			this.addChild(this._cursor);
						
			//init content cache
			this._contentMap = new Object();
			
			//constructor call							  
			super("", "", "", "", areaWidth, areaHeight, 0x000000, 0x000000, 0x000000, preloaderColor, preloaderSize);
			this.removeEventListener(MouseEvent.CLICK, onSlideClick);
			
			this.buttonMode = false;		
			this.useHandCursor = false;
			this.mouseChildren = true;										
		}
		
		//on stage resize		
		public function onResize():void {
			var preloaderSize:Number = this._preloader.height;
			this._preloader.x = FlashUtil.getCenter(this.stage.stageWidth, preloaderSize);
			this._preloader.y = FlashUtil.getCenter(this.stage.stageHeight, preloaderSize);			
		
			if (this._currContent) {	
				this._currContent.onResize();
				this.zoomout();
			}
		}
		
		//reset 
		public function reset(categoryId:int):void {
			//reset properties
			this._categoryId = categoryId;
			this._contentMap = new Object();
			
			//remove unused display object
			for (var i:uint = 0; i < this.numChildren; i++) {
				var obj:DisplayObject = this.getChildAt(i);
				if (obj != this._preloader && obj != this._cursor) {
					this.removeChildAt(i);
				}
			}	
			
			this._currContent = null;
			this._prevContent = null;
		}
		
		//zoom in
		public function zoomin():void {
			this._zoomin = true;
			this._currContent.zoomin();

			this._cursor.gotoAndStop(CURSOR_MINUS);
			this.dispatchEvent(new Event(ZOOM_IN));
		}
		
		//zoom out
		public function zoomout():void {
			this._zoomin = false;
			this._currContent.zoomout();

			this._cursor.gotoAndStop(CURSOR_PLUS);
			this.dispatchEvent(new Event(ZOOM_OUT));	
		}
		
		//set category id
		public function set categoryId(id:int):void {
			this._categoryId = id;
		}
		
		//load content 
		public function loadAndStore(id:int, categoryId:int, contentPath:String):void {
			if (categoryId == this._categoryId) {
				var key:String = categoryId + "_" + id;
				if (!this._contentMap[key]) {	
					//load content
					var loader:CustomLoader = new CustomLoader(id, categoryId);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, storeContent);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.load(new URLRequest(contentPath));		
				}		
				else {
					this.dispatchEvent(new Event(CONTENT_STORED));				
				}
			}
		}	
		
		//store content in map
		private function storeContent(event:Event):void {
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var loader:CustomLoader = CustomLoader(loaderInfo.loader);

			if (loader.categoryId == this._categoryId) {
				var contentContainer:ContentContainer = new ContentContainer(loaderInfo.content);
				contentContainer.addEventListener(MouseEvent.CLICK, onSlideClick);	
				this._contentMap[loader.key] = contentContainer;			
				
				this.dispatchEvent(new Event(CONTENT_STORED)); 
			}
		}
		
		//load main content
		public function loadIndexContent(id:int, categoryId:int, contentPath:String):void {
			if (categoryId == this._categoryId) {
				var key:String = categoryId + "_" + id;
				if (this._contentMap[key]) {		
					this.displayContent(key);
				}
				else {								
					//load new content
					//set preloader to front
					this._preloader.visible = true;
					this.setChildIndex(this._preloader, this.numChildren - 1);
					
					//load new content
					var loader:CustomLoader = new CustomLoader(id, categoryId);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.load(new URLRequest(contentPath));	
				}
			}
		}
		
		//on content load complete handler
		protected override function onLoadComplete(event:Event):void {
			//add loaded content
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var loader:CustomLoader = CustomLoader(loaderInfo.loader);
			
			if (loader.categoryId == this._categoryId) {
				var contentContainer:ContentContainer = new ContentContainer(loaderInfo.content);		
				contentContainer.addEventListener(MouseEvent.CLICK, onSlideClick);	
				this._contentMap[loader.key] = contentContainer; 
				
				this.dispatchEvent(new Event(CONTENT_STORED)); 
			
				//display content 
				this.displayContent(loader.key);
			}
			
			this._preloader.visible = false;
		}

		//display current content		
		private function displayContent(key:String):void {		
			//dispatch loaded event
			dispatchEvent(new Event(MasterSlide.CONTENT_LOADED));	
			
			//add content
			this._prevContent = this._currContent;	
			this._currContent = this._contentMap[key];
			this._currContent.x = FlashUtil.getCenter(this.stage.stageWidth,  this._currContent.width);
			this._currContent.y = FlashUtil.getCenter(this.stage.stageHeight, this._currContent.height);
			this._currContent.alpha = 0;			
			this.addChild(this._currContent);
		
			this.setChildIndex(this._cursor, this.numChildren - 1);		

			//set zoomin/zoomout
			if (this._zoomin) {	
				this._currContent.zoomin(false);
			}
			else {
				this._currContent.zoomout(false);
			}

			//peform transition			
			if (this._prevContent) {
				Tweener.addTween(this._prevContent, {alpha:0, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE,
								onComplete:removePrevContent});	
			}
			
			Tweener.addTween(this._currContent, {alpha:1, delay:0.25, 
								time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE, onComplete:cleanup});	
			
			//play external swf				 
			this.startSWF();				 				
		}
		
		//remove previous content
		protected function removePrevContent():void {
			if (this._prevContent && this.contains(this._prevContent)) {
				this.removeChild(this._prevContent);
			}	
		}
		
		//cleanup unused display object
		protected override function cleanup():void {
			for (var i:uint = 0; i < this.numChildren; i++) {
				var obj:DisplayObject = this.getChildAt(i);
				if (obj != this._currContent && obj != this._preloader && obj != this._cursor) {
					this.removeChildAt(i);
				}
			}	
		}
		
		//on slide click handler
		private function onSlideClick(event:MouseEvent):void {
			this._zoomin = !this._zoomin;
			var contentContainer:ContentContainer = ContentContainer(event.currentTarget);
			
			if (this._zoomin) {
				contentContainer.zoomin();
				this._cursor.gotoAndStop(CURSOR_MINUS);
				this.dispatchEvent(new Event(ZOOM_IN));
			}
			else {
				contentContainer.zoomout();
				this._cursor.gotoAndStop(CURSOR_PLUS);
				this.dispatchEvent(new Event(ZOOM_OUT));
			}
		}	

		//on slide mouse over handler
		protected override function onSlideOver(event:MouseEvent):void {
			this._cursor.x = event.stageX + CURSOR_XOFFSET;
			this._cursor.y = event.stageY - this._cursor.height;
			Tweener.addTween(this._cursor, {alpha:1,
								time:0.25, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on slide mouse out handler
		protected override function onSlideOut(event:MouseEvent):void {
			Tweener.addTween(this._cursor, {alpha:0,
								time:0.25, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//on slide move handler	
		protected override function onSlideMove(event:MouseEvent):void {
			Tweener.addTween(this._cursor, {x:event.stageX + CURSOR_XOFFSET, y:event.stageY - this._cursor.height,
								time:0.50, transition:FlashUtil.TRANSITION_TYPE});	
		}
		
		//start external swf		
		private function startSWF():void {
			var mc:DisplayObject = this._currContent.content;
			if (mc is MovieClip) {
				try {	
					MovieClip(mc).gotoAndPlay(1);
				}
				catch (e:Error) {
					trace(e.message);
				}
			}							
		}
		
		//on IO Error event handler
		protected override function onIOError(event:IOErrorEvent):void {
			trace(event.text);
		}
		
		protected override function initContentMask(obj:Sprite, maskWidth:Number, maskHeight:Number):void {
			//override, do nothing
		}
		
		protected override function initBackground():void {
			//override, do nothing
		}
		
		//init preloader symbol
		protected override function initPreloader(color:uint, size:Number):void {
			this._preloader = new PreloaderArrow();
			this._preloader.height = size;
			this._preloader.scaleX = this._preloader.scaleY;
			FlashUtil.setColor(this._preloader, color);

			this._preloader.x = FlashUtil.getCenter(this._areaWidth, size);
			this._preloader.y = FlashUtil.getCenter(this._areaHeight, size);
			this.addChild(this._preloader);
		}
	}
}