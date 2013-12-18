package com.cfm.core.interfaces.buttons
{
	[Event(name="buttonClicked", type="com.cfm.core.events.CFM_ButtonEvent")]
	
	public interface CFM_IButton
	{			
		function deselect()														:void;
		function select(_dispatch:Boolean = false)								:void;
		function enable()														:void;
		function disable()														:void;
		function resetLabel(updateSize:Boolean = true)							:void;
		function updateLabel(_newLabel:String, updateSize:Boolean = true)		:void;
		function get labelText()												:String;
	}
}