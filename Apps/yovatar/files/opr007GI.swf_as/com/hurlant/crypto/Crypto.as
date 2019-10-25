package com.hurlant.crypto 
{
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.prng.*;
    import com.hurlant.crypto.rsa.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class Crypto extends Object
    {
        public function Crypto()
        {
            super();
            return;
        }

        public static function getCipher(arg1:String, arg2:flash.utils.ByteArray, arg3:com.hurlant.crypto.symmetric.IPad=null):com.hurlant.crypto.symmetric.ICipher
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc5 = null;
            loc4 = arg1.split("-");
            loc6 = loc4[0];
            switch (loc6) 
            {
                case "simple":
                    loc4.shift();
                    arg1 = loc4.join("-");
                    if ((loc5 = getCipher(arg1, arg2, arg3)) as IVMode)
                    {
                        return new SimpleIVMode(loc5 as IVMode);
                    }
                    return loc5;
                case "aes":
                case "aes128":
                case "aes192":
                case "aes256":
                    loc4.shift();
                    if (arg2.length * 8 == loc4[0])
                    {
                        loc4.shift();
                    }
                    return getMode(loc4[0], new AESKey(arg2), arg3);
                case "bf":
                case "blowfish":
                    loc4.shift();
                    return getMode(loc4[0], new BlowFishKey(arg2), arg3);
                case "des":
                    loc4.shift();
                    if (!(loc4[0] == "ede") && !(loc4[0] == "ede3"))
                    {
                        return getMode(loc4[0], new DESKey(arg2), arg3);
                    }
                    if (loc4.length == 1)
                    {
                        loc4.push("ecb");
                    }
                case "3des":
                case "des3":
                    loc4.shift();
                    return getMode(loc4[0], new TripleDESKey(arg2), arg3);
                case "xtea":
                    loc4.shift();
                    return getMode(loc4[0], new XTeaKey(arg2), arg3);
                case "rc4":
                    loc4.shift();
                    return new ARC4(arg2);
            }
            return null;
        }

        public static function getHash(arg1:String):com.hurlant.crypto.hash.IHash
        {
            var loc2:*;

            loc2 = arg1;
            switch (loc2) 
            {
                case "md2":
                    return new MD2();
                case "md5":
                    return new MD5();
                case "sha":
                case "sha1":
                    return new SHA1();
                case "sha224":
                    return new SHA224();
                case "sha256":
                    return new SHA256();
            }
            return null;
        }

        public static function getRSA(arg1:String, arg2:String):com.hurlant.crypto.rsa.RSAKey
        {
            return RSAKey.parsePublicKey(arg2, arg1);
        }

        private static function getMode(arg1:String, arg2:com.hurlant.crypto.symmetric.ISymmetricKey, arg3:com.hurlant.crypto.symmetric.IPad=null):com.hurlant.crypto.symmetric.IMode
        {
            var loc4:*;

            loc4 = arg1;
            switch (loc4) 
            {
                case "ecb":
                    return new ECBMode(arg2, arg3);
                case "cfb":
                    return new CFBMode(arg2, arg3);
                case "cfb8":
                    return new CFB8Mode(arg2, arg3);
                case "ofb":
                    return new OFBMode(arg2, arg3);
                case "ctr":
                    return new CTRMode(arg2, arg3);
                case "cbc":
                default:
                    return new CBCMode(arg2, arg3);
            }
        }

        public static function getKeySize(arg1:String):uint
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.split("-");
            loc3 = loc2[0];
            switch (loc3) 
            {
                case "simple":
                    loc2.shift();
                    return getKeySize(loc2.join("-"));
                case "aes128":
                    return 16;
                case "aes192":
                    return 24;
                case "aes256":
                    return 32;
                case "aes":
                    loc2.shift();
                    return parseInt(loc2[0]) / 8;
                case "bf":
                case "blowfish":
                    return 16;
                case "des":
                    loc2.shift();
                    loc3 = loc2[0];
                    switch (loc3) 
                    {
                        case "ede":
                            return 16;
                        case "ede3":
                            return 24;
                        default:
                            return 8;
                    }
                case "3des":
                case "des3":
                    return 24;
                case "xtea":
                    return 8;
                case "rc4":
                    if (parseInt(loc2[1]) > 0)
                    {
                        return parseInt(loc2[1]) / 8;
                    }
                    return 16;
            }
            return 0;
        }

        public static function getPad(arg1:String):com.hurlant.crypto.symmetric.IPad
        {
            var loc2:*;

            loc2 = arg1;
            switch (loc2) 
            {
                case "null":
                    return new NullPad();
                case "pkcs5":
                default:
                    return new PKCS5();
            }
        }

        public static function getHMAC(arg1:String):com.hurlant.crypto.hash.HMAC
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.split("-");
            if (loc2[0] == "hmac")
            {
                loc2.shift();
            }
            loc3 = 0;
            if (loc2.length > 1)
            {
                loc3 = parseInt(loc2[1]);
            }
            return new HMAC(getHash(loc2[0]), loc3);
        }

        private var b64:com.hurlant.util.Base64;
    }
}
