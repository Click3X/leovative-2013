package com.cfm.core.vo
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;

	public class CFM_GraphicsParams
	{
		private var _width				:Number = 10;
		private var _height				:Number = 10;
		private var _x					:Number = 0;
		private var _y					:Number = 0;
		private var _gradRotation		:Number = 90;
		private var _gradType			:String = GradientType.LINEAR;
		private var _gradOffsetX		:Number = 0;
		private var _gradOffsetY		:Number = 0;
		private var _corners			:Array;
		private var _colors				:Array = [0];
		private var _alphas				:Array = [1];
		private var _ratios				:Array = [0,255];
		private var _circle				:Boolean = false;
		private var _lineColor			:Number = Number.NaN;
		private var _lineThickness		:Number = 1;
		private var _lineCaps			:String = CapsStyle.NONE;
		private var _lineJoints			:String = JointStyle.MITER;
		
		public function CFM_GraphicsParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}
		
		public function get hasLineStyle():Boolean{return (!isNaN(this.lineColor));}
		public function get isGradient():Boolean{return (colors.length > 1);}
		public function get roundedCorners():Boolean{return (corners != null);}
		public function get complexCorners():Boolean{return corners.length > 1;}
		
		public function get width():Number{return _width};
		public function set width(value:Number):void{_width =  value};
		
		public function get height():Number{return _height};
		public function set height(value:Number):void{_height = value};
		
		public function get x():Number{return _x};
		public function set x(value:Number):void{_x = value};
		
		public function get y():Number{return _y};
		public function set y(value:Number):void{_y = value};
		
		public function get gradRotation():Number{return _gradRotation};
		public function set gradRotation(value:Number):void{_gradRotation = value};
		
		public function get gradType():String{return _gradType};
		public function set gradType(value:String):void{_gradType = value};
		
		public function get gradOffsetY():Number{return _gradOffsetY};
		public function set gradOffsetY(value:Number):void{_gradOffsetY = value};
		
		public function get gradOffsetX():Number{return _gradOffsetX};
		public function set gradOffsetX(value:Number):void{_gradOffsetX = value};
		
		public function get corners():Array{return _corners};
		public function set corners(value:Array):void{_corners = value};
		
		public function get colors():Array{return _colors};
		public function set colors(value:Array):void{_colors = value};
		
		public function get alphas():Array{return _alphas};
		public function set alphas(value:Array):void{_alphas = value};
		
		public function get ratios():Array{return _ratios};
		public function set ratios(value:Array):void{_ratios = value};
		
		public function get circle():Boolean{return _circle};
		public function set circle(value:Boolean):void{_circle = value};
		
		public function get lineColor():Number{return _lineColor};
		public function set lineColor(value:Number):void{_lineColor = value};
		
		public function get lineThickness():Number{return _lineThickness};
		public function set lineThickness(value:Number):void{_lineThickness = value};
		
		public function get lineCaps():String{return _lineCaps};
		public function set lineCaps(value:String):void{_lineCaps = value};
		
		public function get lineJoints():String{return _lineJoints};
		public function set lineJoints(value:String):void{_lineJoints = value};
	}
}