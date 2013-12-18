package com.cfm.core.templates
{
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_PageEvent;
	import com.cfm.core.interfaces.util.CFM_IResize;
	import com.cfm.core.managers.CFM_FontManager;
	import com.cfm.core.navigation.CFM_SimpleNavigation;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.text.CFM_TextField;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class CFM_PageTemplate extends CFM_Object implements CFM_IResize
	{
		protected var xml					:XML;
		protected var params				:Object;
		
		protected var content				:CFM_ObjectContainer;
		
		public var index					:Number;
		
		public var id						:String;
		
		public function CFM_PageTemplate(_index:Number, _xml:XML, _params:Object)
		{
			index = _index;
			id = _xml.@id;
			xml = _xml;
			params = _params;
			
			super("PageTemplate_" + _xml.@classname,true,true);
		}
		
		override protected function build():void{
			content = new CFM_ObjectContainer(true);
			content.setProperties({alpha:0, visible:false});
			content.renderTo(this);
			
			buildBackground();
			buildContent();
			buildComplete();
			onResize();
			
			transitionIn();
		}
		
		protected function buildBackground():void{}
		
		override protected function buildComplete():void{
			super.buildComplete();
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.BUILD_COMPLETE));
		}
		
		protected function buildContent():void{}
		
		public function initContent():void{}
		
		public function transitionIn():void{
			TweenMax.to(content, .2,{delay:.2, autoAlpha:1, onComplete:transitionInComplete, ease:Linear.easeNone});
		}
		
		public function transitionInComplete():void{
			initContent();
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.TRANSITION_IN_COMPLETE));
		}
		
		public function transitionOut(_newParams:Object):void{
			TweenMax.to(content, .2,{autoAlpha:0, onComplete:transitionOutComplete, onCompleteParams:[_newParams], ease:Linear.easeNone});
		}
		
		public function transitionOutComplete(_newParams:Object):void{
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.TRANSITION_OUT_COMPLETE,id,_newParams));
		}
		
		override protected function destroy(e:Event):void{
			super.destroy(e);
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.DESTROY_COMPLETE));
		}
		
		public function onResize():void{
			
		}
	}
}