package gs 
{
    import flash.display.*;
    import flash.filters.*;
    
    public class TweenFilterLite extends gs.TweenLite
    {
        public function TweenFilterLite(arg1:flash.display.DisplayObject, arg2:Number, arg3:Object)
        {
            _fType = YoVilleApp;
            super(arg1, arg2, arg3);
            if (TweenLite.version < 6.04 || isNaN(TweenLite.version))
            {
                trace("ERROR! Please update your TweenLite class. TweenFilterLite requires a more recent version. Download updates at http://www.TweenLite.com.");
            }
            return;
        }

        private function setFilter(arg1:Class, arg2:Array, arg3:flash.filters.BitmapFilter):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc5 = 0;
            loc6 = NaN;
            loc7 = null;
            loc8 = null;
            loc9 = null;
            loc10 = null;
            _fType = arg1;
            loc4 = _mc.filters;
            loc5 = 0;
            while (loc5 < loc4.length) 
            {
                if (loc4[loc5] as arg1)
                {
                    _f = loc4[loc5];
                    break;
                }
                ++loc5;
            }
            if (_f == null)
            {
                loc4.push(arg3);
                _mc.filters = loc4;
                _f = arg3;
            }
            loc5 = 0;
            while (loc5 < arg2.length) 
            {
                loc7 = arg2[loc5];
                if (this.vars[loc7] != undefined)
                {
                    if (!(loc7 == "brightness" || loc7 == "colorize" || loc7 == "amount" || loc7 == "saturation" || loc7 == "contrast" || loc7 == "hue" || loc7 == "threshold"))
                    {
                        if (loc7 == "color" || loc7 == "highlightColor" || loc7 == "shadowColor")
                        {
                            loc9 = HEXtoRGB(_f[loc7]);
                            loc10 = HEXtoRGB(this.vars[loc7]);
                            _clrsa.push({"p":loc7, "sr":loc9.rb, "cr":loc10.rb - loc9.rb, "sg":loc9.gb, "cg":loc10.gb - loc9.gb, "sb":loc9.bb, "cb":loc10.bb - loc9.bb});
                        }
                        else 
                        {
                            if (loc7 == "quality" || loc7 == "inner" || loc7 == "knockout" || loc7 == "hideObject")
                            {
                                _f[loc7] = this.vars[loc7];
                            }
                            else 
                            {
                                if (typeof this.vars[loc7] != "number")
                                {
                                    loc6 = Number(this.vars[loc7]);
                                }
                                else 
                                {
                                    loc6 = this.vars[loc7] - _f[loc7];
                                }
                                this.tweens[loc7] = {"o":_f, "p":loc7, "s":_f[loc7], "c":loc6};
                            }
                        }
                    }
                }
                ++loc5;
            }
            return;
        }

        public override function initTweenVals(arg1:Boolean=false, arg2:String=""):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc3 = 0;
            loc4 = null;
            _mc = this.target as DisplayObject;
            _clrsa = [];
            _matrix = _idMatrix.slice();
            if (this.vars.type == null)
            {
                super.initTweenVals(false);
            }
            else 
            {
                if (this.vars.quality == undefined || isNaN(this.vars.quality))
                {
                    this.vars.quality = 2;
                }
                loc5 = this.vars.type.toLowerCase();
                switch (loc5) 
                {
                    case "blur":
                        setFilter(BlurFilter, ["blurX", "blurY", "quality"], new BlurFilter(0, (0), this.vars.quality));
                        break;
                    case "glow":
                        setFilter(GlowFilter, ["alpha", "blurX", "blurY", "color", "quality", "strength", "inner", "knockout"], new GlowFilter(16777215, 0, (0), (0), this.vars.strength || 1, this.vars.quality, this.vars.inner, this.vars.knockout));
                        break;
                    case "colormatrix":
                    case "color":
                    case "colormatrixfilter":
                    case "colorize":
                        setFilter(ColorMatrixFilter, [], new ColorMatrixFilter(_matrix));
                        _matrix = ColorMatrixFilter(_f).matrix;
                        if (this.vars.relative != true)
                        {
                            _endMatrix = _idMatrix.slice();
                        }
                        else 
                        {
                            _endMatrix = _matrix.slice();
                        }
                        _endMatrix = setBrightness(_endMatrix, this.vars.brightness);
                        _endMatrix = setContrast(_endMatrix, this.vars.contrast);
                        _endMatrix = setHue(_endMatrix, this.vars.hue);
                        _endMatrix = setSaturation(_endMatrix, this.vars.saturation);
                        _endMatrix = setThreshold(_endMatrix, this.vars.threshold);
                        if (isNaN(this.vars.colorize))
                        {
                            if (!isNaN(this.vars.color))
                            {
                                _endMatrix = colorize(_endMatrix, this.vars.color, this.vars.amount);
                            }
                        }
                        else 
                        {
                            _endMatrix = colorize(_endMatrix, this.vars.colorize, this.vars.amount);
                        }
                        loc3 = 0;
                        while (loc3 < _endMatrix.length) 
                        {
                            if (!(_matrix[loc3] == _endMatrix[loc3]) && !(_matrix[loc3] == undefined))
                            {
                                this.tweens[("tflmtx" + loc3)] = {"o":_matrix, "p":loc3.toString(), "s":_matrix[loc3], "c":_endMatrix[loc3] - _matrix[loc3]};
                            }
                            loc3 = (loc3 + 1);
                        }
                        break;
                    case "shadow":
                    case "dropshadow":
                        setFilter(DropShadowFilter, ["alpha", "angle", "blurX", "blurY", "color", "distance", "quality", "strength", "inner", "knockout", "hideObject"], new DropShadowFilter(0, 45, 0, (0), (0), 0, 1, this.vars.quality, this.vars.inner, this.vars.knockout, this.vars.hideObject));
                        break;
                    case "bevel":
                        setFilter(BevelFilter, ["angle", "blurX", "blurY", "distance", "highlightAlpha", "highlightColor", "quality", "shadowAlpha", "shadowColor", "strength"], new BevelFilter(0, (0), 16777215, 0.5, 0, 0.5, 2, (2), 0, this.vars.quality));
                        break;
                }
                if (this.vars.runBackwards == true)
                {
                    loc3 = 0;
                    while (loc3 < _clrsa.length) 
                    {
                        loc4 = _clrsa[loc3];
                        loc4.sr = loc4.sr + loc4.cr;
                        loc4.cr = loc4.cr * -1;
                        loc4.sg = loc4.sg + loc4.cg;
                        loc4.cg = loc4.cg * -1;
                        loc4.sb = loc4.sb + loc4.cb;
                        loc4.cb = loc4.cb * -1;
                        _f[loc4.p] = loc4.sr << 16 | loc4.sg << 8 | loc4.sb;
                        loc3 = (loc3 + 1);
                    }
                }
                super.initTweenVals(true, " alpha angle blurX blurY color distance quality strength inner knockout hideObject highlightAlpha highlightColor shadowAlpha shadowColor ");
            }
            return;
        }

        public override function render(arg1:uint):void
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
            var loc11:*;
            var loc12:*;

            loc4 = null;
            loc5 = 0;
            loc6 = null;
            loc7 = null;
            loc8 = NaN;
            loc9 = NaN;
            loc10 = NaN;
            loc2 = (arg1 - this.startTime) / 1000;
            if (loc2 > this.duration)
            {
                loc2 = this.duration;
            }
            loc3 = this.vars.ease(loc2, 0, 1, this.duration);
            loc11 = 0;
            loc12 = this.tweens;
            for (loc6 in loc12)
            {
                (loc4 = this.tweens[loc6]).o[loc4.p] = loc4.s + loc3 * loc4.c;
            }
            loc7 = _mc.filters.slice();
            if (!(_mc.parent == null) && !(loc7.length == 0))
            {
                loc5 = 0;
                while (loc5 < _clrsa.length) 
                {
                    loc8 = (loc4 = _clrsa[loc5]).sr + loc3 * loc4.cr;
                    loc9 = loc4.sg + loc3 * loc4.cg;
                    loc10 = loc4.sb + loc3 * loc4.cb;
                    _f[loc4.p] = loc8 << 16 | loc9 << 8 | loc10;
                    loc5 = (loc5 + 1);
                }
                if (_endMatrix != null)
                {
                    ColorMatrixFilter(_f).matrix = _matrix;
                }
                loc5 = (loc7.length - 1);
                while (loc5 > -1) 
                {
                    if (loc7[loc5] as _fType)
                    {
                        loc7[loc5] = _f;
                        break;
                    }
                    loc5 = (loc5 - 1);
                }
                _mc.filters = loc7;
            }
            if (_hst)
            {
                loc5 = 0;
                while (loc5 < _subTweens.length) 
                {
                    _subTweens[loc5].proxy(_subTweens[loc5]);
                    loc5 = (loc5 + 1);
                }
            }
            if (this.vars.onUpdate != null)
            {
                this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
            }
            if (loc2 == this.duration)
            {
                super.complete(true);
            }
            return;
        }

        public function HEXtoRGB(arg1:Number):Object
        {
            return {"rb":arg1 >> 16, "gb":arg1 >> 8 & 255, "bb":arg1 & 255};
        }

        public static function setContrast(arg1:Array, arg2:Number):Array
        {
            var loc3:*;

            if (isNaN(arg2))
            {
                return arg1;
            }
            arg2 = arg2 + 0.01;
            loc3 = [arg2, 0, (0), (0), 128 * (1 - arg2), 0, arg2, 0, (0), 128 * (1 - arg2), 0, (0), arg2, 0, 128 * (1 - arg2), 0, (0), (0), 1, 0];
            return applyMatrix(loc3, arg1);
        }

        public static function applyMatrix(arg1:Array, arg2:Array):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = 0;
            loc7 = 0;
            if (!(arg1 as Array) || !(arg2 as Array))
            {
                return arg2;
            }
            loc3 = [];
            loc4 = 0;
            loc5 = 0;
            loc6 = 0;
            while (loc6 < 4) 
            {
                loc7 = 0;
                while (loc7 < 5) 
                {
                    if (loc7 != 4)
                    {
                        loc5 = 0;
                    }
                    else 
                    {
                        loc5 = arg1[(loc4 + 4)];
                    }
                    loc3[(loc4 + loc7)] = arg1[loc4] * arg2[loc7] + arg1[(loc4 + 1)] * arg2[(loc7 + 5)] + arg1[(loc4 + 2)] * arg2[(loc7 + 10)] + arg1[(loc4 + 3)] * arg2[(loc7 + 15)] + loc5;
                    ++loc7;
                }
                loc4 = loc4 + 5;
                ++loc6;
            }
            return loc3;
        }

        public static function colorize(arg1:Array, arg2:Number, arg3:Number=100):Array
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            if (isNaN(arg2))
            {
                return arg1;
            }
            if (isNaN(arg3))
            {
                arg3 = 1;
            }
            loc4 = (arg2 >> 16 & 255) / 255;
            loc5 = (arg2 >> 8 & 255) / 255;
            loc6 = (arg2 & 255) / 255;
            loc8 = [(loc7 = 1 - arg3) + arg3 * loc4 * _lumR, arg3 * loc4 * _lumG, arg3 * loc4 * _lumB, 0, (0), arg3 * loc5 * _lumR, loc7 + arg3 * loc5 * _lumG, arg3 * loc5 * _lumB, 0, (0), arg3 * loc6 * _lumR, arg3 * loc6 * _lumG, loc7 + arg3 * loc6 * _lumB, 0, (0), (0), 0, (0), 1, 0];
            return applyMatrix(loc8, arg1);
        }

        public static function setBrightness(arg1:Array, arg2:Number):Array
        {
            if (isNaN(arg2))
            {
                return arg1;
            }
            arg2 = arg2 * 100 - 100;
            return applyMatrix([1, 0, (0), (0), arg2, 0, 1, 0, (0), arg2, 0, (0), 1, 0, arg2, 0, (0), (0), 1, 0, (0), (0), 0, (0), 1], arg1);
        }

        public static function setSaturation(arg1:Array, arg2:Number):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            if (isNaN(arg2))
            {
                return arg1;
            }
            loc3 = 1 - arg2;
            loc4 = loc3 * _lumR;
            loc5 = loc3 * _lumG;
            loc6 = loc3 * _lumB;
            loc7 = [loc4 + arg2, loc5, loc6, 0, (0), loc4, loc5 + arg2, loc6, 0, (0), loc4, loc5, loc6 + arg2, 0, (0), (0), 0, (0), 1, 0];
            return applyMatrix(loc7, arg1);
        }

        public static function from(arg1:flash.display.DisplayObject, arg2:Number, arg3:Object):gs.TweenFilterLite
        {
            arg3.runBackwards = true;
            return new TweenFilterLite(arg1, arg2, arg3);
        }

        public static function setThreshold(arg1:Array, arg2:Number):Array
        {
            var loc3:*;

            if (isNaN(arg2))
            {
                return arg1;
            }
            loc3 = [_lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * arg2, _lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * arg2, _lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * arg2, 0, (0), (0), 1, 0];
            return applyMatrix(loc3, arg1);
        }

        public static function setHue(arg1:Array, arg2:Number):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;

            if (isNaN(arg2))
            {
                return arg1;
            }
            arg2 = arg2 * Math.PI / 180;
            loc3 = Math.cos(arg2);
            loc4 = Math.sin(arg2);
            loc5 = [_lumR + loc3 * (1 - _lumR) + loc4 * -_lumR, _lumG + loc3 * -_lumG + loc4 * -_lumG, _lumB + loc3 * -_lumB + loc4 * (1 - _lumB), 0, (0), _lumR + loc3 * -_lumR + loc4 * 0.143, _lumG + loc3 * (1 - _lumG) + loc4 * 0.14, _lumB + loc3 * -_lumB + loc4 * -0.283, 0, (0), _lumR + loc3 * -_lumR + loc4 * -(1 - _lumR), _lumG + loc3 * -_lumG + loc4 * _lumG, _lumB + loc3 * (1 - _lumB) + loc4 * _lumB, 0, (0), (0), 0, (0), 1, 0, (0), (0), 0, (0), 1];
            return applyMatrix(loc5, arg1);
        }

        public static function to(arg1:flash.display.DisplayObject, arg2:Number, arg3:Object):gs.TweenFilterLite
        {
            return new TweenFilterLite(arg1, arg2, arg3);
        }

        
        {
            version = 6.02;
            delayedCall = TweenLite.delayedCall;
            killTweensOf = TweenLite.killTweensOf;
            killDelayedCallsTo = TweenLite.killTweensOf;
            _idMatrix = [1, 0, (0), (0), 0, (0), 1, 0, (0), (0), 0, (0), 1, 0, (0), (0), 0, (0), 1, 0];
            _lumR = 0.212671;
            _lumG = 0.71516;
            _lumB = 0.072169;
        }

        private var _matrix:Array;

        private var _fType:Class;

        private var _f:flash.filters.BitmapFilter;

        private var _mc:flash.display.DisplayObject;

        private var _clrsa:Array;

        private var _endMatrix:Array;

        private static var _idMatrix:Array;

        private static var _lumB:Number=0.072169;

        public static var version:Number=6.02;

        public static var delayedCall:Function;

        public static var killTweensOf:Function;

        private static var _lumG:Number=0.71516;

        public static var killDelayedCallsTo:Function;

        private static var _lumR:Number=0.212671;
    }
}
