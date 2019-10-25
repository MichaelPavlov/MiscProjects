package MyLife 
{
    import fai.*;
    import flash.display.*;
    
    public class DepthSort extends flash.display.MovieClip
    {
        public function DepthSort()
        {
            super();
            return;
        }

        public function initDepthMap(arg1:int, arg2:int, arg3:Array):*
        {
            _mapWidth = arg1;
            _mapHeight = arg2;
            itemMap = arg3;
            return;
        }

        private function generateItemOrderPairList():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = null;
            loc1 = [];
            loc2 = 1;
            while (loc2 <= _mapWidth + _mapHeight) 
            {
                loc3 = getItemOrder(loc2);
                loc5 = 0;
                loc6 = loc3;
                for each (loc4 in loc6)
                {
                    loc1.push(loc4);
                }
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        private function applyItemPairListToRayDistance(arg1:Array, arg2:Array):Array
        {
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

            loc6 = null;
            loc7 = undefined;
            loc8 = undefined;
            loc9 = undefined;
            loc10 = undefined;
            loc3 = arg1;
            loc4 = true;
            loc5 = 0;
            while (loc4 && loc5 < 3) 
            {
                loc4 = false;
                loc11 = 0;
                loc12 = arg2;
                for each (loc6 in loc12)
                {
                    loc7 = loc6[0];
                    loc8 = loc6[1];
                    loc9 = loc3.indexOf(loc7);
                    loc10 = loc3.indexOf(loc8);
                    if (!(loc9 > loc10))
                    {
                        continue;
                    }
                    loc3[loc9] = loc8;
                    loc3[loc10] = loc7;
                    loc4 = true;
                }
                loc5 = (loc5 + 1);
            }
            return loc3;
        }

        private function getItemOrder(arg1:*):Array
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

            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            loc9 = false;
            loc2 = [];
            loc3 = 0;
            loc4 = 0;
            if (arg1 <= _mapWidth)
            {
                loc3 = _mapHeight - arg1;
                loc4 = (_mapWidth - 1);
                while (loc4 >= 0) 
                {
                    loc5 = itemMap[loc3] ? itemMap[loc3][loc4] ? itemMap[loc3][loc4] : "" : "";
                    loc10 = 0;
                    loc11 = String(loc5).split("_");
                    for each (loc7 in loc11)
                    {
                        if (!(loc7 > 0))
                        {
                            continue;
                        }
                        loc9 = true;
                        loc12 = 0;
                        loc13 = String(loc6).split("_");
                        for each (loc8 in loc13)
                        {
                            if (!(loc8 > 0))
                            {
                                continue;
                            }
                            if (loc8 == loc7)
                            {
                                continue;
                            }
                            loc2.push([int(loc8), int(loc7)]);
                        }
                    }
                    if (loc9)
                    {
                        loc6 = loc5;
                        loc9 = false;
                    }
                    loc4 = (loc4 - 1);
                }
            }
            if (arg1 > _mapWidth)
            {
                loc4 = _mapWidth - (arg1 - _mapWidth);
                loc3 = (_mapHeight - 1);
                while (loc3 >= 0) 
                {
                    loc5 = itemMap[loc3] ? itemMap[loc3][loc4] ? itemMap[loc3][loc4] : "" : "";
                    loc10 = 0;
                    loc11 = String(loc5).split("_");
                    for each (loc7 in loc11)
                    {
                        if (!(loc7 > 0))
                        {
                            continue;
                        }
                        loc9 = true;
                        loc12 = 0;
                        loc13 = String(loc6).split("_");
                        for each (loc8 in loc13)
                        {
                            if (!(loc8 > 0))
                            {
                                continue;
                            }
                            if (loc8 == loc7)
                            {
                                continue;
                            }
                            loc2.push([int(loc8), int(loc7)]);
                        }
                    }
                    if (loc9)
                    {
                        loc6 = loc5;
                        loc9 = false;
                    }
                    loc3 = (loc3 - 1);
                }
            }
            return loc2;
        }

        private function castDistanceRay(arg1:*, arg2:*):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc9 = undefined;
            loc3 = arg1;
            loc4 = arg2;
            if ((loc5 = itemMap[arg1] ? itemMap[arg1][arg2] ? itemMap[arg1][arg2] : "" : "") == "")
            {
                return [{"i":0, "d":0}];
            }
            loc7 = (loc6 = Math.max(_mapWidth, _mapHeight) - Math.abs(_mapHeight - _mapWidth) / 2) - (arg1 * 0.5 + arg2 * 0.5) + 0.5;
            loc8 = [];
            loc10 = 0;
            loc11 = String(loc5).split("_");
            for each (loc9 in loc11)
            {
                if (!loc9)
                {
                    continue;
                }
                loc8.push({"i":int(loc9), "d":loc7});
            }
            return loc8;
        }

        public function setupDefaultMap():void
        {
            return;
        }

        public function calcSortOrder():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = undefined;
            loc5 = null;
            loc6 = null;
            loc1 = getRayDistanceItemList();
            loc1.sortOn("d", Array.NUMERIC);
            loc2 = [];
            loc3 = [];
            loc7 = 0;
            loc8 = loc1;
            for each (loc4 in loc8)
            {
                if (loc3[loc4.i])
                {
                    continue;
                }
                loc2.push(loc4.i);
                loc3[loc4.i] = true;
            }
            loc5 = generateItemOrderPairList();
            return loc6 = applyItemPairListToRayDistance(loc2, loc5);
        }

        private function getRayDistanceItemList():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc3 = 0;
            loc4 = null;
            loc5 = undefined;
            loc1 = [];
            loc2 = 0;
            while (loc2 < _mapWidth) 
            {
                loc3 = 0;
                while (loc3 < _mapHeight) 
                {
                    loc4 = castDistanceRay(loc2, loc3);
                    loc6 = 0;
                    loc7 = loc4;
                    for each (loc5 in loc7)
                    {
                        if (!(loc5.d > 0))
                        {
                            continue;
                        }
                        loc1.push(loc5);
                    }
                    ++loc3;
                }
                ++loc2;
            }
            return loc1;
        }

        private var _mapHeight:Number=0;

        private var _myLife:flash.display.MovieClip;

        public var itemMap:Array;

        private var _blockSize:Number=0;

        private var _mapWidth:Number=0;
    }
}
