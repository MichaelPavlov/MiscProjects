package MyLife 
{
    import MyLife.Interfaces.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import gs.*;
    
    public class Interface extends flash.display.MovieClip
    {
        public function Interface()
        {
            super();
            trace("Interface Class Initialized");
            Security.allowDomain("*");
            return;
        }

        public function makeContextMenu(arg1:Array, arg2:Object=null):MyLife.Interfaces.MyLifeContextMenu
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (this.myLifeContextMenu)
            {
                this.myLifeContextMenu.remove();
            }
            this.myLifeContextMenu = new MyLifeContextMenu(arg1, arg2);
            loc3 = -20;
            loc4 = 12;
            this.myLifeContextMenu.x = this.stage.mouseX + loc3;
            this.myLifeContextMenu.y = this.stage.mouseY - this.myLifeContextMenu.height + loc4;
            this.stage.addChild(this.myLifeContextMenu);
            if ((loc5 = this.myLifeContextMenu.getBounds(this.stage)).right > this.stage.stageWidth)
            {
                this.myLifeContextMenu.x = this.stage.mouseX - this.myLifeContextMenu.width - loc3;
            }
            if (loc5.top < 0)
            {
                this.myLifeContextMenu.y = this.stage.mouseY - loc4;
            }
            this.myLifeContextMenu.alpha = 0;
            TweenLite.to(this.myLifeContextMenu, 0.3, {"alpha":1});
            return this.myLifeContextMenu;
        }

        public function getIsHomeLocked():Boolean
        {
            var loc1:*;

            return (loc1 = this.interfaceHUD)["getIsHomeLocked"]();
        }

        public function initialize(arg1:flash.display.MovieClip):void
        {
            _myLife = arg1;
            _myLife.addChild(this);
            interfaceHUD = new HUD();
            interfaceHUD.initialize(_myLife, {});
            addChildAt(interfaceHUD, 0);
            TradeManager.initialize();
            interfaceDialogOpen = false;
            interfaceQueue = new Array();
            return;
        }

        public function dequeueInterfaceDialog():*
        {
            var loc1:*;

            loc1 = this.interfaceQueue.shift();
            if (loc1)
            {
                displayInterfaceDialog(loc1.interfaceName, loc1.interfaceParams, loc1.autoShow, loc1.isDraggable, loc1.newInterface);
            }
            return;
        }

        public function setIsHomeLocked(arg1:Boolean):void
        {
            this.interfaceHUD.setIsHomeLocked(arg1);
            return;
        }

        public function initializeFriendLadder():void
        {
            friendLadder = new FriendLadder();
            friendLadder.initialize(_myLife.getPlayer().getPlayerId());
            friendLadder.y = 570;
            addChildAt(friendLadder, getChildIndex(interfaceHUD) + 1);
            return;
        }

        private function interfaceCloseListener(arg1:MyLife.MyLifeEvent):void
        {
            dispatchEvent(arg1);
            return;
        }

        public function queueInterfaceDialog(arg1:String, arg2:Object, arg3:Boolean, arg4:Boolean, arg5:flash.display.MovieClip):void
        {
            var loc6:*;

            (loc6 = new Object()).interfaceName = arg1;
            loc6.interfaceParams = arg2;
            loc6.autoShow = arg3;
            loc6.isDraggable = arg4;
            loc6.newInterface = arg5;
            this.interfaceQueue.push(loc6);
            return;
        }

        private function externalWindowHandler(arg1:MyLife.MyLifeEvent):void
        {
            setDialogOpen(arg1);
            BadgeManager.instance.addEventListener(MyLifeEvent.WINDOW_CLOSE, unsetDialogOpen);
            return;
        }

        public function setDialogOpen(arg1:MyLife.MyLifeEvent=null):void
        {
            interfaceDialogOpen = true;
            return;
        }

        private function draggableInterfaceMouseDownHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;

            loc2 = arg1.target as MovieClip;
            this.draggableInterface = loc2.parent as MovieClip;
            dragMouseOffset = {"x":stage.mouseX - draggableInterface.x, "y":stage.mouseY - draggableInterface.y};
            this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            return;
        }

        private function stageMouseUpHandler(arg1:flash.events.MouseEvent):void
        {
            this.removeDraggableInterfaceListeners();
            return;
        }

        public function unsetDialogOpen(arg1:MyLife.MyLifeEvent=null):void
        {
            interfaceDialogOpen = false;
            dequeueInterfaceDialog();
            return;
        }

        public function displayInterfaceDialog(arg1:String, arg2:Object, arg3:Boolean, arg4:Boolean, arg5:flash.display.MovieClip):*
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc6 = 0;
            loc7 = 0;
            loc8 = null;
            if (arg5)
            {
                if (arg5.hasOwnProperty("initialize"))
                {
                    arg5.initialize(_myLife, arg2);
                }
                if (arg3 && arg5.hasOwnProperty("show"))
                {
                    arg5.show();
                }
                _myLife.showDialog(arg5);
                if (arg1 != "GenericDialog")
                {
                    currentInterface = arg5;
                    currentInterfaceName = arg1;
                    loc9 = arg1;
                    switch (loc9) 
                    {
                        case "TradeInterface":
                            this._myLife._interface.interfaceHUD.showOverlayButtons(false);
                    }
                }
                if (arg4)
                {
                    loc6 = this.MAX_X - this.MIN_X >> 1;
                    loc7 = this.MAX_Y - this.MIN_Y >> 1;
                    loc8 = arg5.getBounds(this);
                    arg5.x = loc6 - loc8.left - (loc8.width >> 1);
                    arg5.y = loc7 - loc8.top - (loc8.height >> 1) + this.MIN_Y;
                    if (arg5.hasOwnProperty("titleBar"))
                    {
                        arg5.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, draggableInterfaceMouseDownHandler, false, 0, true);
                        arg5.titleBar.useHandCursor = loc9 = true;
                        arg5.titleBar.buttonMode = loc9;
                        arg5.titleBar.mouseChildren = false;
                    }
                }
            }
            return arg5;
        }

        public function getHud():MyLife.Interfaces.HUD
        {
            return interfaceHUD;
        }

        public function hide():void
        {
            interfaceHUD.hide();
            return;
        }

        public function showInterface(arg1:String, arg2:Object=null, arg3:Boolean=true, arg4:Boolean=false, arg5:Boolean=false):*
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc7 = false;
            loc8 = null;
            trace("showInterface(" + arg1 + ")");
            loc6 = null;
            loc9 = arg1;
            switch (loc9) 
            {
                case "ConfirmPurchaseWithOpen":
                    loc6 = new ConfirmPurchaseWithOpen();
                    break;
                case "CreateNewPlayerStep1":
                    loc6 = new CreateNewPlayerStep1();
                    break;
                case "CreateNewPlayerStep2":
                    loc6 = new CreateNewPlayerStep2();
                    break;
                case "MysterBoxDialog":
                    loc6 = new MysteryBoxDialog();
                    break;
                case "ViewStoreInventory":
                    loc6 = ViewStoreInventory.getInstance();
                    break;
                case "GiftWindow":
                    loc6 = new GiftWindow();
                    break;
                case "GiftWindowOpen":
                    loc6 = new GiftWindowOpen();
                    break;
                case "TradeInterface":
                    loc6 = new TradeInterface();
                    break;
                case "GiftListViewer":
                    loc6 = new GiftListViewer();
                    break;
                case "GiftStepInventory":
                    loc6 = new GiftStepInventory();
                    break;
                case "GiftStepWrap":
                    loc6 = new GiftStepWrap();
                    break;
                case "PlayerInfoWindow":
                    loc6 = new PlayerInfoWindow();
                    break;
                case "FactoryWorkDialog":
                    loc6 = new FactoryWorkDialog();
                    break;
                case "WorkHelpDlg":
                    loc6 = new WorkHelpDlg();
                    break;
                default:
                    if (loc7 = arg1.indexOf(".") == -1)
                    {
                        loc8 = getDefinitionByName("MyLife.Interfaces." + arg1) as Class;
                    }
                    else 
                    {
                        loc8 = getDefinitionByName(arg1) as Class;
                    }
                    loc6 = new loc8();
                    break;
            }
            if (interfaceDialogOpen)
            {
                queueInterfaceDialog(arg1, arg2, arg3, arg4, loc6);
            }
            else 
            {
                displayInterfaceDialog(arg1, arg2, arg3, arg4, loc6);
            }
            if (loc6)
            {
                loc6.addEventListener(MyLifeEvent.WINDOW_CLOSE, interfaceCloseListener, false, 0, true);
            }
            return loc6;
        }

        public function getWaterBalloonPercentage():Number
        {
            var loc1:*;
            var loc2:*;

            loc1 = NaN;
            loc2 = this.interfaceHUD.throwBalloonButtonIcon;
            if (loc2.currentFrame > 2)
            {
                loc1 = loc2.currentFrame / loc2.totalFrames;
            }
            else 
            {
                loc1 = 1;
            }
            return loc1;
        }

        public function setWaterBalloonPercentage(arg1:Number=1):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = 0;
            loc2 = this.interfaceHUD.throwBalloonButtonIcon;
            if (arg1 >= 1)
            {
                loc2.gotoAndStop(1);
            }
            else 
            {
                loc3 = loc2.totalFrames * arg1;
                loc2.gotoAndStop(loc3);
            }
            return;
        }

        private function removeDraggableInterfaceListeners():void
        {
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            return;
        }

        private function stageMouseMoveHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.draggableInterface)
            {
                draggableInterface.x = stage.mouseX - dragMouseOffset.x;
                draggableInterface.y = stage.mouseY - dragMouseOffset.y;
                if (draggableInterface.x < MIN_X)
                {
                    draggableInterface.x = MIN_X;
                }
                else 
                {
                    if (draggableInterface.x > MAX_X - draggableInterface.width)
                    {
                        draggableInterface.x = MAX_X - draggableInterface.width;
                    }
                }
                if (draggableInterface.y < MIN_Y)
                {
                    draggableInterface.y = MIN_Y;
                }
                else 
                {
                    if (draggableInterface.y > MAX_Y - draggableInterface.height)
                    {
                        draggableInterface.y = MAX_Y - draggableInterface.height;
                    }
                }
            }
            else 
            {
                this.removeDraggableInterfaceListeners();
            }
            return;
        }

        public function unloadInterface(arg1:flash.display.MovieClip):void
        {
            var interfaceObject:flash.display.MovieClip;
            var loc2:*;
            var loc3:*;

            interfaceObject = arg1;
            if (interfaceObject.hasOwnProperty("titleBar"))
            {
                interfaceObject.titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, draggableInterfaceMouseDownHandler);
            }
            this.removeDraggableInterfaceListeners();
            this.currentInterface = null;
            this.currentInterfaceName = "";
            if (interfaceObject)
            {
                _myLife.hideDialog(interfaceObject);
            }
            try
            {
                interfaceObject.destroy();
            }
            catch (e:Error)
            {
            };
            unsetDialogOpen();
            return;
        }

        public function show():void
        {
            interfaceHUD.show();
            return;
        }

        public const MIN_X:int=2;

        public const MIN_Y:int=80;

        public const MAX_Y:int=535;

        public const MAX_X:int=640;

        private var _SelectPlayer:MyLife.Interfaces.SelectPlayer;

        private var _StartScreen:MyLife.Interfaces.StartScreen;

        private var _ProgressDialog:MyLife.Interfaces.ProgressDialog;

        private var draggableInterface:flash.display.MovieClip;

        private var dragMouseOffset:Object;

        public var myLifeContextMenu:MyLife.Interfaces.MyLifeContextMenu;

        public var currentInterface:flash.display.MovieClip;

        private var interfaceDialogOpen:Boolean;

        private var _CreateNewPlayerStep1:MyLife.Interfaces.CreateNewPlayerStep1;

        private var _CreateNewPlayerStep2:MyLife.Interfaces.CreateNewPlayerStep2;

        private var _GenericDialog:MyLife.Interfaces.GenericDialog;

        public var currentInterfaceName:String;

        private var _myLife:flash.display.MovieClip;

        public var friendLadder:MyLife.Interfaces.FriendLadder;

        private var interfaceQueue:Array;

        public var interfaceHUD:MyLife.Interfaces.HUD;
    }
}
