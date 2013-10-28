package net.ored.events
{
	import flash.events.Event;
	
	public class ORedNavEvent extends Event
	{
		public static const SCREEN_CHANGE:String = "screenChange";
		
		public var screen:String;
		
		public function ORedNavEvent($screen:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SCREEN_CHANGE, bubbles, cancelable);
			screen = $screen;
		}
	}
}