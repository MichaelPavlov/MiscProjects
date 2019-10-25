package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class CFBMode extends com.hurlant.crypto.symmetric.IVMode implements com.hurlant.crypto.symmetric.IMode
    {
        public function CFBMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super(arg1, null);
            return;
        }

        public function toString():String
        {
            return key.toString() + "-cfb";
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = 0;
            loc6 = 0;
            loc2 = arg1.length;
            loc3 = getIV4e();
            loc4 = 0;
            while (loc4 < arg1.length) 
            {
                key.encrypt(loc3);
                loc5 = (loc4 + blockSize < loc2) ? blockSize : loc2 - loc4;
                loc6 = 0;
                while (loc6 < loc5) 
                {
                    arg1[(loc4 + loc6)] = arg1[(loc4 + loc6)] ^ loc3[loc6];
                    loc6 = (loc6 + 1);
                }
                loc3.position = 0;
                loc3.writeBytes(arg1, loc4, loc5);
                loc4 = loc4 + blockSize;
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
            var loc7:*;

            loc6 = 0;
            loc7 = 0;
            loc2 = arg1.length;
            loc3 = getIV4d();
            loc4 = new ByteArray();
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                key.encrypt(loc3);
                loc6 = (loc5 + blockSize < loc2) ? blockSize : loc2 - loc5;
                loc4.position = 0;
                loc4.writeBytes(arg1, loc5, loc6);
                loc7 = 0;
                while (loc7 < loc6) 
                {
                    arg1[(loc5 + loc7)] = arg1[(loc5 + loc7)] ^ loc3[loc7];
                    loc7 = (loc7 + 1);
                }
                loc3.position = 0;
                loc3.writeBytes(loc4);
                loc5 = loc5 + blockSize;
            }
            return;
        }
    }
}
