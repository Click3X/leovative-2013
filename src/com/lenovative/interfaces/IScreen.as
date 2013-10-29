package com.lenovative.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IScreen extends IEventDispatcher
	{
		function init():void;
		function transitionIn():void;
		function transitionOut():void;
		function resize():void;
		function reset():void;
	}
}