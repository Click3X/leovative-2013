package com.cfm.core.events
{
	import flash.events.Event;
	
	public class CFM_FormEvent extends Event
	{
		public static const SEND_COMPLETE:String = "sendComplete";
		public static const VALIDATE_FORM:String = "validateForm";
		public var result:String;
		public var valid:Boolean;
		
		public function CFM_FormEvent(type:String, _result:String, _valid:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			result = _result;
			valid = _valid;
			super(type, bubbles, cancelable);
		}
	}
}