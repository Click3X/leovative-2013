package com.cfm.core.managers
{
	import com.cfm.core.interfaces.util.CFM_IResize;

	public class CFM_ResizeManager
	{
		private static var resizeQue:Array = [];
		
		public static function addToResizeQue(_object:CFM_IResize):void{
			if(resizeQue.indexOf(_object) == -1){
				resizeQue.push(_object);
				_object.onResize();
			}
		}
		
		public static function removeFromResizeQue(_object:CFM_IResize):void{
			if(resizeQue.indexOf(_object) != -1)
				resizeQue.splice(resizeQue.indexOf(_object),1);
		}
		
		public static function resize():void{
			for each(var o:CFM_IResize in resizeQue)
				o.onResize();
		}
	}
}