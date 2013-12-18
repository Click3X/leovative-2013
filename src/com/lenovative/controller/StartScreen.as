package com.lenovative.controller
{
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.out.Out;
	
	public class StartScreen extends EventDispatcher implements IScreen
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		
		private var _cfm_logo:CFMLogo;
		private var _leovative_logo:LeovativeLogo;
		private var _input:FormField;
		private var _heading:ScreenHeading;
		
		public var view:Sprite; 
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			_createChildren();
			resize();
		}
		
		public function transitionIn():void{
			Out.status(this, "transitionIn");
			
			view.visible 	= true;
			view.x = 0;
			
			TweenMax.from(view, 1, {x:_m.stageRef.stageWidth, ease:Cubic.easeInOut});
		}
		
		public function transitionOut():void{
			Out.status(this, "transitionOut");		
						
			TweenMax.to(view, 1, {x:-_m.stageRef.stageWidth, ease:Cubic.easeInOut, onComplete:reset});
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _handleStartClick($me:Event):void
		{
			Out.status(this, "_handleStartClick");
			
			_m.twitterHandle = _input.inputValue;
			
			dispatchEvent(new ORedNavEvent(Constants.CAPTURE_SCREEN));
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
			view.visible = false;
		}
		
		public function resize():void{
			_heading.x = (_m.stageRef.stageWidth-_heading.width)*.5;
			_cfm_logo.x = (_m.stageRef.stageWidth-_cfm_logo.width)*.5;
			_leovative_logo.x = (_m.stageRef.stageWidth-_leovative_logo.width)*.5;
			_input.x = ((_m.stageRef.stageWidth-_input.width)*.5) + 30;
			
			view.y = (_m.stageRef.stageHeight-view.height)*.4;
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function StartScreen(target:IEventDispatcher=null)
		{
			super(target);
			
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
		}
	}
}