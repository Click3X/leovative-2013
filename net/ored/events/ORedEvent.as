package net.ored.events
{
	import flash.events.Event;
	
	public class ORedEvent extends Event
	{
		private var _payload:Object;
		
		public function ORedEvent(type:String, $payload:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			payload = $payload;
		}

		public function get payload():Object
		{
			return _payload;
		}

		public function set payload(value:Object):void
		{
			_payload = value;
		}

	}
}