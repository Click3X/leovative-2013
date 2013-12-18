package com.cfm.core.interfaces.media
{
	import flash.display.Bitmap;

	public interface CFM_IImage
	{
		function resize(	_width:Number, _height:Number, _delay:Number, 
							_tweenTime:Number, _ease:Object)							:void;
		
		function get loadedBitmap()														:Bitmap;
		function get url()																:String;
	}
}