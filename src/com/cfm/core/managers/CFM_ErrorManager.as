package com.cfm.core.managers
{
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	public class CFM_ErrorManager
	{
		public static function ioError(e:IOErrorEvent):void{
			trace(e);
		}
		
		public static function reportError(e:Error):void{
			//trace(e);
		}
		
		public static function securityError(e:SecurityErrorEvent):void{
			trace(e);
		}
	}
}