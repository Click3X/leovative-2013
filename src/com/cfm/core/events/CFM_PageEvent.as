package com.cfm.core.events
{
	import flash.events.Event;
	
	public class CFM_PageEvent extends Event
	{
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static const BUILD_COMPLETE:String = "destroyComplete";
		public static const DESTROY_COMPLETE:String = "destroyComplete";
		
		public var id:String;
		public var params:Object;
		
		public function CFM_PageEvent(type:String, _id:String = "", _params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			id = _id;
			params = _params;
		}
	}
}