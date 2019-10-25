package MyLife 
{
    import com.adobe.serialization.json.*;
    import flash.events.*;
    import flash.net.*;
    import flash.xml.*;
    
    public class MyLifeConfiguration extends flash.events.EventDispatcher
    {
        public function MyLifeConfiguration()
        {
            variables = {};
            super();
            return;
        }

        private function onLocalSettingsXML(arg1:flash.events.Event):void
        {
            localSettingsLoaded = true;
            parseXML(new XML(arg1.target.data));
            return;
        }

        private function configLoaderError(arg1:flash.events.Event):void
        {
            arg1.target.removeEventListener(IOErrorEvent.IO_ERROR, configLoaderError);
            arg1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoaderError);
            if (arg1.hasOwnProperty("text"))
            {
                trace(arg1["text"]);
            }
            return;
        }

        private function loadPath(arg1:String, arg2:Object, arg3:Boolean):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc6 = null;
            loc7 = null;
            runningLocal = arg3;
            (loc4 = new URLLoader()).addEventListener(Event.COMPLETE, onLoadXML);
            loc4.addEventListener(IOErrorEvent.IO_ERROR, configLoaderError);
            loc4.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoaderError);
            loc4.load(new URLRequest(arg1));
            variables["querystring"] = {};
            loc5 = arg2 || {};
            loc8 = 0;
            loc9 = loc5;
            for (loc6 in loc9)
            {
                loc7 = loc5[loc6];
                variables["querystring"][loc6] = loc7;
            }
            if (arg3)
            {
                variables["querystring"]["instancesJSON"] = "{\"4005\":{\"instance_id\":\"4005\",\"server\":\"4\",\"instance_name\":\"English 1.1\",\"user_count\":\"150\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"74.217.69.155\",\"ip_address\":\"74.217.69.155\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1001\":{\"instance_id\":\"1001\",\"server\":\"1\",\"instance_name\":\"English 1.1\",\"user_count\":\"150\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"74.217.69.153\",\"ip_address\":\"74.217.69.153\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1002\":{\"instance_id\":\"1002\",\"server\":\"1\",\"instance_name\":\"English 1.2\",\"user_count\":\"130\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1003\":{\"instance_id\":\"1003\",\"server\":\"1\",\"instance_name\":\"English 1.3\",\"user_count\":\"172\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1004\":{\"instance_id\":\"1004\",\"server\":\"1\",\"instance_name\":\"English 1.4\",\"user_count\":\"142\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1005\":{\"instance_id\":\"1005\",\"server\":\"1\",\"instance_name\":\"English 1.5\",\"user_count\":\"131\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1016\":{\"instance_id\":\"1016\",\"server\":\"1\",\"instance_name\":\"Spanish 1.1\",\"user_count\":\"146\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"1017\":{\"instance_id\":\"1017\",\"server\":\"1\",\"instance_name\":\"Spanish 1.2\",\"user_count\":\"156\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"1\",\"hostname\":\"server1.yoville.com\",\"ip_address\":\"server1.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2001\":{\"instance_id\":\"2001\",\"server\":\"2\",\"instance_name\":\"English 2.1\",\"user_count\":\"152\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2002\":{\"instance_id\":\"2002\",\"server\":\"2\",\"instance_name\":\"English 2.2\",\"user_count\":\"157\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2003\":{\"instance_id\":\"2003\",\"server\":\"2\",\"instance_name\":\"English 2.3\",\"user_count\":\"157\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2004\":{\"instance_id\":\"2004\",\"server\":\"2\",\"instance_name\":\"English 2.4\",\"user_count\":\"142\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2005\":{\"instance_id\":\"2005\",\"server\":\"2\",\"instance_name\":\"English 2.5\",\"user_count\":\"177\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2016\":{\"instance_id\":\"2016\",\"server\":\"2\",\"instance_name\":\"Spanish 2.1\",\"user_count\":\"124\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"2017\":{\"instance_id\":\"2017\",\"server\":\"2\",\"instance_name\":\"Spanish 2.2\",\"user_count\":\"132\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"2\",\"hostname\":\"server2.yoville.com\",\"ip_address\":\"server2.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3001\":{\"instance_id\":\"3001\",\"server\":\"3\",\"instance_name\":\"English 3.1\",\"user_count\":\"148\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3002\":{\"instance_id\":\"3002\",\"server\":\"3\",\"instance_name\":\"English 3.2\",\"user_count\":\"136\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3003\":{\"instance_id\":\"3003\",\"server\":\"3\",\"instance_name\":\"English 3.3\",\"user_count\":\"137\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3004\":{\"instance_id\":\"3004\",\"server\":\"3\",\"instance_name\":\"English 3.4\",\"user_count\":\"136\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3005\":{\"instance_id\":\"3005\",\"server\":\"3\",\"instance_name\":\"English 3.5\",\"user_count\":\"69\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3016\":{\"instance_id\":\"3016\",\"server\":\"3\",\"instance_name\":\"Spanish 3.1\",\"user_count\":\"131\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3017\":{\"instance_id\":\"3017\",\"server\":\"3\",\"instance_name\":\"Spanish 3.2\",\"user_count\":\"118\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"3018\":{\"instance_id\":\"3018\",\"server\":\"3\",\"instance_name\":\"Spanish 3.3\",\"user_count\":\"160\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"3\",\"hostname\":\"server3.yoville.com\",\"ip_address\":\"server3.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4001\":{\"instance_id\":\"4001\",\"server\":\"4\",\"instance_name\":\"English 4.1\",\"user_count\":\"131\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4002\":{\"instance_id\":\"4002\",\"server\":\"4\",\"instance_name\":\"English 4.2\",\"user_count\":\"140\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4003\":{\"instance_id\":\"4003\",\"server\":\"4\",\"instance_name\":\"English 4.3\",\"user_count\":\"136\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4004\":{\"instance_id\":\"4004\",\"server\":\"4\",\"instance_name\":\"English 4.4\",\"user_count\":\"135\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4016\":{\"instance_id\":\"4016\",\"server\":\"4\",\"instance_name\":\"Spanish 4.1\",\"user_count\":\"148\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4017\":{\"instance_id\":\"4017\",\"server\":\"4\",\"instance_name\":\"Spanish 4.2\",\"user_count\":\"143\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4018\":{\"instance_id\":\"4018\",\"server\":\"4\",\"instance_name\":\"Spanish 4.3\",\"user_count\":\"132\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"4019\":{\"instance_id\":\"4019\",\"server\":\"4\",\"instance_name\":\"Spanish 4.4\",\"user_count\":\"5\",\"active\":\"1\",\"debug\":\"0\",\"server_id\":\"4\",\"hostname\":\"server4.yoville.com\",\"ip_address\":\"server4.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"9002\":{\"instance_id\":\"9002\",\"server\":\"9\",\"instance_name\":\"DEV 2\",\"user_count\":\"1\",\"active\":\"1\",\"debug\":\"1\",\"server_id\":\"9\",\"hostname\":\"stage.yoville.com\",\"ip_address\":\"stage.yoville.com\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0},\"8001\":{\"instance_id\":\"8001\",\"server\":\"8\",\"instance_name\":\"JOSH\",\"user_count\":\"1\",\"active\":\"1\",\"debug\":\"1\",\"server_id\":\"8\",\"hostname\":\"jrl.zynga.com\",\"ip_address\":\"74.201.93.74\",\"instance_count\":\"2\",\"status\":\"1\",\"buddy_count\":0}}";
                variables["querystring"]["static_base_url"] = "";
            }
            else 
            {
                localSettingsLoaded = true;
            }
            variables["utils"] = {};
            variables["utils"]["random"] = Math.round(Math.random() * 100000000);
            variables["utils"]["version"] = variables["querystring"]["v"] || variables["utils"]["random"];
            return;
        }

        public function load(arg1:String, arg2:Object=null, arg3:Boolean=false):void
        {
            if (!_ready)
            {
                arg2 == arg2 || {};
                loadPath(arg1, arg2, arg3);
            }
            return;
        }

        private function onLoadXML(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = null;
            configLoaded = true;
            parseXML(new XML(arg1.target.data));
            if (localSettingsLoaded)
            {
                assetVersionParam = "?v=" + variables["utils"]["version"];
                version = variables["utils"]["version"];
            }
            else 
            {
                loc2 = new URLLoader();
                loc2.addEventListener(Event.COMPLETE, onLocalSettingsXML);
                loc2.addEventListener(IOErrorEvent.IO_ERROR, configLoaderError);
                loc2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoaderError);
                loc2.load(new URLRequest("localSettings.xml"));
                version = "-1";
            }
            return;
        }

        private function parseXML(arg1:XML):void
        {
            var ad:XML;
            var attribute:XML;
            var categoryName:String;
            var fbUserObj:Object;
            var gameServerPath:String;
            var id:String;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var msUserObj:Object;
            var node:XML;
            var nodeName:String;
            var pXML:XML;
            var pattern:RegExp;
            var playerListObject:Object;
            var promoInfo:Object;
            var promos:Object;
            var replace:String;
            var taggedObj:Object;
            var variableName:String;
            var variableNodes:XMLList;
            var variableObj:Object;
            var variableType:String;
            var variableValue:String;

            nodeName = null;
            node = null;
            ad = null;
            variableType = null;
            variableName = null;
            variableValue = null;
            variableObj = null;
            promos = null;
            promoInfo = null;
            attribute = null;
            categoryName = null;
            pattern = null;
            replace = null;
            fbUserObj = null;
            msUserObj = null;
            taggedObj = null;
            gameServerPath = null;
            playerListObject = null;
            id = null;
            pXML = arg1;
            variableNodes = pXML.child("variable");
            loc3 = 0;
            loc4 = variableNodes;
            for each (node in loc4)
            {
                nodeName = node.name().toString();
                variableType = node.type;
                variableName = node.name;
                variableValue = node.toString();
                trace(variableType + " " + variableName + " " + variableValue);
                if (variables[variableType] == undefined)
                {
                    variables[variableType] = {};
                }
                if (!(variableType == "querystring") && variableValue.charAt(0) == "{")
                {
                    variableObj = JSON.decode(variableValue);
                    variables[variableType][variableName] = variableObj;
                    continue;
                }
                variables[variableType][variableName] = variableValue;
            }
            loc3 = 0;
            loc4 = pXML.child("promo");
            for each (ad in loc4)
            {
                if (variables["promos"] == null)
                {
                    variables["promos"] = {};
                    variables["promos"]["DEFAULT"] = [];
                }
                promos = variables["promos"];
                promoInfo = {};
                loc5 = 0;
                loc6 = ad.attributes();
                for each (attribute in loc6)
                {
                    promoInfo[attribute.name().toString()] = attribute.valueOf().toString();
                }
                if (ad.category != undefined)
                {
                    categoryName = ad.category;
                    if (promos[categoryName] == null)
                    {
                        promos[categoryName] = [];
                    }
                    promos[categoryName].push(promoInfo);
                }
                promos["DEFAULT"].push(promoInfo);
            }
            if (configLoaded && localSettingsLoaded)
            {
                pattern = new RegExp("fb", "g");
                replace = null;
                if (variables["querystring"]["facebookJSON"])
                {
                    platformType = PLATFORM_FACEBOOK;
                    fbUserObj = JSON.decode(variables["querystring"]["facebookJSON"]);
                    _snUID = fbUserObj.fb_sig_user;
                    _networkCredentials = "fb_sig_user=" + fbUserObj.fb_sig_user + "&fb_sig_session_key=" + fbUserObj.fb_sig_session_key;
                }
                else 
                {
                    if (variables["querystring"]["oauthJSON"] || variables["querystring"]["opensocialJSON"])
                    {
                        platformType = PLATFORM_MYSPACE;
                        replace = "ms";
                        msUserObj = JSON.decode(variables["querystring"]["opensocialJSON"]);
                        _snUID = msUserObj.opensocial_owner_id;
                        _networkCredentials = "opensocialJSON=" + variables["querystring"]["opensocialJSON"] + "&oathJSON=" + variables["querystring"]["oauthJSON"];
                    }
                    else 
                    {
                        platformType = PLATFORM_TAGGED;
                        replace = "tg";
                        taggedObj = JSON.decode(variables["querystring"]["taggedJSON"]);
                        _snUID = taggedObj.tagged_id;
                        _networkCredentials = "taggedJSON=" + variables["querystring"]["taggedJSON"];
                    }
                }
                if (replace != null)
                {
                    gameServerPath = variables["global"]["game_server"];
                    gameServerPath = gameServerPath.replace(pattern, replace);
                    variables["global"]["game_server"] = gameServerPath;
                }
                if (variables["querystring"]["playersJSON"])
                {
                    try
                    {
                        playerListObject = JSON.decode(MyLifeConfiguration.getInstance().variables["querystring"]["playersJSON"]);
                        loc3 = 0;
                        loc4 = playerListObject;
                        for (id in loc4)
                        {
                            playerId = parseInt(id);
                            break;
                        }
                    }
                    catch (e:*)
                    {
                    };
                }
                _ready = true;
                dispatchEvent(new MyLifeEvent(MyLifeEvent.LOADING_DONE));
            }
            return;
        }

        public static function ready():Boolean
        {
            return _ready;
        }

        public static function getInstance():MyLife.MyLifeConfiguration
        {
            if (!_instance)
            {
                _instance = new MyLifeConfiguration();
            }
            return _instance;
        }

        public static function get networkCredentials():String
        {
            return _networkCredentials;
        }

        public static function get sn_uid():String
        {
            return _snUID;
        }

        
        {
            version = null;
            _ready = false;
        }

        public const PLATFORM_FACEBOOK:String="platformFacebook";

        public const PLATFORM_MYSPACE:String="platformMySpace";

        public const PLATFORM_TAGGED:String="platformTagged";

        public var platformType:String="platformFacebook";

        private var localSettingsLoaded:Boolean=false;

        public var playerId:Number=-1;

        public var assetVersionParam:String="";

        private var configLoaded:Boolean=false;

        public var runningLocal:Boolean=false;

        private var _configXML:XML;

        public var variables:Object;

        private static var _ready:Boolean=false;

        private static var _networkCredentials:String;

        private static var _instance:MyLife.MyLifeConfiguration;

        private static var _snUID:String;

        public static var version:String=null;
    }
}
