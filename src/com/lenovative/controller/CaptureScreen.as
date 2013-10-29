package com.lenovative.controller
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import net.ored.events.ORedEvent;
	import net.ored.events.ORedNavEvent;
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	public class CaptureScreen extends EventDispatcher implements IScreen
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _m:Model;
		
		public var view:Sprite;
		
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
		public function init():void{
			
			view = new Sprite();
			view.visible = false;
			
			_timer = new Timer(__INTERVAL,3);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			//display text
			_counter 					= new TextField();
			_counter.defaultTextFormat 	= textFormat;
			_counter.autoSize			= TextFieldAutoSize.LEFT;
			_counter.selectable			= false;
			_counter.text 				= "Ready?";
			_counter.visible 			= false;
			view.addChild(_counter);
			
			//simulate camera flash by blinking screen white.
			_glowSprite = ORedUtils.gimmeRectWithTransparency(_m.stageRef.fullScreenWidth, _m.stageRef.fullScreenHeight,0xffffff, 1);
			_glowSprite.visible = false;
			view.addChild(_glowSprite);
			
			resize();
		}


		public function start():void{
			Out.status(this, "start");
			_counter.text = count;
			TweenLite.delayedCall(1, _timer.start);
		}
		public function transitionIn():void{
			Out.status(this, "transitionIn");
			view.visible = true;
			TweenLite.from(_counter,.7,{x:tweenFromX, autoAlpha:1, ease:Cubic.easeOut, onComplete:_onTransitionIn});
			
		}
		public function transitionOut():void{
			Out.status(this, "transitionOut");
			dispatchEvent(new ORedNavEvent(Constants.FINISH));
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _onTimerComplete($e:TimerEvent):void
		{
			Out.status(this, "timerComplete");
			dispatchEvent(new ORedEvent(Constants.CAPTURE_BITMAP, {index:_index}));
			_blinkFlash();
			_index++;
			if(_index < __MAX_PICS) {
				_count 			= 3;
				_counter.text 	= count;
				_timer.reset();
				_timer.start();
			}else{	
				_counter.visible = false;
				transitionOut();
			}
		}
		
		protected function _onTimer($e:TimerEvent):void
		{
			Out.status(this, "timer");
			_count--;
			_counter.text = count;
		}
		protected function _blinkFlash():void{
			//_glowSprite.x = 0;
			_glowSprite.alpha = 1;
			_glowSprite.visible = true;
			TweenLite.to(_glowSprite,.25,{autoAlpha:0});
		}
		// =================================================
		// ================ Handlers
		// =================================================
		private function _onComplete():void{
			Out.status(this, "_onComplete");
		}
		private function _onTransitionIn():void{
			Out.status(this, "_onTransistionIn():");
			TweenLite.delayedCall(1, start);
		}
		private function _onTransitionOut():void{
			
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
			textFormat.align 	= TextFormatAlign.CENTER;
			
			return textFormat;
		}
		
		public function get count():String
		{
			return String(_count);
		}
		private function get tweenFromX():Number{
			var x:Number = _m.isFullScreen() ? _m.stageRef.fullScreenWidth : _m.stageRef.stageWidth;
			return x + _counter.width;
		}
		// =================================================
		// ================ Core Handler
		// =================================================
		
		public function reset():void{
			_m.flushBitmaps();
			_index			= 0;
			_count 			= 3;
			_counter.text	= "Ready?";
			_counter.visible = true;
			
			resize();
		}
		public function resize():void{
					
			if(_m.isFullScreen()){
				_glowSprite.width 	= _m.stageRef.fullScreenWidth;
				_glowSprite.height	= _m.stageRef.fullScreenHeight;
				_counter.x 			= _m.stageRef.fullScreenWidth/2;
				_counter.y 			= _m.stageRef.fullScreenHeight/2 - _counter.height;
			} else{
				_glowSprite.width 	= _m.stageRef.stageWidth;
				_glowSprite.height	= _m.stageRef.stageHeight;
				_counter.x 			= _m.stageRef.stageWidth/2 - _counter.width/2;
				_counter.y 			= _m.stageRef.stageHeight/2 - _counter.height;
				
			}
		}
		
		// =================================================
		// ================ Initialize
		// =================================================

		public function CaptureScreen()
		{
			_m = Model.getInstance();
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
	}
}