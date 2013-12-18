package com.cfm.core.managers
{
	import asual.SWFAddress;

	public class CFM_SWFAddressManager
	{
		private var _currentLevels:Array = [];
		
		public function CFM_SWFAddressManager()
		{
			trace("init - CFM_SWFAddressManager");
		}
		
		public function get levels():Array{return _currentLevels;}
		
		public function setLevel(_value:String, _level:Number, trim:Boolean = false):void{
			_currentLevels[_level] = _value;
			
			if(trim)
				_currentLevels.slice(0,_level-1);
			
			SWFAddress.setValue( _currentLevels.toString().replace( new RegExp(",","gs") , "/" ) );
		}
		
		public function onValueChange(_value:String):void{
			_currentLevels = _value.split("/");
			_currentLevels.shift();
		}
		
		public function get numLevels():Number{
			return _currentLevels.length;
		}
	}
}