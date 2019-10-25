package MyLife 
{
    import fl.motion.easing.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    import gs.*;
    
    public class MyLifeSoundController extends Object
    {
        public function MyLifeSoundController()
        {
            bgSoundCollection = [];
            super();
            if (_instance != null)
            {
                throw new Error("Please use getInstance() to access class.");
            }
            return;
        }

        private function ioErrorHandler(arg1:flash.events.Event):Boolean
        {
            trace("ioErrorHandler: " + arg1);
            return false;
        }

        private function loadBgSound(arg1:*):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            if (bgSoundCollection[arg1])
            {
                return bgSoundCollection[arg1];
            }
            loc2 = MyLifeInstance.getInstance().myLifeConfiguration.variables["global"]["audio_path"] + arg1 + ".mp3";
            loc3 = new Sound();
            loc3.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            loc4 = new URLRequest(loc2);
            loc3.load(loc4);
            bgSoundCollection[arg1] = {"sound":loc3, "channel":null, "position":0, "volume":0};
            return bgSoundCollection[arg1];
        }

        public function playClassSound(arg1:Class):void
        {
            var loc2:*;

            loc2 = null;
            if (!isMuted)
            {
                loc2 = new arg1();
                loc2.play();
            }
            return;
        }

        public function unMute():*
        {
            isMuted = false;
            playBgSound(unMuteBgSound);
            soundObj = SharedObject.getLocal("isMute");
            soundObj.data.isMute = 0;
            soundObj.flush();
            return;
        }

        private function adjustSoundVolumeComplete(arg1:*):*
        {
            if (arg1.volume <= 0)
            {
                arg1.channel.stop();
                arg1.playing = false;
            }
            return;
        }

        public function mute():*
        {
            playBgSound("stop");
            isMuted = true;
            soundObj = SharedObject.getLocal("isMute");
            soundObj.data.isMute = 1;
            soundObj.flush();
            return;
        }

        public function loadLastSettings():void
        {
            soundObj = SharedObject.getLocal("isMute");
            if (soundObj.size > 0)
            {
                if (soundObj.data.isMute == 1)
                {
                    mute();
                    MyLifeInstance.getInstance().getInterface().interfaceHUD.onBtnMuteClick();
                }
            }
            return;
        }

        private function fadeSoundVolume(arg1:*, arg2:*, arg3:*):void
        {
            var loc4:*;

            loc4 = Linear.easeOut;
            TweenLite.to(arg1, arg3, {"volume":arg2, "ease":Linear.easeOut, "onUpdate":adjustSoundVolume, "onUpdateParams":[arg1], "onComplete":adjustSoundVolumeComplete, "onCompleteParams":[arg1]});
            return;
        }

        public function playBgSound(arg1:String):void
        {
            var loc2:*;

            loc2 = undefined;
            trace("playBgSound(" + arg1 + ")");
            if (arg1 == "")
            {
                return;
            }
            if (isMuted)
            {
                unMuteBgSound = arg1;
                return;
            }
            if (arg1.toLowerCase() != "stop")
            {
                unMuteBgSound = arg1;
                loc2 = loadBgSound(arg1);
                if (loc2 && loc2.playing)
                {
                    return;
                }
            }
            if (currentBgSoundObj)
            {
                if (currentBgSoundObj.channel)
                {
                    currentBgSoundObj.position = currentBgSoundObj.channel.position;
                    fadeSoundVolume(currentBgSoundObj, 0, FADE_OUT_DURATION);
                }
            }
            if (arg1.toLowerCase() == "stop")
            {
                currentBgSoundObj = null;
                return;
            }
            trace("", "init playing sound...");
            if (loc2.channel)
            {
                trace("", "", "channel exists");
                loc2.channel = loc2.sound.play(loc2.position, 9000);
            }
            else 
            {
                trace("", "", "make new chanel");
                loc2.channel = loc2.sound.play(0, 9000);
            }
            loc2.volume = 0;
            loc2.playing = true;
            fadeSoundVolume(loc2, MAX_VOLUME, FADE_IN_DURATION);
            currentBgSoundObj = loc2;
            return;
        }

        public function playLibrarySound(arg1:*):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = null;
            loc3 = null;
            if (!isMuted)
            {
                loc2 = getDefinitionByName(arg1) as Class;
                loc3 = new loc2();
                loc3.play();
            }
            return;
        }

        private function adjustSoundVolume(arg1:*):void
        {
            arg1.channel.soundTransform = new SoundTransform(arg1.volume);
            return;
        }

        public static function getInstance():MyLife.MyLifeSoundController
        {
            return _instance;
        }

        
        {
            isMuted = false;
        }

        private const FADE_IN_DURATION:Number=2;

        private const FADE_OUT_DURATION:Number=1;

        private const MAX_VOLUME:Number=0.2;

        private static const _instance:MyLife.MyLifeSoundController=new MyLifeSoundController();

        private var bgSoundCollection:Array;

        private var unMuteBgSound:String="";

        private var currentBgSoundObj:Object;

        private var soundObj:flash.net.SharedObject;

        public static var isMuted:Boolean=false;
    }
}
