package
{
	import com.lenovative.controller.ControlsController;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import net.ored.media.ORedCamera;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	[SWF(backgroundColor="#ff0000", frameRate="30", quality="HIGH")]
	public class Lenovative extends Sprite
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
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
			//full screen button
			var fsBtn:FSBtn = new FSBtn();
			fsBtn.addEventListener(MouseEvent.CLICK, _enterFullScreen);
			addChild(fsBtn);
			
			//controls
			_controls = new ControlsController();
			addChild(_controls.view);
		}
		// =================================================
		// ================ Handlers
		// =================================================
		
		protected function _enterFullScreen(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			stage.displayState = StageDisplayState.FULL_SCREEN; 
			oredCamera.connectCamera();
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
			
			_createChildren();
			_createCamera();

		
		}
		


	}
}