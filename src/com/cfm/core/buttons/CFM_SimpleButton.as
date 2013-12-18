package com.cfm.core.buttons
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_ButtonEvent;
	import com.cfm.core.graphics.CFM_Graphics;
	import com.cfm.core.interfaces.buttons.CFM_IButton;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.text.CFM_TextField;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.cfm.core.vo.CFM_TextFieldParams;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	[Event(name="buttonClicked", type="com.cfm.core.events.CFM_ButtonEvent")]
	
	public class CFM_SimpleButton extends CFM_Object implements CFM_IButton
	{
		protected var container						:CFM_ObjectContainer;
		protected var backgroundContainer			:CFM_ObjectContainer;
		protected var labelContainer				:CFM_ObjectContainer;
		
		protected var selected						:Boolean = false;
		
		protected var selectState					:Boolean;
		protected var toggle						:Boolean;
		protected var _disabled						:Boolean;

		protected var background					:CFM_Graphics;
		protected var hit							:CFM_Graphics;
		protected var label							:CFM_TextField;
		
		protected var paddingH						:Number;
		protected var paddingV						:Number;
		protected var buttonIndex					:Number;
		protected var _hitWidth						:Number;
		protected var _hitHeight						:Number;
		
		protected var buttonId						:String;
		protected var buttonValue					:String;
		protected var href							:String;
		
		protected var __labelText					:String;
		
		public function CFM_SimpleButton(_index:Number,_id:String,_value:String,_labelText:String,_paddingH:Number = 4,_paddingV:Number = 4,_toggle:Boolean = false,_selectState:Boolean = true,_href:String=null,_autoInit:Boolean=true,_autoDestroy:Boolean=true)
		{
			super("CFM_SimpleButton",_autoInit,_autoDestroy);
			
			buttonIndex 							= _index;
			buttonId 								= _id;
			buttonValue 							= _value;
			paddingH 								= _paddingH;
			paddingV 								= _paddingV;
			toggle 									= _toggle;
			selectState 							= _toggle ? true : _selectState;
			href 									= _href;
			
			__labelText 							= _labelText;
		}
		
		override protected function build():void{
			buildContainers();
			buildBackground();
			buildLabel();
			buildHit();
		}
		
		override protected function addListeners():void{
			hit.buttonMode = true;
			hit.mouseChildren = true;
			
			if(!hit.hasEventListener(MouseEvent.MOUSE_DOWN))
				hit.addEventListener(MouseEvent.MOUSE_DOWN, clicked, false, 0, true);
			
			if(!hit.hasEventListener(MouseEvent.MOUSE_OVER))
				hit.addEventListener(MouseEvent.MOUSE_OVER, over, false, 0, true);
			
			if(!hit.hasEventListener(MouseEvent.MOUSE_OUT))
				hit.addEventListener(MouseEvent.MOUSE_OUT, out, false, 0, true);
		}
		
		override protected function removeListeners():void{	
			hit.buttonMode = false;
			hit.mouseChildren = false;
			
			if(hit.hasEventListener(MouseEvent.MOUSE_DOWN))
				hit.removeEventListener(MouseEvent.MOUSE_DOWN, clicked);
			
			if(hit.hasEventListener(MouseEvent.MOUSE_OVER))
				hit.removeEventListener(MouseEvent.MOUSE_OVER, over);
			
			if(hit.hasEventListener(MouseEvent.MOUSE_OUT))
				hit.removeEventListener(MouseEvent.MOUSE_OUT, out);		
		}
		
		override public function get width():Number{return _hitWidth;}
		override public function get height():Number{return _hitHeight;}
		
		protected function buildContainers():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			
			backgroundContainer = new CFM_ObjectContainer();
			backgroundContainer.renderTo(container);
			
			labelContainer = new CFM_ObjectContainer();
			labelContainer.renderTo(container);
			labelContainer.setProperties({x:paddingH, y:paddingV});
		}
		
		protected function buildBackground():void{
			background = new CFM_Graphics( backgroundParams );
			background.renderTo(backgroundContainer);
		}
		
		protected function buildLabel():void{			
			label = new CFM_TextField(__labelText, labelParams);
			label.renderTo(labelContainer);
		}
		
		protected function get labelParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({size:14, color:0x333333});
		}
		
		protected function get backgroundParams():CFM_GraphicsParams{
			return new CFM_GraphicsParams();
		}
		
		protected function setHitDimensions():void{
			_hitWidth = int(labelContainer.width + (paddingH*2));
			_hitHeight = int(labelContainer.height + (paddingV*2));
		}
		
		protected function buildHit():void{
			hit = new CFM_Graphics(new CFM_GraphicsParams({colors:[0xFFFFFF]}));
			hit.renderTo(container);
			hit.setProperties({buttonMode:true, alpha:0});
		}
		
		override protected function buildComplete():void{
			setHitDimensions();
			resizeGraphics();
			
			toOutState(false);
		}
		
		protected function resizeGraphics():void{
			if(background) background.redraw(_hitWidth, _hitHeight,background.params.x,background.params.y);
			if(hit) hit.redraw(_hitWidth, _hitHeight,hit.params.x,hit.params.y);
		}
		
		private function over(e:MouseEvent):void{
			toOverState();
		}
		
		private function out(e:MouseEvent):void{
			toOutState();
		}
		
		protected function clicked(e:MouseEvent):void{
			if(href && href != ""){
				openLink();
			} else {
				if(!selected)
					 select();
				else 
					deselect();
			}
			
			dispatchSelected();
		}
		
		protected function openLink():void{
			navigateToURL(new URLRequest(href), "_blank");
		}
		
		protected function dispatchSelected():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.BUTTON_CLICKED, buttonIndex, buttonId, buttonValue, labelText, selected));
		}
		
		protected function toOverState():void{
			killTweens();
			TweenMax.to(labelContainer, .2, {tint:0xFFFFFF, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, .2, {alpha:1, ease:Linear.easeNone});
		}
		
		protected function toOutState(_tween:Boolean = true):void{
			killTweens();
			TweenMax.to(labelContainer, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, _tween ? .2 : 0, {alpha:.1, ease:Linear.easeNone});
		}
		
		protected function toSelectedState():void{
			toOverState();
		}
		
		protected function toUnselectedState():void{
			toOutState();
		}
		
		protected function disableOverOut():void{
			if(hit.hasEventListener(MouseEvent.MOUSE_OVER))
				hit.removeEventListener(MouseEvent.MOUSE_OVER, over);
			
			if(hit.hasEventListener(MouseEvent.MOUSE_OUT))
				hit.removeEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		protected function killTweens():void{
			TweenMax.killTweensOf(labelContainer);
			TweenMax.killTweensOf(backgroundContainer);
		}
		
		public function select(_dispatch:Boolean = false):void{
			if(selectState){
				selected = true;
				toSelectedState();
				
				if(!toggle){
					disable();
				}
			}
			
			if(_dispatch)
				dispatchSelected();
		}
		
		public function deselect():void{
			if(selectState){
				selected = false;
				toUnselectedState();
				
				if(!toggle){
					enable();
				}
			}
		}
		
		public function updateLabel(_newLabel:String, updateSize:Boolean = true):void{
			label.text = _newLabel;
			
			if(updateSize){
				setHitDimensions();
				resizeGraphics();
			}
		}
		
		public function resetLabel(updateSize:Boolean = true):void{
			label.text = __labelText;
			
			if(updateSize){
				setHitDimensions();
				resizeGraphics();
			}
		}
	
		public function enable():void{
			if(_disabled){
				_disabled = false;
				addListeners();
			}
		}
		
		public function disable():void{
			if(!_disabled){
				_disabled = true;
				removeListeners();
			}
		}
		
		public function get labelText():String{return __labelText;}
		public function get disabled():Boolean{return _disabled;}
		public function get hitHeight():Number{return _hitHeight;}
		public function get hitWidth():Number{return _hitWidth;}
		
	}
}