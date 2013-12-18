package net.ored.media
{
	import com.lenovative.model.Constants;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	
	public class ORedCamera extends EventDispatcher
	{
		public static const USER_DENIED_CAMERA		:String = "USER_DENIED_CAMERA";
		public static const USER_ACCEPTED_CAMERA	:String = "USER_ACCEPTED_CAMERA";
		public static const CAMERA_IS_ACTIVATED		:String = "CAMERA_IS_ACTIVATED";
		
		private var _screenWidth			:Number;
		private var _screenHeight			:Number;
		
		private var _cameraWidth			:Number;
		private var _cameraHeight			:Number;
		
		private var _view			:Sprite;
		private var cam				:Camera;
		private var vid				:Video;
		private var _isAvailable 	:Boolean = true;
		private var _aspectRatio	:Number;
		
		private var _liveArea:Sprite;
		private var _isActive:Boolean = false;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function resize($w:Number, $h:Number):void{
			Out.status(this,"resize");
			
			_screenWidth = $w;
			_screenHeight = $h;
			
			_liveArea.width 	=
			_liveArea.height 	= _screenHeight*.8;
			_liveArea.x 		= (_screenWidth-_liveArea.width)/2;
			_liveArea.y 		= (_screenHeight-_liveArea.height)/2;
			
			var _vidscale:Number = 1;
			
			_vidscale = _screenWidth/1920;
			
			if(1080*_vidscale < _screenHeight)
				_vidscale = _screenHeight/1080;
			
			var nvw:Number = _vidscale*1920;
			var nvh:Number = _vidscale*1080;
			
			vid.mask = _liveArea;
			
			vid.scaleX = _vidscale*-1;
			vid.scaleY = _vidscale;
			
			vid.y = (_screenHeight-nvh)/2;
			vid.x = ((_screenWidth-nvw)/2)+nvw;
			
		}
		
		public function takeSnapshot():Bitmap{
			_liveArea.visible = false;
			
			Out.status(this, "takeSnapshot");
			
			var _scale:Number = Constants.SIDE_LENGTH/_liveArea.width;
			
			//crop using the matrix and cropRect
			var matrix:Matrix = new Matrix();
			matrix.translate(- _liveArea.x, -_liveArea.y);
			matrix.scale(_scale,_scale);
			
			var cropSquare:Rectangle = new Rectangle(0,0,Constants.SIDE_LENGTH,Constants.SIDE_LENGTH);
			
			var bmd:BitmapData = new BitmapData(Constants.SIDE_LENGTH, Constants.SIDE_LENGTH, false, Math.random() * 0xFFFFFF);
			bmd.draw(view, matrix, null, null, cropSquare, true);
			
			var img:Bitmap = new Bitmap(bmd, PixelSnapping.AUTO, true);
			
			_liveArea.visible = true;
			
			return img;
		}
		
		public function connectCamera():void {
			Out.status(this, "connectCamera");
			Out.debug(this, "cam.w: "+cam.width+", cam.h: "+cam.height);
			
			if(vid) 
				if(view.contains(vid)) view.removeChild(vid);
			
			vid 			= new Video(_cameraWidth, _cameraHeight);
			vid.scaleX = -1;
			vid.visible		= true;
			vid.attachCamera(cam);
			view.addChild(vid);    
			cam.addEventListener(ActivityEvent.ACTIVITY, checkActivity, false, 0, true);
			
			//live area
			_liveArea = ORedUtils.gimmeRectWithTransparency(_screenHeight*8,_screenHeight*8, 0x00ffff, .2);
			_liveArea.x 		= (_screenWidth-_liveArea.width)/2;
			_liveArea.y 		= (_screenHeight-_liveArea.height)/2;
			_view.addChild(_liveArea);
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
				cam.setMode(_cameraWidth,_cameraHeight,40);
				
				Out.debug(this, "cam.w: "+cam.width+", cam.h: "+cam.height);
				cam.addEventListener(StatusEvent.STATUS, _statusHandler); 
			}
			
			//view.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void{
			//Out.status(this, "onFrame: ", vid.videoWidth);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		

		// =================================================
		// ================ Handlers
		// =================================================
		private function _statusHandler($e:StatusEvent):void 
		{ 
			Out.warning(this, "_statusHandler",$e.code);
			
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
			if(!_isActive){
				_isActive = true;
				dispatchEvent(new ORedEvent(CAMERA_IS_ACTIVATED));
			}
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
			if(cam.hasEventListener(StatusEvent.STATUS))	
				cam.removeEventListener(StatusEvent.STATUS, _statusHandler); 
			
			if(cam.hasEventListener(ActivityEvent.ACTIVITY))	
				cam.removeEventListener(ActivityEvent.ACTIVITY, checkActivity);
			
			if(isAvailable){
				vid.attachCamera(null);
				vid.clear();
				view.removeChild(vid);
				cam = null;
			}
			
			_isActive = false;
			
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
			_cameraWidth 	= _screenWidth 		= $w;
			_cameraHeight 	= _screenHeight 	= $h;
		}
	}
}