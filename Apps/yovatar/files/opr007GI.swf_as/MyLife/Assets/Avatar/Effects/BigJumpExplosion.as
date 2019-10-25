package MyLife.Assets.Avatar.Effects 
{
    import flash.display.*;
    import flash.events.*;
    
    public class BigJumpExplosion extends flash.display.MovieClip
    {
        public function BigJumpExplosion(arg1:Array, arg2:flash.display.MovieClip, arg3:Number)
        {
            particles = new Array();
            spareParticles = new Array();
            super();
            this.framesToStartAnimationOn = arg1;
            this.numLoops = arg3;
            cycle = 0;
            loop = 0;
            this.syncClip = arg2;
            addEventListener(Event.ENTER_FRAME, delayBetweenBursts);
            return;
        }

        internal function randRange(arg1:Number, arg2:Number):*
        {
            var loc3:*;

            loc3 = Math.random() * (arg2 - arg1) + arg1;
            return loc3;
        }

        internal function startBurst():void
        {
            var loc1:*;
            var loc2:*;

            removeEventListener(Event.ENTER_FRAME, delayBetweenBursts);
            cycle++;
            particles = new Array();
            spareParticles = new Array();
            particle = null;
            counter = 0;
            bursting = false;
            active = false;
            addEventListener(Event.ENTER_FRAME, enterFrame);
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
                    if (cycle < framesToStartAnimationOn.length)
                    {
                        removeEventListener(Event.ENTER_FRAME, enterFrame);
                        addEventListener(Event.ENTER_FRAME, delayBetweenBursts);
                    }
                }
            }
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
                    particle = new Particle(Spark, this, arg1, arg2);
                }
                particle.setVel(randRange(-10, 10), randRange(-10, 10) - 3);
                particle.setScale(randRange(1, 2));
                particle.shrink = 0.9;
                particle.gravity = 0;
                particle.drag = 0.98;
                particle.directionRotate = true;
                particle.updateRotation();
                particles.push(particle);
                ++loc4;
            }
            return;
        }

        internal function enterFrame(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (syncClip.currentFrame >= syncClip.totalFrames)
            {
                cycle = 0;
                loop++;
            }
            if (!(numLoops == -1) && loop > numLoops)
            {
                destroy();
            }
            updateParticles();
            counter++;
            loc2 = 0;
            loc3 = -10;
            if (counter < 5)
            {
                addSparkParticle(loc2, loc3, 30);
            }
            return;
        }

        public function destroy():*
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            removeEventListener(Event.ENTER_FRAME, delayBetweenBursts);
            removeEventListener(Event.ENTER_FRAME, enterFrame);
            return;
        }

        internal function delayBetweenBursts(arg1:flash.events.Event):*
        {
            if (syncClip.currentFrame == framesToStartAnimationOn[cycle])
            {
                startBurst();
            }
            return;
        }

        public static const Spark:Class=BigJumpExplosion_Spark;

        internal var bursting:Boolean=false;

        internal var particle:Object;

        internal var active:Boolean=false;

        private var syncClip:flash.display.MovieClip;

        internal var spareParticles:Array;

        internal var framesToStartAnimationOn:Array;

        internal var loop:Number=0;

        internal var cycle:Number;

        private var numLoops:Number;

        internal var particles:Array;

        internal var counter:Number=0;
    }
}
