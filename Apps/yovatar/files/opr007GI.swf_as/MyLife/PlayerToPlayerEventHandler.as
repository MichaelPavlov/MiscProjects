package MyLife 
{
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    
    public class PlayerToPlayerEventHandler extends flash.events.EventDispatcher
    {
        public function PlayerToPlayerEventHandler(arg1:flash.display.MovieClip)
        {
            super();
            _myLife = arg1;
            return;
        }

        internal function handlePlayerEvent(arg1:Object):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = arg1.from;
            loc3 = {};
            if (arg1.message.substr(0, 4) != "EVT:")
            {
                if (arg1.message.substr(0, 1) == "{")
                {
                    loc3 = JSON.decode(arg1.message);
                }
            }
            else 
            {
                loc3 = JSON.decode(arg1.message.substring(4));
            }
            (loc4 = {}).sender = loc2;
            loc4.type = loc3.t ? loc3.t : "";
            loc4.params = loc3.p ? loc3.p : {};
            dispatchPlayerEvent(loc4);
            return;
        }

        internal function dispatchPlayerEvent(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = null;
            loc3 = null;
            trace("dispatchPlayerEvent()");
            trace("\t\tplayerToPlayerEvent.type = " + arg1.type);
            loc4 = arg1.type;
            switch (loc4) 
            {
                case "TicTacToe2":
                    MyLifeTicTacToe.getInstance().handleEvent(arg1);
                    break;
                case "RPS":
                    MyLifeRockPaperScissors.getInstance().handleEvent(arg1);
                    break;
                case "BUDDYLIST":
                    MyLifeBuddyRequest.getInstance().handleEvent(arg1);
                    break;
                case "TRADE":
                    loc2 = new MyLifeEvent(MyLifeEvent.TRADE_RESPONSE, arg1);
                    this.dispatchEvent(loc2);
                    break;
                case "GIFT":
                    loc2 = new MyLifeEvent(MyLifeEvent.GIFT_RESPONSE, arg1);
                    this.dispatchEvent(loc2);
                    break;
                case "ITEMREQUEST":
                    if (arg1.params && arg1.params.eventName)
                    {
                        loc3 = arg1.params.eventName;
                        trace("\t\teventName = " + loc3);
                        loc2 = new MyLifeEvent(arg1.params.eventName, arg1);
                        this.dispatchEvent(loc2);
                    }
                    break;
                default:
                    break;
            }
            return;
        }

        private var _myLife:flash.display.MovieClip;
    }
}
