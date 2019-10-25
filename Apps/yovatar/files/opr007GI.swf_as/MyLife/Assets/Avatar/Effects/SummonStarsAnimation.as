package MyLife.Assets.Avatar.Effects 
{
    import flash.display.*;
    import flash.events.*;
    
    public class SummonStarsAnimation extends flash.display.MovieClip
    {
        public function SummonStarsAnimation()
        {
            particles = new Array();
            spareParticles = new Array();
            super();
            addEventListener(Event.ENTER_FRAME, enterFrame);
            return;
        }

        internal function destroy():*
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            removeEventListener(Event.ENTER_FRAME, enterFrame);
            return;
        }

        internal function addSparkParticle(arg1:Number, arg2:Number, arg3:int):*
        {
            var loc4:*;

            active = true;
            loc4 = 0;
            while (loc4 < arg3) 
            {
                if (spareParticles.length > 0)
                {
                    particle = spareParticles.shift();
                    particle.restart(arg1, arg2);
                }
                else 
                {
                    particle = new Particle(SparkCyan, this, arg1, arg2);
                }
                particle.setVel(randRange(0, (0)), randRange(0, (0)));
                particle.setScale(1.5);
                particle.clip.x = 0;
                particle.clip.alpha = 0.9;
                particle.frameIndex = 47;
                particle.shrink = 0.99;
                particle.minScale = 0.2;
                particle.sinScale = 4;
                particle.rotate = randRange(-10, 10);
                particle.gravity = randRange(-0.01, -0.04);
                particle.drag = 0.98;
                particle.fade = 0.9876;
                particle.updateRotation();
                particles.push(particle);
                ++loc4;
            }
            return;
        }

        internal function updateParticles():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = null;
            loc2 = 0;
            while (particles.length > 5000) 
            {
                loc1 = particles.shift();
                loc1.disable();
                spareParticles.push(loc1);
            }
            loc3 = 0;
            while (loc3 < particles.length) 
            {
                loc1 = particles[loc3];
                if (!loc1.disabled)
                {
                    loc1.update();
                    if (loc1.disabled)
                    {
                        loc1.destroy();
                    }
                    else 
                    {
                        ++loc2;
                    }
                }
                ++loc3;
            }
            if (active)
            {
                if (loc2 == 0)
                {
                    destroy();
                }
            }
            return;
        }

        internal function enterFrame(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            updateParticles();
            counter++;
            loc2 = 0;
            loc3 = -7;
            if (counter < 170)
            {
                if (Math.random() <= 0.2)
                {
                    addSparkParticle(loc2, loc3, 1);
                }
            }
            return;
        }

        internal function randRange(arg1:Number, arg2:Number):*
        {
            var loc3:*;

            loc3 = Math.random() * (arg2 - arg1) + arg1;
            return loc3;
        }

        public static const SparkCyan:Class=SummonStarsAnimation_SparkCyan;

        internal var bursting:Boolean=false;

        internal var particle:Object;

        internal var particles:Array;

        internal var active:Boolean=false;

        internal var spareParticles:Array;

        internal var counter:Number=0;
    }
}
