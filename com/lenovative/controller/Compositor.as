package com.lenovative.controller
{
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	
	import net.ored.util.out.Out;
	
	public class Compositor extends EventDispatcher
	{
		public static function getTiledImage($v:Vector.<Bitmap>):Bitmap{
			Out.status(new Object(), "Compositor.getTiledImage: "+$v.length);
			
			
			var bitmap:Bitmap = new Bitmap();
			
			return bitmap;
		}
	}
}