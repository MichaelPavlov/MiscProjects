package MyLife 
{
    public class MyLifeGameManager extends Object
    {
        public function MyLifeGameManager()
        {
            super();
            if (_instance != null)
            {
                throw new Error("MyLifeGameManager: Please use getInstance() to access class.");
            }
            return;
        }

        public function getActiveGameCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc1 = 0;
            loc3 = 0;
            loc4 = gameHandlerCollection;
            for each (loc2 in loc4)
            {
                loc1 = loc1 + loc2.getActiveGameCount();
            }
            return loc1;
        }

        public function getActiveWindowCount():int
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc1 = 0;
            loc3 = 0;
            loc4 = gameHandlerCollection;
            for each (loc2 in loc4)
            {
                loc1 = loc1 + loc2.getActiveWindowCount();
            }
            return loc1;
        }

        public function handleUserLeave(arg1:*):*
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc2 = undefined;
            loc3 = 0;
            loc4 = gameHandlerCollection;
            for each (loc2 in loc4)
            {
                loc2.handleUserLeave(arg1);
            }
            return;
        }

        public function closeWindows():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = undefined;
            loc2 = 0;
            loc3 = gameHandlerCollection;
            for each (loc1 in loc3)
            {
                loc1.closeWindows();
            }
            return;
        }

        private static function initSingleton():*
        {
            initialized = true;
            gameHandlerCollection.push(MyLifeTicTacToe.getInstance());
            gameHandlerCollection.push(MyLifeRockPaperScissors.getInstance());
            return;
        }

        public static function getInstance():MyLife.MyLifeGameManager
        {
            if (!initialized)
            {
                initSingleton();
            }
            return _instance;
        }

        
        {
            gameHandlerCollection = [];
            initialized = false;
        }

        private static const _instance:MyLife.MyLifeGameManager=new MyLifeGameManager();

        private static var initialized:Boolean=false;

        private static var gameHandlerCollection:Array;
    }
}
