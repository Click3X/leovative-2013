package com.cfm.core.events
{
	import flash.events.Event;
	
	public class CFM_FormFieldEvent extends Event
	{
		public static const VALIDATE:String = "validate";
		public var valid:Boolean;
		public var text:String;
		
		public function CFM_FormFieldEvent(type:String, _text:String, _valid:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			valid = _valid;
			text = _text;
			
			super(type, bubbles, cancelable);
		}
	}
}