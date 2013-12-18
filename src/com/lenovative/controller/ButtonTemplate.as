package com.lenovative.controller
{
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.greensock.TweenMax;
	import com.lenovative.model.Constants;
	
	public class ButtonTemplate extends CFM_SimpleButton
	{
		public function ButtonTemplate(_index:Number, _id:String, _value:String, _labelText:String)
		{
			super(_index, _id, _value, _labelText, 22, 22, false, false, null, true, true);
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xFF0000,0xDD2222];
			p.alphas = [1,1];
			p.lineColor = 0xFFFFFF;
			p.lineThickness = 2;
			return p;
		}
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0xFFFFFF;
			p.font = Constants.GOTHAM_BOOK;
			return p;
		}
		
		override protected function toOverState():void{
			TweenMax.killTweensOf(backgroundContainer);
			TweenMax.to(backgroundContainer, .3, Constants.HOVER_STYLE);
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
			killTweens();
			TweenMax.to(backgroundContainer, .2, {dropShadowFilter:{color:0, blurX:0, blurY:0, alpha:0,amount:0, inner:false,remove:true}});
		}
	}
}