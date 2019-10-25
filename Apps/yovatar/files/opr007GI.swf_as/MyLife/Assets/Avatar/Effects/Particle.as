package MyLife.Assets.Avatar.Effects 
{
    import flash.display.*;
    
    public class Particle extends Object
    {
        public function Particle(arg1:Class, arg2:flash.display.DisplayObjectContainer, arg3:Number, arg4:Number, arg5:*=null)
        {
            super();
            if (arg5 == null)
            {
                isUsingClipOverride = false;
                clip = new arg1();
                spriteClass = arg1;
            }
            else 
            {
                trace("clipOveride: " + arg5);
                clip = arg5;
                isUsingClipOverride = true;
            }
            if (arg2)
            {
                arg2.addChild(clip);
            }
            if (arg3 > -1000)
            {
                setPos(arg3, arg4);
            }
            initDefaults();
            return;
        }

        public function destroy():*
        {
            if (clip.parent && !this.isUsingClipOverride)
            {
                clip.parent.removeChild(clip);
            }
            clip = null;
            return;
        }

        public function setScale(arg1:Number):*
        {
            var loc2:*;

            clip.scaleY = loc2 = arg1;
            clip.scaleX = loc2;
            return;
        }

        public function initDefaults():*
        {
            drag = 1;
            fade = 1;
            shrink = 1;
            gravity = 0;
            frameIndex = 0;
            sinScale = 0;
            minScale = 0.5;
            rotate = 0;
            directionRotate = false;
            return;
        }

        public function update():*
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc1 = undefined;
            loc2 = undefined;
            frameIndex++;
            clip.x = clip.x + xVel;
            clip.y = clip.y + yVel;
            if (sinScale != 0)
            {
                loc1 = Math.sin(frameIndex / 10);
                loc2 = loc1 * sinScale;
                clip.x = clip.x + loc2;
            }
            xVel = xVel * drag;
            yVel = yVel * drag;
            clip.alpha = clip.alpha * 1000 * fade / 1000;
            clip.scaleY = loc3 = clip.scaleY * shrink;
            clip.scaleX = loc3;
            yVel = yVel + gravity;
            if (directionRotate)
            {
                updateRotation();
            }
            if (rotate != 0)
            {
                clip.rotation = clip.rotation + rotate;
            }
            if (clip.scaleX <= 0.5)
            {
                disable();
            }
            if (clip.alpha <= 0.01)
            {
                disable();
            }
            if (clip.y > 500)
            {
                disable();
            }
            return;
        }

        public function restart(arg1:Number, arg2:Number):*
        {
            initDefaults();
            clip.visible = true;
            disabled = false;
            setPos(arg1, arg2);
            return;
        }

        public function setPos(arg1:Number, arg2:Number):*
        {
            clip.x = arg1;
            clip.y = arg2;
            return;
        }

        public function setVel(arg1:Number, arg2:Number):*
        {
            xVel = arg1;
            yVel = arg2;
            return;
        }

        public function updateRotation():*
        {
            clip.rotation = Math.atan2(yVel, xVel) * 180 / Math.PI;
            return;
        }

        public function disable():*
        {
            clip.visible = false;
            disabled = true;
            return;
        }

        public var disabled:Boolean;

        public var xVel:Number;

        public var shrink:Number;

        public var gravity:Number;

        public var clip:flash.display.Sprite;

        private var isUsingClipOverride:Boolean;

        public var minScale:Number;

        public var sinScale:Number;

        public var rotate:Number;

        public var yVel:Number;

        public var frameIndex:int;

        public var spriteClass:Class;

        public var directionRotate:Boolean;

        public var drag:Number;

        public var fade:Number;
    }
}
