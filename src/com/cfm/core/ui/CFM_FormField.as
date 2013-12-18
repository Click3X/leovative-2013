package com.cfm.core.ui
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.graphics.CFM_Graphics;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.text.CFM_TextField;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;
	
	public class CFM_FormField extends CFM_Object
	{
		protected var MARGIN:int = 10;
		
		protected var backgroundContainer:CFM_ObjectContainer;
		protected var labelContainer:CFM_ObjectContainer;
		protected var errorContainer:CFM_ObjectContainer;
		
		public var background:CFM_Graphics;
		protected var error:CFM_Graphics;
		
		protected var input:CFM_TextField;
		
		protected var defaultText:String;
		protected var isEmail:Boolean;
		protected var tweenTime:Number;
		protected var isValid:Boolean = false;
		protected var index:Number;
		public var enabled:Boolean = true;
		protected var required:Boolean = true;
		protected var isPassword:Boolean = false;
		
		public function CFM_FormField(_index:Number, _isEmail:Boolean = false, _required:Boolean = true, _password:Boolean = false, _defaultText:String="", _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			defaultText = _defaultText;
			isEmail = _isEmail;
			index = _index;
			required = _required;
			isPassword = _password;
			
			super("CFM_FormField",_autoInit, _autoDestroy);
		}
		
		public function get inputValue():String{return input.text;}
		
		protected override function build():void{
			backgroundContainer = new CFM_ObjectContainer();
			backgroundContainer.renderTo(this);
			
			labelContainer = new CFM_ObjectContainer();
			labelContainer.renderTo(this);
			
			errorContainer = new CFM_ObjectContainer();
			errorContainer.renderTo(this);
			
			buildBackground();
			buildError();
			
			buildInput();
			buildLabel();
			buildComplete();
		}
		
		protected function get inputParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({type:TextFieldType.INPUT, width:300, color:0xFFFFFF, size:14, displayAsPassword:isPassword});
		}
		
		public function reset():void{
			input.text = defaultText;
			isValid = validate();
		}
		
		protected function buildBackground():void{
			background = new CFM_Graphics(backgroundParams);
			background.renderTo(backgroundContainer);
		}
		
		protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0x999999]
			p.alphas = [1]
			p.width = 10;
			p.height = 10;
			return p;
		}
				
		protected function buildError():void{
			error = new CFM_Graphics(new CFM_GraphicsParams({colors:[0xFFFFFF], alphas:[0], width:10, height:10}));
			error.renderTo(errorContainer);
		}
		
		protected function buildInput():void{
			input = new CFM_TextField(defaultText, inputParams);
			input.renderTo(this);
			input.setProperties({x:background.x + MARGIN+1, y:MARGIN});
		}
		
		protected function buildLabel():void{}
		
		override protected function buildComplete():void{
			background.redraw(input.width+(MARGIN*2),input.height+(MARGIN*2),0,0);
			error.redraw(input.width+(MARGIN*2),input.height+(MARGIN*2),0,0);
			input.tabIndex = index;
			//validate();
			focusOut(null);
		}
		
		protected override function addListeners():void{
			input.addEventListener(FocusEvent.FOCUS_IN, focusIn, false, 0, true);
			input.addEventListener(FocusEvent.FOCUS_OUT, focusOut, false, 0, true);
			input.addEventListener(Event.CHANGE, onChange, false, 0, true);
		}
		
		protected function focusIn(e:FocusEvent):void{
			toFocusState();
			
			if(input.text == defaultText){
				input.text = "";
			}

			input.displayAsPassword = inputParams.displayAsPassword;
		}
		
		protected function toErrorState():void{
			isValid = false;
			
			TweenMax.killTweensOf(errorContainer);
			TweenMax.to(errorContainer, .3, {autoAlpha:1});
		}
				
		protected function noErrorState():void{
			isValid = true;
			
			TweenMax.killTweensOf(errorContainer);
			TweenMax.to(errorContainer, .3, {autoAlpha:0});
		}
		
		protected function toFocusState():void{
			TweenMax.killTweensOf(backgroundContainer);
			TweenMax.to(backgroundContainer, tweenTime, {dropShadowFilter:{color:0, blurX:8, blurY:8, alpha:.3,amount:1, inner:false}});
		}
		
		protected function toUnFocusedState():void{
			TweenMax.killTweensOf(backgroundContainer);
			TweenMax.to(backgroundContainer, tweenTime, {dropShadowFilter:{color:0, blurX:0, blurY:0, alpha:0,amount:0, inner:false,remove:true}});
		}
		
		protected function focusOut(e:FocusEvent):void{
			toUnFocusedState();
			
			if(input.text == "" || input.text == defaultText){
				input.displayAsPassword = false;
				input.text = defaultText;
			}	
		}
		
		protected function onChange(e:Event):void{
			//dispatchEvent(new CFM_FormFieldEvent(CFM_FormFieldEvent.VALIDATE, input.text, validate(),true));
		}
		
		public function validate():Boolean{
			var valid:Boolean = true;
			
			if(required){
				if(input.text.length >= 1 && input.text != defaultText){
					if(isEmail){
						if(!validateEmail(input.text)){
							valid = false;
						}
					}
				} else {
					valid = false;
					toErrorState();
				}
			}
			
			if(!valid){
				toErrorState();
			} else {
				noErrorState();
			}
			
			return valid;
		}
		
		protected override function removeListeners():void{
			input.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
			input.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
			input.removeEventListener(Event.CHANGE, onChange);
		}
		
		protected function validateEmail(_txt:String):Boolean{
			var v:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return v.test(_txt);
		}
		
		public function disable():void{
			backgroundContainer.alpha = .5;
			input.mouseEnabled = false;
			enabled = false;
		}
		
		public function enable():void{
			backgroundContainer.alpha = 1;
			input.mouseEnabled = true;
			enabled = true;
		}
	}
}