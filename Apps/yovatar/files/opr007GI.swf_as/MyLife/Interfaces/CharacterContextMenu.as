package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class CharacterContextMenu extends flash.display.MovieClip
    {
        public function CharacterContextMenu()
        {
            flyoutMenuList = [];
            super();
            this.visible = false;
            return;
        }

        private function onMenuButtonVoidClick(arg1:flash.events.MouseEvent):void
        {
            arg1.stopPropagation();
            return;
        }

        private function flyoutTriggerRollOut(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            arg1.stopPropagation();
            loc2 = arg1.currentTarget;
            loc4 = 0;
            loc5 = flyoutMenuList;
            for each (loc3 in loc5)
            {
                if (loc3.btn != loc2)
                {
                    continue;
                }
                loc3.action = "hide";
                loc3.flyoutTimer.reset();
                loc3.flyoutTimer.start();
            }
            return;
        }

        public function Show(arg1:Object=null):void
        {
            var btnCollection:Array;
            var btnCollectionHide:Array;
            var buttonOffset:Number;
            var inParams:Object=null;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var maxButtonWidth:Number;
            var menuButton:flash.display.SimpleButton;
            var params:Object;

            menuButton = null;
            maxButtonWidth = NaN;
            buttonOffset = NaN;
            inParams = arg1;
            btnCollectionHide = [];
            btnCollection = [];
            params = {};
            if (inParams)
            {
                params = inParams;
            }
            if (params.EDIT_PLAYER_INFO)
            {
                btnCollection.push(btnContextEditPlayerInfo);
            }
            else 
            {
                btnCollectionHide.push(btnContextEditPlayerInfo);
            }
            if (params.DEFAULTS)
            {
                btnCollection.push(btnContextViewPlayerInfo);
            }
            else 
            {
                btnCollectionHide.push(btnContextViewPlayerInfo);
            }
            if (params.ADD_BUDDY)
            {
                btnCollection.push(btnContextAddAsAFriend);
            }
            else 
            {
                btnCollectionHide.push(btnContextAddAsAFriend);
            }
            if (params.DEFAULTS)
            {
                btnCollection.push(btnContextVisitTheirHome);
                btnCollection.push(btnContextPlayAGame);
                btnCollection.push(btnContextReportPlayer);
            }
            else 
            {
                btnCollectionHide.push(btnContextVisitTheirHome);
                btnCollectionHide.push(btnContextPlayAGame);
                btnCollectionHide.push(btnContextReportPlayer);
            }
            if (params.BLOCK_PLAYER)
            {
                btnCollection.push(btnBlockPlayer);
                btnCollectionHide.push(btnUnblockPlayer);
            }
            else 
            {
                if (params.UNBLOCK_PLAYER)
                {
                    btnCollection.push(btnUnblockPlayer);
                    btnCollectionHide.push(btnBlockPlayer);
                }
                else 
                {
                    btnCollectionHide.push(btnBlockPlayer);
                    btnCollectionHide.push(btnUnblockPlayer);
                }
            }
            if (params.KICK_FROM_HOME)
            {
                btnCollection.push(btnContextKickOutOfHome);
            }
            else 
            {
                btnCollectionHide.push(btnContextKickOutOfHome);
            }
            if (params.IS_ADMIN)
            {
                btnCollection.push(btnContextAdminMenu);
            }
            else 
            {
                btnCollectionHide.push(btnContextAdminMenu);
            }
            if (params.ADMIN_FLYOUT)
            {
                btnCollection.push(btnContextReloadExtensions);
                btnCollection.push(btnContextKickBan);
                btnCollection.push(btnContextSendAdminMsg);
            }
            else 
            {
                btnCollectionHide.push(btnContextReloadExtensions);
                btnCollectionHide.push(btnContextKickBan);
                btnCollectionHide.push(btnContextSendAdminMsg);
            }
            btnCollectionHide.push(btnContextReloadExtensions);
            if (params.GAME_FLYOUT)
            {
                btnCollection.push(btnContextPlayRockPaperScissors);
                btnCollection.push(btnContextPlayTicTacToe);
            }
            else 
            {
                btnCollectionHide.push(btnContextPlayRockPaperScissors);
                btnCollectionHide.push(btnContextPlayTicTacToe);
            }
            if (params.MAKE_TRADE)
            {
                btnCollection.push(btnContextMakeTrade);
            }
            else 
            {
                btnCollectionHide.push(btnContextMakeTrade);
            }
            if (params.GIVE_GIFT)
            {
                btnCollection.push(btnContextGiveGift);
            }
            else 
            {
                btnCollectionHide.push(btnContextGiveGift);
            }
            if (params.DEFAULTS)
            {
                btnCollection.push(btnContextSendPrivateMsg);
            }
            else 
            {
                btnCollectionHide.push(btnContextSendPrivateMsg);
            }
            if (params.VIEW_BADGES)
            {
                btnCollection.push(btnViewBadges);
            }
            else 
            {
                btnCollectionHide.push(btnViewBadges);
            }
            loc3 = 0;
            loc4 = btnCollectionHide;
            for each (menuButton in loc4)
            {
            };
            maxButtonWidth = 0;
            buttonOffset = 0;
            loc3 = 0;
            loc4 = btnCollection;
            for each (menuButton in loc4)
            {
                if (menuButton == null)
                {
                    continue;
                }
                menuButton.visible = true;
                menuButton.x = 5;
                menuButton.y = -19 - buttonOffset * 23;
                maxButtonWidth = (maxButtonWidth < menuButton.width + 5) ? menuButton.width + 5 : maxButtonWidth;
                buttonOffset = (buttonOffset + 1);
            }
            if (txtPlayerName)
            {
                if (params.PLAYER_NAME)
                {
                    txtPlayerName.text = params.PLAYER_NAME;
                    txtPlayerName.y = -19.7 - buttonOffset * 23;
                    buttonOffset = (buttonOffset + 1);
                }
                else 
                {
                    removeChild(txtPlayerName);
                }
            }
            if (params.SELF_CLICK)
            {
                maxButtonWidth = 140;
                ContextMenuBG.gotoAndStop(buttonOffset);
                ContextMenuBG.width = maxButtonWidth;
                ContextMenuBG.x = (maxButtonWidth >> 1) - 3;
            }
            else 
            {
                ContextMenuBG.gotoAndStop(buttonOffset);
                ContextMenuBG.width = maxButtonWidth + 10;
                ContextMenuBG.x = maxButtonWidth >> 1;
            }
            this.visible = true;
            loc3 = 0;
            loc4 = btnCollection;
            for each (menuButton in loc4)
            {
                if (menuButton != btnContextPlayAGame)
                {
                    if (menuButton != btnContextAdminMenu)
                    {
                        if (menuButton != null)
                        {
                            menuButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
                        }
                    }
                    else 
                    {
                        if (btnContextAdminMenu)
                        {
                            addFlyoutEvents(btnContextAdminMenu);
                            btnContextAdminMenu.addEventListener(MouseEvent.CLICK, onMenuButtonVoidClick);
                        }
                    }
                }
                else 
                {
                    if (btnContextPlayAGame)
                    {
                        addFlyoutEvents(btnContextPlayAGame);
                        btnContextPlayAGame.addEventListener(MouseEvent.CLICK, onMenuButtonVoidClick);
                    }
                }
                if (menuButton != btnViewBadges)
                {
                    continue;
                }
                if (!btnViewBadges)
                {
                    continue;
                }
                badgeContainer.x = btnViewBadges.x;
                badgeContainer.y = btnViewBadges.y;
                achievementBadge = new AchievementBadge(null, -1, -1, -1, null, false, true);
                if (badgeContainer.numChildren)
                {
                    badgeContainer.removeChildAt(0);
                }
                badgeContainer.mouseEnabled = false;
                badgeContainer.mouseChildren = false;
                badgeContainer.addChild(achievementBadge);
            }
            return;
        }

        private function addFlyoutEvents(arg1:flash.display.SimpleButton):void
        {
            arg1.addEventListener(MouseEvent.ROLL_OVER, flyoutTriggerRollOver);
            arg1.addEventListener(MouseEvent.ROLL_OUT, flyoutTriggerRollOut);
            return;
        }

        private function getNewInstanceFromClassName(arg1:String):*
        {
            var AssetClass:Class;
            var AssetObj:*;
            var className:String;
            var loc2:*;
            var loc3:*;

            AssetClass = null;
            AssetObj = undefined;
            className = arg1;
            try
            {
                AssetClass = getDefinitionByName(className) as Class;
                AssetObj = new AssetClass();
                return AssetObj;
            }
            catch (e:*)
            {
                trace(undefined.message);
                return null;
            }
            return;
        }

        private function flyoutContextMenuRollOver(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            arg1.stopPropagation();
            loc2 = arg1.currentTarget;
            loc4 = 0;
            loc5 = flyoutMenuList;
            for each (loc3 in loc5)
            {
                if (loc3.flyout != loc2)
                {
                    continue;
                }
                loc3.action = "show";
                loc3.flyoutTimer.reset();
                loc3.flyoutTimer.start();
            }
            return;
        }

        private function flyoutTriggerRollOver(arg1:flash.events.MouseEvent):void
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

            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            loc2 = arg1.currentTarget as SimpleButton;
            loc10 = 0;
            loc11 = flyoutMenuList;
            for each (loc3 in loc11)
            {
                if (loc3.btn != loc2)
                {
                    continue;
                }
                loc3.action = "show";
                loc3.flyoutTimer.reset();
                loc3.flyoutTimer.start();
                return;
            }
            loc4 = getNewInstanceFromClassName("MyLife.Interfaces.CharacterContextMenu");
            loc5 = {};
            if (loc2.name != "btnContextAdminMenu")
            {
                if (loc2.name == "btnContextPlayAGame")
                {
                    loc5.GAME_FLYOUT = true;
                }
            }
            else 
            {
                loc5.ADMIN_FLYOUT = true;
            }
            loc4.Show(loc5);
            addChild(loc4);
            loc6 = loc2.x + 125;
            loc7 = loc2.y + loc4.height;
            loc4.x = loc6;
            loc4.y = loc7;
            if ((loc8 = loc4.getBounds(getStageClip())).right > 645)
            {
                loc4.x = loc2.x - 135;
            }
            if (loc8.bottom > 595)
            {
                loc4.y = loc4.y - (loc8.bottom - 595);
            }
            loc4.visible = false;
            (loc9 = new Timer(400, 1)).addEventListener(TimerEvent.TIMER, flyoutTimerTick);
            loc9.start();
            loc4.addEventListener(MouseEvent.ROLL_OVER, flyoutContextMenuRollOver);
            loc4.addEventListener(MouseEvent.ROLL_OUT, flyoutContextMenuRollOut);
            flyoutMenuList.push({"btn":loc2, "flyout":loc4, "flyoutTimer":loc9, "action":"show"});
            return;
        }

        private function onMenuButtonClick(arg1:flash.events.MouseEvent):void
        {
            arg1.stopPropagation();
            dispatchEvent(new MyLifeEvent(MyLifeEvent.CONTEXT_ITEM, {"value":arg1.currentTarget.name}, true));
            return;
        }

        private function flyoutContextMenuRollOut(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            arg1.stopPropagation();
            loc2 = arg1.currentTarget;
            loc4 = 0;
            loc5 = flyoutMenuList;
            for each (loc3 in loc5)
            {
                if (loc3.flyout != loc2)
                {
                    continue;
                }
                loc3.action = "hide";
                loc3.flyoutTimer.reset();
                loc3.flyoutTimer.start();
            }
            return;
        }

        private function getStageClip():*
        {
            var loc1:*;

            loc1 = this;
            while (loc1.parent) 
            {
                loc1 = loc1.parent;
            }
            return loc1;
        }

        private function flyoutTimerTick(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            arg1.stopPropagation();
            loc2 = arg1.currentTarget as Timer;
            loc4 = 0;
            loc5 = flyoutMenuList;
            for each (loc3 in loc5)
            {
                if (loc3.flyoutTimer != loc2)
                {
                    continue;
                }
                if (loc3.action == "show")
                {
                    loc3.flyout.visible = true;
                    continue;
                }
                if (loc3.action != "hide")
                {
                    continue;
                }
                loc3.flyout.visible = false;
            }
            return;
        }

        public function destroy():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = undefined;
            loc2 = 0;
            loc3 = flyoutMenuList;
            for each (loc1 in loc3)
            {
                if (loc1.btn)
                {
                    loc1.btn.removeEventListener(MouseEvent.ROLL_OVER, flyoutTriggerRollOver);
                    loc1.btn.removeEventListener(MouseEvent.ROLL_OUT, flyoutTriggerRollOut);
                }
                if (loc1.flyout)
                {
                    loc1.flyout.removeEventListener(MouseEvent.ROLL_OVER, flyoutContextMenuRollOver);
                    loc1.flyout.removeEventListener(MouseEvent.ROLL_OUT, flyoutContextMenuRollOut);
                }
                if (loc1.flyoutTimer)
                {
                    loc1.flyoutTimer.stop();
                    loc1.flyoutTimer.removeEventListener(TimerEvent.TIMER, flyoutTimerTick);
                }
                if (!loc1.flyout)
                {
                    continue;
                }
                removeChild(loc1.flyout);
                loc1.flyout.destroy();
            }
            flyoutMenuList = [];
            return;
        }

        public var btnContextReportPlayer:flash.display.SimpleButton;

        public var btnContextPlayRockPaperScissors:flash.display.SimpleButton;

        public var btnUnblockPlayer:flash.display.SimpleButton;

        public var txtPlayerName:flash.text.TextField;

        public var badgeContainer:flash.display.Sprite;

        public var btnContextMakeTrade:flash.display.SimpleButton;

        public var btnContextKickOutOfHome:flash.display.SimpleButton;

        public var btnContextPlayAGame:flash.display.SimpleButton;

        public var btnContextSendAdminMsg:flash.display.SimpleButton;

        public var btnViewBadges:flash.display.SimpleButton;

        public var btnContextGiveGift:flash.display.SimpleButton;

        public var btnContextSendPrivateMsg:flash.display.SimpleButton;

        public var btnContextPlayTicTacToe:flash.display.SimpleButton;

        public var btnContextKickBan:flash.display.SimpleButton;

        private var flyoutMenuList:Array;

        public var achievementBadge:MyLife.Interfaces.AchievementBadge;

        public var btnContextViewPlayerInfo:flash.display.SimpleButton;

        public var btnBlockPlayer:flash.display.SimpleButton;

        public var ContextMenuBG:flash.display.MovieClip;

        public var btnContextAdminMenu:flash.display.SimpleButton;

        public var btnContextReloadExtensions:flash.display.SimpleButton;

        public var btnContextVisitTheirHome:flash.display.SimpleButton;

        public var btnContextEditPlayerInfo:flash.display.SimpleButton;

        public var btnContextAddAsAFriend:flash.display.SimpleButton;
    }
}
