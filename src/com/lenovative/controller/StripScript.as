package com.lenovative.controller
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	public class StripScript extends EventDispatcher
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		
		private const __MAX_PICS:int = 4; 
		private var _counter	:TextField;
		private var _count		:int = 3;
		private var _index		:int = 0;
		private var _glowSprite	:Sprite;
		
		private var _timer		:Timer;
		private const __INTERVAL:Number = 200;
		private var _sequencer	:TimelineLite;
		
		
		// =================================================
		// ================ Public
		// =================================================


		public function start():void{
			Out.status(this, "start");
			_reset();
			_timer.start();
		}
		// =================================================
		// ================ Workers
		// =================================================
		private function _init():void{
			
			_timer = new Timer(__INTERVAL,3);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			_counter 					= new TextField();
			_counter.defaultTextFormat 	= textFormat;
			
			//_counter.visible			= false;
			_counter.x 					= _m.stageRef.fullScreenWidth/2 - _counter.width/2;
			_counter.y 					= _m.stageRef.fullScreenHeight/2 - _counter.height/2;
			_m.stageRef.addChild(_counter);
			
			_glowSprite = ORedUtils.gimmeRectWithTransparency(_m.stageRef.fullScreenWidth, _m.stageRef.fullScreenHeight,0xffffff, 1);
			_glowSprite.visible = false;
			_m.stageRef.addChild(_glowSprite);
		
		}
		
		protected function _onTimerComplete($e:TimerEvent):void
		{
			Out.status(this, "timerComplete");
			dispatchEvent(new ORedEvent(Constants.CAPTURE_BITMAP, {index:_index}));
			_glowSprite.alpha = 1;
			_glowSprite.visible = true;
			TweenLite.to(_glowSprite,.25,{autoAlpha:0});
			_index++;
			if(_index < __MAX_PICS) {
				_count 			= 3;
				_counter.text 	= count;
				_timer.reset();
				_timer.start();
			}else{
				_counter.visible = false;
					
			}
		}
		
		protected function _onTimer($e:TimerEvent):void
		{
			Out.status(this, "timer");
			_count--;
			_counter.text = count;
		}
		// =================================================
		// ================ Handlers
		// =================================================
		private function _onComplete():void{
			Out.status(this, "_onComplete");
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
		
		public function get count():String
		{
			return String(_count);
		}

		// =================================================
		// ================ Core Handler
		// =================================================
		private function _reset():void{
			_m.flushBitmaps();
			_index			= 0;
			_count 			= 3;
			_counter.text	= count;
			_counter.visible = true;
		}
		// =================================================
		// ================ Initialize
		// =================================================

		public function StripScript()
		{
			_m = Model.getInstance();
			TweenPlugin.activate([AutoAlphaPlugin]);
			_init();
		}
	}
}