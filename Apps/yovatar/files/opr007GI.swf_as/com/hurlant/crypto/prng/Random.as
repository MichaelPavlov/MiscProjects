package com.hurlant.crypto.prng 
{
    import com.hurlant.util.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class Random extends Object
    {
        public function Random(arg1:Class=null)
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 0;
            super();
            if (arg1 == null)
            {
                arg1 = ARC4;
            }
            state = new arg1() as IPRNG;
            psize = state.getPoolSize();
            pool = new ByteArray();
            pptr = 0;
            while (pptr < psize) 
            {
                loc2 = 65536 * Math.random();
                loc3 = pptr++;
                pool[loc3] = loc2 >>> 8;
                pool[(loc4 = pptr++)] = loc2 & 255;
            }
            pptr = 0;
            seed();
            return;
        }

        public function autoSeed():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = null;
            loc1 = new ByteArray();
            loc1.writeUnsignedInt(System.totalMemory);
            loc1.writeUTF(Capabilities.serverString);
            loc1.writeUnsignedInt(getTimer());
            loc1.writeUnsignedInt(new Date().getTime());
            loc2 = Font.enumerateFonts(true);
            loc4 = 0;
            loc5 = loc2;
            for each (loc3 in loc5)
            {
                loc1.writeUTF(loc3.fontName);
                loc1.writeUTF(loc3.fontStyle);
                loc1.writeUTF(loc3.fontType);
            }
            loc1.position = 0;
            while (loc1.bytesAvailable >= 4) 
            {
                seed(loc1.readUnsignedInt());
            }
            return;
        }

        public function seed(arg1:int=0):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            if (arg1 == 0)
            {
                arg1 = new Date().getTime();
            }
            loc2 = pptr++;
            pool[loc2] = pool[loc2] ^ arg1 & 255;
            loc3 = pptr++;
            pool[loc3] = pool[loc3] ^ arg1 >> 8 & 255;
            pool[(loc4 = pptr++)] = pool[loc4] ^ arg1 >> 16 & 255;
            pool[(loc5 = pptr++)] = pool[loc5] ^ arg1 >> 24 & 255;
            pptr = pptr % psize;
            seeded = true;
            return;
        }

        public function toString():String
        {
            return "random-" + state.toString();
        }

        public function dispose():void
        {
            var loc1:*;

            loc1 = 0;
            while (loc1 < pool.length) 
            {
                pool[loc1] = Math.random() * 256;
                loc1 = (loc1 + 1);
            }
            pool.length = 0;
            pool = null;
            state.dispose();
            state = null;
            psize = 0;
            pptr = 0;
            Memory.gc();
            return;
        }

        public function nextBytes(arg1:flash.utils.ByteArray, arg2:int):void
        {
            while (arg2--) 
            {
                arg1.writeByte(nextByte());
            }
            return;
        }

        public function nextByte():int
        {
            if (!ready)
            {
                if (!seeded)
                {
                    autoSeed();
                }
                state.init(pool);
                pool.length = 0;
                pptr = 0;
                ready = true;
            }
            return state.next();
        }

        private var ready:Boolean=false;

        private var pool:flash.utils.ByteArray;

        private var seeded:Boolean=false;

        private var psize:int;

        private var state:com.hurlant.crypto.prng.IPRNG;

        private var pptr:int;
    }
}
