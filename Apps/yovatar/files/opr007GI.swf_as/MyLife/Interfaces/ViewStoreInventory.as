package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.FB.*;
    import MyLife.FB.Objects.*;
    import MyLife.Utils.*;
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class ViewStoreInventory extends flash.display.MovieClip
    {
        public function ViewStoreInventory()
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            _newItems = [];
            super();
            if (!_instance)
            {
                itemDisplayCollection = [item1, item2, item3, item4, item5, item6];
                btnCloseWindow.addEventListener(MouseEvent.CLICK, btnCloseWindowClick);
                loc2 = 0;
                loc3 = itemDisplayCollection;
                for each (loc1 in loc3)
                {
                    loc1.alpha = 0;
                }
                btnScrollBack.addEventListener(MouseEvent.CLICK, btnScrollBackClick);
                btnScrollNext.addEventListener(MouseEvent.CLICK, btnScrollNextClick);
                btnScrollBack.visible = false;
                btnScrollNext.visible = false;
                pageOffsetDisplay.visible = false;
                StoreInventoryDisplayGrid.visible = false;
                StoreInventoryDisplayGridBG.visible = false;
            }
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _newItems.splice(0);
            dispatchEvent(new Event(Event.CLOSE));
            _myLife._interface.unloadInterface(arg1);
            if (toolTip)
            {
                toolTip.clear();
            }
            petId = 0;
            if (this.showEatAnimationOnStoreClose)
            {
                playEatAnimation();
            }
            return;
        }

        private function useFoodHandler(arg1:MyLife.MyLifeEvent):void
        {
            arg1.target.removeEventListener(Event.CLOSE, confirmWithOpenClosed);
            arg1.target.removeEventListener(MyLifeEvent.USE_FOOD_ITEM, useFoodHandler);
            showEatAnimationOnStoreClose = true;
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String, arg3:int=0, arg4:int=0):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = null;
            loc5 = getMovieChildren(arg1);
            loc7 = 0;
            loc8 = loc5;
            for each (loc6 in loc8)
            {
                arg1.removeChild(loc6);
            }
            _myLife.assetsLoader.loadImage(arg2, {"clip":arg1, "x":arg3, "y":arg4}, imageLoadedCallback);
            return;
        }

        private function openGiftWrapWindow():void
        {
            var loc1:*;

            loc1 = {};
            loc1.giftData = {};
            loc1.giftData.previousStep = "ViewStoreInventory";
            loc1.giftData.recipientName = giftData.recipientName;
            loc1.giftData.recipientPlayerId = giftData.recipientPlayerId;
            loc1.giftData.itemId = itemId;
            loc1.giftData.playerItemId = playerItemId;
            _myLife._interface.showInterface("GiftStepWrap", loc1);
            return;
        }

        private function btnCloseWindowClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.WINDOW_CLOSE, {"interfaceType":InterfaceTypes.GIFT_WINDOW}));
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        private function btnScrollNextClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            _currentPageOffset++;
            preUpdatePageDisplayItems();
            return;
        }

        private function inventoryBuyItemScreenCancelButtonClick(arg1:flash.events.MouseEvent):void
        {
            hideInventoryBuyItem();
            return;
        }

        private function loadCategoryItems(arg1:*):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            loc3 = undefined;
            _currentPageOffset = 0;
            if (arg1 != 0)
            {
                if (arg1 == -1)
                {
                    loc2 = _currentCategoryObj.parentCategory.store_category_id;
                    _currentCategoryObj = _currentCategoryObj.parentCategory.parentCategory;
                    loadCategoryItems(loc2);
                    return;
                }
                loc3 = _currentCategoryObj;
                _currentCategoryObj = _currentCategoryObj.sub_categories[arg1];
                _currentCategoryObj.parentCategory = loc3;
                _currentPageCount = Math.ceil((_currentCategoryObj.child_count + 1) / ITEMS_PER_PAGE);
                txtStoreName.text = _currentCategoryObj.category;
            }
            else 
            {
                _currentCategoryObj = storeInventoryDataObj.categories[0];
                _currentCategoryObj.parentCategory = _currentCategoryObj;
                _currentPageCount = Math.ceil(_currentCategoryObj.child_count / ITEMS_PER_PAGE);
                txtStoreName.text = _storeName;
            }
            preUpdatePageDisplayItems();
            return;
        }

        public function destroy():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            trace("ViewStoreInventory :: destroy called");
            loc2 = 0;
            loc3 = itemDisplayCollection;
            for each (loc1 in loc3)
            {
            };
            return;
        }

        private function confirmGiftHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                if (arg1.eventData.userResponse != "BTN_NO")
                {
                };
            }
            else 
            {
                playerItemId = arg1.eventData.metaData.playerItemId;
                itemId = arg1.eventData.metaData.itemId;
                if (playerItemId)
                {
                    unloadInterface(this);
                    openGiftBuddyWindow(playerItemId, itemId);
                }
            }
            return;
        }

        private function doBuyItemCallback(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;
            var loc24:*;
            var loc25:*;

            loc3 = null;
            loc4 = null;
            loc5 = false;
            loc6 = null;
            loc7 = NaN;
            loc8 = 0;
            loc9 = null;
            loc10 = false;
            loc11 = null;
            loc12 = NaN;
            loc13 = null;
            loc14 = null;
            loc15 = null;
            loc16 = NaN;
            loc17 = null;
            loc18 = null;
            loc19 = null;
            loc20 = null;
            loc21 = null;
            loc22 = null;
            loc23 = null;
            loc24 = null;
            _myLife.server.removeEventListener("MLXT_makePurchase", doBuyItemCallback);
            hideInventoryBuyItem();
            loc2 = "";
            if (arg1.eventData.params.dataObj.success != "true")
            {
                loc22 = "";
                loc23 = arg1.eventData.params.dataObj.message;
                loc25 = loc23;
                switch (loc25) 
                {
                    case "notEnoughCash":
                        loc22 = "\nYou don\'t have enough YoCash.";
                        break;
                    case "notEnoughCoins":
                        loc22 = "\nYou don\'t have enough coins.";
                        break;
                    case "notEnoughCrewMembers":
                        loc22 = "\nYou don\'t have crew members..";
                        break;
                    case "notEnoughRoomRating":
                        loc22 = "\nYou don\'t have a high enough room rating.";
                        break;
                }
                loc25 = loc23;
                switch (loc25) 
                {
                    case "notEnoughCash":
                        (loc24 = _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Unsuccessful", "message":"Sorry! Your purchase was unsuccessful." + loc22, "buttons":[{"name":"Earn YoCash", "value":YO_CASH_EARN}, {"name":"Buy YoCash", "value":YO_CASH_BUY}, {"name":"OK", "value":"BTN_OK"}]}) as GenericDialog).addEventListener(MyLifeEvent.DIALOG_RESPONSE, genericDialogResponse);
                        break;
                    default:
                        _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Unsuccessful", "message":"Sorry! Your purchase was unsuccessful." + loc22});
                }
            }
            else 
            {
                loc6 = (loc5 = (loc4 = arg1.eventData.params.dataObj.inventoy).hasOwnProperty("length")) ? loc4 as Array : [loc4];
                loc7 = 0;
                loc8 = 0;
                while (loc8 < loc6.length) 
                {
                    loc10 = (loc9 = loc6[loc8]).must_consume;
                    loc11 = loc9.metaData;
                    trace("mustConsume " + loc10 + " " + loc9.must_consume);
                    if (loc10)
                    {
                        if (loc11)
                        {
                            loc3 = JSON.decode(loc11);
                            if (loc3.speed)
                            {
                                loc2 = "\nYou Received +" + loc3.speed + " Speed!";
                                _myLife.player.adjustSpeedLevel(loc3.speed);
                            }
                            if (loc3.energy)
                            {
                                if (_myLife.player.getEnergyLevel() >= 100)
                                {
                                    loc2 = "";
                                }
                                else 
                                {
                                    loc2 = "\nYou Received +" + loc3.energy + " Energy!";
                                }
                                showEatAnimationOnStoreClose = true;
                            }
                            if (loc3.drunk)
                            {
                                loc2 = "\nYou Are Now " + loc3.drunk + "% More Dizzy!";
                                _myLife.player.adjustDrinksLevel(loc3.drunk);
                            }
                            if (loc3.petFeed)
                            {
                                if (loc3.petFeed > 1)
                                {
                                    loc2 = "\n\nYou have fed your pet for the next " + loc3.petFeed + " days!";
                                }
                                else 
                                {
                                    loc2 = "\n\nYou have fed your pet for the next day!";
                                }
                                loc12 = loc3.petFeed;
                                dispatchEvent(new MyLifeEvent(MyLifeEvent.PET_FEED_EVENT, {"petFeed":loc3.petFeed, "petId":petId}, true));
                            }
                        }
                    }
                    else 
                    {
                        InventoryManager.addItemToInventory(loc9);
                        ShortStoryPublisher.instance.dispatchEvent(new MyLifeEvent(MyLifeEvent.FB_ADD_ITEM_TO_STORY, new ItemFeedObject(_myLife.player._playerId, loc9.itemId, loc9.name, loc9.price)));
                        if (int(Number(loc9.categoryId)) == this.CATEGORY_ID_HOMES)
                        {
                            loc7 = Number(loc9.playerItemId);
                        }
                    }
                    ++loc8;
                }
                if (loc9.itemId == PET_ITEM_POPUP || loc9.itemId == SPCA_CAT_POPUP)
                {
                    loc2 = "\n\n2$US from the sale of this item will benefit the SF SPCA.";
                }
                if (loc3 && loc3.petFeed)
                {
                    (loc13 = _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Successful", "message":"Congratulations! Your purchase was successful." + loc2, "buttons":[{"name":"Close", "value":"BTN_NO"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmPetFeedDialogHandler, false, 0, true);
                }
                else 
                {
                    if (loc3 && !(loc3.energy == null))
                    {
                        loc14 = _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Successful", "message":"Congratulations! Your purchase was successful." + loc2});
                        (loc15 = new EnergyMeter()).name = "energyMeter";
                        if ((loc16 = _myLife.player.getEnergyLevel()) <= 0)
                        {
                            loc15.gotoAndStop(1);
                            loc15.txtEnergy.text = "0%";
                        }
                        else 
                        {
                            if (loc16 > 100)
                            {
                                loc15.gotoAndStop(100);
                                loc15.txtEnergy.text = "100%";
                            }
                            else 
                            {
                                loc15.gotoAndStop(loc16);
                                loc15.txtEnergy.text = String(loc16) + "%";
                            }
                        }
                        loc15.x = 255;
                        loc15.y = 290;
                        loc14.addChild(loc15);
                        loc14.addEventListener(MyLifeEvent.DIALOG_RESPONSE, removeMeterOnConfirmationClose, false, 0, true);
                    }
                    else 
                    {
                        if (giftData)
                        {
                            if (giftData.recipientPlayerId)
                            {
                                (loc17 = _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Successful", "message":"Congratulations! Your purchase was successful." + loc2, "metaData":{"playerItemId":loc9.playerItemId, "itemId":loc9.itemId}, "buttons":[{"name":"Close", "value":"BTN_NO"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmGiftStep2Handler, false, 0, true);
                            }
                        }
                        else 
                        {
                            if (loc7 == 0)
                            {
                                if (loc9.can_consume == "1" && !loc10)
                                {
                                    (loc19 = _myLife._interface.showInterface("ConfirmPurchaseWithOpen", {"item":loc9}, true, false, true)).addEventListener(MyLifeEvent.USE_FOOD_ITEM, useFoodHandler);
                                    loc19.addEventListener(Event.CLOSE, confirmWithOpenClosed);
                                }
                                else 
                                {
                                    loc20 = [{"name":"Close", "value":"BTN_NO"}];
                                    if (!loc10)
                                    {
                                        loc20.unshift({"name":"Send as Gift", "value":"BTN_YES"});
                                    }
                                    (loc21 = _myLife._interface.showInterface("GenericDialog", {"title":"Item Purchase Was Successful", "message":"Congratulations! Your purchase was successful." + loc2, "metaData":{"playerItemId":loc9.playerItemId, "itemId":loc9.itemId}, "buttons":loc20})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmGiftHandler, false, 0, true);
                                }
                            }
                            else 
                            {
                                (loc18 = _myLife._interface.showInterface("GenericDialog", {"title":"Home Purchase Was Successful", "message":"Congratulations on your successful purchase!\nWould you like to visit your new home now?", "metaData":{"homeId":loc7}, "buttons":[{"name":"Visit Now", "value":"BTN_YES"}, {"name":"Close", "value":"BTN_NO"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmHomeJoinDialogHandler, false, 0, true);
                            }
                        }
                    }
                }
                txtCoinCount.text = _myLife.player.getCoinBalance();
                txtCashCount.text = _myLife.player.getCashBalance();
            }
            return;
        }

        private function onLoadItemCollectionRawDataError(arg1:flash.events.IOErrorEvent):void
        {
            unloadInterface(this);
            return;
        }

        private function hideInventoryBuyItem():void
        {
            TweenLite.to(ViewInventoryBuyItem, 0.3, {"alpha":0, "onComplete":removeBuyItem});
            return;
        }

        private function updatePageDisplayItems():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc4 = undefined;
            loc5 = 0;
            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            loc9 = null;
            loc10 = 0;
            loc11 = 0;
            loc1 = _currentCategoryObj.sub_categories;
            loc2 = _currentCategoryObj.sub_items;
            loc3 = [];
            if (_currentCategoryObj.store_category_id != 0)
            {
                loc3.push({"sort_order":-1, "goBack":{}});
            }
            loc12 = 0;
            loc13 = loc1;
            for each (loc4 in loc13)
            {
                loc3.push(loc4);
            }
            loc5 = 100;
            loc12 = 0;
            loc13 = loc2;
            for each (loc6 in loc13)
            {
                ++loc5;
                loc6.sort_order = loc5;
                loc3.push(loc6);
            }
            loc3.sortOn("sort_order", Array.NUMERIC);
            loc8 = (loc7 = ITEMS_PER_PAGE * _currentPageOffset) + ITEMS_PER_PAGE;
            loc3 = loc3.slice(loc7, loc8);
            loc12 = 0;
            loc13 = itemDisplayCollection;
            for each (loc9 in loc13)
            {
                this.toolTip.setTip(loc9, "");
            }
            loc5 = 0;
            loc12 = 0;
            loc13 = loc3;
            for each (loc4 in loc13)
            {
                loc9 = itemDisplayCollection[loc5];
                loc11 = -1;
                if (loc4.child_count)
                {
                    loc11 = loc4.child_count;
                }
                if (loc4.goBack)
                {
                    setupDisplayItem(loc9, {"itemType":0, "goBack":{}});
                }
                else 
                {
                    if (loc4.item_id)
                    {
                        setupDisplayItem(loc9, {"active":loc4.active, "itemType":2, "itemId":loc4.item_id, "categoryId":loc4.item_category_id, "name":loc4.name, "price":loc4.price, "cash":loc4.price_cash, "isNew":loc4.is_new, "expireTime":loc4.expire_time, "crewMembers":loc4.crew_members, "description":loc4.description, "metaData":loc4.meta_data});
                    }
                    else 
                    {
                        if (loc4.sub_categories)
                        {
                            setupDisplayItem(loc9, {"active":loc4.active, "itemType":1, "categoryId":loc4.store_category_id, "name":loc4.category, "subCategoryCount":loc11});
                        }
                        else 
                        {
                            setupDisplayItem(loc9, {"active":loc4.active, "itemType":1, "categoryId":loc4.store_category_id, "name":loc4.category, "subItemCount":loc11});
                        }
                    }
                }
                loc9.addEventListener(MouseEvent.CLICK, itemDisplayClick);
                ++loc5;
            }
            loc10 = loc5;
            while (loc10 < ITEMS_PER_PAGE) 
            {
                loc9 = itemDisplayCollection[loc10];
                setupDisplayItem(loc9, {"itemType":0});
                loc9.removeEventListener(MouseEvent.CLICK, itemDisplayClick);
                ++loc10;
            }
            loc12 = 0;
            loc13 = itemDisplayCollection;
            for each (loc9 in loc13)
            {
                TweenLite.to(loc9, 0.5, {"alpha":1});
            }
            return;
        }

        private function setupDisplayItem(arg1:flash.display.MovieClip, arg2:Object):Boolean
        {
            var counterInterval:Function;
            var displayItem:flash.display.MovieClip;
            var energy:Number;
            var expireTime:int;
            var expired:Boolean;
            var i:int;
            var isCash:Boolean;
            var isToGoFood:Boolean;
            var isVIP:Boolean;
            var itemData:Object;
            var loc3:*;
            var loc4:*;
            var memberString:String;
            var metaData:Object;
            var param:Array;
            var params:Array;
            var seconds:int;
            var srcImgPath:String;

            srcImgPath = null;
            metaData = null;
            params = null;
            i = 0;
            param = null;
            energy = NaN;
            expireTime = 0;
            seconds = 0;
            expired = false;
            counterInterval = null;
            memberString = null;
            displayItem = arg1;
            itemData = arg2;
            displayItem.txtGoBack.visible = false;
            displayItem.txtNew.visible = false;
            displayItem.txtTimeLeft.visible = false;
            displayItem.txtCrewMembers.visible = false;
            displayItem.deactivatedBox.visible = false;
            displayItem.vip.visible = false;
            displayItem.mouseChildren = loc4 = true;
            displayItem.mouseEnabled = loc4;
            if (displayItem.timer)
            {
                Timer(displayItem.timer).reset();
            }
            isCash = parseInt(itemData.cash, 10) > 0;
            isVIP = false;
            if (itemData.hasOwnProperty("active"))
            {
                if (String(itemData.active) == "2")
                {
                    isVIP = true;
                }
            }
            isToGoFood = false;
            if (itemData["metaData"] && !(itemData.metaData.indexOf("Consummable") == -1))
            {
                isToGoFood = true;
            }
            if (itemData.itemId == PET_ITEM_POPUP || itemData.itemId == SPCA_CAT_POPUP)
            {
                displayItem.txtCrewMembers.htmlText = "2$US from the sale of this item benefit the SF SPCA.";
                displayItem.txtCrewMembers.visible = true;
            }
            if (itemData.itemType == 0)
            {
                displayItem.txtItemName.visible = false;
                displayItem.btnCategory.visible = false;
                displayItem.btnItem.visible = false;
                displayItem.txtDetails.visible = false;
                displayItem.StoreItemCoinDisplay.visible = false;
                displayItem.StoreListingItemPicture.visible = false;
                displayItem.customDataTxt.visible = false;
                displayItem.customIcon.visible = false;
                if (itemData.goBack)
                {
                    displayItem.txtGoBack.visible = true;
                    displayItem.txtGoBack.text = "<< Go Back To\n" + _currentCategoryObj.parentCategory.category;
                    displayItem.btnCategory.visible = true;
                    displayItem.itemData = itemData;
                }
                else 
                {
                    if (isVIP)
                    {
                        displayItem.vip.visible = true;
                    }
                }
                return true;
            }
            displayItem.txtItemName.visible = true;
            displayItem.btnCategory.visible = false;
            displayItem.btnItem.visible = true;
            displayItem.txtDetails.visible = true;
            displayItem.StoreItemCoinDisplay.visible = true;
            displayItem.StoreListingItemPicture.visible = true;
            displayItem.StoreListingItemPicture.toGoClip.visible = isToGoFood;
            displayItem.customDataTxt.visible = true;
            displayItem.customIcon.visible = true;
            displayItem.vip.visible = isVIP;
            displayItem.itemData = itemData;
            if (itemData.name)
            {
                displayItem.txtItemName.text = itemData.name;
            }
            if (itemData.subItemCount)
            {
                if (itemData.subItemCount <= 0)
                {
                    displayItem.txtDetails.text = "No Items";
                }
                else 
                {
                    if (itemData.subItemCount != 1)
                    {
                        displayItem.txtDetails.text = itemData.subItemCount + " Items";
                    }
                    else 
                    {
                        displayItem.txtDetails.text = "1 Item";
                    }
                }
                displayItem.customDataTxt.visible = false;
                displayItem.customIcon.visible = false;
                displayItem.StoreItemCoinDisplay.visible = false;
            }
            else 
            {
                if (itemData.subCategoryCount)
                {
                    if (itemData.subCategoryCount > 0)
                    {
                        if (itemData.subCategoryCount != 1)
                        {
                            displayItem.txtDetails.text = itemData.subCategoryCount + " Categories";
                        }
                        else 
                        {
                            displayItem.txtDetails.text = "1 Category";
                        }
                    }
                    else 
                    {
                        displayItem.txtDetails.visible = false;
                    }
                    displayItem.StoreItemCoinDisplay.visible = false;
                    displayItem.customDataTxt.visible = false;
                    displayItem.customIcon.visible = false;
                }
                else 
                {
                    if (itemData.price)
                    {
                        displayItem.StoreItemCoinDisplay.visible = true;
                        displayItem.txtDetails.visible = false;
                        displayItem.StoreItemCoinDisplay.txtPrice.text = isCash ? itemData.cash : itemData.price;
                        displayItem.StoreItemCoinDisplay.mcCoinIcon.visible = !isCash;
                        displayItem.StoreItemCoinDisplay.mcCashIcon.visible = isCash;
                        displayItem.txtNew.visible = Boolean(itemData.isNew);
                        DisplayObjectContainerUtils.removeChildren(displayItem.customIcon);
                        if (itemData.metaData)
                        {
                            try
                            {
                                itemData.metaData = JSON.decode(itemData.metaData);
                            }
                            catch (error:Error)
                            {
                                metaData = {};
                                params = itemData.metaData.split("|");
                                if (params.length > 0)
                                {
                                    i = 0;
                                    while (i < params.length) 
                                    {
                                        param = params[i].split(":");
                                        if (param.length == 2)
                                        {
                                            metaData[param[0]] = param[1];
                                        }
                                        i = (i + 1);
                                    }
                                }
                                itemData.metaData = metaData;
                            }
                        }
                        if (itemData.metaData)
                        {
                            if (itemData.metaData["energy"] > 0)
                            {
                                energy = _myLife.player.getEnergyLevel();
                                if (energy >= 100)
                                {
                                    displayItem.fullEnergy = true;
                                }
                                else 
                                {
                                    displayItem.fullEnergy = false;
                                }
                                displayItem.customDataTxt.visible = true;
                                displayItem.customIcon.visible = true;
                                displayItem.customDataTxt.textColor = 10027008;
                                displayItem.customDataTxt.text = "+" + itemData.metaData.energy + " Energy";
                                displayItem.customIcon.addChild(new PlusHeart());
                            }
                            else 
                            {
                                if (itemData.metaData["drunk"])
                                {
                                    displayItem.customDataTxt.visible = true;
                                    displayItem.customIcon.visible = true;
                                    displayItem.customDataTxt.textColor = 12953;
                                    displayItem.customDataTxt.text = "+" + itemData.metaData.drunk + " Dizzy";
                                    displayItem.customIcon.addChild(new PlusDizzy());
                                }
                                else 
                                {
                                    displayItem.customDataTxt.visible = false;
                                    displayItem.customIcon.visible = false;
                                    displayItem.customDataTxt.text = "";
                                }
                            }
                        }
                        else 
                        {
                            displayItem.customDataTxt.visible = false;
                            displayItem.customIcon.visible = false;
                            displayItem.customDataTxt.text = "";
                        }
                        if (itemData.description)
                        {
                            this.toolTip.setTip(displayItem, "<b>" + itemData.description + "</b>");
                        }
                        if (itemData.expireTime && !(itemData.expireTime == "null"))
                        {
                            expireTime = int(Number(itemData.expireTime));
                            seconds = expireTime - this.currentTime;
                            expired = seconds < 1;
                            trace("timer start", seconds);
                            counterInterval = function (arg1:flash.events.TimerEvent):void
                            {
                                var loc2:*;
                                var loc3:*;
                                var loc4:*;
                                var loc5:*;
                                var loc6:*;
                                var loc7:*;

                                loc2 = 0;
                                loc3 = 0;
                                loc4 = 0;
                                loc5 = 0;
                                trace("timer!!", seconds);
                                if (seconds < 1)
                                {
                                    Timer(arg1.target).removeEventListener(TimerEvent.TIMER, counterInterval);
                                    displayItem.txtTimeLeft.htmlText = "No Longer Available";
                                    displayItem.txtTimeLeft.visible = true;
                                    displayItem.deactivatedBox.visible = true;
                                    displayItem.btnItem.visible = false;
                                }
                                else 
                                {
                                    loc2 = Math.floor(seconds / 86400);
                                    loc3 = Math.floor(seconds / 3600) % 24;
                                    loc4 = Math.floor(seconds / 60) % 60;
                                    loc5 = seconds % 60;
                                    displayItem.txtTimeLeft.htmlText = "Time Left: " + loc2 + " days, " + loc3 + " hours, " + loc4 + " min, " + loc5 + " sec";
                                    displayItem.txtTimeLeft.visible = true;
                                    seconds--;
                                }
                                return;
                            }
                            if (expired)
                            {
                                displayItem.txtTimeLeft.htmlText = "No Longer Available";
                                displayItem.txtTimeLeft.visible = true;
                                displayItem.deactivatedBox.visible = true;
                                displayItem.btnItem.visible = false;
                            }
                            else 
                            {
                                if (!displayItem.timer)
                                {
                                    displayItem.timer = new Timer(1000);
                                    displayItem.timer.addEventListener(TimerEvent.TIMER, counterInterval);
                                }
                                displayItem.timer.start();
                                counterInterval(new TimerEvent(TimerEvent.TIMER));
                            }
                        }
                        if (itemData.crewMembers > 0)
                        {
                            memberString = "member";
                            if (itemData.crewMembers > 1)
                            {
                                memberString = memberString + "s";
                            }
                            displayItem.txtCrewMembers.htmlText = "Requires " + itemData.crewMembers + " Crew " + memberString + " To Purchase";
                            displayItem.txtCrewMembers.visible = true;
                            displayItem.txtTimeLeft.visible = false;
                        }
                        if (isVIP)
                        {
                            displayItem.vip.visible = true;
                            displayItem.mouseChildren = loc4 = false;
                            displayItem.mouseEnabled = loc4;
                        }
                    }
                }
            }
            if (itemData.itemType != 1)
            {
                if (itemData.itemType == 2)
                {
                    displayItem.btnCategory.visible = false;
                }
            }
            else 
            {
                displayItem.btnCategory.visible = true;
            }
            if (itemData.itemType != 1)
            {
                if (itemData.categoryId == 2001 || itemData.categoryId == 2002)
                {
                    srcImgPath = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + itemData.itemId + "_110_80.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                    loadImageIntoMovieClip(displayItem.StoreListingItemPicture.image, srcImgPath, 10, (10));
                }
                else 
                {
                    srcImgPath = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + itemData.itemId + "_130_100.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                    loadImageIntoMovieClip(displayItem.StoreListingItemPicture.image, srcImgPath);
                }
            }
            else 
            {
                srcImgPath = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + "cat_" + itemData.categoryId + "_130_100.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                loadImageIntoMovieClip(displayItem.StoreListingItemPicture.image, srcImgPath);
            }
            displayItem.btnItem.visible = !displayItem.btnCategory.visible;
            return true;
        }

        private function setupStoreWithLoadedData():void
        {
            var loc1:*;
            var loc2:*;

            if (storeInventoryDataObj && storeInventoryDataObj["categories"] && storeInventoryDataObj["categories"].length)
            {
                _newItems.splice(0);
                if (storeInventoryDataObj["categories"][0]["sub_categories"])
                {
                    findNewItems(storeInventoryDataObj["categories"][0]);
                }
                if (_newItems.length)
                {
                    _newItems.sortOn("created_on", Array.DESCENDING);
                    loc2 = ((loc1 = storeInventoryDataObj["categories"][0]).child_count + 1);
                    loc1.child_count = loc2;
                    storeInventoryDataObj["categories"][0]["sub_categories"]["new"] = {"category":"New Items", "itemType":1, "child_count":_newItems.length, "description":"", "sort_order":"0", "store_category_id":"new", "sub_items":_newItems};
                }
            }
            return;
        }

        private function fadeInUIElements():void
        {
            visible = true;
            alpha = 0;
            fadeClip(LoadingItemsPleaseWait, 0);
            fadeClip(pageOffsetDisplay);
            fadeClip(btnScrollBack);
            fadeClip(btnScrollNext);
            fadeClip(StoreInventoryDisplayGrid);
            fadeClip(StoreInventoryDisplayGridBG);
            fadeClip(this);
            return;
        }

        private function onLoadItemCollectionRawData(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target.data;
            trace("onLoadItemCollectionRawData() " + loc2);
            storeInventoryDataObj = JSON.decode(loc2);
            setupStoreWithLoadedData();
            fadeInUIElements();
            _storeName = storeInventoryDataObj.store_name;
            this.currentTime = storeInventoryDataObj.current_time || 0;
            loadCategoryItems(0);
            return;
        }

        public function hide():void
        {
            _myLife.debug("Select Player Screen");
            MovieClip(this).visible = false;
            return;
        }

        private function openGiftBuddyWindow(arg1:Number, arg2:Number):void
        {
            var loc3:*;

            trace("openGiftBuddy");
            loc3 = {};
            loc3.giftData = {};
            loc3.giftData.previousStep = "ViewStoreInventory";
            loc3.giftData.senderName = this._myLife.player._character._characterName;
            loc3.giftData.playerItemId = this.playerItemId;
            loc3.giftData.itemId = this.itemId;
            _myLife._interface.showInterface("GiftListViewer", loc3);
            return;
        }

        private function confirmPetFeedDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            unloadInterface(this);
            return;
        }

        private function genericDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc6 = null;
            GenericDialog(arg1.target).removeEventListener(MyLifeEvent.DIALOG_RESPONSE, genericDialogResponse);
            loc2 = arg1.eventData.userResponse;
            loc3 = null;
            loc4 = "_blank";
            loc5 = _myLife.getConfiguration().platformType;
            loc7 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_server"];
            loc8 = MyLifeInstance.getInstance().myLifeConfiguration.platformType;
            switch (loc8) 
            {
                case PLATFORM_FACEBOOK:
                    loc8 = loc2;
                    switch (loc8) 
                    {
                        case YO_CASH_BUY:
                            loc3 = loc7 + "zpay/buy_alt.php?r=" + Math.random();
                            break;
                        case YO_CASH_EARN:
                            loc3 = "http://sr.kitnmedia.com/offers.php?h=qork&uid=" + MyLifeConfiguration.sn_uid;
                            break;
                    }
                    break;
                case PLATFORM_MYSPACE:
                    loc8 = loc2;
                    switch (loc8) 
                    {
                        case YO_CASH_BUY:
                            loc3 = "http://yoload.zynga.com/ms/zpay/buy.php?r=47590353&opensocial_owner_id=" + MyLifeConfiguration.sn_uid;
                            break;
                        case YO_CASH_EARN:
                            loc3 = "http://75.126.76.75/super/offers?h=iycitv.113684549121&uid=" + MyLifeConfiguration.sn_uid;
                            break;
                    }
                    break;
                case MyLifeConfiguration.getInstance().PLATFORM_TAGGED:
                    loc8 = loc2;
                    switch (loc8) 
                    {
                        case YO_CASH_BUY:
                            loc3 = "http://yoload.zynga.com/tg/zpay/buy.php?opensocial_owner_id=" + MyLifeConfiguration.sn_uid + "&r=" + Math.random();
                            break;
                        case YO_CASH_EARN:
                            loc3 = "http://super.kitnmedia.com/super/offers?h=jegjxwome.023326353506&uid=" + MyLifeConfiguration.sn_uid;
                            break;
                    }
            }
            if (_myLife && loc3)
            {
                _myLife.navigateToURL(loc3, loc4);
            }
            return;
        }

        public function playEatAnimation():void
        {
            var loc1:*;
            var loc2:*;

            showEatAnimationOnStoreClose = false;
            trace("show eat animation");
            loc1 = ActionTweenType.EAT;
            loc2 = _myLife.getPlayer().getCharacter()["serverUserId"];
            ActionTweenManager.instance.broadcastActionTween(loc1, loc2, loc2);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;

            hide();
            txtCoinCount.text = _myLife.player.getCoinBalance();
            txtCashCount.text = _myLife.player.getCashBalance();
            storeId = arg2.storeId;
            gender = arg2.gender;
            petId = arg2.petId;
            if (arg2.giftData)
            {
                this.giftData = arg2.giftData;
            }
            loadRawStoreInventoryFromServer();
            this.toolTip = new ToolTip(this.toolTipColor, this.toolTipBackgroundColor);
            this.addChild(this.toolTip);
            loc3 = 6;
            loc4 = loc3;
            while (loc4--) 
            {
                this.toolTip.addTool(this[("item" + loc4 + 1)]);
            }
            showEatAnimationOnStoreClose = false;
            return;
        }

        private function enableButton(arg1:flash.display.SimpleButton, arg2:Boolean):void
        {
            arg1.mouseEnabled = arg2;
            arg1.visible = arg2;
            return;
        }

        private function btnScrollBackClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            _currentPageOffset--;
            preUpdatePageDisplayItems();
            return;
        }

        private function itemDisplayClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            if (arg1.currentTarget.alpha < 0.8)
            {
                return;
            }
            if (!arg1.currentTarget.itemData)
            {
                return;
            }
            if (arg1.currentTarget.deactivatedBox.visible == true)
            {
                return;
            }
            loc2 = arg1.currentTarget.itemData;
            if (loc2.itemType != 0)
            {
                if (loc2.itemType != 1)
                {
                    if (loc2.itemType == 2)
                    {
                        showInventoryBuyItem(loc2);
                    }
                }
                else 
                {
                    loadCategoryItems(loc2.categoryId);
                }
            }
            else 
            {
                if (loc2.goBack)
                {
                    loadCategoryItems(-1);
                }
            }
            return;
        }

        private function removeBuyItem():void
        {
            var loc1:*;
            var loc2:*;

            if (viewInventoryBuyItem)
            {
                while (viewInventoryBuyItem.StoreListingItemPicture.image.numChildren) 
                {
                    viewInventoryBuyItem.StoreListingItemPicture.image.removeChildAt(0);
                }
                viewInventoryBuyItem.btnCancel.removeEventListener(MouseEvent.CLICK, inventoryBuyItemScreenCancelButtonClick);
                viewInventoryBuyItem.btnBuy.removeEventListener(MouseEvent.CLICK, inventoryBuyItemScreenBuyButtonClick);
                try
                {
                    removeChild(viewInventoryBuyItem);
                }
                catch (e:*)
                {
                };
            }
            viewInventoryBuyItem = null;
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:Object):void
        {
            if (arg1 && arg2)
            {
                arg1.x = arg2.x;
                arg1.y = arg2.y;
                arg2.clip.addChild(arg1);
            }
            return;
        }

        private function getMovieChildren(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            loc2 = new Array();
            loc3 = 0;
            while (loc3 < arg1.numChildren) 
            {
                loc4 = arg1.getChildAt(loc3);
                loc2.unshift(loc4);
                ++loc3;
            }
            return loc2;
        }

        private function confirmWithOpenClosed(arg1:flash.events.Event):void
        {
            arg1.target.removeEventListener(Event.CLOSE, confirmWithOpenClosed);
            arg1.target.removeEventListener(MyLifeEvent.USE_FOOD_ITEM, useFoodHandler);
            return;
        }

        public function doBuyItem(arg1:int, arg2:int=0, arg3:int=1):void
        {
            _myLife.server.addEventListener("MLXT_makePurchase", doBuyItemCallback);
            _myLife.server.callExtension("makePurchase", {"store":arg2, "item":{"id":arg1, "qty":arg3}});
            return;
        }

        private function hideClip(arg1:flash.display.MovieClip):void
        {
            arg1.visible = false;
            return;
        }

        private function confirmGiftStep2Handler(arg1:MyLife.MyLifeEvent):void
        {
            playerItemId = arg1.eventData.metaData.playerItemId;
            itemId = arg1.eventData.metaData.itemId;
            openGiftWrapWindow();
            giftData = null;
            unloadInterface(this);
            return;
        }

        private function preUpdatePageDisplayItems():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            pageOffsetDisplay.text = "Page " + _currentPageOffset + 1 + " of " + _currentPageCount;
            if (_currentPageOffset <= 0)
            {
                enableButton(btnScrollBack, false);
            }
            else 
            {
                enableButton(btnScrollBack, true);
            }
            if (_currentPageOffset < (_currentPageCount - 1))
            {
                enableButton(btnScrollNext, true);
            }
            else 
            {
                enableButton(btnScrollNext, false);
            }
            loc1 = true;
            loc3 = 0;
            loc4 = itemDisplayCollection;
            for each (loc2 in loc4)
            {
                if (loc1)
                {
                    TweenLite.to(loc2, 0.5, {"alpha":0, "onComplete":updatePageDisplayItems, "onCompleteParams":[]});
                }
                else 
                {
                    TweenLite.to(loc2, 0.5, {"alpha":0});
                }
                loc1 = false;
            }
            return;
        }

        private function confirmHomeJoinDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = NaN;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = Number(arg1.eventData.metaData.homeId);
                if (loc2)
                {
                    unloadInterface(this);
                    _myLife.zone.joinHomeRoom(loc2, _myLife.player.getPlayerId());
                }
            }
            return;
        }

        private function showInventoryBuyItem(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = null;
            initInventoryBuyItem();
            viewInventoryBuyItem.alpha = 0;
            addChild(viewInventoryBuyItem);
            loc2 = parseInt(arg1.cash, 10) > 0;
            viewInventoryBuyItem.mcMoneyIcon.visible = !loc2;
            viewInventoryBuyItem.mcCashIcon.visible = loc2;
            viewInventoryBuyItem.txtItemName.text = arg1.name;
            viewInventoryBuyItem.txtPrice.text = loc2 ? arg1.cash : arg1.price;
            viewInventoryBuyItem.visible = true;
            viewInventoryBuyItem.currentItemId = arg1.itemId;
            viewInventoryBuyItem.alpha = 0;
            viewInventoryBuyItem.btnCancel.mouseEnabled = true;
            viewInventoryBuyItem.btnBuy.mouseEnabled = true;
            viewInventoryBuyItem.btnCancel.alpha = 1;
            viewInventoryBuyItem.btnBuy.alpha = 1;
            loc3 = false;
            if (arg1["metaData"] && arg1.metaData["command"] == "Consummable")
            {
                loc3 = true;
            }
            viewInventoryBuyItem.StoreListingItemPicture.toGoClip.visible = loc3;
            if (arg1.metaData)
            {
                if (arg1.metaData.energy > 0)
                {
                    viewInventoryBuyItem.customDataTxt.visible = true;
                    viewInventoryBuyItem.customIcon.visible = true;
                    viewInventoryBuyItem.customDataTxt.textColor = 10027008;
                    viewInventoryBuyItem.customDataTxt.text = "+" + arg1.metaData.energy + " Energy";
                    viewInventoryBuyItem.customIcon.addChild(new PlusHeart());
                }
                else 
                {
                    if (arg1.metaData.drunk)
                    {
                        viewInventoryBuyItem.customDataTxt.visible = true;
                        viewInventoryBuyItem.customIcon.visible = true;
                        viewInventoryBuyItem.customDataTxt.textColor = 12953;
                        viewInventoryBuyItem.customDataTxt.text = "+" + arg1.metaData.drunk + " Dizzy";
                        viewInventoryBuyItem.customIcon.addChild(new PlusDizzy());
                    }
                    else 
                    {
                        viewInventoryBuyItem.customDataTxt.visible = false;
                        viewInventoryBuyItem.customIcon.visible = false;
                        viewInventoryBuyItem.customDataTxt.text = "";
                    }
                }
            }
            else 
            {
                viewInventoryBuyItem.customDataTxt.visible = false;
                viewInventoryBuyItem.customIcon.visible = false;
                viewInventoryBuyItem.customDataTxt.text = "";
            }
            if (arg1.crewMembers > 0)
            {
                loc5 = "Member";
                if (arg1.crewMembers > 1)
                {
                    loc5 = loc5 + "s";
                }
                viewInventoryBuyItem.txtCrewMembers.htmlText = "Requires " + arg1.crewMembers + " Crew " + loc5 + " To Purchase";
                viewInventoryBuyItem.txtCrewMembers.visible = true;
            }
            else 
            {
                viewInventoryBuyItem.txtCrewMembers.visible = false;
            }
            if (this.storeId != this.STORE_ID_REALTY_OFFICE)
            {
                if (arg1.categoryId == 2001 || arg1.categoryId == 2002)
                {
                    loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_110_80.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                    loadImageIntoMovieClip(viewInventoryBuyItem.StoreListingItemPicture.image, loc4, 10, (10));
                }
                else 
                {
                    loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_130_100.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                    loadImageIntoMovieClip(viewInventoryBuyItem.StoreListingItemPicture.image, loc4);
                }
            }
            else 
            {
                loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + arg1.itemId + "_280_190.gif?v=" + _myLife.myLifeConfiguration.variables["utils"]["version"];
                loadImageIntoMovieClip(viewInventoryBuyItem.StoreListingItemPicture.image, loc4);
            }
            TweenLite.to(viewInventoryBuyItem, 0.3, {"alpha":1});
            return;
        }

        private function findNewItems(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = null;
            loc3 = null;
            loc4 = false;
            loc5 = null;
            if (arg1)
            {
                loc6 = 0;
                loc7 = arg1["sub_items"];
                for each (loc2 in loc7)
                {
                    if (!loc2["is_new"])
                    {
                        continue;
                    }
                    loc4 = false;
                    loc8 = 0;
                    loc9 = _newItems;
                    for each (loc5 in loc9)
                    {
                        if (loc2["item_id"] != loc5["item_id"])
                        {
                            continue;
                        }
                        loc4 = true;
                        break;
                    }
                    if (loc4)
                    {
                        continue;
                    }
                    _newItems.push(MyLifeUtils.cloneObject(loc2));
                }
                loc6 = 0;
                loc7 = arg1["sub_categories"];
                for each (loc3 in loc7)
                {
                    findNewItems(loc3);
                }
            }
            return;
        }

        private function fadeClip(arg1:flash.display.DisplayObject, arg2:Number=1):void
        {
            if (arg2 != 1)
            {
                arg1.alpha = 1;
            }
            else 
            {
                arg1.visible = true;
                arg1.alpha = 0;
            }
            TweenLite.to(arg1, 0.75, {"alpha":arg2});
            return;
        }

        private function initInventoryBuyItem():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = NaN;
            viewInventoryBuyItem = new ViewInventoryBuyItem();
            viewInventoryBuyItem.storeId = storeId;
            viewInventoryBuyItem.btnCancel.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenCancelButtonClick);
            viewInventoryBuyItem.btnBuy.addEventListener(MouseEvent.CLICK, inventoryBuyItemScreenBuyButtonClick);
            viewInventoryBuyItem.x = 321;
            viewInventoryBuyItem.y = 311;
            if (this.storeId != this.STORE_ID_REALTY_OFFICE)
            {
                loc1 = "Yes, Buy This Item!";
            }
            else 
            {
                viewInventoryBuyItem.mcItemBG.y = viewInventoryBuyItem.mcItemBG.y - 30;
                viewInventoryBuyItem.mcItemBG.width = 350;
                viewInventoryBuyItem.mcItemBG.height = 350;
                loc2 = viewInventoryBuyItem.mcItemBG.y - (viewInventoryBuyItem.mcItemBG.height >> 1);
                viewInventoryBuyItem.txtItemName.y = loc2 + 11;
                viewInventoryBuyItem.StoreListingItemPicture.x = -140;
                viewInventoryBuyItem.StoreListingItemPicture.y = loc2 + 40;
                viewInventoryBuyItem.txtPrice.x = 0;
                viewInventoryBuyItem.txtPrice.y = loc2 + 230;
                viewInventoryBuyItem.mcMoneyIcon.x = -20;
                viewInventoryBuyItem.mcMoneyIcon.y = loc2 + 242;
                viewInventoryBuyItem.mcCashIcon.x = -20;
                viewInventoryBuyItem.mcCashIcon.y = loc2 + 242;
                viewInventoryBuyItem.txtCrewMembers.x = viewInventoryBuyItem.mcItemBG.x - (viewInventoryBuyItem.mcItemBG.width >> 1) + 50;
                viewInventoryBuyItem.txtCrewMembers.y = viewInventoryBuyItem.txtPrice.y + 28;
                viewInventoryBuyItem.btnBuy.x = 0;
                viewInventoryBuyItem.btnBuy.y = loc2 + 288;
                viewInventoryBuyItem.btnCancel.x = 0;
                viewInventoryBuyItem.btnCancel.y = loc2 + 318;
                loc1 = "Yes, Buy This Home!";
            }
            viewInventoryBuyItem.btnBuy["upState"].getChildAt(1).text = loc1;
            viewInventoryBuyItem.btnBuy["overState"].getChildAt(1).text = loc1;
            viewInventoryBuyItem.btnBuy["downState"].getChildAt(1).text = loc1;
            return;
        }

        private function loadRawStoreInventoryFromServer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            trace("loadRawStoreInventoryFromServer()");
            loc1 = _myLife.player.getGender();
            loc2 = _myLife.myLifeConfiguration.variables["global"]["game_control_server"] + "get_store_items.php?store=" + storeId + "&gender=" + loc1 + "&storemode&r=" + Math.random();
            loc3 = new URLRequest(loc2);
            (loc4 = new URLLoader()).addEventListener(Event.COMPLETE, onLoadItemCollectionRawData);
            loc4.addEventListener(IOErrorEvent.IO_ERROR, onLoadItemCollectionRawDataError);
            loc4.load(loc3);
            return;
        }

        private function inventoryBuyItemScreenBuyButtonClick(arg1:flash.events.MouseEvent):void
        {
            viewInventoryBuyItem.btnCancel.mouseEnabled = false;
            viewInventoryBuyItem.btnBuy.mouseEnabled = false;
            viewInventoryBuyItem.btnCancel.alpha = 0.5;
            viewInventoryBuyItem.btnBuy.alpha = 0.5;
            return;
        }

        public function show():void
        {
            _myLife.debug("Select Player Screen");
            return;
        }

        private function removeMeterOnConfirmationClose(arg1:MyLife.MyLifeEvent):void
        {
            var dialog:MyLife.Interfaces.GenericDialog;
            var event:MyLife.MyLifeEvent;
            var loc2:*;
            var loc3:*;
            var userResponse:String;

            event = arg1;
            dialog = GenericDialog(event.target);
            dialog.removeEventListener(MyLifeEvent.DIALOG_RESPONSE, removeMeterOnConfirmationClose);
            userResponse = event.eventData.userResponse;
            trace("removeMeter " + userResponse);
            try
            {
                dialog.removeChild(dialog.getChildByName("energyMeter"));
            }
            catch (error:Error)
            {
            };
            if (!parent && showEatAnimationOnStoreClose)
            {
                playEatAnimation();
            }
            return;
        }

        public static function getInstance():MyLife.Interfaces.ViewStoreInventory
        {
            if (!_instance)
            {
                _instance = new ViewStoreInventory();
                _instance._myLife = MyLifeInstance.getInstance();
            }
            return _instance;
        }

        
        {
            PlusHeart = ViewStoreInventory_PlusHeart;
            PlusDizzy = ViewStoreInventory_PlusDizzy;
            EnergyMeter = ViewStoreInventory_EnergyMeter;
        }

        private const toolTipColor:uint=16777215;

        private const ITEMS_PER_PAGE:Number=6;

        private const CATEGORY_ID_HOMES:int=2029;

        private const toolTipBackgroundColor:uint=16760832;

        private const STORE_ID_REALTY_OFFICE:int=1013;

        private static const PET_ITEM_POPUP:String="26457";

        private static const YO_CASH_BUY:String="BTN_BUY_YOCASH";

        private static const PLATFORM_MYSPACE:String="platformMySpace";

        private static const PLATFORM_FACEBOOK:String="platformFacebook";

        private static const YO_CASH_EARN:String="BTN_EARN_YOCASH";

        private static const SPCA_CAT_POPUP:String="26611";

        public var btnCloseWindow:flash.display.SimpleButton;

        public var txtCashCount:flash.text.TextField;

        private var showEatAnimationOnStoreClose:Boolean;

        private var itemDisplayCollection:Array;

        private var _newItems:Array;

        public var pageOffsetDisplay:flash.text.TextField;

        public var txtCoinCount:flash.text.TextField;

        public var txtStoreName:flash.text.TextField;

        public var item1:flash.display.MovieClip;

        private var _currentCategoryObj:Object;

        public var item3:flash.display.MovieClip;

        public var item4:flash.display.MovieClip;

        public var item5:flash.display.MovieClip;

        public var item6:flash.display.MovieClip;

        public var item2:flash.display.MovieClip;

        public var viewInventoryBuyItem:MyLife.Interfaces.ViewInventoryBuyItem;

        public var StoreInventoryDisplayGrid:flash.display.MovieClip;

        private var itemId:Number;

        public var StoreInventoryDisplayGridBG:flash.display.MovieClip;

        private var _storeName:String="";

        private var petId:int=0;

        public var LoadingItemsPleaseWait:flash.display.MovieClip;

        private var _currentPageCount:int=0;

        private var gender:int=0;

        private var playerItemId:Number;

        public var btnScrollBack:flash.display.SimpleButton;

        private var storeId:int=0;

        public var btnScrollNext:flash.display.SimpleButton;

        private var currentTime:int=0;

        private var _myLife:flash.display.MovieClip;

        public var toolTip:MyLife.Interfaces.ToolTip;

        private var storeInventoryDataObj:Object;

        private var _currentPageOffset:int=0;

        private var giftData:*;

        public static var EnergyMeter:Class;

        public static var PlusHeart:Class;

        private static var _instance:MyLife.Interfaces.ViewStoreInventory;

        public static var PlusDizzy:Class;
    }
}
