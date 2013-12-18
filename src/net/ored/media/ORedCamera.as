package net.ored.media
{
	import com.cfm.core.graphics.CFM_Graphics;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.lenovative.model.Constants;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	
	import net.ored.events.ORedEvent;
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
		
		private var _liveArea:Rectangle;
		private var _isActive:Boolean = false;
		
		private var overlay:Shape;
		private var _vid_mask:Shape;
		
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
			
			vid.scaleX = _vidscale*-1;
			vid.scaleY = _vidscale;
			
			vid.y = (_screenHeight-nvh)/2;
			vid.x = ((_screenWidth-nvw)/2)+nvw;
			
			
			_vid_mask.width = _screenWidth;
			_vid_mask.height = _screenHeight;
			
			redrawOverlay();
		}
		
		private function redrawOverlay():void{
			overlay.graphics.clear();
			overlay.graphics.beginFill(0xEEEEEE,.9);
			overlay.graphics.drawRect(0,0,_screenWidth, _screenHeight);
			overlay.graphics.lineStyle(6,0xFFFFFF,1);
			overlay.graphics.drawRect(_liveArea.x,_liveArea.y,_liveArea.width, _liveArea.height);
			overlay.graphics.endFill();
		}
		
		public function takeSnapshot():Bitmap{
			overlay.visible = false;
			
			
			var currvidwitdh:Number = vid.scaleX*-1920;
			var curvidx:Number = vid.x;
			
			vid.scaleX *= -1;
			vid.x -= currvidwitdh;
			
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
			
			vid.scaleX *= -1;
			vid.x = curvidx;
			
			overlay.visible = true;
			
			return img;
		}
		
		public function connect():void{
			cam = Camera.getCamera();
			
			if (!cam) {
				Out.error(this, "No camera is installed.");
				
				isAvailable = false;
				dispatchEvent(new ORedEvent(USER_DENIED_CAMERA)); 
			} else {
				Out.debug(this, "cam.w: "+cam.width+", cam.h: "+cam.height);
				
				cam.setMode(_cameraWidth,_cameraHeight,40);
				
				cam.addEventListener(StatusEvent.STATUS, _statusHandler); 
				cam.addEventListener(ActivityEvent.ACTIVITY, checkActivity, false, 0, true);
			}
			
			vid.attachCamera(cam);
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
				
				TweenMax.to(vid, .5, {alpha:1, onComplete:cameraReady});
			}
		}
		
		private function cameraReady():void{
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
		public function disconnect():void{
			if(cam.hasEventListener(StatusEvent.STATUS))	
				cam.removeEventListener(StatusEvent.STATUS, _statusHandler); 
					
			if(cam.hasEventListener(ActivityEvent.ACTIVITY))	
				cam.removeEventListener(ActivityEvent.ACTIVITY, checkActivity);
			
			vid.clear();
			vid.attachCamera(null);
			vid.alpha = 0;
			
			cam = null;
			
			_isActive = false;
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
			
			view 	= new Sprite();
			vid = new Video(_cameraWidth, _cameraHeight);
			vid.scaleX = -1;
			vid.alpha = 0;
			view.addChild(vid); 
			
			//live area
			_liveArea = new Rectangle(_screenHeight*8,_screenHeight*8);
			_liveArea.y 		= (_screenHeight-_liveArea.height)/2;
			
			overlay = new Shape();
			view.addChild(overlay);
			
			_vid_mask = new Shape();
			view.addChild(_vid_mask);
			_vid_mask.graphics.beginFill(0);
			_vid_mask.graphics.drawRect(0,0,10, 10);
			_vid_mask.graphics.endFill();
			vid.mask = _vid_mask;
		}
	}
}