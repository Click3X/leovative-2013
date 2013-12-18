package com.lenovative.model
{
	import flash.filters.DropShadowFilter;
	import flash.text.Font;

	public class Constants
	{
		public static const SAVE_ROUTE					:String = "photobooth/save";
		
		public static const START_SCREEN				:String = "start_screen";
		public static const CAPTURE_SCREEN				:String = "capture_screen";
		public static const FINISH_SCREEN				:String = "finish_screen";
		public static const EXPORT_COMPLETE				:String = "export_complete";
		
		public static const SIDE_LENGTH			:Number = 500;
		public static const GUTTER				:Number = 12;
		
		public static const GOTHAM_BOOK				:Font = new Gotham_Book();
		public static const GOTHAM_MEDIUM			:Font = new Gotham_Medium();
		
		public static const HOVER_STYLE			:Object = {dropShadowFilter:{color:0, blurX:10, blurY:10, alpha:.3,amount:.5, inner:false}};
		public static const SHADOW_STYLE		:Array = [new DropShadowFilter(3,40,0x999999,.5,18,18,.5,2), new DropShadowFilter(40,25,0xFFFFFF,.9,10,10,.5,2)];
	}
}