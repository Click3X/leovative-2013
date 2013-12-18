package com.lenovative.controller
{
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import net.ored.util.out.Out;
	
	public class Compositor extends EventDispatcher
	{
		public static function getTiledImage($v:Vector.<Bitmap>):Bitmap{
			var o:Object = {};
			Out.status(o, "Compositor.getTiledImage: "+$v.length);
			
			var contactSheet:Sprite = new Sprite();
			
			var count:int = 0;
			for each(var e:* in $v){
				Out.debug(o, "e: "+e);
				
				switch (count){
					case 1: 	//top right img
						e.x = Constants.SIDE_LENGTH + Constants.GUTTER;
						break;
						
					case 2: 	//bottom left img
						e.y = Constants.SIDE_LENGTH + Constants.GUTTER;
						break;
					
					case 3:		//bottom right img
						e.x = Constants.SIDE_LENGTH + Constants.GUTTER;
						e.y = Constants.SIDE_LENGTH + Constants.GUTTER;
						break;
					
					default: Out.error(o,"NO IMAGE INDEX WTF");
				}

				contactSheet.addChild(e);
				count++;
			}
			
			var totalSize:Number = (Constants.SIDE_LENGTH*2)+Constants.GUTTER;
			var bmd:BitmapData = new BitmapData( totalSize, totalSize,true,0x00000000);
			
			bmd.draw(contactSheet);
			var bitmap:Bitmap = new Bitmap(bmd);
			bitmap.scaleX = bitmap.scaleY = Constants.SIDE_LENGTH/totalSize;
				
			return bitmap;
		}
	}
}