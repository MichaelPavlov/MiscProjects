package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Components.*;
    import com.adobe.serialization.json.*;
    import fl.controls.*;
    import fl.controls.listClasses.*;
    import fl.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class EventWindow extends flash.display.MovieClip
    {
        public function EventWindow()
        {
            var loc1:*;

            super();
            loc1 = new CheckBox();
            startDialog.cbContainer.addChild(loc1);
            startDialog.cbContainer["premium"] = loc1;
            this.makeComboBox();
            this.makeEventList();
            this.makeTimer();
            this.makeListeners();
            return;
        }

        protected function createTimerComplete(arg1:flash.events.TimerEvent):void
        {
            this.createAvailable = true;
            return;
        }

        public function show():void
        {
            this.visible = true;
            return;
        }

        public function isPremiumIndex(arg1:int):Boolean
        {
            if (this.events[arg1].premium == 1)
            {
                return true;
            }
            return false;
        }

        protected function itemRollOverHandler(arg1:fl.events.ListEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.item;
            loc3 = this.eventList.itemToCellRenderer(loc2) as CellRenderer;
            loc4 = loc3.getBounds(this.description.parent);
            this.description.y = loc4.top + loc3.height * 0.5;
            this.description.textField.text = loc2.data.desc;
            this.description.time.text = loc2.data.time;
            this.description.visible = true;
            return;
        }

        public function closeWindow():void
        {
            this.visible = false;
            return;
        }

        protected function makeEventList():void
        {
            this.eventList = new List();
            this.eventList.x = this.viewDialog.eventsWindowOutline.x;
            this.eventList.y = this.viewDialog.eventsWindowOutline.y;
            this.eventList.width = (this.viewDialog.eventsWindowOutline.width - 1);
            this.eventList.height = (this.viewDialog.eventsWindowOutline.height - 1);
            this.eventList.setStyle("cellRenderer", AlternatingColorRenderer);
            this.viewDialog.eventsWindowOutline.parent.addChildAt(this.eventList, 3);
            this.description = this.viewDialog.description;
            this.description.x = this.description.x + this.viewDialog.x;
            this.addChild(this.description);
            this.description.visible = false;
            this.description.mouseEnabled = false;
            return;
        }

        protected function eventDescriptionMouseDownHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.startDialog.eventDescription.text == this.DEFAULT_EVENT_DESCRIPTION)
            {
                this.startDialog.eventDescription.setSelection(0, this.startDialog.eventDescription.length);
            }
            this.startDialog.warning.visible = false;
            return;
        }

        protected function updateEventList():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            loc3 = 0;
            this.eventList.removeAll();
            if (this.events)
            {
                loc2 = this.events.length;
                if (loc2)
                {
                    loc2 = (loc2 > this.MAX_EVENTS) ? this.MAX_EVENTS : loc2;
                    loc3 = loc2--;
                    while (loc3--) 
                    {
                        loc1 = this.events[(loc2 - loc3)];
                        this.eventList.addItem({"label":loc1.title, "data":loc1});
                    }
                    this.eventList.addEventListener(Event.ENTER_FRAME, updateRows, false, 0, true);
                    this.viewDialog.defaultText.visible = false;
                }
            }
            return;
        }

        public function joinEvent(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = null;
            this.lastEventData = arg1;
            loc2 = Number(this.lastEventData.pid);
            loc3 = 1;
            loc4 = "This event is located on a different server than you.  Are you sure you want to change servers?";
            loc5 = this.lastEventData.instance || getCurrentInstanceId();
            MyLifeInstance.getInstance().getZone().addEventListener(MyLifeEvent.JOIN_ZONE_COMPLETE, joinCompleteHandler, false, 0, true);
            if (loc6 = Number(this.lastEventData.playerHomeId))
            {
                MyLifeInstance.getInstance().getZone().joinHomeRoom(loc6, loc2, 0, loc3, loc5, loc4);
            }
            else 
            {
                loc7 = "APLiving-" + loc2;
                MyLifeInstance.getInstance().getZone().join(loc7, loc3, loc5, loc4);
            }
            return;
        }

        protected function premiumInfoButtonHandler(arg1:flash.events.Event):void
        {
            if (arg1.type != MouseEvent.MOUSE_OVER)
            {
                this.startDialog.premiumInfoBox.visible = false;
            }
            else 
            {
                this.startDialog.premiumInfoBox.visible = true;
            }
            return;
        }

        protected function cancelButtonClickHandler(arg1:flash.events.MouseEvent):void
        {
            this.hide();
            return;
        }

        protected function comboBoxOpenHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            this.eventList.mouseChildren = loc2 = false;
            this.eventList.mouseEnabled = loc2;
            return;
        }

        protected function comboBoxChangeHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = this.combobox.selectedLabel;
            this.currentCategoryId = this.iDOfCategory(loc2);
            this.viewDialog.defaultText.visible = true;
            this.loadDataFromServer();
            return;
        }

        protected function loadDataIOErrorHandler(arg1:flash.events.Event):void
        {
            return;
        }

        public function showDialog(arg1:String):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = NaN;
            loc3 = NaN;
            loc4 = arg1;
            switch (loc4) 
            {
                case "viewDialog":
                    this.viewDialog.visible = true;
                    this.startDialog.visible = false;
                    loc2 = MyLifeInstance.getInstance().getZone().getApartmentOwnerPlayerId();
                    loc3 = this.getPlayerId();
                    if (loc2 != loc3)
                    {
                        this.viewDialog.btnStartEvent.alpha = 0.5;
                        this.viewDialog.btnStartEvent.mouseEnabled = true;
                    }
                    else 
                    {
                        this.viewDialog.btnStartEvent.alpha = 1;
                        this.viewDialog.btnStartEvent.mouseEnabled = true;
                    }
                    this.viewDialog.defaultText.visible = true;
                    this.updateEventList();
                    break;
                case "startDialog":
                    this.viewDialog.visible = false;
                    this.startDialog.visible = true;
                    this.startDialog.eventTitle.text = this.DEFAULT_EVENT_NAME;
                    this.startDialog.eventDescription.text = this.DEFAULT_EVENT_DESCRIPTION;
                    this.startDialog.eventTitle.setSelection(0, this.startDialog.eventTitle.length);
                    this.startDialog.warning.visible = false;
                    this.startDialog.premiumInfoBox.visible = false;
                    if (this.stage)
                    {
                        this.stage.focus = this.startDialog.eventTitle;
                    }
                    break;
            }
            this.currentDialog = this[arg1];
            return;
        }

        protected function loadDataCompleteHandler(arg1:flash.events.Event=null):void
        {
            var loc2:*;

            loc2 = arg1.target.data;
            if (loc2)
            {
                this.events = JSON.decode(loc2);
            }
            else 
            {
                this.events = [];
            }
            this.updateEventList();
            return;
        }

        protected function comboBoxCloseHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            this.eventList.mouseChildren = loc2 = true;
            this.eventList.mouseEnabled = loc2;
            return;
        }

        protected function getCurrentInstanceId():*
        {
            return MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"];
        }

        protected function createCompleteHandler(arg1:flash.events.Event):void
        {
            var errorMessage:String;
            var event:flash.events.Event;
            var key:String;
            var loc2:*;
            var loc3:*;
            var params:Object;
            var response:String;
            var responseObj:Object;
            var responseString:String;

            responseString = null;
            response = null;
            key = null;
            responseObj = null;
            params = null;
            event = arg1;
            responseString = event.target.data;
            try
            {
                responseObj = JSON.decode(responseString);
                if (responseObj as Number)
                {
                    response = String(responseObj);
                }
                else 
                {
                    if (responseObj.hasOwnProperty("result"))
                    {
                        response = responseObj["result"];
                    }
                    if (responseObj.hasOwnProperty("key"))
                    {
                        key = responseObj["key"];
                    }
                }
            }
            catch (error:com.adobe.serialization.json.JSONParseError)
            {
                response = responseString;
            }
            errorMessage = "";
            if (response)
            {
                if (response != "1")
                {
                    if (response != "4")
                    {
                        if (response == "2")
                        {
                            errorMessage = "You have been banned from creating new events due to abuse. First time offenders are banned for 24 hours, second time bans last 72 hours, and third time offenders are banned forever.";
                        }
                    }
                    else 
                    {
                        errorMessage = "We do not show inappropriate events. Continuous abuse will result in termination of your ability to create events.";
                    }
                }
                else 
                {
                    errorMessage = "An error occured creating your event. Please try again";
                }
                if (errorMessage != "")
                {
                    MyLifeInstance.getInstance()._interface.showInterface("GenericDialog", {"title":"Error", "message":errorMessage});
                }
                MyLifeInstance.getInstance().server.callExtension("giveCoinBonus", {"playerId":MyLifeInstance.getInstance().getPlayer()._playerId});
                MyLifeInstance.getInstance().getInterface().interfaceHUD.showEventLink(this.lastEventData);
                this.hide();
            }
            if (key)
            {
                params = {};
                params.key = key;
                params.amt = 1;
                (MyLifeInstance.getInstance() as MyLife).getServer().callExtension("XpManager.updateEventXpSFS", params);
            }
            return;
        }

        protected function startEventClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = null;
            if (this.viewDialog.btnStartEvent.alpha != 1)
            {
                loc2 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Go Home Now?", "message":"To start an event you must be in your home. Do you want to go home now?", "metaData":{}, "buttons":[{"name":"Yes", "value":"BTN_YES"}, {"name":"No", "value":"BTN_NO"}]});
                loc2.addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmGoHomeDialogHandler);
            }
            else 
            {
                this.showDialog("startDialog");
            }
            return;
        }

        protected function createClickHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = this.startDialog.eventTitle.text;
            loc3 = this.startDialog.eventDescription.text;
            loc4 = false;
            loc5 = true;
            loc6 = new RegExp("[A-Za-z0-9]");
            if (loc2 == "" || loc2 == this.DEFAULT_EVENT_NAME || !loc6.test(loc2))
            {
                loc4 = true;
            }
            else 
            {
                if (loc3 == "" || loc3 == this.DEFAULT_EVENT_DESCRIPTION || !loc6.test(loc3))
                {
                    loc4 = true;
                }
            }
            if (startDialog.cbContainer.premium.selected)
            {
                if (MyLifeInstance.getInstance().getPlayer().getCoinBalance() < this.PREMIUM_EVENT_COST)
                {
                    loc5 = false;
                    MyLifeInstance.getInstance()._interface.showInterface("GenericDialog", {"title":"Not Enough Money", "message":"Sorry, you need " + this.PREMIUM_EVENT_COST + " coins to create a premium event."});
                }
            }
            if (loc4)
            {
                this.startDialog.warning.visible = true;
            }
            else 
            {
                if (loc5)
                {
                    this.createEvent(loc2, loc3);
                }
            }
            return;
        }

        protected function createErrorHandler(arg1:flash.events.Event):void
        {
            MyLifeInstance.getInstance().debug("Error Creating Event");
            return;
        }

        private function joinCompleteHandler(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;

            MyLifeInstance.getInstance().getZone().removeEventListener(MyLifeEvent.JOIN_ZONE_COMPLETE, joinCompleteHandler);
            loc2 = arg1.eventData.success;
            if (loc2)
            {
                this.viewDialog.btnStartEvent.alpha = 0.5;
                this.hide();
            }
            return;
        }

        protected function eventNameMouseDownHandler(arg1:flash.events.MouseEvent):void
        {
            if (this.startDialog.eventTitle.text == this.DEFAULT_EVENT_NAME)
            {
                this.startDialog.eventTitle.setSelection(0, this.startDialog.eventTitle.length);
            }
            this.startDialog.warning.visible = false;
            return;
        }

        protected function updateRows(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc5 = 0;
            loc2 = 3;
            if (this.eventList.numChildren > loc2)
            {
                loc3 = (loc6 = (loc6 = this.eventList)["getChildAt"](loc2))["getChildAt"](0) as Sprite;
                if (loc5 = loc3.numChildren)
                {
                    this.eventList.removeEventListener(Event.ENTER_FRAME, updateRows);
                    while (loc5--) 
                    {
                        loc4 = loc3.getChildAt(loc5) as CellRenderer;
                        loc4.useHandCursor = loc6 = true;
                        loc4.buttonMode = loc6;
                        loc4.setStyle("upSkin", CellRenderer_upSkinA);
                    }
                }
            }
            return;
        }

        protected function iDOfCategory(arg1:String):int
        {
            var loc2:*;

            loc2 = this.categories.indexOf(arg1);
            return loc2;
        }

        public function hide():void
        {
            this.visible = false;
            return;
        }

        protected function itemClickHandler(arg1:fl.events.ListEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.item;
            loc3 = loc2.data;
            this.joinEvent(loc3);
            return;
        }

        public function getLocale():String
        {
            return MyLifeInstance.getInstance().getPlayer()._locale;
        }

        protected function getPlayerId():*
        {
            return MyLifeInstance.getInstance().getPlayer()._playerId;
        }

        protected function confirmGoHomeDialogHandler(arg1:MyLife.MyLifeEvent):void
        {
            if (arg1.eventData.userResponse == "BTN_YES")
            {
                this.viewDialog.btnStartEvent.alpha = 1;
                MyLifeInstance.getInstance().getZone().onDoGoHome();
            }
            return;
        }

        protected function loadDataFromServer():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc1 = MyLifeInstance.getInstance().myLifeConfiguration;
            loc2 = new URLVariables();
            loc2.category = this.currentCategoryId;
            loc2.locale = getLocale();
            loc2.pid = MyLifeInstance.getInstance().getPlayer()._playerId;
            loc2.instance = getCurrentInstanceId();
            loc2.server = loc1.variables["querystring"]["defaultServer"];
            loc2.age = MyLifeInstance.getInstance().getPlayer().age || 100;
            loc3 = MyLifeInstance.getInstance().getZone().getApartmentOwnerPlayerId();
            loc5 = (loc4 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_events_server"]) + "events.php?action=load&pid=" + loc3 + "&r=" + Math.random();
            trace("loadDataFromServer url = " + loc5);
            (loc6 = new URLRequest(loc5)).method = URLRequestMethod.POST;
            loc6.data = loc2;
            (loc7 = new URLLoader()).addEventListener(Event.COMPLETE, loadDataCompleteHandler);
            loc7.addEventListener(IOErrorEvent.IO_ERROR, loadDataIOErrorHandler);
            loc7.load(loc6);
            return;
        }

        protected function cancelCreateClickHandler(arg1:flash.events.Event=null):void
        {
            if (this.mode != "edit")
            {
                this.showDialog("viewDialog");
            }
            else 
            {
                this.hide();
            }
            return;
        }

        protected function makeComboBox():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = null;
            loc3 = NaN;
            loc4 = null;
            loc5 = 0;
            loc6 = 0;
            combobox = new ComboBox2();
            combobox.x = 76;
            combobox.y = 198;
            combobox.width = 200;
            combobox.height = 22;
            addChild(combobox);
            combobox.rowCount = 6;
            loc1 = MyLifeInstance.getInstance().myLifeConfiguration.variables["eventCategory"];
            this.categories = [];
            loc7 = 0;
            loc8 = loc1;
            for (loc2 in loc8)
            {
                loc3 = Number(loc2);
                loc4 = loc1[loc2];
                this.categories[loc3] = loc4;
            }
            loc5 = categories.length;
            loc6 = 0;
            while (loc6 < loc5) 
            {
                loc4 = categories[loc6];
                this.combobox.addItem({"label":loc4 || ""});
                ++loc6;
            }
            this.currentCategoryId = 0;
            return;
        }

        protected function itemRollOutHandler(arg1:fl.events.ListEvent):void
        {
            this.description.visible = false;
            return;
        }

        private function confirmUnlockDialogResponse(arg1:MyLife.MyLifeEvent):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (arg1.eventData.userResponse != "BTN_YES")
            {
                this.cancelCreateClickHandler();
            }
            else 
            {
                MyLifeInstance.getInstance().getInterface().interfaceHUD.toggleHomeLock();
                loc2 = arg1.eventData.metaData.title;
                loc3 = arg1.eventData.metaData.description;
                this.createEvent(loc2, loc3);
            }
            return;
        }

        protected function makeListeners():void
        {
            this.cancelWindowButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler, false, 0, true);
            this.combobox.addEventListener(Event.CHANGE, comboBoxChangeHandler, false, 0, true);
            this.combobox.addEventListener(Event.OPEN, comboBoxOpenHandler, false, 0, true);
            this.combobox.addEventListener(Event.CLOSE, comboBoxCloseHandler, false, 0, true);
            this.eventList.addEventListener(ListEvent.ITEM_ROLL_OUT, itemRollOutHandler, false, 0, true);
            this.eventList.addEventListener(ListEvent.ITEM_ROLL_OVER, itemRollOverHandler, false, 0, true);
            this.eventList.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler, false, 0, true);
            this.viewDialog.btnStartEvent.addEventListener(MouseEvent.CLICK, startEventClickHandler, false, 0, true);
            this.startDialog.btnCreate.addEventListener(MouseEvent.CLICK, createClickHandler, false, 0, true);
            this.startDialog.btnCancel.addEventListener(MouseEvent.CLICK, cancelCreateClickHandler, false, 0, true);
            this.startDialog.eventTitle.addEventListener(MouseEvent.MOUSE_DOWN, eventNameMouseDownHandler, false, 0, true);
            this.startDialog.eventDescription.addEventListener(MouseEvent.MOUSE_DOWN, eventDescriptionMouseDownHandler, false, 0, true);
            this.startDialog.premiumInfoButton.addEventListener(MouseEvent.MOUSE_OVER, premiumInfoButtonHandler, false, 0, true);
            this.startDialog.premiumInfoButton.addEventListener(MouseEvent.MOUSE_OUT, premiumInfoButtonHandler, false, 0, true);
            this.createTimer.addEventListener(TimerEvent.TIMER_COMPLETE, createTimerComplete, false, 0, true);
            return;
        }

        public function activate(arg1:String="viewDialog", arg2:Object=null):void
        {
            var loc3:*;

            this.mode = arg1;
            if (this.mode != "edit")
            {
                this.showDialog("viewDialog");
                this.loadDataFromServer();
                this.combobox.mouseChildren = loc3 = true;
                this.combobox.mouseEnabled = loc3;
            }
            else 
            {
                this.showDialog("startDialog");
                arg2 = arg2 || {};
                this.startDialog.eventTitle.text = arg2.title;
                this.startDialog.eventDescription.text = arg2.desc;
                this.combobox.selectedIndex = Number(arg2.category);
                this.combobox.mouseChildren = loc3 = false;
                this.combobox.mouseEnabled = loc3;
            }
            this.show();
            return;
        }

        protected function makeTimer():void
        {
            this.createTimer = new Timer(this.CREATE_TIME_LIMIT);
            this.createAvailable = true;
            return;
        }

        public function deactivate():void
        {
            this.hide();
            return;
        }

        public function createEvent(arg1:String, arg2:String):void
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

            loc4 = undefined;
            loc5 = undefined;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            loc11 = null;
            loc12 = null;
            loc3 = MyLifeInstance.getInstance().getInterface().interfaceHUD.homeIsLocked;
            if (loc3)
            {
                (loc4 = MyLifeInstance.getInstance()._interface.showInterface("GenericDialog", {"title":"Event Creation Confirmation", "message":"Creating an event will automatically unlock your home. Proceed with creating event?", "metaData":{"title":arg1, "description":arg2}, "buttons":[{"name":"Cancel", "value":"BTN_NO"}, {"name":"Ok", "value":"BTN_YES"}]})).addEventListener(MyLifeEvent.DIALOG_RESPONSE, confirmUnlockDialogResponse);
            }
            else 
            {
                if (this.createAvailable)
                {
                    loc5 = MyLifeInstance.getInstance().myLifeConfiguration;
                    loc6 = {};
                    this.lastEventData = {};
                    this.lastEventData.category = loc13 = this.currentCategoryId;
                    loc6.category = loc13;
                    this.lastEventData.title = loc13 = arg1;
                    loc6.title = loc13;
                    this.lastEventData.desc = loc13 = arg2;
                    loc6.desc = loc13;
                    this.lastEventData.pid = loc13 = this.getPlayerId();
                    loc6.pid = loc13;
                    this.lastEventData.instance = loc13 = this.getCurrentInstanceId();
                    loc6.instance = loc13;
                    MyLifeInstance.getInstance().getZone()._myEventData = loc6;
                    (loc7 = new URLVariables()).category = this.lastEventData.category;
                    loc7.title = this.lastEventData.title;
                    loc7.desc = this.lastEventData.desc;
                    loc7.pid = this.lastEventData.pid;
                    if (MyLifeInstance.getInstance().zone.homeData && MyLifeInstance.getInstance().zone.homeData.homeId)
                    {
                        loc7.playerHomeId = MyLifeInstance.getInstance().zone.homeData.homeId;
                    }
                    else 
                    {
                        loc7.playerHomeId = 0;
                    }
                    loc7.instance = this.lastEventData.instance;
                    loc7.locale = getLocale();
                    loc7.premium = this.startDialog.cbContainer.premium.selected ? 1 : 0;
                    loc7.lk = loc5.variables["querystring"]["lk"];
                    loc7.server = loc5.variables["querystring"]["defaultServer"];
                    loc7.age = MyLifeInstance.getInstance().getPlayer().age || 100;
                    loc9 = (loc8 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_events_server"]) + "events.php?action=create&r=" + Math.random();
                    (loc10 = new URLRequest(loc9)).method = URLRequestMethod.POST;
                    loc10.data = loc7;
                    (loc11 = new URLLoader()).addEventListener(Event.COMPLETE, createCompleteHandler);
                    loc11.addEventListener(IOErrorEvent.IO_ERROR, createErrorHandler);
                    loc11.load(loc10);
                    this.createAvailable = false;
                    this.createTimer.reset();
                    this.createTimer.start();
                }
                else 
                {
                    loc12 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":"Event Not Created", "message":"New events can only be created or edited every five minutes. Please try again later.", "metaData":{}, "buttons":[{"name":"Ok", "value":""}]});
                }
            }
            return;
        }

        protected var MAX_EVENTS:int=40;

        protected var DEFAULT_EVENT_NAME:String="Event Name...";

        public var currentCategoryId:int;

        protected var events:Array;

        protected var currentDialog:flash.display.MovieClip;

        protected var categories:Array;

        protected var createTimer:flash.utils.Timer;

        public var mode:String;

        public var createAvailable:Boolean;

        public var startDialog:flash.display.MovieClip;

        protected var CREATE_TIME_LIMIT:*=300000;

        public var viewDialog:flash.display.MovieClip;

        protected var eventList:fl.controls.List;

        public var cancelWindowButton:flash.display.SimpleButton;

        public var lastEventData:Object;

        protected var DEFAULT_EVENT_DESCRIPTION:String="Event Description...";

        public var PREMIUM_EVENT_COST:Number=1000;

        protected var description:flash.display.MovieClip;

        public var combobox:MyLife.Components.ComboBox2;
    }
}
