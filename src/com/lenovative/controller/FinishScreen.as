package com.lenovative.controller
{
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.out.Out;
	
	public class FinishScreen extends EventDispatcher implements IScreen
	{
		private var _m:Model;
		
		public var view:DisplayPhotoClip;
		// =================================================
		// ================ Instance Vars
		// =================================================
		
		// =================================================
		// ================ Public
		// =================================================
		public function init():void{
			_m = Model.getInstance();
			
			view 				= new DisplayPhotoClip();
			view.visible 		= false;
			
			view.startOverBtn.addEventListener(MouseEvent.CLICK, _onStartOverClick);
			
			resize();
		}
		
		public function addPhoto(_image:Bitmap, _bitmaps:Vector.<Bitmap>):void{
			removePhoto();
			view.photo_container.addChild(_image);
			
			var seq:ImageSequence = new ImageSequence(_bitmaps,100);
			seq.x = Constants.SIDE_LENGTH+(Constants.GUTTER);
			view.photo_container.addChild(seq);
			seq.play();
		}
		
		public function removePhoto():void{
			while( view.photo_container.numChildren > 0 ){
				var c:DisplayObject = view.photo_container.getChildAt(0);
				if(c is ImageSequence){
					ImageSequence(c).destroy();
				}
				view.photo_container.removeChild(c);
			}
		}
		
		public function transitionIn():void{
			Out.status(this, "transitionIn");
			
			view.visible 	= true;
		}
		
		public function transitionOut():void{
			Out.status(this, "transitionOut");
			
			view.visible 	= false;
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _onStartOverClick($e:MouseEvent):void
		{
			Out.status(this, "_onStartOverClick");		
			
			dispatchEvent(new ORedNavEvent(Constants.START));
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		public function reset():void{
			removePhoto();
			
			resize();
		}
		
		public function resize():void{
			view.x = _m.stageRef.stageWidth/2 - view.width/2;
			view.y = _m.stageRef.stageHeight/2 - view.height/2;
		}
		// =================================================
		// ================ Initialize
		// =================================================
	}
}