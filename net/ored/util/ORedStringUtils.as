package net.ored.util
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ORedStringUtils extends EventDispatcher
	{
		public static function strEscape(value:String):String
		{
				var str:String = escape(value);
				str = str.replace(/\'/g, "%27");
				str = str.replace(/\//g, "%2F");
				str = str.replace(/\*/g, "%2A");
				str = str.replace(/\+/g, "%2B");
				str = str.replace(/@/g, "%40");
				return str;
			return value;
		}
		
		public function ORedStringUtils(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}