package MyLife.Events 
{
    import flash.events.*;
    
    public class GameManagerEvent extends flash.events.Event
    {
        public function GameManagerEvent(arg1:String, arg2:Object=null, arg3:Boolean=false, arg4:Boolean=false)
        {
            this.data = arg2 || {};
            super(arg1, arg3, arg4);
            return;
        }

        public static const REGISTER_BET_COMPLETE:String="registerBetComplete";

        public static const REGISTER_GAME_RESULT_COMPLETE:String="registerGameResultComplete";

        public static const GAME_EXIT:String="gameExit";

        public static const USE_ITEM_COMPLETE:String="MLE_USE_ITEM_REPONSE";

        public static const STORE_DIALOG_COMPLETE:String="storeDialogComplete";

        public static const INVENTORY_CHANGE:String="gameManagerEventInventoryChange";

        public static const GAME_START:String="gameStart";

        public static const GET_GAME_LIMITS_COMPLETE:String="getGameLimitsComplete";

        public var data:Object;
    }
}
