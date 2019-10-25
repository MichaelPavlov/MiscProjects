package com.webtako.flash {	
	import caurina.transitions.Tweener;
	
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	public class HGallery extends MovieClip {
		public static const DEFAULT_DELAY:Number = 5;
		public static const SETTINGS_NAME:String = "gallerySettings";
							
		private var _timer:Timer;
		private var _delay:Number;	
		private var _rotateMode:Boolean;
		private var _autoStart:Boolean;
		private var _random:Boolean;
		private var _prevIndex:Number;
		private var _currentIndex:Number;	
		private var _loadIndex:uint;
		private var _thumbLoadIndex:uint;
		private var _thumbs:Array;			
		private var _thumbWidth:Number;
		private var _thumbHeight:Number;
		private var _thumbColor:uint;		
		private var _thumbMouseoverColor:uint;
		private var _thumbBgColor:uint;
		private var _thumbPreloaderSize:Number;
		private var _thumbFrameSize:Number;
		private var _displayThumbNum:Boolean;	
		private var _cpTextSize:Number;
		private var _cpColor:uint;
		private var _cpMouseoverColor:uint;
		private var _cpBgColor:uint;
		private var _cpBgAlpha:Number;
		private var _cpHeight:Number;
		private var _menuWidth:Number;					
		private var _preloaderColor:uint;
		
		private var _mainSlide:MasterSlide;
		private var _background:Sprite;		
		private var _tooltip:Tooltip;	
		private var _backButton:ArrowButton;
		private var _fwdButton:ArrowButton;	
		private var _textPanel:TextPanel;		
		private var _thumbPanel:ThumbPanel;
		private var _controlPanel:ControlPanel;
		private var _menu:Menu;
		private var _infoField:TextField;
		private var _playPauseButton:ControlButton;
		private var _timerBar:TimerBar;
		private var _thumbPanelButton:ControlButton;		
		private var _categoryPath:String;
		private var _delta:Number;
		private var _settings:SharedObject
		private var _displayPreview:Boolean;		

		private var _thumbPanelXML:XMLList;
		private var _buttonDataXML:XMLList;
		private var _tooltipDataXML:XMLList;
		
		public function HGallery() {				
			//init stage
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//get settings
			this._settings = SharedObject.getLocal(SETTINGS_NAME);

			//get flashvar
			var configPath:String = "modules/mod_xmlswf_vm_powerplay/config.xml";
			this._categoryPath 	  = "modules/mod_xmlswf_vm_powerplay/categories.xml";
			
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			
			if (paramObj["configpath"]) {
				configPath = String(paramObj["configpath"]);
			}			
			if (paramObj["categorypath"]) {
				this._categoryPath = String(paramObj["categorypath"]);
			}
			
			//load config xml
			var configLoader:URLLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, processConfigXML); 
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			configLoader.load(new URLRequest(configPath));		 		 
		}
				
		//process config XML
		private function processConfigXML(event:Event):void {
			var loader:URLLoader = URLLoader(event.currentTarget);
			
			if (loader.data) {
				//set global properties
				var globalDataXML:XML  = XML(loader.data);				
				var bgColor:uint = 		 	 FlashUtil.getUintParam(globalDataXML.@bgColor, 0x000000);	
				var gradientColor:uint =	 FlashUtil.getUintParam(globalDataXML.@gradientColor, bgColor);		
				this._rotateMode =			 FlashUtil.getBooleanParam(globalDataXML.@rotateMode, true);
				this._autoStart =			 FlashUtil.getBooleanParam(globalDataXML.@autoStart, true);
				this._random =		 		 FlashUtil.getBooleanParam(globalDataXML.@random, false);
				this._preloaderColor = 		 FlashUtil.getUintParam(globalDataXML.@preloaderColor, 0x0066FF);															
				var preloaderSize:Number = 	 FlashUtil.getNumberParam(globalDataXML.@preloaderSize, 34);
				
				//set delay
				this._delay =				 FlashUtil.getNumberParam(globalDataXML.@delay, DEFAULT_DELAY);
				if (this._delay <= 0) {
					this._delay = DEFAULT_DELAY;
				}
				this._delay = FlashUtil.secondsToMilliseconds(this._delay);
								
				//set thumbnail properties
				var thumbDataXML:XMLList = 		globalDataXML.thumbnail;				
				this._thumbWidth =  			FlashUtil.getNumberParam(thumbDataXML.@width, 100);
				this._thumbHeight =		 		FlashUtil.getNumberParam(thumbDataXML.@height, 50);
				this._thumbColor =				FlashUtil.getUintParam(thumbDataXML.@color, 0x000000);		
				this._thumbMouseoverColor = 	FlashUtil.getUintParam(thumbDataXML.@mouseoverColor, 0x0066FF);
				this._thumbBgColor =			FlashUtil.getUintParam(thumbDataXML.@bgColor, 0x000000);
				this._thumbPreloaderSize = 		FlashUtil.getNumberParam(thumbDataXML.@preloaderSize, 24);
				this._thumbFrameSize =	  		FlashUtil.getNumberParam(thumbDataXML.@frameSize, 1);
				this._displayThumbNum = 		FlashUtil.getBooleanParam(thumbDataXML.@displayNumber, false);	
				
				//set text panel properties
				var textDataXML:XMLList = 		globalDataXML.textpanel;	
				var textSize =			 		FlashUtil.getNumberParam(textDataXML.@textSize, 12);
				var textAlign:String =			FlashUtil.getStringParam(textDataXML.@textAlign, TextFormatAlign.LEFT).toLowerCase();
				var textColor:uint =			FlashUtil.getUintParam(textDataXML.@textColor, 0xFFFFFF);
				var textPanelColor:uint = 		FlashUtil.getUintParam(textDataXML.@bgColor, 0x333333);
				var textPanelBgAlpha:Number =	FlashUtil.getNumberParam(textDataXML.@bgAlpha, FlashUtil.DEFAULT_ALPHA);		
				
				//set control panel properties
				var cpanelDataXML:XMLList = 	globalDataXML.controlpanel;
				this._cpTextSize = 				FlashUtil.getNumberParam(cpanelDataXML.@textSize, 12);
				this._cpColor =					FlashUtil.getUintParam(cpanelDataXML.@color, 0xFFFFFF);
				this._cpMouseoverColor = 		FlashUtil.getUintParam(cpanelDataXML.@mouseoverColor, 0x0066FF);
				this._cpBgColor = 				FlashUtil.getUintParam(cpanelDataXML.@bgColor, 0x333333);
				this._cpBgAlpha =				FlashUtil.getNumberParam(cpanelDataXML.@bgAlpha, FlashUtil.DEFAULT_ALPHA);
				this._menuWidth =				FlashUtil.getNumberParam(cpanelDataXML.@menuWidth, MenuItem.ITEM_WIDTH);
				
				//set other xml list
				this._buttonDataXML =			globalDataXML.button;
				this._thumbPanelXML = 			globalDataXML.thumbpanel;							
				this._tooltipDataXML =			globalDataXML.tooltip;
				
				//init background
				this.initBackground(bgColor, gradientColor);
				
				//init tool tip
				this.initTooltip();
				
				//init text panel
				this._textPanel = new TextPanel(this.stage.stageWidth, this.stage.stageHeight, TextPanel.TEXT_MARGIN, textSize, 
												textAlign, textColor, textPanelColor, textPanelBgAlpha);
				this.addChild(this._textPanel);
				
				//init thumbnails panel	
				this.initThumbPanel();
				
				//init main slide's control panel
				this.initControlPanel();
				
				//init directional buttons
				this.initDirectionalButtons();
				
				//init main slide
				this._mainSlide = new MasterSlide(this.stage.stageWidth, this.stage.stageHeight, this._preloaderColor, preloaderSize);		
				this._mainSlide.addEventListener(MasterSlide.CONTENT_LOADED, startTimer);
				this._mainSlide.addEventListener(MasterSlide.ZOOM_IN, onZoomIn);
				this._mainSlide.addEventListener(MasterSlide.ZOOM_OUT, onZoomOut);
				this._mainSlide.alpha = 0;
				this.addChildAt(this._mainSlide, 1);		
				
				this.setChildIndex(this._tooltip, this.numChildren - 1);				
	
				//process category XML
				var categoryLoader:URLLoader = new URLLoader();
				categoryLoader.addEventListener(Event.COMPLETE, processCategoryXML);
				categoryLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				categoryLoader.load(new URLRequest(this._categoryPath));	
			}	
			else {
				trace("No Config Data");
			}
		}
		
		//process category XML
		private function processCategoryXML(event:Event):void {
			var loader:URLLoader = URLLoader(event.currentTarget);			
			if (loader.data) {
				var dataXML:XML = XML(loader.data);
				var categoryIndex:uint = 0;
				var menuItems:Array = new Array();				
				
				//process and add menu items
				for each (var item:XML in dataXML.category) {	
					var menuItem:MenuItem = new MenuItem(item.childIndex(), item.@title, item.@path, 
														this._menuWidth, this._cpHeight, this._cpTextSize, 
														this._cpColor, this._cpMouseoverColor, this._cpBgColor, this._cpBgAlpha);	
					menuItem.addEventListener(MouseEvent.CLICK, selectCategory);
					menuItems.push(menuItem);
				}	
				
				if (this._settings.data.category != undefined) {
					categoryIndex = this._settings.data.category;
					if (!menuItems[categoryIndex]) {
						categoryIndex = 0;
					}
				}
				
				//init and add menu
				this._menu = new Menu(menuItems, this._menuWidth, this._cpHeight, this._cpTextSize, 
														this._cpColor, this._cpMouseoverColor, this._cpBgColor, categoryIndex);	
				this._controlPanel.addMenu(this._menu);
						
				//load category's data
				if (menuItems.length > 0 && categoryIndex >= 0 && categoryIndex < menuItems.length) {
					this._mainSlide.categoryId = categoryIndex;
					
					var dataLoader:URLLoader = new URLLoader(); 
					dataLoader.addEventListener(Event.COMPLETE, processDataXML); 	
					dataLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);			
					dataLoader.load(new URLRequest(menuItems[categoryIndex].path));
				}
			}	
			else {
				trace("No Category Data");
			}			
		}
		
		//process data xml
		private function processDataXML(event:Event):void {
			this._currentIndex = 0;
			this._prevIndex = -1;
			
			var loader:URLLoader = URLLoader(event.currentTarget);				
			if (loader.data) {	
				var xmlData:XML = XML(loader.data);					
				var slideList:XMLList = xmlData.slide;
				var numSlides:int = slideList.length();
				
				if (numSlides == 0) {
					trace("No Slide Data");
					return;
				}
				
				//init each slide from xml and create thumbnails
				this._thumbs = new Array();
				for each (var item:XML in xmlData.slide) {		
					var extPath:String =  item.@path;
					var thumbnailPath:String = item.@thumbPath;
					var caption:String = item.caption;
					var description:String = item.description;					
					var delay:Number = FlashUtil.getNumberParam(item.@delay, Math.round(this._delay/1000));					
					delay = FlashUtil.secondsToMilliseconds(delay);
					
					var thumbnail:Slide = new Slide(caption, description, thumbnailPath, extPath, 
												this._thumbWidth, this._thumbHeight, 
												this._thumbBgColor, this._thumbColor, this._thumbMouseoverColor, 
												this._preloaderColor, this._thumbPreloaderSize,
												this._thumbFrameSize, delay);												
					thumbnail.tooltip = this._tooltip;
					if (this._displayThumbNum) {
						thumbnail.displayNumber = true;
					}
					//add event listeners
					thumbnail.addEventListener(Slide.SLIDE_LOADED, loadThumb);
					thumbnail.addEventListener(MouseEvent.CLICK, onThumbClick);
					this._thumbs.push(thumbnail);		
				}
				
				//shuffle thumbnails
				if (this._random) {
					this._thumbs = FlashUtil.shuffleArray(this._thumbs);
				}
				
				//init thumb pane
				this._thumbPanel.initThumbPane(this._thumbs);

				//enable control panel
				this._thumbPanel.mouseChildren = true;				

				//show main slide
				Tweener.addTween(this._mainSlide, {alpha:1.0, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
				
				//show preview container
				Tweener.addTween(this._thumbPanel, {alpha:1.0, time:FlashUtil.TRANSITION_TIME, transition:FlashUtil.TRANSITION_TYPE});	
				
				//init load
				this.initLoad();
				
				//add event listeners
				this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheelScroll);
				this.stage.addEventListener(Event.RESIZE, onStageResize);
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);	
				
				//init rotate timer
				if (this._rotateMode && !this._timer) {
					this._timer = new Timer(this._delay);
					this._timer.addEventListener(TimerEvent.TIMER, rotateSlide);	
				}
			}
			else {
				trace("No Data");
			}	
		}	
		
		//init background
		private function initBackground(bgColor:uint, gradientColor:uint):void {
			this._background = new Sprite();
			if (bgColor == gradientColor) {
				this._background.graphics.beginFill(bgColor);					
			}
			else {
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, Math.PI/2, 0, 0);
				this._background.graphics.beginGradientFill(GradientType.LINEAR, [bgColor, gradientColor], [1, 1], [0, 255], matrix, SpreadMethod.PAD);
			}
			this._background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this._background.graphics.endFill();
			this.addChildAt(this._background, 0);			
		}

		//init control panel
		private function initControlPanel():void {
			//init text format						
			var textFormat:TextFormat = new TextFormat();
			//textFormat.font =  FlashUtil.getInstance().TEXT_FONT1.fontName;
			textFormat.size =  this._cpTextSize;
			textFormat.color = this._cpColor;	
			textFormat.align = TextFormatAlign.CENTER;	

			//init info field						
			var txtHolder:TextFieldHolder = new TextFieldHolder();
			this._infoField = txtHolder.TXT;
			this._infoField.defaultTextFormat = textFormat;
			this._infoField.selectable = false;
			this._infoField.multiline = false;
			this._infoField.wordWrap = false;	
			this._infoField.embedFonts = true;
			this._infoField.antiAliasType = AntiAliasType.ADVANCED;			
			this._infoField.text = " -- / -- ";	
			this._infoField.autoSize = TextFieldAutoSize.LEFT;		
			
			//assign height value
			this._cpHeight = (ControlPanel.CPANEL_HEIGHT >= this._infoField.height) ? ControlPanel.CPANEL_HEIGHT : this._infoField.height;

			if (this._rotateMode) {
				//init play/pause button
				this._playPauseButton = new ControlButton(new PlayPauseSymbol(), this._cpHeight, this._cpHeight,
															this._cpColor, this._cpMouseoverColor, this._cpBgColor, 0, ControlButton.ON); 
				if (!this._autoStart) {
					this._playPauseButton.state = ControlButton.OFF;
				} 
				this._playPauseButton.addEventListener(MouseEvent.CLICK, onPlayPause);	
				
				//init timer bar
				this._timerBar = new TimerBar(TimerBar.TIMERBAR_WIDTH, TimerBar.TIMERBAR_HEIGHT, this._cpMouseoverColor, this._cpColor, this._cpBgAlpha);
				this._timerBar.addEventListener(MouseEvent.CLICK, onPlayPause);
			}
			
			//init thumb panel button
			this._thumbPanelButton = new ControlButton(new PlusMinusSymbol(), this._cpHeight, this._cpHeight, 
														this._cpColor, this._cpMouseoverColor, this._cpBgColor, 0);
			this._thumbPanelButton.addEventListener(MouseEvent.CLICK, toggleThumbPanel);
			
			//init control panel
			this._controlPanel = new ControlPanel(this.stage.stageWidth, this._cpHeight, this._cpBgColor, this._cpBgAlpha);
			this._controlPanel.addInfoField(this._infoField);
			if (this._rotateMode) {
				this._controlPanel.addPlayButton(this._playPauseButton);	
				this._controlPanel.addTimerBar(this._timerBar);		
			}
			this._controlPanel.addThumbPanelButton(this._thumbPanelButton);
			this._controlPanel.x = 0;
			this._controlPanel.y = this._thumbPanel.y - this._controlPanel.height;
			this._controlPanel.yOffset = this._thumbPanel.panelHeight;			
			this.addChild(this._controlPanel);
		}
		
		//init thumb panel
		private function initThumbPanel():void {						
			//get config properties
			var color:uint = 			FlashUtil.getUintParam(this._thumbPanelXML.@color, 0x000000);
			var mouseoverColor:uint =  	FlashUtil.getUintParam(this._thumbPanelXML.@mouseoverColor, 0x0066FF);
			var bgColor:uint = 		 	FlashUtil.getUintParam(this._thumbPanelXML.@bgColor, 0xCCCCCC);
			var gradientColor:uint = 	FlashUtil.getUintParam(this._thumbPanelXML.@gradientColor, bgColor);
			var bgAlpha:Number =		FlashUtil.getNumberParam(this._thumbPanelXML.@bgAlpha, 1);
			var margin:Number = 		FlashUtil.getNumberParam(this._thumbPanelXML.@margin, 5);
			var gap:Number =			FlashUtil.getNumberParam(this._thumbPanelXML.@gap, 5);	
			this._thumbPanelXML = null;
						
			//init and add thumb panel
			this._thumbPanel = new ThumbPanel(this.stage.stageWidth, this._thumbHeight + (2 * margin), 
												this._thumbWidth, this._thumbHeight, gap, 
												color, mouseoverColor, bgColor, gradientColor, bgAlpha);			
			this._thumbPanel.x = FlashUtil.getCenter(this.stage.stageWidth, this._thumbPanel.width);
			this._thumbPanel.y = this.stage.stageHeight - this._thumbPanel.height;
			this.addChild(this._thumbPanel);
		}
		
		//init directional buttons
		private function initDirectionalButtons():void {
			var buttonWidth:Number =	FlashUtil.getNumberParam(this._buttonDataXML.@width, 20);
			var buttonHeight:Number = 	FlashUtil.getNumberParam(this._buttonDataXML.@height, 70);
			var color:uint = 	   		FlashUtil.getUintParam(this._buttonDataXML.@color, 0xFFFFFF);
			var mouseoverColor:uint = 	FlashUtil.getUintParam(this._buttonDataXML.@mouseoverColor, 0x0066FF);
			var bgColor:uint = 		 	FlashUtil.getUintParam(this._buttonDataXML.@bgColor, 0x333333);	
			var bgAlpha:Number =		FlashUtil.getNumberParam(this._buttonDataXML.@bgAlpha, FlashUtil.DEFAULT_ALPHA);
			var panelColor:uint =		FlashUtil.getUintParam(this._buttonDataXML.@panelColor, 0x000000);							
			this._displayPreview =		FlashUtil.getBooleanParam(this._buttonDataXML.@displayPreview, true);
			this._buttonDataXML = null;
			
			//init back button
			this._backButton = new ArrowButton(ArrowButton.BACK, color, mouseoverColor, bgColor, bgAlpha, panelColor,
												buttonWidth, buttonHeight);			
			this._backButton.addEventListener(MouseEvent.CLICK, onBackButtonClick);
			if (this._displayPreview) {
				this._backButton.previewSlide = new PreviewSlide(PreviewSlide.PREV_LABEL, this._thumbWidth, this._thumbHeight, this._thumbBgColor, 
													this._thumbColor, this._thumbMouseoverColor, this._preloaderColor, this._thumbPreloaderSize);
				this._backButton.previewSlide.tooltip = this._tooltip;
			}
			this._backButton.x = 0;
			this._backButton.y = FlashUtil.getCenter(this.stage.stageHeight, this._backButton.buttonHeight);
			this.addChild(this._backButton);
			
			//init forward button
			this._fwdButton = new ArrowButton(ArrowButton.FORWARD, color, mouseoverColor, bgColor, bgAlpha, panelColor,
												buttonWidth, buttonHeight);				
			this._fwdButton.addEventListener(MouseEvent.CLICK, onFwdButtonClick);	
			if (this._displayPreview) {
				this._fwdButton.previewSlide =  new PreviewSlide(PreviewSlide.NEXT_LABEL, this._thumbWidth, this._thumbHeight, this._thumbBgColor, 
													this._thumbColor, this._thumbMouseoverColor, this._preloaderColor, this._thumbPreloaderSize);
				this._fwdButton.previewSlide.tooltip = this._tooltip;	
			}
			this._fwdButton.x = this.stage.stageWidth - this._fwdButton.buttonWidth;
			this._fwdButton.y = FlashUtil.getCenter(this.stage.stageHeight, this._fwdButton.buttonHeight);
			this.addChild(this._fwdButton);
		}	
		
		//init tool tip
		private function initTooltip():void {
			//set properties
			var textSize:Number =			FlashUtil.getNumberParam(this._tooltipDataXML.@textSize, 12);
			var textColor:uint =			FlashUtil.getUintParam(this._tooltipDataXML.@textColor, 0xFFFFFF);		
			var bgColor:uint =				FlashUtil.getUintParam(this._tooltipDataXML.@bgColor, 0x000000);
			var bgAlpha:Number =			FlashUtil.getNumberParam(this._tooltipDataXML.@bgAlpha, FlashUtil.DEFAULT_ALPHA);
			this._tooltipDataXML = null;
			
			//init tooltip
			this._tooltip = new Tooltip("", textSize, textColor, bgColor, bgAlpha);
			this.addChild(this._tooltip);
		}
		
		//on stage resize
		private function onStageResize(event:Event):void {
			//resize background
			this._background.width = this.stage.stageWidth;
			this._background.height = this.stage.stageHeight;
			
			//text panel on resize
			this._textPanel.onResize();
			
			//directional buttons on resize
			this._backButton.onResize();
			this._fwdButton.onResize();
			
			//main slide on resize
			this._mainSlide.onResize();
			
			//control panel on resize
			this._controlPanel.onResize();
			
			//thumb panel on resize
			this._thumbPanel.onResize();			
		}
		
		//key press event handler
		private function onKeyPress(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case 32:	
				 	this.playPause();
					break;
				case 37:	
					this.moveSlideBack();
					break;
				case 38:
					this._mainSlide.zoomin();
					break;	
				case 39:	
					this.moveSlideFwd();
					break;
				case 40:
					this._mainSlide.zoomout();
					break;
			}
		}
		
		//on IO error event handler
		private function onIOError(event:IOErrorEvent):void {
			trace("IO Error: " + event.text);
		}
		
		//on mouse wheel scroll event handler
		private function onWheelScroll(event:MouseEvent):void {
			this._delta = event.delta;
			var timer:Timer = new Timer(1, 1);			
			timer.addEventListener(TimerEvent.TIMER, initMouseWheel);
			timer.start();	
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelScroll);
		}	
		
		//init mouse wheel
		private function initMouseWheel(event:TimerEvent):void {
			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheelScroll);
		}
		
		//wheel scroll
		private function wheelScroll(event:MouseEvent):void {
			if (this._delta > 0) {
				this._thumbPanel.moveThumbBack(event);
			}	
			else if (this._delta < 0) {
				this._thumbPanel.moveThumbFwd(event);
			}
		}
		
		//toggle thumb panel
		private function toggleThumbPanel(event:MouseEvent):void {
			this._thumbPanelButton.toggle();
			if (this._thumbPanel.hidden) {				
				this._controlPanel.moveUp();
				this._thumbPanel.display();
			}
			else {
				this._controlPanel.moveDown();
				this._thumbPanel.hide();				
			}
		}
		
		//on play/pause button event handler
		private function onPlayPause(event:MouseEvent):void {					
			event.stopPropagation();
			this.playPause();		
		}
		
		//on back button click event handler
		private function onBackButtonClick(event:MouseEvent):void {		
			event.stopPropagation();
			this.moveSlideBack();	
		}

		//on forward button click event handler
		private function onFwdButtonClick(event:MouseEvent):void {		
			event.stopPropagation();
			this.moveSlideFwd();	
		}
		
		//on thumbnail click event handler
		private function onThumbClick(event:MouseEvent):void {
			//stop timer
			this.stopTimer();
			
			//get thumbnail
			var thumbnail:Slide = Slide(event.currentTarget);			
			if (this._currentIndex != thumbnail.index) {
				//set indexes
				this._prevIndex = this._currentIndex;
				this._currentIndex = thumbnail.index;

				//load content
				this.loadMainContent();	
			}
		}	
		
		//play/pause
		private function playPause():void {		
			if (this._rotateMode) {	
				//switch symbol
				this._playPauseButton.toggle();	
						
				if (this._playPauseButton.state == ControlButton.ON) {	
					//play
					this._timer.reset();	
					this._timer.delay = this._delay - this._timerBar.elapseTime;
					
					if (this._timerBar.delay == 0) {
						this._timerBar.delay = this._delay;
					}
					this._timerBar.resume();	
					
					this._timer.start();			
				}
				else {	
					//pause
					this._timer.stop();
					this._timerBar.pause();
				}
			}	
		}
		
		//timer event handler		
		private function rotateSlide(event:TimerEvent):void {
			//stop timer bar
			this._timerBar.stop();
			
			//set indexes
			this._prevIndex = this._currentIndex;			
			if (this._currentIndex + 1 < this._thumbs.length) {
				this._currentIndex++;
			}
			else {
				this._currentIndex = 0;
			}
			
			this._thumbPanel.moveByRotate(this._currentIndex);
			
			//load content
			this.loadMainContent();
		}
		
		//move main slide back
		private function moveSlideBack():void {						
			//stop timer
			this.stopTimer();

			//set indexes
			this._prevIndex = this._currentIndex;								
			if (this._currentIndex > 0) {
				this._currentIndex--;
			}
			else {
				this._currentIndex = this._thumbs.length - 1;
			}	
				
			//auto move thumbnail strip
			this._thumbPanel.moveByIndex(this._currentIndex);

			//load content
			this.loadMainContent();			
		}
		
		//move main slide fwd
		private function moveSlideFwd():void {
			//stop timer
			this.stopTimer();
			
			//set indexes
			this._prevIndex = this._currentIndex;		
			if (this._currentIndex + 1 < this._thumbs.length) {
				this._currentIndex++;
			}
			else {
				this._currentIndex = 0;
			}
			
			//auto move thumbnail strip
			this._thumbPanel.moveByIndex(this._currentIndex);
			
			//load content
			this.loadMainContent();
		}
		
		//select new category
		private function selectCategory(event:MouseEvent):void {
			this._mainSlide.removeEventListener(MasterSlide.CONTENT_STORED, loadContent);
			
			var menuItem:MenuItem = MenuItem(event.currentTarget);
			
			//assign setting
			this._settings.data.category = menuItem.index;
			this._settings.flush();
			
			//reset
			if (this._timerBar) {
				this._timerBar.reset();
			}
			this._textPanel.reset();
			if (this._displayPreview) {
				this._backButton.previewSlide.reset();
				this._fwdButton.previewSlide.reset();			
			}
			this._mainSlide.reset(menuItem.index);				
						
			//load data xml
			var dataLoader:URLLoader = new URLLoader(); 
			dataLoader.addEventListener(Event.COMPLETE, processDataXML); 				
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			dataLoader.load(new URLRequest(menuItem.path));	
		}
		
		//start timer
		private function startTimer(event:Event):void {
			if (this._rotateMode && this._playPauseButton.state == ControlButton.ON) {
				this._timer.reset();
				this._timer.delay = this._delay;
				
				this._timerBar.delay = this._delay;
				
				this._timerBar.start();
				this._timer.start();	
			}
		}
		
		//stop timer
		private function stopTimer():void {
			if (this._rotateMode) {
				this._timer.stop();
				this._timerBar.stop();					
			}
		}
		
		//on zoom in event handler
		private function onZoomIn(event:Event):void {
			if (!this._thumbPanel.hidden) {
				this._controlPanel.moveDown();
				this._thumbPanel.hide();
				this._thumbPanelButton.state = ControlButton.OFF;
			}
		}
		
		//on zoom out event handler
		private function onZoomOut(event:Event):void {
			if (this._thumbPanel.hidden) {
				this._controlPanel.moveUp();
				this._thumbPanel.display();	
				this._thumbPanelButton.state = ControlButton.ON;
			}
		}
		
		//update preview slides
		private function updatePreviewSlides(index:uint):void {
			if (this._displayPreview) {
				var previousSlideIndex:uint = (index > 0) ? index - 1 : this._thumbs.length - 1;			
				var previousSlide:Slide = Slide(this._thumbs[previousSlideIndex]);
				this._backButton.previewSlide.assign(previousSlide);
	
				var nextSlideIndex:uint = (index < this._thumbs.length - 1) ? index + 1 : 0;
				var nextSlide:Slide = Slide(this._thumbs[nextSlideIndex]);			
				this._fwdButton.previewSlide.assign(nextSlide);			
			}
		}
		
		//check if preview slides are loaded
		private function checkPreviewSlides(index:uint):void {
			if (this._displayPreview) {
				if (!this._backButton.previewSlide.loaded) {
					var previousSlideIndex:uint = (this._currentIndex > 0) ? this._currentIndex - 1 : this._thumbs.length - 1;
					if (index == previousSlideIndex) {
						this._backButton.previewSlide.assign(Slide(this._thumbs[index]));
					}
				}
				
				if (!this._fwdButton.previewSlide.loaded) {
					var nextSlideIndex:uint = (this._currentIndex < this._thumbs.length - 1) ? this._currentIndex + 1 : 0;
					if (index == nextSlideIndex) {
						this._fwdButton.previewSlide.assign(Slide(this._thumbs[index]));
					}
				}
			}
		}
		
		//load main slide's content
		private function loadMainContent():void {
			//get current thumbnail
			var currThumbnail:Slide = this._thumbs[this._currentIndex];
			
			//assign thumbnail's data
			this._mainSlide.path = currThumbnail.extPath;
			this._delay = currThumbnail.delay;
			
			//update info field
			this._infoField.text = (currThumbnail.index + 1) + " / " + this._thumbs.length;
			this._infoField.autoSize = TextFieldAutoSize.LEFT;
			
			//load main slide's content
			this._mainSlide.loadIndexContent(this._currentIndex, this._menu.selectedIndex, currThumbnail.extPath);	
			
			//mark thumbnail
			var prevThumbnail:Slide = this._thumbs[this._prevIndex];
			if (prevThumbnail) {
				prevThumbnail.unhighlight();
			}	
			currThumbnail.highlight();
			
			//update preview slides
			this.updatePreviewSlides(this._currentIndex);
			
			//update text
			this._textPanel.updatePanelText(currThumbnail.description);
		}	
		
		//init of loading content
		private function initLoad():void {	
			this._mainSlide.addEventListener(MasterSlide.CONTENT_STORED, loadContent);
			this._loadIndex = 0;
			
	//		if (this._currentIndex == 0) {	
				this.loadMainContent();
	//		}
	//		else {
				//load main contents			
	//			if (this._loadIndex < this._thumbs.length) {
	//				var thumb:Slide = Slide(this._thumbs[this._loadIndex]);
	//				this._mainSlide.loadAndStore(this._loadIndex, this._menu.selectedIndex, thumb.extPath);
	//			}
	//		}			
			//load thumbs	
			this._thumbLoadIndex = 0;
			if (this._thumbLoadIndex < this._thumbs.length) {
				Slide(this._thumbs[this._thumbLoadIndex]).loadContent();
			}				
		}
		
		//load main content event handler
		private function loadContent(event:Event):void {
			this._loadIndex++;
			if (this._loadIndex < this._thumbs.length) {
				var thumb:Slide = Slide(this._thumbs[this._loadIndex]);
				this._mainSlide.loadAndStore(this._loadIndex, this._menu.selectedIndex, thumb.extPath);
			}
		}
		
		//load thumb event handler
		private function loadThumb(event:Event):void {
			this.checkPreviewSlides(this._thumbLoadIndex);
			this._thumbLoadIndex++;
			if (this._thumbLoadIndex < this._thumbs.length) {
				Slide(this._thumbs[this._thumbLoadIndex]).loadContent();	
			}
		}
		
	}
}