package net.ored.events{
	
	import flash.events.Event;
	
	public class OutEvent extends Event{
		
		public static const ALL			: String = "all";
		public static const INFO		: String = "info";
		public static const STATUS		: String = "status";
		public static const DEBUG		: String = "debug";
		public static const WARNING		: String = "warning";
		public static const ERROR		: String = "error";
		public static const FATAL		: String = "fatal";
		
		public var output				: String;
		
		public function OutEvent($type:String, $out:String){
			super($type);
			output = $out;
		}

		public override function clone():Event{
			return new OutEvent(type, output);
		}
	}
}