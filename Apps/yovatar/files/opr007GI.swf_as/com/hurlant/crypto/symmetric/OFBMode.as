package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class OFBMode extends com.hurlant.crypto.symmetric.IVMode implements com.hurlant.crypto.symmetric.IMode
    {
        public function OFBMode(arg1:com.hurlant.crypto.symmetric.ISymmetricKey, arg2:com.hurlant.crypto.symmetric.IPad=null)
        {
            super(arg1, null);
            return;
        }

        private function core(arg1:flash.utils.ByteArray, arg2:flash.utils.ByteArray):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = 0;
            loc7 = 0;
            loc3 = arg1.length;
            loc4 = new ByteArray();
            loc5 = 0;
            while (loc5 < arg1.length) 
            {
                key.encrypt(arg2);
                loc4.position = 0;
                loc4.writeBytes(arg2);
                loc6 = (loc5 + blockSize < loc3) ? blockSize : loc3 - loc5;
                loc7 = 0;
                while (loc7 < loc6) 
                {
                    arg1[(loc5 + loc7)] = arg1[(loc5 + loc7)] ^ arg2[loc7];
                    loc7 = (loc7 + 1);
                }
                arg2.position = 0;
                arg2.writeBytes(loc4);
                loc5 = loc5 + blockSize;
            }
            return;
        }

        public function toString():String
        {
            return key.toString() + "-ofb";
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            loc2 = getIV4e();
            core(arg1, loc2);
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            loc2 = getIV4d();
            core(arg1, loc2);
            return;
        }
    }
}
