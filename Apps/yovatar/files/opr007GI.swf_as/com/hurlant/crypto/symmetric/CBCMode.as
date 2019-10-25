package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class CBCMode extends com.hurlant.crypto.symmetric.IVMode implements com.hurlant.crypto.symmetric.IMode
    {
        public function CBCMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super(arg1, arg2);
            return;
        }

        public function toString():String
        {
            return key.toString() + "-cbc";
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = 0;
            padding.pad(arg1);
            loc2 = getIV4e();
            loc3 = 0;
            while (loc3 < arg1.length) 
            {
                loc4 = 0;
                while (loc4 < blockSize) 
                {
                    arg1[(loc3 + loc4)] = arg1[(loc3 + loc4)] ^ loc2[loc4];
                    loc4 = (loc4 + 1);
                }
                key.encrypt(arg1, loc3);
                loc2.position = 0;
                loc2.writeBytes(arg1, loc3, blockSize);
                loc3 = loc3 + blockSize;
            }
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = 0;
            loc2 = getIV4d();
            loc3 = new ByteArray();
            loc4 = 0;
            while (loc4 < arg1.length) 
            {
                loc3.position = 0;
                loc3.writeBytes(arg1, loc4, blockSize);
                key.decrypt(arg1, loc4);
                loc5 = 0;
                while (loc5 < blockSize) 
                {
                    arg1[(loc4 + loc5)] = arg1[(loc4 + loc5)] ^ loc2[loc5];
                    loc5 = (loc5 + 1);
                }
                loc2.position = 0;
                loc2.writeBytes(loc3, 0, blockSize);
                loc4 = loc4 + blockSize;
            }
            padding.unpad(arg1);
            return;
        }
    }
}
