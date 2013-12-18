package
{
	import com.lenovative.controller.CaptureScreen;
	import com.lenovative.controller.Compositor;
	import com.lenovative.controller.FinishScreen;
	import com.lenovative.controller.StartScreen;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	import com.lenovative.service.ExportBitmapService;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedEvent;
	import net.ored.events.ORedNavEvent;
	import net.ored.media.ORedCamera;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="40", quality="HIGHEST")]
	public class Lenovative extends Sprite
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		public var oredCamera:ORedCamera;
		private var _exporter:ExportBitmapService;
		
		//screens
		private var _startScreen:StartScreen;
		private var _captureScreen:CaptureScreen;
		private var _finishScreen:FinishScreen;
		
		// =================================================
		// ================ Public
		// =================================================
		protected function screenChange($e:ORedNavEvent):void{
			Out.info(this, "screenChange: " +$e.screen);
			
			switch($e.screen){
				case Constants.START: 
					oredCamera.view.visible = false;
					
					_finishScreen.transitionOut();
					_captureScreen.transitionOut();
					
					_startScreen.transitionIn();
					break;
				case Constants.CAPTURE: 
					oredCamera.view.visible = true;
					
					_finishScreen.transitionOut();
					_startScreen.transitionOut();
					
					_captureScreen.transitionIn();
					break;
				case Constants.FINISH:
					//oc: create 4-up image 
					_m.compositedImage 	= Compositor.getTiledImage(_m.curPics);
					
					_finishScreen.addPhoto(_m.compositedImage, _m.curPics);
					
					oredCamera.view.visible 	= false;
					
					_captureScreen.transitionOut();
					_startScreen.transitionOut();
					
					_finishScreen.transitionIn();
					break;
			}
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		private function _createCamera():void
		{
			oredCamera = new ORedCamera(1920,1080);
			oredCamera.init();
			oredCamera.connectCamera();
			oredCamera.addEventListener(ORedCamera.CAMERA_IS_ACTIVATED, _cameraReady)
			
			//oc: hide camera initially
			oredCamera.view.visible = false;
			addChildAt(oredCamera.view,0);
		}
		
		private function _createChildren():void
		{
			//start screen
			_startScreen = new StartScreen();
			_startScreen.init();
			addChild(_startScreen.view);

			//capture screen
			_captureScreen = new CaptureScreen();
			_captureScreen.addEventListener(Constants.CAPTURE_BITMAP, _captureBitmap);
			_captureScreen.init();
			addChild(_captureScreen.view);
			
			//finish screen
			_finishScreen = new FinishScreen();
			_finishScreen.init();
			_finishScreen.view.saveBtn.addEventListener(MouseEvent.CLICK, _exportBitmap);
			addChild(_finishScreen.view);
			
			//load screens into model
			_m.screens.push(_startScreen);
			_m.screens.push(_captureScreen);
			_m.screens.push(_finishScreen);	
			
			//listen for screen change event
			for each (var s:IScreen in _m.screens) s.addEventListener(ORedNavEvent.SCREEN_CHANGE, screenChange);
		}
		
		protected function _exportBitmap($e:MouseEvent):void
		{
			Out.status(this, "_exportBitmap");
			_exporter.export(_m.compositedImage.bitmapData, _m.twitterHandle, _m.twitterHashtag);
		}
		
		protected function _cameraReady($e:ORedEvent):void{
			_startScreen.transitionIn();
		}

		protected function _onResize($e:Event = null):void
		{
			Out.status(this, "_onResize");
			
			_m.stageRef.stageWidth = stage.stageWidth;
			_m.stageRef.stageHeight	= stage.stageHeight;
				
			oredCamera.resize(_m.stageRef.stageWidth, _m.stageRef.stageHeight);
			
			for each(var s:IScreen in _m.screens) s.resize();
		}	

		protected function _captureBitmap($e:ORedEvent):void{
			Out.status(this, "_captureBitmap: index: "+ $e.payload.index);
			
			var img:Bitmap = oredCamera.takeSnapshot();
			_m.curPics.push(img);
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
			
			//config stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			
			//model
			_m 				= Model.getInstance();
			_m.init(stage);
			
			//prepare display objects
			_createChildren();
			_createCamera();
			_exporter = new ExportBitmapService();
			
			_onResize();
			stage.addEventListener(Event.RESIZE, _onResize, false, 0, true);
		}
	}
}