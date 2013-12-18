package com.cfm.core.media
{
	import com.cfm.core.events.CFM_VideoStreamEvent;
	import com.cfm.core.managers.CFM_VideoPlayerManager;
	import com.cfm.core.objects.CFM_Object;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="progress", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	[Event(name="ready", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	[Event(name="complete", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	
	public class CFM_VideoNS extends CFM_Object
	{
		private var videoURL		:String;
		private var connection		:NetConnection;
		private var stream			:NetStream;
		private var video			:Video;
		private var sound			:SoundTransform;
		private var cuePoints		:Array = [];
		private var startCuepoint	:Number = NaN;
		
		private var bufferFull		:Boolean = false;
		private var centerH			:Boolean;
		private var centerV			:Boolean;
		private var videoPaused		:Boolean = false;
		private var firstBuffer		:Boolean = false;
		private var loop			:Boolean;
		private var autoStart		:Boolean;
		
		private var client			:Object;
		private var metaData		:Object;
		private var cuePointWaiting	:Object = null;
		
		public function CFM_VideoNS(_centerH:Boolean = false, _centerV:Boolean = false, _autoInit:Boolean = true,_autoDestroy:Boolean = true	)
		{
			super("CFM_VideoPlayer",_autoInit,_autoDestroy);
			
			centerH 				= _centerH;
			centerV 				= _centerV;
			sound 					= new SoundTransform(1);
			
			initConnection();
		}
		
		private function initConnection():void{
			connection = CFM_VideoPlayerManager.netConnection;
			
			if(connection.connected)
				connectStream();
			else
				throw new Error("connectStream:: Not Connected");
		}
		
		private function connectStream():void {
			client = new Object();
			client.onMetaData = ns_onMetaData;
			client.onCuePoint = ns_onCuePoint;
			
			stream = new NetStream(connection);
			stream.client = client;
			stream.bufferTime = 2;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.soundTransform = sound;
			
			video = new Video();
			video.smoothing = true;
			video.visible = false;
			video.attachNetStream(stream);
			addChild(video);
		}
		
		public function play(_url:String, _startCuepoint:Number = NaN, _autoStart:Boolean = false, _loop:Boolean = false):Boolean{
			videoURL = _url;
			loop = _loop;
			autoStart = _autoStart;
			startCuepoint = _startCuepoint;
			bufferFull = false;
			firstBuffer = true;
			
			if(stream){
				stream.play(videoURL);
				return true;
			} else {
				return false;
			}
		}
		
		public function stop():void{
			if(stream){
				stream.pause();
				stream.seek(0);
			
				try{
					stream.close();
				} catch(e:Error){
					trace(e);
				}
			}
			
			killRender();
		}
		
		private function rendering(e:Event):void{
			dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.PROGRESS, stream.time/metaData.duration,stream.bytesLoaded/stream.bytesTotal));
			
			if(cuePointWaiting)
				if(stream.bytesLoaded/stream.bytesTotal > cuePointWaiting.percent+.05)
					gotoCuePoint(cuePointWaiting.index);
		}
		
		public function gotoCuePoint(_index:Number):void{
			var cuePointTime:Number = cuePoints[_index].time;
			var percent:Number = cuePointTime/metaData.duration;
			
			if( percent+.05 > stream.bytesLoaded/stream.bytesTotal){
				cuePointWaiting = {index:_index, percent:percent};
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.WAITING_FOR_CUEPOINT, percent));
			} else {
				stream.seek(metaData.duration*percent);
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.WAITING_FOR_CUEPOINT_COMPLETE, cuePointWaiting.percent));
				cuePointWaiting = null;
			}
		}
		
		private function ns_onMetaData(item:Object):void {
			if(!metaData){
				metaData = item;
				
				video.width = 480;
				video.height = 270;
				video.x = centerH ? -metaData.width/2 : 0;
				video.y = centerV ? -metaData.height/2 : 0;
			//	video.scaleX = video.scaleY = 480/700;
				
				cuePoints = metaData.cuePoints;
				
				if(firstBuffer)
					videoReady(true);
			}
		}
		
		private function ns_onCuePoint(item:Object):void{
			dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.CUEPOINT,0,0,item));
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("NetStream ::::::::: " + event.info.code);
			
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					
				break;
				case "NetStream.Play.Start":
					
				break;
				case "NetStream.Buffer.Full":
					
					if(metaData)
						videoReady();
					
					firstBuffer = true;
					
				break;
				case "NetStream.Play.Stop":
					
					dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.COMPLETE));
					
					if(loop)
						stream.seek(0);
					else
						stream.pause();
						rewindVideo();
					
				break;
			}
		}
			
		public function videoReady(fromMeta:Boolean = false):void{
			if(!firstBuffer || fromMeta){
				if(!isNaN( startCuepoint ))
					gotoCuePoint(startCuepoint);
				
				if(!autoStart){
					stream.pause();
					stream.seek(0);
				} else {
					startRender();
				}
				
				video.visible = true;
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.READY));
			}
		}
		
		public function pauseVideo():void{
			killRender();
			
			if(stream){
				stream.pause();
				videoPaused = true;
			}
		}
		
		public function resumeVideo():void{
			startRender();
			
			if(stream){
				stream.resume();
				videoPaused = false;
			}
		}
		
		public function rewindVideo():void{
			if(stream)
				stream.seek(0);
		}
		
		public function turnSoundOff():void{
			sound.volume = 0;
			
			if(stream)
				stream.soundTransform = sound;
		}
		
		public function turnSoundOn():void{
			sound.volume = 1;
			
			if(stream)
				stream.soundTransform = sound;
		}
		
		private function startRender():void{
			if(!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME, rendering, false, 0, true);
		}
		
		private function killRender():void{
			if(hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, rendering);
		}
		
		override protected function destroy(e:Event):void{			
			killRender();
			
			if(stream){
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.pause();
				stream.close();
			}
			
			super.destroy(e);
		}
	}
}