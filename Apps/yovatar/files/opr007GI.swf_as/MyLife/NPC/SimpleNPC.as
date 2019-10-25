package MyLife.NPC 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.*;
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Events.*;
    import MyLife.Interfaces.*;
    import MyLife.Utils.*;
    import com.boostworthy.core.*;
    import fai.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    
    public class SimpleNPC extends flash.display.MovieClip
    {
        public function SimpleNPC(arg1:flash.display.MovieClip=null, arg2:int=4)
        {
            _renderClip = new MovieClip();
            _nameTagClip = new MovieClip();
            super();
            _myLife = arg1 || MyLifeInstance.getInstance();
            this.modBadge = arg2;
            Global.stage = _myLife.stage;
            _speechBubble = new SpeechBubble(_myLife);
            addChild(_renderClip);
            addChild(_nameTagClip);
            return;
        }

        public function setCharacterProperties(arg1:*, arg2:int, arg3:String=""):void
        {
            _currentClothing = arg1;
            _gender = arg2;
            _characterName = arg3;
            return;
        }

        public function getRenderClip():flash.display.MovieClip
        {
            return _renderClip;
        }

        public function getSpeechBubble():MyLife.SpeechBubble
        {
            return this._speechBubble;
        }

        public function setNewClothing(arg1:Object, arg2:Boolean=false):void
        {
            if (arg2 != true)
            {
                _renderClip.avatarClip.renderClothes(arg1);
            }
            else 
            {
                _renderClip.avatarClip.loadAvatarClothes(arg1, true);
            }
            return;
        }

        public function cleanUp():void
        {
            trace(this._characterName + " cleanUp");
            if (MyLifeInstance.getInstance().player._character == this)
            {
                trace("player character");
                MyLifeInstance.getInstance().server.callExtension("updateCharacterProperty", {"p":"item", "v":{"piid":-1, "itemPos":-1, "posId":-1}, "s":1, "sich3":_characterName});
                setInteractingItemState(-1, -1, -1);
            }
            if (_speechBubble)
            {
                this._speechBubble.remove();
                this._speechBubble = null;
            }
            if (_renderClip)
            {
                removeChild(_renderClip);
                if (_renderClip["avatarClip"])
                {
                    _renderClip.avatarClip.removeEventListener(MouseEvent.ROLL_OVER, onCharacterMouseOver);
                    _renderClip.avatarClip.removeEventListener(MouseEvent.ROLL_OUT, onCharacterMouseOut);
                    _renderClip.avatarClip.parent.removeChild(_renderClip.avatarClip);
                    _renderClip.avatarClip.removeEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, onAvatarLoaded);
                    _renderClip.avatarClip = null;
                }
                DisplayObjectContainerUtils.removeChildren(_renderClip);
                _renderClip = null;
            }
            if (_nameTagClip)
            {
                removeChild(_nameTagClip);
                _nameTagClip = null;
            }
            if (avatarActionManager)
            {
                avatarActionManager.cleanUp();
                avatarActionManager = null;
            }
            _currentClothing = null;
            return;
        }

        public function loadCharacterClothing(arg1:Object, arg2:Object=null):void
        {
            var loc3:*;
            var loc4:*;

            loc4 = null;
            _overrideSpeed = false;
            if (arg2 && arg2.metaData)
            {
                if ((loc4 = new ItemMetaData(arg2.metaData)).getProperty("speed"))
                {
                    _overrideSpeed = true;
                    _speedValue = parseInt(loc4.getProperty("speed"));
                }
            }
            loc3 = _myLife.assetsLoader.newAvatarInstance() as MovieClip;
            loc3.y = 2;
            _renderClip.addChild(loc3);
            _renderClip.avatarClip = loc3;
            loc3.setParentCharacter(this);
            _renderClip.avatarClip.initAvatar(_gender, 0.2);
            loc3.addEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, onAvatarLoaded);
            trace(this._characterName + "**  loadCharacterClothing " + arg2);
            loc3.loadAvatarClothes(arg1, false, arg2);
            return;
        }

        protected function onAvatarLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;

            loc2 = _renderClip.avatarClip;
            if (loc2)
            {
                loc2.buttonMode = true;
                loc2.addEventListener(MouseEvent.ROLL_OVER, onCharacterMouseOver);
                loc2.addEventListener(MouseEvent.ROLL_OUT, onCharacterMouseOut);
            }
            if (avatarActionManager == null)
            {
                avatarActionManager = new AvatarActionManager(loc2);
                doAvatarAction("0");
            }
            dispatchEvent(new AvatarLoadEvent(AvatarLoadEvent.CHARACTER_LOAD_COMPLETE, this));
            renderCharacterName();
            return;
        }

        protected function onCharacterMouseOut(arg1:flash.events.MouseEvent):void
        {
            highlightCharacter(arg1.target, false);
            return;
        }

        internal function getMovieChildren(arg1:flash.display.MovieClip):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = null;
            if (arg1 == null)
            {
                return new Array();
            }
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

        public function doAvatarAction(arg1:String, arg2:Boolean=false, arg3:Object=null):void
        {
            var loc4:*;

            (loc4 = new Object()).id = arg1;
            loc4.interruptionType = 2;
            if (arg3)
            {
                loc4.params = arg3;
            }
            avatarActionManager.doActionList([loc4], arg2, String(arg1));
            return;
        }

        public function getPosition():fai.Position
        {
            return new Position(this.x, this.y);
        }

        public function changeDirection(arg1:Number):*
        {
            avatarActionManager.changeDirection(arg1);
            return;
        }

        public function sayMessage(arg1:*, arg2:Boolean=false):void
        {
            if (!this._speechBubble.parent)
            {
                this.addChild(this._speechBubble);
            }
            renderCharacterName();
            this._speechBubble.sayMessage(arg1, arg2);
            return;
        }

        public function moveTo(arg1:fai.Position, arg2:Boolean=false):*
        {
            walkAlongPath(getWalkPathToPosition(arg1), arg2);
            return;
        }

        protected function onCharacterMouseOver(arg1:flash.events.MouseEvent):void
        {
            highlightCharacter(arg1.target, true);
            return;
        }

        public function setInteractingItemState(arg1:Number, arg2:Number, arg3:Number):void
        {
            interactingItemPosition = arg3;
            interactingItemPlayerItemId = arg1;
            interactingItemPositionId = arg2;
            renderCharacterName();
            return;
        }

        public function get characterSpeed():int
        {
            return _overrideSpeed ? _speedValue : _characterSpeed;
        }

        public function getInteractingItemPosition(arg1:Number, arg2:Number):Number
        {
            if (!(interactingItemPlayerItemId == arg1) && !(interactingItemPositionId == arg2))
            {
                return -1;
            }
            return interactingItemPosition;
        }

        public function setPosition(arg1:fai.Position):void
        {
            this.x = arg1.x;
            this.y = arg1.y;
            return;
        }

        public function set characterSpeed(arg1:int):void
        {
            _characterSpeed = Math.max(125, Math.min(arg1, 350));
            return;
        }

        public function isBusy():Boolean
        {
            return avatarActionManager.isAvatarBusy();
        }

        public function doStop(arg1:Boolean=false):void
        {
            if (arg1 == true)
            {
                MyLifeInstance.getInstance().server.callExtension("updateCharacterProperty", {"p":"item", "v":{"piid":-1, "itemPos":-1, "posId":-1}, "s":1, "sich2":_characterName});
                setInteractingItemState(-1, -1, -1);
            }
            destinationPos = null;
            if (this.avatarActionManager != null)
            {
                this.avatarActionManager.cancelAllActions();
            }
            return;
        }

        public function get gender():int
        {
            return _gender;
        }

        public function getDirection():Number
        {
            return _renderClip.avatarClip.getDirection();
        }

        public function setTemporaryCostume(arg1:Object):void
        {
            var loc2:*;

            loc2 = null;
            _overrideSpeed = false;
            if (arg1 && arg1.metaData)
            {
                loc2 = new ItemMetaData(arg1.metaData);
                if (loc2.getProperty("speed"))
                {
                    _overrideSpeed = true;
                    _speedValue = parseInt(loc2.getProperty("speed"));
                }
            }
            _renderClip.avatarClip.renderItem(arg1, true);
            return;
        }

        protected function renderNameTagGraphics(arg1:Array):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 1;
            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                arg1[loc5].x = arg1[loc5].x + loc3;
                loc3 = loc3 + arg1[loc5].width + loc2;
                _nameTagClip.addChild(arg1[loc5]);
                loc5 = (loc5 + 1);
            }
            (loc6 = new Shape()).graphics.beginFill(nameShapeColor, 0.9);
            loc6.graphics.lineStyle(1, 11184810);
            loc6.graphics.drawRoundRect(loc4, 0, loc3, 16, 14);
            loc6.graphics.endFill();
            loc6.alpha = 0.6;
            _nameTagClip.addChildAt(loc6, 0);
            _nameTagClip.x = -_nameTagClip.width / 2;
            _nameTagClip.y = 6;
            return;
        }

        public function getPlayerId():int
        {
            return myLifePlayerId;
        }

        public function renderCharacterName():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            if (_nameTagClip == null)
            {
                return;
            }
            if (_characterName == "" || _characterName == null)
            {
                return;
            }
            loc2 = 0;
            loc3 = getMovieChildren(_nameTagClip);
            for each (loc1 in loc3)
            {
                _nameTagClip.removeChild(loc1);
            }
            renderNameTagGraphics(getNameTagItems());
            _nameTagClip.scaleY = loc2 = 1 / _myLife.zone.zoneScale;
            _nameTagClip.scaleX = loc2;
            return;
        }

        public function getServerUserId():int
        {
            return serverUserId;
        }

        public function highlightCharacter(arg1:*, arg2:Boolean):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            if (arg2)
            {
                loc3 = new GlowFilter();
                loc3.color = 16768000;
                loc3.blurY = loc4 = 10;
                loc3.blurX = loc4;
                arg1.filters = [loc3];
            }
            else 
            {
                arg1.filters = [];
            }
            renderCharacterName();
            return;
        }

        public function doRandomDance(arg1:Boolean=false):String
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = Math.round(Math.random() * 3);
            if (loc2 != 0)
            {
                if (loc2 != 1)
                {
                    if (loc2 != 2)
                    {
                        if (loc2 == 3)
                        {
                            loc3 = "JUMPING_JACKS";
                        }
                    }
                    else 
                    {
                        loc3 = "ARM_SHUFFLE";
                    }
                }
                else 
                {
                    loc3 = "JUMP_AND_SWING";
                }
            }
            else 
            {
                loc3 = "ROBOT_DANCE";
            }
            doAvatarAction(loc3, arg1);
            return loc3;
        }

        public function getAvatarClip():flash.display.MovieClip
        {
            return _renderClip.avatarClip;
        }

        public function getWalkPathToPosition(arg1:fai.Position):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = NaN;
            if (destinationPos != null)
            {
                if ((loc5 = arg1.deltaPosition(destinationPos).vectorLength()) <= 8)
                {
                    return null;
                }
            }
            destinationPos = arg1;
            loc2 = this.getPosition();
            loc3 = _myLife.zone.checkForCollisionBlock(loc2.x, loc2.y);
            return loc4 = _myLife.zone.getCollisionPath().findPath(getPosition(), arg1, loc3);
        }

        public function getNameTag():flash.display.MovieClip
        {
            return this._nameTagClip;
        }

        public override function set y(arg1:Number):void
        {
            super.y = arg1;
            if (_speechBubble)
            {
                this._speechBubble.y = (this.y + this.speechBubbleOffsetY) * _myLife.zone.zoneScale;
            }
            return;
        }

        public function activate():Boolean
        {
            var loc1:*;

            loc1 = null;
            this.avatarActionManager.cancelAllActions();
            if (interactingItemPlayerItemId != -1)
            {
                loc1 = MyLifeInstance.getInstance().zone.zoneItemManager.getItemByPlayerItemId(interactingItemPlayerItemId, interactingItemPositionId);
                if (loc1 != null)
                {
                    if (interactingItemPosition != -1)
                    {
                        loc1.doItemAction(serverUserId, false, {"position":interactingItemPosition});
                        return true;
                    }
                }
                setInteractingItemState(-1, -1, -1);
                if (MyLifeInstance.getInstance().player._character == this)
                {
                    MyLifeInstance.getInstance().server.callExtension("updateCharacterProperty", {"p":"item", "v":{"item":-1, "itemPos":-1}, "s":1, "sich":_characterName});
                }
            }
            if (_renderClip.avatarClip && !(_renderClip.avatarClip.parent == _renderClip))
            {
                _renderClip.addChild(_renderClip.avatarClip);
            }
            return false;
        }

        protected function getNameTagTextField():flash.text.TextField
        {
            var loc1:*;
            var loc2:*;

            loc1 = new TextFormat();
            loc1.font = "Tahoma";
            loc1.color = 0;
            loc1.size = 11;
            loc1.align = "center";
            loc2 = new TextField();
            loc2.selectable = false;
            loc2.defaultTextFormat = loc1;
            loc2.embedFonts = true;
            loc2.antiAliasType = AntiAliasType.ADVANCED;
            loc2.width = 300;
            loc2.text = _characterName;
            loc2.wordWrap = false;
            loc2.height = 18;
            if (loc2.textWidth > 100)
            {
                loc2.width = 106;
            }
            else 
            {
                loc2.width = loc2.textWidth + 6;
            }
            loc2.alpha = 0.6;
            return loc2;
        }

        protected function getNameTagItems():Array
        {
            var loc1:*;

            loc1 = new Array();
            if (modBadge >= 0)
            {
                loc1.push(getModBadge(modBadge));
            }
            loc1.push(getNameTagTextField());
            return loc1;
        }

        public override function set x(arg1:Number):void
        {
            super.x = arg1;
            if (_speechBubble)
            {
                this._speechBubble.x = (this.x + this.speechBubbleOffsetX) * _myLife.zone.zoneScale;
            }
            return;
        }

        public function walkAlongPath(arg1:Array, arg2:Boolean=false):*
        {
            var loc3:*;

            loc3 = null;
            trace("walkAlongPath " + arg1);
            if (arg1 != null)
            {
                loc3 = new Object();
                loc3.id = String(this.getDirection() + 4);
                loc3.interruptionType = 2;
                loc3.params = {"walkPath":arg1, "walkSpeed":characterSpeed};
                avatarActionManager.doActionList([loc3], arg2);
            }
            return;
        }

        protected function getModBadge(arg1:Number):MyLife.Interfaces.ModBadge
        {
            var loc2:*;

            loc2 = new ModBadge();
            loc2.gotoAndStop(arg1);
            loc2.alpha = 0.6;
            loc2.x = 2;
            if (offlineToolTip == null)
            {
                offlineToolTip = new ToolTip(0, 16445345, true, true, true, OFFLINE_TOOLTIP_X, OFFLINE_TOOLTIP_Y);
                this.addChild(offlineToolTip);
            }
            offlineToolTip.addTool(loc2, "offline");
            return loc2;
        }

        private const speechBubbleOffsetX:int=5;

        private const speechBubbleOffsetY:int=-85;

        private static const OFFLINE_TOOLTIP_X:int=-65;

        private static const OFFLINE_TOOLTIP_Y:int=-18;

        public static const CHARACTER_STOPPED:String="MLE_CHARACTER_STOPPED";

        protected var _speedValue:int=150;

        public var currentFoot:int=0;

        protected var offlineToolTip:MyLife.Interfaces.ToolTip;

        protected var interactingItemPlayerItemId:Number=-1;

        public var stepCount:int=0;

        public var _renderClip:flash.display.MovieClip;

        protected var nameShapeColor:Number=10066431;

        protected var interactingItemPositionId:Number=-1;

        protected var _characterSpeed:int=150;

        public var avatarActionManager:MyLife.Assets.Avatar.AvatarActions.AvatarActionManager;

        protected var _nameTagClip:flash.display.MovieClip;

        protected var modBadge:int;

        public var myLifePlayerId:Number=0;

        public var actionBusy:Boolean=false;

        public var sortOrder:Number=0;

        public var _characterName:String="";

        protected var _overrideSpeed:Boolean=false;

        protected var _gender:int;

        protected var _currentClothing:Object;

        protected var destinationPos:fai.Position;

        protected var _myLife:flash.display.MovieClip;

        protected var interactingItemPosition:Number=-1;

        public var serverUserId:*;

        protected var _speechBubble:MyLife.SpeechBubble;

        public var depth_value:Number;
    }
}
