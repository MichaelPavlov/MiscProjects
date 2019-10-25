package com.shurba.marketadviser {
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import fl.motion.Color;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Link extends Sprite {
		
		private const BUY_COLOR:uint = 0x58A81E;
		private const HOLD_COLOR:uint = 0x4A92F7;
		private const SELL_COLOR:uint = 0xE14933;
		
		public static const URL_TO_NAVIGATE:String = "http://www.webpia.i-tt.ru/signal.html?";
		
		private var _dataProvider:MarketItemVO;
		
		public var link:TextField;
		
		[Embed(source="C:\\WINDOWS\\Fonts\\ARIAL.TTF", fontFamily="Arial")]
		private var _arial_str:String;
		
		public function Link(data:MarketItemVO = null) {
			super();
			TweenPlugin.activate([TintPlugin]);
			
			link = new TextField();
			link.mouseEnabled = false;
			link.embedFonts = true;
			link.multiline = false;
			
			var tf:TextFormat = new TextFormat("Arial", 12);			
			tf.align = TextFormatAlign.LEFT;
			
			link.defaultTextFormat = tf;
			
			this.addChild(link);
			this.buttonMode = true;
			this.addListeners();
			if (data)
				this.dataProvider = data;
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function removeListeners():void {
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			
		}
		
		private function drawColor():void {
			
			switch (dataProvider.signal.toLowerCase()) {
				case Signal.BUY : {
					TweenLite.to(this, 0, { tint:BUY_COLOR } );
					break;
				}
				
				case Signal.HOLD : {
					TweenLite.to(this, 0, { tint:HOLD_COLOR } );					
					break;
				}
				
				case Signal.SELL : {
					TweenLite.to(this, 0, { tint:SELL_COLOR } );					
					break;
				}
			}
		}
		
		public function clear():void {
			this.removeListeners();
		}
		
		private function clickHandler(e:MouseEvent):void {
			navigateToURL(new URLRequest(URL_TO_NAVIGATE + _dataProvider.code));
		}
		
		public function get dataProvider():MarketItemVO { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:MarketItemVO):void {
			_dataProvider = value;
			link.text = value.name + " " + value.signal + " " + value.trend;
			link.width = link.textWidth + 5;
			link.height = link.textHeight + 2;	
			this.drawColor();
		}
		
	}

}