package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class CFB8Mode extends com.hurlant.crypto.symmetric.IVMode implements com.hurlant.crypto.symmetric.IMode
    {
        public function CFB8Mode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super(arg1, null);
            return;
        }

        public function toString():String
        {
            return key.toString() + "-cfb8";
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc5 = 0;
            loc2 = getIV4e();
            loc3 = new ByteArray();
            loc4 = 0;
            while (loc4 < arg1.length) 
            {
                loc3.position = 0;
                loc3.writeBytes(loc2);
                key.encrypt(loc2);
                arg1[loc4] = arg1[loc4] ^ loc2[0];
                loc5 = 0;
                while (loc5 < (blockSize - 1)) 
                {
                    loc2[loc5] = loc3[(loc5 + 1)];
                    loc5 = (loc5 + 1);
                }
                loc2[(blockSize - 1)] = arg1[loc4];
                loc4 = (loc4 + 1);
            }
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = 0;
            loc6 = 0;
            loc2 = getIV4d();
            loc3 = new ByteArray();
            loc4 = 0;
            while (loc4 < arg1.length) 
            {
                loc5 = arg1[loc4];
                loc3.position = 0;
                loc3.writeBytes(loc2);
                key.encrypt(loc2);
                arg1[loc4] = arg1[loc4] ^ loc2[0];
                loc6 = 0;
                while (loc6 < (blockSize - 1)) 
                {
                    loc2[loc6] = loc3[(loc6 + 1)];
                    loc6 = (loc6 + 1);
                }
                loc2[(blockSize - 1)] = loc5;
                loc4 = (loc4 + 1);
            }
            return;
        }
    }
}
