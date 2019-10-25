package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Events.*;
    import MyLife.FB.*;
    import MyLife.FB.Interfaces.*;
    import MyLife.FB.Objects.*;
    import MyLife.FB.ShortStories.*;
    import MyLife.UI.*;
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    
    public class CreateNewPlayerStep2 extends flash.display.MovieClip
    {
        public function CreateNewPlayerStep2()
        {
            TabButtonNormal = CreateNewPlayerStep2_TabButtonNormal;
            TabButtonSelected = CreateNewPlayerStep2_TabButtonSelected;
            TabButtonOver = CreateNewPlayerStep2_TabButtonOver;
            categoriesThatRequireASelection = new Array("eyes", "hair", "mouth", "eye brows", "nose", "ears", "skin", "face shapes");
            currentAvatarItems = {};
            initPlayerObject = {};
            super();
            categoryButtonCollection = [categoryButton1, categoryButton2, categoryButton3, categoryButton4, categoryButton5, categoryButton6, categoryButton7, categoryButton8, categoryButton9, categoryButton10, categoryButton11, categoryButton12];
            itemCollection = [new AppearanceItemButton(item1), new AppearanceItemButton(item2), new AppearanceItemButton(item3), new AppearanceItemButton(item4), new AppearanceItemButton(item5), new AppearanceItemButton(item6)];
            isCostumesDisabled = !Boolean(Number(MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["costumesEnabled"]));
            btnUnlockItems.visible = false;
            buttonGroup = new RadioButtonManager();
            btnClothes = createToggleButton("Change Clothes");
            btnFeatures = createToggleButton("Edit Face");
            btnFeatures.x = btnClothes.x + btnClothes.width + 5;
            buttonGroup.addButton(btnClothes);
            buttonGroup.addButton(btnFeatures);
            tabGroupContainer.addChildAt(btnClothes, 0);
            tabGroupContainer.addChildAt(btnFeatures, 0);
            buttonGroup.selectButton(btnClothes);
            return;
        }

        private function setupButtonEvents():void
        {
            btnUnlockItems.addEventListener(MouseEvent.CLICK, btnUnlockItemsClick);
            mcInstallZwinky.btnCancel.addEventListener(MouseEvent.CLICK, btnCancelUnlockItemsClick);
            mcInstallZwinky.btnInstall.addEventListener(MouseEvent.CLICK, btnInstallUnlockItemsClick);
            backButton.addEventListener(MouseEvent.CLICK, backButtonClick);
            nextButton.addEventListener(MouseEvent.CLICK, nextButtonClick);
            savePlayer.addEventListener(MouseEvent.CLICK, savePlayerClick);
            randomizeAllItemsButton.addEventListener(MouseEvent.CLICK, randomizeAllItemsButtonClick);
            scrollBackButton.addEventListener(MouseEvent.CLICK, scrollBackButtonClick);
            scrollNextButton.addEventListener(MouseEvent.CLICK, scrollNextButtonClick);
            RotatePlayerControlSet.rotateRight.addEventListener(MouseEvent.CLICK, rotateAvatarRightClick);
            RotatePlayerControlSet.rotateLeft.addEventListener(MouseEvent.CLICK, rotateAvatarLeftClick);
            return;
        }

        private function showCreateStep2(arg1:flash.display.MovieClip, arg2:flash.display.MovieClip):void
        {
            unloadInterface(arg1);
            arg2.loadAvatarPreview();
            return;
        }

        private function backButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            cancelRandomItemLoading();
            if (currentStep != 2)
            {
                if (currentStep == 3)
                {
                    loc3 = initPlayerObject;
                    loc3.nextStep = 2;
                    loc3.currentClothes = avatarPreview.previewClip.getCurrentAvatarClothes();
                    loc3.clothingSet = true;
                    loc3.appearanceSet = true;
                    loc2 = _myLife._interface.showInterface("CreateNewPlayerStep2", loc3);
                    TweenLite.to(loc2, 0.75, {"x":0, "ease":Back.easeOut, "onComplete":showCreateStep2, "onCompleteParams":[this, loc2]});
                }
            }
            else 
            {
                initPlayerObject.appearanceSet = true;
                initPlayerObject.clothingSet = clothingSet;
                initPlayerObject.currentClothes = avatarPreview.previewClip.getCurrentAvatarClothes();
                loc2 = _myLife._interface.showInterface("CreateNewPlayerStep1", initPlayerObject);
                TweenLite.to(loc2, 0.75, {"x":0, "ease":Back.easeOut, "onComplete":unloadInterface, "onCompleteParams":[this]});
            }
            loc2.x = loc2.width;
            backButton.enabled = false;
            backButton.mouseEnabled = false;
            nextButton.enabled = false;
            nextButton.mouseEnabled = false;
            return;
        }

        private function selectCategory(arg1:int):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = 0;
            loc4 = null;
            currentCategoryIdSelected = arg1;
            loc2 = new TextFormat();
            loc5 = 0;
            loc6 = categoryButtonCollection;
            for each (loc4 in loc6)
            {
                if (loc4.buttonValue != arg1)
                {
                    if (loc4.currentFrame != this.buttonFrameDisabled)
                    {
                        loc4.gotoAndStop(this.buttonFrameUnselected);
                        loc4.hitZone.visible = true;
                        loc2.color = 333333;
                    }
                    else 
                    {
                        loc4.hitZone.visible = false;
                        loc2.color = 333333;
                    }
                }
                else 
                {
                    loc4.gotoAndStop(this.buttonFrameSelected);
                    loc4.hitZone.visible = false;
                    loc2.color = 16777215;
                }
                loc4.buttonText.setTextFormat(loc2);
            }
            currentPagingOffset = getCurrentCategorySelectedItem().pageOffset;
            updateItemDisplay();
            updateSelectionHighlight();
            return;
        }

        private function btnCancelUnlockItemsClick(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        private function onDefaultClothesLoaded():void
        {
            trace("onDefaultClothesLoaded");
            defaultClothesLoaded = true;
            loadItemCollectionRawDataFromServer();
            return;
        }

        private function fadeClipIn(arg1:flash.display.MovieClip):void
        {
            TweenLite.to(arg1, 0.75, {"alpha":1});
            arg1.alpha = 0;
            return;
        }

        private function selectNewItem(arg1:int, arg2:int, arg3:Boolean=false):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = undefined;
            loc6 = NaN;
            loc4 = arg2;
            if (itemCollectionData[arg1])
            {
                loc6 = (loc5 = itemCollectionData[arg1].itemList[loc4]).itemId;
                avatarPreview.previewClip.renderItem(loc5);
                itemCollectionData[arg1].selectedItem = {"itemIndex":loc4, "pageOffset":Math.floor(loc4 / 6), "itemId":loc6, "metaData":loc5.metaData};
                if (arg1 == currentCategoryIdSelected)
                {
                    updateSelectionHighlight();
                }
            }
            return;
        }

        private function checkForSaveCompletion():void
        {
            if (totalSaveStepsCompleted >= 2)
            {
                _myLife.server.removeEventListener("MLXT_savePlayerClothes", handleSavePlayerExtensionResponse);
                unloadInterface(progressDialogResponse);
                btnClothes.visible = false;
                btnFeatures.visible = false;
                TweenLite.to(this, 0.5, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            }
            return;
        }

        private function onLoadItemCollectionRawData(arg1:flash.events.Event):void
        {
            var loc2:*;

            trace("RAW DATA FROM SERVER " + arg1.target.data);
            avatarPreview.LoadingAnimation.visible = false;
            loc2 = JSON.decode(arg1.target.data);
            if (loc2.items)
            {
                itemCollectionRawData = convertRawDataToLocalFormat(loc2.items);
            }
            else 
            {
                itemCollectionRawData = convertRawDataToLocalFormat(loc2 as Array);
            }
            setupInterface();
            return;
        }

        private function onAppearanceItemButtonClick(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            trace("onAppearanceItemButtonClick");
            loc2 = arg1.target as AppearanceItemButton;
            loc3 = loc2.getAppearanceObject();
            avatarPreview.previewClip.renderItem(loc3);
            loc4 = loc2.getIndex();
            itemCollectionData[loc3.categoryId].selectedItem = {"itemIndex":loc4, "pageOffset":Math.floor(loc4 / 6), "itemId":loc3.itemId, "metaData":loc3.metaData};
            if (loc3.categoryId == currentCategoryIdSelected)
            {
                updateSelectionHighlight();
            }
            return;
        }

        private function convertRawCollectionData(arg1:Array):Array
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

            loc2 = 0;
            loc7 = null;
            loc8 = false;
            loc9 = NaN;
            loc10 = null;
            loc11 = NaN;
            loc12 = null;
            loc13 = undefined;
            loc14 = 0;
            loc15 = 0;
            loc16 = 0;
            loc17 = null;
            loc18 = NaN;
            loc3 = [];
            loc4 = 0;
            loc5 = this.getDefaultClothing();
            loc6 = 10;
            loc2 = 0;
            while (loc2 < arg1.length) 
            {
                loc7 = arg1[loc2];
                loc8 = currentStep == 3;
                loc9 = Number(loc7.g);
                if (loc8 || loc9 == 0 || loc9 == this.selectedGender || !(parseInt(loc7.playerId) == 1))
                {
                    loc10 = loc7.category;
                    loc11 = loc7.categoryId;
                    loc12 = "";
                    if (loc7["metaData"])
                    {
                        loc12 = loc7.metaData.split(":")[0];
                    }
                    if (!loc3[loc11])
                    {
                        loc3[loc11] = new Object();
                        loc3[loc11].sortOrder = loc4++;
                        loc3[loc11].categoryName = loc10;
                        loc3[loc11].categoryId = loc11;
                        loc3[loc11].categoryItemType = loc12;
                        loc3[loc11].itemList = new Array();
                        loc3[loc11].selectedItem = {"itemIndex":0, "pageOffset":0, "itemId":0, "metaData":""};
                        if (categoriesThatRequireASelection.indexOf(loc10.toLowerCase()) == -1)
                        {
                            loc3[loc11].itemList.push(generateNoSelectionItem(loc3[loc11]));
                        }
                    }
                    if (!initPlayerObject.editMode && !(loc5[loc11] == null) && loc7.itemId == loc5[loc11].itemId)
                    {
                        loc6 = (loc6 + 1);
                    }
                    else 
                    {
                        loc6 = (loc6 + 1);
                        loc7.sortOrder = loc6;
                        loc3[loc11].itemList.push(loc7);
                    }
                    if (loc13 = (currentAvatarItems != null) ? currentAvatarItems[loc3[loc11].categoryItemType] : null)
                    {
                        if (loc7.itemId == loc13.id)
                        {
                            if (loc3[loc11].selectedItem.itemIndex == 0)
                            {
                                loc14 = (loc3[loc11].itemList.length - 1);
                                loc15 = Math.floor(loc14 / 6);
                                loc3[loc11].itemList[loc14];
                                loc16 = 0;
                                if (categoriesThatRequireASelection.indexOf(loc10.toLowerCase()) == -1)
                                {
                                    loc16 = 1;
                                }
                                loc3[loc11].selectedItem = {"itemIndex":loc16, "pageOffset":0, "itemId":loc3[loc11].itemList[loc14].itemId, "metaData":loc3[loc11].itemList[loc14].metaData};
                                loc3[loc11].itemList[loc14].sortOrder = 5;
                            }
                        }
                    }
                    else 
                    {
                        if (loc3[loc11].itemList.length == 1)
                        {
                            loc3[loc11].selectedItem = {"itemIndex":0, "pageOffset":0, "itemId":loc3[loc11].itemList[0].itemId, "metaData":""};
                        }
                    }
                }
                ++loc2;
            }
            trace("initPlayerObject.editMode " + initPlayerObject.editMode);
            if (!initPlayerObject.editMode)
            {
                loc19 = 0;
                loc20 = loc5;
                for (loc17 in loc20)
                {
                    if (loc3[loc17] == null)
                    {
                        continue;
                    }
                    trace("pushing " + loc17);
                    loc18 = loc3[loc17].itemList[0].sortOrder + 1;
                    loc5[loc17].sortOrder = loc18;
                    loc3[loc17].itemList.splice(1, 0, loc5[loc17]);
                }
            }
            categoryCount = loc4;
            return loc3;
        }

        private function takePreviewSnapshot(arg1:Boolean=false):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = null;
            avatarPreview.previewClip.doAvatarAction("0");
            loc2 = new JPEGSnapshot(95, 100, 170);
            loc2.setUploadServer(_myLife.myLifeConfiguration.variables["global"]["new_upload_server"]);
            if (arg1)
            {
                jpegSnapshotCaptureCompleteNewPlayer();
            }
            else 
            {
                loc2.addEventListener(MyLifeEvent.PROGRESS_COMPLETE, jpegSnapshotCaptureComplete);
            }
            loc3 = new Sprite();
            loc4 = new Sprite();
            loc3.addChild(loc4);
            loc5 = avatarPreview.previewClip;
            loc4.addChild(loc5);
            loc6 = loc5.getBounds(loc4);
            loc4.y = loc4.y - loc6.top;
            loc4.x = loc4.x - loc6.left;
            if (!arg1)
            {
                loc2.capture(loc3, _myLife._selectedPlayerId);
            }
            return;
        }

        private function generateNoSelectionItem(arg1:Object):Object
        {
            var loc2:*;

            loc2 = new Object();
            loc2.category = arg1.categoryName;
            loc2.categoryId = arg1.categoryId;
            loc2.name = "None";
            loc2.player = 0;
            loc2.sortOrder = 0;
            loc2.itemId = 0;
            loc2.playerItemId = 0;
            loc2.metadata = "";
            return loc2;
        }

        private function getCurrentCategorySelectedItem():Object
        {
            return itemCollectionData[currentCategoryIdSelected].selectedItem;
        }

        private function onFinishAvatarBlur(arg1:int):void
        {
            avatarPreview.previewClip.changeDirection(arg1);
            TweenFilterLite.to(avatarPreview.previewClip, 0.15, {"type":"Blur", "blurX":0, "quality":2, "onComplete":onFinishNewAvatarBlur});
            return;
        }

        private function onSavePlayerComplete(arg1:MyLife.MyLifeEvent):void
        {
            var backDialogResponse:flash.display.MovieClip;
            var dialogEvent:MyLife.MyLifeEvent;
            var loc2:*;
            var loc3:*;
            var redirectUrl:String;
            var responseObj:Object;
            var saveResponse:String;
            var saveSuccess:*;

            responseObj = null;
            backDialogResponse = null;
            dialogEvent = arg1;
            redirectUrl = "";
            saveSuccess = dialogEvent.eventData.success;
            saveResponse = dialogEvent.eventData.response;
            try
            {
                responseObj = JSON.decode(saveResponse);
            }
            catch (error:Error)
            {
                responseObj = {"code":0};
            }
            if (saveSuccess && responseObj.code == "0")
            {
                saveSuccess = false;
            }
            if (responseObj.newPlayerId)
            {
                _newPlayerId = responseObj.newPlayerId;
            }
            else 
            {
                _newPlayerId = _myLife.myLifeConfiguration.variables["querystring"]["user"];
            }
            if (saveSuccess)
            {
                if (responseObj.code != "1")
                {
                    if (responseObj.code != "2")
                    {
                        saveSuccess = false;
                        saveResponse = responseObj.response;
                    }
                    else 
                    {
                        saveSuccess = true;
                        redirectUrl = responseObj.response;
                    }
                }
                else 
                {
                    saveSuccess = true;
                    redirectUrl = "index.php?newplayer";
                }
                _myLife.debug("Redirect To redirectUrl: " + redirectUrl);
            }
            else 
            {
                saveResponse = "There was a problem creating your new player.";
            }
            if (redirectUrl == "")
            {
                _myLife._interface.unloadInterface(progressDialogResponse);
                backDialogResponse = _myLife._interface.showInterface("GenericDialog", {"title":"There Was A Problem", "message":saveResponse});
            }
            else 
            {
                if (_myLife.myLifeConfiguration.platformType != "platformFacebook")
                {
                    this._myLife.linkTracker.track("2037", "1372");
                }
                else 
                {
                    this._myLife.linkTracker.track("1538", "1479");
                }
                _redirectUrl = redirectUrl;
                takePreviewSnapshot(true);
            }
            return;
        }

        private function btnFeaturesClick(arg1:flash.events.MouseEvent):void
        {
            if (currentStep != 2)
            {
                currentStep = 2;
                initPlayerObject.editMode = 1;
                initPlayerObject.currentClothes = avatarPreview.previewClip.getCurrentAvatarClothes();
                resetInterface();
                loadAvatarPreview();
            }
            return;
        }

        private function rotateAvatarRightClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = NaN;
            loc2 = avatarPreview.previewClip.getDirection();
            if (loc2 != MyLifeInstance.LEFT_FRONT)
            {
                if (loc2 != MyLifeInstance.RIGHT_FRONT)
                {
                    if (loc2 != MyLifeInstance.RIGHT_BACK)
                    {
                        loc3 = MyLifeInstance.LEFT_FRONT;
                    }
                    else 
                    {
                        loc3 = MyLifeInstance.LEFT_BACK;
                    }
                }
                else 
                {
                    loc3 = MyLifeInstance.RIGHT_BACK;
                }
            }
            else 
            {
                loc3 = MyLifeInstance.RIGHT_FRONT;
            }
            rotateAvatar(loc3);
            return;
        }

        private function nextButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            cancelRandomItemLoading();
            if (currentStep == 2)
            {
                if (REACHED_STEP_3 == false)
                {
                    REACHED_STEP_3 = true;
                }
                loc2 = initPlayerObject;
                loc2.nextStep = 3;
                loc2.appearanceSet = true;
                loc2.clothingSet = clothingSet;
                loc2.currentClothes = avatarPreview.previewClip.getCurrentAvatarClothes();
                loc3 = _myLife._interface.showInterface("CreateNewPlayerStep2", loc2);
                loc3.x = -loc3.width;
                TweenLite.to(loc3, 0.75, {"x":0, "ease":Back.easeOut, "onComplete":showCreateStep2, "onCompleteParams":[this, loc3]});
                backButton.enabled = false;
                backButton.mouseEnabled = false;
                nextButton.enabled = false;
                nextButton.mouseEnabled = false;
            }
            return;
        }

        private function btnUnlockItemsClick(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        private function cancelRandomItemLoading():void
        {
            if (randomAppearanceItemLoader != null)
            {
                randomAppearanceItemLoader.cancel();
                randomAppearanceItemLoader = null;
            }
            randomAppearanceList = null;
            return;
        }

        private function rotateAvatar(arg1:Number):void
        {
            if (rotatingAvatar == true)
            {
                return;
            }
            rotatingAvatar = true;
            TweenFilterLite.to(avatarPreview.previewClip, 0.15, {"type":"Blur", "blurX":25, "quality":2, "onComplete":onFinishAvatarBlur, "onCompleteParams":[arg1]});
            return;
        }

        private function cancelButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Are You Sure?", "message":"Are you sure you want to cancel?\nYou will lose any changes you\'ve made to your player.", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmCancelDialogResponse);
            bounceClipInViaY(loc2);
            return;
        }

        private function btnClothesClick(arg1:flash.events.MouseEvent):void
        {
            if (currentStep != 3)
            {
                currentStep = 3;
                initPlayerObject.editMode = 3;
                initPlayerObject.currentClothes = avatarPreview.previewClip.getCurrentAvatarClothes();
                resetInterface();
                loadAvatarPreview();
            }
            return;
        }

        private function resetInterface():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = 0;
            loc2 = null;
            loc3 = null;
            loc1 = 0;
            while (loc1 < categoryButtonCollection.length) 
            {
                loc2 = categoryButtonCollection[loc1];
                loc2.visible = false;
                ++loc1;
            }
            loc1 = 0;
            while (loc1 < 6) 
            {
                loc3 = itemCollection[loc1];
                loc3.showButton(false);
                ++loc1;
            }
            scrollBackButton.mouseEnabled = false;
            scrollBackButton.alpha = 0;
            scrollNextButton.mouseEnabled = false;
            scrollNextButton.alpha = 0;
            nextButton.mouseEnabled = false;
            nextButton.alpha = 0.5;
            randomizeAllItemsButton.mouseEnabled = false;
            randomizeAllItemsButton.alpha = 0.5;
            ItemSelectionHighlight.visible = false;
            pageOffsetDisplay.visible = false;
            ItemGrid6.visible = false;
            LoadingItemsPleaseWait.visible = true;
            savePlayer.visible = false;
            btnClothes.visible = false;
            btnFeatures.visible = false;
            if (currentStep != 2)
            {
                savePlayer.visible = true;
                nextButton.visible = false;
                randomizeAllItemsButton.visible = false;
                RotatePlayerControlSet.visible = true;
                if (initPlayerObject.editMode)
                {
                    CreatePlayerTitle.text = "Change Your Clothing";
                }
                else 
                {
                    CreatePlayerTitle.text = "Create A New Player - Select Your Clothing";
                }
            }
            else 
            {
                randomizeAllItemsButton.visible = true;
                RotatePlayerControlSet.visible = false;
                if (initPlayerObject.editMode)
                {
                    CreatePlayerTitle.text = "Change Your Appearance";
                }
                else 
                {
                    CreatePlayerTitle.text = "Create A New Player - Select Your Look";
                }
            }
            if (initPlayerObject.editMode)
            {
                nextButton.visible = false;
                backButton.visible = false;
                saveButton.mouseEnabled = false;
                saveButton.alpha = 0.5;
                btnClothes.visible = true;
                btnFeatures.visible = true;
            }
            else 
            {
                cancelButton.visible = false;
                saveButton.visible = false;
            }
            return;
        }

        private function jpegSnapshotCaptureComplete(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            totalSaveStepsCompleted++;
            checkForSaveCompletion();
            return;
        }

        private function getDefaultClothing(arg1:Number=-1):Object
        {
            var loc2:*;

            loc2 = {};
            if (arg1 == -1)
            {
                arg1 = selectedGender;
            }
            if (arg1 != 1)
            {
                loc2["101"] = {"itemId":"1143", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:CC5656|Outline:713232", "filename":"MaleTank"};
                loc2["100"] = {"itemId":"1030", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:212121|Outline:BCBCBC", "filename":"MalePants"};
                loc2["105"] = {"itemId":"1501", "categoryId":"105", "category":"Shoes", "name":"Black Shoes", "metaData":"Fill:000000|Outline:FFFFFF", "filename":"MaleShoes"};
                loc2["1003"] = {"itemId":"301", "categoryId":"1003", "catergory":"Hair", "name":"Spiky Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"ShortTosseledHairColor"};
            }
            else 
            {
                loc2["101"] = {"itemId":"1108", "categoryId":"101", "category":"Shirts", "name":"Red Tank", "metaData":"Fill:BE2A2A|Outline:681111", "filename":"FemaleTank"};
                loc2["100"] = {"itemId":"1003", "categoryId":"100", "category":"Pants", "name":"Black Pants", "metaData":"Fill:000000|Outline:BCBCBC", "filename":"FemalePants"};
                loc2["105"] = {"itemId":"1500", "categoryId":"105", "catergory":"Shoes", "name":"White Shoes", "metaData":"Fill:F5FBFC|Outline:CEDADC", "filename":"Heels"};
                loc2["1003"] = {"itemId":"300", "categoryId":"1003", "catergory":"Hair", "name":"Short Blond Hair", "metaData":"Fill:E5D285|Outline:776C42", "filename":"FlippedLongHairColor"};
            }
            return loc2;
        }

        private function createToggleButton(arg1:String=null):MyLife.UI.ToggleButton
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = new TabButtonNormal();
            loc3 = new TabButtonSelected();
            loc4 = new TabButtonOver();
            (loc5 = new TabButtonSelected()).label.visible = false;
            loc5.label.autoSize = "left";
            loc5.label.text = " ";
            loc6 = new ToggleButton(loc2, loc3, loc5, loc4);
            if (arg1)
            {
                loc6.name = arg1;
                loc3.label.autoSize = "left";
                loc3.label.text = arg1;
                loc3.button.width = loc3.label.width + 20;
                loc2.label.autoSize = "left";
                loc2.label.text = arg1;
                loc4.label.autoSize = "left";
                loc4.label.text = arg1;
                loc2.button.width = loc7 = loc3.button.width;
                loc4.button.width = loc7 = loc7;
                loc5.button.width = loc7;
            }
            return loc6;
        }

        private function bounceClipInViaY(arg1:flash.display.MovieClip):void
        {
            TweenLite.to(arg1, 0.75, {"alpha":1, "y":arg1.y, "ease":Bounce.easeOut});
            arg1.alpha = 0;
            arg1.y = -arg1.height;
            return;
        }

        public function loadAvatarPreview():void
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

            loc5 = null;
            loc6 = null;
            loc7 = null;
            while (avatarPreview.numChildren) 
            {
                avatarPreview.removeChildAt(0);
            }
            loc1 = _myLife.assetsLoader.newAvatarInstance();
            avatarPreview.previewClip = loc1;
            loc2 = 1;
            loc3 = 0;
            loc4 = 0;
            if (currentStep != 2)
            {
                if (currentStep == 3)
                {
                    loc2 = 0.45;
                    loc3 = 85;
                    loc4 = 230;
                }
            }
            else 
            {
                loc2 = 0.45;
                loc3 = 85;
                loc4 = 230;
            }
            avatarPreview.previewClip.initAvatar(selectedGender, loc2);
            avatarPreview.previewClip.x = loc3;
            avatarPreview.previewClip.y = loc4;
            currentAvatarItems = MyLifeUtils.cloneObject(initPlayerObject.currentClothes);
            avatarPreview.visible = false;
            avatarPreview.previewClip.renderClothes(currentAvatarItems);
            avatarPreview.addChild(avatarPreview.previewClip);
            avatarPreview.previewClip.doAvatarAction(0);
            loc1.visible = true;
            avatarPreview.LoadingAnimation.visible = true;
            if (initPlayerObject.editMode)
            {
                avatarPreview.visible = true;
                loadItemCollectionRawDataFromClient();
            }
            else 
            {
                if (defaultClothesLoaded)
                {
                    loadItemCollectionRawDataFromServer();
                }
                else 
                {
                    trace("loadingDefaults");
                    defaultClothesLoader = new AssetListLoader();
                    loc5 = new Array();
                    loc7 = this.getDefaultClothing(1);
                    loc8 = 0;
                    loc9 = loc7;
                    for each (loc6 in loc9)
                    {
                        loc6.url = _myLife.myLifeConfiguration.variables["global"]["avatar_asset_path"] + loc6.filename + ".swf";
                        loc5.push(loc6);
                    }
                    loc7 = this.getDefaultClothing(2);
                    loc8 = 0;
                    loc9 = loc7;
                    for each (loc6 in loc9)
                    {
                        loc6.url = _myLife.myLifeConfiguration.variables["global"]["avatar_asset_path"] + loc6.filename + ".swf";
                        loc5.push(loc6);
                    }
                    defaultClothesLoader.loadAssets(loc5, onDefaultClothesLoaded);
                }
            }
            return;
        }

        private function onFinishNewAvatarBlur():void
        {
            rotatingAvatar = false;
            return;
        }

        private function initializeCategoryButtons(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = undefined;
            loc2 = 0;
            loc3 = 0;
            loc2 = 0;
            while (loc2 < categoryCount) 
            {
                loc6 = 0;
                loc7 = arg1;
                for each (loc5 in loc7)
                {
                    if (loc5.sortOrder != loc2)
                    {
                        continue;
                    }
                    break;
                }
                if (loc3 < categoryButtonCollection.length)
                {
                    (loc4 = categoryButtonCollection[loc3]).alpha = 0;
                    TweenLite.to(loc4, 0.75, {"alpha":1});
                    loc4.visible = true;
                    loc4.buttonText.text = loc5.categoryName;
                    loc4.buttonValue = loc5.categoryId;
                    if (loc5.categoryId == this.CostumeCategoryId && this.isCostumesDisabled)
                    {
                        loc4.gotoAndStop(this.buttonFrameDisabled);
                        loc4.useHandCursor = false;
                    }
                    else 
                    {
                        loc4.gotoAndStop(this.buttonFrameUnselected);
                        loc4.hitZone.addEventListener(MouseEvent.CLICK, selectCategoryClick);
                        loc4.useHandCursor = true;
                    }
                    ++loc3;
                }
                ++loc2;
            }
            loc2 = loc3;
            while (loc2 < categoryButtonCollection.length) 
            {
                (loc4 = categoryButtonCollection[loc2]).visible = false;
                loc4.buttonValue = 0;
                ++loc2;
            }
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        public function show():void
        {
            _myLife.debug("Show CreateNewPlayerStep1");
            MovieClip(this).visible = true;
            return;
        }

        private function jpegSnapshotCaptureCompleteNewPlayer(arg1:MyLife.MyLifeEvent=null):void
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

            loc4 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc2 = _redirectUrl;
            loc3 = new URLVariables();
            loc3["redirecturl"] = loc2;
            if (_myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"])
            {
                loc6 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"]);
                loc9 = 0;
                loc10 = loc6;
                for (loc4 in loc10)
                {
                    loc3[loc4] = loc6[loc4];
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"])
            {
                loc7 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"]);
                loc9 = 0;
                loc10 = loc7;
                for (loc4 in loc10)
                {
                    loc3[loc4] = loc7[loc4];
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"])
            {
                loc8 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"]);
                loc9 = 0;
                loc10 = loc8;
                for (loc4 in loc10)
                {
                    loc3[loc4] = loc8[loc4];
                }
            }
            (loc5 = new URLRequest("frame_breakout.php")).data = loc3;
            loc5.method = URLRequestMethod.POST;
            navigateToURL(loc5, "_self");
            return;
        }

        private function updateSelectionHighlight():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = getCurrentCategorySelectedItem().itemIndex;
            loc2 = currentPagingOffset * ITEMS_PER_PAGE;
            loc3 = currentPagingOffset * ITEMS_PER_PAGE + ITEMS_PER_PAGE;
            if (loc1 >= loc2 && loc1 < loc3)
            {
                ItemSelectionHighlight.alpha = 0;
                ItemSelectionHighlight.visible = true;
                ItemSelectionHighlight.gotoAndStop(loc1 % ITEMS_PER_PAGE + 1);
                TweenLite.to(ItemSelectionHighlight, 0.75, {"alpha":1});
            }
            else 
            {
                ItemSelectionHighlight.visible = false;
            }
            return;
        }

        private function onLoadItemCollectionRawDataError(arg1:flash.events.IOErrorEvent):void
        {
            return;
        }

        private function handleSavePlayerExtensionResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            totalSaveStepsCompleted++;
            checkForSaveCompletion();
            return;
        }

        private function setupInterface():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = undefined;
            loc2 = false;
            if (!itemCollectionRawData)
            {
                if (initPlayerObject.editMode != 1)
                {
                    itemCollectionRawData = InventoryManager.getPlayerInventory(InventoryManager.INVENTORY_CLOTHING, false, InventoryManager.INVENTORY_ACCESSORIES);
                }
                else 
                {
                    itemCollectionRawData = InventoryManager.getPlayerInventory(InventoryManager.INVENTORY_APPEARANCE, false);
                }
            }
            setupButtonEvents();
            nextButton.mouseEnabled = true;
            nextButton.alpha = 1;
            backButton.mouseEnabled = true;
            backButton.alpha = 1;
            randomizeAllItemsButton.mouseEnabled = true;
            randomizeAllItemsButton.alpha = 1;
            ItemSelectionHighlight.visible = false;
            pageOffsetDisplay.visible = true;
            ItemGrid6.visible = true;
            LoadingItemsPleaseWait.visible = false;
            itemCollectionData = convertRawCollectionData(itemCollectionRawData);
            itemCollectionRawData = null;
            initializeCategoryButtons(itemCollectionData);
            loc3 = 0;
            loc4 = itemCollectionData;
            for each (loc1 in loc4)
            {
                if (loc1.sortOrder != 0)
                {
                    continue;
                }
                selectCategory(loc1.categoryId);
                break;
            }
            loc2 = false;
            if (currentStep == 2)
            {
                loc2 = !appearanceSet;
            }
            if (currentStep == 3)
            {
                loc2 = !clothingSet;
            }
            if (initPlayerObject.editMode)
            {
                nextButton.visible = false;
                backButton.visible = false;
                saveButton.mouseEnabled = true;
                saveButton.alpha = 1;
                cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClick);
                saveButton.addEventListener(MouseEvent.CLICK, saveButtonClick);
                btnClothes.addEventListener(MouseEvent.CLICK, btnClothesClick);
                btnFeatures.addEventListener(MouseEvent.CLICK, btnFeaturesClick);
            }
            if (loc2)
            {
                this.selectDefaults();
            }
            avatarPreview.visible = true;
            return;
        }

        private function loadItemCollectionRawDataFromServer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            trace("loadItemCollectionRawDataFromServer");
            if (currentStep != 2)
            {
                loc1 = _myLife.myLifeConfiguration.variables["global"]["game_control_server"] + "get_store_items.php?store=1&percent=1&gender=" + selectedGender + "&r=" + Math.random();
            }
            else 
            {
                loc1 = _myLife.myLifeConfiguration.variables["global"]["game_control_server"] + "get_appearance_items.php?gender=" + selectedGender + "&r=" + Math.random();
            }
            trace("url " + loc1);
            loc2 = new URLRequest(loc1);
            loc3 = new URLLoader();
            loc3.addEventListener(Event.COMPLETE, onLoadItemCollectionRawData);
            loc3.addEventListener(IOErrorEvent.IO_ERROR, onLoadItemCollectionRawDataError);
            loc3.load(loc2);
            return;
        }

        public function hide():void
        {
            _myLife.debug("Hide CreateNewPlayerStep1");
            MovieClip(this).visible = false;
            return;
        }

        private function convertRawDataToLocalFormat(arg1:Array):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = arg1;
            for each (loc2 in loc4)
            {
                loc2.playerItemId = loc2.player_item_id;
                delete loc2.player_item_id;
                loc2.itemId = loc2.item_id;
                delete loc2.item_id;
                loc2.metaData = loc2.meta_data;
                delete loc2.meta_data;
                loc2.categoryId = loc2.item_category_id;
                delete loc2.item_category_id;
                loc2.g = loc2.gender;
                delete loc2.gender;
            }
            return arg1;
        }

        private function onLoadedRandomItems():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = null;
            loc2 = NaN;
            while (randomAppearanceList.length > 0) 
            {
                loc1 = randomAppearanceList.pop();
                avatarPreview.previewClip.renderItem(loc1);
                loc2 = loc1.index;
                itemCollectionData[loc1.categoryId].selectedItem = {"itemIndex":loc2, "pageOffset":Math.floor(loc2 / 6), "itemId":loc1.itemId, "metaData":loc1.metaData};
                if (loc1.categoryId == currentCategoryIdSelected)
                {
                    updateSelectionHighlight();
                }
                delete loc1.index;
                delete loc1.url;
            }
            randomAppearanceList = null;
            randomAppearanceItemLoader = null;
            return;
        }

        private function savePlayerClick(arg1:flash.events.MouseEvent):void
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

            loc4 = undefined;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            loc13 = null;
            loc14 = null;
            loc15 = null;
            loc16 = NaN;
            cancelRandomItemLoading();
            loc2 = avatarPreview.previewClip.getCurrentAvatarClothes();
            loc3 = _myLife.myLifeConfiguration.variables["global"]["game_server"] + "new_player_post.php?r=" + Math.random();
            if (MyLifeConfiguration.getInstance().variables["querystring"]["qsJSON"])
            {
                loc8 = JSON.decode(MyLifeConfiguration.getInstance().variables["querystring"]["qsJSON"]);
                loc17 = 0;
                loc18 = loc8;
                for (loc4 in loc18)
                {
                    loc3 = loc3 + "&" + loc4 + "=" + loc8[loc4];
                }
            }
            loc5 = [];
            loc6 = {};
            loc5.push({"name":"login_key", "value":_myLife.myLifeConfiguration.variables["querystring"]["lk"]});
            loc5.push({"name":"mylife_user_id", "value":_myLife.myLifeConfiguration.variables["querystring"]["user"]});
            loc5.push({"name":"src", "value":_myLife.myLifeConfiguration.variables["querystring"]["src"]});
            if (_myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"])
            {
                loc9 = _myLife.myLifeConfiguration.variables["querystring"]["facebookJSON"];
                loc10 = JSON.decode(loc9);
                loc17 = 0;
                loc18 = loc10;
                for (loc4 in loc18)
                {
                    loc5.push({"name":loc4, "value":loc10[loc4]});
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"])
            {
                loc11 = _myLife.myLifeConfiguration.variables["querystring"]["oauthJSON"];
                loc12 = JSON.decode(loc11);
                loc17 = 0;
                loc18 = loc12;
                for (loc4 in loc18)
                {
                    loc5.push({"name":loc4, "value":loc12[loc4]});
                }
            }
            if (_myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"])
            {
                loc13 = _myLife.myLifeConfiguration.variables["querystring"]["opensocialJSON"];
                loc14 = JSON.decode(loc13);
                loc17 = 0;
                loc18 = loc14;
                for (loc4 in loc18)
                {
                    loc5.push({"name":loc4, "value":loc14[loc4]});
                }
            }
            if (MyLifeConfiguration.getInstance().platformType == MyLifeConfiguration.getInstance().PLATFORM_TAGGED)
            {
                loc15 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["taggedJSON"]);
                loc17 = 0;
                loc18 = loc15;
                for (loc4 in loc18)
                {
                    loc5.push({"name":loc4, "value":loc15[loc4]});
                }
            }
            loc6["name"] = initPlayerObject.nameSelected;
            loc17 = 0;
            loc18 = loc2;
            for (loc7 in loc18)
            {
                if (loc2[loc7].itemId == null || loc2[loc7].itemId < 0)
                {
                    loc16 = 0;
                }
                else 
                {
                    loc16 = loc2[loc7].itemId;
                }
                loc6[loc7] = loc16;
            }
            loc6["gender"] = this.selectedGender;
            loc6["player_id"] = initPlayerObject["playerId"];
            trace("SAVING PLAYER " + JSON.encode(loc6));
            loc5.push({"name":"player_data", "value":JSON.encode(loc6)});
            progressDialogResponse = _myLife._interface.showInterface("ProgressDialog", {"title":"Saving Your Player", "message":"Your Player Is Currently Being Saved. This Will Normally Take Less Than 10 Seconds.", "url":loc3, "postData":loc5, "keepWindowOpen":true});
            progressDialogResponse.addEventListener(MyLifeEvent.PROGRESS_COMPLETE, onSavePlayerComplete);
            fadeClipIn(progressDialogResponse);
            return;
        }

        private function selectDefaults():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = false;
            loc1 = this.getDefaultClothing();
            loc4 = 0;
            loc5 = loc1;
            for (loc2 in loc5)
            {
                if (currentStep == 3 && loc2 == "1003")
                {
                    continue;
                }
                loc3 = loc2 == "100" || loc2 == "101" || loc2 == "105" || loc2 == "1003";
                if (!(itemCollectionData[loc2] == null) && loc3)
                {
                    selectNewItem(Number(loc2), 1, true);
                    continue;
                }
                avatarPreview.previewClip.renderItem(loc1[loc2]);
            }
            return;
        }

        private function scrollBackButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            currentPagingOffset--;
            updateItemDisplay();
            return;
        }

        private function rotateAvatarLeftClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = NaN;
            loc2 = avatarPreview.previewClip.getDirection();
            if (loc2 != MyLifeInstance.LEFT_FRONT)
            {
                if (loc2 != MyLifeInstance.LEFT_BACK)
                {
                    if (loc2 != MyLifeInstance.RIGHT_BACK)
                    {
                        loc3 = MyLifeInstance.LEFT_FRONT;
                    }
                    else 
                    {
                        loc3 = MyLifeInstance.RIGHT_FRONT;
                    }
                }
                else 
                {
                    loc3 = MyLifeInstance.RIGHT_BACK;
                }
            }
            else 
            {
                loc3 = MyLifeInstance.LEFT_BACK;
            }
            rotateAvatar(loc3);
            return;
        }

        private function selectCategoryClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            selectCategory(loc2.parent.buttonValue);
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            mcInstallZwinky.visible = false;
            if (_myLife.myLifeConfiguration.variables["querystring"]["zwinky"] == "1")
            {
            };
            initPlayerObject = {};
            loc4 = 0;
            loc5 = arg2;
            for (loc3 in loc5)
            {
                initPlayerObject[loc3] = MyLifeUtils.cloneObject(arg2[loc3]);
            }
            currentStep = initPlayerObject.nextStep;
            selectedGender = initPlayerObject.selectedGender;
            PlayerName.text = initPlayerObject.nameSelected;
            if (initPlayerObject.editMode)
            {
                CreatePlayerTitle.visible = false;
                appearanceSet = true;
                clothingSet = true;
            }
            else 
            {
                appearanceSet = (initPlayerObject.appearanceSet != null) ? initPlayerObject.appearanceSet : false;
                clothingSet = (initPlayerObject.clothingSet != null) ? initPlayerObject.clothingSet : false;
            }
            resetInterface();
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            setupInterface();
            return;
        }

        private function updateItemDisplay():void
        {
            var loc1:*;
            var loc2:*;
            var nTotalPages:*;
            var nCurrentPage:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc1 = 0;
            loc5 = NaN;
            loc6 = undefined;
            loc7 = null;
            cancelRandomItemLoading();
            loc2 = itemCollectionData[currentCategoryIdSelected].itemList;
            if (currentPagingOffset < 0)
            {
                currentPagingOffset = 0;
            }
            loc2.sortOn("sortOrder", Array.NUMERIC);
            loc1 = 0;
            while (loc1 < ITEMS_PER_PAGE) 
            {
                loc5 = loc1 + currentPagingOffset * ITEMS_PER_PAGE;
                loc6 = loc2[loc5];
                (loc7 = itemCollection[loc1]).addEventListener("APPEARANCE_ITEM_BUTTON_CLICK", onAppearanceItemButtonClick);
                loc7.setAppearanceObject(loc6, loc5);
                ++loc1;
            }
            nTotalPages = Math.ceil(loc2.length / ITEMS_PER_PAGE);
            nCurrentPage = currentPagingOffset + 1;
            pageOffsetDisplay.text = "Page " + nCurrentPage + " of " + nTotalPages;
            if (nCurrentPage <= 1)
            {
                scrollBackButton.mouseEnabled = false;
                scrollBackButton.alpha = 0;
            }
            else 
            {
                scrollBackButton.mouseEnabled = true;
                scrollBackButton.alpha = 1;
            }
            if (nCurrentPage >= nTotalPages)
            {
                scrollNextButton.mouseEnabled = false;
                scrollNextButton.alpha = 0;
            }
            else 
            {
                scrollNextButton.mouseEnabled = true;
                scrollNextButton.alpha = 1;
            }
            updateSelectionHighlight();
            return;
        }

        private function confirmCancelDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                btnClothes.visible = false;
                btnFeatures.visible = false;
                TweenLite.to(this, 0.5, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            }
            return;
        }

        private function saveButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            totalSaveStepsCompleted = 0;
            loc2 = avatarPreview.previewClip.getCurrentAvatarClothes();
            loc3 = {};
            loc6 = 0;
            loc7 = loc2;
            for (loc4 in loc7)
            {
                if (!(!(loc2[loc4] == null) && !(loc2[loc4].itemId == null)))
                {
                    continue;
                }
                loc3[loc4] = loc2[loc4].itemId;
            }
            _myLife.server.callExtension("savePlayerClothes", {"player_data":loc3});
            _myLife.server.addEventListener("MLXT_savePlayerClothes", handleSavePlayerExtensionResponse);
            progressDialogResponse = _myLife._interface.showInterface("ProgressDialog", {"title":"Saving Your Player", "message":"Your Player Is Currently Being Saved. This Will Normally Take Less Than 10 Seconds.", "url":"", "keepWindowOpen":true});
            fadeClipIn(progressDialogResponse);
            takePreviewSnapshot();
            trace("_myLife.player.setNewClothing(avatarClothing);");
            _myLife.player.setNewClothing(loc2);
            if (!(loc5 = ShortStoryPublisher.instance.getStory(ShortStoryPublisher.APPEARANCE_FEED)))
            {
                loc5 = new AppearanceFeedStory();
            }
            loc5.addItem(new AppearanceFeedObject(_myLife.player._playerId));
            ShortStoryPublisher.instance.putStory(loc5, ShortStoryPublisher.APPEARANCE_FEED);
            ShortStoryPublisher.instance.publish(ShortStoryPublisher.APPEARANCE_FEED);
            return;
        }

        private function btnInstallUnlockItemsClick(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        private function loadItemCollectionRawDataFromClient():void
        {
            trace("loadItemCollectionRawDataFromClient");
            if (InventoryManager.ready)
            {
                setupInterface();
            }
            else 
            {
                InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
                InventoryManager.loadInventory();
            }
            return;
        }

        private function updateAvatarWithDefaultGender(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = 0;
            loc4 = arg1;
            for each (loc2 in loc4)
            {
                currentAvatarItems[loc2.i] = loc2;
            }
            return;
        }

        private function randomizeAllItemsButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = null;
            loc4 = NaN;
            loc5 = null;
            randomAppearanceList = new Array();
            loc2 = new Array();
            loc6 = 0;
            loc7 = itemCollectionData;
            for each (loc3 in loc7)
            {
                loc4 = Math.floor(loc3.itemList.length * Math.random());
                (loc5 = itemCollectionData[loc3.categoryId].itemList[loc4]).index = loc4;
                randomAppearanceList.push(loc5);
                if (AssetsManager.getInstance().getItemLoadStatus(loc5.itemId) != 3)
                {
                    continue;
                }
                loc5.url = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["avatar_asset_path"] + loc5.filename + ".swf";
                loc2.push(loc5);
            }
            if (loc2.length > 0)
            {
                randomAppearanceItemLoader = new AssetListLoader();
                randomAppearanceItemLoader.loadAssets(loc2, onLoadedRandomItems);
            }
            else 
            {
                onLoadedRandomItems();
            }
            return;
        }

        private function scrollNextButtonClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            currentPagingOffset++;
            updateItemDisplay();
            return;
        }

        
        {
            REACHED_STEP_3 = false;
        }

        private const buttonFrameUnselected:int=1;

        private const ITEMS_PER_PAGE:Number=6;

        private const CostumeCategoryId:int=2025;

        private const buttonFrameDisabled:int=3;

        private const buttonFrameSelected:int=2;

        public var nextButton:flash.display.SimpleButton;

        private var itemCollection:Array;

        private var totalSaveStepsCompleted:int=0;

        public var avatarPreview:flash.display.MovieClip;

        private var _redirectUrl:String="";

        public var ItemGrid6:flash.display.MovieClip;

        private var btnClothes:MyLife.UI.ToggleButton;

        public var cancelButton:flash.display.SimpleButton;

        public var pageOffsetDisplay:flash.text.TextField;

        public var categoryButton1:flash.display.MovieClip;

        public var categoryButton2:flash.display.MovieClip;

        public var categoryButton3:flash.display.MovieClip;

        public var categoryButton4:flash.display.MovieClip;

        public var categoryButton5:flash.display.MovieClip;

        public var categoryButton6:flash.display.MovieClip;

        public var categoryButton7:flash.display.MovieClip;

        public var categoryButton8:flash.display.MovieClip;

        public var categoryButton9:flash.display.MovieClip;

        private var buttonGroup:MyLife.UI.RadioButtonManager;

        private var TabButtonOver:Class;

        private var categoryButtonCollection:Array;

        private var itemCollectionRawData:Array;

        private var currentAvatarItems:Object;

        private var categoryCount:int=0;

        public var scrollNextButton:flash.display.SimpleButton;

        private var initPlayerObject:Object;

        private var btnFeatures:MyLife.UI.ToggleButton;

        public var savePlayer:flash.display.SimpleButton;

        private var TabButtonSelected:Class;

        private var randomAppearanceList:Array;

        private var TabButtonNormal:Class;

        public var randomizeAllItemsButton:flash.display.SimpleButton;

        private var rotatingAvatar:Boolean=false;

        public var btnUnlockItems:flash.display.SimpleButton;

        public var backButton:flash.display.SimpleButton;

        public var saveButton:flash.display.SimpleButton;

        public var ItemSelectionHighlight:flash.display.MovieClip;

        public var RotatePlayerControlSet:flash.display.MovieClip;

        public var PlayerName:flash.text.TextField;

        private var progressDialogResponse:flash.display.MovieClip;

        public var CreatePlayerTitle:flash.text.TextField;

        private var selectedGender:int=0;

        private var currentPagingOffset:int=0;

        private var itemCollectionData:Array;

        private var appearanceSet:Boolean;

        public var select_male:flash.display.MovieClip;

        private var isCostumesDisabled:Boolean;

        public var item1:flash.display.MovieClip;

        public var item2:flash.display.MovieClip;

        public var item3:flash.display.MovieClip;

        public var item4:flash.display.MovieClip;

        public var item5:flash.display.MovieClip;

        public var item6:flash.display.MovieClip;

        public var mcInstallZwinky:flash.display.MovieClip;

        public var scrollBackButton:flash.display.SimpleButton;

        public var LoadingItemsPleaseWait:flash.display.MovieClip;

        private var defaultClothesLoaded:Boolean=false;

        public var tabGroupContainer:flash.display.MovieClip;

        private var defaultClothesLoader:MyLife.AssetListLoader;

        private var clothingSet:Boolean;

        private var currentCategoryIdSelected:int=0;

        private var categoriesThatRequireASelection:Array;

        private var _newPlayerId:String="";

        private var _myLife:flash.display.MovieClip;

        private var currentStep:int=0;

        public var categoryButton10:flash.display.MovieClip;

        public var categoryButton11:flash.display.MovieClip;

        public var categoryButton12:flash.display.MovieClip;

        private var randomAppearanceItemLoader:MyLife.AssetListLoader;

        public var select_female:flash.display.MovieClip;

        private static var REACHED_STEP_3:Boolean=false;
    }
}
