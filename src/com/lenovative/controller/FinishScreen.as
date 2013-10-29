package com.lenovative.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.out.Out;
	
	public class FinishScreen extends EventDispatcher implements IScreen
	{
		private var _m:Model;
		
		public var view:DisplayPhotoClip;
		public var photoContainer:Sprite;
		// =================================================
		// ================ Instance Vars
		// =================================================
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			
			_m = Model.getInstance();
			
			view 			= new DisplayPhotoClip();
			view.visible 	= false;
			
			
			view.startOverBtn.addEventListener(MouseEvent.CLICK, _onStartOverClick);
		}
		
		public function transitionIn():void{
			Out.status(this, "transitionIn");
			view.visible = true;
		}
		public function transitionOut():void{
			Out.status(this, "transitionOut");
			TweenLite.to(view,.7,{x:_m.stageRef.fullScreenWidth+view.width, autoAlpha:1, ease:Cubic.easeOut, onComplete:_onTransitionOut});
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _onStartOverClick($e:MouseEvent):void
		{
			Out.status(this, "_onStartOverClick");		
			transitionOut();
		}
		
		protected function _onTransitionOut():void{
			
			dispatchEvent(new ORedNavEvent(Constants.START));
		}
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		public function reset():void{
			view.visible = false;
			resize();
		}
		public function resize():void{
			
		}
		// =================================================
		// ================ Initialize
		// =================================================


	}
}