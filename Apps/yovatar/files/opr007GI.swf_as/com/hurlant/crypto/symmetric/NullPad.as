package com.hurlant.crypto.symmetric 
{
    import flash.utils.*;
    
    public class NullPad extends Object implements com.hurlant.crypto.symmetric.IPad
    {
        public function NullPad()
        {
            super();
            return;
        }

        public function unpad(arg1:flash.utils.ByteArray):void
        {
            return;
        }

        public function pad(arg1:flash.utils.ByteArray):void
        {
            return;
        }

        public function setBlockSize(arg1:uint):void
        {
            return;
        }
    }
}
