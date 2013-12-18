package com.lenovative.controller
{
	import com.cfm.core.text.CFM_TextField;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.lenovative.model.Constants;
	
	public class ScreenHeading extends CFM_TextField
	{
		public function ScreenHeading(_text:String)
		{
			super(_text, _params);
			
			this.filters = Constants.SHADOW_STYLE;
		}
		
		private function get _params():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.size = 60;
			p.color = 0x222222;
			p.letterSpacing = -2;
			p.font = Constants.GOTHAM_MEDIUM;
			return p;
		}
	}
}