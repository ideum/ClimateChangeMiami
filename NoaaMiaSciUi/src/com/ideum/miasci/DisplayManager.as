package com.ideum.miasci
{	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class DisplayManager extends TouchSprite
	{
		public var clientId:String;		
		public var display:int = 1;
		public var module:int = 1;
		public var content:int = 1;		
		public var globeAvailable:Boolean = true;
		public var globeControl:Boolean = false;
		public var globeRequest:Boolean = false;
		public var globeRequestMade:Boolean = false;
		
		private var mainStage:Stage;				
		
		private var ui1:Ui1;
		private var ui2:Ui2;
		private var ui3:Ui3;
		private var ui4:Ui4;
		private var uiDictionary:Dictionary;
		
		private var language:String = "english";
		
		private var globeControlTimer:Timer;
		private var globeControlTime:int = 45;
		
		private var menuTimer:Timer;
		private var menuTime:int = 20;
		
		private var menuButtonDelayTimer:Timer;
		private var menuButtonDelay:int = 1000;
		
		private var contentTimer:Timer;
		private var contentTime:int = 20;
		
		private var editMode:Boolean = false;
		private var defaultScreen:String;
		
		public function DisplayManager(mStage:Stage)
		{
			super();
			mainStage = mStage
			
			//create ui screens
			ui1 = new Ui1(mainStage);
			ui2 = new Ui2(mainStage);
			ui3 = new Ui3(mainStage);
			ui4 = new Ui4(mainStage);
			uiDictionary = new Dictionary();
			uiDictionary['ui1'] = ui1; 
			uiDictionary['ui2'] = ui2; 
			uiDictionary['ui3'] = ui3; 
			uiDictionary['ui4'] = ui4; 
			
			//load xml settings
			menuTime = Settings.getInstance('global').data.timers.@menu;			
			globeControlTime = Settings.getInstance('global').data.timers.@globe;
			contentTime = Settings.getInstance('global').data.timers.@content;
			ui1.logoTimerInterval = int(Settings.getInstance('global').data.timers.@caption) * 1000;
			ui1.instructionTimerInterval = int(Settings.getInstance('global').data.timers.@instruction) * 1000;
			ui1.instructionPulseOn = (Settings.getInstance('global').data.instructionPulse.@on == "true") ? true : false;			
			ui1.instructionPulseInterval = Settings.getInstance('global').data.instructionPulse.@interval;
			ui3.spinTimerInterval = Settings.getInstance('global').data.globeRotation.@speed;			
			ui3.spinInc = Settings.getInstance('global').data.globeRotation.@increment;
			ui3.timeBlinkOn = (Settings.getInstance('global').data.countdownBlink.@on == "true") ? true : false;			
			ui3.timeBlinkInterval = Settings.getInstance('global').data.countdownBlink.@interval;
			ui3.timeBlinkThreshold = Settings.getInstance('global').data.countdownBlink.@threshold;			
			ui4.contentCycleInterval = Settings.getInstance('global').data.timers.@contentCycle;
			ui4.timeBlinkOn = (Settings.getInstance('global').data.countdownBlink.@on == "true") ? true : false;			
			ui4.timeBlinkInterval = Settings.getInstance('global').data.countdownBlink.@interval;
			ui4.timeBlinkThreshold = Settings.getInstance('global').data.countdownBlink.@threshold;
			ui4.timeBlinkThreshold = Settings.getInstance('global').data.countdownBlink.@threshold;			
			editMode = (Settings.getInstance('global').data.editMode.@on == "true") ? true : false;
			
			//create menu Timer
			menuTimer = new Timer(1000, menuTime);
			menuTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onMenuTimerEnd);			
			
			menuButtonDelayTimer = new Timer(menuButtonDelay, 1);
			menuButtonDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onMenuButtonDelayTimer);
			
			//create globe timer
			globeControlTimer = new Timer(1000, globeControlTime);
			globeControlTimer.addEventListener(TimerEvent.TIMER, onTimer);			
			globeControlTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGlobeControlTimerEnd);

			//create content Timer
			contentTimer = new Timer(contentTime*1000, 1);
			
			//edit mode
			if (editMode)
			{	
				mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;				
				mainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				ui3.setUpMenuButton();
			}
			//presentation mode
			else
			{
				Mouse.hide();										
				mainStage.displayState = StageDisplayState.FULL_SCREEN;
			}
			
			//load default screen
			show(ui1);			
		}
		
		
		private function show(ui:TouchSprite):void 
		{			
			if (ui == ui1)
			{
				display = 1;
			
				ui1.resetDiagram();
				ui1.showInstruction();			
				ui1.showLanguage("english");
				ui1.addEventListener(NewSessionEvent.NEW_SESSION, onNewSession);
				
				if (!ui1.globeAvailable){
					menuTimer.reset();
					menuTimer.start();
				}
			}
				
			else if (ui == ui2) 
			{
				display = 2;
				
				menuTimer.reset();
				menuTimer.start();	
				
				globeRequest = false;
				ui4.globeRequest = false;
				
				ui2.removeButtonListeners();
				
				menuButtonDelayTimer.start();
				
				ui2.toggleMenuBtns(ui1.selection);
				ui2.showLanguage(ui1.language);
				
				ui2.addEventListener(MenuScreenActivityEvent.ACTIVITY, onMenuScreenActivity);
				ui2.addEventListener(ModuleSelectionEvent.MODULE_SELECTION, onModuleSelection);
				ui2.addEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
								
			}	
				
			else if (ui == ui3)			
			{
				display = 3;
				
				menuTimer.stop();
				
				updateGlobeControlTime(globeControlTime);
				globeControlTimer.reset();
				globeControlTimer.start();					
				
				ui3.stopBlinkTimer();
				ui3.showView(module);
				
				ui3.addEventListener(GlobeRotateEvent.ROTATE, onRotate);				
				ui3.addEventListener(ControlBarEvent.CONTROL_BUTTON, onControlBtn);
				ui3.addEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
				ui3.addEventListener(MenuEvent.MENU_RETURN, onMenuReturn);
			}
				
			else if (ui == ui4)
			{
				display = 4;			
				
				menuTimer.stop();
				
				ui1.globeAvailable = false;	
					
				updateGlobeControlTime(globeControlTime);
				globeControlTimer.reset();
				globeControlTimer.start();

				contentTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onContentTimeEnd);		
				contentTimer.reset();				
				contentTimer.start();
				
				ui4.stopBlinkTimer();				
				ui4.showView(module);
				
				ui4.addEventListener(GlobeRequestEvent.CONTROL_GLOBE, onGlobeRequest);
				ui4.addEventListener(ContentSelectionEvent.CONTENT_SELECTION, onContentSelection);						
				ui4.addEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
				ui4.addEventListener(ContentScreenActivityEvent.ACTIVITY, onContentScreenActivity);
			}
			
			// 
			addChild(ui);
			
			//remove
			for each (var i:TouchSprite in uiDictionary)
			{
				if (i != ui)
				{
					if (contains(i))
						remove(i);
				}	
			}
		}
		
		
		private function remove(ui:TouchSprite):void 
		{
			if (ui == ui1)
			{	
				ui1.removeEventListener(NewSessionEvent.NEW_SESSION, onNewSession); 	
			}
				
			else if (ui == ui2) 
			{
				ui2.removeEventListener(MenuScreenActivityEvent.ACTIVITY, onMenuScreenActivity);				
				ui2.removeEventListener(ModuleSelectionEvent.MODULE_SELECTION, onModuleSelection);
				ui2.removeEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
			}	
				
			else if (ui == ui3)			
			{
				ui3.removeEventListener(GlobeRotateEvent.ROTATE, onRotate);								
				ui3.removeEventListener(ControlBarEvent.CONTROL_BUTTON, onControlBtn);				
				ui3.removeEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange); 								
			}
				
			else if (ui == ui4)
			{
				contentTimer.stop();
				contentTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onContentTimeEnd);								
				
				ui4.removeEventListener(GlobeRequestEvent.CONTROL_GLOBE, onGlobeRequest);				
				ui4.removeEventListener(ContentSelectionEvent.CONTENT_SELECTION, onContentSelection);	
				ui4.removeEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
				ui4.removeEventListener(ContentScreenActivityEvent.ACTIVITY, onContentScreenActivity);				
				ui4.stopContentCycle();
			}
			
			if (contains(ui))
				removeChild(ui);
		}	
		
		
		//parse server messages
		public function clientUpdate(message:Object):void 
		{
			if (message.funct == "globeAvailable")
			{			
				this.globeAvailable = message.val;				
				ui1.globeAvailable = message.val;				
			}
				
			else if (message.funct == "moduleSelection")
			{				
				this.module = message.val;
				ui4.module = message.val;
				show(ui4);
			}
				
			else if (message.funct == "screenUpdate")
			{				
				if (message.val == "contentDisplay1")
					ui4.changeDiagram("left");
				else if (message.val == "contentDisplay2")
					ui4.changeDiagram("right");	
			}			
				
			else if (message.funct == "globeRequestMade")
			{
				this.globeRequestMade = message.val;
				ui3.globeRequestMade = message.val;
			}
				
			else if (message.funct == "reset")
			{				
				if (message.val == "no")
				{
					updateGlobeControlTime(globeControlTime);
					globeControlTimer.reset();
					globeControlTimer.start();	
					
					this.globeAvailable = false;				
					ui1.globeAvailable = false;	
					show(ui1);								
				}
					
				else if (message.val == "none")
				{
					this.globeRequestMade = false;										
					this.globeAvailable = true;
					this.globeRequest = false;
					ui4.globeRequest = false;
					ui1.globeAvailable = true;
					ui3.globeRequestMade = false;
					show(ui1);								
				}
					
				else if (message.val == this.clientId)
				{						
					this.globeAvailable = true;
					ui1.globeAvailable = true;										
					show(ui1);			
				}					
				
			}			
		}
		
		//display events
		private function onNewSession(e:NewSessionEvent):void
		{
			this.globeAvailable = false;
			ui1.globeAvailable = false;										
			
			show(ui2);			
			dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "newSession", true));			
		}
		
		
		private function onModuleSelection(e:ModuleSelectionEvent):void
		{
			this.module = e.module;
			ui4.module = e.module;
			
			show(ui3);			
			dispatchEvent(new DisplayEventInt(DisplayEventInt.DISPLAY_EVENT_INT, "moduleSelection", e.module));						
		}
		
		
		private function onContentSelection(e:ContentSelectionEvent):void
		{
			this.module = e.module;
			ui2.module = e.module;
			ui3.module = e.module;
			ui4.module = e.module;
			
			this.content = e.content;
			ui4.content = e.content;
			
			dispatchEvent(new DisplayEventInt2(DisplayEventInt2.DISPLAY_EVENT_INT2, "contentSelection", e.module, e.content));									
		}
		
		
		private function onGlobeRequest(e:GlobeRequestEvent):void
		{
			this.globeRequest = true;
			this.globeRequestMade = true;
			
			dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "globeRequest", true));									
		}	
		
		//globe control timer events
		private function onGlobeControlTimerEnd(e:TimerEvent):void
		{
			if (this.display == 3)
				dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "globeControlTimerEnd", true));	
		}
		
		
		private function onTimer(e:TimerEvent):void
		{
			updateGlobeControlTime(globeControlTime - e.currentTarget.currentCount);
		}
		
		
		private function updateGlobeControlTime(time:int):void
		{
			var sec:int = time % 60;
			var min:int = (time / 60) % 60;
			
			var secStr:String = sec.toString();
			if (secStr.length < 2)
				secStr = "0" + secStr;
			
			var t:String = min + ":" + secStr;				
			ui3.upateGlobeControlTime(t);
			ui4.upateGlobeControlTime(t);					
		}
		
		
		//menu timer events
		private function onMenuScreenActivity(e:MenuScreenActivityEvent):void
		{			
			menuTimer.reset();
			menuTimer.start();			
		}
		
		
		private function onMenuTimerEnd(e:TimerEvent):void
		{
			menuTimer.stop();
			
			if (this.display == 2 || this.display == 1)
			{
				this.globeRequestMade = false;										
				this.globeAvailable = true;
				this.globeRequest = false;
				ui4.globeRequest = false;
				ui1.globeAvailable = true;
				ui3.globeRequestMade = false;
				dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "menuTimerEnd", true));	
			}
		}
		
		
		private function onMenuButtonDelayTimer(e:TimerEvent):void
		{
			ui2.addButtonListeners();
		}
		
		//content timer events
		private function onContentScreenActivity(e:ContentScreenActivityEvent):void
		{
			ui4.stopContentCycle();
			contentTimer.reset();
			contentTimer.start();
		}
		
		private function onContentTimeEnd(e:TimerEvent):void
		{
			ui4.startContentCycle();			
		}
		
		
		//language event
		private function onLanguageChange(e:LanguageEvent):void 
		{
			language = e.language;
			
			if (e.target == ui2) 
			{
				ui3.showLanguage(language);
				ui4.showLanguage(language);
			}
			else if (e.target == ui3) 
			{
				ui2.showLanguage(language);
				ui4.showLanguage(language);
			}
			else if (e.target == ui4) 
			{
				ui2.showLanguage(language);
				ui3.showLanguage(language);
			}
			
			dispatchEvent(new DisplayEventStr(DisplayEventStr.DISPLAY_EVENT_STR, "language", e.language));									
		}			
		
		private function onMenuReturn(e:MenuEvent):void
		{
			show(ui2);
			dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "menu", true));						
		}
		
		
		private function onControlBtn(e:ControlBarEvent):void
		{
			dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, e.button, true));						
		}
		
		
		private function onRotate(e:GlobeRotateEvent):void
		{
			//adjust transformations for magic planet
			var rx:int = map(e.rx, -90, 90, 180, 0);			
			var ry:int;
			
			if (e.ry >= 0){
				ry = map(e.ry, 0, 360, -180, 180);
			}
			else {
				ry = map(e.ry, 0, -360, 180, -180);			
			}	
			
			dispatchEvent(new DisplayEventInt3(DisplayEventInt3.DISPLAY_EVENT_INT3, "rotate", rx, ry, e.rz));
		}
		
		public function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number 
		{
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}			
		
		//edit mode on
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 49) {
				removeAll();				
				module = 1;
				content = 1;
				ui4.module = module;				
				if (!e.shiftKey) 
					show(ui3);
				else 		
					show(ui4);
			}	
			else if (e.keyCode == 50) {
				removeAll();				
				module = 2;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}	
			else if (e.keyCode == 51) {
				removeAll();				
				module = 3;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}
			else if (e.keyCode == 52) {
				removeAll();				
				module = 4;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}				
			else if (e.keyCode == 53) {
				removeAll();				
				module = 5;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);				
			}	
			else if (e.keyCode == 54) {
				removeAll();				
				module = 6;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}				
			else if (e.keyCode == 55) {
				removeAll();				
				module = 7;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}	
			else if (e.keyCode == 56) {
				removeAll();				
				module = 8;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}	
			else if (e.keyCode == 57) {
				removeAll();				
				module = 9;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}				
			else if (e.keyCode == 48) {
				removeAll();				
				module = 10;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}	
			else if (e.keyCode == 189) {
				removeAll();				
				module = 11;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}
			else if (e.keyCode == 187) {
				removeAll();				
				module = 12;
				content = 1;
				if (!e.shiftKey) 
					show(ui3);
				else
					show(ui4);			
			}
			else if (e.keyCode == 32) {
				removeAll();
				module = 0;
				content = 0;				
				show(ui1);
				ui1.globeAvailable = true;
			}
			dispatchEvent(new DisplayEventInt(DisplayEventInt.DISPLAY_EVENT_INT, "moduleSelection", module));
			dispatchEvent(new DisplayEventBool(DisplayEventBool.DISPLAY_EVENT_BOOL, "globeControl", false));												
		}
		
		
		private function removeAll():void 
		{
			if (contains(ui1)) remove(ui1);
			if (contains(ui2)) remove(ui2);
			if (contains(ui3)) removeChild(ui3);
			if (contains(ui4)) removeChild(ui4);
		}		
		
	}//class
}//package