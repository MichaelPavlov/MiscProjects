package com.UI {
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;	
	import gs.TweenLite;
	import com.UI.Avatar;
	
	/**
	 * ...
	 * @author ...
	 */
		
	 
	 
	public class CreateAvatarWindow extends Sprite {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();		
		
		//public var playerName:TextField;
		public var createPlayerTitle:TextField;
		public var pageOffsetDisplay:TextField;
		
		private var categoryButtonCollection:Array;
		private var itemButtonsCollection:Array;
		
		public var randomizeAllItemsButton:SimpleButton;
		public var scrollBackButton:SimpleButton;
		public var scrollNextButton:SimpleButton;
		
		public var loadingItemsPleaseWait:Sprite;
		public var itemGrid:Sprite;
		
		public var item1:ItemPreviewButton;
		public var item2:ItemPreviewButton;
		public var item3:ItemPreviewButton;
		public var item4:ItemPreviewButton;
		public var item5:ItemPreviewButton;
		public var item6:ItemPreviewButton;
		
		public var categoryButton1:CategoryButton;
		public var categoryButton2:CategoryButton;
		public var categoryButton3:CategoryButton;
		public var categoryButton4:CategoryButton;
		public var categoryButton5:CategoryButton;
		public var categoryButton6:CategoryButton;
		public var categoryButton7:CategoryButton;
		public var categoryButton8:CategoryButton;
		public var categoryButton9:CategoryButton;
		public var categoryButton10:CategoryButton;
		public var categoryButton11:CategoryButton;
		public var categoryButton12:CategoryButton;
		
		public var btnClothes:ToggleButton;
		public var btnFeatures:ToggleButton;
		
		private var avatar:Avatar;
		
		public var itemSelectionHighlight:MovieClip;
		public var avatarPreview:MovieClip;
		
		public static const ASSETS_SET_CLOTHES:Number = 3;
		public static const ASSETS_SET_APPEARANCE:Number = 1;
		private const ITEMS_PER_PAGE:Number = 6;
		
		private var currentAssetSet:int;
		private var currentPagingOffset:int = 0;
		private var currentCategoryIdSelected:int=0;
		private var lastCategoryButtonSelected:CategoryButton;
		private var currentDisplayObjects:Array = new Array();;
		
		private var itemsObject:Object;
	
		public function CreateAvatarWindow() {
			super();
			categoryButtonCollection = [categoryButton1, categoryButton2, categoryButton3, categoryButton4, categoryButton5, categoryButton6, categoryButton7, categoryButton8, categoryButton9, categoryButton10, categoryButton11, categoryButton12];
			itemButtonsCollection = [item1, item2, item3, item4, item5, item6];
			this.resetInterface();
			this.addListeners();
		}
		
		private function addListeners():void {
			scrollBackButton.addEventListener(MouseEvent.CLICK, scrollBackClickHandler);
            scrollNextButton.addEventListener(MouseEvent.CLICK, scrollNextClickHandler);
			var i:int = 0;
			for (i = 0; i < categoryButtonCollection.length; i++) {
				categoryButtonCollection[i].addEventListener(MouseEvent.CLICK, categoryClickHandler);				
			}
			for (i = 0; i < itemButtonsCollection.length; i++) {
				itemButtonsCollection[i].addEventListener(MouseEvent.CLICK, itemClickHandler);				
			}
			btnClothes.addEventListener(MouseEvent.CLICK, toggleClothes);
			btnFeatures.addEventListener(MouseEvent.CLICK, toggleFeatures);
			
			randomizeAllItemsButton.addEventListener(MouseEvent.CLICK, randomizeBtnClickHandler);
		}
		 
		private function removeListeners():void {
			scrollBackButton.removeEventListener(MouseEvent.CLICK, scrollBackClickHandler);
            scrollNextButton.removeEventListener(MouseEvent.CLICK, scrollNextClickHandler);
			var i:int = 0;
			for (i = 0; i < categoryButtonCollection.length; i++) {
				categoryButtonCollection[i].removeEventListener(MouseEvent.CLICK, categoryClickHandler);
			}
			for (i = 0; i < itemButtonsCollection.length; i++) {
				itemButtonsCollection[i].removeEventListener(MouseEvent.CLICK, itemClickHandler);
			}
			btnClothes.removeEventListener(MouseEvent.CLICK, toggleClothes);
			btnFeatures.removeEventListener(MouseEvent.CLICK, toggleFeatures);
		}
		
		public function resetInterface():void {
			var categoryBtn:CategoryButton;
			var itemBtn:ItemPreviewButton;
			var counter:int = 0
			
			while (counter < categoryButtonCollection.length) {
                categoryBtn = categoryButtonCollection[counter];				
                categoryBtn.visible = false;
                ++counter;
            }
			
			counter = 0;
			
			while (counter < itemButtonsCollection.length) {
				itemButtonsCollection[counter].ID = counter + 1;
                itemBtn = itemButtonsCollection[counter];
                itemBtn.visible = false;
                ++counter;
            }
			
			
			
			scrollBackButton.mouseEnabled = false;
            scrollBackButton.alpha = 0;
            scrollNextButton.mouseEnabled = false;
            scrollNextButton.alpha = 0;
			itemSelectionHighlight.stop();
			itemSelectionHighlight.visible = false;			
            pageOffsetDisplay.visible = false;
			randomizeAllItemsButton.mouseEnabled = true;
            //randomizeAllItemsButton.alpha = 0.5;
			itemGrid.visible = false;
            loadingItemsPleaseWait.visible = true;
			//playerName.text = dataHolder.playerName;
			createPlayerTitle.visible = false;
			//createPlayerTitle.text = "Change Your Clothing";
            btnClothes.toggleOn();
			currentAssetSet = CreateAvatarWindow.ASSETS_SET_CLOTHES;
			//savePlayer.visible = false;
            btnClothes.label = "Change Clothes"
            btnFeatures.label = "Edit Face";			
		}
		
		private function switchItemsSet($set:int):void {
			currentAssetSet = $set;
			if ($set == CreateAvatarWindow.ASSETS_SET_APPEARANCE) {
				btnClothes.toggleOff();
				btnFeatures.toggleOn();
			} else {
				btnClothes.toggleOn();
				btnFeatures.toggleOff();
			}
		}
		
		public function onDataReady():void {
			this.resetInterface();
			itemGrid.visible = true;
			pageOffsetDisplay.visible = true;
			if (avatar == null) {
				this.initAvatarPreview();
			}
			avatar.init();
			if (!avatar.hasEventListener("allPartsLoaded")) {
				avatar.addEventListener("allPartsLoaded", hidePreloader);
				avatar.addEventListener("startPreload", showPreloader);
			}
			
			this.resetButtons();
		}
		
		private function hidePreloader($event:Event):void {
			avatarPreview.visible = false;
			randomizeAllItemsButton.enabled = true;
			randomizeAllItemsButton.useHandCursor = true;
		}
		
		private function showPreloader($event:Event):void {
			avatarPreview.visible = true;
			randomizeAllItemsButton.enabled = false;
			
		}
		
		private function resetButtons():void {
			this.loadAssets();
			this.serializeCategoryButtons();
			this.updateItemDisplay();
		}
		
		private function initAvatarPreview() {			
			avatar = new Avatar();
			this.addChild(avatar);
			//dataHolder.avatarHandler = new MovieClip();
			dataHolder.avatarHandler = avatar;
			avatar.x = 65;
			avatar.y = 190;
			avatar.scaleX = 0.45;
			avatar.scaleY = 0.45;			
		}
		private function loadAssets():void {
			dataHolder.itemsObject = new Object();
			if (currentAssetSet == CreateAvatarWindow.ASSETS_SET_APPEARANCE) {
				dataHolder.itemsObject = dataHolder.getAvatarAssets([DataHolder.INVENTORY_APPEARANCE]);
			} else if (currentAssetSet == CreateAvatarWindow.ASSETS_SET_CLOTHES) {
				dataHolder.itemsObject = dataHolder.getAvatarAssets([DataHolder.INVENTORY_CLOTHING, DataHolder.INVENTORY_ACCESSORIES]);
			}
			
		}
		
		private function serializeCategoryButtons():void {			
			this.hideCategoryButtons();
			var i:int = 0;
			for (var name:String in dataHolder.itemsObject) {				
				if (i == 0) {					
					currentCategoryIdSelected = dataHolder.itemsObject[name].categoryId;
					toggleCategoryButton(currentCategoryIdSelected);
				}
				categoryButtonCollection[i].toggleOff();
				categoryButtonCollection[i].categoryId = dataHolder.itemsObject[name].categoryId;
				categoryButtonCollection[i].label = dataHolder.itemsObject[name].label;
				categoryButtonCollection[i].visible = true;
				categoryButtonCollection[i].alpha = 0;
				TweenLite.to(categoryButtonCollection[i], 0.5, { "alpha":1 } );
				i++;
			}			
		}
		
		private function hideCategoryButtons():void {
			for (var i:int = 0; i < categoryButtonCollection.length; i++) {
				categoryButtonCollection[i].visible = false;
			}
		}
		
		private function updateItemDisplay():void {
			loadingItemsPleaseWait.visible = false;
			var itemNum:int = 0;
			var currentItems:Array = dataHolder.itemsObject["category_" + currentCategoryIdSelected];
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				itemNum = i + currentPagingOffset * this.ITEMS_PER_PAGE;
				itemButtonsCollection[i].itemObject = currentItems[itemNum];				
			}
			
			var numPages:int = Math.ceil(currentItems.length / ITEMS_PER_PAGE);
            var curPage:int = currentPagingOffset + 1;
            pageOffsetDisplay.text = "Page " + curPage + " of " + numPages;
			
			this.highlightSelection(0);
			
			if (curPage <= 1) {
                scrollBackButton.mouseEnabled = false;
                scrollBackButton.alpha = 0;
            } else {
                scrollBackButton.mouseEnabled = true;
                scrollBackButton.alpha = 1;
            } if (curPage >= numPages) {
                scrollNextButton.mouseEnabled = false;
                scrollNextButton.alpha = 0;
            } else {
                scrollNextButton.mouseEnabled = true;
                scrollNextButton.alpha = 1;
            }
		}
		
		private function scrollBackClickHandler($event:MouseEvent):void {
			currentPagingOffset--;
            this.updateItemDisplay();
		}
		
		private function scrollNextClickHandler($event:MouseEvent):void {
			currentPagingOffset++;
            this.updateItemDisplay();
		}
		
		private function categoryClickHandler($event:MouseEvent):void {
			if (currentCategoryIdSelected == $event.currentTarget.categoryId) {
				return;
			}
			currentCategoryIdSelected = $event.currentTarget.categoryId;
			currentPagingOffset = 0;
			this.updateItemDisplay();
			toggleCategoryButton($event.currentTarget.categoryId);
		}
		
		private function itemClickHandler($event:MouseEvent):void {
			//trace ("item click");
			this.highlightSelection($event.currentTarget.ID);
			avatar.addItem($event.currentTarget.itemObject);			
		}
		
		private function highlightSelection($id:int):void {
			if ($id == 0) {
				itemSelectionHighlight.visible = false;
				return;
			}
			itemSelectionHighlight.visible = true;
			itemSelectionHighlight.gotoAndStop($id);
			itemSelectionHighlight.alpha = 0;
			TweenLite.to(itemSelectionHighlight, 0.5, { "alpha":1 } );
		}
		
		private function toggleClothes($event:MouseEvent):void {
			this.switchItemsSet(CreateAvatarWindow.ASSETS_SET_CLOTHES);
			btnClothes.toggleOn();
			btnFeatures.toggleOff();
			currentPagingOffset = 0;
			this.resetButtons();		
		}
		
		private function toggleFeatures($event:MouseEvent):void {
			this.switchItemsSet(CreateAvatarWindow.ASSETS_SET_APPEARANCE);
			btnClothes.toggleOff();
			btnFeatures.toggleOn();
			currentPagingOffset = 0;
			this.resetButtons();		
		}
		
		private function toggleCategoryButton($categoryID:int):void {
			for (var i:int = 0; i < categoryButtonCollection.length; i++) {
				if (categoryButtonCollection[i].categoryId == $categoryID && categoryButtonCollection[i].visible) {
					categoryButtonCollection[i].toggleOn();
					if (lastCategoryButtonSelected) {
						lastCategoryButtonSelected.toggleOff();
					} 
					lastCategoryButtonSelected = categoryButtonCollection[i];
				}				
			}			
		}
		
		private function randomizeBtnClickHandler($event:MouseEvent):void {
			avatar.loadRandomItems();
		}
		
	}
	
}