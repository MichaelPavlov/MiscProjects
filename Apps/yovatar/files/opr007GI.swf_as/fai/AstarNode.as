package fai 
{
    public class AstarNode extends Object
    {
        public function AstarNode()
        {
            super();
            return;
        }

        public function score():Number
        {
            return h + g * 1;
        }

        public function toString():String
        {
            return this.pos + " / " + this.g + " / " + this.h + " / " + this.f;
        }

        public function key():Number
        {
            return pos.x * 1000 + pos.y;
        }

        public var f:Number=0;

        public var g:Number=0;

        public var h:Number=0;

        public var parent:fai.AstarNode=null;

        public var pos:fai.Position=null;
    }
}
