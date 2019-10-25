package com.boostworthy.animation.sequence 
{
    import com.boostworthy.animation.sequence.tweens.*;
    import com.boostworthy.collections.*;
    import com.boostworthy.collections.iterators.*;
    
    public class TweenStack extends com.boostworthy.collections.Stack
    {
        public function TweenStack()
        {
            super();
            return;
        }

        public override function addElement(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = null;
            loc2 = arg1 as ITween;
            loc3 = new Array();
            loc4 = getIterator();
            while (loc4.hasNext()) 
            {
                if (!((loc7 = loc4.next() as ITween).target == loc2.target && loc7.property == loc2.property))
                {
                    continue;
                }
                if (!(loc7.firstFrame > loc2.firstFrame))
                {
                    continue;
                }
                loc3.push(loc7.clone());
                removeElement(loc7);
            }
            super.addElement(loc2);
            loc5 = loc3.length;
            loc6 = 0;
            while (loc6 < loc5) 
            {
                super.addElement(loc3[loc6]);
                ++loc6;
            }
            return;
        }
    }
}
