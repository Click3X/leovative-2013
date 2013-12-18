package com.lenovative.controller
{
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.navigation.CFM_SimpleNavigation;
	import com.lenovative.model.Constants;
	
	public class NavigationTemplate extends CFM_SimpleNavigation
	{
		public function NavigationTemplate(_list:XMLList, _allowToggle:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_list, _allowToggle, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy);
			buttonSpacing = 15;
		}
		
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			var b:ButtonTemplate = new ButtonTemplate(_i,_tag.@id,_tag.@value,_tag.label);
			b.filters = Constants.SHADOW_STYLE;
			return b;
		}
	}
}