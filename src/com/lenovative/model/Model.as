package com.lenovative.model
{
	import com.lenovative.interfaces.IScreen;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	
	import net.ored.util.out.Out;
	
	public class Model extends EventDispatcher
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _stageRef				:Stage;
		private var _curPics				:Vector.<Bitmap>;
		private var _twitterHandle			:String;
		private var _twitterHashtag			:String;
		private var _compositedImage		:Bitmap;
		private var _screenIds				:Array = ["start","capture","finish"];
		private var _screens				:Vector.<IScreen>;
		// =================================================
		// ================ Singleton
		// =================================================
		private static var __instance       :Model;
		public static function getInstance():Model { return __instance || (__instance = new Model()); };
		// =================================================
		// ================ Public
		// =================================================
		public function init($stage:Stage):void{
			stageRef 	= $stage;
			_screens 	= new Vector.<IScreen>();
		}

		public function flushBitmaps():void{
			_curPics = null;
			_curPics = new Vector.<Bitmap>();
		}
		public function isFullScreen():Boolean{
			return stageRef.displayState == StageDisplayState.FULL_SCREEN;
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function getScreenById($id:String):IScreen{
			var screen:IScreen;
			
			switch($id){
				case "start" :
					screen = _screens[0];
					break;
				case "capture" :
					screen = _screens[1];
					break;
				case "finish":
					screen = _screens[2];
					break;
				default: Out.error(this, "NO SCREEN FOUND");
			}
			return screen;
		}
		public function get stageRef():Stage
		{
			return _stageRef;
		}

		public function set stageRef(value:Stage):void
		{
			_stageRef = value;
		}

		public function get curPics():Vector.<Bitmap>
		{
			return _curPics;
		}

		public function set curPics(value:Vector.<Bitmap>):void
		{
			_curPics = value;
		}

		public function get compositedImage():Bitmap
		{
			return _compositedImage;
		}

		public function set compositedImage(value:Bitmap):void
		{
			_compositedImage = value;
		}

		public function get screenIds():Array
		{
			return _screenIds;
		}

		public function set screenIds(value:Array):void
		{
			_screenIds = value;
		}

		public function get screens():Vector.<IScreen>
		{
			return _screens;
		}

		public function set screens(value:Vector.<IScreen>):void
		{
			_screens = value;
		}

		public function get twitterHandle():String
		{
			return _twitterHandle;
		}

		public function set twitterHandle(value:String):void
		{
			_twitterHandle = value;
		}

		public function get twitterHashtag():String
		{
			return _twitterHashtag;
		}

		public function set twitterHashtag(value:String):void
		{
			_twitterHashtag = value;
		}


	}
}