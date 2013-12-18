package com.cfm.core.managers
{
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	public class CFM_VideoPlayerManager
	{
		private static var connection:NetConnection;
		
		{
			trace("init --- videoplayer manager--");
		}
	
		public static function get netConnection():NetConnection{
			if(!connection){
				connection = new NetConnection();
				connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection.connect(null);
			}
			
			return connection;
		}
		
		private static function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("CFM_VideoPlayerManager---securityErrorHandler: " + event);
		}
	}
}