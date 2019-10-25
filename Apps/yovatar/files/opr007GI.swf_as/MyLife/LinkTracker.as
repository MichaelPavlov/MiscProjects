package MyLife 
{
    import flash.net.*;
    
    public class LinkTracker extends Object
    {
        public function LinkTracker()
        {
            super();
            this.isActive = false;
            return;
        }

        public function zTrack(arg1:String, arg2:Number, arg3:String, arg4:String=null):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            loc6 = null;
            loc7 = null;
            if (isActive)
            {
                loc5 = "ztrackcount.php";
                loc6 = (loc6 = (loc6 = (loc6 = "?") + "cname=" + arg1) + "&u=" + String(arg2)) + "&k=" + arg3;
                if (arg4)
                {
                    loc6 = loc6 + "&p=" + arg4;
                }
                loc5 = loc5 + loc6;
                (loc7 = new URLLoader()).load(new URLRequest(loc5));
            }
            return;
        }

        public function setRandomActive(arg1:int=100):void
        {
            if (Math.floor(Math.random() * arg1) == 0)
            {
                this.isActive = true;
            }
            return;
        }

        public function track(arg1:String="", arg2:String="", arg3:String=""):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc7 = null;
            loc8 = null;
            trace("track(" + arg1 + "," + arg2 + "," + arg3 + ")");
            if (this.isActive)
            {
                loc4 = arg3 || BASE_URL;
                loc5 = "";
                if (arg1 || arg2)
                {
                    loc5 = "?";
                    loc7 = arg1 ? "link=" + arg1 : "";
                    loc8 = arg2 ? "client=" + arg2 : "client=" + DEFAULT_CLIENT;
                    if (loc7)
                    {
                        loc8 = "&" + loc8;
                    }
                    loc5 = loc5 + loc7 + loc8;
                }
                loc4 = loc4 + loc5;
                (loc6 = new URLLoader()).load(new URLRequest(loc4));
            }
            return;
        }

        private const BASE_URL:String="http://nav2.zynga.com/link/link.php";

        private const DEFAULT_CLIENT:String="1479";

        public var isActive:Boolean;
    }
}
