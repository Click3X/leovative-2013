package com.lenovative.controller
{
	import com.greensock.TimelineLite;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StripScript extends EventDispatcher
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		
		private var _counter:TextField;
		private var _glowSprite:Sprite;
		private var _sequencer:TimelineLite;
		
		// =================================================
		// ================ Public
		// =================================================
		public function start():void{
			if(_sequencer) _reset();
		}
		// =================================================
		// ================ Workers
		// =================================================
		private function _init():void{
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = textFormat;
			tf.text = "3";
			tf.x = _m.stageRef.fullScreenWidth/2 - tf.width/2;
			tf.y = _m.stageRef.fullScreenHeight/2 - tf.height/2;
			_m.stageRef.addChild(tf);
		}
		// =================================================
		// ================ Handlers
		// =================================================
		private function _onComplete():void{
			
		}
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get textFormat():TextFormat{
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold 	= false; 
			textFormat.color 	= 0x0000ff; //coundown colors
			textFormat.font 	= "Gotham";    
			textFormat.size 	= 128;

			
			return textFormat;
		}
		// =================================================
		// ================ Core Handler
		// =================================================
		private function _reset():void{
			_m.reset();
			_sequencer = new TimelineLite({onComplete:_onComplete});
		}
		// =================================================
		// ================ Initialize
		// =================================================

		public function StripScript()
		{
			_m = Model.getInstance();
			_init();
		}
	}
}