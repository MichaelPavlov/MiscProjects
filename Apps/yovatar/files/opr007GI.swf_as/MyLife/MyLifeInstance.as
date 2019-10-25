package MyLife 
{
    import flash.display.*;
    
    public class MyLifeInstance extends Object
    {
        public function MyLifeInstance()
        {
            super();
            if (_instance != null)
            {
                throw new Error("MyLifeInstance: Please use getInstance() to access class.");
            }
            return;
        }

        public function setMyLifeInstance(arg1:flash.display.MovieClip):void
        {
            _myLife = arg1;
            return;
        }

        public static function getInstance():flash.display.MovieClip
        {
            _myLife = _myLife || new MovieClip();
            return _myLife;
        }

        public static function getClassInstance():MyLife.MyLifeInstance
        {
            return _instance;
        }

        public static const RIGHT_FRONT:Number=0;

        public static const RIGHT_BACK:Number=2;

        public static const LEFT_FRONT:Number=1;

        private static const _instance:MyLife.MyLifeInstance=new MyLifeInstance();

        public static const LEFT_BACK:Number=3;

        private static var _myLife:flash.display.MovieClip;
    }
}
