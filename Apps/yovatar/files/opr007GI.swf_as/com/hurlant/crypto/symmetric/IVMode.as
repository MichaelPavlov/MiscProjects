package com.hurlant.crypto.symmetric 
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class IVMode extends Object
    {
        public function IVMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super();
            this.key = arg1;
            blockSize = arg1.getBlockSize();
            if (arg2 != null)
            {
                arg2.setBlockSize(blockSize);
            }
            else 
            {
                arg2 = new PKCS5(blockSize);
            }
            this.padding = arg2;
            prng = new Random();
            iv = null;
            lastIV = new ByteArray();
            return;
        }

        public function set IV(arg1:flash.utils.ByteArray):void
        {
            iv = arg1;
            lastIV.length = 0;
            lastIV.writeBytes(iv);
            return;
        }

        protected function getIV4d():flash.utils.ByteArray
        {
            var loc1:*;

            loc1 = new ByteArray();
            if (iv)
            {
                loc1.writeBytes(iv);
            }
            else 
            {
                throw new Error("an IV must be set before calling decrypt()");
            }
            return loc1;
        }

        protected function getIV4e():flash.utils.ByteArray
        {
            var loc1:*;

            loc1 = new ByteArray();
            if (iv)
            {
                loc1.writeBytes(iv);
            }
            else 
            {
                prng.nextBytes(loc1, blockSize);
            }
            lastIV.length = 0;
            lastIV.writeBytes(loc1);
            return loc1;
        }

        public function get IV():flash.utils.ByteArray
        {
            return lastIV;
        }

        public function dispose():void
        {
            var loc1:*;

            loc1 = 0;
            if (iv != null)
            {
                loc1 = 0;
                while (loc1 < iv.length) 
                {
                    iv[loc1] = prng.nextByte();
                    loc1 = (loc1 + 1);
                }
                iv.length = 0;
                iv = null;
            }
            if (lastIV != null)
            {
                loc1 = 0;
                while (loc1 < iv.length) 
                {
                    lastIV[loc1] = prng.nextByte();
                    loc1 = (loc1 + 1);
                }
                lastIV.length = 0;
                lastIV = null;
            }
            key.dispose();
            key = null;
            padding = null;
            prng.dispose();
            prng = null;
            Memory.gc();
            return;
        }

        public function getBlockSize():uint
        {
            return key.getBlockSize();
        }

        protected var lastIV:flash.utils.ByteArray;

        protected var iv:flash.utils.ByteArray;

        protected var blockSize:uint;

        protected var padding:com.hurlant.crypto.symmetric.IPad;

        protected var prng:com.hurlant.crypto.prng.Random;

        protected var key:com.hurlant.crypto.symmetric.ISymmetricKey;
    }
}
