package com.cfm.core.interfaces.navigation
{
	public interface CFM_INavigation
	{
		function disableButtonByIndex(_index:Number)											:void
		function enableButtonByIndex(_index:Number)												:void
		function disableButtonById(_id:String)													:void
		function enableButtonById(_id:String)													:void
		function getButtonLabelText(_id:String)													:void
		function selectButtonById(_id:String, _dispatch:Boolean = false)						:void
		function changeButtonLabelById(_id:String, _label:String, updateSize:Boolean = true)	:void
		function resetButtonLabelById(_id:String)												:void
		function selectButton(_childIndex:Number, _dispatch:Boolean = false)					:void
	}
}