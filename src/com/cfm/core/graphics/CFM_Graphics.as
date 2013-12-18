package com.cfm.core.graphics
{
	import com.cfm.core.vo.CFM_GraphicsParams;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class CFM_Graphics extends Sprite
	{
		private var gradMat			:Matrix;
		private var _params			:CFM_GraphicsParams;
		
		public function CFM_Graphics(__params:CFM_GraphicsParams = null)
		{
			_params 					= __params ? __params : new CFM_GraphicsParams();
			
			redraw( _params.width , _params.height, _params.x, _params.y);
		}
		
		public function redraw(_w:Number, _h:Number, _x:Number, _y:Number):void{
			_params.height 			= _h;
			_params.width 			= _w;
			_params.x 				= _x;
			_params.y 				= _y;
			
			graphics.clear();  
			
			if(_params.hasLineStyle)
				graphics.lineStyle(_params.lineThickness, _params.lineColor,1, false,"normal", _params.lineCaps, _params.lineJoints);
			
			if(_params.isGradient){
				gradMat = new Matrix();
				gradMat.createGradientBox(_params.width,_params.height,_params.gradRotation*(Math.PI/180), _x-(_params.circle ? _w/2 : 0)+params.gradOffsetX, _y-(_params.circle ? _w/2 : 0)+params.gradOffsetY);
				graphics.beginGradientFill(_params.gradType,_params.colors, _params.alphas, _params.ratios, gradMat);
			} else {
				graphics.beginFill(_params.colors[0], _params.alphas[0]);
			}
			
			if(_params.circle)
				graphics.drawCircle( _x , _y , _w/2 );
			else
				if(_params.roundedCorners)
					if(_params.complexCorners)
						graphics.drawRoundRectComplex(_x,_y,_w,_h,_params.corners[0],_params.corners[1],_params.corners[2],_params.corners[3]);
					else
						graphics.drawRoundRect(_x,_y,_w,_h,_params.corners[0],_params.corners[0]);
				else 
					graphics.drawRect(_x,_y,_w,_h);
			
			graphics.endFill();
		}
		
		public function renderTo(_parent:DisplayObjectContainer, index:Number = Number.NaN):void{
			(isNaN(index))?_parent.addChild(this):_parent.addChildAt(this, int(index));
		}
		
		public function remove():void{
			this.parent.removeChild(this);
		}
		
		public function setProperties(_prop:Object):void{
			for (var p:String in _prop){
				if(p=="x" || p=="y" || p=="width" || p=="height")
					this[p] = Math.round(_prop[p]); 
				else
					this[p] = _prop[p]; 
			}
		}
		
		public function get params():CFM_GraphicsParams{
			return _params;
		}
	}
}