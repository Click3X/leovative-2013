package com.lenovative.model
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		// =================================================
		// ================ Instance Vars
		// =================================================
		private var _stageRef				:Stage;
		private var _curPics				:Vector.<Bitmap>;
		
		// =================================================
		// ================ Singleton
		// =================================================
		private static var __instance       :Model;
		public static function getInstance():Model { return __instance || (__instance = new Model()); };
		// =================================================
		// ================ Public
		// =================================================


		public function reset():void{
			_curPics = null;
			_curPics = new Vector.<Bitmap>();
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
	}
}