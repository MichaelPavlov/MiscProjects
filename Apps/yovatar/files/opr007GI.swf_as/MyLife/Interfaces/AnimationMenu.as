package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.Assets.Avatar.AvatarActions.*;
    import MyLife.Events.*;
    import flash.display.*;
    import flash.events.*;
    
    public class AnimationMenu extends flash.display.Sprite
    {
        public function AnimationMenu()
        {
            _animationMenuData = [];
            _actionsMenuData = [];
            _dancesMenuData = [];
            _posesMenuData = [];
            _allAnimations = [];
            _favoriteAnimationsCore = [];
            _favoriteAnimations = [];
            style = {"myLifeContextMenu":{"backgroundColor":16777215, "alpha":0.8, "borderColor":10066329, "borderWidth":1, "borderRadius":20, "dividerColor":13421772, "dividerWidth":1, "dividerPadding":3}, "myLifeContextMenuItem":{"width":200, "color":3355443, "fontSize":12, "metaColor":13382451, "metaFontSize":10, "backgroundColor":16711935, "backgroundAlpha":0, "hoverColor":0, "hoverBackgroundColor":15923455, "arrowHoverColor":0, "categoryBackgroundColor":15923455, "categoryBackgroundAlpha":0.5}};
            super();
            restoreStoredAnimationData();
            if (InventoryManager.ready)
            {
                buildAnimList();
            }
            else 
            {
                InventoryManager.getInstance().addEventListener(InventoryEvent.READY, inventoryReadyHandler);
                InventoryManager.loadInventory();
            }
            return;
        }

        private function menuCloseHandler(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = 0;
            loc4 = null;
            loc5 = false;
            loc6 = null;
            loc2 = _menu.value;
            if (loc2)
            {
                loc3 = 0;
                while (loc3 < _allAnimations.length) 
                {
                    if ((loc4 = _allAnimations[loc3]).value.a == loc2.a)
                    {
                        _lastAnimation = loc4;
                        break;
                    }
                    ++loc3;
                }
                loc5 = false;
                loc3 = 0;
                while (loc3 < _favoriteAnimationsCore.length) 
                {
                    if ((loc6 = _favoriteAnimationsCore[loc3]).a == loc2.a)
                    {
                        loc6.used = loc6.used || 0;
                        loc8 = ((loc7 = loc6).used + 1);
                        loc7.used = loc8;
                        loc5 = true;
                        break;
                    }
                    ++loc3;
                }
                if (!loc5)
                {
                    _favoriteAnimationsCore.push({"a":loc2.a, "used":1});
                }
                saveStoredAnimationData();
                dispatchEvent(new MyLifeEvent(MyLifeEvent.PLAY_ANIMATION, loc2));
            }
            return;
        }

        public function cleanUp():void
        {
            if (_menu)
            {
                if (contains(_menu))
                {
                    removeChild(_menu);
                }
                _menu.remove();
                _menu.removeEventListener(Event.COMPLETE, menuCloseHandler);
                _menu = null;
            }
            _animationMenuData.splice(0);
            _actionsMenuData.splice(0);
            _dancesMenuData.splice(0);
            _posesMenuData.splice(0);
            _lastAnimation = null;
            _newAnimation = null;
            _favoriteAnimations.splice(0);
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            return;
        }

        private function buildAnimList():void
        {
            var loc1:*;

            loc1 = InventoryManager.getPlayerInventory(InventoryManager.INVENTORY_ANIMATIONS);
            constructFinalMenu(loc1);
            _menu = new MyLifeContextMenu(_animationMenuData, style);
            _menu.addEventListener(Event.COMPLETE, menuCloseHandler);
            addChild(_menu);
            return;
        }

        private function constructFinalMenu(arg1:Object):void
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
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;

            loc4 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = false;
            loc11 = null;
            loc12 = null;
            loc13 = false;
            loc14 = null;
            _dancesMenuData.push({"name":"JUMP_AND_SWING", "text":"Jump And Swing", "meta":"9 energy", "value":{"e":9, "a":"JUMP_AND_SWING"}, "used":0});
            _dancesMenuData.push({"name":"ROBOT_DANCE", "text":"The Robot Dance", "meta":"6 energy", "value":{"e":6, "a":"ROBOT_DANCE"}, "used":0});
            _dancesMenuData.push({"name":"ARM_SHUFFLE", "text":"Arm Shuffle", "meta":"3 energy", "value":{"e":3, "a":"ARM_SHUFFLE"}, "used":0});
            _allAnimations = _allAnimations.concat(_dancesMenuData);
            _actionsMenuData.push({"name":"YOU_DA_BOMB", "text":"You Da Bomb!", "meta":"30 energy", "value":{"e":30, "a":"YOU_DA_BOMB"}, "used":0});
            _actionsMenuData.push({"name":"MYSTIC_LEVITATION", "text":"Mystic Levitation", "meta":"24 energy", "value":{"e":24, "a":"MYSTIC_LEVITATION"}, "used":0});
            _actionsMenuData.push({"name":"POWER_JUMP", "text":"Power Jump", "meta":"15 energy", "value":{"e":15, "a":"POWER_JUMP"}, "used":0});
            _actionsMenuData.push({"name":"JUMPING_JACKS", "text":"Jumping Jacks", "meta":"6 energy", "value":{"e":6, "a":"JUMPING_JACKS"}, "used":0});
            _allAnimations = _allAnimations.concat(_actionsMenuData);
            if (arg1)
            {
                loc15 = 0;
                loc16 = arg1;
                for each (loc6 in loc16)
                {
                    loc7 = ActionLibrary.makeAnimItem(loc6);
                    loc17 = loc6.category;
                    switch (loc17) 
                    {
                        case "Action":
                            _actionsMenuData.push(loc7);
                            break;
                        case "Dance":
                            _dancesMenuData.push(loc7);
                            break;
                        case "Pose":
                            _posesMenuData.push(loc7);
                            break;
                    }
                    _allAnimations.push(loc7);
                }
            }
            _actionsMenuData.sortOn(["name"]);
            _dancesMenuData.sortOn(["name"]);
            _posesMenuData.sortOn(["name"]);
            _animationMenuData.push({"text":"<b>Actions</b>", "contextMenuData":{"itemDataArray":_actionsMenuData}});
            _animationMenuData.push({"text":"<b>Dances</b>", "contextMenuData":{"itemDataArray":_dancesMenuData}});
            loc2 = 5;
            if (_posesMenuData.length)
            {
                loc2 = (loc2 - 1);
                _animationMenuData.push({"text":"<b>Poses</b>", "contextMenuData":{"itemDataArray":_posesMenuData}});
            }
            loc3 = [];
            if (_newAnimation)
            {
                _animationMenuData.unshift(_newAnimation);
                loc2 = (loc2 - 1);
            }
            if (_lastAnimation)
            {
                _animationMenuData.unshift(_lastAnimation);
                loc2 = (loc2 - 1);
            }
            _favoriteAnimationsCore.sortOn(["used"], Array.DESCENDING | Array.NUMERIC);
            loc15 = 0;
            loc16 = _favoriteAnimationsCore;
            for each (loc4 in loc16)
            {
                loc17 = 0;
                loc18 = _allAnimations;
                for each (loc8 in loc18)
                {
                    if (loc8.value.a != loc4.a)
                    {
                        continue;
                    }
                    _favoriteAnimations.push(loc8);
                    break;
                }
            }
            while (_favoriteAnimations.length > 0 && loc2 > 0) 
            {
                loc9 = _favoriteAnimations.pop();
                loc10 = false;
                loc15 = 0;
                loc16 = _animationMenuData;
                for each (loc11 in loc16)
                {
                    if (!loc11.hasOwnProperty("value"))
                    {
                        continue;
                    }
                    if (loc11.value.a != loc9.value.a)
                    {
                        continue;
                    }
                    loc10 = true;
                    break;
                }
                if (loc10)
                {
                    continue;
                }
                _animationMenuData.unshift(loc9);
                loc2 = (loc2 - 1);
            }
            loc5 = 0;
            while (loc5 < loc2 && loc5 < _actionsMenuData.length) 
            {
                loc12 = _actionsMenuData[loc5];
                loc13 = false;
                loc15 = 0;
                loc16 = _animationMenuData;
                for each (loc14 in loc16)
                {
                    if (!loc14.hasOwnProperty("value"))
                    {
                        continue;
                    }
                    if (loc14.value.a != loc12.value.a)
                    {
                        continue;
                    }
                    loc13 = true;
                    break;
                }
                if (!loc13)
                {
                    _animationMenuData.unshift(_actionsMenuData[loc5]);
                }
                ++loc5;
            }
            return;
        }

        private function inventoryReadyHandler(arg1:MyLife.Events.InventoryEvent):void
        {
            InventoryManager.getInstance().removeEventListener(InventoryEvent.READY, inventoryReadyHandler);
            buildAnimList();
            return;
        }

        private function saveStoredAnimationData():void
        {
            var loc1:*;

            loc1 = {};
            loc1.f = _favoriteAnimationsCore;
            loc1.l = _lastAnimation;
            SharedObjectManager.setValue(SharedObjectManager.ANIMATION_DATA, loc1);
            return;
        }

        private function restoreStoredAnimationData():void
        {
            var loc1:*;

            loc1 = SharedObjectManager.getValue(SharedObjectManager.ANIMATION_DATA);
            if (loc1)
            {
                _lastAnimation = loc1.l || {};
                _favoriteAnimationsCore = loc1.f || [];
            }
            return;
        }

        private var _actionsMenuData:Array;

        private var _dancesMenuData:Array;

        private var _favoriteAnimationsCore:Array;

        private var _favoriteAnimations:Array;

        private var _posesMenuData:Array;

        private var _animationMenuData:Array;

        private var _lastAnimation:Object;

        private var _newAnimation:Object;

        private var style:Object;

        private var _allAnimations:Array;

        private var _menu:MyLife.Interfaces.MyLifeContextMenu;
    }
}
