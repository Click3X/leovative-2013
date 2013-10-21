package net.ored.util.out.adapters
{
	import com.carlcalderon.arthropod.Debug;
	
	import flash.display.Bitmap;
	
	/**
	 * A bridge for the Out class with the Athropod debugger (http://arthropod.stopp.se/)
	 * 
	 * @copyright 		2013 Clickfire Media
	 * @author			Owen Corso
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */	
	
	public class ArthropodAdapter implements IOutAdapter
	{
		private var _traceObjects	:Boolean = false;
		
		public function set traceAsObjects($val:Boolean):void { _traceObjects = $val; }
		
		/**
		 * Construct
		 * Pass in an optional parameter to trace objects using special arthropod
		 * debug features as opposed to strings which is the default
		 */		
		public function ArthropodAdapter($traceAsObjects:Boolean=false) {
			_traceObjects = $traceAsObjects;
		};
		
		/**
		 * Clear the viewer input 
		 */		
		public function clear():void {
			Debug.clear();
		};
		
		/**
		 * Called when it receives data for output to debugger  
		 */		
		public function output($prefix:String, $level:String, ...$objects):void {
			var output:String = $prefix;
			
			for(var i:String in $objects){
				output += " "+$objects[i];
			}
			
			if(_traceObjects && $objects[0] is Array){	Debug.array($objects[0]); return;	}
			if(_traceObjects && $objects[0] is Bitmap){	Debug.bitmap($objects[0]); return;	}
			
			switch($level)
			{
				case "ERROR" :
					Debug.error(output);
					break;
				case "WARNING" :
					Debug.warning(output);
					break;
				case "FATAL" :
					Debug.log(output, Debug.RED);
					break;
				case "DEBUG" :
					Debug.log(output, Debug.PINK);
					break;
				case "STATUS" :
					Debug.log(output, Debug.GREEN);
					break;
				case "INFO" :
					Debug.log(output);
					break;
				case "" :
				case "OBJECT" :
					Debug.log(output, 0xBCF100);
					break;
				default:
					break;
			}
		};
	}
}