package com.cfm.core.ui
{	
	import com.cfm.core.buttons.CFM_SimpleButton;
	import com.cfm.core.events.CFM_AccordionMenuEvent;
	import com.cfm.core.events.CFM_DropdownMenuEvent;
	import com.cfm.core.objects.CFM_Object;
	import com.cfm.core.ui.CFM_DropdownMenu;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	public class CFM_AccordionMenu extends com.cfm.core.objects.CFM_Object
	{
		private var menuList:XMLList;
		public var index:Number;
		public var menu:CFM_DropdownMenu;
		private var menuArray:Array = [];
		
		public var MENU_SPACING:Number = 4;
		public var MENU_MARGIN_BOTTOM:Number = 10;
		
		public function CFM_AccordionMenu(_index:Number, _menuList:XMLList)
		{
			index = _index;
			menuList = _menuList;
			
			super("MenuPanel_" + index.toString() , true, true);
		}
		
		public function resetAll():void{
			for each(var mo:Object in menuArray)
				CFM_DropdownMenu(mo.menu).reset();
		}
		
		override protected function build():void{
			for each(var m:XML in menuList){
				var menuIndex:Number = m.childIndex();
				menu = buildDropDownMenu(menuIndex,m.button[0], m.@id, m.@value, m.navigation );
				menu.renderTo(this);
				menu.setProperties({y:menuIndex>0 ? MENU_SPACING + menuArray[menuIndex-1].menu.y + CFM_DropdownMenu(menuArray[menuIndex-1].menu).button.hitHeight  :0});
				menuArray.push({menu:menu, startY:menu.y});
			}
		}
		
		protected function buildDropDownMenu(_index:Number, _buttonXML:XML, _id:String, _value:String, _navigationList:XMLList):CFM_DropdownMenu{
			return new CFM_DropdownMenu(_index, _buttonXML, _id, _value, _navigationList );
		}
		
		override protected function addListeners():void{
			for each(var mo:Object in menuArray){
				mo.menu.addEventListener(CFM_DropdownMenuEvent.ITEM_SELECTED, menuItemSelected, false, 0, true);
				mo.menu.addEventListener(CFM_DropdownMenuEvent.OPEN_MENU, openMenu, false, 0, true);
				mo.menu.addEventListener(CFM_DropdownMenuEvent.CLOSE_MENU, closeMenu, false, 0, true);
			}
		}
		
		override protected function removeListeners():void{
			for each(var mo:Object in menuArray){
				mo.menu.removeEventListener(CFM_DropdownMenuEvent.ITEM_SELECTED, menuItemSelected);
				mo.menu.removeEventListener(CFM_DropdownMenuEvent.OPEN_MENU, openMenu);
				mo.menu.removeEventListener(CFM_DropdownMenuEvent.CLOSE_MENU, closeMenu);
			}
		}
		
		private function menuItemSelected(e:CFM_DropdownMenuEvent):void{
			dispatchEvent(new CFM_AccordionMenuEvent(CFM_AccordionMenuEvent.ITEM_SELECTED, index, e.menuIndex, e.menuValue, e.itemIndex, e.itemValue));
		}
		
		private function closeMenu(e:CFM_DropdownMenuEvent):void{
			for each(var m:Object in menuArray)
				TweenMax.to(m.menu, .4, {y:m.startY, ease:Cubic.easeInOut});
		}
		
		public function deactivate():void{
			for each(var m:Object in menuArray)
				CFM_DropdownMenu(m.menu).closeMenu(false);
			
			closeMenu(null);
		}
		
		private function openMenu(e:CFM_DropdownMenuEvent):void{
			for each(var mo:Object in menuArray){
				var menuIndex:Number = mo.menu.index;
				var yOffset:Number = CFM_DropdownMenu(e.currentTarget).offsetHeight + MENU_MARGIN_BOTTOM;
				var newY:Number;
				
				if(menuIndex != e.menuIndex){
					mo.menu.closeMenu(false);
				}
					
				if(menuIndex > e.menuIndex)
					newY = mo.startY + yOffset;
				else
					newY = mo.startY;
				
				TweenMax.to(mo.menu, .4, {y:newY, ease:Cubic.easeInOut});
			}
			
			dispatchEvent(new CFM_AccordionMenuEvent(CFM_AccordionMenuEvent.PANEL_ACTIVE, index, 0,null,NaN,null));
		}
	}
}