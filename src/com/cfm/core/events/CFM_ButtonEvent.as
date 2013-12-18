package com.cfm.core.events
{
	import flash.events.Event;

	public class CFM_ButtonEvent extends Event
	{
		public static const BUTTON_CLICKED:String = "buttonClicked";
		
		public var index					:Number;
		public var id						:String;
		public var value					:String;
		public var selected					:Boolean;
		public var label					:String;
		
		public function CFM_ButtonEvent(type:String, _index:Number, _id:String, _value:String, _label:String, _selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			index 							= _index;
			id 								= _id;
			value 							= _value;
			label							= _label;
			selected						= _selected;
		}
	}
}