package MyLife 
{
    import com.adobe.images.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class JPEGSnapshot extends flash.display.MovieClip
    {
        public function JPEGSnapshot(arg1:int=85, arg2:int=0, arg3:int=0, arg4:Boolean=true)
        {
            super();
            _encodeQuality = arg1;
            this.imageWidth = arg2;
            this.imageHeight = arg3;
            this.resize = arg4;
            return;
        }

        public function setUploadServer(arg1:String):void
        {
            _uploadServerURL = arg1;
            return;
        }

        public function capture(arg1:flash.display.DisplayObject, arg2:String="0"):void
        {
            var bitmapHeight:int;
            var bitmapWidth:int;
            var destHeight:Number;
            var destWidth:Number;
            var dx:Number;
            var dy:Number;
            var header:flash.net.URLRequestHeader;
            var id:String="0";
            var jpgEncoder:com.adobe.images.JPGEncoder;
            var jpgSource:flash.display.BitmapData;
            var jpgStream:flash.utils.ByteArray;
            var jpgURLRequest:flash.net.URLRequest;
            var loc3:*;
            var loc4:*;
            var matrix:flash.geom.Matrix;
            var mcHeight:Number;
            var mcWidth:Number;
            var movieClip:flash.display.DisplayObject;
            var scale:Number;
            var xScale:Number;
            var yScale:Number;

            mcWidth = NaN;
            mcHeight = NaN;
            xScale = NaN;
            yScale = NaN;
            movieClip = arg1;
            id = arg2;
            trace("capture");
            if (JPEGSnapshot.jpgURLLoader)
            {
                try
                {
                    JPEGSnapshot.jpgURLLoader.close();
                }
                catch (error:Error)
                {
                    trace("capture error:" + undefined);
                }
            }
            if (movieClip.mask)
            {
                mcWidth = movieClip.mask.width;
                mcHeight = movieClip.mask.height;
            }
            else 
            {
                mcWidth = movieClip.width;
                mcHeight = movieClip.height;
            }
            bitmapWidth = this.imageWidth || mcWidth;
            bitmapHeight = this.imageHeight || mcHeight;
            if (bitmapWidth > this.maxLength)
            {
                bitmapWidth = maxLength;
            }
            if (bitmapHeight > this.maxLength)
            {
                bitmapHeight = maxLength;
            }
            scale = 1;
            if (this.resize)
            {
                xScale = bitmapWidth / mcWidth;
                yScale = bitmapHeight / mcHeight;
                if (xScale < yScale)
                {
                    scale = xScale;
                }
                else 
                {
                    scale = yScale;
                }
            }
            destWidth = mcWidth * scale;
            destHeight = mcHeight * scale;
            dx = bitmapWidth - destWidth >> 1;
            dy = bitmapHeight - destHeight >> 1;
            matrix = new Matrix();
            matrix.scale(scale, scale);
            matrix.translate(dx, dy);
            jpgSource = new BitmapData(bitmapWidth, bitmapHeight);
            jpgSource.draw(movieClip, matrix);
            jpgEncoder = new JPGEncoder(_encodeQuality);
            jpgStream = jpgEncoder.encode(jpgSource);
            header = new URLRequestHeader("Content-type", "application/octet-stream");
            jpgURLRequest = new URLRequest(_uploadServerURL + "up.php?id=" + id);
            jpgURLRequest.requestHeaders.push(header);
            jpgURLRequest.method = URLRequestMethod.POST;
            jpgURLRequest.data = jpgStream;
            JPEGSnapshot.jpgURLLoader = new URLLoader();
            JPEGSnapshot.jpgURLLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
            JPEGSnapshot.jpgURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            JPEGSnapshot.jpgURLLoader.load(jpgURLRequest);
            return;
        }

        private function onLoaderComplete(arg1:flash.events.Event):void
        {
            if (arg1.target.data != "1")
            {
                dispatchEvent(new MyLifeEvent(MyLifeEvent.PROGRESS_COMPLETE, {"success":false}, false));
            }
            else 
            {
                dispatchEvent(new MyLifeEvent(MyLifeEvent.PROGRESS_COMPLETE, {"success":true}, false));
            }
            return;
        }

        private function onLoaderError(arg1:flash.events.IOErrorEvent):void
        {
            dispatchEvent(new MyLifeEvent(MyLifeEvent.PROGRESS_COMPLETE, {"success":false}, false));
            return;
        }

        private const maxLength:int=640;

        public const LOADING_COMPLETE:String="JPEGSnapshot_LOADING_COMPLETE";

        private var imageHeight:int;

        private var resize:Boolean;

        private var imageWidth:int;

        private var _uploadServerURL:String="";

        private var _encodeQuality:int=85;

        private static var jpgURLLoader:flash.net.URLLoader;
    }
}
