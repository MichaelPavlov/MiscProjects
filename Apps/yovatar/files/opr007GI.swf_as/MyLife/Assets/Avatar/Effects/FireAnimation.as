package MyLife.Assets.Avatar.Effects 
{
    import flash.display.*;
    import flash.events.*;
    
    public class FireAnimation extends flash.display.MovieClip
    {
        public function FireAnimation()
        {
            particles = new Array();
            explodeParticles = new Array();
            spareParticles = new Array();
            super();
            addEventListener(Event.ENTER_FRAME, enterFrame);
            return;
        }

        internal function randRange(arg1:Number, arg2:Number):*
        {
            var loc3:*;

            loc3 = Math.random() * (arg2 - arg1) + arg1;
            return loc3;
        }

        internal function getMovieChildren(arg1:*):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc4 = undefined;
            loc2 = new Array();
            loc3 = 0;
            while (loc3 < arg1.numChildren) 
            {
                loc4 = arg1.getChildAt(loc3);
                loc2.unshift(loc4);
                ++loc3;
            }
            return loc2;
        }

        internal function addExplosionParticle(arg1:Number, arg2:Number, arg3:int):*
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
                particle.setVel(randRange(-6, 6), randRange(-6, 6) - 3);
                particle.setScale(randRange(1, 2));
                particle.shrink = 0.9;
                particle.gravity = 0.1;
                particle.drag = 0.98;
                particle.directionRotate = true;
                particle.updateRotation();
                particles.push(particle);
                ++loc4;
            }
            return;
        }

        internal function addSparkParticle(arg1:Number, arg2:Number, arg3:int, arg4:int):*
        {
            var loc5:*;

            active = true;
            loc5 = 0;
            while (loc5 < arg3) 
            {
                if (spareParticles.length > 0)
                {
                    particle = spareParticles.shift();
                    particle.restart(arg1, arg2);
                }
                else 
                {
                    if (arg4 != 1)
                    {
                        particle = new Particle(FireSmokeSprite, this, arg1, arg2);
                    }
                    else 
                    {
                        if (Math.random() < 0.5)
                        {
                            particle = new Particle(FireSprite, this, arg1, arg2);
                        }
                        else 
                        {
                            particle = new Particle(FireRedSprite, this, arg1, arg2);
                        }
                    }
                }
                if (arg4 != 1)
                {
                    particle.setVel(randRange(-1, 1), randRange(-0.3, -0.5));
                    particle.clip.alpha = 0.5;
                    particle.shrink = 1.02;
                    particle.gravity = -0.1;
                    particle.drag = 0.98;
                    particle.fade = 0.96;
                }
                else 
                {
                    particle.setVel(randRange(-1, 1), randRange(-0.3, -0.5));
                    particle.setScale(1.3);
                    particle.clip.alpha = 0.9;
                    particle.rotate = randRange(-10, 10);
                    particle.shrink = 1.02;
                    particle.gravity = -0.1;
                    particle.drag = 0.98;
                    particle.fade = 0.94;
                }
                particle.updateRotation();
                particles.push(particle);
                ++loc5;
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
            loc3 = 0;
            while (loc3 < explodeParticles.length) 
            {
                loc1 = explodeParticles[loc3];
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
            var loc6:*;
            var loc7:*;

            loc4 = undefined;
            loc5 = undefined;
            updateParticles();
            counter++;
            loc2 = 0;
            loc3 = 0;
            if (counter < 118)
            {
                if (counter % 2 == 0)
                {
                    addSparkParticle(randRange(-10, 10), loc3 - 8, 1, 2);
                }
                if (Math.random() < 0.7)
                {
                    addSparkParticle(randRange(-5, 5), randRange(-3, 3), 1, (1));
                }
            }
            else 
            {
                if (counter < 123)
                {
                    if (!blowUpComplete)
                    {
                        blowUpComplete = true;
                        avatar = this.parent;
                        if (avatar != null)
                        {
                            loc6 = 0;
                            loc7 = getMovieChildren(avatar.avatarClip);
                            for each (loc4 in loc7)
                            {
                                (loc5 = new ParticlePreExisting(loc4)).setVel(randRange(-20, 20), randRange(-40, -60));
                                loc5.rotate = randRange(-20, 20);
                                loc5.gravity = 2;
                                explodeParticles.push(loc5);
                            }
                        }
                    }
                    addExplosionParticle(0, (0), 20);
                }
            }
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

        public static const FireRedSprite:Class=FireAnimation_FireRedSprite;

        public static const FireSprite:Class=FireAnimation_FireSprite;

        public static const Spark:Class=FireAnimation_Spark;

        public static const FireSmokeSprite:Class=FireAnimation_FireSmokeSprite;

        internal var bursting:Boolean=false;

        internal var particle:Object;

        internal var active:Boolean=false;

        internal var explodeParticles:Array;

        internal var blowUpComplete:Boolean=false;

        internal var spareParticles:Array;

        internal var avatar:*;

        internal var particles:Array;

        internal var counter:Number=0;
    }
}
