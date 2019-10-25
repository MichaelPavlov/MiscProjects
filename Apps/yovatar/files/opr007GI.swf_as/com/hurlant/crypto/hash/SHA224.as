package com.hurlant.crypto.hash 
{
    public class SHA224 extends com.hurlant.crypto.hash.SHA256
    {
        public function SHA224()
        {
            super();
            h = [3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428];
            return;
        }

        public override function getHashSize():uint
        {
            return 28;
        }

        public override function toString():String
        {
            return "sha224";
        }
    }
}
