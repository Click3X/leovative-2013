package com.cfm.core.factories
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.graphics.CFM_Graphics;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	public class CFM_WindowFactory extends CFM_PageFactory
	{
		protected var overlay:CFM_Graphics;
		
		public function CFM_WindowFactory(_pageContainer:CFM_ObjectContainer, _pageList:XMLList)
		{
			super(_pageContainer,_pageList);
			
			buildOverlay();
		}
		
		protected function buildOverlay():void{
			overlay = new CFM_Graphics( overlayParams );
			overlay.renderTo(pageContainer);
			hideOverlay(false);
		}
		
		protected function get overlayParams():CFM_GraphicsParams{
			var params:CFM_GraphicsParams = new CFM_GraphicsParams();
			params.colors = [0xFFFFFF];
			params.alphas = [.9];
			return params;
		}
		
		public function showOverlay(_tween:Boolean = true):void{
			TweenMax.killTweensOf(overlay);
			TweenMax.to(overlay, _tween ? .3 : 0, {autoAlpha:1, ease:Cubic.easeInOut});
		}
		
		public function hideOverlay(_tween:Boolean = true):void{
			TweenMax.killTweensOf(overlay);
			TweenMax.to(overlay, _tween ? .3 : 0, {autoAlpha:0, ease:Cubic.easeInOut});
		}
		
		override public function removeCurrentPage(_tween:Boolean = true):void{
			super.removeCurrentPage(_tween);
			hideOverlay();
		}
		
		override protected function newPage(_params:Object = null):void{
			showOverlay();
			super.newPage(_params);
		}
		
		public function resize(_w:Number, _h:Number):void{
			overlay.redraw(_w,_h,0,0);
			overlay.setProperties({x:-_w*.5, y:-_h*.5});
			pageContainer.setProperties({x:_w*.5, y:_h*.5});
		}
	}
}