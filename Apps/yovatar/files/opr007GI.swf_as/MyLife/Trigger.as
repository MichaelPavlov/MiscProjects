package MyLife 
{
    import flash.display.*;
    import flash.events.*;
    
    public class Trigger extends flash.events.EventDispatcher
    {
        public function Trigger(arg1:flash.display.MovieClip, arg2:Boolean=true)
        {
            super();
            fired = false;
            _parentClip = arg1;
            _singleFire = arg2;
            return;
        }

        public function characterStartMove(arg1:*):void
        {
            var loc2:*;
            var loc3:*;

            if (activated)
            {
                movesSinceActivated++;
            }
            return;
        }

        public function fireWalkOut(arg1:*):void
        {
            activated = false;
            movesSinceActivated = 0;
            dispatchEvent(new MyLifeEvent(MyLifeEvent.TRIGGER_WALK_OUT, {"trigger":this, "parent":_parentClip, "character":arg1}));
            return;
        }

        public function activate():*
        {
            activated = true;
            fired = false;
            movesSinceActivated = 0;
            return;
        }

        public function fireWalk(arg1:*):void
        {
            if (!(_singleFire && fired))
            {
                dispatchEvent(new MyLifeEvent(MyLifeEvent.TRIGGER_WALK, {"trigger":this, "parent":_parentClip, "character":arg1}));
            }
            fired = true;
            return;
        }

        private var _parentClip:flash.display.MovieClip;

        public var fired:Boolean=false;

        public var activated:Boolean=false;

        public var movesSinceActivated:int=0;

        private var _singleFire:Boolean=false;
    }
}
