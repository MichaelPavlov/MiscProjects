package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Xp.*;
    import caurina.transitions.*;
    import com.adobe.serialization.json.*;
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;
    import gs.*;
    
    public class HUD extends flash.display.MovieClip
    {
        public function HUD()
        {
            var loc1:*;
            var loc2:*;

            waterBalloonManager = new WaterBalloonManager();
            super();
            throwBalloonButtonIcon.gotoAndStop(1);
            btnShowMap.addEventListener(MouseEvent.CLICK, btnShowMapClick);
            btnGoHome.addEventListener(MouseEvent.CLICK, btnGoHomeClick);
            btnGoHomeArrow.addEventListener(MouseEvent.CLICK, btnGoHomeArrowClick);
            btnEditHome.addEventListener(MouseEvent.CLICK, btnEditHomeClick);
            btnChangeAppearance.addEventListener(MouseEvent.CLICK, btnChangeAppearanceClick);
            btnInventory.addEventListener(MouseEvent.CLICK, btnInventoryClick);
            btnEarnMoreCoins.addEventListener(MouseEvent.CLICK, btnEarnMoreCoinsClick);
            btnGiveFeedback.addEventListener(MouseEvent.CLICK, btnGiveFeedbackClick);
            btnMute.visible = true;
            btnUnMute.visible = false;
            btnMute.addEventListener(MouseEvent.CLICK, onBtnMuteClick);
            btnUnMute.addEventListener(MouseEvent.CLICK, onBtnUnMuteClick);
            btnActionsActivate.addEventListener(MouseEvent.CLICK, activateActionsSelector);
            actionsSelectorHideLayer.alpha = 0;
            actionsSelectorHideLayer.visible = false;
            actionsSelectorHideLayer.addEventListener(MouseEvent.MOUSE_OVER, hideActionsSelector);
            btnEmoteActivate.addEventListener(MouseEvent.CLICK, activateEmoteSelector);
            EmoteSelectorHideLayer.alpha = 0;
            EmoteSelectorHideLayer.visible = false;
            EmoteSelectorHideLayer.addEventListener(MouseEvent.MOUSE_OVER, hideEmoteSelector);
            EmoticonSelector.visible = false;
            emoteItems = [];
            sendMessageButton.addEventListener(MouseEvent.CLICK, sendMessageButtonClickHandler);
            txtMessage.addEventListener(FocusEvent.FOCUS_IN, txtMessageFocusIn);
            txtMessage.addEventListener(FocusEvent.FOCUS_OUT, txtMessageFocusOut);
            txtMessage.addEventListener(KeyboardEvent.KEY_DOWN, txtMessageKeyDown);
            tip_EnterYourChatMessageHere.visible = true;
            mapWorldSelector = new MapWorldSelector();
            mapWorldSelector.visible = false;
            mapWorldSelector.addEventListener(MyLifeEvent.WINDOW_CLOSE, closeMapWorld);
            mapWorldSelector.addEventListener(MyLifeEvent.JOIN_ZONE, onMapWorldJoinZone);
            addChild(mapWorldSelector);
            btnShowBuddyList.addEventListener(MouseEvent.CLICK, showBuddyListViewer);
            buddyListViewer = new BuddyListViewer();
            buddyListViewer.x = 10.8;
            buddyListViewer.y = 208.8;
            buddyListViewer.visible = false;
            addChild(buddyListViewer);
            btnShowEvents.addEventListener(MouseEvent.CLICK, showEventWindow, false, 0, true);
            eventWindow = new EventWindow();
            eventWindow.visible = false;
            eventWindow.x = -26.2;
            eventWindow.y = 17.4;
            addChild(eventWindow);
            eventLink = new EventLink();
            eventLink.addEventListener(MouseEvent.CLICK, eventLinkClickHandler, false, 0, true);
            eventLink.visible = false;
            eventLink.x = 328;
            eventLink.y = 510;
            addChild(eventLink);
            eventBubble = new EventBubble();
            eventBubble.addEventListener("editClick", eventBubbleEditClickHandler, false, 0, true);
            eventBubble.addEventListener("endClick", eventBubbleEndClickHandler, false, 0, true);
            eventBubble.visible = false;
            addChild(eventBubble);
            homeInfoLink = new HomeInfoLink();
            homeInfoLink.addEventListener(MouseEvent.CLICK, homeInfoLinkClickHandler, false, 0, true);
            homeInfoLink.visible = false;
            homeInfoLink.x = 329;
            homeInfoLink.y = 510;
            addChild(homeInfoLink);
            homeInfoBubble = new HomeInfoBubble();
            homeInfoBubble.addEventListener(homeInfoBubble.EVENT_SAVE_CLICKED, homeInfoBubbleSaveClickHandler, false, 0, true);
            homeInfoBubble.visible = false;
            addChild(homeInfoBubble);
            feedbackWindow = new FeedbackWindow();
            feedbackWindow.visible = false;
            addChild(feedbackWindow);
            earnCoinsWindow = new EarnCoinsWindow();
            earnCoinsWindow.visible = false;
            addChild(earnCoinsWindow);
            roomItemSelector = new RoomItemSelector();
            roomItemSelector.visible = false;
            addChild(roomItemSelector);
            chatWindowHistory = new ChatWindowHistory();
            chatWindowHistory.visible = false;
            chatWindowHistory.x = 320;
            chatWindowHistory.y = 125;
            addChild(chatWindowHistory);
            ChatBarMask.visible = false;
            EditRoomInstructions.visible = false;
            txtMemoryUsage.visible = false;
            importFriendsDialog = new ImportFriendsDialog();
            importFriendsDialog.visible = false;
            addChild(importFriendsDialog);
            setupLeaveAMessage(false);
            setupGiveGift(false);
            setResponseTime(0);
            mcLeaveAMessage.btnSeeMessages.addEventListener(MouseEvent.CLICK, btnSeeMessagesClick);
            mcHomeLock.useHandCursor = loc2 = true;
            mcHomeLock.buttonMode = loc2;
            mcHomeLock["iconClosed"].visible = false;
            mcHomeLock["iconOpen"].visible = true;
            mcHomeLock.addEventListener(MouseEvent.CLICK, homeLockClick, false, 0, true);
            homeIsLocked = false;
            mcRoomRating["rateUp"].useHandCursor = loc2 = true;
            mcRoomRating["rateUp"].buttonMode = loc2;
            mcRoomRating["rateDown"].useHandCursor = loc2 = true;
            mcRoomRating["rateDown"].buttonMode = loc2;
            mcRoomRating["rateUp"].addEventListener(MouseEvent.CLICK, rateUpClick, false, 0, true);
            mcRoomRating["rateDown"].addEventListener(MouseEvent.CLICK, rateDownClick, false, 0, true);
            mcRoomRating["rateUp"].mouseChildren = false;
            mcRoomRating["rateDown"].mouseChildren = false;
            _energyMeter = new EnergyMeter();
            TickerBar.energyMeterContainer.addEventListener(MouseEvent.ROLL_OVER, showTickerToolTip);
            TickerBar.energyMeterContainer.addEventListener(MouseEvent.ROLL_OUT, hideTickerToolTip);
            TickerBar.energyToolTip.visible = false;
            TickerBar.energyMeterContainer.addChild(_energyMeter);
            TickerBar.XpBarContainer.addEventListener(MouseEvent.ROLL_OVER, showTickerToolTip);
            TickerBar.XpBarContainer.addEventListener(MouseEvent.ROLL_OUT, hideTickerToolTip);
            TickerBar.xpToolTip.visible = false;
            TickerBar.apartmentCountIcon.addEventListener(MouseEvent.ROLL_OVER, showTickerToolTip);
            TickerBar.apartmentCountIcon.addEventListener(MouseEvent.ROLL_OUT, hideTickerToolTip);
            TickerBar.ratingToolTip.visible = false;
            loc1 = TickerBar.apartmentCountIcon as MovieClip;
            loc1.buttonMode = true;
            loc1.addEventListener(MouseEvent.CLICK, onOpenAptWindowClick, false, 0, true);
            return;
        }

        private function btnEditHomeClick(arg1:flash.events.MouseEvent):void
        {
            showEditHomeMenu();
            return;
        }

        private function homeInfoLinkClickHandler(arg1:flash.events.Event):void
        {
            if (homeInfoLink.data.isOwner)
            {
                showHomeInfoBubble(homeInfoLink.data);
            }
            return;
        }

        private function takeSaveRoomPreviewSnapshot():void
        {
            var editRoomZone:flash.display.MovieClip;
            var id:String;
            var jpegSnapshot:MyLife.JPEGSnapshot;
            var loc1:*;
            var loc2:*;

            editRoomZone = null;
            jpegSnapshot = null;
            id = null;
            try
            {
                editRoomZone = _myLife.zone.getZoneMovieObject();
                editRoomZone.enableScreenshotMode();
                jpegSnapshot = new JPEGSnapshot(85);
                jpegSnapshot.setUploadServer(_myLife.myLifeConfiguration.variables["global"]["new_upload_server"]);
                if (_myLife.zone.homeData)
                {
                    id = _myLife.player._playerId + "-" + _myLife.zone._zoneName;
                }
                else 
                {
                    id = _myLife.player._playerId + "-" + editRoomZone.roomName;
                }
                jpegSnapshot.capture(editRoomZone, id);
            }
            catch (e:*)
            {
            };
            jpegSaveRoomSnapshotCaptureComplete();
            return;
        }

        public function onBtnUnMuteClick(arg1:flash.events.MouseEvent=null):void
        {
            btnMute.visible = true;
            btnUnMute.visible = false;
            MyLifeSoundController.getInstance().unMute();
            return;
        }

        public function toggleHomeLock():void
        {
            setIsHomeLocked(!homeIsLocked);
            return;
        }

        private function btnShowMapClick(arg1:flash.events.MouseEvent):void
        {
            MyLifeInstance.getInstance().closeAllPopupCollection();
            mapWorldSelector.visible = true;
            mapWorldSelector.alpha = 0;
            mapWorldSelector.setYouAreHereLocation(_myLife.zone.getCurrentZoneName());
            _myLife.showDialog(mapWorldSelector, true);
            TweenLite.to(mapWorldSelector, 0.5, {"alpha":1});
            return;
        }

        public function hideHomeInfoLink():void
        {
            homeInfoLink.deactivate();
            return;
        }

        private function txtMessageKeyDown(arg1:flash.events.KeyboardEvent):void
        {
            if (arg1.keyCode == Keyboard.ENTER && arg1.shiftKey == false)
            {
                sendMessage();
            }
            else 
            {
                tip_EnterYourChatMessageHere.visible = false;
                _typingActivity = true;
            }
            return;
        }

        private function setResponseTime(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = Math.round(arg1 / 400 * 5);
            loc3 = loc2 + 1;
            if (loc3 < 0)
            {
                loc3 = 0;
            }
            if (loc3 > 6)
            {
                loc3 = 6;
            }
            ResponseTime.gotoAndStop(loc3);
            return;
        }

        private function typingStatusTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (_typingActivity)
            {
                _myLife.server.callExtension("updateCharacterProperty", {"p":"tp", "v":{}, "s":0});
            }
            _typingActivity = false;
            return;
        }

        public function updatePlayerEnergy(arg1:int):void
        {
            if (_energyMeter)
            {
                _energyMeter.moveTo(arg1);
            }
            return;
        }

        private function inventoryClosedHandler(arg1:flash.events.Event):void
        {
            if (_inventoryScreen)
            {
                _inventoryScreen.removeEventListener(Event.CLOSE, inventoryClosedHandler);
                _inventoryScreen = null;
            }
            return;
        }

        private function emoteItemHighlight(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = new GlowFilter();
            loc2.color = 16768000;
            loc2.blurY = loc5 = 10;
            loc2.blurX = loc5;
            arg1.currentTarget.filters = [loc2];
            loc3 = arg1.currentTarget.width;
            loc4 = arg1.currentTarget.height;
            arg1.currentTarget.scaleY = loc5 = 1.1;
            arg1.currentTarget.scaleX = loc5;
            arg1.currentTarget.x = arg1.currentTarget.x - (arg1.currentTarget.width - loc3) / 2;
            arg1.currentTarget.y = arg1.currentTarget.y - (arg1.currentTarget.height - loc4) / 2;
            return;
        }

        private function hideActionsSelector(arg1:flash.events.MouseEvent=null):void
        {
            actionsSelectorHideLayer.visible = false;
            _myLife.hideDialog(animationMenu);
            animationMenu.cleanUp();
            return;
        }

        private function reapplyFilter(arg1:flash.display.DisplayObject, arg2:flash.filters.GlowFilter):void
        {
            if (arg1.filters.length > 0)
            {
                arg1.filters = [arg2];
            }
            return;
        }

        private function eventLinkClickHandler(arg1:flash.events.MouseEvent):void
        {
            showEventBubble(eventLink.eventData);
            return;
        }

        private function eventBubbleEndClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            eventLink.deactivate();
            loc2 = eventBubble.eventData;
            _myLife.getZone().deleteEvent(loc2);
            return;
        }

        public function rateResetClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = _myLife._interface.showInterface("GenericDialog", {"title":"Reset Room Rating?", "message":"Are you sure you want to reset your apartment\'s rating?", "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"Cancel", "value":"BTN_NO"}]});
            loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmResetRating);
            return;
        }

        private function btnGiveFeedbackClick(arg1:flash.events.MouseEvent):void
        {
            feedbackWindow.visible = true;
            feedbackWindow.alpha = 0;
            feedbackWindow.resetForm(_myLife);
            TweenLite.to(FeedbackWindow, 0.5, {"alpha":1});
            return;
        }

        public function actionsIconHighlite(arg1:Boolean):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1)
            {
                loc2 = new GlowFilter(5335973, 1, 5, (5), 2, 3);
                btnActionsActivate.filters = [loc2];
                TweenLite.to(loc2, 1, {"blurX":10, "blurY":10, "onUpdate":reapplyFilter, "onUpdateParams":[btnActionsActivate, loc2], "onComplete":shrinkIconGlow, "onCompleteParams":[btnActionsActivate]});
            }
            else 
            {
                if (btnActionsActivate.filters)
                {
                    btnActionsActivate.filters = null;
                }
            }
            return;
        }

        private function btnShowThrowBalloonMouseDown(arg1:flash.events.MouseEvent):void
        {
            buddyListViewer.deactivate();
            if (throwBalloonButtonIcon.currentFrame > 2)
            {
                _myLife._interface.showInterface("GenericDialog", {"title":"Water Balloon", "message":"Please wait until the water balloon has filled up before throwing it again."});
                return;
            }
            waterBalloonManager.startBalloonDrag();
            return;
        }

        public function hideEventLink():void
        {
            eventLink.deactivate();
            return;
        }

        private function btnSeeMessagesClick(arg1:flash.events.MouseEvent):void
        {
            showWallMessages();
            return;
        }

        public function get unreadMessageCount():int
        {
            return _unreadMessageCount;
        }

        private function showEventBubble(arg1:Object):void
        {
            eventBubble.activate(arg1);
            return;
        }

        private function updateMemoryUsage():void
        {
            var loc1:*;

            loc1 = Number(System.totalMemory / 1024 / 1024).toFixed(2);
            txtMemoryUsage.text = loc1;
            return;
        }

        private function emoteItemUnhighlight(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            arg1.currentTarget.filters = [];
            arg1.currentTarget.scaleY = loc2 = 1;
            arg1.currentTarget.scaleX = loc2;
            arg1.currentTarget.x = emoteItems[arg1.currentTarget.name].orgX;
            arg1.currentTarget.y = emoteItems[arg1.currentTarget.name].orgY;
            return;
        }

        private function activateActionsSelector(arg1:flash.events.MouseEvent):void
        {
            buddyListViewer.deactivate();
            eventWindow.deactivate();
            actionsSelectorHideLayer.visible = true;
            actionsIconHighlite(false);
            animationMenu = new AnimationMenu();
            animationMenu.x = arg1.currentTarget.x - (arg1.currentTarget.width >> 1);
            animationMenu.y = arg1.currentTarget.y - animationMenu.height - (arg1.currentTarget.height >> 1);
            animationMenu.addEventListener(MyLifeEvent.PLAY_ANIMATION, animationMenuHandler);
            _myLife.showDialog(animationMenu);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.MENU_ACTIONS_ACTIVATING));
            return;
        }

        private function txtMessageFocusIn(arg1:flash.events.FocusEvent):void
        {
            tip_EnterYourChatMessageHere.visible = false;
            return;
        }

        private function playerApartmentCountUpdate(arg1:MyLife.MyLifeEvent):void
        {
            _latestRoomCount = arg1.eventData.count;
            _updateApartmentCountTimer.reset();
            _updateApartmentCountTimer.start();
            return;
        }

        public function toggleRatingResetButton(arg1:Boolean):void
        {
            return;
        }

        public function showEditHomeMenu():void
        {
            _myLife.zone.addEventListener(MyLifeEvent.LOADING_EDIT_DONE, doneLoadingEditItems);
            _myLife.zone.enableEditMode();
            return;
        }

        public function rateUpClick(arg1:flash.events.MouseEvent):void
        {
            _myLife.getZone().rateApartment(1);
            return;
        }

        private function updateMessageCount(arg1:MyLife.MyLifeEvent):void
        {
            unreadMessageCount = int(arg1.eventData);
            return;
        }

        private function sendMessageButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            sendMessage();
            return;
        }

        private function btnGoHomeArrowClick(arg1:flash.events.MouseEvent):void
        {
            MyLifeInstance.getInstance().closeAllPopupCollection();
            buddyListViewer.deactivate();
            eventWindow.deactivate();
            _myLife._interface.showInterface("ViewHomes", {"playerId":_myLife.player._playerId});
            return;
        }

        private function sendMessageValidTimerHandler(arg1:flash.events.TimerEvent):void
        {
            isSendMessageValid = true;
            return;
        }

        private function onRoundTripTimeUpdate(arg1:MyLife.MyLifeEvent):void
        {
            setResponseTime(arg1.eventData.ms);
            return;
        }

        public function setupLeaveAMessage(arg1:Boolean, arg2:Boolean=false):void
        {
            mcLeaveAMessage.visible = arg1;
            if (arg1)
            {
                if (arg2)
                {
                    mcLeaveAMessage.mcLabelLeaveAMessage.visible = false;
                    mcLeaveAMessage.mcLabelReadMessages.visible = true;
                    mcLeaveAMessage.txtNewMessageCount.visible = unreadMessageCount > 0;
                }
                else 
                {
                    mcLeaveAMessage.mcLabelLeaveAMessage.visible = true;
                    mcLeaveAMessage.mcLabelReadMessages.visible = false;
                    mcLeaveAMessage.txtNewMessageCount.visible = false;
                }
            }
            return;
        }

        private function animationMenuHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = false;
            loc4 = undefined;
            if (arg1.eventData)
            {
                loc3 = MyLifeInstance.getInstance().getPlayer()._character.freeActions;
                if ((loc4 = arg1.eventData).e > _myLife.player.getEnergyLevel() && !loc3)
                {
                    _myLife._interface.showInterface("GenericDialog", {"title":"You Need More Energy", "message":"You don\'t have enough energy to perform this action.\nBuy some food at Vinny\'s Diner to build up more energy."});
                }
                else 
                {
                    if (!loc3)
                    {
                        _myLife.server.callExtension("updateCharacterEnergy", {"e":-loc4.e});
                    }
                    _myLife.player._character.doAvatarAction(loc4.a, true, loc4["params"]);
                }
            }
            loc2 = arg1.currentTarget as AnimationMenu;
            loc2.removeEventListener(MyLifeEvent.PLAY_ANIMATION, animationMenuHandler);
            hideActionsSelector();
            return;
        }

        public function inventoryBtnHighlite(arg1:Boolean):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1)
            {
                loc2 = new GlowFilter(5335973, 1, 5, (5), 2, 3);
                btnInventory.filters = [loc2];
                TweenLite.to(loc2, 1, {"blurX":10, "blurY":10, "onUpdate":reapplyFilter, "onUpdateParams":[btnInventory, loc2], "onComplete":shrinkIconGlow, "onCompleteParams":[btnInventory]});
            }
            else 
            {
                if (btnInventory.filters)
                {
                    btnInventory.filters = null;
                }
            }
            return;
        }

        private function giftReceivedHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = null;
            loc2 = arg1.eventData;
            loc3 = loc2.params.senderName;
            loc4 = "You\'ve Received a Gift!";
            if (loc3)
            {
                loc5 = loc3 + " has sent you a gift.";
            }
            else 
            {
                loc5 = "You have received a gift.";
            }
            loc5 = loc5 + " Open your gift now?";
            (loc6 = _myLife._interface.showInterface("GenericDialog", {"title":loc4, "message":loc5, "buttons":[{"name":"Open Gift", "value":"BTN_YES"}, {"name":"Cancel", "value":"BTN_NO"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, receivedGiftDialogResponseHandler, false, 0, true);
            return;
        }

        private function btnChangeAppearanceClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.DO_CHANGE_APPEARANCE, {}, true));
            return;
        }

        private function shrinkIconGlow(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.filters)
            {
                loc2 = arg1.filters[0];
                TweenLite.to(loc2, 1, {"blurX":5, "blurY":5, "onUpdate":reapplyFilter, "onUpdateParams":[arg1, loc2], "onComplete":growIconGlow, "onCompleteParams":[arg1]});
            }
            return;
        }

        private function growIconGlow(arg1:flash.display.DisplayObject):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.filters)
            {
                loc2 = arg1.filters[0];
                TweenLite.to(loc2, 1, {"blurX":10, "blurY":10, "onUpdate":reapplyFilter, "onUpdateParams":[arg1, loc2], "onComplete":shrinkIconGlow, "onCompleteParams":[arg1]});
            }
            return;
        }

        public function showWallMessages():void
        {
            mcLeaveAMessage.txtNewMessageCount.visible = false;
            _myLife._interface.showInterface("WindowReadMessages", {});
            return;
        }

        public function confirmResetRating(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                _myLife.getZone().resetApartmentRating();
            }
            return;
        }

        private function onXpManagerGainXp(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;

            loc2 = TickerBar.xpScrollingText as TextField;
            loc2.x = TickerBar.XpBarContainer.x - loc2.width * 0.5 + 10;
            loc2.y = 100;
            loc2.alpha = 1;
            loc2.text = "+" + arg1.data.xp + " YP";
            Tweener.addTween(loc2, {"time":1.5, "y":5, "onComplete":xpManagerGainXpAnimationComplete});
            return;
        }

        private function roundTripTimerTick(arg1:flash.events.TimerEvent):void
        {
            _myLife.server.roundTripBench();
            return;
        }

        private function showBuddyListViewer(arg1:flash.events.MouseEvent):void
        {
            eventWindow.deactivate();
            if (buddyListViewer == null)
            {
                buddyListViewer = new BuddyListViewer();
                buddyListViewer.x = 10.8;
                buddyListViewer.y = 208.8;
                buddyListViewer.visible = false;
                addChild(buddyListViewer);
            }
            buddyListViewer.activate();
            return;
        }

        private function updateApartmentCountTimerTick(arg1:flash.events.TimerEvent):void
        {
            if (_latestRoomCount <= 0)
            {
                TickerBar.txtApartmentCount.htmlText = "Nobody is in your apartment";
            }
            else 
            {
                if (_latestRoomCount != 1)
                {
                    TickerBar.txtApartmentCount.htmlText = "<b>" + _latestRoomCount + "</b> people are in your apartment";
                }
                else 
                {
                    TickerBar.txtApartmentCount.htmlText = "<b>1</b> person is in your apartment";
                }
            }
            return;
        }

        public function show():void
        {
            _myLife.debug("Show HUD");
            MovieClip(this).visible = true;
            return;
        }

        public function homeLockClick(arg1:flash.events.MouseEvent):void
        {
            toggleHomeLock();
            return;
        }

        public function rateDownClick(arg1:flash.events.MouseEvent):void
        {
            _myLife.getZone().rateApartment(-1);
            return;
        }

        private function btnInventoryClick(arg1:flash.events.MouseEvent):void
        {
            inventoryBtnHighlite(false);
            if (!_inventoryScreen)
            {
                _inventoryScreen = new ViewInventory();
                _inventoryScreen.addEventListener(Event.CLOSE, inventoryClosedHandler);
                _inventoryScreen.initialize(_myLife, {});
            }
            _myLife.showDialog(_inventoryScreen, true);
            return;
        }

        public function getGiftCount():int
        {
            return giftCount;
        }

        public function setRoomRatingTotal(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = mcRoomRating["rateTotal"]["total"] as TextField;
            loc2.text = String(arg1);
            loc3 = new TextFormat();
            if (arg1 < 0)
            {
                loc3.color = 16711680;
            }
            else 
            {
                if (arg1 > 0)
                {
                    loc3.color = 65280;
                }
                else 
                {
                    loc3.color = 16777215;
                }
            }
            loc2.setTextFormat(loc3);
            return;
        }

        public function setIsHomeLocked(arg1:Boolean):void
        {
            var loc2:*;

            homeIsLocked = arg1;
            mcHomeLock["iconClosed"].visible = homeIsLocked;
            mcHomeLock["iconOpen"].visible = !homeIsLocked;
            loc2 = mcHomeLock["textField"] as TextField;
            if (homeIsLocked)
            {
                loc2.text = "Home\nLocked";
            }
            else 
            {
                loc2.text = "Home\nUnlocked";
            }
            _myLife.getZone().setApartmentLock(homeIsLocked);
            return;
        }

        private function memUsageTimerTick(arg1:flash.events.TimerEvent):void
        {
            updateMemoryUsage();
            return;
        }

        private function btnCancelRoomChangesClick(arg1:flash.events.MouseEvent):void
        {
            hideEditHomeMenu();
            _myLife.zone.disableEditMode();
            return;
        }

        public function setMode(arg1:String):void
        {
            var loc2:*;

            trace("setMode(" + arg1 + ")");
            mode = arg1;
            loc2 = mode;
            switch (loc2) 
            {
                case HUD.MODE_HOME_EDIT:
                    btnEditHome.mouseEnabled = false;
                    chatWindowHistory.visible = false;
                    mcHomeLock.visible = false;
                    setupLeaveAMessage(false);
                    setupGiveGift(false);
                    homeInfoLink.visible = false;
                    homeInfoBubble.visible = false;
                    eventWindow.visible = false;
                    buddyListViewer.deactivate();
                    hideEmoteSelector();
                    break;
                case HUD.MODE_HOME_VISITOR:
                    btnGoHome.visible = true;
                    mcHomeLock.visible = false;
                    mcRoomRating.visible = true;
                    toggleRoomRatings(false);
                    toggleRatingResetButton(false);
                    setupLeaveAMessage(true, false);
                    setupGiveGift(true, false);
                    homeInfoLink.data = null;
                    homeInfoLink.visible = false;
                    homeInfoBubble.visible = false;
                    break;
                case HUD.MODE_HOME_VISITOR_ASYNC_MENU:
                    btnGoHome.visible = true;
                    mcHomeLock.visible = false;
                    mcRoomRating.visible = true;
                    toggleRoomRatings(false);
                    toggleRatingResetButton(false);
                    setupLeaveAMessage(false, false);
                    setupGiveGift(false, false);
                    homeInfoLink.data = null;
                    homeInfoLink.visible = false;
                    homeInfoBubble.visible = false;
                    break;
                case HUD.MODE_HOME_OWNER:
                    btnGoHome.visible = false;
                    btnEditHome.mouseEnabled = true;
                    mcHomeLock.visible = true;
                    mcRoomRating.visible = true;
                    toggleRoomRatings(true);
                    toggleRatingResetButton(true);
                    setupLeaveAMessage(true, true);
                    setupGiveGift(giftCount > 0, true, giftCount);
                    chatWindowHistory.visible = true;
                    if (homeInfoLink.data)
                    {
                        homeInfoLink.visible = true;
                    }
                    break;
                case HUD.MODE_MAP_VISITOR:
                    btnGoHome.visible = true;
                    mcHomeLock.visible = false;
                    homeInfoLink.data = null;
                    homeInfoLink.visible = false;
                    homeInfoBubble.visible = false;
                    mcRoomRating.visible = false;
                    toggleRatingResetButton(false);
                    setupLeaveAMessage(false);
                    setupGiveGift(false);
                default:
                    break;
            }
            return;
        }

        public function giveGiftClickHandler(arg1:flash.events.MouseEvent=null):void
        {
            openGiftWindow();
            return;
        }

        public function set unreadMessageCount(arg1:int):void
        {
            _unreadMessageCount = arg1;
            if (_unreadMessageCount <= 0)
            {
                mcLeaveAMessage.txtNewMessageCount.visible = false;
            }
            else 
            {
                if (_unreadMessageCount != 1)
                {
                    mcLeaveAMessage.txtNewMessageCount.text = _unreadMessageCount + " New Messages";
                }
                else 
                {
                    mcLeaveAMessage.txtNewMessageCount.text = "1 New Message";
                }
            }
            setupLeaveAMessage(mcLeaveAMessage.visible, mcLeaveAMessage.mcLabelReadMessages.visible);
            return;
        }

        private function btnSaveRoomChangesClick(arg1:flash.events.MouseEvent):void
        {
            _savingDialog = _myLife._interface.showInterface("ProgressDialog", {"title":"Saving Room Changes...", "keepWindowOpen":true});
            arg1.updateAfterEvent();
            takeSaveRoomPreviewSnapshot();
            dispatchEvent(new MyLifeEvent(MyLifeEvent.SAVE_ROOM_START));
            return;
        }

        private function onOpenAptWindowClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = new StandardDialog(new ApartmentRatingWindow(), "Apartment All-Stars", 400, 340);
            (_myLife as MyLife).showDialog(loc2, true);
            trace("opening!");
            return;
        }

        private function updateXpTitle(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = TickerBar.xpTitle as TextField;
            loc2.x = 220;
            loc2.y = 33;
            if (XpManager.instance.getTitle())
            {
                loc3 = XpManager.instance.getTitle();
            }
            else 
            {
                loc3 = "No Name";
            }
            loc2.htmlText = "<b>" + loc3 + "</b>";
            return;
        }

        private function receivedGiftDialogResponseHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            loc2 = null;
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                loc2 = {};
                loc2.playerId = _myLife.player._playerId;
                loc2.title = "You Received a New Gift!";
                _myLife._interface.showInterface("GiftWindow", loc2);
            }
            return;
        }

        private function activateEmoteSelector(arg1:flash.events.MouseEvent):void
        {
            buddyListViewer.deactivate();
            eventWindow.deactivate();
            EmoticonSelector.visible = true;
            EmoteSelectorHideLayer.visible = true;
            return;
        }

        public function hide():void
        {
            _myLife.debug("Hide HUD");
            MovieClip(this).visible = false;
            return;
        }

        public function openGiftWindow(arg1:Object=null):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = 0;
            loc2 = null;
            if (_myLife.zone._apartmentMode)
            {
                loc3 = arg1 || {};
                loc5 = mode;
                switch (loc5) 
                {
                    case HUD.MODE_HOME_OWNER:
                        loc3.playerId = _myLife.player._playerId;
                        loc2 = _myLife._interface.showInterface("GiftWindow", loc3);
                        break;
                    case HUD.MODE_HOME_VISITOR:
                        loc4 = _myLife.zone.currentOwnerPlayerId;
                        loc3.giftData = {"recipientPlayerId":loc4};
                        loc2 = _myLife._interface.showInterface("GiftStepInventory", loc3);
                        break;
                }
            }
            return loc2;
        }

        public function showEventLink(arg1:Object):void
        {
            trace("Show Event Link");
            eventLink.activate(arg1);
            homeInfoLink.deactivate();
            return;
        }

        public function toggleRoomRatings(arg1:Boolean):void
        {
            mcRoomRating["rateTotal"].visible = arg1;
            mcRoomRating["rateUp"].visible = !arg1;
            mcRoomRating["rateDown"].visible = !arg1;
            return;
        }

        private function hideEmoteSelector(arg1:flash.events.MouseEvent=null):void
        {
            EmoticonSelector.visible = false;
            EmoteSelectorHideLayer.visible = false;
            return;
        }

        private function btnEarnMoreCoinsClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            earnCoinsWindow.visible = true;
            earnCoinsWindow.alpha = 0;
            setChildIndex(earnCoinsWindow, (numChildren - 1));
            loc2 = _myLife.myLifeConfiguration.platformType == _myLife.myLifeConfiguration.PLATFORM_FACEBOOK;
            if (loc2)
            {
                earnCoinsWindow.stepFive.visible = true;
            }
            else 
            {
                earnCoinsWindow.stepFive.visible = false;
            }
            TweenLite.to(earnCoinsWindow, 0.5, {"alpha":1});
            return;
        }

        private function hideTickerToolTip(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            clearInterval(toolTipInterval);
            loc2 = null;
            loc3 = arg1.currentTarget;
            switch (loc3) 
            {
                case TickerBar.energyMeterContainer:
                    loc2 = TickerBar.energyToolTip;
                    break;
                case TickerBar.XpBarContainer:
                    loc2 = TickerBar.xpToolTip;
                    break;
                case TickerBar.apartmentCountIcon:
                    loc2 = TickerBar.ratingToolTip;
                    break;
            }
            if (loc2)
            {
                loc2.visible = false;
            }
            return;
        }

        private function sendMessage():void
        {
            var loc1:*;

            loc1 = null;
            _typingActivity = false;
            if (txtMessage.text == "")
            {
                return;
            }
            if (isSendMessageValid)
            {
                loc1 = txtMessage.text;
                loc1 = "C:" + loc1;
                dispatchEvent(new MyLifeEvent(MyLifeEvent.SEND_MESSAGE, {"msg":loc1, "recipient":0}, true));
                txtMessage.text = "";
                isSendMessageValid = false;
                sendMessageValidTimer.reset();
                sendMessageValidTimer.start();
            }
            return;
        }

        public function showHomeInfoLink(arg1:Object):void
        {
            trace("Show Home Info Link");
            homeInfoLink.activate(arg1);
            return;
        }

        public function hideEditHomeMenu():void
        {
            TweenLite.to(roomItemSelector, 0.5, {"alpha":0, "y":-roomItemSelector.height, "onComplete":hideMovieClip, "onCompleteParams":[roomItemSelector]});
            EditRoomInstructions.alpha = 1;
            TweenLite.to(EditRoomInstructions, 0.5, {"alpha":0, "onComplete":hideMovieClip, "onCompleteParams":[EditRoomInstructions]});
            roomItemSelector.btnSaveChanges.removeEventListener(MouseEvent.CLICK, btnSaveRoomChangesClick);
            roomItemSelector.btnCancelChanges.removeEventListener(MouseEvent.CLICK, btnCancelRoomChangesClick);
            return;
        }

        private function showHomeInfoBubble(arg1:Object=null):void
        {
            arg1 = arg1 || {};
            homeInfoBubble.activate(arg1);
            return;
        }

        private function xpManagerGainXpAnimationComplete():void
        {
            Tweener.addTween(TickerBar.xpScrollingText, {"time":0.5, "alpha":0});
            return;
        }

        public function onBtnMuteClick(arg1:flash.events.MouseEvent=null):void
        {
            btnMute.visible = false;
            btnUnMute.visible = true;
            MyLifeSoundController.getInstance().mute();
            return;
        }

        private function showTickerToolTip(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = arg1.currentTarget;
            switch (loc3) 
            {
                case TickerBar.energyMeterContainer:
                    TickerBar.energyToolTip.percent.htmlText = "<b>" + _energyMeter.getValue() + "% Energy</b>";
                    loc2 = TickerBar.energyToolTip;
                    break;
                case TickerBar.XpBarContainer:
                    loc2 = TickerBar.xpToolTip;
                    break;
                case TickerBar.apartmentCountIcon:
                    loc2 = TickerBar.ratingToolTip;
                    break;
            }
            if (loc2)
            {
                toolTipInterval = setInterval(showToolTipAfterDelay, 500, loc2);
            }
            return;
        }

        public function setGiftCount(arg1:int):void
        {
            giftCount = arg1;
            return;
        }

        private function setupXpBar(arg1:MyLife.Xp.XpManagerEvent=null):void
        {
            XpManager.instance.removeEventListener(XpManagerEvent.XP_MANAGER_INITIALIZED, setupXpBar);
            if (XpManager.instance.isInitialized())
            {
                (TickerBar.txtApartmentCount as TextField).visible = false;
                TickerBar.XpBarContainer.addChild(XpManager.instance.getXpProgressBar());
                updateXpTitle(null);
                TickerBar.xpScrollingText.alpha = 0;
                (TickerBar.xpScrollingText as TextField).mouseEnabled = false;
                XpManager.instance.addEventListener(XpManagerEvent.XP_MANAGER_GAIN_XP, onXpManagerGainXp, false, 0, true);
                TickerBar.apartmentCountIcon.x = 495;
                TickerBar.apartmentCountIcon.visible = false;
            }
            else 
            {
                XpManager.instance.addEventListener(XpManagerEvent.XP_MANAGER_INITIALIZED, setupXpBar);
            }
            return;
        }

        public function set giftCount(arg1:int):void
        {
            lastGiftCount = arg1;
            if (mode == MODE_HOME_OWNER)
            {
                if (giftCount <= 0)
                {
                    mcGiveGift.visible = false;
                }
                else 
                {
                    if (giftCount != 1)
                    {
                        mcGiveGift.giftCountTextField.text = giftCount + " New Gifts";
                    }
                    else 
                    {
                        mcGiveGift.giftCountTextField.text = "1 New Gift";
                    }
                }
                mcGiveGift.giftCountTextField.visible = lastGiftCount > 0;
            }
            return;
        }

        public function showOverlayButtons(arg1:Boolean=true):void
        {
            btnEditHome.mouseEnabled = arg1;
            chatWindowHistory.visible = arg1;
            mcHomeLock.visible = arg1;
            setupLeaveAMessage(arg1);
            return;
        }

        private function hideMovieClip(arg1:*):void
        {
            arg1.visible = false;
            return;
        }

        private function setEnergy(arg1:Number):void
        {
            if (_energyMeter)
            {
                _energyMeter.moveTo(arg1);
            }
            return;
        }

        public function setupGiveGift(arg1:Boolean, arg2:Boolean=false, arg3:int=-1):void
        {
            if (arg3 != -1)
            {
                giftCount = arg3;
            }
            mcGiveGift.visible = arg1;
            mcGiveGift.giveGiftTextField.visible = !arg2;
            mcGiveGift.viewYourGiftsTextField.visible = arg2;
            mcGiveGift.giftCountTextField.visible = giftCount && arg2;
            return;
        }

        private function jpegSaveRoomSnapshotCaptureComplete(arg1:MyLife.MyLifeEvent=null):void
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

            loc6 = null;
            loc7 = 0;
            loc8 = null;
            loc9 = null;
            loc2 = _myLife.zone.getZoneMovieObject();
            loc3 = loc2.getSaveRoomObj();
            loc4 = loc3.roomData.furnitureItemCollection;
            loc5 = [];
            loc10 = 0;
            loc11 = loc4;
            for each (loc6 in loc11)
            {
                if (loc6.playerItemId)
                {
                    continue;
                }
                loc5.push(loc6);
            }
            loc10 = 0;
            loc11 = loc5;
            for each (loc6 in loc11)
            {
                loc7 = loc4.indexOf(loc6);
                loc4.splice(loc7, 1);
            }
            loc3.roomData.furnitureItemCollection = loc4;
            loc8 = JSON.encode(loc3.roomData);
            loc9 = String(_myLife.myLifeConfiguration.variables["querystring"]["lk"]);
            _myLife.server.addEventListener("MLXT_savePlayerRoom", onSavePlayerRoomComplete);
            _myLife.server.callExtension("savePlayerRoom", {"roomName":loc3.roomName, "roomObj":loc8, "lk":loc9, "playerHomeRoomId":loc3.playerHomeRoomId});
            return;
        }

        private function emoteItemClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            hideEmoteSelector();
            loc2 = emoteItems[arg1.currentTarget.name].i;
            dispatchEvent(new MyLifeEvent(MyLifeEvent.SEND_MESSAGE, {"msg":"E:" + loc2, "recipient":0}, true));
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            roomItemSelector.initialize(_myLife);
            initEmoticonSelector();
            _typingStatusTimer = new Timer(2000);
            _typingStatusTimer.addEventListener("timer", typingStatusTimerTick);
            _typingStatusTimer.start();
            sendMessageValidTimer = new Timer(MESSAGE_MIN_TIME, 1);
            sendMessageValidTimer.addEventListener(TimerEvent.TIMER, sendMessageValidTimerHandler, false, 0, true);
            isSendMessageValid = true;
            _updateApartmentCountTimer = new Timer(1000, 1);
            _updateApartmentCountTimer.addEventListener("timer", updateApartmentCountTimerTick);
            _myLife.addEventListener(MyLifeEvent.PLAYER_APARTMENT_COUNT_UPDATE, playerApartmentCountUpdate);
            setEnergy(0);
            TickerBar.txtApartmentCount.htmlText = "Nobody is in your apartment";
            btnShowThrowBalloon.addEventListener(MouseEvent.MOUSE_DOWN, btnShowThrowBalloonMouseDown);
            mcGiveGift.btnGiveGift.addEventListener(MouseEvent.CLICK, giveGiftClickHandler, false, 0, true);
            _myLife.server.playerToPlayerEventHandler.addEventListener(MyLifeEvent.GIFT_RESPONSE, giftReceivedHandler, false, 0, true);
            _myLife.server.addEventListener(MyLifeEvent.MESSAGE_COUNT, updateMessageCount, false, 0, true);
            setupXpBar();
            XpManager.instance.getXpProgressBar().addEventListener(XpManagerEvent.XP_PROGRESS_BAR_FULL, updateXpTitle);
            return;
        }

        private function onMapWorldJoinZone(arg1:MyLife.MyLifeEvent):void
        {
            _myLife.hideDialog(mapWorldSelector);
            return;
        }

        private function closeMapWorld(arg1:MyLife.MyLifeEvent):void
        {
            TweenLite.to(mapWorldSelector, 0.5, {"alpha":0, "onComplete":onMapWorldJoinZone, "onCompleteParams":[null]});
            return;
        }

        public function showRoomItemSelector():void
        {
            trace("showRoomItemSelector");
            roomItemSelector.y = 1.12;
            roomItemSelector.alpha = 1;
            roomItemSelector.visible = true;
            return;
        }

        public function setReferralLinkPlayerId(arg1:Number):void
        {
            return;
        }

        private function initEmoticonSelector():void
        {
            var loc1:*;
            var loc2:*;

            loc2 = undefined;
            loc1 = 1;
            while (loc1 <= 24) 
            {
                loc2 = EmoticonSelector[("emote" + loc1)];
                loc2.gotoAndStop(loc1);
                loc2.buttonMode = true;
                emoteItems[("emote" + loc1)] = {"i":loc1, "mc":loc2, "orgX":loc2.x, "orgY":loc2.y};
                loc2.addEventListener(MouseEvent.CLICK, emoteItemClick);
                loc2.addEventListener(MouseEvent.MOUSE_OVER, emoteItemHighlight);
                loc2.addEventListener(MouseEvent.MOUSE_OUT, emoteItemUnhighlight);
                ++loc1;
            }
            return;
        }

        private function doneLoadingEditItems(arg1:MyLife.MyLifeEvent):void
        {
            roomItemSelector.loadInventory();
            roomItemSelector.visible = true;
            roomItemSelector.alpha = 0;
            roomItemSelector.y = -roomItemSelector.height;
            TweenLite.to(roomItemSelector, 0.5, {"alpha":1, "y":1.12});
            EditRoomInstructions.visible = true;
            EditRoomInstructions.alpha = 0;
            TweenLite.to(EditRoomInstructions, 0.5, {"alpha":1});
            roomItemSelector.btnSaveChanges.addEventListener(MouseEvent.CLICK, btnSaveRoomChangesClick);
            roomItemSelector.btnCancelChanges.addEventListener(MouseEvent.CLICK, btnCancelRoomChangesClick);
            return;
        }

        public function get giftCount():int
        {
            return lastGiftCount;
        }

        private function eventBubbleEditClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = eventBubble.eventData;
            eventWindow.activate("edit", loc2);
            return;
        }

        private function showToolTipAfterDelay(arg1:flash.display.MovieClip):void
        {
            clearInterval(toolTipInterval);
            if (arg1)
            {
                arg1.visible = true;
            }
            return;
        }

        private function onSavePlayerRoomComplete(arg1:MyLife.MyLifeEvent):void
        {
            _myLife.server.removeEventListener("MLXT_savePlayerRoom", onSavePlayerRoomComplete);
            hideEditHomeMenu();
            _myLife._interface.unloadInterface(_savingDialog);
            dispatchEvent(new MyLifeEvent(MyLifeEvent.SAVE_ROOM_COMPLETE));
            return;
        }

        private function btnGoHomeClick(arg1:flash.events.MouseEvent):void
        {
            MyLifeInstance.getInstance().closeAllPopupCollection();
            dispatchEvent(new MyLifeEvent(MyLifeEvent.DO_GO_HOME, {}, true));
            return;
        }

        private function showEventWindow(arg1:flash.events.MouseEvent):void
        {
            buddyListViewer.deactivate();
            eventWindow.activate();
            return;
        }

        private function initMemoryUsage():void
        {
            txtMemoryUsage.visible = true;
            _memUsageTimer = new Timer(1000, 0);
            _memUsageTimer.addEventListener("timer", memUsageTimerTick);
            _memUsageTimer.start();
            updateMemoryUsage();
            return;
        }

        private function txtMessageFocusOut(arg1:flash.events.FocusEvent):void
        {
            if (txtMessage.text == "")
            {
                tip_EnterYourChatMessageHere.visible = true;
            }
            return;
        }

        private function homeInfoBubbleSaveClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc2 = null;
            loc3 = null;
            loc4 = homeInfoLink.isDefault;
            loc5 = homeInfoBubble.isDefault;
            if (loc4 != loc5)
            {
                loc2 = {};
                if (loc5)
                {
                    loc2.playerItemId = _myLife.zone.currentPlayerHomeId;
                }
                else 
                {
                    loc2.playerItemId = 0;
                }
                _myLife.server.callExtension("HomeManager.setDefaultHome", loc2);
                _myLife.player.defaultHomePlayerItemId = loc2.playerItemId;
                loc3 = homeInfoLink.data;
                loc3.isDefault = loc5;
                homeInfoLink.activate(loc3);
            }
            loc6 = homeInfoLink.title;
            loc7 = homeInfoBubble.title;
            if (!(loc6 == loc7) && _myLife.zone.currentPlayerHomeId)
            {
                loc2 = {};
                loc2.title = loc7;
                loc2.playerItemId = _myLife.zone.currentPlayerHomeId;
                _myLife.server.callExtension("HomeManager.setHomeTitle", loc2);
                loc3 = homeInfoLink.data;
                loc3.title = loc7;
                homeInfoLink.activate(loc3);
                _myLife.zone.setHomeDataProp("title", loc7);
            }
            return;
        }

        public static const MODE_HOME_VISITOR:String="homeVisitor";

        public static const MODE_MAP_VISITOR:String="mapVisitor";

        public static const MESSAGE_MIN_TIME:int=1000;

        public static const MODE_HOME_EDIT:String="homeEdit";

        public static const MODE_HOME_OWNER:String="homeOwner";

        public static const MODE_HOME_VISITOR_ASYNC_MENU:String="homeVisitorAsyncMenu";

        public var chatWindowHistory:MyLife.Interfaces.ChatWindowHistory;

        public var throwBalloonButtonIcon:flash.display.MovieClip;

        private var _energyMeter:MyLife.Interfaces.EnergyMeter;

        private var apartmentCountToolTip:MyLife.Interfaces.ToolTip;

        public var btnGiveFeedback:flash.display.SimpleButton;

        public var mcLeaveAMessage:flash.display.MovieClip;

        private var _roundTripTimer:flash.utils.Timer;

        public var btnInventory:flash.display.SimpleButton;

        public var btnGoHomeArrow:flash.display.SimpleButton;

        public var mcHomeLock:flash.display.MovieClip;

        public var EditRoomInstructions:flash.display.MovieClip;

        public var txtCoinCount:flash.text.TextField;

        public var btnShowThrowBalloon:flash.display.SimpleButton;

        public var btnEditHome:flash.display.SimpleButton;

        public var TickerBar:flash.display.MovieClip;

        public var ApartmentCounter:flash.display.MovieClip;

        public var roomItemSelector:MyLife.Interfaces.RoomItemSelector;

        public var mcRoomRating:flash.display.MovieClip;

        public var txtMemoryUsage:flash.text.TextField;

        public var actionsSelectorHideLayer:flash.display.MovieClip;

        public var btnMute:flash.display.SimpleButton;

        public var EmoticonSelector:flash.display.MovieClip;

        private var _inventoryScreen:MyLife.Interfaces.ViewInventory;

        public var btnChangeAppearance:flash.display.SimpleButton;

        public var indicator_energy:flash.display.MovieClip;

        public var tip_EnterYourChatMessageHere:flash.display.MovieClip;

        private var _savingDialog:*;

        public var ResponseTime:flash.display.MovieClip;

        public var homeIsLocked:Boolean;

        private var _latestRoomCount:int=0;

        public var indicator_intelligence:flash.display.MovieClip;

        public var indicator_happiness:flash.display.MovieClip;

        private var animationMenu:MyLife.Interfaces.AnimationMenu;

        public var ChatBarMask:flash.display.MovieClip;

        public var btnShowBuddyList:flash.display.SimpleButton;

        public var txtCashCount:flash.text.TextField;

        public var homeInfoBubble:MyLife.Interfaces.HomeInfoBubble;

        public var btnActionsActivate:flash.display.SimpleButton;

        public var btnShowMap:flash.display.SimpleButton;

        private var isSendMessageValid:Boolean;

        private var emoteItems:Array;

        public var eventWindow:MyLife.Interfaces.EventWindow;

        private var _unreadMessageCount:int=0;

        private var _updateApartmentCountTimer:flash.utils.Timer;

        private var actionItems:Array;

        public var btnGoHome:flash.display.SimpleButton;

        private var apartmentCountString:String;

        private var sendMessageValidTimer:flash.utils.Timer;

        public var sendMessageButton:flash.display.SimpleButton;

        public var waterBalloonManager:MyLife.WaterBalloonManager;

        public var txtMessage:flash.text.TextField;

        public var btnEmoteActivate:flash.display.SimpleButton;

        public var mapWorldSelector:MyLife.Interfaces.MapWorldSelector;

        public var mcGiveGift:flash.display.MovieClip;

        public var importFriendsDialog:MyLife.Interfaces.ImportFriendsDialog;

        public var earnCoinsWindow:MyLife.Interfaces.EarnCoinsWindow;

        public var indicator_social:flash.display.MovieClip;

        public var EmoteSelectorHideLayer:flash.display.MovieClip;

        public var indicator_charm:flash.display.MovieClip;

        public var mode:String;

        public var eventLink:MyLife.Interfaces.EventLink;

        public var buddyListViewer:MyLife.Interfaces.BuddyListViewer;

        public var btnEarnMoreCoins:flash.display.SimpleButton;

        private var _typingActivity:Boolean=false;

        public var eventBubble:MyLife.Interfaces.EventBubble;

        public var txtReferralLink:flash.text.TextField;

        private var toolTipInterval:Number;

        private var lastGiftCount:int=0;

        public var btnUnMute:flash.display.SimpleButton;

        public var homeInfoLink:MyLife.Interfaces.HomeInfoLink;

        private var _memUsageTimer:flash.utils.Timer;

        private var _myLife:flash.display.MovieClip;

        public var btnShowEvents:flash.display.SimpleButton;

        public var feedbackWindow:MyLife.Interfaces.FeedbackWindow;

        private var _typingStatusTimer:flash.utils.Timer;
    }
}
