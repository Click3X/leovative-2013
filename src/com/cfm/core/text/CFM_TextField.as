package com.cfm.core.text
{
	import com.cfm.core.vo.CFM_TextFieldParams;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CFM_TextField extends TextField
	{
		private var __text			:String;
		private var params			:CFM_TextFieldParams;
		private var _format			:TextFormat = new TextFormat();
		
		public function CFM_TextField(_text:String, _params:CFM_TextFieldParams = null)
		{		
			__text 					= _text;
			params 					= _params ? _params : new CFM_TextFieldParams();
			
			init();
		}
		 
		private function init():void{
			_format.font 				= params.fontName;
			_format.color 				= params.color;
			_format.size 				= params.size;
			_format.leading 			= params.leading;
			_format.indent 				= params.indent;
			_format.letterSpacing 		= params.letterSpacing;
			_format.align 				= params.align;
			_format.underline 			= params.underline;
			_format.leftMargin 			= params.leftMargin;
			_format.rightMargin			= params.rightMargin;
			_format.bullet				= params.bullet;
			_format.url					= params.url;
			_format.italic				= params.italic;
			_format.tabStops			= params.tabStops;
		
			width 						= height = 2;
			defaultTextFormat 			= _format;
			multiline					= params.multiline;
			displayAsPassword 			= params.displayAsPassword;
			embedFonts 					= params.embedFonts; 
			selectable 					= params.isInput ? true : params.selectable;
			antiAliasType 				= params.antiAliasType;
			wordWrap 					= !isNaN(params.width) ? true : params.wordWrap;
			autoSize 					= TextFieldAutoSize.LEFT;
			background					= !isNaN(params.backgroundColor) ? true : false;
			type 						= params.type;
			
			if(params.styleSheet)
				styleSheet = params.styleSheet;
			
			if(!params.isHtml || params.isInput)
				text = __text;
			else
				htmlText = __text;
			
			if(!isNaN(params.width))
				width = params.width;
			
			if(!isNaN(params.height))
				height = params.height;
			
			if(!isNaN(params.maxChars))
				maxChars = params.maxChars;
			
			if(!isNaN(params.backgroundColor))
				backgroundColor = params.backgroundColor;
			
			autoSize 					= !isNaN(params.height) ? TextFieldAutoSize.NONE : params.autoSize;
		}
		
		public function get format():TextFormat{
			return _format;
		}
		
		public function renderTo(_parent:DisplayObjectContainer):void{
			_parent.addChild(this);
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
	}
}