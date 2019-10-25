package MyLife.Interfaces 
{
    import MyLife.*;
    import fl.controls.*;
    import fl.data.*;
    import fl.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    
    public class DeveloperUI extends flash.display.Sprite
    {
        public function DeveloperUI()
        {
            var loc1:*;
            var loc2:*;

            super();
            graphics.beginFill(13421772);
            graphics.lineStyle(2);
            graphics.drawRoundRect(0, (0), 480, 360, 15, (15));
            graphics.endFill();
            _loginButton = new MovieClip();
            _loginButton.graphics.beginFill(13421823);
            _loginButton.graphics.lineStyle(1);
            _loginButton.graphics.drawRoundRect(0, (0), 60, 25, 5, (5));
            _loginButton.graphics.endFill();
            loc1 = new TextField();
            loc1.text = "Login";
            loc1.x = 60 - loc1.textWidth >> 1;
            loc1.y = 25 - loc1.textHeight >> 1;
            _loginButton.addChild(loc1);
            _loginButton.x = 210;
            _loginButton.y = 315;
            _loginButton.buttonMode = true;
            _loginButton.useHandCursor = true;
            _loginButton.mouseChildren = false;
            _loginButton.alpha = 0.75;
            _loginButton.addEventListener(MouseEvent.CLICK, loginClicked);
            loc2 = new URLLoader();
            loc2.addEventListener(Event.COMPLETE, configLoaded);
            loc2.addEventListener(IOErrorEvent.IO_ERROR, configError);
            loc2.load(new URLRequest("developer.xml"));
            return;
        }

        private function loginClicked(arg1:flash.events.MouseEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = undefined;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            if (_player)
            {
                loc2 = MyLifeInstance.getInstance().myLifeConfiguration;
                loc3 = loc2.variables["querystring"];
                loc3["user"] = Number(_player.user);
                loc3["playersJSON"] = _player.playersJSON;
                loc5 = loc2.variables["global"]["game_server"];
                if (_player["facebookJSON"])
                {
                    loc3["facebookJSON"] = _player.facebookJSON;
                    loc2.platformType = "platformFacebook";
                    loc4 = new RegExp("ms", "g");
                    loc5 = loc5.replace(loc4, "fb");
                    loc2.variables["global"]["game_server"] = loc5;
                }
                else 
                {
                    loc3["oathJSON"] = _player.oathJSON;
                    loc3["opensocialJSON"] = _player.opensocialJSON;
                    loc2.platformType = "platformMySpace";
                    loc4 = new RegExp("fb", "g");
                    loc5 = loc5.replace(loc4, "ms");
                    loc2.variables["global"]["game_server"] = loc5;
                }
                close();
            }
            return;
        }

        private function configError(arg1:flash.events.IOErrorEvent):void
        {
            var loc2:*;

            loc2 = arg1.currentTarget as URLLoader;
            loc2.removeEventListener(Event.COMPLETE, configLoaded);
            loc2.removeEventListener(IOErrorEvent.IO_ERROR, configError);
            close();
            return;
        }

        private function verifyFBSession(arg1:String):void
        {
            return;
        }

        private function playerSelected(arg1:fl.events.ListEvent):void
        {
            _player = arg1.item;
            _loginButton.enabled = true;
            _loginButton.alpha = 1;
            loginClicked(null);
            return;
        }

        private function configLoaded(arg1:flash.events.Event):void
        {
            var loader:flash.net.URLLoader;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var obj:Object;
            var pEvent:flash.events.Event;
            var player:XML;
            var prop:XML;

            player = null;
            obj = null;
            prop = null;
            pEvent = arg1;
            loader = pEvent.currentTarget as URLLoader;
            loader.removeEventListener(Event.COMPLETE, configLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, configError);
            try
            {
                _config = new XML(loader.data);
                _playerList = new DataGrid();
                _playerList.x = 20;
                _playerList.y = 20;
                _playerList.width = width - 40;
                _playerList.dataProvider = new DataProvider();
                loc3 = 0;
                loc4 = _config.players.children();
                for each (player in loc4)
                {
                    obj = {};
                    obj["name"] = player.name;
                    loc5 = 0;
                    loc6 = player.children();
                    for each (prop in loc6)
                    {
                        obj[prop.name().toString()] = prop.text()[0];
                    }
                    _playerList.dataProvider.addItem(obj);
                }
                _playerList.rowCount = (_playerList.dataProvider.length > 10) ? 10 : _playerList.dataProvider.length;
                _playerList.addEventListener(ListEvent.ITEM_CLICK, playerSelected);
                showUI();
            }
            catch (e:*)
            {
                trace(undefined.message);
                close();
            }
            return;
        }

        private function showUI(arg1:String="selectPlayer"):void
        {
            var loc2:*;

            while (numChildren > 1) 
            {
                removeChildAt(1);
            }
            loc2 = arg1;
            switch (loc2) 
            {
                case "selectPlayer":
                    addChild(_playerList);
                    addChild(_loginButton);
                    _loginButton.enabled = false;
                    break;
            }
            return;
        }

        private function close():void
        {
            _config = null;
            _loginButton.removeEventListener(MouseEvent.CLICK, loginClicked);
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }

        private var _player:*;

        private var _config:XML=null;

        private var _loginButton:flash.display.MovieClip;

        private var _playerList:fl.controls.DataGrid;
    }
}
