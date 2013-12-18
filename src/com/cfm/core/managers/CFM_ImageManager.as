package com.cfm.core.managers
{
	import flash.display.Bitmap;
	import flash.system.Security;
	
	public class CFM_ImageManager
	{
		public static var LOADED_IMAGES_ARRAY:Array = [];
		public static var POLICY_DOMAINS:Array = [];
		public static var faceBookPoliciesLoaded:Boolean = false;
		
		public static function getLoadedBitmap(url:String, wdth:Number=0, hght:Number=0):Bitmap{
			var bt:Bitmap;
			
			for each(var bm:Object in LOADED_IMAGES_ARRAY){
				if(bm.url == url){
					bt = new Bitmap(Bitmap(bm.bmp).bitmapData);
					
					if(wdth > 0){
						bt.width = wdth;
						bt.height = wdth/bm.ar;
					}
					
					if(hght>0){
						if(bt.height<hght || wdth == 0){
							bt.height = hght;
							bt.width = hght*bm.ar;
						}
					}
				}
			}
			
			return bt;
		}
		
		public static function isAlreadyLoaded(_url:String):Boolean{
			var alreadyLoaded:Boolean = false;
			
			for each(var al:Object in CFM_ImageManager.LOADED_IMAGES_ARRAY)
				if(al.url == _url)
					alreadyLoaded = true;
			
			return alreadyLoaded;
		}
		
		public static function loadDomainPolicy(__url:String):void{
			var domain:String = __url.substring( 0 , __url.indexOf( "/", 10 ) + 1 );
			
			if(POLICY_DOMAINS.indexOf(domain) == -1){
				POLICY_DOMAINS.push(domain);
				Security.loadPolicyFile(domain + "crossdomain.xml");
				trace("loading policy :: " + domain + "crossdomain.xml");
			} 
		}
		
		public static function loadFacebookImagePolicies():void{
			var profileDomain:String = "http://profile.ak.fbcdn.net/";
			
			if(POLICY_DOMAINS.indexOf(profileDomain) == -1){
				POLICY_DOMAINS.push(profileDomain);
				Security.loadPolicyFile(profileDomain + "crossdomain.xml");
				trace("loading policy :: " + profileDomain + "crossdomain.xml");
			}
			
			for ( var i:Number = "a".charCodeAt(); i <= "z".charCodeAt(); i++) {
				var domain:String = "http://photos-" + String.fromCharCode(i) + ".ak.fbcdn.net/";
				
				if(CFM_ImageManager.POLICY_DOMAINS.indexOf(domain) == -1){
					CFM_ImageManager.POLICY_DOMAINS.push(domain);
					Security.loadPolicyFile(domain + "crossdomain.xml");
					trace("loading policy :: " + domain + "crossdomain.xml");
				} 
			}
		}
	}
}