package fai 
{
    public class Astar extends Object
    {
        public function Astar(arg1:fai.MapMatrix)
        {
            super();
            checkxy = checkwall;
            map = arg1;
            return;
        }

        public function checkwall(arg1:Number, arg2:Number):Boolean
        {
            return !(Consts.Wall == map.getxy(arg1, arg2));
        }

        public function search(arg1:fai.Position, arg2:fai.Position, arg3:Array):fai.AstarNode
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
            var loc19:*;
            var loc20:*;

            loc13 = null;
            loc16 = null;
            loc17 = null;
            loc18 = undefined;
            nextbestpos = null;
            ns = new Array();
            arg3.length = 0;
            (loc4 = new AstarNode()).f = 1000;
            loc4.h = 1000;
            loc4.g = 1000;
            loc4.pos = arg1;
            opened = new AstarMap();
            closed = new AstarMap();
            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            loc8 = 0;
            loc9 = null;
            loc10 = null;
            loc11 = new AstarNode();
            loc12 = null;
            loc11.pos = arg1;
            loc11.h = loc19 = hestimate(arg1, arg2);
            loc11.f = loc19;
            opened.add(loc11.key(), loc11);
            loc14 = new AstarNode();
            loc15 = 0;
            while (!opened.empty() && loc15 < 1000) 
            {
                loc15 = (loc15 + 1);
                (loc14 = new AstarNode()).h = 1000;
                loc19 = 0;
                loc20 = opened.values;
                for each (loc13 in loc20)
                {
                    if (!(loc13.score() < loc14.score()))
                    {
                        continue;
                    }
                    loc14 = loc13;
                }
                if (!((loc12 = loc14) && loc12.pos))
                {
                    continue;
                }
                opened.remove(loc12.pos.x * 1000 + loc12.pos.y);
                if (loc12.pos.isequal(arg2))
                {
                    loc17 = loc12;
                    while (loc17 != loc11) 
                    {
                        arg3.unshift(loc17.pos);
                        loc17 = loc17.parent;
                    }
                    arg3.unshift(arg1);
                    return new AstarNode();
                }
                neighbours(loc12.pos);
                nextbestpos = null;
                loc19 = 0;
                loc20 = ns;
                for each (loc16 in loc20)
                {
                    loc5 = loc12.g + gestimate(loc12.pos, loc16);
                    loc6 = hestimate(loc16, arg2);
                    loc8 = loc5 + loc6;
                    if ((loc9 = opened.get(loc16.x * 1000 + loc16.y)) && loc9.f <= loc8)
                    {
                        continue;
                    }
                    if ((loc10 = closed.get(loc16.x * 1000 + loc16.y)) && loc10.f <= loc8)
                    {
                        continue;
                    }
                    if (loc9)
                    {
                        opened.remove(loc9.key());
                    }
                    if (loc10)
                    {
                        closed.remove(loc10.key());
                    }
                    (loc18 = new AstarNode()).pos = loc16;
                    loc18.g = loc5;
                    loc18.h = loc6;
                    loc18.f = loc8;
                    loc18.parent = loc12;
                    if (loc18.h < loc4.h)
                    {
                        loc4 = loc18;
                    }
                    else 
                    {
                        if (loc18.h == loc4.h)
                        {
                            if (loc18.g <= loc4.g)
                            {
                                loc4 = loc18;
                            }
                        }
                    }
                    opened.add(loc18.key(), loc18);
                }
                closed.add(loc12.key(), loc12);
            }
            trace("end");
            return loc4;
        }

        public function checkwallid(arg1:Number, arg2:Number):Boolean
        {
            var loc3:*;

            loc3 = map.getxy(arg1, arg2);
            return !(loc3 == Consts.Wall) && !(loc3 == tid);
        }

        public function neighbours(arg1:fai.Position):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc4 = undefined;
            ns.length = 0;
            loc3 = -1;
            while (loc3 <= 1) 
            {
                loc4 = -1;
                while (loc4 <= 1) 
                {
                    if (!(loc3 == 0 && loc4 == 0))
                    {
                        loc2 = new Position(arg1.x + loc3, arg1.y + loc4);
                        if (loc2.x >= 0 && loc2.y >= 0 && loc2.x < map.h && loc2.y < map.v)
                        {
                            if (checkxy(loc2.x, loc2.y))
                            {
                                ns.push(loc2);
                            }
                        }
                    }
                    loc4 = (loc4 + 1);
                }
                loc3 = (loc3 + 1);
            }
            return;
        }

        public function gestimate(arg1:fai.Position, arg2:fai.Position, arg3:Boolean=false):Number
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc7 = undefined;
            loc8 = undefined;
            loc4 = Math.abs(arg1.x - arg2.x);
            loc5 = Math.abs(arg1.y - arg2.y);
            if (arg3)
            {
                trace("Delta: " + loc4 + " / " + loc5);
            }
            if ((loc6 = loc4 + loc5) == 2)
            {
                loc6 = 1.4;
                loc7 = new Position(arg1.x, arg2.y);
                loc8 = new Position(arg2.x, arg1.y);
                if (map.getpos(loc7) > 0 || map.getpos(loc8) > 0)
                {
                    loc6 = 100;
                }
            }
            return loc6 * 10;
        }

        public function hestimate(arg1:fai.Position, arg2:fai.Position, arg3:Boolean=false):Number
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = Math.abs(arg1.x - arg2.x);
            loc5 = Math.abs(arg1.y - arg2.y);
            if (arg3)
            {
                trace("Delta: " + loc4 + " / " + loc5);
            }
            return (loc6 = loc4 + loc5) * 10;
        }

        private var ns:Array=null;

        private var opened:fai.AstarMap=null;

        private var closed:fai.AstarMap=null;

        public var tid:Number=0;

        public var checkxy:Function=null;

        public var map:fai.MapMatrix=null;

        private var nextbestpos:fai.Position=null;
    }
}
