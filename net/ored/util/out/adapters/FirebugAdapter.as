package net.ored.util.out.adapters
{
	
	import flash.external.ExternalInterface;
	
	/**
	 * A bridge for the Out class with the Firebug extension for Firefox (http://getfirebug.com/)
	 * 
	 * @copyright 		2013 Clickfire Media
	 * @author			Owen Corso
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */	
	public class FirebugAdapter implements IOutAdapter
	{
		public function FirebugAdapter(){
		}
		
		public function output($prefix:String, $level:String, ...$objects):void {
			if(!ExternalInterface.available) return;

			var output:String = $prefix;
			for(var k:String in $objects){	output += " "+$objects[k].toString();	}
			
			switch($level)
			{
				case "ERROR" :
					ExternalInterface.call("console.error",output);
					break;
				case "WARNING" :
					ExternalInterface.call("console.warn",output);
					break;
				case "FATAL" :
					ExternalInterface.call("console.error",output);
					break;
				case "DEBUG" :
					ExternalInterface.call("console.debug",output);
					break;
				case "STATUS" :
					ExternalInterface.call("console.log",output);
					break;
				case "INFO" :
					ExternalInterface.call("console.info",output);
					break;
				default:
					ExternalInterface.call("console.log",output);
					break;
			}
		};
		
		public function clear():void{
			if(ExternalInterface.available) ExternalInterface.call("console.clear");
		};
	}
}