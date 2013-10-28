package net.ored.util.out.adapters
{
	/**
	 * 
	 * 
	 * @copyright 		2013 Clickfire Media
	 * @author			Owen Corso
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */	
	public interface IOutAdapter
	{
		/**
		 * Out will print trace data to this function
		 *  
		 * @param $prefix A standard string that Out prefaces it's calls with. Looks something like "STATUS  :::	MyClass	::"
		 * @param $level Which debugging level this call is on.  See Out.as for a list of constants.
		 * @param $objects A list of all of the parameters passed into the Out call.
		 * 
		 */		
		function output($prefix:String, $level:String, ...$objects):void;
		
		/**
		 * Called on "Out.clear()"  This should clear the screen of your debugger.
		 */		
		function clear():void;
	}
}