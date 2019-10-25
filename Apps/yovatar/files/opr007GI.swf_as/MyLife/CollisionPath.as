package MyLife 
{
    import fai.*;
    import flash.display.*;
    
    public class CollisionPath extends flash.display.MovieClip
    {
        public function CollisionPath(arg1:flash.display.MovieClip)
        {
            super();
            _myLife = arg1;
            return;
        }

        internal function getShortPath(arg1:Array):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc5 = null;
            loc6 = null;
            loc2 = new Array();
            loc3 = new Position();
            loc4 = new Position();
            loc7 = 0;
            loc8 = arg1;
            for each (loc6 in loc8)
            {
                if ((loc5 = loc3.deltaPosition(loc6)).deltaPosition(loc4).toString() != "(0, 0)")
                {
                    if (loc3.toString() != "(0, 0)")
                    {
                        loc2.push(loc3);
                    }
                }
                loc4 = loc5;
                loc3 = loc6;
            }
            if (loc3.toString() != "(0, 0)")
            {
                loc2.push(loc3);
            }
            return loc2;
        }

        internal function initializeMap(arg1:Number=53, arg2:Number=53, arg3:Number=18):*
        {
            _mapWidth = arg1;
            _mapHeight = arg2;
            mapMatrix = new MapMatrix(_mapWidth, _mapHeight);
            setupDefaultMap();
            return;
        }

        private function fillMapLine(arg1:*, arg2:*, arg3:*, arg4:*, arg5:int=1):*
        {
            var loc6:*;
            var loc7:*;

            loc6 = arg1;
            loc7 = arg2;
            while (loc6 >= 0 && loc7 >= 0 && loc6 < _mapWidth && loc7 < _mapHeight) 
            {
                mapMatrix.setxy(loc6, loc7, arg5);
                loc6 = loc6 + arg3;
                loc7 = loc7 + arg4;
            }
            return;
        }

        public function mapToString():String
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc3 = NaN;
            loc1 = "";
            loc2 = 0;
            while (loc2 < _mapHeight) 
            {
                loc3 = 0;
                while (loc3 < _mapWidth) 
                {
                    if (mapMatrix.getxy(loc3, loc2) != 0)
                    {
                        loc1 = loc1 + " X";
                    }
                    else 
                    {
                        loc1 = loc1 + " :";
                    }
                    loc3 = (loc3 + 1);
                }
                loc1 = loc1 + "\n";
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public function setupDefaultMap():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = (_mapWidth - 1);
            loc2 = (_mapHeight - 1);
            loc3 = _mapWidth >> 1;
            loc4 = _mapHeight >> 1;
            fillMapLine(0, loc3 - 3, 1, (1), 6);
            fillMapLine(0, loc3 - 4, 1, (1));
            fillMapLine(0, loc3 - 5, 1, -1);
            fillMapLine(0, loc3 - 6, 1, -1);
            fillMapLine(loc1, loc3 + 2, -1, -1);
            fillMapLine(loc1, loc3 + 3, -1, -1);
            fillMapLine(loc1, loc3 + 3, -1, 1);
            fillMapLine(loc1, loc3 + 4, -1, 1);
            return;
        }

        public function findPath(arg1:fai.Position, arg2:fai.Position, arg3:Boolean=false):Array
        {
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

            loc14 = null;
            loc15 = undefined;
            loc16 = null;
            trace("findPath(startPixelPos:" + arg1 + ", endPixelPos:" + arg2 + ", allowEscape:" + arg3 + ")");
            loc4 = new Astar(mapMatrix);
            loc5 = new Array();
            (loc6 = _myLife.zone.transformIsoToXy(arg1)).x = Math.round(loc6.x);
            loc6.y = Math.round(loc6.y);
            (loc7 = _myLife.zone.transformIsoToXy(arg2)).x = Math.round(loc7.x);
            loc7.y = Math.round(loc7.y);
            if (loc7.x < 0)
            {
                loc7.x = 0;
            }
            if (loc7.y < 0)
            {
                loc7.y = 0;
            }
            if (!((loc8 = loc4.search(loc6, loc7, loc5)).f == 0 && loc8.h == 0 && loc8.g == 0))
            {
                loc16 = loc8.pos;
                if (_myLife.zone.isApartmentMode() && arg3)
                {
                    if ((loc8 = loc4.search(loc7, loc6, [])).pos)
                    {
                        loc5 = [loc6, loc7];
                    }
                    else 
                    {
                        loc8 = loc4.search(loc6, loc16, loc5);
                    }
                }
                else 
                {
                    loc8 = loc4.search(loc6, loc16, loc5);
                }
            }
            (loc9 = getShortPath(loc5)).shift();
            loc10 = _myLife.zone.transformXyToIso(loc6);
            loc11 = arg1.x - loc10.x;
            loc12 = arg1.y - loc10.y;
            loc13 = new Array();
            loc17 = 0;
            loc18 = loc9;
            for each (loc14 in loc18)
            {
                loc14 = _myLife.zone.transformXyToIso(loc14);
                loc14.x = loc14.x + loc11;
                loc14.y = loc14.y + loc12;
                loc14.x = Math.round(loc14.x);
                loc14.y = Math.round(loc14.y);
                loc13.push(loc14);
            }
            loc13.unshift(arg1);
            loc15 = loc9[(loc9.length - 1)];
            return loc13;
        }

        private var _mapHeight:Number=0;

        private var _myLife:flash.display.MovieClip;

        private var _mapWidth:Number=0;

        public var mapMatrix:fai.MapMatrix;
    }
}
