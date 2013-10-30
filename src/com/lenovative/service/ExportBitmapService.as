package com.lenovative.service
{
	import com.adobe.images.PNGEncoder;
	import com.lenovative.model.Constants;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Encoder;
	
	import net.ored.util.out.Out;
	
	public class ExportBitmapService extends EventDispatcher
	{
		public function export($bmd:BitmapData, $tw:String, $hash:String):void{
			
			//oc: largeImage
			var bytes			:ByteArray		= PNGEncoder.encode( $bmd );
			var encrypted1		:Base64Encoder 	= new Base64Encoder();
			encrypted1.encodeBytes(bytes);
			
			
			var _uploaderVars:URLVariables	= new URLVariables();
			_uploaderVars.largeImage 		= encrypted1;
			_uploaderVars.twitter_handle	= $tw;
			_uploaderVars.hastag			= $hash;
			
			var req:URLRequest 			= new URLRequest( Constants.ROUTE );
			req.data 					= _uploaderVars;
			req.method 					= URLRequestMethod.POST;
			
			var _uploader:URLLoader 	=  new URLLoader();
			_uploader.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_uploader.load(req);

		}
		
		protected function _onComplete($e:Event):void
		{
			Out.status(this, "_onComplete");
			
		}
		
		public function ExportBitmapService(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}