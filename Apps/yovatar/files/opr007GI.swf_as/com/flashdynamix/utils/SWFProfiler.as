package com.flashdynamix.utils 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.ui.*;
    import flash.utils.*;
    
    public class SWFProfiler extends Object
    {
        public function SWFProfiler()
        {
            super();
            return;
        }

        private static function addEvent(arg1:flash.events.EventDispatcher, arg2:String, arg3:Function):void
        {
            arg1.addEventListener(arg2, arg3, false, 0, true);
            return;
        }

        public static function stop():void
        {
            if (!started)
            {
                return;
            }
            started = false;
            removeEvent(frame, Event.ENTER_FRAME, draw);
            return;
        }

        public static function get averageFps():Number
        {
            return totalCount / runningTime;
        }

        public static function init(arg1:flash.display.Stage, arg2:flash.display.InteractiveObject):void
        {
            var loc3:*;

            if (inited)
            {
                return;
            }
            inited = true;
            stage = arg1;
            content = new ProfilerContent();
            frame = new Sprite();
            minFps = Number.MAX_VALUE;
            maxFps = Number.MIN_VALUE;
            minMem = Number.MAX_VALUE;
            maxMem = Number.MIN_VALUE;
            loc3 = new ContextMenu();
            loc3.hideBuiltInItems();
            ci = new ContextMenuItem("Show Profiler", true);
            addEvent(ci, ContextMenuEvent.MENU_ITEM_SELECT, onSelect);
            loc3.customItems = [ci];
            arg2.contextMenu = loc3;
            start();
            return;
        }

        public static function get currentMem():Number
        {
            return System.totalMemory / 1024 / 1000;
        }

        private static function get runningTime():Number
        {
            return (currentTime - initTime) / 1000;
        }

        private static function get intervalTime():Number
        {
            return (currentTime - itvTime) / 1000;
        }

        private static function resize(arg1:flash.events.Event):void
        {
            content.update(runningTime, minFps, maxFps, minMem, maxMem, currentFps, currentMem, averageFps, fpsList, memList, history);
            return;
        }

        private static function updateDisplay():void
        {
            updateMinMax();
            content.update(runningTime, minFps, maxFps, minMem, maxMem, currentFps, currentMem, averageFps, fpsList, memList, history);
            return;
        }

        private static function onSelect(arg1:flash.events.ContextMenuEvent):void
        {
            if (displayed)
            {
                hide();
            }
            else 
            {
                show();
            }
            return;
        }

        public static function get currentFps():Number
        {
            return frameCount / intervalTime;
        }

        private static function hide():void
        {
            ci.caption = "Show Profiler";
            displayed = false;
            removeEvent(stage, Event.RESIZE, resize);
            stage.removeChild(content);
            return;
        }

        private static function draw(arg1:flash.events.Event):void
        {
            var loc2:*;
            var loc3:*;

            currentTime = getTimer();
            frameCount++;
            totalCount++;
            if (intervalTime >= 1)
            {
                if (displayed)
                {
                    updateDisplay();
                }
                else 
                {
                    updateMinMax();
                }
                fpsList.unshift(currentFps);
                memList.unshift(currentMem);
                if (fpsList.length > history)
                {
                    fpsList.pop();
                }
                if (memList.length > history)
                {
                    memList.pop();
                }
                itvTime = currentTime;
                frameCount = 0;
            }
            return;
        }

        private static function updateMinMax():void
        {
            minFps = Math.min(currentFps, minFps);
            maxFps = Math.max(currentFps, maxFps);
            minMem = Math.min(currentMem, minMem);
            maxMem = Math.max(currentMem, maxMem);
            return;
        }

        public static function gc():void
        {
            var loc1:*;
            var loc2:*;

            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (e:Error)
            {
            };
            return;
        }

        public static function start():void
        {
            var loc1:*;

            if (started)
            {
                return;
            }
            started = true;
            itvTime = loc1 = getTimer();
            initTime = loc1;
            frameCount = loc1 = 0;
            totalCount = loc1;
            addEvent(frame, Event.ENTER_FRAME, draw);
            return;
        }

        private static function removeEvent(arg1:flash.events.EventDispatcher, arg2:String, arg3:Function):void
        {
            arg1.removeEventListener(arg2, arg3);
            return;
        }

        private static function show():void
        {
            ci.caption = "Hide Profiler";
            displayed = true;
            addEvent(stage, Event.RESIZE, resize);
            stage.addChild(content);
            updateDisplay();
            return;
        }

        
        {
            history = 60;
            fpsList = [];
            memList = [];
            displayed = false;
            started = false;
            inited = false;
        }

        private static var started:Boolean=false;

        private static var initTime:int;

        public static var memList:Array;

        public static var history:int=60;

        private static var itvTime:int;

        public static var minMem:Number;

        public static var fpsList:Array;

        private static var frameCount:int;

        private static var totalCount:int;

        private static var inited:Boolean=false;

        public static var minFps:Number;

        public static var maxMem:Number;

        private static var displayed:Boolean=false;

        public static var maxFps:Number;

        private static var currentTime:int;

        private static var frame:flash.display.Sprite;

        private static var ci:flash.ui.ContextMenuItem;

        private static var content:ProfilerContent;

        private static var stage:flash.display.Stage;
    }
}

import flash.display.*;
import flash.events.*;
import flash.text.*;


class ProfilerContent extends flash.display.Sprite
{
    public function ProfilerContent()
    {
        var loc1:*;

        super();
        fps = new Shape();
        mb = new Shape();
        box = new Shape();
        this.mouseChildren = false;
        this.mouseEnabled = false;
        fps.x = 65;
        fps.y = 45;
        mb.x = 65;
        mb.y = 90;
        loc1 = new TextFormat("_sans", 9, 11184810);
        infoTxtBx = new TextField();
        infoTxtBx.autoSize = TextFieldAutoSize.LEFT;
        infoTxtBx.defaultTextFormat = new TextFormat("_sans", 11, 13421772);
        infoTxtBx.y = 98;
        minFpsTxtBx = new TextField();
        minFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
        minFpsTxtBx.defaultTextFormat = loc1;
        minFpsTxtBx.x = 7;
        minFpsTxtBx.y = 37;
        maxFpsTxtBx = new TextField();
        maxFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
        maxFpsTxtBx.defaultTextFormat = loc1;
        maxFpsTxtBx.x = 7;
        maxFpsTxtBx.y = 5;
        minMemTxtBx = new TextField();
        minMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
        minMemTxtBx.defaultTextFormat = loc1;
        minMemTxtBx.x = 7;
        minMemTxtBx.y = 83;
        maxMemTxtBx = new TextField();
        maxMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
        maxMemTxtBx.defaultTextFormat = loc1;
        maxMemTxtBx.x = 7;
        maxMemTxtBx.y = 50;
        addChild(box);
        addChild(infoTxtBx);
        addChild(minFpsTxtBx);
        addChild(maxFpsTxtBx);
        addChild(minMemTxtBx);
        addChild(maxMemTxtBx);
        addChild(fps);
        addChild(mb);
        this.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
        this.addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
        return;
    }

    private function added(arg1:flash.events.Event):void
    {
        resize();
        stage.addEventListener(Event.RESIZE, resize, false, 0, true);
        return;
    }

    private function removed(arg1:flash.events.Event):void
    {
        stage.removeEventListener(Event.RESIZE, resize);
        return;
    }

    private function resize(arg1:flash.events.Event=null):void
    {
        var loc2:*;

        loc2 = box.graphics;
        loc2.clear();
        loc2.beginFill(0, 0.5);
        loc2.drawRect(0, (0), stage.stageWidth, 120);
        loc2.lineStyle(1, 16777215, 0.2);
        loc2.moveTo(65, 45);
        loc2.lineTo(65, 10);
        loc2.moveTo(65, 45);
        loc2.lineTo(stage.stageWidth - 15, 45);
        loc2.moveTo(65, 90);
        loc2.lineTo(65, 55);
        loc2.moveTo(65, 90);
        loc2.lineTo(stage.stageWidth - 15, 90);
        loc2.endFill();
        infoTxtBx.x = stage.stageWidth - infoTxtBx.width - 20;
        return;
    }

    public function update(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number, arg6:Number, arg7:Number, arg8:Number, arg9:Array, arg10:Array, arg11:int):void
    {
        var loc12:*;
        var loc13:*;
        var loc14:*;
        var loc15:*;
        var loc16:*;
        var loc17:*;
        var loc18:*;
        var loc19:*;

        loc19 = NaN;
        if (arg1 >= 1)
        {
            minFpsTxtBx.text = arg2.toFixed(3) + " Fps";
            maxFpsTxtBx.text = arg3.toFixed(3) + " Fps";
            minMemTxtBx.text = arg4.toFixed(3) + " Mb";
            maxMemTxtBx.text = arg5.toFixed(3) + " Mb";
        }
        infoTxtBx.text = "Current Fps " + arg6.toFixed(3) + "   |   Average Fps " + arg8.toFixed(3) + "   |   Memory Used " + arg7.toFixed(3) + " Mb";
        infoTxtBx.x = stage.stageWidth - infoTxtBx.width - 20;
        (loc12 = fps.graphics).clear();
        loc12.lineStyle(1, 3407616, 0.7);
        loc13 = 0;
        loc14 = arg9.length;
        loc15 = 35;
        loc17 = (loc16 = stage.stageWidth - 80) / (arg11 - 1);
        loc18 = arg3 - arg2;
        loc13 = 0;
        while (loc13 < loc14) 
        {
            loc19 = (arg9[loc13] - arg2) / loc18;
            if (loc13 != 0)
            {
                loc12.lineTo(loc13 * loc17, -loc19 * loc15);
            }
            else 
            {
                loc12.moveTo(0, -loc19 * loc15);
            }
            ++loc13;
        }
        (loc12 = mb.graphics).clear();
        loc12.lineStyle(1, 26367, 0.7);
        loc13 = 0;
        loc14 = arg10.length;
        loc18 = arg5 - arg4;
        loc13 = 0;
        while (loc13 < loc14) 
        {
            loc19 = (arg10[loc13] - arg4) / loc18;
            if (loc13 != 0)
            {
                loc12.lineTo(loc13 * loc17, -loc19 * loc15);
            }
            else 
            {
                loc12.moveTo(0, -loc19 * loc15);
            }
            ++loc13;
        }
        return;
    }

    private var maxFpsTxtBx:flash.text.TextField;

    private var minMemTxtBx:flash.text.TextField;

    private var fps:flash.display.Shape;

    private var box:flash.display.Shape;

    private var minFpsTxtBx:flash.text.TextField;

    private var maxMemTxtBx:flash.text.TextField;

    private var infoTxtBx:flash.text.TextField;

    private var mb:flash.display.Shape;
}