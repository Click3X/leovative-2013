package net.ored.media
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.out.Out;
	
	
	public class ORedCamera extends EventDispatcher
	{
		public static const USER_DENIED_CAMERA		:String = "USER_DENIED_CAMERA";
		public static const USER_ACCEPTED_CAMERA	:String = "USER_ACCEPTED_CAMERA";
		public static const CAMERA_IS_ACTIVATED		:String = "CAMERA_IS_ACTIVATED";
		
		private var _width	:Number;
		private var _height	:Number;
		
		private var _view	:Sprite;
		private var cam		:Camera;
		private var vid		:Video;
		private var _isAvailable :Boolean = true;
		private var _aspectRatio	:Number;

		// =================================================
		// ================ Callable
		// =================================================
		public function takeSnapshot($w:Number, $h:Number):Bitmap{
			//Out.status(this, "takeSnapshot");
			
			var scale:Number = $w/_width;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var bmd:BitmapData = new BitmapData($w, $h, true, 0xffffff);
			bmd.draw(vid, matrix, null, null, null, true);//oc: last true for smoothing
			
			var img:Bitmap = new Bitmap(bmd, PixelSnapping.AUTO,true);
			
			//view.addChild(img);
			return img;
			
		}
		
		public function connectCamera():void {
			Out.status(this, "connectCamera");
			Out.debug(this, "cam.w: "+cam.width+", cam.h: "+cam.height);
			if (vid) 
				if (view.contains(vid)) view.removeChild(vid);
			cam.setMode(_width, _height, 24); 
			vid 			= new Video(_width, _height);
			vid.visible		= true;
			vid.attachCamera(cam);
			view.addChild(vid);    
			cam.addEventListener(ActivityEvent.ACTIVITY, checkActivity, false, 0, true);
			
		}
		public function init():void{
			Out.status(this, "init");
			view 	= new Sprite();
			cam 	= Camera.getCamera();
			
			if (!cam) {
				Out.error(this, "No camera is installed.");
				isAvailable = false;
				dispatchEvent(new ORedEvent(USER_DENIED_CAMERA)); 
			} else {
				_aspectRatio = cam.width/cam.height;
				
				Out.debug(this, "cam.w: "+cam.width+", cam.h: "+cam.height);
				var standard:Number = 4/3;
				standard == _aspectRatio ? Out.info("webcam is Standard def") : Out.info("webcam is WIDE SCREEN");
				//oc: NOT YET, we still need user's permission!! isAvailable = true;
				cam.addEventListener(StatusEvent.STATUS, _statusHandler); 
			}
		}
		// =================================================
		// ================ Workers
		// =================================================
		

		// =================================================
		// ================ Handlers
		// =================================================
		private function _statusHandler($e:StatusEvent):void 
		{ 
			Out.warning(this, "_statusHandler");
			switch ($e.code) 
			{ 
				case "Camera.Muted": 
					Out.warning(this, "User clicked Deny."); 
					isAvailable = false;
					dispatchEvent(new ORedEvent(USER_DENIED_CAMERA)); 
					break; 
				case "Camera.Unmuted": 
					dispatchEvent(new ORedEvent(USER_ACCEPTED_CAMERA)); 
					Out.warning(this, "User clicked Accept."); 
					isAvailable = true;
					break; 
			} 
		}
		
		private function checkActivity($e:ActivityEvent):void{
			dispatchEvent(new ORedEvent(CAMERA_IS_ACTIVATED));
		}

		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get view():Sprite
		{
			return _view;
		}
		
		public function set view(value:Sprite):void
		{
			_view = value;
		}

		public function get isAvailable():Boolean
		{
			return _isAvailable;
		}

		public function set isAvailable(value:Boolean):void
		{
			_isAvailable = value;
		}
		
		
		// =================================================
		// ================ Interfaced
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		public function dispose():void{
			if(cam.hasEventListener(StatusEvent.STATUS))	cam.removeEventListener(StatusEvent.STATUS, _statusHandler); 
			if(cam.hasEventListener(ActivityEvent.ACTIVITY))	cam.removeEventListener(ActivityEvent.ACTIVITY, checkActivity);
			if(isAvailable){
				vid.attachCamera(null);
				vid.clear();
				view.removeChild(vid);
				cam = null;
			}
			view = null;
		}
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function ORedCamera($w:Number, $h:Number)
		{
			_width 	= $w;
			_height = $h;
		}
	}
}