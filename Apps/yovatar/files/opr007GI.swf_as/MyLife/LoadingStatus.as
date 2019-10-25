package MyLife 
{
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    
    public class LoadingStatus extends flash.display.MovieClip
    {
        public function LoadingStatus()
        {
            super();
            if (!_instance)
            {
                if (!myLife.runningLocal)
                {
                    _assetVersionParam = "?v=" + config.variables["utils"]["version"];
                }
                super.alpha = 0;
                _timer = new Timer(MIN_DISPLAY_TIME, 1);
                _timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
            }
            return;
        }

        private function get myLife():flash.display.MovieClip
        {
            return MyLifeInstance.getInstance();
        }

        private function get config():Object
        {
            return MyLifeConfiguration.getInstance();
        }

        public function hide():void
        {
            getInstance().hideUI();
            return;
        }

        private function promotionsListError(arg1:flash.events.Event):void
        {
            var loc2:*;

            loc2 = arg1.target as URLLoader;
            if (loc2)
            {
                loc2.removeEventListener(Event.COMPLETE, promotionsListLoaded);
                loc2.removeEventListener(IOErrorEvent.IO_ERROR, promotionsListError);
                loc2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, promotionsListError);
            }
            return;
        }

        private function loadPromo(arg1:String):flash.display.DisplayObject
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc2 = null;
            loc3 = config.variables["promos"];
            if (loc3)
            {
                loc4 = arg1;
                loc5 = null;
                loc7 = arg1;
                switch (loc7) 
                {
                    case PROMO_ALL:
                        loc5 = loc3[PROMO_ALL];
                        break;
                    case PROMO_ROOMCHANGE:
                        loc5 = loc3[PROMO_ROOMCHANGE];
                        break;
                }
                if (loc5)
                {
                    loc6 = Math.random() * loc5.length;
                    loc4 = loc5[loc6]["url"];
                }
                loc2 = AssetsManager.getInstance().getPromoAd(loc4);
            }
            return loc2;
        }

        public function setTask(arg1:String):void
        {
            getInstance().task.text = arg1;
            return;
        }

        private function promotionsListLoaded(arg1:flash.events.Event):void
        {
            var category:Array;
            var json:Object;
            var loader:flash.net.URLLoader;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var pEvent:flash.events.Event;
            var promoInfo:Object;
            var promoList:Object;

            json = null;
            promoList = null;
            promoInfo = null;
            category = null;
            pEvent = arg1;
            loader = pEvent.target as URLLoader;
            if (loader)
            {
                json = null;
                try
                {
                    json = JSON.decode(loader.data);
                }
                catch (e:*)
                {
                    trace("***** LoadingStatus: Bad Data Returned from get_promotions.php *****");
                }
                if (json)
                {
                    promoList = config.variables["promos"];
                    if (promoList == null)
                    {
                        promoList = {};
                        promoList["DEFAULT"] = [];
                        config.variables["promos"] = promoList;
                    }
                    loc3 = 0;
                    loc4 = json;
                    for each (promoInfo in loc4)
                    {
                        category = promoList[String(promoInfo.category)];
                        if (category == null)
                        {
                            category = [];
                            promoList[String(promoInfo.category)] = category;
                        }
                        category.push(promoInfo);
                        promoList["DEFAULT"].push(promoInfo);
                    }
                    AssetsManager.getInstance().preloadPromos();
                }
                loader.removeEventListener(Event.COMPLETE, promotionsListLoaded);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, promotionsListError);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, promotionsListError);
            }
            return;
        }

        private function hideUI():void
        {
            if (_timerExpired || _promo == null)
            {
                myLife.debug("Hide Loading Status");
                if (_timer)
                {
                    _timer.stop();
                    _timer.reset();
                }
                _timerExpired = false;
                _hideRequested = false;
                TweenLite.to(this, 1, {"alpha":0});
            }
            else 
            {
                _hideRequested = true;
            }
            return;
        }

        private function showUI(arg1:Boolean=false, arg2:String="ROOM_CHANGE", arg3:Number=640, arg4:Number=600):void
        {
            myLife.debug("Show Loading Status");
            alpha = 1;
            if (!(arg3 == MAX_WIDTH) || !(arg4 == MAX_HEIGHT))
            {
                removeChild(loadingBG);
                loadingBG.width = Math.min(MAX_WIDTH, arg3);
                loadingBG.height = Math.min(MAX_HEIGHT, arg4);
                addChildAt(loadingBG, 0);
                this.x = MAX_WIDTH - arg3 >> 1;
                this.y = MAX_HEIGHT - arg4 >> 1;
            }
            else 
            {
                if (!(loadingBG.width == MAX_WIDTH) || !(loadingBG.height == MAX_HEIGHT))
                {
                    removeChild(loadingBG);
                    loadingBG.width = Math.min(MAX_WIDTH, arg3);
                    loadingBG.height = Math.min(MAX_HEIGHT, arg4);
                    addChildAt(loadingBG, 0);
                    x = 0;
                    y = 0;
                }
            }
            progressBar.x = loadingBG.width - progressBar.width >> 1;
            taskPercent.x = loadingBG.width - taskPercent.width >> 1;
            task.x = loadingBG.width - task.width >> 1;
            myLife.addChild(this);
            parent.setChildIndex(this, (parent.numChildren - 1));
            if (arg1)
            {
                if (!_showing)
                {
                    _showing = true;
                    removePromo();
                    _promo = loadPromo(arg2);
                    if (_promo)
                    {
                        _promo.visible = true;
                        _promo.alpha = 0;
                        addChild(_promo);
                        _promo.x = Math.max(0, stage.stageWidth - _promo.width >> 1);
                        _promo.y = ZONE_OFFSET + Math.max(0, ZONE_HEIGHT - _promo.height >> 1);
                        if (_promo as MovieClip)
                        {
                            MovieClip(_promo).gotoAndPlay(1);
                        }
                        TweenLite.to(_promo, 0.5, {"alpha":1});
                        _timerExpired = false;
                        _timer.start();
                    }
                }
            }
            else 
            {
                removePromo();
            }
            return;
        }

        public function setProgress(arg1:Number, arg2:Number=-1):void
        {
            var loc3:*;

            loc3 = 0;
            if (arg2 > -1)
            {
                getInstance()._lastMaximum = arg2;
            }
            else 
            {
                arg2 = getInstance()._lastMaximum;
            }
            if (arg2 > 0)
            {
                loc3 = Math.floor(arg1 / arg2 * 100);
            }
            if (loc3 < 1)
            {
                loc3 = 1;
            }
            if (loc3 > 100)
            {
                loc3 = 100;
            }
            getInstance().progressBar.gotoAndStop(loc3);
            getInstance().taskPercent.text = loc3 + "%";
            return;
        }

        private function removePromo():void
        {
            var loc1:*;
            var loc2:*;

            if (_promo)
            {
                try
                {
                    removeChild(_promo);
                }
                catch (e:*)
                {
                };
                _promo = null;
            }
            return;
        }

        private function timerCompleteHandler(arg1:flash.events.TimerEvent):void
        {
            _timer.stop();
            _timer.reset();
            _timerExpired = true;
            if (_hideRequested)
            {
                hide();
            }
            return;
        }

        public function loadPromotionsList():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = null;
            loc3 = null;
            if (myLife.runningLocal)
            {
                myLife.assetsLoader.preloadPromos();
            }
            else 
            {
                loc1 = config.variables["global"]["game_control_server"];
                loc2 = loc1 + SCRIPT_NAME + _assetVersionParam;
                loc3 = new URLLoader();
                loc3.addEventListener(Event.COMPLETE, promotionsListLoaded);
                loc3.addEventListener(IOErrorEvent.IO_ERROR, promotionsListError);
                loc3.addEventListener(SecurityErrorEvent.SECURITY_ERROR, promotionsListError);
                loc3.load(new URLRequest(loc2));
            }
            return;
        }

        public override function set alpha(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;
            var value:Number;

            value = arg1;
            super.alpha = value;
            if (value == 0)
            {
                try
                {
                    myLife.removeChild(this);
                    _showing = false;
                    removePromo();
                }
                catch (e:*)
                {
                };
            }
            return;
        }

        public function show(arg1:Boolean=false, arg2:String="ROOM_CHANGE", arg3:Number=640, arg4:Number=600):void
        {
            getInstance().showUI(arg1, arg2, arg3, arg4);
            return;
        }

        public static function getInstance():MyLife.LoadingStatus
        {
            if (!_instance)
            {
                _instance = new LoadingStatus();
            }
            return _instance;
        }

        
        {
            _assetVersionParam = "";
        }

        private const ZONE_OFFSET:Number=60;

        private const SCRIPT_NAME:String="get_promotions.php";

        private const ZONE_HEIGHT:Number=480;

        private const MIN_DISPLAY_TIME:Number=3000;

        private static const MAX_WIDTH:Number=640;

        public static const PROMO_BOOKMARKS:String="BOOKMARKS";

        private static const MAX_HEIGHT:Number=600;

        public static const PROMO_ALL:String="DEFAULT";

        public static const PROMO_ROOMCHANGE:String="ROOM_CHANGE";

        public var taskPercent:flash.text.TextField;

        public var loadingBG:flash.display.MovieClip;

        public var task:flash.text.TextField;

        private var _showing:Boolean=false;

        private var _promo:flash.display.DisplayObject=null;

        private var _hideRequested:Boolean=false;

        private var _timer:flash.utils.Timer;

        public var progressBar:flash.display.MovieClip;

        private var _lastMaximum:Number=1;

        private var _timerExpired:Boolean=false;

        private static var _assetVersionParam:String="";

        private static var _instance:MyLife.LoadingStatus;
    }
}
