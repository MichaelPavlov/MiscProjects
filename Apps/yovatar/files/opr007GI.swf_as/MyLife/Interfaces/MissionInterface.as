package MyLife.Interfaces 
{
    import MyLife.*;
    import MyLife.NPC.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class MissionInterface extends flash.display.MovieClip
    {
        public function MissionInterface()
        {
            x = 15;
            y = 95;
            alpha = 0;
            Tweener.addTween(this, {"time":1, "alpha":1});
            super();
            btnIgnore.addEventListener(MouseEvent.CLICK, onBtnIgnoreClick, false, 0, true);
            btnEngage.addEventListener(MouseEvent.CLICK, onBtnEngageClick, false, 0, true);
            btnNext.addEventListener(MouseEvent.CLICK, onBtnNextClick, false, 0, true);
            btnEngage.mouseChildren = false;
            btnEngage.buttonMode = true;
            characterPlaceholder.mouseChildren = false;
            return;
        }

        public function setData(arg1:String="", arg2:String="Go To Mission", arg3:Object=null, arg4:MyLife.NPC.SimpleNPC=null):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;

            description.text = arg1;
            loc5 = btnEngage["buttonTextField"] as TextField;
            loc6 = btnEngage["buttonGraphic"] as MovieClip;
            loc5.htmlText = "<b>" + arg2 + "</b>";
            loc7 = loc5.textWidth + 40;
            loc6.width = (loc7 < MAX_BUTTON_WIDTH) ? loc7 : MAX_BUTTON_WIDTH;
            loc5.width = loc6.width - 20;
            loc6.x = -loc6.width / 2;
            loc5.x = -loc5.width / 2;
            if (arg4)
            {
                characterPlaceholder.addChild(arg4);
                arg4.getAvatarClip().scaleX = arg4.getAvatarClip().scaleX * 1.3;
                arg4.getAvatarClip().scaleY = arg4.getAvatarClip().scaleY * 1.3;
            }
            if (arg3)
            {
                if (arg3["pic_url"])
                {
                    profileImage = new ProfileImage();
                    profileImage.x = 70;
                    profileImage.y = 65;
                    AssetsManager.getInstance().loadImage(arg3["pic_url"], profileImage, onProfileImageLoad);
                    addChild(profileImage);
                    characterPlaceholder.y = characterPlaceholder.y + 20;
                }
            }
            return;
        }

        private function onBtnEngageClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.ENGAGE_MISSION));
            return;
        }

        private function onProfileImageLoad(arg1:*, arg2:Object):void
        {
            if (arg1 && arg2)
            {
                arg2.addImage(arg1);
            }
            return;
        }

        private function onBtnIgnoreClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.IGNORE_MISSION));
            return;
        }

        private function onBtnNextClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.NEXT_MISSION));
            return;
        }

        private static const MAX_BUTTON_WIDTH:int=220;

        public var characterPlaceholder:flash.display.MovieClip;

        public var btnIgnore:flash.display.SimpleButton;

        public var btnNext:flash.display.SimpleButton;

        private var profileImage:MyLife.Interfaces.ProfileImage;

        public var description:flash.text.TextField;

        public var btnEngage:flash.display.MovieClip;
    }
}
