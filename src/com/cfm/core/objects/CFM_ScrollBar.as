package com.cfm.core.objects
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_ScrollBarEvent;
	import com.cfm.core.graphics.CFM_Graphics;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="scrolling", type="com.cfm.core.events.CFM_ScrollBarEvent")]

	public class CFM_ScrollBar extends CFM_Object
	{
		protected var container:CFM_ObjectContainer;
		protected var slideContainer:CFM_ObjectContainer;
		protected var thumbContainer:CFM_ObjectContainer;
		
		protected var slideBackground:CFM_Graphics;
		protected var thumb:CFM_Graphics;
		protected var thumbHit:CFM_Graphics;
		protected var currentRatio:Number = 0;
		protected var dragAreaRec:Rectangle;
		
		protected var lastMousePos:Point = new Point();
		protected var lastThumbX:Number;
		
		protected var vertical:Boolean;
		protected var thumbWidth:Number;
		
		public function CFM_ScrollBar(_slideWidth:Number, _thumbWidth:Number, _height:Number, _vertical:Boolean = false, autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			dragAreaRec = new Rectangle(0,0,_slideWidth,_height);
			vertical = _vertical;
			thumbWidth = _thumbWidth;
			
			super("scrollbar",autoInit,_autoDestroy);
		}
		
		override protected function build():void{			
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			container.setProperties({x:vertical?dragAreaRec.height:0,rotation:vertical?90:0});
			
			slideContainer = new CFM_ObjectContainer();
			slideContainer.renderTo(container);
			
			thumbContainer = new CFM_ObjectContainer();
			thumbContainer.renderTo(container);
			
			buildSlideBackground();
			buildSlide();
			buildThumb();
			buildThumbHit();
			
			toOutState(false);
		}
		
		protected function buildSlideBackground():void{
			slideBackground = new CFM_Graphics(slideBackgroundParams);
			slideBackground.renderTo(slideContainer);
		}
		
		protected function buildSlide():void{}
		
		protected function buildThumb():void{
			thumb = new CFM_Graphics(thumbParams);
			thumb.renderTo(thumbContainer);
		}
		
		private function buildThumbHit():void{
			thumbHit = new CFM_Graphics(new CFM_GraphicsParams({width:thumbWidth, height:dragAreaRec.height, colors:[0xFFFFFF], alphas:[0]}));
			thumbHit.buttonMode = true;
			thumbHit.renderTo(thumbContainer);
		}
		
		protected function get slideBackgroundParams():CFM_GraphicsParams{
			var params:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			with(params){
				width = dragAreaRec.width;
				height = dragAreaRec.height;
				colors = [0x999999];
				gradRotation = 0;
				alphas = [1];
			}
			
			return params;
		}
		
		protected function get thumbParams():CFM_GraphicsParams{
			var params:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			with(params){
				width =  thumbWidth-4;
				y = 2;
				x = 2;
				height = dragAreaRec.height-4;
				colors = [0xFFFFFF];
				alphas = [1];
			}
			
			return params;
		}
		
		protected function get thumbHitParams():CFM_GraphicsParams{
			var params:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			with(params){
				width = thumbWidth;
				height = dragAreaRec.height;
				alphas = [0];
			}
			
			return params;
		}
		
		override protected function addListeners():void{
			thumbHit.addEventListener(MouseEvent.MOUSE_DOWN, startDragThumb, false, 0, true);
			thumbHit.addEventListener(MouseEvent.MOUSE_OVER, thumbOver, false, 0, true);
			thumbHit.addEventListener(MouseEvent.MOUSE_OUT, thumbOut, false, 0, true);
		}
		
		override protected function removeListeners():void{
			thumbHit.removeEventListener(MouseEvent.MOUSE_DOWN,startDragThumb);
			thumbHit.removeEventListener(MouseEvent.MOUSE_OVER, thumbOver);
			thumbHit.removeEventListener(MouseEvent.MOUSE_OUT, thumbOut);
		}
		
		private function thumbOver(e:MouseEvent):void{
			killTweens();
			toOverState();
		}
		
		private function thumbOut(e:MouseEvent):void{
			killTweens();
			toOutState();
		}
		
		protected function toOverState():void{
			TweenMax.to(thumb, .2, {tint:0xFFFFFF, ease:Linear.easeNone});
		}
		
		protected function toOutState(_tween:Boolean = true):void{
			TweenMax.to(thumb, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
		}
		
		protected function killTweens():void{
			TweenMax.killTweensOf(thumb);
			TweenMax.killTweensOf(thumbHit);
		}
		
		private function startDragThumb(e:MouseEvent):void{
			lastMousePos.y = stage.mouseY;
			lastMousePos.x = stage.mouseX;
			lastThumbX = thumbContainer.x;
			
			killTweens();
			removeListeners();
			toOverState();
			
			if(stage){
				stage.addEventListener(MouseEvent.MOUSE_UP, stopDragThumb);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbHitDragging);
			}
		}
		
		protected function stopDragThumb(e:MouseEvent=null):void{
			killTweens();
			addListeners();
			toOutState();
			
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragThumb);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbHitDragging);
			}
		}
		
		public function adjustThumb(percent:Number, dispatch:Boolean = false):void{			
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragThumb);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbHitDragging);
			}
			
			currentRatio = percent;
			
			removeListeners();
			
			var newP:Number = (dragAreaRec.width- thumbWidth)*percent;
			
			if(thumbContainer.x != newP)
				TweenMax.to(thumbContainer, .3, { onUpdate: dispatch ? dispatchNewRatio : null, delay:.1, x:newP, onComplete:stopDragThumb});
			else
				stopDragThumb();
		}
		
		protected function thumbHitDragging(e:MouseEvent=null):void{
			if(stage){
				var newThumbX:Number = lastThumbX + (stage.mouseX - lastMousePos.x);
				
				if(vertical)
					newThumbX = lastThumbX + (stage.mouseY - lastMousePos.y);
				
				if(newThumbX < 0)
					newThumbX = 0;
				
				if(newThumbX > dragAreaRec.width-thumbWidth)
					newThumbX = dragAreaRec.width-thumbWidth;
				
				thumbContainer.x = newThumbX;
				currentRatio = (thumbContainer.x/(dragAreaRec.width-thumbWidth));
				
				dispatchNewRatio();
			}
		}
		
		public function dispatchNewRatio():void{
			dispatchEvent(new CFM_ScrollBarEvent(CFM_ScrollBarEvent.SCROLLING, currentRatio));
		}
		
		private function reset():void{
			TweenMax.to(thumbContainer, .5, {x:0, ease: Cubic.easeInOut});
			lastThumbX = 0;
		}
		
		public function resize(_width:Number):void{
			dragAreaRec.width = _width;
			
			resizeSlideBackground(_width);
					
			adjustThumb(currentRatio,true);
		}
		
		protected function resizeSlideBackground(_width:Number):void{
			if(slideBackground) 
				slideBackground.redraw(_width,dragAreaRec.height,0,0);
		}
	}
}