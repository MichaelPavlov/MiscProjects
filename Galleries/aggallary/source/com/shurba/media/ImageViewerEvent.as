package com.shurba.media {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ImageViewerEvent extends Event	{
		
		public static var IMAGE_LOAD_COMPLETE:String = "imageLoadComplete";
		public static var IMAGE_LOAD_ERROR:String = "imageLoadError";
		
		public function ImageViewerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
		}
		
	}

}