package com.cfm.core.ui
{	
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_ButtonEvent;
	import com.cfm.core.events.CFM_DropdownMenuEvent;
	import com.cfm.core.events.CFM_NavigationEvent;
	import com.cfm.core.graphics.CFM_Graphics;
	import com.cfm.core.navigation.CFM_SimpleNavigation;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.vo.CFM_GraphicsParams;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.events.Event;
	
	public class CFM_DropdownMenu extends CFM_Object
	{
		public var ITEM_SPACING:Number = 23;
		public var ITEM_HOLDER_MARGIN:Number = 2;
		public var NAVIGATION_SPACING:Number = 10;
		
		public var navigationList:XMLList;
		public var buttonXML:XML;
		
		public var itemHolder:CFM_ObjectContainer;
		public var itemHolderMask:CFM_Graphics;
		public var navigations:Array = [];
		
		public var button:CFM_SimpleButton;
		public var navigation:CFM_SimpleNavigation;
		public var menuOpen:Boolean = false;
		public var currentSelection:String;
		
		public var index:Number;
		public var value:String;
		public var id:String;
		public var _offsetHeight:Number = 0;
		
		public function CFM_DropdownMenu(_index:Number, _buttonXML:XML, _id:String, _value:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{			
			index = _index;
			navigationList = _navigationList;
			buttonXML = _buttonXML;
			currentSelection = buttonXML.label;
			id = _id;
			value = _value;
			
			super("CFM_DropdownMenu",_autoInit,_autoDestroy);
		}
		
		override protected function build():void{				
			button = getButton();
			button.renderTo(this);
			
			itemHolder = new CFM_ObjectContainer();
			itemHolder.renderTo(this);
			
			itemHolderMask = new CFM_Graphics(new CFM_GraphicsParams({width:10,height:10, colors:[0], alphas:[0]}));
			itemHolderMask.renderTo(this);
			
			itemHolder.mask = itemHolderMask;
			
			buildNavigations();
			
			itemHolder.setProperties({alpha:0, visible:false, y:button.hitHeight + ITEM_HOLDER_MARGIN});
			
			itemHolderMask.setProperties({scaleY:0, y:itemHolder.y});
		}
		
		public function get offsetHeight():Number{
			return _offsetHeight;
		}
		
		public function buildNavigations():void{
			var i:Number = 0;
			for each(var n:XML in navigationList){
				navigation = getNavigation(n.button);
				navigation.renderTo(itemHolder);
				navigation.setProperties({x:i>0 ? (navigations[i-1].x + navigations[i-1].width + NAVIGATION_SPACING) : 0});
				navigations.push(navigation);
				i++
			}
			
			itemHolderMask.redraw(itemHolder.x + itemHolder.width, itemHolder.height + ITEM_HOLDER_MARGIN,0,0);
			_offsetHeight = itemHolder.height + ITEM_HOLDER_MARGIN;
		}
		
		public function deselectAllItems(_exceptNavIndex:Number = -1, _exceptButtonIndex:Number = -1):void{
			for each(var n:CFM_SimpleNavigation in navigations)
				if(_exceptNavIndex != navigations.indexOf(n))
					n.deselectAll();
				else 
					n.deselectAll( _exceptButtonIndex );
		}
		
		protected function getButton():CFM_SimpleButton{
			return new CFM_SimpleButton(0,buttonXML.@id,buttonXML.@value,buttonXML.label,4,4,true,true,"") as CFM_SimpleButton;
		}
		
		protected function getNavigation(_buttonList:XMLList):CFM_SimpleNavigation{
			return new CFM_SimpleNavigation(_buttonList,false,false,"left") as CFM_SimpleNavigation;
		}
		
		override protected function addListeners():void{
			super.addListeners();
			
			for each(var n:CFM_SimpleNavigation in navigations)
				n.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, itemSelected, false, 0, true);
			
			button.addEventListener(CFM_ButtonEvent.BUTTON_CLICKED, buttonSelected, false, 0, true);
		}
		
		public function openMenu():void{
			menuOpen = true;
			
			TweenMax.to(itemHolder, 0, {autoAlpha:1});
			TweenMax.to(itemHolderMask, .4, {scaleY:1, ease:Cubic.easeInOut});
			
			dispatchEvent(new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.OPEN_MENU, index, value, NaN, currentSelection));
		}
		
		public function closeMenu(_dispatch:Boolean = true):void{
			menuOpen = false;
			
			button.deselect();
			
			TweenMax.to(itemHolder, 0, {delay:.4, autoAlpha:0});
			TweenMax.to(itemHolderMask, .4, {scaleY:0,  ease:Cubic.easeInOut});
			
			if(_dispatch) dispatchEvent(new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.CLOSE_MENU, index, value, NaN, currentSelection ));
		}
		
		public function buttonSelected(e:CFM_ButtonEvent):void{
			killTweens();

			menuOpen ? closeMenu() : openMenu();
		}
		
		public function reset():void{
			killTweens();
			currentSelection = null;
			button.updateLabel("",false);
			
			closeMenu(true);
		}
		
		public function itemSelected(e:CFM_NavigationEvent):void{
			killTweens();
			deselectAllItems(navigations.indexOf( CFM_SimpleNavigation(e.currentTarget) ), e.index);
			dispatchEvent( new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.ITEM_SELECTED, index, value, e.index, e.value));
		}
		
		public function updateSelection(_value:String):void{
			currentSelection = _value;
			button.updateLabel(_value,false);
		}

		public function killTweens():void{
			TweenMax.killTweensOf(itemHolder);
			TweenMax.killTweensOf(itemHolderMask);
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			
			for each(var n:CFM_SimpleNavigation in navigations)
				n.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, itemSelected);
			
			button.removeEventListener(CFM_ButtonEvent.BUTTON_CLICKED, buttonSelected);
		}
		
		private function get itemLabelParams():Object{
			return {};
		}
		
		private function get buttonLabelParams():Object{
			return {};
		}
		
		override protected function destroy(e:Event):void{
			killTweens();
			
			while(itemHolder.numChildren>0){
				itemHolder.removeChildAt(0);
			}
			
			super.destroy(e);
		}
	}
}