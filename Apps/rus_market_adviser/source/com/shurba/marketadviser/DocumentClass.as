package com.shurba.marketadviser {
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private const XML_PATH:String = "market_adviser.xml";
		
		//public var tabBar:TabBar;
		public var xmlLoader:XMLLoader;
		public var linkBuilder:LinkBuilder;
		
		public var selectedTab:String;
		
		public var parsedData:MarketsVO;
		
		public var tabNavigator:TabNavigator;
		private var container:ScrollPane;
		
		public function DocumentClass() {
			super();
			if (stage) {
				this.init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
			new ApplyStandartOptions(this);			
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			selectedTab = MarketsVO.MICEX;
			
			container = new ScrollPane();
			this.addChild(container);
			
			container.x = 115;
			container.y = 56;			
			container.width = 240;
			container.height = 165;
			
			container.verticalScrollPolicy = ScrollPolicy.AUTO;
			//this.addChild(linkBuilder);
			
			
			xmlLoader = new XMLLoader(XML_PATH, xmlLoaded);
			linkBuilder = new LinkBuilder();
			
			container.source = linkBuilder;
			linkBuilder.x = 5;
			linkBuilder.y = 5;
			linkBuilder.addEventListener(Event.COMPLETE, linkBuilderCompleteHandler, false, 0, true);
			tabNavigator.addEventListener(Event.CHANGE, tabBarChangeHandler, false, 0, true);
		}
		
		private function linkBuilderCompleteHandler(e:Event):void {
			container.update();
		}
		
		private function tabBarChangeHandler(e:Event = null):void {
			selectedTab = (tabNavigator.selectedTab as Object).labelName.toLowerCase();
			this.assignData();
		}
		
		private function assignData():void {
			switch (selectedTab) {
				case (MarketsVO.COMMODITIES) : {
					linkBuilder.dataProvider = parsedData.commodities;
					break;
				}
				case (MarketsVO.FOREX) : {
					linkBuilder.dataProvider = parsedData.forex;
					break;
				}
				case (MarketsVO.INDEX) : {
					linkBuilder.dataProvider = parsedData.index;
					break;
				}
				case (MarketsVO.MICEX) : {
					linkBuilder.dataProvider = parsedData.micex;
					break;
				}
			}
			
		}
		
		
		
		private function xmlLoaded($xml:XML):void {			
			var xList:XMLList = $xml.children();
			parsedData = new MarketsVO();
			var tmpXList:XMLList;
			var j:int = 0;
			for (var i:int = 0; i < xList.length(); i++) {
				switch (xList[i].@name.toLowerCase()) {
					
					case (MarketsVO.COMMODITIES) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							parsedData.commodities.push(new MarketItemVO(tmpXList[j]))
						}
						
						break;
					}
					case (MarketsVO.FOREX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							parsedData.forex.push(new MarketItemVO(tmpXList[j]))
						}
						break;
					}
					case (MarketsVO.INDEX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							parsedData.index.push(new MarketItemVO(tmpXList[j]))
						}
						break;
					}
					case (MarketsVO.MICEX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							parsedData.micex.push(new MarketItemVO(tmpXList[j]))
						}
						break;
					}
				}
				
			}
			
			this.tabBarChangeHandler();
			//this.assignData();
			
		}
		
		
		
	}
	
	

}