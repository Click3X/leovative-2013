package
{
	import com.lenovative.controller.CaptureScreen;
	import com.lenovative.controller.Compositor;
	import com.lenovative.controller.FinishScreen;
	import com.lenovative.controller.StartScreen;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedEvent;
	import net.ored.events.ORedNavEvent;
	import net.ored.media.ORedCamera;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	[SWF(backgroundColor="#ff0000", frameRate="30", quality="HIGH")]
	public class Lenovative extends Sprite
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		public var oredCamera:ORedCamera;
		
		private var _startScreen:StartScreen;
		private var _captureScreen:CaptureScreen;
		private var _finishScreen:FinishScreen;
		// =================================================
		// ================ Public
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		private function _createCamera():void
		{
			oredCamera = new ORedCamera(stage.stageWidth,stage.stageHeight);
			oredCamera.init();
			oredCamera.connectCamera();
			oredCamera.view.visible = false;
			oredCamera.addEventListener(ORedCamera.USER_ACCEPTED_CAMERA, _startApp);
			addChildAt(oredCamera.view,0);
		}
		
		private function _createChildren():void
		{
			
			//start screen
			_startScreen = new StartScreen();
			_startScreen.init();
			_startScreen.addEventListener(Constants.START, _beginFilmStrip);
			addChild(_startScreen.view);

			//full screen button
			_startScreen.view.fsBtn.addEventListener(MouseEvent.CLICK, _enterFullScreen);
				
			//capture screen
			_captureScreen = new CaptureScreen();
			_captureScreen.addEventListener(Constants.CAPTURE_BITMAP, _captureBitmap);
			_captureScreen.init();
			addChild(_captureScreen.view);
			
			//finish screen
			_finishScreen = new FinishScreen();
			_finishScreen.init();
			addChild(_finishScreen.view);
			
			//load screens into model
			_m.screens.push(_startScreen);
			_m.screens.push(_captureScreen);
			_m.screens.push(_finishScreen);
		}
		
		protected function _beginFilmStrip($e:ORedEvent):void
		{
			Out.status(this, "_beginFilmStrip");
			_captureScreen.start();
		}
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _startApp($e:ORedEvent):void{
			//start the app.
			_startScreen.transitionIn();
		}
		protected function _screenChange($e:ORedNavEvent):void{
			switch($e.screen){
				case Constants.START: 
					_startScreen.transitionIn();
					break;
				case Constants.CAPTURE: 
					_captureScreen.start();
					break;
				case Constants.FINISH:
					_finishScreen.transitionIn();
					break;
			}
		}
		protected function _enterFullScreen(event:MouseEvent):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN; 
			oredCamera.resize(stage.fullScreenWidth, stage.fullScreenHeight);
			oredCamera.connectCamera();
				
			for(var e:* in _m.screenIds){
				IScreen(_m.getScreenById(e)).resize();
					
			}
		}
		protected function _debug($e:MouseEvent):void{
			Out.status(this, "debug");
			Out.debug(this, "ORedCamera.view.x: "+oredCamera.view.x);
			
		}
		protected function _captureBitmap($e:ORedEvent):void{
			Out.status(this, "_captureBitmap: index: "+ $e.payload.index);
			var img:Bitmap = oredCamera.takeSnapshot(stage.fullScreenWidth, stage.fullScreenHeight);
			_m.curPics.push(img);
			
			//oc: now that we're on the last photo, create 4-up image 
			if($e.payload.index == 3) {
				_m.compositedImage = Compositor.getTiledImage(_m.curPics);
				//oc: make call with 
					//_controls.view.tf.text; 
					// Base64 encoded byte array 
				
			//	addChild(_m.compositedImage);
			}
		}
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function Lenovative()
		{
			//log
			ORedUtils.turnOutOn();
			Out.info(this, "Hello Lenovative");
			
			//fix stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			
			//model
			_m 				= Model.getInstance();
			_m.init(stage);
			
			//prepare display objects
			_createChildren();
			_createCamera();

		}
		


	}
}