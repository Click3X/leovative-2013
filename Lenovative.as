package
{
	import com.greensock.TimelineLite;
	import com.lenovative.controller.ControlsController;
	import com.lenovative.controller.StripScript;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedEvent;
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
		private var _stripScript:StripScript;
		
		public var oredCamera:ORedCamera;
		
		private var _controls:ControlsController;
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
			addChildAt(oredCamera.view,0);
		}
		
		private function _createChildren():void
		{
			
			//controls
			_controls = new ControlsController();
			_controls.addEventListener(Constants.START, _beginFilmStrip);
			addChild(_controls.view);
				
			//countdown
			_stripScript = new StripScript();
			
			
			//full screen button
			var fsBtn:FSBtn = new FSBtn();
			fsBtn.addEventListener(MouseEvent.CLICK, _enterFullScreen);
			addChild(fsBtn);
		}
		
		protected function _beginFilmStrip($e:ORedEvent):void
		{
			Out.status(this, "_beginFilmStrip");
			
		}
		// =================================================
		// ================ Handlers
		// =================================================
		
		protected function _enterFullScreen(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			stage.displayState = StageDisplayState.FULL_SCREEN; 
			oredCamera.resize(stage.fullScreenWidth, stage.fullScreenHeight);
		}
		protected function _debug($e:MouseEvent):void{
			Out.status(this, "debug");
			Out.debug(this, "ORedCamera.view.x: "+oredCamera.view.x);
			
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			ORedUtils.turnOutOn();
			Out.info(this, "Hello Lenovative");
			_m 				= Model.getInstance();
			_m.stageRef 	= stage;
			_createChildren();
			_createCamera();

		
		}
		


	}
}