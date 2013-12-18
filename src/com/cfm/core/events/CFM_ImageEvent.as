package com.cfm.core.events
{
	import flash.events.Event;
	import flash.display.Bitmap;

	public class CFM_ImageEvent extends Event
	{
		public static const COMPLETE					:String = "complete";
		public static const LOADER_PROGRESS				:String = "loaderProgress";
		
		public var url						:String;
		public var bmp						:Bitmap;
		public var percent					:Number;
		
		public function CFM_ImageEvent(type:String, _url:String, _bmp:Bitmap, _percent:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			url								= _url;
			bmp								= _bmp;
			percent							= _percent;
		
		}
	}
}