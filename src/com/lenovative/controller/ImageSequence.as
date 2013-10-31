package com.lenovative.controller
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ImageSequence extends Sprite
	{
		private var _timer:Timer;
		private var _bitmaps:Vector.<Bitmap>;
		private var _interval:Number;
		
		private var _index:Number = 0;
		
		private var _currentBitmap:Bitmap;
		
		public function ImageSequence($bitmaps:Vector.<Bitmap>, $interval:Number = 100)
		{
			super();
			
			_bitmaps = $bitmaps;
			_interval = $interval;
			
			build();
			onFrame();
		}
		
		public function build():void{			
			for each(var b:Bitmap in _bitmaps){
				b.x = b.y = 0;
				addChild(b);
				b.visible = false;
			}
			
			_timer = new Timer(_interval);
			_timer.addEventListener(TimerEvent.TIMER, onFrame, false, 0, true);
		}
		
		public function play():void{
			_timer.start();
		}
		
		public function pause():void{
			_timer.stop();
		}
		
		private function onFrame($event:TimerEvent = null):void{
			if(_currentBitmap)
				_currentBitmap.visible = false;
			
			_currentBitmap = _bitmaps[_index];
			_currentBitmap.visible = true;
			
			_index++;
			
			if(_index > _bitmaps.length-1)
				_index = 0;
		}
		
		public function destroy():void{
			_timer.stop();
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER,onFrame);
			
			while(numChildren>0)
				removeChildAt(0);
		}
	}
}