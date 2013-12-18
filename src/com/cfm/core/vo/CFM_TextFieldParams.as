package com.cfm.core.vo
{	
	import com.cfm.core.managers.CFM_FontManager;
	
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;

	public class CFM_TextFieldParams
	{
		private var _font				:Font = new CFM_FontManager.Default();
		private var _width				:Number = Number.NaN;
		private var _height				:Number = Number.NaN;
		private var _maxChars			:Number = Number.NaN;
		private var _backgroundColor	:Number = Number.NaN;
		private var _color 				:Number = 0;
		private var _leading 			:Number = 0;
		private var _indent 			:Number = 0;
		private var _letterSpacing 		:Number = 0;
		private var _leftMargin 		:Number = 0;
		private var _rightMargin		:Number = 0;
		private var _size 				:Number = 14;
		private var _align 				:String = TextFormatAlign.LEFT;
		private var _antiAliasType		:String = AntiAliasType.ADVANCED;
		private var _type				:String = TextFieldType.DYNAMIC;
		private var _autoSize			:String = TextFieldAutoSize.LEFT;
		private var _url				:String;
		private var _underline 			:Boolean = false;
		private var _multiline			:Boolean = false;
		private var _displayAsPassword	:Boolean = false;
		private var _wordWrap			:Boolean = false;
		private var _isHtml				:Boolean = true;
		private var _embedFonts			:Boolean = true;
		private var _selectable			:Boolean = false;
		private var _bullet				:Boolean = false;
		private var _italic				:Boolean = false;
		private var _styleSheet			:StyleSheet = null;
		private var _tabStops			:Array;
		
		public function CFM_TextFieldParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}
		
		public function get tabStops():Array{return _tabStops;}
		public function set tabStops(value:Array):void{_tabStops = value;}

		public function get styleSheet():StyleSheet{return _styleSheet;}
		public function set styleSheet(value:StyleSheet):void{_styleSheet = value;}
		
		public function get fontName():String{return font.fontName;}
		public function get isInput():Boolean{return type == TextFieldType.INPUT;}	

		public function get italic():Boolean{return _italic;}
		public function set italic(value:Boolean):void{_italic = value;}
		
		public function get bullet():Boolean{return _bullet;}
		public function set bullet(value:Boolean):void{_bullet = value;}
		
		public function get selectable():Boolean{return _selectable;}
		public function set selectable(value:Boolean):void{_selectable = value;}
		
		public function get embedFonts():Boolean{return _embedFonts;}
		public function set embedFonts(value:Boolean):void{_embedFonts = value;}
		
		public function get isHtml():Boolean{return _isHtml;}
		public function set isHtml(value:Boolean):void{_isHtml = value;}
		
		public function get wordWrap():Boolean{return _wordWrap;}
		public function set wordWrap(value:Boolean):void{_wordWrap = value;}
		
		public function get displayAsPassword():Boolean{return _displayAsPassword;}
		public function set displayAsPassword(value:Boolean):void{_displayAsPassword = value;}
		
		public function get multiline():Boolean{return _multiline;}
		public function set multiline(value:Boolean):void{_multiline = value;}
		
		public function get underline():Boolean{return _underline;}
		public function set underline(value:Boolean):void{_underline = value;}
		
		public function get url():String{return _url;}
		public function set url(value:String):void{_url = value;}
		
		public function get autoSize():String{return _autoSize;}
		public function set autoSize(value:String):void{_autoSize = value;}
		
		public function get type():String{return _type;}
		public function set type(value:String):void{_type = value;}

		public function get antiAliasType():String{return _antiAliasType;}
		public function set antiAliasType(value:String):void{_antiAliasType = value;}

		public function get align():String{return _align;}
		public function set align(value:String):void{_align = value;}

		public function get size():Number{return _size;}
		public function set size(value:Number):void{_size = value;}

		public function get rightMargin():Number{return _rightMargin;}
		public function set rightMargin(value:Number):void{_rightMargin = value;}

		public function get leftMargin():Number{return _leftMargin;}
		public function set leftMargin(value:Number):void{_leftMargin = value;}
		
		public function get letterSpacing():Number{return _letterSpacing;}
		public function set letterSpacing(value:Number):void{_letterSpacing = value;}

		public function get indent():Number{return _indent;}
		public function set indent(value:Number):void{_indent = value;}

		public function get leading():Number{return _leading;}
		public function set leading(value:Number):void{_leading = value;}

		public function get color():Number{return _color;}
		public function set color(value:Number):void{_color = value;}

		public function get backgroundColor():Number{return _backgroundColor;}
		public function set backgroundColor(value:Number):void{_backgroundColor = value;}

		public function get maxChars():Number{return _maxChars;}
		public function set maxChars(value:Number):void{_maxChars = value;}

		public function get height():Number{return _height;}
		public function set height(value:Number):void{_height = value;}

		public function get width():Number{return _width;}
		public function set width(value:Number):void{_width = value;}

		public function get font():Font{return _font;}
		public function set font(value:Font):void{_font = value;}
	}
}