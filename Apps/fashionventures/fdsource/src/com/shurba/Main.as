package com.shurba {	
	import com.shurba.fashionventures.ApplicationFacade;
	import com.shurba.fashionventures.view.components.ControlBar;
	import com.shurba.fashionventures.view.components.ScrollBar;
	import com.shurba.fashionventures.view.components.Spinner;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.GraphicsUtil;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author Michael Pavlov
	 */
	[Frame(factoryClass="com.shurba.Preloader")]
	public class Main extends Sprite {
		
		public var spinner:Spinner;
		public var splashScrim:Sprite;
		public var background:Shape;
		public var controlBar:ControlBar;
		
		public var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public var scrollBar:ScrollBar;

		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initializeStage();
			initializeBackground();
			initializeViews();
			
			facade.startup(this);
		}
		
		private function initializeStage():void {
			new ApplyStandartOptions(this);
		}
		
		private function initializeBackground():void {
			background = GraphicsUtil.createGradientBox(stage.stageWidth, stage.stageHeight, [0x44009BCC, 0xFFFFFF]);
			addChild(background);
			background.alpha = 0.5;
		}
		
		private function initializeViews():void {
			controlBar = new ControlBar();
			addChild(controlBar);
			
			controlBar.x = 300;
			controlBar.y = 30;
			
			scrollBar = new ScrollBar();
			addChild(scrollBar);
			scrollBar.x = 230;
			scrollBar.y = 400;
			scrollBar.width = 500;
		}
		
		public function showPreloader():void {
			splashScrim = new Sprite();
			splashScrim.graphics.beginFill(0x000000, 0.3);
			splashScrim.graphics.moveTo(0, 0);
			splashScrim.graphics.lineTo(stage.stageWidth, 0);
			splashScrim.graphics.lineTo(stage.stageWidth, stage.stageHeight);
			splashScrim.graphics.lineTo(0, stage.stageHeight);
			splashScrim.graphics.endFill();
			this.addChild(splashScrim);
			splashScrim.buttonMode = true;
			splashScrim.useHandCursor = false;
			spinner = new Spinner(this, 700, 40, 0x666666, 3);
			spinner.play();
		}
		
		public function hidePreloader():void {
			removeChild(splashScrim);
			removeChild(spinner);
			spinner.destroy();
			splashScrim = null;
			spinner = null;
		}

	}

}