package com.lenovative.controller
{
<<<<<<< HEAD
<<<<<<< HEAD
=======
	import com.cfm.core.buttons.CFM_SimpleButton;
>>>>>>> parent of 176dc20... flash updates
	import com.greensock.TweenMax;
=======
	import com.greensock.TweenLite;
>>>>>>> parent of 218d65c... init
	import com.greensock.easing.Cubic;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.out.Out;
	
	public class StartScreen extends EventDispatcher implements IScreen
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
<<<<<<< HEAD
<<<<<<< HEAD
	
=======
		
>>>>>>> parent of 176dc20... flash updates
		private var _cfm_logo:CFMLogo;
		private var _leovative_logo:LeovativeLogo;
		private var _input:FormField;
		private var _heading:ScreenHeading;
		
		public var view:Sprite; 
=======
		
		public var view:Controls; 
>>>>>>> parent of 218d65c... init
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			_m = Model.getInstance();
			
			view.startBtn.buttonMode = true;
			view.startBtn.addEventListener(MouseEvent.CLICK, _handleStartClick);
			view.visible = false;
			
			resize();
		}
		
		public function transitionIn():void{
			Out.status(this, "transitionIn");
			
			view.visible 	= true;
		}
		
		public function transitionOut():void{
			Out.status(this, "transitionOut");		
			
			view.visible 	= false;
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _handleStartClick($me:MouseEvent):void
		{
			Out.status(this, "_handleStartClick");
			
			dispatchEvent(new ORedNavEvent(Constants.CAPTURE));
		}
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		// =================================================
		// ================ Core Handler
		// =================================================
		public function reset():void{
			resize();
		}
		
		public function resize():void{
<<<<<<< HEAD
<<<<<<< HEAD
			_heading.x = (_m.stageRef.stageWidth)*.5;
			_cfm_logo.x = (_m.stageRef.stageWidth)*.5;
=======
			_heading.x = (_m.stageRef.stageWidth-_heading.width)*.5;
			_cfm_logo.x = (_m.stageRef.stageWidth-_cfm_logo.width)*.5;
			_leovative_logo.x = (_m.stageRef.stageWidth-_leovative_logo.width)*.5;
>>>>>>> parent of 176dc20... flash updates
			_input.x = ((_m.stageRef.stageWidth-_input.width)*.5) + 30;
			
			view.y = (_m.stageRef.stageHeight-view.height)*.4;
=======
			view.x = _m.stageRef.stageWidth/2 - view.width/2;
			view.y = _m.stageRef.stageHeight/2 - view.height/2;
>>>>>>> parent of 218d65c... init
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function StartScreen(target:IEventDispatcher=null)
		{
			super(target);
			
<<<<<<< HEAD
			_m = Model.getInstance();
			
			view = new Sprite();
			view.visible = false;
		}
		
		private function _createChildren():void
		{
			_cfm_logo = new CFMLogo();
			view.addChild(_cfm_logo);
			_cfm_logo.filters = Constants.SHADOW_STYLE;
			
			_heading = new ScreenHeading("TWITTER PHOTO BOOTH");
			_heading.y = _cfm_logo.y + _cfm_logo.height + 80;
			_heading.renderTo(view);
			
			_input = new FormField(0,false,false,false,"",true,true);
			_input.y = _heading.y + _heading.height + 50;
			_input.renderTo( view );
			
			_leovative_logo = new LeovativeLogo();
			view.addChild(_leovative_logo);
			_leovative_logo.y = 700-_leovative_logo.height;
			_leovative_logo.filters = Constants.SHADOW_STYLE;
			
			_input.addEventListener("submit", _handleStartClick, false, 0, true);
=======
			view = new Controls();
>>>>>>> parent of 218d65c... init
		}
	}
}