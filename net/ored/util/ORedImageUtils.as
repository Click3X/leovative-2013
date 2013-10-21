package net.ored.util
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import net.ored.util.out.Out;
	
	import sharp.model.Model;

	public class ORedImageUtils
	{
		/**
		 * This function takes a bitmap and sizes it to the specified dimensions 
		 * white-letterboxing the new bitmap if necessary
		 * 
		 * @param $w
		 * @param $h
		 * @param $bgColor
		 * @param $src
		 * @return 
		 * 
		 */		
		public static function sizeBitmapData($w:Number, $h:Number, $bgColor:Number, $src:BitmapData):BitmapData{
			var leftOffset:Number,topOffset:Number = 0;			
			var bmd:BitmapData 	= new BitmapData($w,$h,false,$bgColor);
			var matrix:Matrix	= new Matrix();
			var s:Number 		= $h/$src.height;
			if($src.width*s > $w) {
				s = $w/$src.width;
				topOffset		= Math.floor(($h - $src.height*s)/2);
				Out.info(new Object(),"width is larger than height, center vertically: "+topOffset);
			}else{
				leftOffset = Math.floor(($w - $src.width*s)/2);
				Out.warning(new Object(),"center horizontally:"+leftOffset);
			}

			matrix.scale(s,s);
			matrix.ty 			= topOffset;
			matrix.tx			= leftOffset;
			bmd.draw($src, matrix,null,null,null,true);
			return bmd;
		}
		
	}
}