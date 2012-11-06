package com.ideum.miasci 
{
	import com.ideum.miasci.ContentDisplay;
	import com.ideum.miasci.LanguageEvent;
	import com.ideum.miasci.ModuleDisplay;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class DisplayManager extends Sprite 
	{
		private var _module:int;
		public function get module():int { return _module; }
		public function set module(v:int):void { _module = v; }

		private var contentCycleTimer:Timer;
		private var _contentCycleInterval:int = 1000;
		public function get contentCycleInterval():int { return _contentCycleInterval; }
		public function set contentCycleInterval(v:int):void { _contentCycleInterval = v * 1000; 
			if (contentCycleTimer) contentCycleTimer.delay =  v * 1000; }			
		
		private var moduleDisplay1:ModuleDisplay;
		private var moduleDisplay2:ModuleDisplay;
		
		private var contentDisplay1:ContentDisplay;
		private var contentDisplay2:ContentDisplay;		
		
		private var windows:Dictionary;
		private var background:Sprite;
		private var kiosks:Dictionary;
		private var globeRequestQue:Array = new Array();
		
		public var module1Monitor:int = 0;
		public var module2Monitor:int = 0;
		public var content1Monitor:int = 0;
		public var content2Monitor:int = 0;
		
		public var attractModule:int = 0;
		private var attractCycle:Boolean = false;		
		private var attractContentCycleRandom:Boolean = true;
		
		public function DisplayManager()
		{
			super();
					
			moduleDisplay1 = new ModuleDisplay;
			moduleDisplay2 = new ModuleDisplay;						
			contentDisplay1 = new ContentDisplay;
			contentDisplay2 = new ContentDisplay;			
			
			if (Settings.getInstance('global').data.attractMode != undefined)
			{
				if (Settings.getInstance('global').data.attractMode.@module == "cycle") 
				{
					attractCycle = true;
					attractModule = 1;
				}	
				else	
					attractModule = Settings.getInstance('global').data.attractMode.@module;
				
				if (Settings.getInstance('global').data.attractMode.@contentRandomCycle == "true") 
					attractContentCycleRandom = true;
				else
					attractContentCycleRandom = false;

				contentCycleInterval = Settings.getInstance('global').data.attractMode.@contentCycleTime;
			}
			
			contentCycleTimer = new Timer(contentCycleInterval);			
			
			setupModuleDisplay(moduleDisplay1, attractModule, "english");
			setupModuleDisplay(moduleDisplay2, attractModule, "alt");			
			
			setupContentDisplay(contentDisplay1,  attractModule, 1, "english");
			setupContentDisplay(contentDisplay2, attractModule, 2, "english");
			
			
			windows = new Dictionary;
			
			for (var i:int=1; i<=4; i++)
			{
				windows['window'+i] = 
					new NativeWindow(new NativeWindowInitOptions());
			}
			
			if (Settings.getInstance('global').data.display != undefined)
			{
				module1Monitor = Settings.getInstance('global').data.display.@module1Monitor;
				module2Monitor = Settings.getInstance('global').data.display.@module2Monitor;
				content1Monitor = Settings.getInstance('global').data.display.@content1Monitor;
				content2Monitor = Settings.getInstance('global').data.display.@content2Monitor;
			}
			
			createWindow(windows['window1'], module1Monitor);
			createWindow(windows['window2'], module2Monitor);
			createWindow(windows['window3'], content1Monitor);
			createWindow(windows['window4'], content2Monitor);
			
			windows['window1'].stage.addChild(moduleDisplay1);
			windows['window2'].stage.addChild(moduleDisplay2);
			windows['window3'].stage.addChild(contentDisplay1);
			windows['window4'].stage.addChild(contentDisplay2);
									
			kiosks = new Dictionary();
			kiosks["Kiosk1"] = new KioskProxy("Kiosk1", "contentDisplay1");
			kiosks["Kiosk2"] = new KioskProxy("Kiosk2", "contentDisplay2");
			kiosks["Kiosk3"] = new KioskProxy("Kiosk3", "contentDisplay2");
			kiosks["Kiosk1"].language = "english";
			kiosks["Kiosk2"].language = "english";
			kiosks["Kiosk3"].language = "english";
			
		}
		
		//load Magic Planet defaults
		public function setupMagicPlanet():void
		{
			dispatchEvent(new UpdateKioskEventInt(UpdateKioskEventInt.KIOSK_UPDATE_INT, 
				"MagicPlanet", "moduleSelection", attractModule));		
			
			dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
				"MagicPlanet", "reset", true));
			
			dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
				"MagicPlanet", "autoRotate", true));					
		}
		
		private function setupModuleDisplay(d:ModuleDisplay, defaultModule:int, language:String):void
		{
			d.show(defaultModule);
			d.showLanguage(language);				
		}
		
		
		private function setupContentDisplay(d:ContentDisplay, defaultModule:int, defaultContent:int, language:String):void
		{
			d.loadFirstOfSets();
			d.loadSecondOfSets();
			d.loadSet(defaultModule);
			
			if (defaultModule == 0) 
			{
				d.setupCustomAttract();				
				d.show(defaultModule, 0);
			}	
			else
			{				
				d.removeCustomAttract();				
				d.show(defaultModule, defaultContent);
				if (attractContentCycleRandom && !contentCycleTimer.running)
					startContentCycle();
			}
			
			d.showLanguage(language);
		}
		
		
		private function createWindow(window:NativeWindow, screen:int):void 
		{
			window.x = Screen.screens[screen].bounds.left;	
			window.y = Screen.screens[screen].bounds.top;
			window.stage.displayState = StageDisplayState.FULL_SCREEN;
			window.stage.align = StageAlign.TOP_LEFT; 
			window.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			background = new Sprite;
			background.graphics.beginFill(0x000000);
			background.graphics.drawRect(0, 0, 1920, 1080);
			background.graphics.endFill();
			window.stage.addChild(background);
			window.activate();
		}		
				
		
		//parse update message from client
		public function clientUpdate(message:Object):void 
		{
			var k:KioskProxy;
			var cd:String;
			var queId:String;
			
			if (message.funct == "newSession")
			{
				for each (k in kiosks)
				{
					if (k.clientId == message.clientId)
						k.globeControl = true;
					else
					{	
						dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
							k.clientId, "globeAvailable", false));
						k.globeControl = false;										
					}	
				}	
			}
			
			//for changing language in edit mode
			else if (message.funct == "globeControl")
			{	
				kiosks[message.clientId].globeControl = message.val;
			}
			
			else if (message.funct == "language")
			{
				kiosks[message.clientId].language = message.val;
				
				if (!kiosks[message.clientId].globeControl)
				{	
					cd = kiosks[message.clientId].contentDisplay;
					this[cd].showLanguage(message.val);	
				}	
			}
			
			else if (message.funct == "moduleSelection")
			{
				module = message.val;
			
				stopContentCycle();
				
				//update magic planet computer
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "autoRotate", false));					
				
				dispatchEvent(new UpdateKioskEventInt(UpdateKioskEventInt.KIOSK_UPDATE_INT, 
					"MagicPlanet", "moduleSelection", module));				
				
				//switch Kiosk2 display screen
				if (message.clientId == "Kiosk1")
					kiosks["Kiosk2"].contentDisplay = "contentDisplay1";
				else if (message.clientId == "Kiosk3")
					kiosks["Kiosk2"].contentDisplay = "contentDisplay2";
				dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
					"Kiosk2", "screenUpdate", kiosks["Kiosk2"].contentDisplay));				
				
				//update other Kiosks
				for each (k in kiosks)
				{					
					if (k.clientId != message.clientId)
					{	
						dispatchEvent(new UpdateKioskEventInt(UpdateKioskEventInt.KIOSK_UPDATE_INT, 
							k.clientId, "moduleSelection", module));
						cd = k.contentDisplay;
						this[cd].showLanguage(k.language);
					}
				}
				
				//update 32" display media
				moduleDisplay1.show(module);
				moduleDisplay2.show(module);
				contentDisplay1.loadSet(module);
				contentDisplay2.loadSet(module);
				contentDisplay1.show(module, 1);				
				contentDisplay2.show(module, 2);					
			}
			
			else if (message.funct == "menu")
			{	
				//update other kiosks
				for each (k in kiosks)
				{
					if (k.clientId != message.clientId)
						dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
							k.clientId, "reset", "no"));							
				}
				
				//showAttract();						
			}			
			
			else if (message.funct == "contentSelection")
			{
				//update local content
				cd = kiosks[message.clientId].contentDisplay;
				this[cd].show(message.val1, message.val2);
			}
			
			else if (message.funct == "globeRequest")
			{
				//update globe request que
				var eval:Boolean = false;			
				for (var i:int = 0; i < globeRequestQue.length; i++) 
				{
					if (message.clientId == globeRequestQue[i])
						eval = true;
				}
				
				if (!eval)
					globeRequestQue.unshift(message.clientId);				
				
				for each (k in kiosks)
				{
					if (k.clientId != message.clientId)
						dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
							k.clientId, "globeRequestMade", true));
				}				
			}
			
			else if (message.funct == "menuTimerEnd")
			{	
				dispatchEvent(new UpdateKioskEventInt(UpdateKioskEventInt.KIOSK_UPDATE_INT, 
					"MagicPlanet", "moduleSelection", attractModule));						

				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "play", true));				
				
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "autoRotate", true));				
				
				//check que
				if (globeRequestQue.length > 0)
				{
					queId = globeRequestQue.pop();
					
					for each (k in kiosks)
					{
						if (k.clientId == queId)
							dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								k.clientId, "reset", queId));
						else 
							dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								k.clientId, "reset", "no"));							
					}					 			 
				}
					
				//que empty
				else
				{
					for each (k in kiosks)
					{
						dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
							k.clientId, "reset", "none"));
					}				
				}
				
				//check que with new length
				if (globeRequestQue.length <= 0)
				{				
					for each (k in kiosks)
					{
						dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
							k.clientId, "globeRequestMade", false));
					}
				}					

				showAttract();									
			}			
			
			else if (message.funct == "globeControlTimerEnd")
			{	
				//check que
				if (globeRequestQue.length > 0)
				{
					queId = globeRequestQue.pop();
					 
					 for each (k in kiosks)
					 {
						if (k.clientId == queId)
							 dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								 k.clientId, "reset", queId));
						else 
							dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								k.clientId, "reset", "no"));							
					 }					 			 
				}
				
				//que empty
				else
				{
					for each (k in kiosks)
					{
						if (k.clientId == message.clientId)
							dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								k.clientId, "reset", k.clientId));
						else 
							dispatchEvent(new UpdateKioskEventStr(UpdateKioskEventStr.KIOSK_UPDATE_STR, 
								k.clientId, "reset", "none"));													
					}				
				}
				
				//check que with new length
				if (globeRequestQue.length <= 0)
				{				
					for each (k in kiosks)
					{
						dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
							k.clientId, "globeRequestMade", false));
					}
				}
				
				
				dispatchEvent(new UpdateKioskEventInt(UpdateKioskEventInt.KIOSK_UPDATE_INT, 
					"MagicPlanet", "moduleSelection", attractModule));
				
				
				showAttract();				
			}		

			//globe functions
			else if (message.funct == "axis")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "axis", true));				
			}
			
			else if (message.funct == "rewind")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "rewind", true));					
			}
			
			else if (message.funct == "play")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "play", true));					
			}
			
			else if (message.funct == "forward")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "forward", true));					
			}
			
			else if (message.funct == "pause")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "pause", true));					
			}
			
			else if (message.funct == "reset")
			{
				dispatchEvent(new UpdateKioskEventBool(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, 
					"MagicPlanet", "reset", true));					
			}				
			
			else if (message.funct == "rotate")
			{
				dispatchEvent(new UpdateKioskEventInt3(UpdateKioskEventInt3.KIOSK_UPDATE_INT3, 
					"MagicPlanet", "rotate", message.val1, message.val2, message.val3));					
			}			
		}
		
		
		private function showAttract():void
		{
			if (attractCycle)
			{
				attractModule++;
				if (attractModule > 12)
					attractModule = 1;
			}
			
			moduleDisplay1.show(attractModule);
			moduleDisplay2.show(attractModule);
			contentDisplay1.loadSet(attractModule);
			contentDisplay2.loadSet(attractModule);
			
			if (attractModule == 0)
			{
				contentDisplay1.show(attractModule, 0);				
				contentDisplay2.show(attractModule, 0);					
			}
			else
			{
				contentDisplay1.show(attractModule, 1);				
				contentDisplay2.show(attractModule, 2);
				if (attractContentCycleRandom && !contentCycleTimer.running)
					startContentCycle();			
			}
		}	
		
		public function startContentCycle():void
		{
			contentCycleTimer.addEventListener(TimerEvent.TIMER, onContentCycle);
			contentCycleTimer.start();
			cycleContent();			
		}
		
		public function stopContentCycle():void
		{
			contentCycleTimer.removeEventListener(TimerEvent.TIMER, onContentCycle);
			contentCycleTimer.stop();			
		}
		
		private function onContentCycle(e:TimerEvent):void
		{
			cycleContent();
		}
		
		public function cycleContent():void
		{
			var num1:int = randomNumber(1, 6);
			var num2:int = randomNumber(1, 6);
			
			while (num1 == num2)
			{
				num2 = randomNumber(1, 6);
			}
			
			contentDisplay1.show(attractModule, num1);				
			contentDisplay2.show(attractModule, num2);	
		}
		
		private function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
	}//class
}//package