package com.ideum.miasci 
{
	import Ui2.GlobeButtonBg;
	
	import com.ideum.miasci.AbstractDisplay;
	import com.ideum.miasci.DisplayEventInt;
	import com.ideum.miasci.LanguageEvent;
	import com.ideum.miasci.ShapeElement;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class Ui2 extends AbstractDisplay 
	{
		public var display:int = 2;
		public var module:int = 1;
		
		private var _globeAvailable:Boolean = false;
		public function get globeAvailable():Boolean { return _globeAvailable; }
		
		private var _globeControl:Boolean = true;
		public function get globeControl():Boolean { return _globeControl; }	
		
		private var _menu:int=1;
		public function get menu():int { return _menu; }
		public function set menu(v:int):void { _menu = v; }
		
		private var menuBtns:Dictionary;

		private var globeBtns:Dictionary;
		private var globeBtnsArray:Array;
		
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }		
		
		private var languageBtn:TouchSprite;
		
		private var colorTransform:ColorTransform;
		private var mainStage:Stage;
		
		public function Ui2(mStage:Stage) 
		{						
			super("ui2", "userUi2");
			
			mainStage = mStage;
			mainStage.addEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);
			
			setUpLanguageButton();	
			setUpGlobeButtons();			
			setUpCategoryBtns();
		}
		
		
		private function onTouchDown(e:TouchEvent):void
		{
			dispatchEvent(new MenuScreenActivityEvent(MenuScreenActivityEvent.ACTIVITY));	
		}
		
		public function setUpLanguageButton():void
		{
			language = "english";
			removeChild(dict['languageBg']);			
			removeChild(dict['languageText']);			
			languageBtn = new TouchSprite;
			languageBtn.addChild(dict['languageBg']);
			languageBtn.addChild(dict['languageText']);			
			languageBtn.addEventListener(TouchEvent.TOUCH_DOWN, onLanguageBtn);
			addChild(languageBtn);
		}


		public function setUpCategoryBtns():void
		{
			menu = 1;
			menuBtns = new Dictionary(true);
			
			for (var i:int=1; i<=3; i++)
			{
				menuBtns['menu'+i] = new TouchSprite;
				removeChild(dict['menu'+i]);			
				removeChild(dict['menuText'+i]);	
				menuBtns['menu'+i].addChild(dict['menu'+i]);
				menuBtns['menu'+i].addChild(dict['menuText'+i]);
				addChild(menuBtns['menu'+i]);
				menuBtns['menu'+i].blobContainerEnabled = true;
				menuBtns['menu'+i].addEventListener(TouchEvent.TOUCH_DOWN, onMenuBtns);
			}	
			dict['menu1'].showId('src2');
			
			colorTransform = new ColorTransform;		
		}
		
		
		public function removeButtonListeners():void
		{
			var i:int;
			for (i=1; i<=3; i++)
			{			
				menuBtns['menu'+i].removeEventListener(TouchEvent.TOUCH_DOWN, onMenuBtns);
			}
			for (i=1; i<=4; i++)
			{
				globeBtns['globe'+i].removeEventListener(TouchEvent.TOUCH_DOWN, onGlobeBtns);
			}				
		}
		
		
		public function addButtonListeners():void
		{
			var i:int;
			for (i=1; i<=3; i++)
			{			
				menuBtns['menu'+i].addEventListener(TouchEvent.TOUCH_DOWN, onMenuBtns);
			}
			for (i=1; i<=4; i++)
			{
				globeBtns['globe'+i].addEventListener(TouchEvent.TOUCH_DOWN, onGlobeBtns);
			}				
		}
		
		
		public function setUpGlobeButtons():void
		{
			globeBtns = new Dictionary(true);
			
			for (var i:int=1; i<=4; i++)
			{
				globeBtns['globe'+i] = new TouchSprite;

				removeChild(dict['globeTextBg'+i]);			
				removeChild(dict['globeText'+i]);
				removeChild(dict['globe'+i]);	
				
				var bg:Object = new GlobeButtonBg;
				bg.x = dict['globe'+i].x-29;
				bg.y = dict['globe'+i].y-0;
				
				globeBtns['globe'+i].addChild(dict['globeTextBg'+i]);
				globeBtns['globe'+i].addChild(dict['globeText'+i]);
				globeBtns['globe'+i].addChild(dict['globe'+i]);								
				globeBtns['globe'+i].addChild(bg);
				
				globeBtns['globe'+i].blobContainerEnabled = true;

				addChild(globeBtns['globe'+i]);
				globeBtns['globe'+i].addEventListener(TouchEvent.TOUCH_DOWN, onGlobeBtns);
			}			
		}

		
		private function onGlobeBtns(e:TouchEvent):void
		{
			var globeIndex:int;
				
			if (e.currentTarget == globeBtns['globe1'])
				globeIndex = 1;
			else if (e.currentTarget == globeBtns['globe2'])
				globeIndex = 2;
			else if (e.currentTarget == globeBtns['globe3'])
				globeIndex = 3;
			else if (e.currentTarget == globeBtns['globe4'])
				globeIndex = 4;			
			
			module = (menu-1) * 4 + globeIndex;
			
			dispatchEvent(new ModuleSelectionEvent(ModuleSelectionEvent.MODULE_SELECTION, module));	
		}
		
		
		public function onMenuBtns(e:TouchEvent):void
		{
			var menuSelection:int;
			
			if (e.currentTarget == menuBtns['menu1'])
				menuSelection = 1;
			else if (e.currentTarget == menuBtns['menu2'])
				menuSelection = 2;
			else if (e.currentTarget == menuBtns['menu3'])
				menuSelection = 3;
			
			module = 1;
			toggleMenuBtns(menuSelection);			
		}
		
		
		public function toggleMenuBtns(menuSelection:int):void
		{
			var i:int;
			
			if (menuSelection != menu)
			{				
				for (i=1; i<=4; i++)
				{				
					dict['globe'+i].showId('src'+menuSelection);
					dict['globeText'+i].showId(language+menuSelection);
				}
				dict['subHeader'].showId(language+menuSelection);
				dict['subHeaderDescription'].showId(language+menuSelection);
				menu = menuSelection;
			}			
			
			for (i=1; i<=3; i++)
			{				
				if (i == menuSelection)
				{
					colorTransform.color = script['TextLayout']['menuText1'].@color;					
					dict['menuText'+i].transform.colorTransform = colorTransform;
					dict['menu'+i].showId('src2');
				}
				else
				{
					colorTransform.color = script['TextLayout']['menuText2'].@color;
					dict['menuText'+i].transform.colorTransform = colorTransform;					
					dict['menu'+i].showId('src1');		
				}	
			}
		}
		
		private function onLanguageBtn(e:TouchEvent):void
		{
			if (language == "english")
				language = "alt";
			else 
				language = "english";
			dispatchEvent(new LanguageEvent(LanguageEvent.LANGUAGE_CHANGE, language));
			showLanguage(language);		
		}
		
		public function showLanguage(lang:String):void 
		{
			language = lang;			
			
			for each (var i:* in dict)
			{
				if (i.className == "TextLayout") {
					i.showId(language+menu);
					i.showId(language);
				}	
			}
		}

	}//class
}//package