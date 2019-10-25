package MyLife 
{
    import MyLife.Events.*;
    import MyLife.Structures.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class FriendDataManager extends flash.events.EventDispatcher
    {
        public function FriendDataManager(arg1:Boolean=false)
        {
            super();
            if (!arg1)
            {
                this.init();
            }
            return;
        }

        private function buildRequest(arg1:String):flash.net.URLRequest
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

            loc3 = null;
            loc10 = null;
            loc11 = null;
            loc2 = new URLRequest();
            loc5 = (loc4 = MyLifeInstance.getInstance().myLifeConfiguration).platformType;
            loc6 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["game_control_server"];
            loc7 = "";
            loc8 = new RegExp("fb", "g");
            if (loc5 != "platformFacebook")
            {
                if (loc5 != "platformMySpace")
                {
                    if (loc5 == MyLifeConfiguration.getInstance().PLATFORM_TAGGED)
                    {
                        loc7 = loc7 + "&" + MyLifeConfiguration.networkCredentials;
                        loc6 = loc6.replace(loc8, "tg");
                    }
                }
                else 
                {
                    loc10 = loc4.variables["querystring"]["opensocialJSON"];
                    loc11 = loc4.variables["querystring"]["oathJSON"];
                    loc7 = loc7 + "opensocialJSON=" + loc10 + "&oauthJSON=" + loc11;
                    loc6 = loc6.replace(loc8, "ms");
                }
            }
            else 
            {
                loc3 = JSON.decode(loc4.variables["querystring"]["facebookJSON"]);
                loc7 = loc7 + "fb_sig_user=" + loc3.fb_sig_user + "&fb_sig_session_key=" + loc3.fb_sig_session_key;
            }
            loc12 = arg1;
            switch (loc12) 
            {
                case ALLFRIENDS_SCRIPT:
                    break;
            }
            loc9 = loc6 + arg1 + "?";
            loc2.url = loc9 + loc7 + "&r=" + Math.random();
            trace("request " + loc2.url);
            return loc2;
        }

        private function onAppUsersError(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, onAppUsersLoaded);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, onAppUsersError);
            if (!_data)
            {
                _data = {};
            }
            _ready = true;
            instance.dispatchEvent(new Event(EVENT_READY));
            return;
        }

        private function checkAppUser(arg1:Number):Boolean
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = undefined;
            loc2 = false;
            if (_data)
            {
                loc4 = 0;
                loc5 = _data;
                for each (loc3 in loc5)
                {
                    if (!(loc3.facebook_id == arg1 || loc3.myspace_id == arg1))
                    {
                        continue;
                    }
                    loc2 = true;
                    break;
                }
            }
            return loc2;
        }

        private function parseData(arg1:String):void
        {
            var friend:*;
            var friendData:Array;
            var jsonString:String;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            friend = undefined;
            friendData = null;
            jsonString = arg1;
            try
            {
                friendData = JSON.decode(jsonString);
            }
            catch (error:Error)
            {
                _data = {};
            }
            if (!_data)
            {
                _data = {};
            }
            loc3 = 0;
            loc4 = friendData;
            for each (friend in loc4)
            {
                if (!friend.player)
                {
                    continue;
                }
                friend.name = friend.name || "Friend";
                friend.playerId = Number(friend.player);
                setNetworkId(friend);
                _data[friend.playerId] = friend;
            }
            return;
        }

        private function init():void
        {
            var loc1:*;

            loc1 = null;
            if (!_instance)
            {
                FriendDataManager._instance = this;
                loc1 = new URLLoader();
                loc1.addEventListener(Event.COMPLETE, onAppUsersLoaded);
                loc1.addEventListener(IOErrorEvent.IO_ERROR, onAppUsersError);
                loc1.load(buildRequest(XPUSER_SCRIPT));
            }
            return;
        }

        private function onAppUsersLoaded(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.currentTarget as URLLoader;
            trace("app users loaded " + loc2.data);
            parseData(loc2.data);
            if (getFriendDataArray().length || _retries > MAX_RETRIES)
            {
                loc2.removeEventListener(Event.COMPLETE, onAppUsersLoaded);
                loc2.removeEventListener(IOErrorEvent.IO_ERROR, onAppUsersError);
                _ready = true;
                instance.dispatchEvent(new Event(EVENT_READY));
            }
            else 
            {
                _retries++;
                loc2.load(buildRequest(XPUSER_SCRIPT));
            }
            return;
        }

        private function onAllFriendsError(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            loc3 = null;
            loc2 = arg1.currentTarget as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, onAllFriendsLoaded);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, onAllFriendsError);
            if (!_data)
            {
                _data = {};
            }
            while (_callbacks.length) 
            {
                loc3 = _callbacks.pop();
                loc3.callback.call(null, MyLifeUtils.cloneObject(_data), loc3.context);
            }
            _allFriendsLoaded = true;
            return;
        }

        private function onAllFriendsLoaded(arg1:flash.events.Event):void
        {
            var callback:Object;
            var friend:*;
            var friendData:Array;
            var loader:flash.net.URLLoader;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var myLifeConfiguration:*;
            var networkId:Number;
            var pEvent:flash.events.Event;
            var platformType:String;

            myLifeConfiguration = undefined;
            platformType = null;
            friend = undefined;
            networkId = NaN;
            callback = null;
            pEvent = arg1;
            loader = pEvent.currentTarget as URLLoader;
            loader.removeEventListener(Event.COMPLETE, onAllFriendsLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onAllFriendsError);
            if (!_data)
            {
                _data = {};
            }
            friendData = null;
            try
            {
                trace("allFreidnsLoaded " + loader.data);
                friendData = JSON.decode(loader.data);
            }
            catch (e:*)
            {
            };
            if (friendData)
            {
                myLifeConfiguration = MyLifeInstance.getInstance().myLifeConfiguration;
                platformType = myLifeConfiguration.platformType;
                loc3 = 0;
                loc4 = friendData;
                for each (friend in loc4)
                {
                    networkId = (platformType != "platformFacebook") ? friend.myspace_id : friend.facebook_id;
                    if (checkAppUser(networkId))
                    {
                        continue;
                    }
                    friend["playerId"] = (platformType != "platformFacebook") ? "mysp_" + networkId : "fbid_" + networkId;
                    setNetworkId(friend);
                    _data[friend.playerId] = friend;
                }
            }
            while (_callbacks.length) 
            {
                callback = _callbacks.pop();
                callback.callback.call(null, MyLifeUtils.cloneObject(_data), callback.context);
            }
            _allFriendsLoaded = true;
            return;
        }

        private function setNetworkId(arg1:Object):void
        {
            if (arg1)
            {
                if (arg1["facebook_id"])
                {
                    arg1["network_id"] = arg1["facebook_id"];
                }
                if (arg1["myspace_id"])
                {
                    arg1["network_id"] = arg1["myspace_id"];
                }
            }
            return;
        }

        public static function getPlayerName():String
        {
            return _playerData ? _playerData.name : playerData.name;
        }

        private static function onAvatarLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = arg1.target;
            loc2.doAvatarAction(0);
            loc2.removeEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, onAvatarLoaded);
            loc3 = avatarLoadCallBackHashMap[loc2.name];
            loc4 = loc3.avatarLoadCallBack;
            loc5 = loc3.avatarLoadContext;
            loc6 = loc3.scale;
            delete avatarLoadCallBackHashMap[loc2.name];
            if (loc6)
            {
                loc6 = 0.2 * loc6;
                loc2.width = loc2.width * loc6;
                loc2.height = loc2.height * loc6;
            }
            if (loc4 != null)
            {
                loc4(loc2, loc5);
            }
            return;
        }

        public static function objDataToFriendData(arg1:Object):MyLife.Structures.FriendData
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc2 = new FriendData();
            loc2.playerId = arg1.player;
            loc2.name = arg1.name;
            loc2.firstName = arg1.first_name;
            loc2.lastName = arg1.last_name;
            loc2.clothesData = arg1.clothing;
            loc2.picUrl = arg1.pic_url;
            loc4 = 0;
            loc5 = arg1.clothing;
            for each (loc3 in loc5)
            {
                if (loc3.i != "Body")
                {
                    continue;
                }
                loc2.gender = Number(loc3.gender);
                break;
            }
            return loc2;
        }

        private static function onAvatarHeadLoaded(arg1:MyLife.Events.AvatarLoadEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc2 = arg1.target;
            loc2.doAvatarAction(0);
            loc2.removeEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, onAvatarHeadLoaded);
            loc3 = loc2["avatarClip"]["head"];
            loc3.y = loc9 = 0;
            loc3.x = loc9;
            (loc4 = new MovieClip()).addChild(loc3);
            loc6 = (loc5 = avatarLoadCallBackHashMap[loc2.name]).avatarLoadCallBack;
            loc7 = loc5.avatarLoadContext;
            loc8 = loc5.scale;
            trace("scale " + loc8);
            delete avatarLoadCallBackHashMap[loc2.name];
            if (loc8)
            {
                loc8 = 0.2 * loc8;
                loc3.width = loc3.width * loc8;
                loc3.height = loc3.height * loc8;
                trace("head.height " + loc3.height);
                trace("head.width " + loc3.width);
            }
            if (loc6 != null)
            {
                loc6(loc3, loc7);
            }
            return;
        }

        public static function get instance():MyLife.FriendDataManager
        {
            if (!FriendDataManager._instance)
            {
                new FriendDataManager();
            }
            return _instance;
        }

        public static function set playerData(arg1:MyLife.Structures.PlayerData):void
        {
            _playerData = arg1;
            return;
        }

        public static function getDefinedInstance(arg1:String):MyLife.FriendDataManager
        {
            var loc2:*;

            loc2 = true;
            _instance = new FriendDataManager(loc2);
            _instance.parseData(arg1);
            return _instance;
        }

        public static function getPlayerId():Number
        {
            return _playerData ? _playerData.playerId : playerData.playerId;
        }

        public static function getXPFriendData(arg1:Number=0, arg2:Boolean=false):Object
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = null;
            loc6 = undefined;
            loc7 = null;
            loc3 = null;
            loc4 = (arg1 > 0) ? String(arg1) : null;
            if (_data)
            {
                if (loc4)
                {
                    if (_data[loc4])
                    {
                        loc3 = MyLifeUtils.cloneObject(_data[loc4]);
                    }
                }
                else 
                {
                    loc5 = arg2 ? [] : {};
                    loc8 = 0;
                    loc9 = _data;
                    for (loc6 in loc9)
                    {
                        if (!(_data[loc6] && _data[loc6]["clothing"]))
                        {
                            continue;
                        }
                        if (arg2)
                        {
                            (loc7 = loc5 as Array).push(MyLifeUtils.cloneObject(_data[loc6]));
                            continue;
                        }
                        loc5[loc6] = MyLifeUtils.cloneObject(_data[loc6]);
                    }
                    loc3 = loc5;
                }
            }
            return loc3;
        }

        private static function loadAvatar(arg1:Function, arg2:Number=0, arg3:Object=null, arg4:Function=null, arg5:Number=0, arg6:Array=null):Boolean
        {
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;

            loc7 = undefined;
            loc9 = null;
            loc11 = null;
            loc12 = null;
            loc8 = "MyLife.Assets.Avatar.Avatar";
            loc10 = new MovieClip();
            if (arg6)
            {
                (loc7 = new (loc9 = getDefinitionByName(loc8) as Class)()).initAvatar(0, 1);
                loc11 = arg6;
            }
            else 
            {
                if (arg2)
                {
                    loc12 = getFriendData(arg2);
                }
                else 
                {
                    loc12 = playerData;
                }
                if (loc12)
                {
                    (loc7 = new (loc9 = getDefinitionByName(loc8) as Class)()).initAvatar(loc12.gender, 1);
                    loc11 = loc12.clothesData;
                }
            }
            if (loc7)
            {
                loc10.addChild(loc7);
                if (avatarLoadCallBackHashMap == null)
                {
                    avatarLoadCallBackHashMap = new Object();
                }
                trace("loading avatar :" + loc7.name);
                avatarLoadCallBackHashMap[loc7.name] = {"avatarLoadCallBack":arg4, "avatarLoadContext":arg3, "scale":arg5};
                loc7.addEventListener(AvatarLoadEvent.CLOTHING_LOAD_COMPLETE, arg1);
                loc7.loadAvatarClothes(loc11);
                return true;
            }
            trace("not loading avatar");
            return false;
        }

        public static function get ready():Boolean
        {
            return _ready;
        }

        public static function getAppUserFriendData(arg1:Number=0, arg2:Boolean=false):Object
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = null;
            loc6 = undefined;
            loc7 = null;
            loc3 = null;
            loc4 = (arg1 > 0) ? String(arg1) : null;
            if (_data)
            {
                if (loc4)
                {
                    if (_data[loc4])
                    {
                        loc3 = MyLifeUtils.cloneObject(_data[loc4]);
                    }
                }
                else 
                {
                    loc5 = arg2 ? [] : {};
                    loc8 = 0;
                    loc9 = _data;
                    for (loc6 in loc9)
                    {
                        if (!(_data[loc6] && _data[loc6]["clothing"]))
                        {
                            continue;
                        }
                        if (arg2)
                        {
                            (loc7 = loc5 as Array).push(MyLifeUtils.cloneObject(_data[loc6]));
                            continue;
                        }
                        loc5[loc6] = MyLifeUtils.cloneObject(_data[loc6]);
                    }
                    loc3 = loc5;
                }
            }
            return loc3;
        }

        public static function loadFriendImage(arg1:Number=0, arg2:Object=null, arg3:Function=null):void
        {
            var loc4:*;

            loc4 = null;
            if (arg1)
            {
                loc4 = getFriendData(arg1);
            }
            else 
            {
                loc4 = playerData;
            }
            if (loc4.picUrl)
            {
                AssetsManager.getInstance().loadImage(loc4.picUrl, arg2, arg3);
            }
            return;
        }

        public static function get playerData():MyLife.Structures.PlayerData
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = NaN;
            loc2 = null;
            loc3 = null;
            if (!_playerData)
            {
                _playerData = new PlayerData();
                loc1 = 0;
                if (MyLifeInstance.getInstance() && MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
                {
                    loc1 = MyLifeInstance.getInstance().getPlayer()._playerId;
                    _playerData.name = MyLifeInstance.getInstance().getPlayer().getPlayerName();
                }
                _playerData.playerId = loc1;
                loc2 = getAppUserFriendData(loc1);
                if (loc2)
                {
                    loc3 = objDataToFriendData(loc2);
                    _playerData.gender = loc3.gender;
                    _playerData.firstName = loc3.firstName;
                    _playerData.lastName = loc3.lastName;
                }
                else 
                {
                    _playerData.gender = 0;
                    _playerData.lastName = loc4 = _playerData.name;
                    _playerData.firstName = loc4;
                }
            }
            if (MyLifeInstance.getInstance() && MyLifeInstance.getInstance().hasOwnProperty("getPlayer"))
            {
                _playerData.clothesData = MyLifeInstance.getInstance().getPlayer().currentClothing;
                _playerData.coins = MyLifeInstance.getInstance().getPlayer().getCoinBalance();
            }
            return _playerData;
        }

        public static function loadFriendAvatar(arg1:Number=0, arg2:Object=null, arg3:Function=null, arg4:Number=0, arg5:Array=null):Boolean
        {
            return loadAvatar(onAvatarLoaded, arg1, arg2, arg3, arg4, arg5);
        }

        public static function getFriendData(arg1:Number):MyLife.Structures.FriendData
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (arg1 == getPlayerId())
            {
                loc3 = playerData;
            }
            else 
            {
                loc2 = getAppUserFriendData(arg1);
                if (loc2)
                {
                    loc3 = objDataToFriendData(loc2);
                }
            }
            return loc3;
        }

        public static function getFriendPlayerIds():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = null;
            loc1 = getPlayerId();
            loc2 = getAppUserFriendData(0, true) as Array;
            loc3 = [];
            loc5 = 0;
            loc6 = loc2;
            for each (loc4 in loc6)
            {
                if (loc4.player == loc1)
                {
                    continue;
                }
                loc3.push(Number(loc4.player));
            }
            return loc3;
        }

        public static function getAllFriendData(arg1:Function, arg2:Object=null):void
        {
            var loc3:*;

            loc3 = null;
            if (_allFriendsLoaded)
            {
                arg1.call(null, MyLifeUtils.cloneObject(_data), arg2);
            }
            else 
            {
                _callbacks.push({"callback":arg1, "context":arg2});
                loc3 = new URLLoader();
                loc3.addEventListener(Event.COMPLETE, instance.onAllFriendsLoaded);
                loc3.addEventListener(IOErrorEvent.IO_ERROR, instance.onAllFriendsError);
                loc3.load(instance.buildRequest(instance.ALLFRIENDS_SCRIPT));
            }
            return;
        }

        public static function loadFriendAvatarHead(arg1:Number=0, arg2:Object=null, arg3:Function=null, arg4:Number=0, arg5:Array=null):Boolean
        {
            return loadAvatar(onAvatarHeadLoaded, arg1, arg2, arg3, arg4, arg5);
        }

        public static function getFriendDataArray():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc1 = getPlayerId();
            loc2 = getAppUserFriendData(0, true) as Array;
            loc3 = [];
            loc6 = 0;
            loc7 = loc2;
            for each (loc5 in loc7)
            {
                if (loc5.player == loc1)
                {
                    continue;
                }
                loc4 = objDataToFriendData(loc5);
                loc3.push(loc4);
            }
            return loc3;
        }

        
        {
            _ready = false;
            _allFriendsLoaded = false;
            _callbacks = [];
            _retries = 0;
        }

        private const XPUSER_SCRIPT:String="get_top_xps.php";

        private const MAX_RETRIES:Number=2;

        private const ALLFRIENDS_SCRIPT:String="get_friends.php";

        public static const EVENT_READY:String="ready";

        private static var _retries:Number=0;

        private static var _data:Object;

        private static var _playerData:MyLife.Structures.PlayerData;

        private static var _callbacks:Array;

        private static var _ready:Boolean=false;

        private static var avatarLoadCallBackHashMap:Object;

        private static var _instance:MyLife.FriendDataManager;

        private static var _allFriendsLoaded:Boolean=false;
    }
}
