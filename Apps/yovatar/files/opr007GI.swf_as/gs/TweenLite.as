package gs 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.utils.*;
    
    public class TweenLite extends Object
    {
        public function TweenLite(arg1:Object, arg2:Number, arg3:Object)
        {
            var loc4:*;

            super();
            if (arg1 == null)
            {
                return;
            }
            if (!(arg3.overwrite == false) && !(arg1 == null) || _all[arg1] == undefined)
            {
                delete _all[arg1];
                _all[arg1] = new Dictionary();
            }
            _all[arg1][this] = this;
            this.vars = arg3;
            this.duration = arg2 || 0.001;
            this.delay = arg3.delay || 0;
            this.target = arg1;
            if (!(this.vars.ease as Function))
            {
                this.vars.ease = easeOut;
            }
            if (this.vars.easeParams != null)
            {
                this.vars.proxiedEase = this.vars.ease;
                this.vars.ease = easeProxy;
            }
            if (this.vars.mcColor != null)
            {
                this.vars.tint = this.vars.mcColor;
            }
            if (!isNaN(Number(this.vars.autoAlpha)))
            {
                this.vars.alpha = Number(this.vars.autoAlpha);
            }
            this.tweens = {};
            _subTweens = [];
            _initted = loc4 = false;
            _hst = loc4;
            _active = arg2 == 0 && this.delay == 0;
            this.initTime = getTimer();
            if (this.vars.runBackwards == true && !(this.vars.renderOnStart == true) || _active)
            {
                initTweenVals();
                this.startTime = getTimer();
                if (_active)
                {
                    render(this.startTime + 1);
                }
                else 
                {
                    render(this.startTime);
                }
            }
            if (!_listening && !_active)
            {
                _sprite.addEventListener(Event.ENTER_FRAME, executeAll);
                _timer.addEventListener("timer", killGarbage);
                _timer.start();
                _listening = true;
            }
            return;
        }

        protected function addSubTween(arg1:Function, arg2:Object, arg3:Object, arg4:Object=null):void
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc5 = null;
            _subTweens.push({"proxy":arg1, "target":arg2, "info":arg4});
            loc6 = 0;
            loc7 = arg3;
            for (loc5 in loc7)
            {
                if (!arg2.hasOwnProperty(loc5))
                {
                    continue;
                }
                if (typeof arg3[loc5] == "number")
                {
                    this.tweens[("st" + _subTweens.length + "_" + loc5)] = {"o":arg2, "p":loc5, "s":arg2[loc5], "c":arg3[loc5] - arg2[loc5]};
                    continue;
                }
                this.tweens[("st" + _subTweens.length + "_" + loc5)] = {"o":arg2, "p":loc5, "s":arg2[loc5], "c":Number(arg3[loc5])};
            }
            _hst = true;
            return;
        }

        public function initTweenVals(arg1:Boolean=false, arg2:String=""):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;

            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc7 = null;
            loc8 = undefined;
            loc9 = null;
            loc3 = this.target as DisplayObject;
            if (this.target as Array)
            {
                loc5 = this.vars.endArray || [];
                loc6 = 0;
                while (loc6 < loc5.length) 
                {
                    if (!(this.target[loc6] == loc5[loc6]) && !(this.target[loc6] == undefined))
                    {
                        this.tweens[loc6.toString()] = {"o":this.target, "p":loc6.toString(), "s":this.target[loc6], "c":loc5[loc6] - this.target[loc6]};
                    }
                    ++loc6;
                }
            }
            else 
            {
                loc10 = 0;
                loc11 = this.vars;
                for (loc4 in loc11)
                {
                    if (loc4 == "ease" || loc4 == "delay" || loc4 == "overwrite" || loc4 == "onComplete" || loc4 == "onCompleteParams" || loc4 == "onCompleteScope" || loc4 == "runBackwards" || loc4 == "onUpdate" || loc4 == "onUpdateParams" || loc4 == "onUpdateScope" || loc4 == "autoAlpha" || loc4 == "onStart" || loc4 == "onStartParams" || loc4 == "onStartScope" || loc4 == "renderOnStart" || loc4 == "easeParams" || loc4 == "mcColor" || loc4 == "type" || arg1 && !(arg2.indexOf(" " + loc4 + " ") == -1))
                    {
                        continue;
                    }
                    if (loc4 == "tint" && loc3)
                    {
                        loc7 = this.target.transform.colorTransform;
                        loc8 = new ColorTransform();
                        if (this.vars.alpha == undefined)
                        {
                            loc8.alphaMultiplier = this.target.alpha;
                        }
                        else 
                        {
                            loc8.alphaMultiplier = this.vars.alpha;
                            delete this.vars.alpha;
                            delete this.tweens.alpha;
                        }
                        if (!(this.vars[loc4] == null) && !(this.vars[loc4] == ""))
                        {
                            loc8.color = this.vars[loc4];
                        }
                        addSubTween(tintProxy, {"progress":0}, {"progress":1}, {"target":this.target, "color":loc7, "endColor":loc8});
                        continue;
                    }
                    if (loc4 == "frame" && loc3)
                    {
                        addSubTween(frameProxy, {"frame":this.target.currentFrame}, {"frame":this.vars[loc4]}, {"target":this.target});
                        continue;
                    }
                    if (loc4 == "volume" && (loc3 || this.target as SoundChannel))
                    {
                        addSubTween(volumeProxy, this.target.soundTransform, {"volume":this.vars[loc4]}, {"target":this.target});
                        continue;
                    }
                    if (!this.target.hasOwnProperty(loc4))
                    {
                        continue;
                    }
                    if (typeof this.vars[loc4] == "number")
                    {
                        this.tweens[loc4] = {"o":this.target, "p":loc4, "s":this.target[loc4], "c":this.vars[loc4] - this.target[loc4]};
                        continue;
                    }
                    this.tweens[loc4] = {"o":this.target, "p":loc4, "s":this.target[loc4], "c":Number(this.vars[loc4])};
                }
            }
            if (this.vars.runBackwards == true)
            {
                loc10 = 0;
                loc11 = this.tweens;
                for (loc4 in loc11)
                {
                    loc9 = this.tweens[loc4];
                    loc9.s = loc9.s + loc9.c;
                    loc9.c = loc9.c * -1;
                }
            }
            if (typeof this.vars.autoAlpha == "number")
            {
                this.target.visible = !(this.vars.runBackwards == true && this.target.alpha == 0);
            }
            _initted = true;
            return;
        }

        public function get active():Boolean
        {
            if (_active)
            {
                return true;
            }
            if ((getTimer() - this.initTime) / 1000 > this.delay)
            {
                _active = true;
                this.startTime = this.initTime + this.delay * 1000;
                if (_initted)
                {
                    if (typeof this.vars.autoAlpha == "number")
                    {
                        this.target.visible = true;
                    }
                }
                else 
                {
                    initTweenVals();
                }
                if (this.vars.onStart != null)
                {
                    this.vars.onStart.apply(this.vars.onStartScope, this.vars.onStartParams);
                }
                if (this.duration == 0.001)
                {
                    this.startTime = (this.startTime - 1);
                }
                return true;
            }
            return false;
        }

        public function render(arg1:uint):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc4 = null;
            loc5 = null;
            loc6 = 0;
            loc2 = (arg1 - this.startTime) / 1000;
            if (loc2 > this.duration)
            {
                loc2 = this.duration;
            }
            loc3 = this.vars.ease(loc2, 0, 1, this.duration);
            loc7 = 0;
            loc8 = this.tweens;
            for (loc5 in loc8)
            {
                (loc4 = this.tweens[loc5]).o[loc4.p] = loc4.s + loc3 * loc4.c;
            }
            if (_hst)
            {
                loc6 = 0;
                while (loc6 < _subTweens.length) 
                {
                    _subTweens[loc6].proxy(_subTweens[loc6]);
                    loc6 = (loc6 + 1);
                }
            }
            if (this.vars.onUpdate != null)
            {
                this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
            }
            if (loc2 == this.duration)
            {
                complete(true);
            }
            return;
        }

        protected function easeProxy(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
        }

        public function complete(arg1:Boolean=false):void
        {
            if (!arg1)
            {
                if (!_initted)
                {
                    initTweenVals();
                }
                this.startTime = 0;
                render(this.duration * 1000);
                return;
            }
            if (typeof this.vars.autoAlpha == "number" && this.target.alpha == 0)
            {
                this.target.visible = false;
            }
            if (this.vars.onComplete != null)
            {
                this.vars.onComplete.apply(this.vars.onCompleteScope, this.vars.onCompleteParams);
            }
            removeTween(this);
            return;
        }

        public static function delayedCall(arg1:Number, arg2:Function, arg3:Array=null, arg4:*=null):gs.TweenLite
        {
            return new TweenLite(arg2, 0, {"delay":arg1, "onComplete":arg2, "onCompleteParams":arg3, "onCompleteScope":arg4, "overwrite":false});
        }

        public static function frameProxy(arg1:Object):void
        {
            arg1.info.target.gotoAndStop(Math.round(arg1.target.frame));
            return;
        }

        public static function from(arg1:Object, arg2:Number, arg3:Object):gs.TweenLite
        {
            arg3.runBackwards = true;
            return new TweenLite(arg1, arg2, arg3);
        }

        public static function executeAll(arg1:flash.events.Event=null):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc4 = null;
            loc5 = null;
            loc2 = _all;
            loc3 = getTimer();
            loc6 = 0;
            loc7 = loc2;
            for (loc4 in loc7)
            {
                loc8 = 0;
                loc9 = loc2[loc4];
                for (loc5 in loc9)
                {
                    if (!(!(loc2[loc4][loc5] == undefined) && loc2[loc4][loc5].active))
                    {
                        continue;
                    }
                    loc2[loc4][loc5].render(loc3);
                    if (loc2[loc4] != undefined)
                    {
                        continue;
                    }
                    break;
                }
            }
            return;
        }

        protected static function easeOut(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc5:*;

            arg1 = loc5 = arg1 / arg4;
            return -arg3 * loc5 * (arg1 - 2) + arg2;
        }

        public static function volumeProxy(arg1:Object):void
        {
            arg1.info.target.soundTransform = arg1.target;
            return;
        }

        public static function removeTween(arg1:gs.TweenLite=null):void
        {
            if (!(arg1 == null) && !(_all[arg1.target] == undefined))
            {
                delete _all[arg1.target][arg1];
            }
            return;
        }

        public static function killGarbage(arg1:flash.events.TimerEvent):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc3 = false;
            loc4 = null;
            loc5 = null;
            loc6 = null;
            loc2 = 0;
            loc7 = 0;
            loc8 = _all;
            for (loc4 in loc8)
            {
                loc3 = false;
                loc9 = 0;
                loc10 = _all[loc4];
                for (loc5 in loc10)
                {
                    loc3 = true;
                    break;
                }
                if (!loc3)
                {
                    delete _all[loc4];
                    continue;
                }
                loc2 = (loc2 + 1);
            }
            if (loc2 == 0)
            {
                _sprite.removeEventListener(Event.ENTER_FRAME, executeAll);
                _timer.removeEventListener("timer", killGarbage);
                _timer.stop();
                _listening = false;
            }
            return;
        }

        public static function tintProxy(arg1:Object):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = arg1.target.progress;
            loc3 = 1 - loc2;
            arg1.info.target.transform.colorTransform = new ColorTransform(arg1.info.color.redMultiplier * loc3 + arg1.info.endColor.redMultiplier * loc2, arg1.info.color.greenMultiplier * loc3 + arg1.info.endColor.greenMultiplier * loc2, arg1.info.color.blueMultiplier * loc3 + arg1.info.endColor.blueMultiplier * loc2, arg1.info.color.alphaMultiplier * loc3 + arg1.info.endColor.alphaMultiplier * loc2, arg1.info.color.redOffset * loc3 + arg1.info.endColor.redOffset * loc2, arg1.info.color.greenOffset * loc3 + arg1.info.endColor.greenOffset * loc2, arg1.info.color.blueOffset * loc3 + arg1.info.endColor.blueOffset * loc2, arg1.info.color.alphaOffset * loc3 + arg1.info.endColor.alphaOffset * loc2);
            return;
        }

        public static function to(arg1:Object, arg2:Number, arg3:Object):gs.TweenLite
        {
            return new TweenLite(arg1, arg2, arg3);
        }

        public static function killTweensOf(arg1:Object=null, arg2:Boolean=false):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc3 = null;
            loc4 = undefined;
            if (!(arg1 == null) && !(_all[arg1] == undefined))
            {
                if (arg2)
                {
                    loc3 = _all[arg1];
                    loc5 = 0;
                    loc6 = loc3;
                    for (loc4 in loc6)
                    {
                        loc3[loc4].complete(false);
                    }
                }
                delete _all[arg1];
            }
            return;
        }

        
        {
            version = 6.04;
            killDelayedCallsTo = killTweensOf;
            _all = new Dictionary();
            _sprite = new Sprite();
            _timer = new Timer(2000);
        }

        public var delay:Number;

        protected var _initted:Boolean;

        protected var _subTweens:Array;

        public var startTime:uint;

        public var target:Object;

        public var duration:Number;

        protected var _hst:Boolean;

        protected var _active:Boolean;

        public var tweens:Object;

        public var vars:Object;

        public var initTime:uint;

        protected static var _all:flash.utils.Dictionary;

        private static var _timer:flash.utils.Timer;

        private static var _sprite:flash.display.Sprite;

        public static var killDelayedCallsTo:Function;

        public static var version:Number=6.04;

        private static var _listening:Boolean;
    }
}
