package com.lenovative.controller
{
	import com.lenovative.interfaces.IScreen;
	import com.lenovative.model.Constants;
	import com.lenovative.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
<<<<<<< HEAD
	import flash.events.IEventDispatcher;
=======
	import flash.events.MouseEvent;
>>>>>>> parent of 218d65c... init
	
	import net.ored.events.ORedNavEvent;
	import net.ored.util.out.Out;
	
	public class FinishScreen extends EventDispatcher implements IScreen
	{
		private var _m:Model;
		
<<<<<<< HEAD
		public var view:Sprite;
		
		private var _photo_container:Sprite;
		
		private var _navigation:NavigationTemplate;
		
		//private var _heading:ScreenHeading;
		
		private var _exporter:ExportBitmapService;
		
=======
		public var view:DisplayPhotoClip;
>>>>>>> parent of 218d65c... init
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
<<<<<<< HEAD
			//_heading.x = (_m.stageRef.stageWidth-_heading.width)*.5;
			_photo_container.x = (_m.stageRef.stageWidth-_photo_container.width)*.5;
			_navigation.x = (_m.stageRef.stageWidth-_navigation.width)*.5;
			
			view.y = (_m.stageRef.stageHeight-view.height)*.5;
=======
			view.x = _m.stageRef.stageWidth/2 - view.width/2;
			view.y = _m.stageRef.stageHeight/2 - view.height/2;
>>>>>>> parent of 218d65c... init
		}
		// =================================================
		// ================ Initialize
		// =================================================
<<<<<<< HEAD
		
		public function FinishScreen(target:IEventDispatcher=null)
		{
			super(target);
			
			_m = Model.getInstance();
			
			_exporter = new ExportBitmapService();
			_exporter.addEventListener(Constants.EXPORT_COMPLETE,onExportComplete);
			
			view = new Sprite();
			view.visible = false;
		}
		
		private function onExportComplete(e:ORedEvent):void{
			dispatchEvent(new ORedNavEvent(Constants.START_SCREEN));			
		}
		
		private function _createChildren():void{
//			_heading = new ScreenHeading("THAT LOOKS AMAZING!");
//			_heading.renderTo(view);
//			
			_photo_container = new Sprite();
			_photo_container.y = 40;
			_photo_container.filters = Constants.SHADOW_STYLE;
			view.addChild(_photo_container);
			
			_navigation = new NavigationTemplate(_button_list,false,false);
			_navigation.renderTo(view);
			_navigation.setProperties({y:720-_navigation.height});
			_navigation.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED,_onNavClicked);
		}
		
		private function _onNavClicked(e:CFM_NavigationEvent):void{
			switch(e.id){
				case "send":
					_exportBitmap();
					break;
				case "try_again":
					dispatchEvent(new ORedNavEvent(Constants.CAPTURE_SCREEN));
					break;
				case "quit":
					dispatchEvent(new ORedNavEvent(Constants.START_SCREEN));
					break;
			}
		}
		
		private function _exportBitmap():void
		{
			Out.status(this, "_exportBitmap");
			
			trace(_m.compositedImage.bitmapData);
			trace(_m.twitterHandle);
			
			_exporter.export(_m.params.base_url + Constants.SAVE_ROUTE, _m.compositedImage.bitmapData, _m.twitterHandle);
		}
		
		private function get _button_list():XMLList{
			var nav:XML = <navigation/>;
			
			var send		:XML = <button id='send' value='send'><label>Love It!</label></button>;
			var try_again	:XML = <button id='try_again' value='try_again'><label>Re-Take</label></button>;
			var quit		:XML = <button id='quit' value='quit'><label>Start Over</label></button>;
				
			nav.appendChild(send);
			nav.appendChild(try_again);
			nav.appendChild(quit);
			
			return nav.button;
		}
=======
>>>>>>> parent of 218d65c... init
	}
}