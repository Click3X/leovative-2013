package com.cfm.core.containers
{
	import com.cfm.core.events.CFM_Event;
	import com.cfm.core.interfaces.util.CFM_IResize;
	import com.cfm.core.managers.CFM_ResizeManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="destroy", type="com.cfm.core.events.CFM_Event")]
	
	public class CFM_ObjectContainer extends Sprite
	{
		private var autoDestroy:Boolean;
		
		public function CFM_ObjectContainer(_autoDestroy:Boolean = true)
		{
			autoDestroy = _autoDestroy;
			
			if(autoDestroy)
				addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		public function renderTo(_parent:DisplayObjectContainer, index:Number = Number.NaN):void{
			(isNaN(index))?_parent.addChild(this):_parent.addChildAt(this, int(index));
			
			if(this is CFM_IResize) 
				CFM_ResizeManager.addToResizeQue(this as CFM_IResize);
		}
		
		public function remove():void{
			if(!autoDestroy)
				destroy(null);
			
			this.parent.removeChild(this);
		}
		
		public function setProperties(_prop:Object):void{
			for (var p:String in _prop){
				if(p=="x" || p=="y" || p=="width" || p=="height")
					this[p] = Math.round(_prop[p]); 
				else
					this[p] = _prop[p]; 
			}
		}
		
		protected function removeChildren():void{
			while(numChildren>0){
				var c:* = getChildAt(0);
				
				if(c is CFM_ObjectContainer)
					CFM_ObjectContainer(c).remove();
				else
					removeChild(c);
					
				c = null;
			}
		}
		
		protected function destroy(e:Event):void{
			if(hasEventListener(Event.REMOVED_FROM_STAGE))
				removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if(this is CFM_IResize)
				CFM_ResizeManager.removeFromResizeQue(this as CFM_IResize);
			
			removeChildren();
			dispatchDestroyEvent();
		}
		
		protected final function dispatchDestroyEvent():void {
			dispatchEvent(new CFM_Event(CFM_Event.DESTROY));
		}
	}
}