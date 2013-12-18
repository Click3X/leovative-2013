package com.cfm.core.events{
	
	import flash.events.Event;
	
	public class CFM_ScrollBarEvent extends Event {
		
		public static const SCROLLING:String = "scrolling";
		
		public var percent:Number;
		
		public function CFM_ScrollBarEvent( _type:String , _percent:Number, _bubbles:Boolean = true, _cancelable:Boolean = false ) {
			super(_type, _bubbles, _cancelable);
			
			percent = _percent;
		}
	}
}