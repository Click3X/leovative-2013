package net.ored.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import net.ored.util.Environment;
	import net.ored.util.out.Out;
	import net.ored.util.out.adapters.ArthropodAdapter;

	public class ORedUtils
	{
		public static function turnOutOn():void{
			Out.enableAllLevels();
			Out.registerDebugger(new ArthropodAdapter(true));
			Out.clear();
		}//end function
		
		/**
		 * This is a utility function that traces an object to arthropod's array  
		 * @param $obj
		 * 
		 */		
		public static function objectToString($obj:Object):void{
			var a:Array = new Array();
			
			for (var e:String in $obj){
				var s:String = e + " : "+$obj[e];
				a.push(s);
			}
			Out.info(new Object(), a);
		}//end function
		
		/**
		 * This is a utility function that traces out an object
		 * specifically meant for the flashvars of a swf  
		 * @param $obj
		 * 
		 */		
		public static function printFlashVars($flashvars:Object):void{
			var o:Object = new Object();
			Out.info(o, "     Here are the flashvars:");
			Out.debug(o, "--------------------------------");
			for (var element:String in $flashvars){
				Out.info(o, element+" : "+$flashvars[element]);	
			}
			/*Out.warning(o, "os: "+Capabilities.os);
			Out.warning(o, "playerType: "+Capabilities.playerType);
			Out.warning(o, "serverString: "+Capabilities.playerType);
			Out.warning(o, "Security.REMOTE: "+Security.REMOTE);
			Out.warning(o, "Environment.IS_IN_BROWSER: "+Environment.IS_IN_BROWSER);*/
		
			Out.debug(o, "---------------------------------");
		}//end function
		
		/**
		 * This is a function that returns a sprite that is a rectangle 
		 * filled with either red or cyan (#00FFFF)
		 *  
		 * @param $w - width of the rectangle
		 * @param $h - height of the rectange
		 * 
		 * @return - the newly created sprite
		 * 
		 */		
		public static function gimmeRect($w:Number, $h:Number):Sprite{
			var r:Sprite = new Sprite();
			r.graphics.beginFill(0x00FFFF,1);
			r.graphics.drawRect(0,0,$w,$h);
			r.graphics.endFill();
			return r;
		}//end function
		public static function gimmeRectWithTransparency($w:Number, $h:Number, $c:uint, $a:Number):Sprite{
			var r:Sprite = new Sprite();
			r.graphics.beginFill($c,$a);
			r.graphics.drawRect(0,0,$w,$h);
			r.graphics.endFill();
			return r;
		}//end function
		
		public static function getRandomPointOnDisplayObj($do:DisplayObject, $stage:Stage):Point{
			
			
			return new Point();
		}//end function
		
		public static const MILLISECONDS_PERappModelINUTE		:int = 1000 * 60; 
		public static const MILLISECONDS_PER_HOUR 		:int = 1000 * 60 * 60; 
		public static const MILLISECONDS_PER_DAY		:int = 1000 * 60 * 60 * 24;  
		
		public static function getGMTAdjustedDate($d:Date, $o:Number):Date{
			var diff:Number = $o * MILLISECONDS_PER_HOUR; //3,600,000 milliseconds in an hour
			var aDate:Date 	= new Date($d.getTime() + diff);
			return aDate;
		}
	}//end class
}//end package