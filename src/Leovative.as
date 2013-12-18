package
{
	import com.lenovative.controller.CaptureScreen;
	import com.lenovative.controller.Compositor;
	import com.lenovative.controller.FinishScreen;
	import com.lenovative.controller.StartScreen;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	[SWF(frameRate="30", quality="LOW")]
	
	public class Leovative extends Sprite
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _params:Object;
		
		private var _m:Model;
		
		//screens
		private var _startScreen:StartScreen;
		private var _captureScreen:CaptureScreen;
		private var _finishScreen:FinishScreen;
		
		private var _background:MainBackground;
		private var _logo:CFMLogo;
		
		private var _currentScreen:IScreen;
		private var _lastScreen:IScreen;
		
		// =================================================
		// ================ Public
		// =================================================
		protected function screenChange($e:ORedNavEvent):void{
			Out.info(this, "screenChange: " +$e.screen);
			
			if(_currentScreen){
				_lastScreen = _currentScreen;
			}
			
			switch($e.screen){
				case Constants.START_SCREEN:
					_currentScreen = _startScreen;
					break;
				case Constants.CAPTURE_SCREEN: 	
					_currentScreen = _captureScreen;
					break;
				case Constants.FINISH_SCREEN:
					_currentScreen = _finishScreen;
					
					_m.compositedImage 	= Compositor.getTiledImage(_m.curPics);
					
					_finishScreen.addPhoto(_m.compositedImage, _m.curPics);
					break;
			}
			
			if(_lastScreen) _lastScreen.transitionOut();
			_currentScreen.transitionIn();
		}
		
		private function _createChildren():void
		{
			//background
			_background = new MainBackground();
			addChild(_background);
			
			//start screen
			_startScreen = new StartScreen();
			addChild(_startScreen.view);
			_startScreen.init();

			//capture screen
			_captureScreen = new CaptureScreen();
			addChild(_captureScreen.view);
			_captureScreen.init();
			
			//finish screen
			_finishScreen = new FinishScreen();
			addChild(_finishScreen.view);
			_finishScreen.init();
			
			//load screens into model
			_m.screens.push(_startScreen);
			_m.screens.push(_captureScreen);
			_m.screens.push(_finishScreen);	
			
			//listen for screen change event
			for each (var s:IScreen in _m.screens) 
				s.addEventListener(ORedNavEvent.SCREEN_CHANGE, screenChange);
		}

		protected function _onResize($e:Event = null):void
		{
			Out.status(this, "_onResize");
			
			_m.stageRef.stageWidth = stage.stageWidth;
			_m.stageRef.stageHeight	= stage.stageHeight;
			
			var bgscale:Number = stage.stageWidth/1920;
			
			if( (1080*bgscale) < stage.stageHeight )
				bgscale = stage.stageHeight/1080;
			
			_background.width = 1920*bgscale;
			_background.height = 1080*bgscale;
			_background.x = (stage.stageWidth-_background.width)*.5;
			_background.y = (stage.stageHeight-_background.height)*.5;
						
			for each(var s:IScreen in _m.screens) s.resize();
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
		public function Leovative()
		{
			_params = LoaderInfo(this.root.loaderInfo).parameters;
			
			//log
			ORedUtils.turnOutOn();
			Out.info(this, "Hello Leovative");
			
			//config stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			
			//model
			_m 				= Model.getInstance();
			_m.init(stage, _params);
			
			//prepare display objects
			_createChildren();
			
			_onResize();
			stage.addEventListener(Event.RESIZE, _onResize, false, 0, true);
			
			_currentScreen = _startScreen;
			_currentScreen.transitionIn();
		}
	}
}