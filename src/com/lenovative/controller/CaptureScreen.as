package com.lenovative.controller
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.ored.events.ORedEvent;
	import net.ored.events.ORedNavEvent;
	import net.ored.media.ORedCamera;
	import net.ored.util.out.Out;
	
	public class CaptureScreen extends EventDispatcher implements IScreen
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private const __DELAY_START:Number = .3;//second
		private const __INTERVAL:Number = 500;
		private const __MAX_PICS:int = 4; 
		
		private var _m:Model = Model.getInstance();
		
		public var view					:Sprite;
		private var _camera_container	:Sprite;
		private var _glowSprite			:Sprite;
		private var _counter			:TimerDIsplay;
		private var _index				:int = 0;
		
		private var _timer				:Timer;
		private var _sequencer			:TimelineLite;
		
		private var _heading:ScreenHeading;
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			_createChildren();
			resize();
		}
		
		private function _createChildren():void{
			_heading = new ScreenHeading("Preparing camera...\nGet ready.");
			view.addChild(_heading);
			
			_m.camera = new ORedCamera(1920,1080);
			_m.camera.addEventListener(ORedCamera.CAMERA_IS_ACTIVATED, _cameraReady);
			
			view.addChild(_m.camera.view);
			
			//display text
			_counter 					= new TimerDIsplay();
			view.addChild(_counter);
			
			//simulate camera flash by blinking screen white.
			_glowSprite = new Sprite();
			_glowSprite.graphics.beginFill(0xFFFFFF);
			_glowSprite.graphics.drawRect(0,0,_m.stageRef.fullScreenWidth, _m.stageRef.fullScreenHeight);
			_glowSprite.alpha = 0;
			view.addChild(_glowSprite);
		}
		
		protected function _cameraReady($e:ORedEvent):void{
			resize();
			initStart(0);
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		protected function _blinkFlash( $finished:Boolean ):void{
			_glowSprite.alpha 		= 1;
			
			TweenLite.to(_glowSprite,.2,{alpha:0, onComplete:$finished ? _done : initStart});
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _onTimer($e:TimerEvent):void
		{
			Out.status(this, "timer");
			
			if(_timer.currentCount <  _timer.repeatCount){
				_counter._num.text 	= count;
				_counter.scaleX = _counter.scaleY = 1;
				_counter.alpha = .8;
				_counter.visible = true;
			
				TweenMax.from(_counter, .3, {scaleX:1.4, scaleY:1.4, alpha:.5});
			}
		}
		
		protected function _onTimerComplete($e:TimerEvent):void
		{
			Out.status(this, "timerComplete");
			
			_index++;
			
			_blinkFlash( _index == __MAX_PICS );
			
			_counter.visible = false;
			
			_m.curPics.push( _m.camera.takeSnapshot() );
		}

		public function transitionIn():void{
			Out.status(this, "_onTransistionIn:");
			reset();
			
			view.visible = true;
			view.x = 0;
			
			TweenMax.from(view, 1, {x:_m.stageRef.stageWidth, ease:Cubic.easeInOut, onComplete:_m.camera.connect});
		}
		
		public function transitionOut():void{
			Out.status(this, "_onTransistionOut:");
			
			TweenMax.to(view, 1, {x:-_m.stageRef.stageWidth, ease:Cubic.easeInOut, onComplete:transitionOutComplete});
		}
		
		public function transitionOutComplete():void{
			trace("transitionOutComplete");
			_m.camera.disconnect();
			view.visible = false;
			_counter.visible = false;
		}
		
		public function initStart(_delay:Number = .2):void{
			Out.status(this, "start");
			
			TweenMax.delayedCall( _delay, start );
		}
		
		private function start():void{
			_timer.reset();
			_timer.start();
		}
		
		private function _done():void{
			_counter.visible = false;
			
			dispatchEvent(new ORedNavEvent(Constants.FINISH_SCREEN));
		}
		
		public function get count():String
		{
			return String(_timer.repeatCount-_timer.currentCount);
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		public function reset():void{
			view.visible = false;
			
			_m.flushBitmaps();
			
			_index			= 0;
			
			_counter.visible = false;
			resize();
		}
		
		public function resize():void{
			_heading.x = (_m.stageRef.stageWidth-_heading.width)*.5;
			_heading.y = (_m.stageRef.stageHeight*.5)-_heading.height;
			
			_glowSprite.width 	= _m.stageRef.stageWidth;
			_glowSprite.height	= _m.stageRef.stageHeight;
			
			_counter.x 		= 	_m.stageRef.stageWidth/2;
			_counter.y 		=  	_m.stageRef.stageHeight/2;
			
			_m.camera.resize(_m.stageRef.stageWidth, _m.stageRef.stageHeight);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function CaptureScreen()
		{
			view = new Sprite();
			view.visible = false;
			
			_timer = new Timer(__INTERVAL,4);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
		}
	}
}