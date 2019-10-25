package MyLife 
{
    import flash.events.*;
    
    public class MyLifeEvent extends flash.events.Event
    {
        public function MyLifeEvent(arg1:String, arg2:Object=null, arg3:Boolean=true)
        {
            this._type = arg1;
            this._bubble = arg3;
            this.eventData = arg2;
            super(arg1, arg3);
            return;
        }

        public override function clone():flash.events.Event
        {
            return new MyLifeEvent(this._type, this.eventData, this._bubble);
        }

        public static const TRIGGER_WALK:String="MLE_TRIGGER_WALK";

        public static const EDIT_ITEM_ROTATION_UPDATED:String="MLE_EDIT_ITEM_ROTATION_UPDATED";

        public static const JOIN_ZONE_COMPLETE:String="MLE_JOIN_ZONE_COMPLETE";

        public static const PLAY_ANIMATION:String="MLE_PLAY_ANIMATION";

        public static const INTERFACE_LOW_PRIORITY_DIALOG_READY:String="MLE_INTERFACE_LOW_PRIORITY_DIALOG_READY";

        public static const ASSET_LOAD_ERROR:String="MLE_ASSET_LOAD_ERROR";

        public static const DO_GO_HOME:String="MLE_DO_GO_HOME";

        public static const BADGE_CLICK_EVENT:String="MLE_BADGE_CLICK_EVENT";

        public static const DO_SHOW_MAP:String="MLE_DO_SHOW_MAP";

        public static const NEXT_MISSION:String="MLE_NEXT_MISSION";

        public static const SEND_MESSAGE:String="MLE_SEND_MESSAGE";

        public static const ROOM_LEAVE:String="MLE_ROOM_LEAVE";

        public static const LEVELING_ITEM_REPLACE:String="MLE_LEVELING_ITEM_REPLACE";

        public static const PLAYER_SELECTED:String="MLE_PLAYER_SELECTED";

        public static const SPECIALITEM_GETDATA2_COMPLETE:String="MLE_SPECIALITEM_GETDATA2_COMPLETE";

        public static const BUY_CREW_COMPLETE:String="MLE_BUY_CREW_COMPLETE";

        public static const BADGE_INFO_BOX_LOADING_COMPLETE:String="MLE_BADGE_INFO_BOX_LOADING_COMPLETE";

        public static const GET_PLAYER_BADGE_LIST_COMPLETE:String="MLE_GET_PLAYER_BADGE_LIST_COMPLETE";

        public static const GET_ACTIONS_COMPLETE:String="MLE_GET_ACTIONS_COMPLETE";

        public static const BADGE_MANAGER_INITIALIZED:String="MLE_BADGE_MANAGER_INITIALIZED";

        public static const UPDATE_GIFT_COUNT:String="MLE_UPDATE_GIFT_COUNT";

        public static const EXTENSION_RESPONSE:String="MLE_EXTENSION_RESPONSE";

        public static const GET_DEFAULT_HOME_DATA_COMPLETE:String="MLE_GET_DEFAULT_HOME_DATA_COMPLETE";

        public static const SEND_ACTION_COMPLETE:String="MLE_SEND_ACTION_COMPLETE";

        public static const CHARACTER_ACTION_START:String="MLE_CHARACTER_ACTION_START";

        public static const GIFT_RESPONSE:String="MLE_GIFT_RESPONSE";

        public static const INTERFACE_DELAYED_DIALOG_DONE:String="MLE_INTERFACE_DELAYED_DIALOG_DONE";

        public static const MENU_ACTIONS_ACTIVATING:String="MLE_MENU_ACTIONS_ACTIVATING";

        public static const PLAYER_SPEED_UPDATE:String="MLE_PLAYER_SPEED_UPDATE";

        public static const TRIGGER_WALK_OUT:String="MLE_TRIGGER_WALK_OUT";

        public static const NOTIFICATION_SUCCESS:String="MLE_NOTIFICATION_SUCCESS";

        public static const ENGAGE_MISSION:String="MLE_ENGAGE_MISSION";

        public static const WHATS_NEW_UPDATE:String="MLE_NEWS_UPDATE";

        public static const ASSET_LOAD_SUCCESS:String="MLE_ASSET_LOAD_COMPLETE";

        public static const MESSAGE_COUNT:String="MLE_MESSAGE_COUNT";

        public static const PLAYER_WATERBALLOON_START:String="MLE_PLAYER_WATERBALLOON_START";

        public static const GET_PLAYER_HOMES_COMPLETE:String="MLE_GET_PLAYER_HOMES_COMPLETE";

        public static const ENABLING_EDIT_MODE:String="MLE_ENABLING_EDIT_MODE";

        public static const INTERFACE_DIALOG_OPEN:String="MLE_INTERFACE_DIALOG_OPEN";

        public static const EDIT_ITEM_POSITION_UPDATED:String="MLE_EDIT_ITEM_POSITION_UPDATED";

        public static const UPDATE_ENERGY:String="MLE_UPDATE_ENERGY";

        public static const GET_STATUS_SUCCESS:String="MLE_GET_STATUS_SUCCESS";

        public static const LOADING_DONE:String="MLE_LOADING_DONE";

        public static const WINDOW_CLOSE:String="MLE_WINDOW_CLOSE";

        public static const ASK_FOR_WELCOME:String="MLE_ASK_FOR_WELCOME_COMPLETE";

        public static const INTERFACE_DIALOG_QUEUE_EMPTY:String="MLE_INTERFACE_DIALOG_QUEUE_EMPTY";

        public static const ROOM_VARS_UPDATE:String="MLE_ROOM_VARS_UPDATE";

        public static const SAVE_ROOM_COMPLETE:String="MLE_SAVE_ROOM_COMPLETE";

        public static const TRADE_RESPONSE:String="MLE_TRADE_RESPONSE";

        public static const SEND_THANK_YOU_GIFT:String="MLE_SEND_THANK_YOU_GIFT";

        public static const ACTION_TWEEN_EVENT_RECEIVED:String="MLE_ACTION_TWEEN_EVENT_RECEIVED";

        public static const DO_EARN_COINS:String="MLE_DO_EARN_COINS";

        public static const SCRATCHER_DATA_COMPLETE:String="MLE_SCRATCHER_DATA_COMPLETE";

        public static const ROUND_TRIP_COMPLETE:String="MLE_ROUND_TRIP_COMPLETE";

        public static const ASYNC_AVATAR_LOADED:String="MLE_ASYNC_AVATAR_LOADED";

        public static const DISPLAY_BADGE_UPDATED:String="MLE_DISPLAY_BADGE_UPDATED";

        public static const COLOR_PICKER:String="MLE_COLOR_PICKER";

        public static const PROGRESS_COMPLETE:String="MLE_PROGRESS_COMPLETE";

        public static const INTERFACE_DELAYED_DIALOG_READY:String="INTERFACE_DELAYED_DIALOG_READY";

        public static const USE_ITEM_RESPONSE:String="MLE_USE_ITEM_REPONSE";

        public static const USER_JOIN:String="MLE_USER_JOIN";

        public static const USER_LEAVE:String="MLE_USER_LEAVE";

        public static const BUDDYLIST_UPDATE:String="MLE_BUDDYLIST_UPDATE";

        public static const PLAYER_LOADED:String="MLE_PLAYER_LOADED";

        public static const GAME_REGISTER_RESULT_COMPLETE:String="MLE_GAME_REGISTER_RESULT_COMPLETE";

        public static const OPEN_ACTION_COMPLETE:String="MLE_OPEN_ACTION_COMPLETE";

        public static const LOADING_EDIT_DONE:String="MLE_LOADING_EDIT_DONE";

        public static const PLAYER_STARTMOVE:String="MLE_PLAYER_STARTMOVE";

        public static const PLAYER_LIST:String="MLE_PLAYER_LIST";

        public static const PLAYER_APARTMENT_COUNT_UPDATE:String="MLE_PLAYER_APARTMENT_COUNT_UPDATE";

        public static const UPDATE_BALANCE:String="MLE_UPDATE_BALANCE";

        public static const ROOM_RATING_UPDATE:String="MLE_ROOM_RATING_UPDATE";

        public static const MAIN_TEST:String="MLE_MAIN_TEST";

        public static const DIALOG_RESPONSE:String="MLE_DIALOG_RESPONSE";

        public static const PLAYER_ASSETS_LOADED:String="MLE_PLAYER_ASSETS_LOADED";

        public static const SPECIALITEM_GETDATA_COMPLETE:String="MLE_SPECIALITEM_GETDATA_COMPLETE";

        public static const GET_BADGE_LIST_COMPLETE:String="MLE_GET_BADGE_LIST_COMPLETE";

        public static const PLAYER_ENERGY_UPDATE:String="MLE_PLAYER_ENERGY_UPDATE";

        public static const DO_CHANGE_CLOTHING:String="MLE_DO_CHANGE_CLOTHING";

        public static const EDIT_ITEM_START_DRAG:String="MLE_EDIT_ITEM_START_DRAG";

        public static const PLAYER_WATERBALLOON_COMPLETE:String="MLE_PLAYER_WATERBALLOON_COMPLETE";

        public static const USE_FOOD_ITEM:String="MLE_USE_FOOD_ITEM";

        public static const NOTIFICATION_ERROR:String="MLE_NOTIFICATION_ERROR";

        public static const DO_CHANGE_APPEARANCE:String="MLE_DO_CHANGE_APPEARANCE";

        public static const JOIN_ZONE:String="MLE_JOIN_ZONE";

        public static const START_NEW_ITEM_DRAG:String="MLE_START_NEW_ITEM_DRAG";

        public static const FB_ADD_ITEM_TO_STORY:String="MLE_FB_ADD_ITEM_TO_STORY";

        public static const CONTEXT_ITEM:String="MLE_CONTEXT_ITEM";

        public static const GET_STATUS_ERROR:String="MLE_GET_STATUS_ERROR";

        public static const JOIN_ROOM_COMPLETE:String="MLE_JOIN_ROOM_COMPLETE";

        public static const INTERFACE_LOAD_COMPLETE:String="MLE_INTERFACE_LOAD_COMPLETE";

        public static const SERVER_CONNECT:String="MLE_SERVER_CONNECT";

        public static const START_GAME:String="MLE_START_GAME";

        public static const PLAYER_ACTIVATED:String="MLE_PLAYER_ACTIVATED";

        public static const TRADE_COMPLETE:String="MLE_TRADE_COMPLETE";

        public static const JOIN_SUCCESS:String="MLE_JOIN_SUCCESS";

        public static const PLAYER_DRINKS_UPDATE:String="MLE_PLAYER_DRINKS_UPDATE";

        public static const PET_FEED_EVENT:String="MLE_PET_FEED_EVENT";

        public static const CHARACTER_MOVED:String="MLE_CHARACTER_MOVED";

        public static const GET_APARTMENT_LOCKED_COMPLETE:String="MLE_GET_APARTMENT_LOCKED_COMPLETE";

        public static const FB_PUBLISH_SHORT_STORY:String="MLE_FB_PUBLISH_SHORT_STORY";

        public static const SAVE_ROOM_START:String="MLE_SAVE_ROOM_START";

        public static const BADGE_EARNED_EVENT:String="MLE_BADGE_EARNED_EVENT";

        public static const BUY_COINS_COMPLETE:String="MLE_BUY_COINS_COMPLETE";

        public static const LOADING_PROGRESS:String="MLE_LOADING_PROGRESS";

        public static const CHARACTER_ACTION_COMPLETE:String="MLE_CHARACTER_ACTION_COMPLETE";

        public static const EDIT_ITEM_STOP_DRAG:String="MLE_EDIT_ITEM_STOP_DRAG";

        public static const IGNORE_MISSION:String="MLE_IGNORE_MISSION";

        public var eventData:Object;

        private var _type:String;

        private var _bubble:Boolean;
    }
}
