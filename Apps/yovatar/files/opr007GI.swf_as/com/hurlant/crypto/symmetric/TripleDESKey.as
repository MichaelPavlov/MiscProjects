package com.hurlant.crypto.symmetric 
{
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class TripleDESKey extends com.hurlant.crypto.symmetric.DESKey
    {
        public function TripleDESKey(arg1:flash.utils.ByteArray)
        {
            super(arg1);
            encKey2 = generateWorkingKey(false, arg1, 8);
            decKey2 = generateWorkingKey(true, arg1, 8);
            if (arg1.length > 16)
            {
                encKey3 = generateWorkingKey(true, arg1, 16);
                decKey3 = generateWorkingKey(false, arg1, 16);
            }
            else 
            {
                encKey3 = encKey;
                decKey3 = decKey;
            }
            return;
        }

        public override function encrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void
        {
            desFunc(encKey, arg1, arg2, arg1, arg2);
            desFunc(encKey2, arg1, arg2, arg1, arg2);
            desFunc(encKey3, arg1, arg2, arg1, arg2);
            return;
        }

        public override function dispose():void
        {
            var loc1:*;

            super.dispose();
            loc1 = 0;
            if (encKey2 != null)
            {
                loc1 = 0;
                while (loc1 < encKey2.length) 
                {
                    encKey2[loc1] = 0;
                    loc1 = (loc1 + 1);
                }
                encKey2 = null;
            }
            if (encKey3 != null)
            {
                loc1 = 0;
                while (loc1 < encKey3.length) 
                {
                    encKey3[loc1] = 0;
                    loc1 = (loc1 + 1);
                }
                encKey3 = null;
            }
            if (decKey2 != null)
            {
                loc1 = 0;
                while (loc1 < decKey2.length) 
                {
                    decKey2[loc1] = 0;
                    loc1 = (loc1 + 1);
                }
                decKey2 = null;
            }
            if (decKey3 != null)
            {
                loc1 = 0;
                while (loc1 < decKey3.length) 
                {
                    decKey3[loc1] = 0;
                    loc1 = (loc1 + 1);
                }
                decKey3 = null;
            }
            Memory.gc();
            return;
        }

        public override function decrypt(arg1:flash.utils.ByteArray, arg2:uint=0):void
        {
            desFunc(decKey3, arg1, arg2, arg1, arg2);
            desFunc(decKey2, arg1, arg2, arg1, arg2);
            desFunc(decKey, arg1, arg2, arg1, arg2);
            return;
        }

        public override function toString():String
        {
            return "3des";
        }

        protected var encKey2:Array;

        protected var encKey3:Array;

        protected var decKey2:Array;

        protected var decKey3:Array;
    }
}
