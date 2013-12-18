package com.cfm.core.objects
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_Event;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	[Event(name="init", type="com.cfm.core.events.CFM_Event")]
	
	public class CFM_Object extends CFM_ObjectContainer
	{
		private var objectId:String;
		private var autoInit:Boolean;
		
		public function CFM_Object(_objectId:String, _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			super(_autoDestroy);
			
			objectId = _objectId;
			autoInit = _autoInit;
			
			if(autoInit){
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		public function init(e:Event):void{
			if(hasEventListener(Event.ADDED_TO_STAGE)){
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}
			
			build();
			addListeners();
			buildComplete();
			dispatchInitEvent();
		}
		
		public override function renderTo(_parent:DisplayObjectContainer, index:Number=Number.NaN):void{
			super.renderTo(_parent, index);
			if(!autoInit){
				init(null);
			}
		}
		
		protected function build():void{}
		
		protected function buildComplete():void{}
		
		protected function addListeners():void{}
		
		protected function removeListeners():void{}
		
		protected override function destroy(e:Event):void{
			removeListeners();
			//trace(objectId + "   ::::::  DESTROYED");
			super.destroy(null);
		}
		
		protected final function dispatchInitEvent():void {
			dispatchEvent(new CFM_Event(CFM_Event.INIT));
		}
	}
}