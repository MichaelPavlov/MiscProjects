package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class PKCS5 extends Object implements com.hurlant.crypto.symmetric.IPad
    {
        public function PKCS5(arg1:uint=0)
        {
            super();
            this.blockSize = arg1;
            return;
        }

        public function pad(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = blockSize - arg1.length % blockSize;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                arg1[arg1.length] = loc2;
                loc3 = (loc3 + 1);
            }
            return;
        }

        public function setBlockSize(arg1:uint):void
        {
            blockSize = arg1;
            return;
        }

        public function unpad(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = 0;
            loc2 = arg1.length % blockSize;
            if (loc2 != 0)
            {
                throw new Error("PKCS#5::unpad: ByteArray.length isn\'t a multiple of the blockSize");
            }
            loc2 = arg1[(arg1.length - 1)];
            loc3 = loc2;
            while (loc3 > 0) 
            {
                loc4 = arg1[(arg1.length - 1)];
                loc6 = ((loc5 = arg1).length - 1);
                loc5.length = loc6;
                if (loc2 != loc4)
                {
                    throw new Error("PKCS#5:unpad: Invalid padding value. expected [" + loc2 + "], found [" + loc4 + "]");
                }
                loc3 = (loc3 - 1);
            }
            return;
        }

        private var blockSize:uint;
    }
}
