package MyLife.Interfaces 
{
    import MyLife.*;
    import com.adobe.serialization.json.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    
    public class StartScreen extends flash.display.MovieClip
    {
        public function StartScreen()
        {
            super();
            trace("StartScreen Class Initialized");
            return;
        }

        public function hide():void
        {
            MovieClip(this).visible = false;
            return;
        }

        public function initialize(arg1:flash.display.MovieClip, arg2:Object):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc3 = null;
            loc5 = null;
            loc6 = undefined;
            loc7 = undefined;
            loc8 = undefined;
            _myLife = arg1;
            hide();
            _myLife.addChild(this);
            startGameButton.addEventListener(MouseEvent.CLICK, startGame);
            serverSelector.addItem({"label":"Connect To The Default YoVille Server"});
            loc3 = JSON.decode(_myLife.myLifeConfiguration.variables["querystring"]["instancesJSON"]);
            loc4 = [];
            loc9 = 0;
            loc10 = loc3;
            for each (loc5 in loc10)
            {
                loc4.push(loc5);
            }
            loc4.sortOn("instance_id", Array.NUMERIC);
            loc9 = 0;
            loc10 = loc4;
            for each (loc5 in loc10)
            {
                loc6 = "Server " + loc5.instance_id;
                loc7 = loc5.bussy_count;
                loc8 = loc6;
                if (loc7 > 0)
                {
                    loc8 = loc8 + "     ***  " + loc7 + " Buddies Online  ***";
                }
                serverSelector.addItem({"label":loc8, "instance":loc5});
            }
            serverSelector.rowCount = 8;
            return;
        }

        private function startGame(arg1:flash.events.MouseEvent):*
        {
            var loc2:*;
            var loc3:*;

            loc2 = undefined;
            loc3 = undefined;
            if (serverSelector.selectedItem.instance && serverSelector.selectedItem.instance.instance_id)
            {
                loc2 = serverSelector.selectedItem.instance.server;
                loc3 = serverSelector.selectedItem.instance.instance_id;
                MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultServer"] = "server" + loc2;
                MyLifeInstance.getInstance().getConfiguration().variables["querystring"]["defaultInstance"] = loc3;
            }
            dispatchEvent(new MyLifeEvent(MyLifeEvent.START_GAME, {"serverIndex":1, "parentInterface":this}, true));
            return;
        }

        public function show():void
        {
            MovieClip(this).visible = true;
            return;
        }

        public var serverSelector:fl.controls.ComboBox;

        public var fbBookmarkReminder:flash.display.MovieClip;

        public var startGameButton:flash.display.SimpleButton;

        private var _myLife:flash.display.MovieClip;
    }
}
