package com.hurlant.crypto.symmetric 
{
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class SimpleIVMode extends Object implements com.hurlant.crypto.symmetric.IMode, com.hurlant.crypto.symmetric.ICipher
    {
        public function SimpleIVMode(arg1:com.hurlant.crypto.symmetric.IVMode)
        {
            super();
            this.mode = arg1;
            cipher = arg1 as ICipher;
            return;
        }

        public function encrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            cipher.encrypt(arg1);
            loc2 = new ByteArray();
            loc2.writeBytes(mode.IV);
            loc2.writeBytes(arg1);
            arg1.position = 0;
            arg1.writeBytes(loc2);
            return;
        }

        public function decrypt(arg1:flash.utils.ByteArray):void
        {
            var loc2:*;

            loc2 = new ByteArray();
            loc2.writeBytes(arg1, 0, getBlockSize());
            mode.IV = loc2;
            loc2 = new ByteArray();
            loc2.writeBytes(arg1, getBlockSize());
            cipher.decrypt(loc2);
            arg1.length = 0;
            arg1.writeBytes(loc2);
            return;
        }

        public function dispose():void
        {
            mode.dispose();
            mode = null;
            cipher = null;
            Memory.gc();
            return;
        }

        public function getBlockSize():uint
        {
            return mode.getBlockSize();
        }

        public function toString():String
        {
            return "simple-" + cipher.toString();
        }

        protected var mode:com.hurlant.crypto.symmetric.IVMode;

        protected var cipher:com.hurlant.crypto.symmetric.ICipher;
    }
}
