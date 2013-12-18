package com.cfm.core.factories
{
	import com.cfm.core.containers.CFM_ObjectContainer;
	import com.cfm.core.events.CFM_PageEvent;
	import com.cfm.core.templates.CFM_PageTemplate;
	
	public class CFM_PageFactory
	{
		public var prevPage:CFM_PageTemplate;
		public var currPage:CFM_PageTemplate;
		
		protected var newPageId:String;
		protected var pageChanging:Boolean = false;
		protected var pageWaiting:String = "";
		
		protected var pageContainer:CFM_ObjectContainer;
		protected var pageList:XMLList;
			
		public function CFM_PageFactory(_pageContainer:CFM_ObjectContainer, _pageList:XMLList)
		{
			pageList = _pageList;
			pageContainer = _pageContainer;
		}
		
		public function updateList(_list:XMLList, _removePage:Boolean = false):void{
			pageList = _list;
			if(_removePage) removeCurrentPage();
		}
		
		public function removeCurrentPage(_tween:Boolean = true):void{
			if(currPage){
				prevPage = currPage;
				
				if(_tween){
					prevPage.addEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, removeCurrentPageComplete);
					prevPage.transitionOut(null);
				} else {
					removeCurrentPageComplete(null);
				}
			}
		}
		
		public function removeCurrentPageComplete(e:CFM_PageEvent):void{
			if(prevPage.hasEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE)){
				prevPage.removeEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, removeCurrentPageComplete);
			}
				
			prevPage.remove();
			prevPage = null;
			currPage = null;
		}
		
		public function changePage(_id:String, _params:Object = null):void{
			if(pageChanging){
				pageWaiting = _id; 
				return;
			}
			
			if(currPage && currPage.id == _id){
				return;
			}
			
			pageChanging = true;
			newPageId = _id;
			
			if(currPage){
				prevPage = currPage;
				prevPage.addEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, pageOutComplete);
				prevPage.transitionOut(_params);
				
				newPage(_params);
			} else {
				newPage(_params);
			}
		}
		
		public function nextPage():void{
			var newIndex:Number = currPage ? (currPage.index+1) : 0;
			if (newIndex > pageList.length()-1) newIndex = 0;
			
			changePage(pageList[newIndex].@id);
		}
		
		public function previousPage():void{
			var newIndex:Number = currPage ? currPage.index-1 : pageList.length()-1;
			if (newIndex < 0) newIndex = pageList.length()-1;
			
			changePage(pageList[newIndex].@id);
		}
		
		protected function pageOutComplete(e:CFM_PageEvent):void{
			var page:CFM_PageTemplate = e.currentTarget as CFM_PageTemplate;
			
			page.removeEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, pageOutComplete);
			page.addEventListener(CFM_PageEvent.DESTROY_COMPLETE, destroyPageComplete);
			page.remove();
		}
		
		public function initCurrentPageContent():void{
			try{
				currPage.initContent();
			} catch(e:Error){
				trace(e);
			}
		}
		
		protected function destroyPageComplete(e:CFM_PageEvent):void{
		}
		
		protected function newPage(_params:Object = null):void{			
			var pxml:XML = pageList.(@id == newPageId)[0];
			var index:Number = pxml.childIndex();
			
			currPage = getPage(index, pxml, _params);
			currPage.addEventListener(CFM_PageEvent.TRANSITION_IN_COMPLETE, buildPageComplete);
			currPage.renderTo(pageContainer);
		}
		
		protected function getPage(_index:Number, _pxml:XML, _params:Object):CFM_PageTemplate{
			return new CFM_PageTemplate(_index, _pxml, _params);
		}
		
		private function buildPageComplete(e:CFM_PageEvent):void{
			currPage.removeEventListener(CFM_PageEvent.TRANSITION_IN_COMPLETE, buildPageComplete);
			pageChanging = false;
			
			if(pageWaiting != ""){
				changePage(pageWaiting);
				pageWaiting = "";
			}
		}
	}
}