package com.hurlant.crypto.symmetric 
{
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class ECBMode extends Object implements com.hurlant.crypto.symmetric.IMode, com.hurlant.crypto.symmetric.ICipher
    {
        public function ECBMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super();
            this.key = arg1;
            if (arg2 != null)
            {
                arg2.setBlockSize(arg1.getBlockSize());
            }
            else 
            {
                arg2 = new PKCS5(arg1.getBlockSize());
            }
            this.padding = arg2;
            return;
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            padding.pad(arg1);
            arg1.position = 0;
            loc2 = key.getBlockSize();
            loc3 = new ByteArray();
            loc4 = new ByteArray();
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                loc3.length = 0;
                arg1.readBytes(loc3, 0, loc2);
                key.encrypt(loc3);
                loc4.writeBytes(loc3);
                loc5 = loc5 + loc2;
            }
            arg1.length = 0;
            arg1.writeBytes(loc4);
            return;
        }

        public function getBlockSize():uint
        {
            return key.getBlockSize();
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            arg1.position = 0;
            loc2 = key.getBlockSize();
            if (arg1.length % loc2 != 0)
            {
                throw new Error("ECB mode cipher length must be a multiple of blocksize " + loc2);
            }
            loc3 = new ByteArray();
            loc4 = new ByteArray();
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                loc3.length = 0;
                arg1.readBytes(loc3, 0, loc2);
                key.decrypt(loc3);
                loc4.writeBytes(loc3);
                loc5 = loc5 + loc2;
            }
            padding.unpad(loc4);
            arg1.length = 0;
            arg1.writeBytes(loc4);
            return;
        }

        public function toString():String
        {
            return key.toString() + "-ecb";
        }

        public function dispose():void
        {
            key.dispose();
            key = null;
            padding = null;
            Memory.gc();
            return;
        }

        private var key:com.hurlant.crypto.symmetric.ISymmetricKey;

        private var padding:com.hurlant.crypto.symmetric.IPad;
    }
}
