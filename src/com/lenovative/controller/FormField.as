package com.lenovative.controller
{
	import com.cfm.core.events.CFM_ButtonEvent;
	import com.cfm.core.text.CFM_TextField;
	import com.cfm.core.ui.CFM_FormField;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.greensock.TweenMax;
	import com.lenovative.model.Constants;
	
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	public class FormField extends CFM_FormField
	{
		private var _submit_button:SubmitButton;
		private var _label:CFM_TextField;
		
		public function FormField(_index:Number, _isEmail:Boolean=false, _required:Boolean=true, _password:Boolean=false, _defaultText:String="", _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _isEmail, _required, _password, _defaultText, _autoInit, _autoDestroy);
			
			this.filters = Constants.SHADOW_STYLE;
		}
		
		override protected function get inputParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.type = TextFieldType.INPUT;
			p.font = Constants.GOTHAM_BOOK;
			p.size = 37;
			p.width = 400;
			p.color = 0x555555;
			return p;
		}
		
		protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Constants.GOTHAM_BOOK;
			p.size = 37;
			p.color = 0x555555;
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xDDDDDD];
			p.alphas = [1];
			p.lineColor = 0xFFFFFF;
			p.lineThickness = 2;
			return p;
		}
		
		override protected function buildLabel():void{
			_label = new CFM_TextField("@",labelParams);
			_label.renderTo(labelContainer);
			_label.x = -_label.width - 6;
			_label.y = 9;
		}
		
		override protected function buildInput():void{
			super.buildInput();
			buildSubmit();
		}
		
		private function buildSubmit():void{
			_submit_button = new SubmitButton();
			_submit_button.renderTo(this);
			_submit_button.addEventListener(CFM_ButtonEvent.BUTTON_CLICKED, onSubmitClicked, false, 0, true);
		}
		
		private function onSubmitClicked(e:CFM_ButtonEvent):void{
			dispatchEvent(new Event("submit"));
		}
				
		override protected function buildComplete():void{
			super.buildComplete();
			
			_submit_button.setProperties({x:background.width + 4});
		}
		
		override protected function toFocusState():void{
			TweenMax.killTweensOf(backgroundContainer);
			TweenMax.to(backgroundContainer, tweenTime, Constants.HOVER_STYLE);
		}
	}
}