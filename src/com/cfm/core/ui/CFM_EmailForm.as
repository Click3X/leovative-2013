package com.cfm.core.ui
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_FormEvent;
	import com.cfm.core.events.CFM_FormFieldEvent;
	import com.cfm.core.objects.CFM_Object;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class CFM_EmailForm extends CFM_Object
	{
		protected var container:CFM_ObjectContainer;
		protected var formFieldsList:XMLList;
		protected var formField:CFM_FormField;
		protected var fieldsArray:Array = [];
		protected var phpUrl:String;
		protected var sendVars:URLVariables;
		protected var FIELD_SPACING:Number = 8;
		
		public function CFM_EmailForm(_fields:XMLList, _phpUrl:String, _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			formFieldsList = _fields;
			phpUrl = _phpUrl;
			
			super("CFM_Form", _autoInit, _autoDestroy);
		}
		
		public function getField(_index:Number):CFM_FormField{
			return fieldsArray[_index];
		}
		
		protected override function build():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			
			buildFields();
		}
		
		protected function buildFields():void{
			var i:Number = 0;
			for each(var fo:XML in formFieldsList){
				trace("*****defaultText = " + fo.@defaultText);
				formField = buildField(fo.childIndex(), fo);
				formField.addEventListener(CFM_FormFieldEvent.VALIDATE, fieldChanged);
				formField.renderTo(container);
				formField.setProperties({y:i>0?fieldsArray[i-1].y + fieldsArray[i-1].height + FIELD_SPACING : 0});
				fieldsArray.push(formField);
				i++;
			}
		}
		
		protected function buildField(_index:Number, _tag:XML):CFM_FormField{
			return new CFM_FormField(_index,_tag.@email == "yes" ? true : false, _tag.@required == "yes" ? true : false, _tag.@password == "yes" ? true : false, _tag.@defaultText);
		}
		
		public function fieldChanged(e:CFM_FormFieldEvent):void{
			dispatchEvent(new CFM_FormEvent(CFM_FormEvent.VALIDATE_FORM,"",validateForm() ));
		}
		
		public function validateForm():Boolean{
			var valid:Boolean = true;
			
			for each(var f:CFM_FormField in fieldsArray){
				if(f.enabled && !f.validate()) valid = false;
			}
			
			return valid;
		}
		
		public function submitForm(_addParams:Object = null):void{
			if(validateForm()){
				send(_addParams);
			} else {
				dispatchEvent(new CFM_FormEvent(CFM_FormEvent.VALIDATE_FORM,"",false));
			}
		}
		
		public function resetForm():void{
			for each(var f:CFM_FormField in fieldsArray){
				f.reset();
			}
		}
		
		protected function send(_addParams:Object = null):void{
			sendVars = new URLVariables();
			
			var fi:Number = 0;
			for (var i:Number =0; i <formFieldsList.length(); i++ ){
				sendVars[formFieldsList[fi].@value] = CFM_FormField(fieldsArray[fi]).inputValue;
				fi++;
			}
			
			if(_addParams){
				for (var s:String in _addParams) sendVars[s] = _addParams[s]; 
			}
		}
	}
}