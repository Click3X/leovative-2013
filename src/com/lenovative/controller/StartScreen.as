package com.lenovative.controller
{
	import com.greensock.TweenLite;
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
		
		public var view:Controls; 
		
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
			view.x = _m.stageRef.stageWidth/2 - view.width/2;
			view.y = _m.stageRef.stageHeight/2 - view.height/2;
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function StartScreen(target:IEventDispatcher=null)
		{
			super(target);
			
			view = new Controls();
		}
	}
}