package com.cfm.core.events
{
	import flash.events.Event;

	public class CFM_DropdownMenuEvent extends Event
	{
		public static const ITEM_SELECTED			:String = "itemSelected";
		public static const OPEN_MENU				:String = "openMenu";
		public static const CLOSE_MENU				:String = "closeMenu";
		public static const CLEAR_SELECTION			:String = "clearSelection";
		
		public var itemIndex						:Number;
		public var itemValue						:String;
		public var menuIndex						:Number;
		public var menuValue						:String;
		
		public function CFM_DropdownMenuEvent(type:String, _menuIndex:Number, _menuValue:String, _itemIndex:Number,  _itemValue:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			itemIndex 		= _itemIndex;
			itemValue 		= _itemValue;
			menuIndex 		= _menuIndex;
			menuValue 		= _menuValue;
		}
		
	}
}