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
		private var _m:Model = Model.getInstance();
		
		public var view:Sprite;
		
		private const __DELAY_START:int = 1;//second
		private const __MAX_PICS:int = 4; 
		
		private var _counter	:TextField;
		private var _count		:int = 3;
		private var _index		:int = 0;
		private var _glowSprite	:Sprite;
		
		private var _timer		:Timer;
		private const __INTERVAL:Number = 400;
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
			_counter.selectable			= false;
			_counter.embedFonts = true;
			view.addChild(_counter);
			
			//simulate camera flash by blinking screen white.
			_glowSprite = new Sprite();
			_glowSprite.graphics.beginFill(0xFFFFFF);
			_glowSprite.graphics.drawRect(0,0,_m.stageRef.fullScreenWidth, _m.stageRef.fullScreenHeight);
			_glowSprite.alpha = 0;
			view.addChild(_glowSprite);
			
			resize();
		}

		

		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _blinkFlash( $finished:Boolean ):void{
			_glowSprite.alpha 		= 1;
			
			TweenLite.to(_glowSprite,.25,{alpha:0, onComplete:$finished ? _done : null});
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _onTimer($e:TimerEvent):void
		{
			Out.status(this, "timer");
			
			_count--;
			_counter.text 	= count;
			
			
		}
		
		protected function _onTimerComplete($e:TimerEvent):void
		{
			Out.status(this, "timerComplete");
			
			dispatchEvent(new ORedEvent(Constants.CAPTURE_BITMAP, {index:_index}));
			
			_index++;
			
			resetCounter();
			
			var _finished:Boolean = (_index == __MAX_PICS);
			
			if(!_finished) {
				initStart(.2);
			}
			
			_blinkFlash( _finished );
		}
		
		private function resetCounter():void{
			_count 			= 3;
			_counter.text 	= count;
			_counter.visible = false;
		}

		public function transitionIn():void{
			Out.status(this, "_onTransistionIn():");
			
			view.visible = true;
			
			reset();
			
			TweenLite.delayedCall(__DELAY_START, initStart,[1]);
		}
		
		public function initStart(_delay:Number):void{
			Out.status(this, "start");
			
			TweenLite.delayedCall(_delay, start);
		}
		
		private function start():void{
			_timer.reset();
			_timer.start();
			_counter.visible = true;
		}
		
		private function _done():void{
			_counter.visible = false;
			
			dispatchEvent(new ORedNavEvent(Constants.FINISH));
		}
		
		public function transitionOut():void{
			view.visible = false;
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get textFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.bold 	= false; 
			tf.color 	= 0x0000ff;
			tf.font 	= new Gotham_Book().fontName;    
			tf.size 	= 128;
			tf.align	= TextFormatAlign.CENTER;
			
			return tf;
		}
		
		public function get count():String
		{
			return String(_count);
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		public function reset():void{
			_m.flushBitmaps();
			
			_index			= 0;
			
			resetCounter();
			
			resize();
		}
		
		public function resize():void{
			_glowSprite.width 	= _m.stageRef.stageWidth;
			_glowSprite.height	= _m.stageRef.stageHeight;
			
			_counter.width 		= 	_m.stageRef.stageWidth;
			_counter.y 			= (_m.stageRef.stageHeight - _counter.height)/2;
		}
		
		// =================================================
		// ================ Initialize
		// =================================================

		public function CaptureScreen()
		{
		}
	}
}