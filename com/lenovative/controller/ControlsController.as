package com.lenovative.controller
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import net.ored.util.out.Out;
	
	public class ControlsController extends EventDispatcher
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		public var view:Controls; 
		
		// =================================================
		// ================ Public
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		public function init():void{
			view.startBtn.addEventListener(MouseEvent.CLICK, _handleStartClick);
			//view.tf.
		}
		
		protected function _handleStartClick($me:MouseEvent):void
		{
			Out.status(this, "_handleStartClick");
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
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function ControlsController(target:IEventDispatcher=null)
		{
			super(target);
			view = new Controls();
			
			
		}
	}
}