package it.gotoandplay.smartfoxserver.http 
{
    import flash.events.*;
    import flash.net.*;
    
    public class LoaderFactory extends Object
    {
        public function LoaderFactory(arg1:Function, arg2:Function, arg3:int=8)
        {
            var loc4:*;
            var loc5:*;

            loc5 = null;
            super();
            loadersPool = [];
            loc4 = 0;
            while (loc4 < arg3) 
            {
                (loc5 = new URLLoader()).dataFormat = URLLoaderDataFormat.TEXT;
                loc5.addEventListener(Event.COMPLETE, arg1);
                loc5.addEventListener(IOErrorEvent.IO_ERROR, arg2);
                loc5.addEventListener(IOErrorEvent.NETWORK_ERROR, arg2);
                loadersPool.push(loc5);
                ++loc4;
            }
            currentLoaderIndex = 0;
            return;
        }

        public function getLoader():flash.net.URLLoader
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;

            loc1 = loadersPool[currentLoaderIndex];
            currentLoaderIndex++;
            if (currentLoaderIndex >= loadersPool.length)
            {
                currentLoaderIndex = 0;
            }
            return loc1;
        }

        private static const DEFAULT_POOL_SIZE:int=8;

        private var currentLoaderIndex:int;

        private var loadersPool:Array;
    }
}
