package com.ideum.miasci 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	import id.core.id_internal;
	
	public class Ui1 extends AbstractDisplay 
	{
		public var display:int = 1;
		
		
		private var _globeAvailable:Boolean = true;
		public function get globeAvailable():Boolean { return _globeAvailable; }
		public function set globeAvailable(v:Boolean):void { _globeAvailable = v; 
			showInstruction(); }


		private var _globeControl:Boolean = false;
		public function get globeControl():Boolean { return _globeControl; }

		private var _logoTimerInterval:int = 10000;
		public function get logoTimerInterval():int { return _logoTimerInterval; }
		public function set logoTimerInterval(v:int):void { _logoTimerInterval = v; 
			if (logoTimer) logoTimer.delay = v; }		
		
		private var _instructionTimerInterval:int = 5000;
		public function get instructionTimerInterval():int { return _instructionTimerInterval; }
		public function set instructionTimerInterval(v:int):void { _instructionTimerInterval = v;
			if (instructionTimer) instructionTimer.delay = v; }		
				
		private var _instructionPulseInterval:int = 4000;
		public function get instructionPulseInterval():int { return _instructionPulseInterval; }
		public function set instructionPulseInterval(v:int):void { _instructionPulseInterval = v;
			if (instructionPulseTimer) instructionPulseTimer.delay = v; }		

		private var _instructionPulseOn:Boolean = true;
		public function get instructionPulseOn():Boolean { return _instructionPulseOn; }
		public function set instructionPulseOn(v:Boolean):void { _instructionPulseOn = v;
			if (instructionPulseTimer && v == false) instructionPulseTimer.stop(); }			

		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }		

		
		private var _selection:int;
		public function get selection():int { return _selection; }
		public function set selection(v:int):void { _selection = v; }		
		
		
		private var languageBtn:TouchSprite;		
		
		
		private var logoTimer:Timer;
		private var currentLogo:int;				
		private var logo:Array = new Array;
		private var instruction:Boolean;
		private var instructionTimer:Timer;
		private var instructionPulseTimer:Timer;
		private var pulse:Boolean;
		private var allowPulse:Boolean;				
		private var menu:TouchSprite;
		
		private var diagramPoint:Point = new Point;
		private var diagramScale:Point = new Point;
		
		
		public function Ui1(mStage:Stage) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			
			super("ui1", "userUi1");
			
			menu = new TouchSprite;
			menu.addEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);

			menu.addChild(dict['categoryBg1']);
			menu.addChild(dict['categoryBg2']);
			menu.addChild(dict['categoryBg3']);
			
			menu.addChild(dict['category1']);
			menu.addChild(dict['category2']);
			menu.addChild(dict['category3']);
			
			menu.addChild(dict['categoryText1']);
			menu.addChild(dict['categoryText2']);
			menu.addChild(dict['categoryText3']);
			
			addChild(menu);
						
			allowPulse = true;
						
			setUpLogo();
			setUpInstruction();
			setUpLanguageButton();	
			
			logoTimer = new Timer(logoTimerInterval);
			logoTimer.addEventListener(TimerEvent.TIMER, onLogoTimer);
			logoTimer.start();
			
			diagramPoint.x = dict['diagram2'].x;
			diagramPoint.y = dict['diagram2'].y;
			diagramScale.x = dict['diagram2'].scaleX;
			diagramScale.y = dict['diagram2'].scaleY;
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
		//logo view
		private function setUpLogo():void
		{
			currentLogo = 0;

			logo[0] = dict['logoMiaSci'];
			logo[1] = dict['logoNoaa'];
			logo[1].alpha = 0;					
		}
		
		public function showLogo(i:int):void
		{
			if (i >= logo.length) 
				i = 0;	
			
			TweenLite.to(logo[i], 1, {alpha:1});	
			TweenLite.to(logo[currentLogo], 1, {alpha:0});
			currentLogo = i;			
		}
		
		//instruction
		private function setUpInstruction():void
		{
			instruction = false;
			pulse = false;
			dict['instruction1'].visible = true;
			dict['instruction2'].visible = false;
			
			if (instructionPulseOn)
			{
				instructionPulseTimer = new Timer(instructionPulseInterval);
				instructionPulseTimer.addEventListener(TimerEvent.TIMER, onInstructionPulseTimer);
				instructionPulseTimer.start();
			}	
		}
		
		
		public function showInstruction():void
		{
			if (globeAvailable)
			{
				dict['instruction1'].visible = true;
				dict['instruction2'].visible = false;
				
				menu.visible = true;
				menu.addEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);		
		
				dict['diagram1'].visible = true;
				dict['diagram2'].visible = false;				
			}
			else
			{
				dict['instruction1'].visible = false;
				dict['instruction2'].visible = true;
				
				menu.visible = false;
				menu.removeEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);
				
				dict['diagram1'].visible = false;
				dict['diagram2'].visible = true;
				
				startAnimation();
			}			
		}	

	
		public function startAnimation():void
		{
			TweenLite.to(dict['instruction2'], 5, { y:300 });	
			TweenLite.to(dict['diagram2'], 5, { scaleX:1, scaleY:1, x: 200, y:517, 
					onComplete:function():void{allowPulse = true;}});	
			
			allowPulse = false;
		}
		

		public function resetDiagram():void
		{
			dict['diagram2'].x = diagramPoint.x;
			dict['diagram2'].y = diagramPoint.y;
			dict['diagram2'].scaleX = diagramScale.x;
			dict['diagram2'].scaleY = diagramScale.y;
		}		
		
		public function pulseInstruction():void 
		{
			if (!allowPulse)
				return;
			
			if (pulse)
			{	
				glowOff(dict['instruction1']);
				glowOff(dict['instruction2']);
			}
			else
			{	
				glowOn(dict['instruction1']);
				glowOn(dict['instruction2']);
			}
			
			function glowOn(obj:*):void 
			{
				TweenLite.to(obj, 2, {
					glowFilter:{
						color:0xFFD972, alpha:1, blurX:10, blurY:10, strength:1, quality:10 }});
				pulse = true;
			}
			
			function glowOff(obj:*):void 
			{
				TweenLite.to(obj, 2, {
					glowFilter:{
						color:0xFFD972, alpha:.5, blurX:10, blurY:10, strength:1, quality:10 }});
				pulse = false;
			}
		}		

		
		
		//event handlers		
		private function onLogoTimer(e:TimerEvent):void
		{
			showLogo(currentLogo+1);
		}
		
		private function onInstructionPulseTimer(e:TimerEvent):void 
		{
			pulseInstruction();
		}
		
		private function onTouchDown(e:TouchEvent):void
		{			
			selection = 1;
			var id:String = e.target.id;
			
			if (id == "category1" || id == "category1Bg")
				selection = 1;
			else if (id == "category2" || id == "category2Bg")
				selection = 2;
			else if (id == "category3" || id == "category3Bg")
				selection = 3;
			
			if (globeAvailable)
				dispatchEvent(new NewSessionEvent(NewSessionEvent.NEW_SESSION));			
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