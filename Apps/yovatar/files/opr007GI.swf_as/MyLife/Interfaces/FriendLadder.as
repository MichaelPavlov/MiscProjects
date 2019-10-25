package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Interfaces.LeaderBoard.*;
    import MyLife.Utils.*;
    import MyLife.Xp.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class FriendLadder extends flash.display.Sprite
    {
        public function FriendLadder()
        {
            var loc1:*;

            super();
            linkTracker = new LinkTracker();
            lowerPlayerCards = [];
            leadingPlayerCards = [];
            firstLowerPlayerIndex = 0;
            navButtons = [leftOne, leftMany, leftEnd, rightOne, rightMany, rightEnd];
            loc1 = 0;
            while (loc1 < navButtons.length) 
            {
                (navButtons[loc1] as SimpleButton).addEventListener(MouseEvent.CLICK, onNavButtonClick, false, 0, true);
                ++loc1;
            }
            removeChild(helpPanel);
            debugBtn.visible = false;
            helpButton.addEventListener(MouseEvent.MOUSE_OVER, onHelpButtonOver, false, 0, true);
            helpButton.addEventListener(MouseEvent.MOUSE_OUT, onHelpButtonOut, false, 0, true);
            initializeLayout();
            return;
        }

        private function onHelpButtonOver(arg1:flash.events.MouseEvent):void
        {
            addChild(helpPanel);
            return;
        }

        private function onNavButtonClick(arg1:flash.events.MouseEvent):void
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

            loc3 = 0;
            loc5 = null;
            loc6 = null;
            loc9 = null;
            loc10 = 0;
            loc11 = null;
            loc12 = 0;
            loc13 = 0;
            loc14 = 0;
            if (lowerPlayerLadderData.length < lowerPlayerCards.length)
            {
                return;
            }
            loc2 = arg1.currentTarget as SimpleButton;
            loc4 = false;
            loc15 = loc2;
            switch (loc15) 
            {
                case leftOne:
                    loc3 = 1;
                    break;
                case leftEnd:
                    loc3 = 1;
                    loc4 = true;
                    break;
                case leftMany:
                    loc3 = PLAYER_CARD_LOWER_COUNT;
                    break;
                case rightOne:
                    loc3 = -1;
                    break;
                case rightEnd:
                    loc3 = -1;
                    loc4 = true;
                    break;
                case rightMany:
                    loc3 = -PLAYER_CARD_LOWER_COUNT;
                    break;
            }
            setNavButtonsEnabled(false);
            loc7 = 1;
            loc8 = 0;
            if (loc4)
            {
                loc9 = [];
                if (loc3 > 0)
                {
                    firstLowerPlayerIndex = lowerPlayerLadderData.length - PLAYER_CARD_LOWER_COUNT;
                    loc9 = lowerPlayerLadderData.slice(firstLowerPlayerIndex, (lowerPlayerLadderData.length - 1));
                    loc7 = PLAYER_CARD_LEADER_COUNT + firstLowerPlayerIndex + 1;
                }
                else 
                {
                    firstLowerPlayerIndex = 0;
                    loc9 = lowerPlayerLadderData.slice(0, lowerPlayerCards.length);
                    loc7 = PLAYER_CARD_LEADER_COUNT + 1;
                }
                loc8 = 0;
                while (loc8 < PLAYER_CARD_LOWER_COUNT) 
                {
                    loc5 = lowerPlayerCards[loc8] as PlayerCard;
                    if (loc8 >= loc9.length)
                    {
                        loc5.setInviteFriend();
                        loc5.addEventListener(PlayerCard.INVITE_FRIEND_CLICK, onInviteFriendClick, false, 0, true);
                    }
                    else 
                    {
                        (loc6 = createPlayerItem(loc9[loc8], loc7++)).addEventListener(MouseEvent.CLICK, onPlayerItemClick);
                        loc5.setFriend(loc6);
                    }
                    ++loc8;
                }
                setNavButtonsEnabled();
            }
            else 
            {
                loc10 = 0;
                loc11 = [];
                if (loc3 > 0)
                {
                    loc14 = lowerPlayerLadderData.length - PLAYER_CARD_LOWER_COUNT + 1;
                    if (firstLowerPlayerIndex >= loc14)
                    {
                        setNavButtonsEnabled();
                        return;
                    }
                    if ((loc12 = firstLowerPlayerIndex + loc3 - loc14) > 0)
                    {
                        loc3 = loc3 - loc12;
                    }
                    loc13 = -(PLAYER_CARD_LOWER_COUNT + 1) * PLAYER_CARD_WIDTH;
                    loc8 = 0;
                    while (loc8 < loc3) 
                    {
                        firstLowerPlayerIndex++;
                        (loc5 = new PlayerCard()).x = loc13;
                        loc13 = loc13 - PLAYER_CARD_WIDTH;
                        lowerPlayerCards.push(loc5);
                        loc11.push(lowerPlayerCards.shift());
                        loc10 = loc10 + PLAYER_CARD_WIDTH;
                        playerCardContainer.addChild(loc5);
                        if (firstLowerPlayerIndex + PLAYER_CARD_LOWER_COUNT > lowerPlayerLadderData.length)
                        {
                            loc5.setInviteFriend();
                            loc5.addEventListener(PlayerCard.INVITE_FRIEND_CLICK, onInviteFriendClick, false, 0, true);
                        }
                        else 
                        {
                            loc6 = createPlayerItem(lowerPlayerLadderData[(firstLowerPlayerIndex + PLAYER_CARD_LOWER_COUNT - 1)], firstLowerPlayerIndex + PLAYER_CARD_LEADER_COUNT + PLAYER_CARD_LOWER_COUNT);
                            loc5.setFriend(loc6);
                        }
                        ++loc8;
                    }
                }
                else 
                {
                    if (firstLowerPlayerIndex <= 0)
                    {
                        setNavButtonsEnabled();
                        return;
                    }
                    if ((loc12 = firstLowerPlayerIndex + loc3) < 0)
                    {
                        loc3 = loc3 - loc12;
                    }
                    loc13 = 0;
                    loc8 = 0;
                    while (loc8 > loc3) 
                    {
                        firstLowerPlayerIndex--;
                        loc6 = createPlayerItem(lowerPlayerLadderData[firstLowerPlayerIndex], firstLowerPlayerIndex + PLAYER_CARD_LEADER_COUNT + 1);
                        (loc5 = new PlayerCard()).setFriend(loc6);
                        loc5.x = loc13;
                        loc13 = loc13 + PLAYER_CARD_WIDTH;
                        playerCardContainer.addChild(loc5);
                        lowerPlayerCards.unshift(loc5);
                        loc11.push(lowerPlayerCards.pop());
                        loc10 = loc10 - PLAYER_CARD_WIDTH;
                        loc8 = (loc8 - 1);
                    }
                }
                Tweener.addTween(playerCardContainer, {"x":playerCardContainer.x + loc10, "time":0.5, "transition":"easeOutCubic", "onComplete":onNavEaseComplete, "onCompleteParams":[loc11]});
            }
            return;
        }

        private function processLoadedData(arg1:*):void
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

            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = 0;
            loc6 = 0;
            loc8 = undefined;
            if (arg1 as Array)
            {
                lowerPlayerLadderData = (arg1 as Array).slice();
            }
            else 
            {
                lowerPlayerLadderData = [];
                loc9 = 0;
                loc10 = arg1;
                for (loc8 in loc10)
                {
                    lowerPlayerLadderData.push(arg1[loc8]);
                }
            }
            lowerPlayerLadderData = lowerPlayerLadderData || [];
            lowerPlayerLadderData.sortOn("xp_count", Array.DESCENDING | Array.NUMERIC);
            firstLowerPlayerIndex = 0;
            loc2 = lowerPlayerLadderData.splice(0, 3);
            loc6 = 1;
            loc5 = 0;
            while (loc5 < leadingPlayerCards.length) 
            {
                loc4 = leadingPlayerCards[loc5] as PlayerCard;
                if (loc5 >= loc2.length)
                {
                    loc4.setInviteFriend();
                    loc4.addEventListener(PlayerCard.INVITE_FRIEND_CLICK, onInviteFriendClick);
                }
                else 
                {
                    loc3 = createPlayerItem(loc2[loc5], loc6++);
                    loc3.addEventListener(MouseEvent.CLICK, onPlayerItemClick);
                    loc4.setFriend(loc3);
                }
                ++loc5;
            }
            loc7 = lowerPlayerLadderData;
            loc6 = leadingPlayerCards.length + 1;
            loc5 = 0;
            while (loc5 < lowerPlayerCards.length) 
            {
                loc4 = lowerPlayerCards[loc5] as PlayerCard;
                if (loc5 >= loc7.length)
                {
                    loc4.setInviteFriend();
                    loc4.addEventListener(PlayerCard.INVITE_FRIEND_CLICK, onInviteFriendClick, false, 0, true);
                }
                else 
                {
                    loc3 = createPlayerItem(loc7[loc5], loc6++);
                    loc3.addEventListener(MouseEvent.CLICK, onPlayerItemClick);
                    loc4.setFriend(loc3);
                }
                ++loc5;
            }
            mouseChildren = true;
            return;
        }

        private function onInviteFriendClick(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = null;
            loc4 = myLife.myLifeConfiguration.platformType;
            loc5 = loc4;
            switch (loc5) 
            {
                case "platformFacebook":
                    loc3 = "http://apps.facebook.com/yoville/my_crew.php";
                    loc2 = "_blank";
                    break;
                case "platformMySpace":
                    loc3 = "http://profile.myspace.com/Modules/Applications/Pages/Canvas.aspx?appId=111238&appParams={\"zy_path\":\"my_crew.php\"}";
                    loc2 = "_top";
                    break;
            }
            myLife.navigateToURL(loc3, loc2);
            return;
        }

        private function onNavEaseComplete(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = 0;
            loc4 = null;
            loc5 = null;
            loc2 = 0;
            while (loc2 < arg1.length) 
            {
                (loc4 = arg1[loc2] as PlayerCard).destroy();
                playerCardContainer.removeChild(loc4);
                ++loc2;
            }
            loc3 = 0;
            loc2 = 0;
            while (loc2 < lowerPlayerCards.length) 
            {
                loc5 = lowerPlayerCards[loc2] as PlayerCard;
                loc3 = loc3 - PLAYER_CARD_WIDTH;
                loc5.x = loc3;
                ++loc2;
            }
            playerCardContainer.x = LOWER_HORIZONTAL_ENTRYPOINT;
            setNavButtonsEnabled();
            return;
        }

        private function createPlayerItem(arg1:Object, arg2:int=0):MyLife.Interfaces.LeaderBoard.PlayerItem
        {
            var loc3:*;

            arg1.rank = StringUtils.getRankString(arg2);
            arg1.isFriend = true;
            arg1.xp = arg1.xp_count;
            loc3 = new PlayerItem();
            loc3.populate(arg1);
            loc3.addEventListener(MouseEvent.CLICK, onPlayerItemClick);
            return loc3;
        }

        private function loadData():void
        {
            mouseChildren = false;
            if (FriendDataManager.ready)
            {
                combinedPlayerData = FriendDataManager.getAppUserFriendData(0, true) as Array;
                processLoadedData(combinedPlayerData);
            }
            else 
            {
                FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, onFriendDataReady);
                setPlayerCardsLoading();
            }
            return;
        }

        public function initialize(arg1:int):void
        {
            this.playerId = arg1;
            myLife = MyLifeInstance.getInstance() as MyLife;
            myLife.getZone().addEventListener("requestJoinRoom", onJoinRoomRequest, false, 0, true);
            myLife.getZone().addEventListener(MyLifeEvent.JOIN_ROOM_COMPLETE, onJoinRoomComplete, false, 0, true);
            myLife.getServer().addEventListener(XpManagerEvent.XP_MANAGER_UPDATE_PROGRESS, onXpManagerNewXp, false, 0, true);
            loadData();
            return;
        }

        private function setNavButtonsEnabled(arg1:Boolean=true):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = 0;
            while (loc2 < navButtons.length) 
            {
                loc3 = navButtons[loc2] as SimpleButton;
                loc3.mouseEnabled = arg1;
                loc3.alpha = arg1 ? 1 : 0.5;
                ++loc2;
            }
            return;
        }

        private function resort():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 0;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc1 = combinedPlayerData.slice();
            if (!loc1)
            {
                return;
            }
            loc1.sortOn("xp_count", Array.DESCENDING | Array.NUMERIC);
            loc2 = 0;
            while (loc2 < leadingPlayerCards.length && loc2 < loc1.length) 
            {
                loc3 = loc1[loc2];
                if (loc4 = leadingPlayerCards[loc2] as PlayerCard)
                {
                    if (loc5 = loc4.getPlayerItem())
                    {
                        if (loc3["playerId"] != loc5.getPlayerID())
                        {
                            loc4.setFriend(createPlayerItem(loc3, loc2 + 1));
                        }
                    }
                }
                loc2 = (loc2 + 1);
            }
            loc2 = 0;
            while (loc2 < lowerPlayerCards.length) 
            {
                loc6 = leadingPlayerCards.length + firstLowerPlayerIndex + loc2;
                loc3 = loc1[loc6];
                if (loc4 = lowerPlayerCards[loc2])
                {
                    if (loc5 = loc4.getPlayerItem())
                    {
                        if (loc3["playerId"] != loc5.getPlayerID())
                        {
                            loc4.setFriend(createPlayerItem(loc3, loc6 + 1));
                        }
                    }
                }
                loc2 = (loc2 + 1);
            }
            leadingPlayerLadderData = loc1.splice(0, PLAYER_CARD_LEADER_COUNT);
            lowerPlayerLadderData = loc1;
            return;
        }

        private function onJoinRoomRequest(arg1:flash.events.Event):void
        {
            visible = false;
            return;
        }

        private function initializeLayout():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = null;
            loc3 = null;
            loc1 = new Point(LEADER_HORIZONTAL_ENTRYPOINT, VERTICAL_ENTRYPOINT);
            loc2 = new Point(LOWER_HORIZONTAL_ENTRYPOINT, VERTICAL_ENTRYPOINT);
            loc4 = 0;
            while (loc4 < PLAYER_CARD_LEADER_COUNT) 
            {
                loc3 = new PlayerCard();
                loc1.x = loc1.x - PLAYER_CARD_WIDTH;
                loc3.x = loc1.x;
                loc3.y = loc1.y;
                leadingPlayerCards.push(loc3);
                addChild(loc3);
                ++loc4;
            }
            playerCardContainer = new Sprite();
            playerCardContainer.mask = scrollMask;
            playerCardContainer.x = loc2.x;
            playerCardContainer.y = loc2.y;
            addChild(playerCardContainer);
            loc5 = 0;
            loc6 = 0;
            while (loc6 < PLAYER_CARD_LOWER_COUNT) 
            {
                loc3 = new PlayerCard();
                loc5 = loc5 - PLAYER_CARD_WIDTH;
                loc3.x = loc5;
                lowerPlayerCards.push(loc3);
                playerCardContainer.addChild(loc3);
                ++loc6;
            }
            return;
        }

        private function onXpManagerNewXp(arg1:MyLife.Xp.XpManagerEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = 0;
            if (arg1.data.hasOwnProperty("progressArray") && combinedPlayerData)
            {
                loc3 = 0;
                while (loc3 < combinedPlayerData.length) 
                {
                    loc2 = combinedPlayerData[loc3];
                    if (loc2["playerId"] == myLife.getPlayer().getPlayerId())
                    {
                        loc2["xp_count"] = parseInt(arg1.data["progressArray"]["xp_count"]);
                        break;
                    }
                    loc3 = (loc3 + 1);
                }
                resort();
            }
            return;
        }

        private function setPlayerCardsLoading():void
        {
            var loc1:*;
            var loc2:*;

            loc1 = 0;
            loc2 = null;
            loc1 = 0;
            while (loc1 < lowerPlayerCards.length) 
            {
                (lowerPlayerCards[loc1] as PlayerCard).setLoading();
                ++loc1;
            }
            loc1 = 0;
            while (loc1 < leadingPlayerCards.length) 
            {
                (leadingPlayerCards[loc1] as PlayerCard).setLoading();
                ++loc1;
            }
            return;
        }

        private function onDebugBtnClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (!inc)
            {
                inc = 100;
            }
            loc2 = [];
            loc2["xp_count"] = inc++;
            loc3 = new XpManagerEvent(XpManagerEvent.XP_MANAGER_GAIN_XP, {"progressArray":loc2});
            onXpManagerNewXp(loc3);
            return;
        }

        private function onFriendDataReady(arg1:flash.events.Event):void
        {
            FriendDataManager.instance.removeEventListener(FriendDataManager.EVENT_READY, onFriendDataReady);
            combinedPlayerData = FriendDataManager.getAppUserFriendData(0, true) as Array;
            processLoadedData(combinedPlayerData);
            return;
        }

        private function onHelpButtonOut(arg1:flash.events.MouseEvent):void
        {
            removeChild(helpPanel);
            return;
        }

        private function onPlayerItemClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc6 = null;
            loc2 = arg1.currentTarget as PlayerItem;
            loc3 = myLife.getConfiguration().variables["querystring"]["defaultInstance"];
            loc4 = "This room is located on a different server than you. Are you sure you want to change servers?";
            if (loc5 = loc2.getDefaultHome())
            {
                myLife.getZone().joinHomeRoom(loc5, loc2.getPlayerID());
            }
            else 
            {
                loc6 = "APLiving-" + loc2.getPlayerID();
                myLife.getZone().join(loc6, 0, loc3, loc4);
            }
            if (linkTracker && !myLife.runningLocal)
            {
                linkTracker.setRandomActive();
                linkTracker.track("1523", "531");
            }
            return;
        }

        private function onJoinRoomComplete(arg1:MyLife.MyLifeEvent):void
        {
            visible = true;
            return;
        }

        private static const PLAYER_CARD_LOWER_COUNT:int=4;

        private static const LEADER_HORIZONTAL_ENTRYPOINT:int=620;

        private static const PLAYER_CARD_LEADER_COUNT:int=3;

        private static const PLAYER_CARD_WIDTH:int=77;

        private static const VERTICAL_ENTRYPOINT:int=35;

        private static const LOWER_HORIZONTAL_ENTRYPOINT:int=354;

        private var firstLowerPlayerIndex:int;

        public var leftMany:flash.display.SimpleButton;

        public var debugBtn:flash.display.SimpleButton;

        private var combinedPlayerData:Array;

        public var rightMany:flash.display.SimpleButton;

        public var rightEnd:flash.display.SimpleButton;

        private var leadingPlayerCards:Array;

        public var rightOne:flash.display.SimpleButton;

        private var lowerPlayerCards:Array;

        public var helpPanel:flash.display.MovieClip;

        private var myLife:MyLife.MyLife;

        private var lowerPlayerLadderData:Array;

        public var helpButton:flash.display.SimpleButton;

        public var scrollMask:flash.display.MovieClip;

        private var leadingPlayerLadderData:Array;

        public var leftEnd:flash.display.SimpleButton;

        private var playerId:int;

        private var linkTracker:MyLife.LinkTracker;

        public var leftOne:flash.display.SimpleButton;

        private var navButtons:Array;

        internal var inc:int;

        private var playerCardContainer:flash.display.Sprite;
    }
}
