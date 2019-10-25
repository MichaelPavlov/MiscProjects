package MyLife 
{
    import flash.events.*;
    
    public class ZoneItemManager extends flash.events.EventDispatcher
    {
        public function ZoneItemManager()
        {
            super();
            this.init();
            return;
        }

        public function removeAllItems():MyLife.ZoneItemManager
        {
            this.deactivateItems();
            this.items.splice(0);
            return this;
        }

        public function activateItems():MyLife.ZoneItemManager
        {
            var loc1:*;
            var loc2:*;

            loc1 = undefined;
            this.disabled = false;
            loc2 = this.items.length;
            while (loc2--) 
            {
                loc1 = this.items[loc2];
                if (loc1.isActivated)
                {
                    continue;
                }
                loc1.activate();
            }
            return this;
        }

        public function setRoomVariable(arg1:String, arg2:*, arg3:Boolean=true):void
        {
            var loc4:*;
            var loc5:*;
            var persistent:Boolean=true;
            var rVars:Array;
            var room:*;
            var roomId:int;
            var sfs:*;
            var value:*;
            var varName:String;

            sfs = undefined;
            room = undefined;
            roomId = 0;
            rVars = null;
            varName = arg1;
            value = arg2;
            persistent = arg3;
            try
            {
                sfs = this._myLife.server.getSFS();
                room = sfs.getActiveRoom();
                roomId = room.getId();
                rVars = new Array();
                rVars.push({"name":varName, "val":value, "persistent":true});
                sfs.setRoomVariables(rVars, roomId, false);
            }
            catch (error:Error)
            {
                trace(undefined);
            }
            return;
        }

        private function connectionLostHandler(arg1:flash.events.Event):void
        {
            if (_instance)
            {
                _instance.disabled = true;
                _instance.deactivateItems();
            }
            return;
        }

        public function deactivateItems():MyLife.ZoneItemManager
        {
            var loc1:*;
            var loc2:*;

            loc1 = undefined;
            trace("deactivateItems()");
            loc2 = this.items.length;
            while (loc2--) 
            {
                loc1 = this.items[loc2];
                if (!loc1.isActivated)
                {
                    continue;
                }
                loc1.deactivate();
            }
            this.disabled = true;
            return this;
        }

        public function clear():void
        {
            this.removeAllItems();
            this.disabled = false;
            return;
        }

        private function init():void
        {
            ZoneItemManager._instance = this;
            this._myLife = MyLifeInstance.getInstance();
            this._myLife.getServer().addEventListener("sfs_connectionLost", connectionLostHandler);
            this.items = [];
            this.disabled = false;
            return;
        }

        public function addItem(arg1:*):MyLife.ZoneItemManager
        {
            this.items.push(arg1);
            return this;
        }

        public function registerItem(arg1:*):MyLife.ZoneItemManager
        {
            if (!this.disabled)
            {
                this.addItem(arg1);
            }
            return this;
        }

        public function removeItem(arg1:*):MyLife.ZoneItemManager
        {
            var loc2:*;

            arg1.deactivate();
            loc2 = this.items.indexOf(arg1);
            if (loc2 >= 0)
            {
                this.items.splice(loc2, 1);
            }
            return this;
        }

        public function getProp(arg1:String):*
        {
            var loc2:*;

            loc2 = this._myLife[arg1];
            return loc2;
        }

        public function getRoomVariable(arg1:String):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = undefined;
            loc6 = null;
            loc2 = this._myLife.server.getSFS();
            if (loc2 == null)
            {
                return null;
            }
            loc3 = loc2.getActiveRoom();
            if (loc3 == null)
            {
                return null;
            }
            if (loc4 = loc3.getVariables())
            {
                loc7 = 0;
                loc8 = loc4;
                for (loc6 in loc8)
                {
                    if (loc6 != arg1)
                    {
                        continue;
                    }
                    return loc4[loc6];
                }
            }
            return null;
        }

        public function doItemAction(arg1:Number, arg2:Number, arg3:Number, arg4:Object):*
        {
            var loc5:*;

            if (!((loc5 = getItemByPlayerItemId(arg2, arg3)) == null) && loc5.hasOwnProperty("doItemAction"))
            {
                loc5.doItemAction(arg1, false, arg4);
            }
            return;
        }

        public function callFunction(arg1:String, arg2:String, arg3:Array=null):*
        {
            var loc4:*;

            return loc4 = this._myLife[arg1][arg2].apply(null, arg3);
        }

        public function getItemByPlayerItemId(arg1:Number, arg2:Number):*
        {
            var loc3:*;
            var loc4:*;

            loc4 = NaN;
            loc3 = 0;
            while (loc3 < this.items.length) 
            {
                if (this.items[loc3].playerItemId == arg1)
                {
                    return this.items[loc3];
                }
                if (this.items[loc3].playerItemId == null || this.items[loc3].playerItemId == undefined || this.items[loc3].playerItemId == 0 || arg1 == 0)
                {
                    loc4 = Number(Math.round(this.items[loc3].x) + "" + Math.round(this.items[loc3].y));
                    if (arg2 == loc4)
                    {
                        return this.items[loc3];
                    }
                }
                ++loc3;
            }
            return null;
        }

        public static function get instance():MyLife.ZoneItemManager
        {
            if (!ZoneItemManager._instance)
            {
                new ZoneItemManager();
            }
            return ZoneItemManager._instance;
        }

        public var items:Array;

        private var _myLife:*;

        public var disabled:Boolean;

        private static var _instance:MyLife.ZoneItemManager;
    }
}
