package MyLife.Assets 
{
    import MyLife.Events.*;
    import MyLife.Utils.*;
    import fai.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    
    public class Chair extends MyLife.Assets.InteractiveActionItem
    {
        public function Chair()
        {
            super();
            return;
        }

        public override function showView(arg1:String="Front"):void
        {
            var ViewClass:Object;
            var fileIsNumber:Boolean;
            var fileName:String;
            var loc2:*;
            var loc3:*;
            var viewClassName:String;
            var viewInstance:flash.display.MovieClip;
            var viewName:String="Front";

            fileName = null;
            viewClassName = null;
            viewInstance = null;
            ViewClass = null;
            viewName = arg1;
            this.clearViews();
            this.currentViewName = viewName;
            fileIsNumber = !isNaN(Number(this.itemData.filename));
            fileName = this.itemData.filename;
            if (fileName == null || fileIsNumber)
            {
                fileName = "Item_" + this.itemData.itemId;
            }
            viewClassName = "MyLife.Assets." + fileName + "." + this.currentViewName;
            try
            {
                try
                {
                    ViewClass = getDefinitionByName(viewClassName);
                }
                catch (error:Error)
                {
                    this.currentViewName = "Front";
                    viewClassName = "MyLife.Assets." + fileName + "." + this.currentViewName;
                    ViewClass = getDefinitionByName(viewClassName);
                }
                viewInstance = new ViewClass() as MovieClip;
                initView(viewInstance);
            }
            catch (error:Error)
            {
                trace(undefined);
            }
            return;
        }

        private function isIndexOccupied(arg1:Number):Boolean
        {
            return false;
        }

        private function getDistanceBetweenPositions(arg1:fai.Position, arg2:fai.Position):Number
        {
            return Math.sqrt(Math.pow(arg2.x - arg1.x, 2) + Math.pow(arg2.y - arg1.y, 2));
        }

        private function getCharacterWalkToPosition(arg1:flash.display.MovieClip, arg2:Number):flash.geom.Point
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = standPositions[arg2];
            loc4 = new Point(loc3.x, loc3.y);
            loc5 = this.zim.getProp("zone").zoneRenderClip;
            return loc6 = DisplayObjectContainerUtils.getCoordinatesInSpace(loc3.parent, loc5, loc4);
        }

        public override function doItemAction(arg1:Number, arg2:Boolean=false, arg3:Object=null):void
        {
            var loc4:*;
            var loc5:*;

            loc4 = null;
            loc5 = NaN;
            if (arg1 != playerUserId)
            {
                loc4 = this.zim.getProp("zone").getCharacter(arg1);
            }
            else 
            {
                loc4 = this.zim.getProp("player")._character;
            }
            if (loc4 == null)
            {
                return;
            }
            if (!(arg3 == null) && !(arg3.position == null))
            {
                loc5 = arg3.position;
            }
            else 
            {
                loc5 = this.getClosestAvailableSitIndex(0, (0));
            }
            if (loc5 == EMPTY_SPACE)
            {
                return;
            }
            if (arg3 == null || arg3.actionList == null)
            {
                arg3 = getSitActionData(loc5, loc4, arg2);
            }
            else 
            {
                if (arg3.position == null)
                {
                    arg3.position = loc5;
                }
            }
            if (arg3 == null)
            {
                return;
            }
            super.doItemAction(arg1, arg2, arg3);
            loc4.avatarActionManager.addEventListener(AvatarActionEvent.ACTION_LIST_START, onActionListStart);
            if (!loc4.avatarActionManager.doActionList(arg3.actionList, false, instanceName))
            {
                loc4.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_LIST_START, onActionListStart);
                return;
            }
            if (arg1 == playerUserId)
            {
                clickEnabled = false;
            }
            return;
        }

        protected override function initView(arg1:flash.display.MovieClip):void
        {
            super.initView(arg1);
            if (this.currentViewName != "Preview")
            {
                if (arg1.characterContainer)
                {
                    characterContainer = arg1.characterContainer;
                }
                else 
                {
                    characterContainer = new MovieClip();
                    this.addChild(characterContainer);
                }
                initializePositionMarkers(arg1);
            }
            return;
        }

        private function getAvatarStandPosition(arg1:flash.display.MovieClip, arg2:Number):flash.geom.Point
        {
            var loc3:*;

            loc3 = standPositions[arg2];
            return new Point(loc3.x, loc3.y);
        }

        private function getClosestAvailableSitIndex(arg1:Number, arg2:Number):Number
        {
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

            loc7 = 0;
            loc8 = null;
            loc9 = NaN;
            loc10 = NaN;
            loc11 = null;
            loc12 = NaN;
            loc3 = Number.POSITIVE_INFINITY;
            loc4 = EMPTY_SPACE;
            loc5 = new Array();
            loc6 = this.zim.getProp("zone").characterCollection;
            loc7 = 0;
            while (loc7 < sitPositions.length) 
            {
                loc5.push(loc7);
                ++loc7;
            }
            loc13 = 0;
            loc14 = loc6;
            for each (loc8 in loc14)
            {
                if (loc8 == null)
                {
                    continue;
                }
                if ((loc9 = loc8.getInteractingItemPosition(playerItemId, positionId)) == -1)
                {
                    continue;
                }
                if ((loc10 = loc5.indexOf(loc9)) == -1)
                {
                    continue;
                }
                loc5.splice(loc10, 1);
            }
            loc7 = 0;
            while (loc7 < loc5.length) 
            {
                loc11 = sitPositions[loc5[loc7]];
                if ((loc12 = Math.sqrt(Math.pow(arg1 - loc11.x, 2) + Math.pow(arg2 - loc11.y, 2))) < loc3 || loc4 == EMPTY_SPACE)
                {
                    loc3 = loc12;
                    loc4 = loc5[loc7];
                }
                ++loc7;
            }
            if (isNaN(loc4))
            {
                loc4 = -1;
            }
            return loc4;
        }

        private function onActionCancelled(arg1:MyLife.Events.AvatarActionEvent):void
        {
            var event:MyLife.Events.AvatarActionEvent;
            var loc2:*;
            var loc3:*;
            var oldDisabled:Boolean;
            var sittingCharacter:flash.display.MovieClip;

            oldDisabled = false;
            sittingCharacter = null;
            event = arg1;
            if (event.actionListID == instanceName)
            {
                oldDisabled = this.zim.disabled;
                this.zim.disabled = false;
                sittingCharacter = this.zim.getProp("zone").getCharacter(event.characterId);
                this.zim.disabled = oldDisabled;
                if (sittingCharacter != null)
                {
                    if (sittingCharacter.serverUserId == this.playerUserId)
                    {
                        this.clickEnabled = true;
                    }
                    try
                    {
                        if (sittingCharacter._renderClip.avatarClip.parent.parent != this.characterContainer)
                        {
                            sittingCharacter.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_START, onActionStart);
                            sittingCharacter.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
                            sittingCharacter.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_CANCELLED, onActionCancelled);
                        }
                        else 
                        {
                            this.kickCharacterOutOfChair(sittingCharacter, event.actionParams.position);
                        }
                    }
                    catch (error:*)
                    {
                    };
                }
            }
            return;
        }

        private function maskCharacter(arg1:Boolean, arg2:flash.display.MovieClip):void
        {
            var avatarClip:flash.display.MovieClip;
            var legVisible:Boolean;
            var loc3:*;
            var loc4:*;
            var sittingCharacter:flash.display.MovieClip;
            var useMask:Boolean;

            avatarClip = null;
            legVisible = false;
            useMask = arg1;
            sittingCharacter = arg2;
            try
            {
                avatarClip = sittingCharacter.getAvatarClip().avatarClip;
                legVisible = sittingCharacter.getAvatarClip().isFront() ? true : !useMask;
                avatarClip.rightFoot.visible = legVisible;
                avatarClip.rightCalf.visible = legVisible;
                avatarClip.rightThigh.visible = legVisible;
            }
            catch (error:Error)
            {
            };
            return;
        }

        private function initializePositionMarkers(arg1:flash.display.MovieClip):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc2 = 0;
            sitPositions = new Array();
            standPositions = new Array();
            for (;;) 
            {
                loc3 = arg1[("sitPosition" + loc2)] as MovieClip;
                loc4 = arg1[("standPosition" + loc2)] as MovieClip;
                if (!(loc3 == null) && !(loc4 == null))
                {
                    loc3.visible = false;
                    loc4.visible = false;
                    sitPositions.push(loc3);
                    standPositions.push(loc4);
                    if (characterContainer.numChildren <= loc2)
                    {
                        (loc5 = new MovieClip()).name = "sitContainer" + loc2;
                        characterContainer.addChild(loc5);
                    }
                }
                else 
                {
                    break;
                }
                loc2 = (loc2 + 1);
            }
            numSeats = sitPositions.length;
            return;
        }

        private function setCharacterItem(arg1:Object, arg2:Number, arg3:Number, arg4:Number):*
        {
            arg1.setInteractingItemState(arg3, arg4, arg2);
            if (arg1.serverUserId != playerUserId)
            {
                return;
            }
            this.zim.getProp("server").callExtension("updateCharacterProperty", {"p":"item", "v":{"piid":arg3, "itemPos":arg2, "posId":arg4}, "s":1, "chch":arg1._characterName});
            return;
        }

        private function addCharacterToChair(arg1:flash.display.MovieClip, arg2:Number, arg3:Boolean=false):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = null;
            loc4 = arg1._renderClip.avatarClip;
            loc5 = this.getCharacterWalkToPosition(arg1, arg2);
            arg1.x = loc5.x;
            arg1.y = loc5.y;
            loc6 = this.getAvatarStandPosition(arg1, arg2);
            loc4.x = loc6.x;
            loc4.y = loc6.y;
            (loc7 = characterContainer.getChildAt(arg2) as MovieClip).addChild(loc4);
            return;
        }

        private function kickCharacterOutOfChair(arg1:flash.display.MovieClip, arg2:Number):void
        {
            var loc3:*;

            loc3 = arg1._renderClip.avatarClip;
            loc3.x = 0;
            loc3.y = 0;
            arg1._renderClip.addChild(loc3);
            loc3.avatarClip.rightFoot.visible = true;
            loc3.avatarClip.rightCalf.visible = true;
            loc3.avatarClip.rightThigh.visible = true;
            arg1.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
            arg1.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_START, onActionStart);
            arg1.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_CANCELLED, onActionCancelled);
            if (arg1.serverUserId == playerUserId)
            {
                clickEnabled = true;
            }
            return;
        }

        protected function onActionComplete(arg1:MyLife.Events.AvatarActionEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = NaN;
            if (arg1.actionListID != instanceName)
            {
                return;
            }
            loc2 = this.zim.getProp("zone").getCharacter(arg1.characterId);
            if (loc2 == null)
            {
                return;
            }
            loc3 = getSittingStatusFromActionId(Number(arg1.actionId));
            if (loc3 == ANIMATING_STAND)
            {
                loc4 = arg1.actionParams.position;
                if (loc2 == this.zim.getProp("player")._character)
                {
                    this.setCharacterItem(loc2, -1, -1, -1);
                }
                kickCharacterOutOfChair(loc2, loc4);
            }
            return;
        }

        private function getAvatarSitPosition(arg1:flash.display.MovieClip, arg2:Number):flash.geom.Point
        {
            var loc3:*;

            loc3 = sitPositions[arg2];
            return new Point(loc3.x, loc3.y);
        }

        private function clickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            if (clickEnabled == false)
            {
                arg1.stopPropagation();
                return;
            }
            loc2 = new Object();
            loc3 = new Point(arg1.localX, arg1.localY);
            loc3 = hitZone.localToGlobal(loc3);
            loc3 = this.globalToLocal(loc3);
            if ((loc4 = getClosestAvailableSitIndex(loc3.x, loc3.y)) == EMPTY_SPACE)
            {
                clickEnabled = true;
                return;
            }
            arg1.stopPropagation();
            playerUserId = this.zim.getProp("player")._character.serverUserId;
            doItemAction(playerUserId, true, {"position":loc4});
            return;
        }

        private function getSitActionData(arg1:Number, arg2:flash.display.MovieClip, arg3:Boolean):Object
        {
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

            loc12 = null;
            loc13 = null;
            loc14 = null;
            loc15 = NaN;
            loc16 = null;
            loc4 = new Object();
            loc5 = new Array();
            if (arg3 == true)
            {
                loc12 = this.getCharacterWalkToPosition(arg2, arg1);
                loc13 = new Position(loc12.x, loc12.y);
                if ((loc14 = arg2.getWalkPathToPosition(loc13)) == null)
                {
                    return null;
                }
                else 
                {
                    if ((loc15 = getDistanceBetweenPositions(loc14[(loc14.length - 1)], loc13)) > MAX_WALK_STAND_DISTANCE)
                    {
                        arg2.walkAlongPath(loc14, true);
                        return null;
                    }
                    loc14[(loc14.length - 1)] = loc13;
                    (loc16 = new Object()).id = getActionIdFromSittingStatus(4, arg2.getDirection());
                    loc16.params = {"walkPath":loc14, "walkSpeed":arg2.characterSpeed};
                    loc16.interruptionType = 2;
                    loc16.isWaiting = false;
                    loc5.push(loc16);
                }
            }
            loc6 = (this.currentViewName == "Front" || this.rotationView <= 1) ? 0 : 3;
            loc7 = arg3 ? ANIMATING_SIT : NON_ANIMATED_SIT;
            loc8 = new Object();
            loc9 = this.getAvatarSitPosition(arg2, arg1);
            loc8.id = getActionIdFromSittingStatus(loc7, loc6);
            loc8.params = {"x":loc9.x, "y":loc9.y, "position":arg1};
            loc8.interruptionType = 0;
            loc8.isWaiting = true;
            loc5.push(loc8);
            loc10 = new Object();
            loc11 = this.getAvatarStandPosition(arg2, arg1);
            loc10.id = getActionIdFromSittingStatus(ANIMATING_STAND, loc6);
            loc10.params = {"x":loc11.x, "y":loc11.y, "position":arg1};
            loc10.interruptionType = 0;
            loc10.isWaiting = false;
            loc5.push(loc10);
            loc4.actionList = loc5;
            return loc4;
        }

        private function onActionStart(arg1:MyLife.Events.AvatarActionEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc4 = NaN;
            loc5 = null;
            if (arg1.actionListID != instanceName)
            {
                return;
            }
            loc2 = this.zim.getProp("zone").getCharacter(arg1.characterId);
            if (loc2 == null || loc2.avatarActionManager == null)
            {
                return;
            }
            loc2.avatarActionManager.addEventListener(AvatarActionEvent.ACTION_CANCELLED, onActionCancelled);
            loc3 = getSittingStatusFromActionId(Number(arg1.actionId));
            if (loc3 == ANIMATING_SIT || loc3 == NON_ANIMATED_SIT)
            {
                loc4 = arg1.actionParams.position;
                if ((loc5 = characterContainer.getChildAt(loc4) as MovieClip).numChildren > 0)
                {
                    loc2.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_START, onActionStart);
                    loc2.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_CANCELLED, onActionCancelled);
                    loc2.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
                    if (loc2.serverUserId == this.playerUserId)
                    {
                        this.clickEnabled = true;
                    }
                    loc2.avatarActionManager.cancelAllActions();
                    return;
                }
                if (loc3 == ANIMATING_SIT)
                {
                    setCharacterItem(loc2, loc4, playerItemId, positionId);
                }
                this.addCharacterToChair(loc2, loc4);
                maskCharacter(true, loc2);
                loc2.avatarActionManager.addEventListener(AvatarActionEvent.ACTION_COMPLETE, onActionComplete);
            }
            else 
            {
                if (loc3 == ANIMATING_STAND)
                {
                    maskCharacter(false, loc2);
                    loc2.avatarActionManager.removeEventListener(AvatarActionEvent.ACTION_START, onActionStart);
                }
            }
            return;
        }

        private function onActionListStart(arg1:MyLife.Events.AvatarActionEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.actionListID;
            if (loc2 != instanceName)
            {
                return;
            }
            loc3 = this.zim.getProp("zone").getCharacter(arg1.characterId);
            if (loc3 == null || loc3.avatarActionManager == null)
            {
                return;
            }
            loc3.avatarActionManager.addEventListener(AvatarActionEvent.ACTION_START, onActionStart);
            return;
        }

        public override function activate():void
        {
            hitZone.alpha = 0;
            hitZone.visible = true;
            hitZone.buttonMode = true;
            hitZone.addEventListener(MouseEvent.CLICK, clickHandler);
            this.characterContainer.visible = true;
            playerUserId = this.zim.getProp("player")._character.serverUserId;
            positionId = Number(Math.round(this.x) + "" + Math.round(this.y));
            instanceName = "piid_" + positionId;
            super.activate();
            return;
        }

        private static function getSittingStatusFromActionId(arg1:Number):Number
        {
            return Math.floor(arg1 / 4) * 4;
        }

        private static function getActionIdFromSittingStatus(arg1:Number, arg2:Number):Number
        {
            return arg1 + arg2;
        }

        private static const NON_ANIMATED_SIT:Number=12;

        private static const ANIMATING_STAND:Number=16;

        private static const MAX_WALK_STAND_DISTANCE:Number=60;

        private static const EMPTY_SPACE:Number=-1;

        private static const ANIMATING_SIT:Number=8;

        public var instanceName:String;

        private var playerUserId:Number;

        private var clickEnabled:Boolean=true;

        private var characterContainer:flash.display.MovieClip;

        private var positionId:Number;

        private var numSeats:Number;

        private var sitPositions:Array;

        private var standPositions:Array;
    }
}
