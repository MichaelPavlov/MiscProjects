package MyLife.Interfaces 
{
    import MyLife.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class GiftWindowOpen extends MyLife.Interfaces.SimpleInterface
    {
        public function GiftWindowOpen()
        {
            thankYouOptions = ["Thank you for the gift you sent.  That’s really nice of you.", "You are too kind.  Thanks for the great gift.", "What a wonderful gift!  Thanks so much.", "You Rock!  Thanks for sending me the cool gift.", "The only thing better than the gift you sent me is YOU!", "You’re so thoughtful.  Thank you for the nice gift.", "You are too generous!  Thanks for the great gift.", "Big Thanks for the awesome gift.", "How sweet of you to send me a gift.", "You are the Best!  Thanks for the gift.", "I really appreciate the gift you sent.  Thank you.", "Thank you for the great gift you sent!", "Sending You Thanks for the great gift!", "You are one generous gifter!  Thank you.", "That was very thoughtful of you to send me a gift. Thank you.", "Thanks for the sweet gift.  You’re the best!", "I sure do appreciate your great gift.  Thanks.", "Thanks a million for such a cool gift!", "What a fantastic gift.  Thank you for sending it to me.", "What a wonderful gift.  Thanks so much!", "Muchas Gracias for the generous gift!", "What a great friend you are.  Thanks for the cool gift.", "Your generous gift made my day.  Thank you for sending it.", "Thanks a bunch for the great gift.  I appreciate it.", "You’re a true friend.  Thanks for the awesome gift.", "Just what I wanted!  Thank you for sending the perfect gift.", "People like you are what make YoVille so awesome. Thanks for the generous gift.", "A terrific gift!  Thank you so much for sending it.", "You Rule!  Thanks for the gift.", "Your generous gift made me really happy!  Thank you.", "Just a quick note to say thanks for the awesome gift!", "Thanks!   Your gift made my day.", "Thanks A Lot for sending such a generous gift.  You’re too kind.", "Your gift put a smile on my face.  Thank you so much.", "What a great surprise!  Thanks for the gift.", "You’re the nicest person I know.  Thank you for the generous gift.", "You’ve got a big heart!  Thank you for the nice gift.", "Sweet!  I love the gift you sent.  Thanks.", "I’m loving your gift!  Thank you so much.", "Love it!  Thanks for super-duper gift.", "You are my hero!  What a great gift.  Thanks."];
            super();
            return;
        }

        private function closeWindow():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            dispatchEvent(new Event(Event.CLOSE));
            _myLife.server.removeEventListener(MyLifeEvent.OPEN_ACTION_COMPLETE, openGiftCompleteHandler);
            btnThankYou.removeEventListener(MouseEvent.CLICK, sendThankYouClickHandler);
            closeButton.removeEventListener(MouseEvent.CLICK, closeButtonClickHandler);
            _myLife._interface.unloadInterface(this);
            return;
        }

        private function loadImageIntoMovieClip(arg1:String, arg2:int, arg3:int):*
        {
            _myLife.assetsLoader.loadImage(arg1, {"width":arg2, "height":arg3}, imageLoadedHandler);
            return;
        }

        private function closeButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            closeWindow();
            return;
        }

        public override function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var loc3:*;

            loc3 = 0;
            this._myLife = arg1;
            this.giftData = arg2;
            this.openGift();
            if (this.giftData.fromPlayerId)
            {
                loc3 = Math.floor(Math.random() * (thankYouOptions.length - 1));
                replyTextField.text = thankYouOptions[loc3];
                this.btnThankYou.addEventListener(MouseEvent.CLICK, sendThankYouClickHandler, false, 0, true);
            }
            else 
            {
                replyTextField.visible = false;
                this.btnThankYou.visible = false;
            }
            this.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler, false, 0, true);
            return;
        }

        private function openGiftCompleteHandler(arg1:MyLife.MyLifeEvent=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc2 = arg1.eventData || {};
            if (loc2.actionType == this._myLife.server.ACTION_MANAGER_TYPE_GIFT && loc2.success)
            {
                loc3 = loc2.item;
                loc4 = "";
                if (loc3.categoryId == 2001 || loc3.categoryId == 2002)
                {
                    loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc3.itemId + "_110_80.gif";
                    this.loadImageIntoMovieClip(loc4, 110, 80);
                }
                else 
                {
                    loc4 = _myLife.myLifeConfiguration.variables["global"]["item_image_path"] + loc3.itemId + "_130_100.gif";
                    this.loadImageIntoMovieClip(loc4, 130, 100);
                }
                this.itemNameTextField.text = loc3.name || "";
                this.fromTextField.text = "From " + this.giftData.fromPlayerName + ":";
                this.noteTextField.text = this.giftData.message;
                if (!(loc5 = InventoryManager.setInventoryItemProperty(this.giftData.playerItemId, "isHidden", false)))
                {
                    InventoryManager.addItemToInventory(loc3);
                }
                replyTextField.setSelection(0, replyTextField.text.length);
                if (this.stage)
                {
                    this.stage.focus = replyTextField;
                }
            }
            return;
        }

        private function openGift():void
        {
            var loc1:*;

            loc1 = this._myLife.server.ACTION_MANAGER_TYPE_GIFT;
            this._myLife.server.addEventListener(MyLifeEvent.OPEN_ACTION_COMPLETE, openGiftCompleteHandler, false, 0, true);
            this._myLife.server.callExtension("ActionManager.openAction", {"actionType":loc1, "actionId":this.giftData.giftId});
            return;
        }

        private function imageLoadedHandler(arg1:*, arg2:*):void
        {
            if (arg1)
            {
                arg1.x = 130 - arg2.width >> 1;
                arg1.y = 100 - arg2.height >> 1;
                picture.addChild(arg1);
            }
            return;
        }

        private function sendThankYouClickHandler(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            if (_myLife && !_myLife.runningLocal)
            {
                loc3 = new LinkTracker();
                loc3.setRandomActive();
                loc3.track("1962", "1529");
            }
            loc2 = StringUtils.trim(replyTextField.text);
            if (loc2 != "")
            {
                _myLife.getServer().callExtension("postApartmentComment", {"playerId":giftData.fromPlayerId, "message":loc2, "meta":""});
                _myLife.getServer().callExtension("ActionManager.sendAction", {"recipientPlayerId":giftData.fromPlayerId, "actionType":_myLife.getServer()["ACTION_MANAGER_TYPE_MESSAGE"]});
                _myLife.getServer().sendNotification(_myLife.getServer().ACTION_MANAGER_TYPE_MESSAGE, giftData.fromPlayerId, true);
                this.dispatchEvent(new Event("commentSent"));
            }
            closeWindow();
            return;
        }

        public var fromTextField:flash.text.TextField;

        private var thankYouOptions:Array;

        public var replyTextField:flash.text.TextField;

        public var btnThankYou:flash.display.SimpleButton;

        public var closeButton:flash.display.SimpleButton;

        private var _myLife:flash.display.MovieClip;

        public var itemNameTextField:flash.text.TextField;

        private var giftData:Object;

        public var noteTextField:flash.text.TextField;

        public var picture:flash.display.MovieClip;
    }
}
