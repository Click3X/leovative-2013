package com.cfm.core.graphics
{
	import com.cfm.core.util.skewObject;
	
	import flash.display.Sprite;
	
	public class CFM_DashedLine extends Sprite
	{			
		public function CFM_DashedLine(_width:Number, _height:Number, _dashColor:Number = 0, _dashAlpha:Number = 1, _spaceWidth:Number = 20, _dashWidth:Number = 20, _skewX:Number = 0, _skewY:Number = 0)
		{
			var numDashes:Number = int(_width/(_dashWidth+_spaceWidth));
			var dash:Sprite = new Sprite();
			
			dash.graphics.beginFill(_dashColor, _dashAlpha);
			addChild(dash);
			skewObject(dash, _skewX, _skewY);
			
			for (var i:Number = 0; i<numDashes; i++)
				dash.graphics.drawRect( i*(_dashWidth+_spaceWidth) , 0 , _dashWidth, _height );
		}
	}
}