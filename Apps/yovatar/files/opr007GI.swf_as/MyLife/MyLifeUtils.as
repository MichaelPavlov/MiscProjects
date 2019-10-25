package MyLife 
{
    import com.hurlant.crypto.*;
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.util.*;
    import flash.utils.*;
    
    public class MyLifeUtils extends Object
    {
        public function MyLifeUtils()
        {
            super();
            return;
        }

        public static function peekArray(arg1:*, arg2:int=0):*
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = undefined;
            loc3 = 0;
            loc5 = 0;
            loc6 = arg1;
            for each (loc4 in loc6)
            {
                if (loc3 == arg2)
                {
                    return loc4;
                }
                ++loc3;
            }
            return null;
        }

        public static function compress(arg1:String):String
        {
            var loc2:*;

            if (arg1 == null || isCompressed(arg1))
            {
                return arg1;
            }
            loc2 = new ByteArray();
            loc2.writeUTFBytes(arg1);
            loc2.compress();
            return "GZ" + Base64.encodeByteArray(loc2);
        }

        public static function encrypt(arg1:String, arg2:String):String
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = Base64.decodeToByteArray(SALT + arg2);
            loc4 = Hex.toArray(Hex.fromString(arg1));
            loc5 = new NullPad();
            loc6 = Crypto.getCipher("simple-aes128", loc3, loc5);
            loc5.setBlockSize(loc6.getBlockSize());
            loc6.encrypt(loc4);
            return Base64.encodeByteArray(loc4);
        }

        public static function deepTrace(arg1:*, arg2:int=0):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            loc3 = "";
            loc4 = 0;
            while (loc4 < arg2) 
            {
                ++loc4;
                loc3 = loc3 + "\t";
            }
            loc6 = 0;
            loc7 = arg1;
            for (loc5 in loc7)
            {
                trace(loc3 + "[" + loc5 + "] => " + arg1[loc5]);
                deepTrace(arg1[loc5], arg2 + 1);
            }
            return;
        }

        public static function uncompress(arg1:String):String
        {
            var loc2:*;

            if (!isCompressed(arg1))
            {
                return arg1;
            }
            loc2 = Base64.decodeToByteArray(arg1.substr(2));
            loc2.uncompress();
            return loc2.toString();
        }

        public static function isCompressed(arg1:String):Boolean
        {
            if (!(arg1 == null) && arg1.charAt(0) == "G" && arg1.charAt(1) == "Z")
            {
                return true;
            }
            return false;
        }

        public static function cloneObject(arg1:Object):*
        {
            var loc2:*;

            loc2 = new ByteArray();
            loc2.writeObject(arg1);
            loc2.position = 0;
            return loc2.readObject();
        }

        public static function decrypt(arg1:String, arg2:String):String
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = Base64.decodeToByteArray(SALT + arg2);
            loc4 = Base64.decodeToByteArray(arg1);
            loc5 = new NullPad();
            loc6 = Crypto.getCipher("simple-aes128", loc3, loc5);
            loc5.setBlockSize(loc6.getBlockSize());
            loc6.decrypt(loc4);
            return Hex.toString(Hex.fromArray(loc4));
        }

        public static function hash(arg1:String):String
        {
            var loc2:*;
            var loc3:*;

            loc2 = new MD5();
            loc3 = loc2.hash(Base64.decodeToByteArray(arg1));
            return Base64.encodeByteArray(loc3);
        }

        private static const SALT:String="2a716a175fe550f7";
    }
}
