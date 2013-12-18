package com.cfm.core.media
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import util.UIManager;
	import util.SoundManager;
	import jt.events.JTVideoPlayerEvent;
	import flash.events.DataEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;

	public class JTFlashPlayer extends Sprite
	{
		private var url:String;
		
		public var loader:Loader;
		public var flashMovie:*;
		
		public var soundOff:SoundTransform;
		public var soundOn:SoundTransform;
		
		public var VIDEO_PROGRESS_RATIO:Number = 0;
		public var VIDEO_DOWNLOAD_RATIO:Number = 0;
		
		public var totalDuration:Number;
		
		public function JTFlashPlayer(_url:String)
		{
			soundOff = new SoundTransform(0);
			soundOn = new SoundTransform(1);
			
			url = _url;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, movieLoadingComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, movieLoadPercent, false, 0, true);
			
			try {
				loader.load( new URLRequest(url), new LoaderContext( true ) );
			} catch (e:Error) {
				trace("missing movie - " + url);
			}
		}
		
		public function movieLoadPercent(e:ProgressEvent):void{
			
		}
		
		public function ioError(e:IOErrorEvent):void{
			trace(e);
		}
		
		public function movieLoadingComplete(e:Event):void {
			try{
				flashMovie = e.target.loader.content;
				addChild(flashMovie);
			} catch(e:Error){
				trace(e);
			}
			
          	if(SoundManager.allSoundsOn){
				turnSoundOn();
			}else {
				turnSoundOff();
			}
			
		}
		
		public function turnSoundOff():void{
			soundTransform = soundOff;
		}
		
		public function turnSoundOn():void{
			soundTransform = soundOn;
		}
		
		public function destroy():void{
			try {
				loader.close();
			} catch (e:Error) {
				trace(e);
			}
			
			UIManager.destroyChildren(this);
			flashMovie = null;
		}
	}
}