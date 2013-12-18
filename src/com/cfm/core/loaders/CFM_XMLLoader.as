package com.cfm.core.loaders
{
	import com.cfm.core.managers.CFM_ErrorManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CFM_XMLLoader
	{
		private var onComplete:Function;
		private var url:String;
		private var loader:URLLoader;
		public var xml:XML;
		
		public function CFM_XMLLoader(_url:String, _onComplete:Function)
		{
			url = _url;
			onComplete = _onComplete;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlComplete, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, CFM_ErrorManager.ioError, false, 0, true);
			loader.load(new URLRequest(url));
		}
		
		private function xmlComplete(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, xmlComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, CFM_ErrorManager.ioError);
			
			xml = XML(e.currentTarget.data);
			onComplete(xml);			
		}
	}
}