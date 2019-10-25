package com.data {
	import com.data.DataHolder;
	import com.adobe.images.JPGEncoder;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*
	import flash.utils.*
	
	/**
	 * ...
	 * @author ...
	 */
	public class Publisher extends MovieClip
	{		
		var dataHolder:DataHolder = DataHolder.getInstance();
		
		function Publisher() {
			
		}	
		
		function createJPG(m:Sprite, q:Number)
		{
			
		}

		public function do_publish() {
			var jpgSource:BitmapData = new BitmapData (dataHolder.avatarHandler.width, dataHolder.avatarHandler.height);
			var container:Sprite = new Sprite();
			
			container.addChild(dataHolder.avatarHandler);
			var rec:Rectangle = dataHolder.avatarHandler.getBounds(container);
			
			dataHolder.avatarHandler.x -= rec.left;
			dataHolder.avatarHandler.y -= rec.top;
			
			jpgSource.draw(container);
			container.removeChild(dataHolder.avatarHandler);
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(100);
			var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);
			
			var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
			
			//Make sure to use the correct path to jpg_encoder_download.php
			
			
			var vars:String = 'username=' + dataHolder.clientInfo.username + '&email='+dataHolder.clientInfo.email + '&birth='+dataHolder.clientInfo.birth_data + '&sex='+dataHolder.clientInfo.sex + '&country='+dataHolder.clientInfo.country
			
			var jpgURLRequest:URLRequest = new URLRequest(DataHolder.URL_PHP_FILE_SEND_PATH + '?' + vars);
			jpgURLRequest.requestHeaders.push(header);				
			jpgURLRequest.method = URLRequestMethod.POST;				
			jpgURLRequest.data = jpgStream;
			
			var jpgURLLoader:URLLoader = new URLLoader();		
			navigateToURL(jpgURLRequest, "_self");
		}		
	}
	
}