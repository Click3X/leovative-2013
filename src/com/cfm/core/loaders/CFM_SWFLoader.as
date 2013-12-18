package com.cfm.core.loaders
{
	import com.cfm.core.managers.CFM_ErrorManager;
	import com.cfm.core.objects.CFM_Object;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class CFM_SWFLoader extends CFM_Object
	{
		static public const OWN_DOMAIN:String = "ownDomain";
		static public const CHILD_DOMAIN:String = "childDomain";
		static public const SAME_DOMAIN:String = "sameDomain";
		
		private var onComplete:Function;
		private var onProgress:Function;
		private var domain:String;
		
		private var url:String;
		private var loader:Loader;
		private var __swf:DisplayObject;
		
		public function CFM_SWFLoader(_url:String, _onProgress:Function, _onComplete:Function, _domain:String = "sameDomain", _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			url = _url;
			domain = _domain;
			onProgress = _onProgress;
			onComplete = _onComplete;
			
			super("CFM_SWFLoader",_autoInit,_autoDestroy);
		}
		
		override protected function build():void{
			trace("loading swf ::: " + url);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, swfProgress, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, CFM_ErrorManager.ioError, false, 0, true);
			
			var context:LoaderContext = new LoaderContext();
			
			switch(domain) {
				case OWN_DOMAIN:
					context.applicationDomain = new ApplicationDomain();
					break;
				case CHILD_DOMAIN:
					context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
				default:
					context.applicationDomain = ApplicationDomain.currentDomain;
			}
			
			loader.load(new URLRequest(url),context);
		}
		
		private function swfComplete(e:Event):void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfComplete);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, swfProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, CFM_ErrorManager.ioError);

			__swf = loader.content;
			if(stage) addChild(__swf);
			
			onComplete();			
		}
		
		private function swfProgress(e:ProgressEvent):void{
			onProgress(e.bytesLoaded/e.bytesTotal);
		}
		
		public function get movie():*{
			return __swf;
		}
		
		override protected function destroy(e:Event):void{ 
			
			if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)){
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfComplete);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, swfProgress);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, CFM_ErrorManager.ioError);
			}
				
			try{
				loader.close();
			} catch(e:Error){
				trace(e);
			}
			
			super.destroy(e);
		}
	}
}