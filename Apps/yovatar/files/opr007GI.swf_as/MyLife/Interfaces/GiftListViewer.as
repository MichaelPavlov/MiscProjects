package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Utils.*;
    import MyLife.Utils.Math.*;
    import fl.containers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import gs.*;
    
    public class GiftListViewer extends flash.display.MovieClip
    {
        public function GiftListViewer()
        {
            _friends = [];
            loadPreviewIntoClipImageList = [];
            super();
            trace("GiftListViewer Loaded");
            return;
        }

        private function unloadInterface(arg1:flash.display.MovieClip):void
        {
            _myLife._interface.unloadInterface(arg1);
            return;
        }

        private function closeWindow():*
        {
            TweenLite.to(this, 0.75, {"alpha":0, "onComplete":unloadInterface, "onCompleteParams":[this]});
            return;
        }

        public function destroy():*
        {
            destroyed = true;
            return;
        }

        private function loadImageIntoMovieClip(arg1:flash.display.MovieClip, arg2:String, arg3:int=0, arg4:int=0):*
        {
            var loc5:*;

            DisplayObjectContainerUtils.removeChildren(arg1);
            (loc5 = new Loader()).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageIntoMovieClipError);
            loc5.load(new URLRequest(arg2));
            arg1.addChild(loc5);
            loc5.x = arg3;
            loc5.y = arg4;
            return;
        }

        private function onLoadPreviewIntoClipIOError(arg1:flash.events.IOErrorEvent):*
        {
            return false;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            currentPlayerId = MyLifeInstance.getInstance().player.getPlayerId();
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            buddyListNoBuddies.visible = true;
            nextButton.visible = false;
            giftData = arg2.giftData || {};
            giftData.previousStep = "GiftListViewer";
            playerItemId = giftData.playerItemId;
            itemId = giftData.itemId;
            btnCloseWindow.addEventListener(MouseEvent.CLICK, btnCloseWindowClickHandler, false, 0, true);
            if (FriendDataManager.ready)
            {
                friendDataReady();
            }
            else 
            {
                FriendDataManager.instance.addEventListener(FriendDataManager.EVENT_READY, friendDataReady);
            }
            putContainerIntoScrollPane();
            return;
        }

        private function friendDataReady(arg1:flash.events.Event=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            FriendDataManager.instance.removeEventListener(FriendDataManager.EVENT_READY, friendDataReady);
            loc3 = 0;
            loc4 = FriendDataManager.getAppUserFriendData();
            for each (loc2 in loc4)
            {
                if (loc2)
                {
                    buddyListNoBuddies.visible = false;
                    nextButton.visible = false;
                }
                trace(loc2);
                if (!loc2["image"] && loc2["pic_url"])
                {
                    loc2["image"] = new MovieClip();
                    _myLife.assetsLoader.loadImage(loc2.pic_url, loc2.image, imageLoadedCallback);
                }
                if (loc2.playerId != currentPlayerId)
                {
                    _friends.push(loc2);
                    continue;
                }
                _friends.unshift(loc2);
            }
            loadItemsIntoContainer(_friends);
            return;
        }

        private function imageLoadedCallback(arg1:*, arg2:Object):void
        {
            var loc3:*;

            loc3 = null;
            if (arg1 && arg2)
            {
                loc3 = FitToDimensions.fitToDimensions(arg1.width, arg1.height, 50, (50), FitToDimensions.CONSTRAIN_MAXIMUM);
                arg1.width = loc3.width;
                arg1.height = loc3.height;
                if (arg1.width < 50)
                {
                    arg1.x = (50 - loc3.width) / 2;
                }
                if (arg1.height < 50)
                {
                    arg1.y = (50 - loc3.height) / 2;
                }
                arg2.addChild(arg1);
            }
            else 
            {
                if (arg2)
                {
                    arg2.addChild();
                }
            }
            return;
        }

        private function putContainerIntoScrollPane():*
        {
            containerScrollPane = new ScrollPane();
            this.addChild(containerScrollPane);
            containerScrollPane.move(this.containerBg.x, this.containerBg.y);
            containerScrollPane.setSize(this.containerBg.width, this.containerBg.height);
            containerScrollPane.source = previewContainer;
            return;
        }

        internal function getMovieChildren(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = undefined;
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

        internal function onPreviewItemRollOver(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.currentTarget;
            loc3 = new GlowFilter();
            loc3.inner = true;
            loc3.color = 16768000;
            loc3.blurY = loc4 = 6;
            loc3.blurX = loc4;
            loc2.filters = [loc3];
            return;
        }

        internal function loadItemsIntoContainer(arg1:Array):*
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

            loc7 = null;
            loc8 = 0;
            loc10 = NaN;
            loc11 = undefined;
            loc12 = null;
            loc13 = null;
            loc14 = NaN;
            loc15 = null;
            loc16 = undefined;
            loc17 = undefined;
            trace("\tloadItemsIntoContainer()");
            loc2 = 0;
            loc3 = 0;
            loc4 = 4;
            loc5 = 10;
            loc6 = 10;
            arg1.sortOn(["first_name"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
            if (arg1.length != 0)
            {
            };
            loc9 = arg1.length;
            loc9 = arg1.length;
            trace("count start " + loc9);
            loc8 = 0;
            while (loc8 < loc9) 
            {
                loc7 = arg1[loc8];
                trace("i " + loc8);
                if ((loc10 = Number(loc7.playerId || "")) == currentPlayerId)
                {
                    trace("friendID == currentPlayerId");
                    arg1.splice(loc8, 1);
                    loc9 = arg1.length;
                    trace("count after friendID " + loc9);
                    if (loc8 < loc9)
                    {
                        loc7 = arg1[loc8];
                    }
                    else 
                    {
                        break;
                    }
                }
                loc2 = loc8 % loc4;
                loc3 = (loc8 - loc2) / loc4;
                loc11 = new FriendUnit();
                previewContainer.addChild(loc11);
                loc11.x = loc2 * (loc11.width + loc5);
                loc11.y = loc3 * (loc11.height + loc6);
                loc12 = loc7.first_name || "";
                loc13 = loc7.last_name || "";
                loc14 = 8;
                if (loc12.length > loc14)
                {
                    loc12 = (loc12 = loc12.slice(0, loc14 - 2)) + "...";
                }
                if (loc13.length > loc14)
                {
                    loc13 = (loc13 = loc13.slice(0, loc14 - 2)) + "...";
                }
                loc15 = loc12 + " " + loc13;
                trace("friendNameText " + loc15);
                loc11.playerId = loc10;
                if (loc15.length > 16)
                {
                    loc15 = (loc15 = loc15.slice(0, 14)) + "...";
                }
                loc11.friendName.text = loc15;
                trace("friendnametextwidth " + loc11.friendName.textWidth);
                loc16 = getMovieChildren(loc11.friendImage);
                loc18 = 0;
                loc19 = loc16;
                for each (loc17 in loc19)
                {
                    loc11.friendImage.removeChild(loc17);
                }
                if (loc7.image)
                {
                    loc11.friendImage.addChild(loc7.image);
                }
                addPreviewItemHooks(loc11);
                ++loc8;
            }
            return;
        }

        internal function addPreviewItemHooks(arg1:*):*
        {
            arg1.buttonMode = true;
            arg1.useHandCursor = true;
            arg1.addEventListener(MouseEvent.CLICK, onPreviewItemClick);
            arg1.addEventListener(MouseEvent.ROLL_OVER, onPreviewItemRollOver);
            arg1.addEventListener(MouseEvent.ROLL_OUT, onPreviewItemRollOut);
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        internal function onPreviewItemClick(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            loc4 = null;
            trace("onPreviewItemClick()");
            this.selectedItem = arg1.currentTarget;
            if (this.selectedItem)
            {
                this.giftData.recipientPlayerId = this.selectedItem.playerId;
                trace("sending to " + this.giftData.recipientPlayerId);
                loc2 = {};
                loc2.giftData = this.giftData;
                trace(loc2.giftData.recipientPlayerId);
                this._myLife._interface.showInterface("GiftStepWrap", loc2);
                this._myLife._interface.unloadInterface(this);
            }
            else 
            {
                loc3 = "Select A Friend";
                loc4 = "Please select a friend to gift to continue.";
                this._myLife._interface.showInterface("GenericDialog", {"title":loc3, "message":loc4});
            }
            return;
        }

        internal function onPreviewItemRollOut(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;

            loc2 = arg1.currentTarget;
            loc2.filters = [];
            return;
        }

        private function onLoadImageIntoMovieClipError(arg1:flash.events.IOErrorEvent):*
        {
            return false;
        }

        private function btnCloseWindowClickHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.giftData.onCancel)
            {
                this.giftData.onCancel();
            }
            closeWindow();
            return;
        }

        private function onLoadPreviewIntoClipComplete(arg1:flash.events.Event):void
        {
            return;
        }

        private function loadPreviewImage():*
        {
            var loc1:*;
            var loc2:*;

            loc1 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + imageId + "_60_60.gif?v=" + MyLifeConfiguration.version;
            loc2 = new Loader();
            loc2.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPreviewIntoClipComplete);
            loc2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadPreviewIntoClipIOError);
            loc2.load(new URLRequest(loc1));
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        public var nextButton:flash.display.SimpleButton;

        public var btnCloseWindow:flash.display.SimpleButton;

        private var itemId:*;

        private var destroyed:*=false;

        private var inviteBitmap:flash.display.BitmapData;

        public var previewContainer:flash.display.MovieClip;

        public var containerBg:flash.display.MovieClip;

        private var maxWorkers:int=16;

        private var containerScrollPane:fl.containers.ScrollPane;

        private var LoadingFriendsPleaseWait:flash.display.MovieClip;

        public var buddyListNoBuddies:flash.display.MovieClip;

        private var loadPreviewIntoClipImageList:Array;

        private var playerItemId:*;

        private var curWorkers:int=0;

        private var _friends:Array;

        private var viewItemDetailsWindow:flash.display.MovieClip;

        private var selectedItem:Object;

        public var imageId:Number;

        private var _myLife:*;

        private var txtGiftHeader:flash.display.MovieClip;

        private var currentPlayerId:int;

        public var giftData:Object;

        private var currentPreviewItemClipParent:flash.display.MovieClip;
    }
}
