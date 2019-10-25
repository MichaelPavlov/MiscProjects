package caurina.transitions 
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class Tweener extends Object
    {
        public function Tweener()
        {
            super();
            trace("Tweener is a static class and should not be instantiated.");
            return;
        }

        public static function registerSpecialPropertyModifier(arg1:String, arg2:Function, arg3:Function):void
        {
            var loc4:*;

            if (!_inited)
            {
                init();
            }
            loc4 = new SpecialPropertyModifier(arg2, arg3);
            _specialPropertyModifierList[arg1] = loc4;
            return;
        }

        public static function registerSpecialProperty(arg1:String, arg2:Function, arg3:Function, arg4:Array=null, arg5:Function=null):void
        {
            var loc6:*;

            if (!_inited)
            {
                init();
            }
            loc6 = new SpecialProperty(arg2, arg3, arg4, arg5);
            _specialPropertyList[arg1] = loc6;
            return;
        }

        public static function init(... rest):void
        {
            _inited = true;
            _transitionList = new Object();
            Equations.init();
            _specialPropertyList = new Object();
            _specialPropertyModifierList = new Object();
            _specialPropertySplitterList = new Object();
            return;
        }

        private static function updateTweens():Boolean
        {
            var loc1:*;

            loc1 = 0;
            if (_tweenList.length == 0)
            {
                return false;
            }
            loc1 = 0;
            while (loc1 < _tweenList.length) 
            {
                if (_tweenList[loc1] == undefined || !_tweenList[loc1].isPaused)
                {
                    if (!updateTweenByIndex(loc1))
                    {
                        removeTweenByIndex(loc1);
                    }
                    if (_tweenList[loc1] == null)
                    {
                        removeTweenByIndex(loc1, true);
                        loc1 = (loc1 - 1);
                    }
                }
                ++loc1;
            }
            return true;
        }

        public static function addCaller(arg1:Object=null, arg2:Object=null):Boolean
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

            loc3 = NaN;
            loc4 = null;
            loc8 = null;
            loc9 = null;
            loc10 = NaN;
            loc11 = null;
            if (!Boolean(arg1))
            {
                return false;
            }
            if (arg1 as Array)
            {
                loc4 = arg1.concat();
            }
            else 
            {
                loc4 = [arg1];
            }
            loc5 = arg2;
            if (!_inited)
            {
                init();
            }
            if (!_engineExists || !Boolean(__tweener_controller__))
            {
                startEngine();
            }
            loc6 = isNaN(loc5.time) ? 0 : loc5.time;
            loc7 = isNaN(loc5.delay) ? 0 : loc5.delay;
            if (typeof loc5.transition != "string")
            {
                loc8 = loc5.transition;
            }
            else 
            {
                loc11 = loc5.transition.toLowerCase();
                loc8 = _transitionList[loc11];
            }
            if (!Boolean(loc8))
            {
                loc8 = _transitionList["easeoutexpo"];
            }
            loc3 = 0;
            while (loc3 < loc4.length) 
            {
                if (loc5.useFrames != true)
                {
                    loc9 = new TweenListObj(loc4[loc3], _currentTime + loc7 * 1000 / _timeScale, _currentTime + (loc7 * 1000 + loc6 * 1000) / _timeScale, false, loc8, loc5.transitionParams);
                }
                else 
                {
                    loc9 = new TweenListObj(loc4[loc3], _currentTimeFrame + loc7 / _timeScale, _currentTimeFrame + (loc7 + loc6) / _timeScale, true, loc8, loc5.transitionParams);
                }
                loc9.properties = null;
                loc9.onStart = loc5.onStart;
                loc9.onUpdate = loc5.onUpdate;
                loc9.onComplete = loc5.onComplete;
                loc9.onOverwrite = loc5.onOverwrite;
                loc9.onStartParams = loc5.onStartParams;
                loc9.onUpdateParams = loc5.onUpdateParams;
                loc9.onCompleteParams = loc5.onCompleteParams;
                loc9.onOverwriteParams = loc5.onOverwriteParams;
                loc9.onStartScope = loc5.onStartScope;
                loc9.onUpdateScope = loc5.onUpdateScope;
                loc9.onCompleteScope = loc5.onCompleteScope;
                loc9.onOverwriteScope = loc5.onOverwriteScope;
                loc9.onErrorScope = loc5.onErrorScope;
                loc9.isCaller = true;
                loc9.count = loc5.count;
                loc9.waitFrames = loc5.waitFrames;
                _tweenList.push(loc9);
                if (loc6 == 0 && loc7 == 0)
                {
                    loc10 = (_tweenList.length - 1);
                    updateTweenByIndex(loc10);
                    removeTweenByIndex(loc10);
                }
                loc3 = (loc3 + 1);
            }
            return true;
        }

        public static function pauseAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                pauseTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public static function removeTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc4 = 0;
            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && loc3.indexOf(rest[loc4]) == -1)
                {
                    if (_specialPropertySplitterList[rest[loc4]])
                    {
                        loc6 = (loc5 = _specialPropertySplitterList[rest[loc4]]).splitValues(arg1, null);
                        loc7 = 0;
                        while (loc7 < loc6.length) 
                        {
                            loc3.push(loc6[loc7].name);
                            loc7 = (loc7 + 1);
                        }
                    }
                    else 
                    {
                        loc3.push(rest[loc4]);
                    }
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(removeTweenByIndex, arg1, loc3);
        }

        public static function splitTweens(arg1:Number, arg2:Array):uint
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = 0;
            loc6 = null;
            loc7 = false;
            loc3 = _tweenList[arg1];
            loc4 = loc3.clone(false);
            loc5 = 0;
            while (loc5 < arg2.length) 
            {
                loc6 = arg2[loc5];
                if (Boolean(loc3.properties[loc6]))
                {
                    loc3.properties[loc6] = undefined;
                    delete loc3.properties[loc6];
                }
                loc5 = (loc5 + 1);
            }
            loc8 = 0;
            loc9 = loc4.properties;
            for (loc6 in loc9)
            {
                loc7 = false;
                loc5 = 0;
                while (loc5 < arg2.length) 
                {
                    if (arg2[loc5] == loc6)
                    {
                        loc7 = true;
                        break;
                    }
                    loc5 = (loc5 + 1);
                }
                if (loc7)
                {
                    continue;
                }
                loc4.properties[loc6] = undefined;
                delete loc4.properties[loc6];
            }
            _tweenList.push(loc4);
            return (_tweenList.length - 1);
        }

        public static function updateFrame():void
        {
            var loc1:*;
            var loc2:*;

            _currentTimeFrame++;
            return;
        }

        public static function resumeTweenByIndex(arg1:Number):Boolean
        {
            var loc2:*;
            var loc3:*;

            loc2 = _tweenList[arg1];
            if (loc2 == null || !loc2.isPaused)
            {
                return false;
            }
            loc3 = getCurrentTweeningTime(loc2);
            loc2.timeStart = loc2.timeStart + loc3 - loc2.timePaused;
            loc2.timeComplete = loc2.timeComplete + loc3 - loc2.timePaused;
            loc2.timePaused = undefined;
            loc2.isPaused = false;
            return true;
        }

        public static function getVersion():String
        {
            return "AS3 1.31.74";
        }

        public static function onEnterFrame(arg1:flash.events.Event):void
        {
            var loc2:*;

            updateTime();
            updateFrame();
            loc2 = false;
            loc2 = updateTweens();
            if (!loc2)
            {
                stopEngine();
            }
            return;
        }

        public static function updateTime():void
        {
            _currentTime = getTimer();
            return;
        }

        private static function updateTweenByIndex(arg1:Number):Boolean
        {
            var b:Number;
            var c:Number;
            var cTime:Number;
            var d:Number;
            var eventScope:Object;
            var i:Number;
            var isOver:Boolean;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var mustUpdate:Boolean;
            var nv:Number;
            var pName:String;
            var pv:Number;
            var t:Number;
            var tProperty:Object;
            var tScope:Object;
            var tTweening:caurina.transitions.TweenListObj;

            tTweening = null;
            mustUpdate = false;
            nv = NaN;
            t = NaN;
            b = NaN;
            c = NaN;
            d = NaN;
            pName = null;
            eventScope = null;
            tScope = null;
            tProperty = null;
            pv = NaN;
            i = arg1;
            tTweening = _tweenList[i];
            if (tTweening == null || !Boolean(tTweening.scope))
            {
                return false;
            }
            isOver = false;
            cTime = getCurrentTweeningTime(tTweening);
            if (cTime >= tTweening.timeStart)
            {
                tScope = tTweening.scope;
                if (tTweening.isCaller)
                {
                    do 
                    {
                        t = (tTweening.timeComplete - tTweening.timeStart) / tTweening.count * (tTweening.timesCalled + 1);
                        b = tTweening.timeStart;
                        c = tTweening.timeComplete - tTweening.timeStart;
                        d = tTweening.timeComplete - tTweening.timeStart;
                        nv = tTweening.transition(t, b, c, d);
                        if (cTime >= nv)
                        {
                            if (Boolean(tTweening.onUpdate))
                            {
                                eventScope = Boolean(tTweening.onUpdateScope) ? tTweening.onUpdateScope : tScope;
                                try
                                {
                                    tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                                }
                                catch (e1:Error)
                                {
                                    handleError(tTweening, undefined, "onUpdate");
                                }
                            }
                            loc4 = ((loc3 = tTweening).timesCalled + 1);
                            loc3.timesCalled = loc4;
                            if (tTweening.timesCalled >= tTweening.count)
                            {
                                isOver = true;
                                break;
                            }
                            if (tTweening.waitFrames)
                            {
                                break;
                            }
                        }
                    }
                    while (cTime >= nv);
                }
                else 
                {
                    mustUpdate = tTweening.skipUpdates < 1 || !tTweening.skipUpdates || tTweening.updatesSkipped >= tTweening.skipUpdates;
                    if (cTime >= tTweening.timeComplete)
                    {
                        isOver = true;
                        mustUpdate = true;
                    }
                    if (!tTweening.hasStarted)
                    {
                        if (Boolean(tTweening.onStart))
                        {
                            eventScope = Boolean(tTweening.onStartScope) ? tTweening.onStartScope : tScope;
                            try
                            {
                                tTweening.onStart.apply(eventScope, tTweening.onStartParams);
                            }
                            catch (e2:Error)
                            {
                                handleError(tTweening, undefined, "onStart");
                            }
                        }
                        loc3 = 0;
                        loc4 = tTweening.properties;
                        for (pName in loc4)
                        {
                            if (tTweening.properties[pName].isSpecialProperty)
                            {
                                if (Boolean(_specialPropertyList[pName].preProcess))
                                {
                                    tTweening.properties[pName].valueComplete = _specialPropertyList[pName].preProcess(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].originalValueComplete, tTweening.properties[pName].extra);
                                }
                                pv = _specialPropertyList[pName].getValue(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                            }
                            else 
                            {
                                pv = tScope[pName];
                            }
                            tTweening.properties[pName].valueStart = isNaN(pv) ? tTweening.properties[pName].valueComplete : pv;
                        }
                        mustUpdate = true;
                        tTweening.hasStarted = true;
                    }
                    if (mustUpdate)
                    {
                        loc3 = 0;
                        loc4 = tTweening.properties;
                        for (pName in loc4)
                        {
                            tProperty = tTweening.properties[pName];
                            if (isOver)
                            {
                                nv = tProperty.valueComplete;
                            }
                            else 
                            {
                                if (tProperty.hasModifier)
                                {
                                    t = cTime - tTweening.timeStart;
                                    d = tTweening.timeComplete - tTweening.timeStart;
                                    nv = tTweening.transition(t, 0, 1, d, tTweening.transitionParams);
                                    nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
                                }
                                else 
                                {
                                    t = cTime - tTweening.timeStart;
                                    b = tProperty.valueStart;
                                    c = tProperty.valueComplete - tProperty.valueStart;
                                    d = tTweening.timeComplete - tTweening.timeStart;
                                    nv = tTweening.transition(t, b, c, d, tTweening.transitionParams);
                                }
                            }
                            if (tTweening.rounded)
                            {
                                nv = Math.round(nv);
                            }
                            if (tProperty.isSpecialProperty)
                            {
                                _specialPropertyList[pName].setValue(tScope, nv, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                                continue;
                            }
                            tScope[pName] = nv;
                        }
                        tTweening.updatesSkipped = 0;
                        if (Boolean(tTweening.onUpdate))
                        {
                            eventScope = Boolean(tTweening.onUpdateScope) ? tTweening.onUpdateScope : tScope;
                            try
                            {
                                tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                            }
                            catch (e3:Error)
                            {
                                handleError(tTweening, undefined, "onUpdate");
                            }
                        }
                    }
                    else 
                    {
                        loc4 = ((loc3 = tTweening).updatesSkipped + 1);
                        loc3.updatesSkipped = loc4;
                    }
                }
                if (isOver && Boolean(tTweening.onComplete))
                {
                    eventScope = Boolean(tTweening.onCompleteScope) ? tTweening.onCompleteScope : tScope;
                    try
                    {
                        tTweening.onComplete.apply(eventScope, tTweening.onCompleteParams);
                    }
                    catch (e4:Error)
                    {
                        handleError(tTweening, undefined, "onComplete");
                    }
                }
                return !isOver;
            }
            return true;
        }

        public static function setTimeScale(arg1:Number):void
        {
            var loc2:*;
            var loc3:*;

            loc2 = NaN;
            loc3 = NaN;
            if (isNaN(arg1))
            {
                arg1 = 1;
            }
            if (arg1 < 1e-005)
            {
                arg1 = 1e-005;
            }
            if (arg1 != _timeScale)
            {
                if (_tweenList != null)
                {
                    loc2 = 0;
                    while (loc2 < _tweenList.length) 
                    {
                        loc3 = getCurrentTweeningTime(_tweenList[loc2]);
                        _tweenList[loc2].timeStart = loc3 - (loc3 - _tweenList[loc2].timeStart) * _timeScale / arg1;
                        _tweenList[loc2].timeComplete = loc3 - (loc3 - _tweenList[loc2].timeComplete) * _timeScale / arg1;
                        if (_tweenList[loc2].timePaused != undefined)
                        {
                            _tweenList[loc2].timePaused = loc3 - (loc3 - _tweenList[loc2].timePaused) * _timeScale / arg1;
                        }
                        loc2 = (loc2 + 1);
                    }
                }
                _timeScale = arg1;
            }
            return;
        }

        public static function resumeAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                resumeTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        private static function handleError(arg1:caurina.transitions.TweenListObj, arg2:Error, arg3:String):void
        {
            var eventScope:Object;
            var loc4:*;
            var loc5:*;
            var pCallBackName:String;
            var pError:Error;
            var pTweening:caurina.transitions.TweenListObj;

            eventScope = null;
            pTweening = arg1;
            pError = arg2;
            pCallBackName = arg3;
            if (Boolean(pTweening.onError) && pTweening.onError as Function)
            {
                eventScope = Boolean(pTweening.onErrorScope) ? pTweening.onErrorScope : pTweening.scope;
                try
                {
                    pTweening.onError.apply(eventScope, [pTweening.scope, pError]);
                }
                catch (metaError:Error)
                {
                    printError(String(pTweening.scope) + " raised an error while executing the \'onError\' handler. Original error:\n " + pError.getStackTrace() + "\nonError error: " + undefined.getStackTrace());
                }
            }
            else 
            {
                if (!Boolean(pTweening.onError))
                {
                    printError(String(pTweening.scope) + " raised an error while executing the \'" + pCallBackName + "\'handler. \n" + pError.getStackTrace());
                }
            }
            return;
        }

        private static function startEngine():void
        {
            _engineExists = true;
            _tweenList = new Array();
            __tweener_controller__ = new MovieClip();
            __tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            _currentTimeFrame = 0;
            updateTime();
            return;
        }

        public static function removeAllTweens():Boolean
        {
            var loc1:*;
            var loc2:*;

            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc1 = false;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                removeTweenByIndex(loc2);
                loc1 = true;
                loc2 = (loc2 + 1);
            }
            return loc1;
        }

        public static function addTween(arg1:Object=null, arg2:Object=null):Boolean
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
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;

            loc3 = NaN;
            loc4 = NaN;
            loc5 = null;
            loc6 = null;
            loc13 = null;
            loc14 = null;
            loc15 = null;
            loc16 = NaN;
            loc17 = null;
            loc18 = null;
            loc19 = null;
            loc20 = null;
            if (!Boolean(arg1))
            {
                return false;
            }
            if (arg1 as Array)
            {
                loc6 = arg1.concat();
            }
            else 
            {
                loc6 = [arg1];
            }
            loc7 = TweenListObj.makePropertiesChain(arg2);
            if (!_inited)
            {
                init();
            }
            if (!_engineExists || !Boolean(__tweener_controller__))
            {
                startEngine();
            }
            loc8 = isNaN(loc7.time) ? 0 : loc7.time;
            loc9 = isNaN(loc7.delay) ? 0 : loc7.delay;
            loc10 = new Array();
            loc11 = {"time":true, "delay":true, "useFrames":true, "skipUpdates":true, "transition":true, "transitionParams":true, "onStart":true, "onUpdate":true, "onComplete":true, "onOverwrite":true, "onError":true, "rounded":true, "onStartParams":true, "onUpdateParams":true, "onCompleteParams":true, "onOverwriteParams":true, "onStartScope":true, "onUpdateScope":true, "onCompleteScope":true, "onOverwriteScope":true, "onErrorScope":true};
            loc12 = new Object();
            loc21 = 0;
            loc22 = loc7;
            for (loc5 in loc22)
            {
                if (loc11[loc5])
                {
                    continue;
                }
                if (_specialPropertySplitterList[loc5])
                {
                    loc17 = _specialPropertySplitterList[loc5].splitValues(loc7[loc5], _specialPropertySplitterList[loc5].parameters);
                    loc3 = 0;
                    while (loc3 < loc17.length) 
                    {
                        if (_specialPropertySplitterList[loc17[loc3].name])
                        {
                            loc18 = _specialPropertySplitterList[loc17[loc3].name].splitValues(loc17[loc3].value, _specialPropertySplitterList[loc17[loc3].name].parameters);
                            loc4 = 0;
                            while (loc4 < loc18.length) 
                            {
                                loc10[loc18[loc4].name] = {"valueStart":undefined, "valueComplete":loc18[loc4].value, "arrayIndex":loc18[loc4].arrayIndex, "isSpecialProperty":false};
                                loc4 = (loc4 + 1);
                            }
                        }
                        else 
                        {
                            loc10[loc17[loc3].name] = {"valueStart":undefined, "valueComplete":loc17[loc3].value, "arrayIndex":loc17[loc3].arrayIndex, "isSpecialProperty":false};
                        }
                        loc3 = (loc3 + 1);
                    }
                    continue;
                }
                if (_specialPropertyModifierList[loc5] != undefined)
                {
                    loc19 = _specialPropertyModifierList[loc5].modifyValues(loc7[loc5]);
                    loc3 = 0;
                    while (loc3 < loc19.length) 
                    {
                        loc12[loc19[loc3].name] = {"modifierParameters":loc19[loc3].parameters, "modifierFunction":_specialPropertyModifierList[loc5].getValue};
                        loc3 = (loc3 + 1);
                    }
                    continue;
                }
                loc10[loc5] = {"valueStart":undefined, "valueComplete":loc7[loc5]};
            }
            loc21 = 0;
            loc22 = loc10;
            for (loc5 in loc22)
            {
                if (_specialPropertyList[loc5] != undefined)
                {
                    loc10[loc5].isSpecialProperty = true;
                    continue;
                }
                if (loc6[0][loc5] != undefined)
                {
                    continue;
                }
                printError("The property \'" + loc5 + "\' doesn\'t seem to be a normal object property of " + String(loc6[0]) + " or a registered special property.");
            }
            loc21 = 0;
            loc22 = loc12;
            for (loc5 in loc22)
            {
                if (loc10[loc5] == undefined)
                {
                    continue;
                }
                loc10[loc5].modifierParameters = loc12[loc5].modifierParameters;
                loc10[loc5].modifierFunction = loc12[loc5].modifierFunction;
            }
            if (typeof loc7.transition != "string")
            {
                loc13 = loc7.transition;
            }
            else 
            {
                loc20 = loc7.transition.toLowerCase();
                loc13 = _transitionList[loc20];
            }
            if (!Boolean(loc13))
            {
                loc13 = _transitionList["easeoutexpo"];
            }
            loc3 = 0;
            while (loc3 < loc6.length) 
            {
                loc14 = new Object();
                loc21 = 0;
                loc22 = loc10;
                for (loc5 in loc22)
                {
                    loc14[loc5] = new PropertyInfoObj(loc10[loc5].valueStart, loc10[loc5].valueComplete, loc10[loc5].valueComplete, loc10[loc5].arrayIndex, {}, loc10[loc5].isSpecialProperty, loc10[loc5].modifierFunction, loc10[loc5].modifierParameters);
                }
                if (loc7.useFrames != true)
                {
                    loc15 = new TweenListObj(loc6[loc3], _currentTime + loc9 * 1000 / _timeScale, _currentTime + (loc9 * 1000 + loc8 * 1000) / _timeScale, false, loc13, loc7.transitionParams);
                }
                else 
                {
                    loc15 = new TweenListObj(loc6[loc3], _currentTimeFrame + loc9 / _timeScale, _currentTimeFrame + (loc9 + loc8) / _timeScale, true, loc13, loc7.transitionParams);
                }
                loc15.properties = loc14;
                loc15.onStart = loc7.onStart;
                loc15.onUpdate = loc7.onUpdate;
                loc15.onComplete = loc7.onComplete;
                loc15.onOverwrite = loc7.onOverwrite;
                loc15.onError = loc7.onError;
                loc15.onStartParams = loc7.onStartParams;
                loc15.onUpdateParams = loc7.onUpdateParams;
                loc15.onCompleteParams = loc7.onCompleteParams;
                loc15.onOverwriteParams = loc7.onOverwriteParams;
                loc15.onStartScope = loc7.onStartScope;
                loc15.onUpdateScope = loc7.onUpdateScope;
                loc15.onCompleteScope = loc7.onCompleteScope;
                loc15.onOverwriteScope = loc7.onOverwriteScope;
                loc15.onErrorScope = loc7.onErrorScope;
                loc15.rounded = loc7.rounded;
                loc15.skipUpdates = loc7.skipUpdates;
                removeTweensByTime(loc15.scope, loc15.properties, loc15.timeStart, loc15.timeComplete);
                _tweenList.push(loc15);
                if (loc8 == 0 && loc9 == 0)
                {
                    loc16 = (_tweenList.length - 1);
                    updateTweenByIndex(loc16);
                    removeTweenByIndex(loc16);
                }
                loc3 = (loc3 + 1);
            }
            return true;
        }

        public static function registerTransition(arg1:String, arg2:Function):void
        {
            if (!_inited)
            {
                init();
            }
            _transitionList[arg1] = arg2;
            return;
        }

        public static function printError(arg1:String):void
        {
            trace("## [Tweener] Error: " + arg1);
            return;
        }

        private static function affectTweens(arg1:Function, arg2:Object, arg3:Array):Boolean
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;

            loc5 = 0;
            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            loc9 = 0;
            loc4 = false;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc5 = 0;
            while (loc5 < _tweenList.length) 
            {
                if (_tweenList[loc5] && _tweenList[loc5].scope == arg2)
                {
                    if (arg3.length != 0)
                    {
                        loc6 = new Array();
                        loc7 = 0;
                        while (loc7 < arg3.length) 
                        {
                            if (Boolean(_tweenList[loc5].properties[arg3[loc7]]))
                            {
                                loc6.push(arg3[loc7]);
                            }
                            loc7 = (loc7 + 1);
                        }
                        if (loc6.length > 0)
                        {
                            if ((loc8 = AuxFunctions.getObjectLength(_tweenList[loc5].properties)) != loc6.length)
                            {
                                loc9 = splitTweens(loc5, loc6);
                                arg1(loc9);
                                loc4 = true;
                            }
                            else 
                            {
                                arg1(loc5);
                                loc4 = true;
                            }
                        }
                    }
                    else 
                    {
                        arg1(loc5);
                        loc4 = true;
                    }
                }
                loc5 = (loc5 + 1);
            }
            return loc4;
        }

        public static function getTweens(arg1:Object):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc2 = 0;
            loc3 = null;
            if (!Boolean(_tweenList))
            {
                return [];
            }
            loc4 = new Array();
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (Boolean(_tweenList[loc2]) && _tweenList[loc2].scope == arg1)
                {
                    loc5 = 0;
                    loc6 = _tweenList[loc2].properties;
                    for (loc3 in loc6)
                    {
                        loc4.push(loc3);
                    }
                }
                loc2 = (loc2 + 1);
            }
            return loc4;
        }

        public static function isTweening(arg1:Object):Boolean
        {
            var loc2:*;

            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return false;
            }
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (Boolean(_tweenList[loc2]) && _tweenList[loc2].scope == arg1)
                {
                    return true;
                }
                loc2 = (loc2 + 1);
            }
            return false;
        }

        public static function pauseTweenByIndex(arg1:Number):Boolean
        {
            var loc2:*;

            loc2 = _tweenList[arg1];
            if (loc2 == null || loc2.isPaused)
            {
                return false;
            }
            loc2.timePaused = getCurrentTweeningTime(loc2);
            loc2.isPaused = true;
            return true;
        }

        public static function getCurrentTweeningTime(arg1:Object):Number
        {
            return arg1.useFrames ? _currentTimeFrame : _currentTime;
        }

        public static function getTweenCount(arg1:Object):Number
        {
            var loc2:*;
            var loc3:*;

            loc2 = 0;
            if (!Boolean(_tweenList))
            {
                return 0;
            }
            loc3 = 0;
            loc2 = 0;
            while (loc2 < _tweenList.length) 
            {
                if (Boolean(_tweenList[loc2]) && _tweenList[loc2].scope == arg1)
                {
                    loc3 = loc3 + AuxFunctions.getObjectLength(_tweenList[loc2].properties);
                }
                loc2 = (loc2 + 1);
            }
            return loc3;
        }

        private static function stopEngine():void
        {
            _engineExists = false;
            _tweenList = null;
            _currentTime = 0;
            _currentTimeFrame = 0;
            __tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            __tweener_controller__ = null;
            return;
        }

        public static function removeTweensByTime(arg1:Object, arg2:Object, arg3:Number, arg4:Number):Boolean
        {
            var eventScope:Object;
            var i:uint;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var pName:String;
            var p_properties:Object;
            var p_scope:Object;
            var p_timeComplete:Number;
            var p_timeStart:Number;
            var removed:Boolean;
            var removedLocally:Boolean;
            var tl:uint;

            removedLocally = false;
            i = 0;
            pName = null;
            eventScope = null;
            p_scope = arg1;
            p_properties = arg2;
            p_timeStart = arg3;
            p_timeComplete = arg4;
            removed = false;
            tl = _tweenList.length;
            i = 0;
            while (i < tl) 
            {
                if (Boolean(_tweenList[i]) && p_scope == _tweenList[i].scope)
                {
                    if (p_timeComplete > _tweenList[i].timeStart && p_timeStart < _tweenList[i].timeComplete)
                    {
                        removedLocally = false;
                        loc6 = 0;
                        loc7 = _tweenList[i].properties;
                        for (pName in loc7)
                        {
                            if (!Boolean(p_properties[pName]))
                            {
                                continue;
                            }
                            if (Boolean(_tweenList[i].onOverwrite))
                            {
                                eventScope = Boolean(_tweenList[i].onOverwriteScope) ? _tweenList[i].onOverwriteScope : _tweenList[i].scope;
                                try
                                {
                                    _tweenList[i].onOverwrite.apply(eventScope, _tweenList[i].onOverwriteParams);
                                }
                                catch (e:Error)
                                {
                                    handleError(_tweenList[i], undefined, "onOverwrite");
                                }
                            }
                            _tweenList[i].properties[pName] = undefined;
                            delete _tweenList[i].properties[pName];
                            removedLocally = true;
                            removed = true;
                        }
                        if (removedLocally)
                        {
                            if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0)
                            {
                                removeTweenByIndex(i);
                            }
                        }
                    }
                }
                i = (i + 1);
            }
            return removed;
        }

        public static function registerSpecialPropertySplitter(arg1:String, arg2:Function, arg3:Array=null):void
        {
            var loc4:*;

            if (!_inited)
            {
                init();
            }
            loc4 = new SpecialPropertySplitter(arg2, arg3);
            _specialPropertySplitterList[arg1] = loc4;
            return;
        }

        public static function removeTweenByIndex(arg1:Number, arg2:Boolean=false):Boolean
        {
            _tweenList[arg1] = null;
            if (arg2)
            {
                _tweenList.splice(arg1, 1);
            }
            return true;
        }

        public static function resumeTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc4 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && loc3.indexOf(rest[loc4]) == -1)
                {
                    loc3.push(rest[loc4]);
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(resumeTweenByIndex, arg1, loc3);
        }

        public static function pauseTweens(arg1:Object, ... rest):Boolean
        {
            var loc3:*;
            var loc4:*;

            loc4 = 0;
            loc3 = new Array();
            loc4 = 0;
            while (loc4 < rest.length) 
            {
                if (typeof rest[loc4] == "string" && loc3.indexOf(rest[loc4]) == -1)
                {
                    loc3.push(rest[loc4]);
                }
                loc4 = (loc4 + 1);
            }
            return affectTweens(pauseTweenByIndex, arg1, loc3);
        }

        
        {
            _engineExists = false;
            _inited = false;
            _timeScale = 1;
        }

        private static var _timeScale:Number=1;

        private static var _currentTimeFrame:Number;

        private static var _specialPropertySplitterList:Object;

        private static var _engineExists:Boolean=false;

        private static var _specialPropertyModifierList:Object;

        private static var _currentTime:Number;

        private static var _tweenList:Array;

        private static var _specialPropertyList:Object;

        private static var _transitionList:Object;

        private static var _inited:Boolean=false;

        private static var __tweener_controller__:flash.display.MovieClip;
    }
}
