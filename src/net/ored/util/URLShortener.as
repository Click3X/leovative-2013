package net.ored.util
{

	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.Bitly;
	import net.ored.util.out.Out;
	
	public class URLShortener extends EventDispatcher
	{	
		private const __BITLY_LOGIN		:String = "o_710ps9go56";
		private const __BITLY_KEY		:String = "R_592d44137d6888ed4cbb95bba5e2dff7";

		private var _bitly				:Bitly;
		private var _bitlyCallback		:Object;
		
		private var _url				:String; 
		
		public function URLShortener($url:String)
		{
			_bitly 			= Bitly.getInstance();
			_bitly.login 	= __BITLY_LOGIN;
			_bitly.apiKey 	= __BITLY_KEY;
			url				= $url;
		}

		/*
		Method:go
		Parameters:
		inUrl:String
		Returns:
		*/
		public function go():void
		{
			Out.debug(this, "go!: "+ url);
			_bitly.addEventListener(Event.COMPLETE, _bitlyCompleteHandler);
			_bitly.shortenUrl(url);
		}
		/*
		Method: _bitlyCompleteHandler
		Parameters:
		event:Event
		Returns:
		*/
		private function _bitlyCompleteHandler($e:Event):void
		{
			Out.status(this, "_bitlyCompleteHandler");
			_bitly.removeEventListener(Event.COMPLETE,_bitlyCompleteHandler);
			var shortened:String = _bitly.shortUrl;
			dispatchEvent(new ORedEvent(Event.COMPLETE, {shortUrl:shortened}));
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

	}
}