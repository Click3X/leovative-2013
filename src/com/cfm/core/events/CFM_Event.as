package com.cfm.core.events
{
	import flash.events.Event;
	
	public class CFM_Event extends Event
	{
		static public const INIT				:String = "init";
		static public const DESTROY				:String = "destroy";
		
		public function CFM_Event(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}