package com.cfm.core.media
{
	import com.cfm.core.managers.CFM_ImageManager;

	public class CFM_FacebookImage extends CFM_Image
	{
		public function CFM_FacebookImage(_url:String, _width:Number, _height:Number, _tweenIn:Boolean=true, _autoInit:Boolean=true, _autoDestoy:Boolean=true)
		{
			super(_url, _width, _height, _tweenIn, true, _autoInit, _autoDestoy);
		}
		
		override protected function build():void{
			if(!CFM_ImageManager.faceBookPoliciesLoaded)
				CFM_ImageManager.loadFacebookImagePolicies();
			
			super.build();
		}
	}
}