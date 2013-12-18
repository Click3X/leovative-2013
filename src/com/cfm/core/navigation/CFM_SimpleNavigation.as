package com.cfm.core.navigation 
{
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_ButtonEvent;
	import com.cfm.core.events.CFM_NavigationEvent;
	import com.cfm.core.interfaces.navigation.CFM_INavigation;
	import com.cfm.core.objects.CFM_Object;
	
	[Event(name="buttonClicked", type="com.cfm.core.events.CFM_NavigationEvent")]
	
	public class CFM_SimpleNavigation extends CFM_Object implements CFM_INavigation
	{
		protected var list					:XMLList;
		protected var buttonParams			:Object;
		protected var _buttonContainer		:CFM_ObjectContainer;
		protected var allowToggle			:Boolean;
		protected var hasSelectedState		:Boolean;
		protected var maxWidth				:Number = 0;
		protected var buttonSpacing			:Number = 4;
		protected var buttonsArray			:Array = [];
		protected var lastSelected			:CFM_SimpleButton;
		protected var verticalAlign			:String;
		
		public function CFM_SimpleNavigation(_list:XMLList, _allowToggle:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String = null, _autoInit:Boolean = true,_autoDestroy:Boolean = true)
		{
			super("CFM_Navigation", _autoInit, _autoDestroy);
			
			list 							= _list;
			allowToggle 					= _allowToggle;
			hasSelectedState 				= _allowToggle ? true : _hasSelectedState;
			verticalAlign 					= _verticalAlign;
		}
		
		protected override function build():void{
			_buttonContainer = new CFM_ObjectContainer();
			_buttonContainer.renderTo(this);
			
			var i:Number = 0;
			
			for each(var bs:XML in list){
				var btn:CFM_SimpleButton = buildButton(i,bs);
				btn.renderTo(buttonContainer);
				buttonsArray.push(btn);
				i++;
			}
			
			if(verticalAlign != null)
				positionVertical();
			else
				positionHorizontal();
		}
		
		protected function positionHorizontal():void{
			var i:Number = 0;
			
			for each(var b:CFM_SimpleButton in buttonsArray){
				var newY:Number = i>0 ? buttonsArray[i-1].y : 0;
				var newX:Number = i>0 ? buttonsArray[i-1].x + buttonsArray[i-1].width + buttonSpacing : 0;;
				
				if( maxWidth > 0 && (newX + b.width > maxWidth) ){
					newX = 0;
					newY = i>0 ? (buttonsArray[i-1].y + buttonsArray[i-1].height + buttonSpacing) : 0;
				}
						
				b.setProperties({x:newX, y:newY});
			
				i++;
			}
		}
		
		protected function positionVertical():void{
			for each(var b:CFM_SimpleButton in buttonsArray){
				var newY:Number = 0;
				var newX:Number = 0;
				
				newY = Math.round(buttonContainer.getChildIndex(b)*(b.height + buttonSpacing));
				
				switch(verticalAlign){
					case "center":
						newX = -b.width/2;
						break;
					case "right":
						newX = -b.width;
						break
				}
				
				b.setProperties({x:newX, y:newY});
			}
		}
		
		override protected function addListeners():void{
			for each(var b:CFM_SimpleButton in buttonsArray)
				b.addEventListener(CFM_ButtonEvent.BUTTON_CLICKED, buttonClicked, false, 0, true);
		}
		
		override protected function removeListeners():void{
			for each(var b:CFM_SimpleButton in buttonsArray)
				b.removeEventListener(CFM_ButtonEvent.BUTTON_CLICKED, buttonClicked);
		}
		
		protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new CFM_SimpleButton(_i,_tag.@id,_tag.@value,_tag.label,4,4,allowToggle,hasSelectedState);
		}
		
		protected function buttonClicked(e:CFM_ButtonEvent):void{
			if(lastSelected && hasSelectedState)
				if(!allowToggle) lastSelected.deselect();
			
			lastSelected = CFM_SimpleButton(e.currentTarget);
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_CLICKED,e.index, e.id, e.value));
		}
		
		public function deselectAll(except:Number = -1):void{
			var i:Number = 0;
			
			for each(var b:CFM_SimpleButton in buttonsArray){
				if(i!=except)
					b.deselect();
				
				i++;
			}
			
			if(except == -1) lastSelected = null;
		}
		
		protected function getButtonValue(_id:String):String{
			return list[getIndexById(_id)].@value;
		}
		
		protected function getIndexById(_id:String):Number{
			var id:Number;
			var i:Number = 0;
			
			for each(var x:XML in list){
				if(x.@id == _id)
					id = i;
					
				i++;
			}
			
			return id;
		}
		
		public function disableButtonByIndex(_index:Number):void{
			if(buttonsArray[_index]) buttonsArray[_index].deActivate();
		}
		
		public function enableButtonByIndex(_index:Number):void{
			if(buttonsArray[_index]) buttonsArray[_index].activate();
		}
		
		public function disableButtonById(_id:String):void{
			var index:Number = getIndexById(_id);
			if(index>=0) buttonsArray[index].deActivate();			
		}
		
		public function enableButtonById(_id:String):void{
			var index:Number = getIndexById(_id);
			if(index>=0) buttonsArray[index].activate();			
		}
		
		public function getButtonLabelText(_id:String):void{
			CFM_SimpleButton(buttonsArray[getIndexById(_id)]).labelText;
		}
		
		public function selectButtonById(_id:String, _dispatch:Boolean = false):void{
			var index:Number = getIndexById(_id);
			
			if(buttonsArray[index] != lastSelected){
				selectButton(index,_dispatch);
			}
		}
		
		public function changeButtonLabelById(_id:String, _label:String, updateSize:Boolean = true):void{
			var index:Number = getIndexById(_id);
			CFM_SimpleButton(buttonsArray[index]).updateLabel(_label, updateSize);
		}
		
		public function resetButtonLabelById(_id:String):void{
			var index:Number = getIndexById(_id);
			CFM_SimpleButton(buttonsArray[index]).resetLabel();
		}
		
		public function selectButton(_childIndex:Number, _dispatch:Boolean = false):void{
			deselectAll(_childIndex);
			
			var btn:CFM_SimpleButton = buttonsArray[_childIndex];
			if(btn){
				btn.select(_dispatch);
				lastSelected = btn;
			}
		}
		
		private function get widestButtonWidth():Number{
			var widestWidth:Number = 0;
			
			for each(var b:CFM_SimpleButton in buttonsArray)
				if(b.width > widestWidth)
					widestWidth = b.width;
			
			return widestWidth;
		}
		
		private function get farRightButton():CFM_SimpleButton{
			var greatestX:Number = -100000;
			var fbtn:CFM_SimpleButton;
			
			for each(var b:CFM_SimpleButton in buttonsArray)
				if(b.x > greatestX){
					greatestX = b.x;
					fbtn = b;
				}
			
			return fbtn;
		}
		
		private function get lastButton():CFM_SimpleButton{
			return CFM_SimpleButton(buttonsArray[buttonsArray.length-1]);
		}
		
		override public function get width():Number{
			if(verticalAlign != null)
				return widestButtonWidth;
			else
				return farRightButton.x + farRightButton.width;
		}
		
		override public function get height():Number{
			return lastButton.y + lastButton.height;
		}
		
		public function get buttonContainer():CFM_ObjectContainer{
			return _buttonContainer;
		}
	}
}