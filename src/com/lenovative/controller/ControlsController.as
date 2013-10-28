package com.lenovative.controller
{
	import com.lenovative.model.Constants;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedEvent;
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
			view.startBtn.buttonMode = true;
			view.startBtn.addEventListener(MouseEvent.CLICK, _handleStartClick);
			//view.tf.
		}
		
		protected function _handleStartClick($me:MouseEvent):void
		{
			Out.status(this, "_handleStartClick");
			dispatchEvent(new ORedEvent(Constants.START,{twHandle:view.tf.text}));
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
			init();
			
		}
	}
}