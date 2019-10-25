package MyLife.Games 
{
    import MyLife.*;
    import MyLife.Events.*;
    import flash.events.*;
    
    public class GameManager extends flash.events.EventDispatcher
    {
        public function GameManager()
        {
            super();
            if (!GameManager._instance)
            {
                this.init();
            }
            return;
        }

        private function init():void
        {
            GameManager._instance = this;
            return;
        }

        private function getGameLimitsCompleteHandler(arg1:MyLife.Events.GameManagerEvent):void
        {
            var loc2:*;

            loc2 = undefined;
            trace("getGameLimitsCompleteHandler()");
            if (isServerAvailable)
            {
                loc2 = MyLifeInstance.getInstance().getServer();
                loc2.removeEventListener(GameManagerEvent.GET_GAME_LIMITS_COMPLETE, instance.getGameLimitsCompleteHandler);
            }
            dispatchGameManagerEvent(GameManagerEvent.GET_GAME_LIMITS_COMPLETE, arg1.data);
            return;
        }

        private function registerBetCompleteHandler(arg1:MyLife.Events.GameManagerEvent):void
        {
            var loc2:*;

            loc2 = undefined;
            if (isServerAvailable)
            {
                loc2 = MyLifeInstance.getInstance().getServer();
                loc2.removeEventListener(GameManagerEvent.REGISTER_BET_COMPLETE, instance.registerBetCompleteHandler);
            }
            dispatchGameManagerEvent(GameManagerEvent.REGISTER_BET_COMPLETE, arg1.data);
            return;
        }

        private function useItemCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = undefined;
            if (isServerAvailable)
            {
                loc3 = MyLifeInstance.getInstance().getServer();
                loc3.removeEventListener(GameManagerEvent.USE_ITEM_COMPLETE, useItemCompleteHandler);
            }
            loc2 = {};
            if (arg1.hasOwnProperty("eventData"))
            {
                loc2 = arg1["eventData"];
            }
            dispatchGameManagerEvent(GameManagerEvent.USE_ITEM_COMPLETE, loc2);
            return;
        }

        private function storeDialogCompleteHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.target;
            loc2.removeEventListener(StoreEvent.DIALOG_COMPLETE, storeDialogCompleteHandler);
            loc3 = {};
            if (arg1.hasOwnProperty("data"))
            {
                loc3 = arg1["data"];
            }
            dispatchGameManagerEvent(GameManagerEvent.STORE_DIALOG_COMPLETE, loc3);
            return;
        }

        private function dispatchGameManagerEvent(arg1:String, arg2:Object=null):void
        {
            var loc3:*;

            arg2 = arg2 || {};
            loc3 = new GameManagerEvent(arg1, arg2);
            dispatchEvent(loc3);
            return;
        }

        private function registerGameResultCompleteHandler(arg1:MyLife.Events.GameManagerEvent):void
        {
            var loc2:*;

            loc2 = undefined;
            if (isServerAvailable)
            {
                loc2 = MyLifeInstance.getInstance().getServer();
                loc2.removeEventListener(GameManagerEvent.REGISTER_GAME_RESULT_COMPLETE, instance.registerGameResultCompleteHandler);
            }
            dispatchGameManagerEvent(GameManagerEvent.REGISTER_GAME_RESULT_COMPLETE, arg1.data);
            return;
        }

        public static function getGameLimits(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = null;
            loc3 = undefined;
            loc4 = null;
            loc5 = null;
            if (isServerAvailable)
            {
                loc2 = {};
                loc2.gameType = arg1;
                loc3 = MyLifeInstance.getInstance().getServer();
                loc3.addEventListener(GameManagerEvent.GET_GAME_LIMITS_COMPLETE, instance.getGameLimitsCompleteHandler, false, 0, true);
                loc3.callExtension("GameManager.getGameLimits", loc2);
            }
            else 
            {
                trace("FAKED: getGameLimits(" + arg1 + ")");
                (loc4 = {}).remainingCoins = 100;
                loc4.remainingRewards = 1;
                loc4.nextReset = 0;
                loc5 = new GameManagerEvent(GameManagerEvent.GET_GAME_LIMITS_COMPLETE, loc4);
                instance.getGameLimitsCompleteHandler(loc5);
            }
            return;
        }

        public static function getInventoryNotInUse(arg1:Number=0, arg2:Number=0):Array
        {
            var loc3:*;

            loc3 = [];
            if (InventoryManager.ready)
            {
                loc3 = InventoryManager.getInstance().getInventoryNotInUse(arg1, arg2);
            }
            return loc3;
        }

        public static function openStoreDialog(arg1:int):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = undefined;
            loc3 = null;
            if (MyLifeInstance.getInstance().hasOwnProperty("getInterface"))
            {
                loc2 = MyLifeInstance.getInstance().getInterface().showInterface("ViewStoreInventory", {"storeId":arg1});
                loc2.addEventListener(StoreEvent.DIALOG_COMPLETE, instance.storeDialogCompleteHandler);
            }
            else 
            {
                trace("FAKED: openStoreDialog(" + arg1 + ")");
                loc3 = {};
                loc3.storeId = arg1;
                instance.dispatchGameManagerEvent(GameManagerEvent.STORE_DIALOG_COMPLETE, loc3);
            }
            return;
        }

        public static function start():void
        {
            _instance.dispatchEvent(new GameManagerEvent(GameManagerEvent.GAME_START));
            return;
        }

        private static function dispatchGameExit(arg1:flash.events.Event):void
        {
            MyLifeInstance.getInstance().removeEventListener(MyLifeEvent.JOIN_ROOM_COMPLETE, dispatchGameExit);
            _instance.dispatchEvent(new GameManagerEvent(GameManagerEvent.GAME_EXIT));
            return;
        }

        public static function getPlayerCoins():Number
        {
            var loc1:*;

            loc1 = NaN;
            if (MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
            {
                loc1 = MyLifeInstance.getInstance().getPlayer().getCoinBalance();
            }
            else 
            {
                loc1 = 50;
                trace("FAKED: getPlayerCoins() return " + loc1);
            }
            return loc1;
        }

        public static function registerBet(arg1:Number, arg2:Number, arg3:Number=2):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = undefined;
            loc6 = NaN;
            loc7 = null;
            loc8 = null;
            if (isServerAvailable)
            {
                (loc4 = {}).gameType = arg1;
                loc4.betAmount = arg2;
                (loc5 = MyLifeInstance.getInstance().getServer()).addEventListener(GameManagerEvent.REGISTER_BET_COMPLETE, instance.registerBetCompleteHandler, false, 0, true);
                loc5.callExtension("GameManager.registerBet", loc4);
            }
            else 
            {
                trace("FAKED: registerBet(" + arg1 + "," + arg2 + "," + arg3 + ")");
                loc6 = 1;
                trace("", "win = " + loc6);
                loc7 = {"win":loc6};
                loc8 = new GameManagerEvent(GameManagerEvent.REGISTER_BET_COMPLETE, loc7);
                instance.registerBetCompleteHandler(loc8);
            }
            return;
        }

        public static function showGenericDialog(arg1:String="", arg2:String="", arg3:String="", arg4:Object=null):Object
        {
            var loc5:*;

            loc5 = null;
            if (MyLifeInstance.getInstance().hasOwnProperty("getInterface"))
            {
                loc5 = MyLifeInstance.getInstance().getInterface().showInterface("GenericDialog", {"title":arg1, "message":arg2, "icon":arg3, "metaData":arg4});
            }
            else 
            {
                loc5 = {};
                trace("GameManager.showGenericDialog not available");
            }
            return loc5;
        }

        public static function registerGameResult(arg1:Number, arg2:Number, arg3:Number=0):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc4 = null;
            loc5 = undefined;
            loc6 = NaN;
            loc7 = NaN;
            loc8 = NaN;
            loc9 = null;
            loc10 = null;
            if (isServerAvailable)
            {
                (loc4 = {}).gameType = arg1;
                loc4.result = arg2;
                loc4.bonusScore = arg3;
                (loc5 = MyLifeInstance.getInstance().getServer()).addEventListener(GameManagerEvent.REGISTER_GAME_RESULT_COMPLETE, instance.registerGameResultCompleteHandler, false, 0, true);
                loc5.callExtension("GameManager.registerGameResult", loc4);
            }
            else 
            {
                trace("FAKED: registerGameResult(" + arg1 + "," + arg2 + "," + arg3 + ")");
                loc6 = 10;
                loc7 = arg3;
                loc8 = loc6 + loc7;
                loc9 = {"coins":loc8, "balance":loc8};
                loc10 = new GameManagerEvent(GameManagerEvent.REGISTER_GAME_RESULT_COMPLETE, loc9);
                instance.registerGameResultCompleteHandler(loc10);
            }
            return;
        }

        public static function sendNotification(arg1:int, arg2:Number, arg3:Boolean=false, arg4:*=null, arg5:String=""):void
        {
            var loc6:*;

            loc6 = undefined;
            if (isServerAvailable)
            {
                (loc6 = MyLifeInstance.getInstance().getServer()).sendNotification(arg1, arg2, arg3, arg4, arg5);
            }
            else 
            {
                trace("FAKED: sendNotification(" + arg1 + "," + arg2 + "," + arg3 + "," + arg4 + "," + arg5 + ")");
            }
            return;
        }

        public static function get instance():MyLife.Games.GameManager
        {
            if (!GameManager._instance)
            {
                new GameManager();
            }
            return GameManager._instance;
        }

        public static function setFlashVar(arg1:String, arg2:*):void
        {
            var loc3:*;
            var loc4:*;

            loc3 = null;
            if (MyLifeInstance.getInstance().hasOwnProperty("myLifeConfiguration"))
            {
                MyLifeInstance.getInstance()["myLifeConfiguration"].variables["querystring"][arg1] = loc4 = arg2;
                loc3 = loc4;
            }
            else 
            {
                trace("FAKED: setQueryStringHash()");
            }
            return;
        }

        public static function useItem(arg1:int):void
        {
            var loc2:*;

            loc2 = null;
            if (isServerAvailable)
            {
                if (MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
                {
                    MyLifeInstance.getInstance().getPlayer().showUseDialog = false;
                }
                MyLifeInstance.getInstance().getServer().addEventListener(GameManagerEvent.USE_ITEM_COMPLETE, instance.useItemCompleteHandler);
                MyLifeInstance.getInstance().getServer().callExtension("useItem", {"inventoryId":arg1});
            }
            else 
            {
                trace("FAKED: useItem(" + arg1 + ")");
                loc2 = {};
                loc2.success = true;
                loc2.usedPlayerItemId = arg1;
                instance.dispatchGameManagerEvent(GameManagerEvent.USE_ITEM_COMPLETE, loc2);
            }
            return;
        }

        public static function getFlashVarHash():Object
        {
            var loc1:*;

            loc1 = null;
            if (MyLifeInstance.getInstance().hasOwnProperty("myLifeConfiguration"))
            {
                loc1 = MyLifeInstance.getInstance()["myLifeConfiguration"].variables["querystring"];
            }
            else 
            {
                trace("FAKED: getQueryStringHash()");
                loc1 = {};
            }
            return loc1;
        }

        private static function get isServerAvailable():Boolean
        {
            return MyLifeInstance.getInstance().hasOwnProperty("getServer");
        }

        public static function getInventoryByCategory(arg1:Number=0):Array
        {
            var loc2:*;

            loc2 = [];
            if (MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
            {
                loc2 = MyLifeInstance.getInstance().getPlayer().getPlayerInventory(arg1);
            }
            return loc2;
        }

        public static function exit(arg1:String, arg2:int=0):void
        {
            if (MyLifeInstance.getInstance().hasOwnProperty("getZone"))
            {
                MyLifeInstance.getInstance().getZone().join(arg1, arg2);
            }
            else 
            {
                trace("FAKED: GAME EXITED");
            }
            MyLifeInstance.getInstance().addEventListener(MyLifeEvent.JOIN_ROOM_COMPLETE, dispatchGameExit);
            return;
        }

        public static function setPlayerCoins(arg1:Number):void
        {
            if (MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
            {
                MyLifeInstance.getInstance().getPlayer().setCoinBalance(arg1);
            }
            else 
            {
                trace("FAKED: setPlayerCoins(" + arg1 + ")");
            }
            return;
        }

        private static var _instance:MyLife.Games.GameManager;
    }
}
