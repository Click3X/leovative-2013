package com.lenovative.controller
{
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Model;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import net.ored.util.out.Out;
	
	public class FinishScreen extends EventDispatcher implements IScreen
	{
		private var _m:Model;
		
		public var view:DisplayPhotoClip;
		// =================================================
		// ================ Instance Vars
		// =================================================
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			_m = Model.getInstance();
			view = new DisplayPhotoClip();
		}
		public function transitionIn():void{
			Out.status(this, "transitionIn");
		}
		public function transitionOut():void{
			Out.status(this, "transitionOut");
		}
		public function resize():void{
			
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Initialize
		// =================================================

		public function FinishScreen(target:IEventDispatcher=null)
		{

		}
	}
}