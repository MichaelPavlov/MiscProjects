package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class CTRMode extends com.hurlant.crypto.symmetric.IVMode implements com.hurlant.crypto.symmetric.IMode
    {
        public function CTRMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super(arg1, arg2);
            return;
        }

        private function core(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc6 = 0;
            loc3 = new ByteArray();
            loc4 = new ByteArray();
            loc3.writeBytes(arg2);
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                loc4.position = 0;
                loc4.writeBytes(loc3);
                key.encrypt(loc4);
                loc6 = 0;
                while (loc6 < blockSize) 
                {
                    arg1[(loc5 + loc6)] = arg1[(loc5 + loc6)] ^ loc4[loc6];
                    loc6 = (loc6 + 1);
                }
                loc6 = (blockSize - 1);
                while (loc6 >= 0) 
                {
                    loc9 = ((loc7 = loc3)[(loc8 = loc6)] + 1);
                    loc7[loc8] = loc9;
                    if (loc3[loc6] != 0)
                    {
                        break;
                    }
                    loc6 = (loc6 - 1);
                }
                loc5 = loc5 + blockSize;
            }
            return;
        }

        public function toString():String
        {
            return key.toString() + "-ctr";
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            padding.pad(arg1);
            loc2 = getIV4e();
            core(arg1, loc2);
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            loc2 = getIV4d();
            core(arg1, loc2);
            padding.unpad(arg1);
            return;
        }
    }
}
