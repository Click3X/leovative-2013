package com.lenovative.controller
{
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	public class Compositor extends EventDispatcher
	{
		public static function getTiledImage($v:Vector.<Bitmap>):Bitmap{
			var o:Object = {};//for Out traces in static function
			Out.status(o, "Compositor.getTiledImage: "+$v.length);
			
			var contactSheet:Sprite = new Sprite();
			
			var count:int = 0;
			for each(var e:* in $v){
				
				Out.debug(o, "e: "+e);
				
				switch (count){
					case 0: 	//top left img

						e.x = Constants.LEFT_MARGIN;
						e.y = Constants.TOP_MARGIN;
						break;
					
					case 1: 	//top right img
		
						e.x = Constants.LEFT_MARGIN + Constants.SIDE_LENGTH + Constants.GUTTER;
						e.y = Constants.TOP_MARGIN;
						break;
						
					case 2: 	//bottom left img
						
						e.x = Constants.LEFT_MARGIN;
						e.y = Constants.TOP_MARGIN + Constants.SIDE_LENGTH + Constants.GUTTER;
						break;
					
					case 3:		//bottom right img
						
						e.x = Constants.LEFT_MARGIN + Constants.SIDE_LENGTH + Constants.GUTTER;
						e.y = Constants.TOP_MARGIN + Constants.SIDE_LENGTH + Constants.GUTTER;
						break;
					
					default: Out.error(o,"NO IMAGE INDEX WTF");
			
				}
				//position each photo and set up the next 

				contactSheet.addChild(e);
				count++;
			}
//			var bmd:BitmapData = new BitmapData(contactSheet.width, contactSheet.height,true,0xFFFFFF);
			var bmd:BitmapData = new BitmapData(Constants.PHOTO_WIDTH, Constants.PHOTO_HEIGHT,true,Math.random() * 0xFFFFFF);
			
			//oc: debug
			var m:Model = Model.getInstance();
			m.stageRef.addChild(contactSheet);
			
			bmd.draw(contactSheet);
			var bitmap:Bitmap = new Bitmap(bmd);
			
			return bitmap;
		}
	}
}