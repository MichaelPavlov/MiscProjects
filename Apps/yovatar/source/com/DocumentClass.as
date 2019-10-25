package com {
	
	import com.data.DataHolder;
	import com.data.DataLoader;
	import com.UI.AdviceDialog;
	import com.UI.CreateAvatarWindow;
	import com.UI.LobbyScreen;
	import com.UI.InfoBox;;
	import com.UI.Preloader;
	import com.UI.TipsBar;
	import com.utils.LogWindow;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import gs.TweenLite;
	
	
	public class DocumentClass extends MovieClip {
		
		public var lobbyScreen:LobbyScreen;
		public var createAvatarWindow:CreateAvatarWindow;
		public var mcPreloader:Preloader;
		private var tipBar:TipsBar;
		private var logger:LogWindow;
		private var adviceDialog:AdviceDialog;
		private var infoBox:InfoBox;
		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function DocumentClass() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.loaderInfo.addEventListener(Event.INIT, startPreloader);
		}
		
		private function startPreloader($event:Event):void {			
			mcPreloader = new Preloader(onLoadComplete);
			this.addChild(mcPreloader);
			mcPreloader.start();
		}
		
		private function onLoadComplete():void {
			this.removeChild(mcPreloader);
			mcPreloader = null;
			this.gotoAndStop("main");
			lobbyScreen = new LobbyScreen();
			this.addChild(lobbyScreen);
			lobbyScreen.x = 0;
			this.setupTipBar();
			lobbyScreen.addEventListener("lobbyDone", lobbyDoneHandler);	
		}
		
		private function lobbyDoneHandler($event:Event):void {			
			lobbyScreen.removeEventListener("lobbyDone", lobbyDoneHandler);
			
			this.removeChild(lobbyScreen);
			lobbyScreen = null;
			createAvatarWindow = new CreateAvatarWindow();
			var tipDepth:int = this.getChildIndex(tipBar);			
			this.addChildAt(createAvatarWindow, tipDepth);			
			createAvatarWindow.x = 0
			createAvatarWindow.y = -createAvatarWindow.height;
			new TweenLite(createAvatarWindow, 0.5, { "y":0 } );
			
			if (dataHolder.gender == DataHolder.GENDER_MALE) {
				new DataLoader(DataHolder.URL_MALE_DATA, onDataLoad);
			} else if (dataHolder.gender == DataHolder.GENDER_FEMALE) {
				new DataLoader(DataHolder.URL_FEMALE_DATA, onDataLoad);
			}
			tipBar.setState(TipsBar.CREATE_AVATAR_STATE);
		}
		
		private function onDataLoad():void {
			if (DataHolder.DEBUG_MODE) {
				//this.addLogger();
				//logger.logThis(dataHolder.assetsData.toString());
			}			
			createAvatarWindow.onDataReady();
		}
		
		private function addLogger():void {
			logger = new LogWindow();
			this.addChild(logger);
		}
		
		private function setupTipBar():void {
			tipBar = new TipsBar();
			this.addChild(tipBar);
			tipBar.y = this.height - tipBar.height - 7;
			tipBar.x = (this.width - tipBar.width) / 2;
			tipBar.setState(TipsBar.SELECT_GENDER_STATE);
			tipBar.addEventListener("finishBtnClick", finishBtnClickHandler);
		}
		
		private function removeLogger():void {
			this.removeChild(logger);
			logger.removeListeners();
			logger = null;
		}
		
		private function initAdviceDialog():void {
			adviceDialog = new AdviceDialog();
			adviceDialog.addEventListener("okBtnClick", adviceDialogOkClickHandler);
			adviceDialog.addEventListener("cancelBtnClick", adviceDialogCancelClickHandler);			
			this.addChild(adviceDialog);
			adviceDialog.x = (this.width - adviceDialog.width) / 2;
			adviceDialog.y = -adviceDialog.height;
		}
		
		private function initInfoBox():void {
			infoBox = new InfoBox();
			//infoBox.addEventListener("okBtnClick", adviceDialogOkClickHandler);
			//infoBox.addEventListener("cancelBtnClick", adviceDialogCancelClickHandler);			
			this.addChild(infoBox);
			infoBox.x = (this.width - infoBox.width) / 2;
			infoBox.y = -infoBox.height;
		}
		
		private function showAdviceDialog():void {			
			TweenLite.to(adviceDialog, 0.25, { "y":188 } );
		}
		
		private function hideAdviceDialog():void {			
			TweenLite.to(adviceDialog, 0.25, { "y": -adviceDialog.height } );
		}
		
		private function showInfoBox():void {			
			TweenLite.to(infoBox, 0.25, { "y":115 } );
		}
		
		private function hideInfoBox():void {			
			TweenLite.to(infoBox, 0.25, { "y": -adviceDialog.height } );
		}
		
		private function finishBtnClickHandler($event:Event):void {
			if (adviceDialog == null) {				
				this.initAdviceDialog();				
			}
			
			adviceDialog.y = -adviceDialog.height;
			this.showAdviceDialog();
		}
		
		private function adviceDialogOkClickHandler($event:Event):void {
			if (infoBox == null) {				
				this.initInfoBox();				
			}			
			this.hideAdviceDialog();
			this.showInfoBox();
		}
		
		private function adviceDialogCancelClickHandler($event:Event):void {
			this.hideAdviceDialog();
		}
		
	}
}