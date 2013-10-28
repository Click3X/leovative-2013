package com.lenovative.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedEvent;
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
			TweenLite.from(view,.7,{x:_m.stageRef.fullScreenWidth+view.width, autoAlpha:1, ease:Cubic.easeOut});
		}
		public function transitionOut():void{
			Out.status(this, "transitionOut");
			TweenLite.to(view,.7,{x:_m.stageRef.fullScreenWidth+view.width, autoAlpha:1, ease:Cubic.easeOut, onComplete:_onTransitionOut});
		
		}
		public function resize():void{
			if(_m.isFullScreen()){
				view.x = _m.stageRef.fullScreenWidth/2 - view.width/2;
				view.y = _m.stageRef.fullScreenHeight - view.height;
			}else{
				view.x = _m.stageRef.stageWidth/2 - view.width/2;
				view.y = _m.stageRef.stageHeight/2 - view.height;
				
			}
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _handleStartClick($me:MouseEvent):void
		{
			Out.status(this, "_handleStartClick");
			transitionOut();
		}
		// =================================================
		// ================ Handlers
		// =================================================
		private function _onTransitionIn():void{
			
		}
		private function _onTransitionOut():void{
			_m.twitterHandle = view.tf.text;
			dispatchEvent(new ORedNavEvent(Constants.CAPTURE));
			
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

		public function StartScreen(target:IEventDispatcher=null)
		{
			super(target);
			view = new Controls();
			
		}
	}
}