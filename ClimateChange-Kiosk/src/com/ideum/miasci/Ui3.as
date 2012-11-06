package com.ideum.miasci 
{
	import Ui3.AnimationTimeBg;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.ideum.miasci.AbstractDisplay;
	import com.ideum.miasci.ControlBar;
	import com.ideum.miasci.ControlBarEvent;
	import com.ideum.miasci.GlobeOverlay;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class Ui3 extends AbstractDisplay 
	{
		public var display:int = 3;
		public var module:int;
		public var globeAvailable:Boolean = false;		
		
		private var _globeControl:Boolean;
		public function get globeControl():Boolean { return _globeControl; }

		private var _globeRequestMade:Boolean;
		public function get globeRequestMade():Boolean { return _globeRequestMade; }
		public function set globeRequestMade(v:Boolean):void { _globeRequestMade = v; 
			updateGlobeStatus(); }		
		
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }		
		
		private var languageBtn:TouchSprite;
		private var menuBtn:TouchSprite;
		
		private var mainStage:Stage
		private var globeTouch:GlobeTouch;
		
		private var activeColor:uint = 0xFFDF7F;
		private var inactiveColor:uint = 0xFFFFFF;
		private var disabledColor:uint = 0x666666;
		
		private var axisDisabled:Boolean = true;
		private var resetDisabled:Boolean = true;
		
		private var timeBlinkTimer:Timer;	
		public var timeBlinkOn:Boolean = true;				
		public var timeBlinkThreshold:String = "0:05";
		
		private var _timeBlinkInterval:int = 250;
		public function get timeBlinkInterval():int { return _timeBlinkInterval; }
		public function set timeBlinkInterval(v:int):void { _timeBlinkInterval = v; 
			if (timeBlinkTimer) timeBlinkTimer.delay = v; }		
		
		private var _spinInc:Number;
		public function get spinInc():Number { return _spinInc; }
		public function set spinInc(v:Number):void { _spinInc = v; 
			if (globeTouch) globeTouch.spinInc = v; }
		
		private var _spinTimerInterval:int;
		public function get spinTimerInterval():int { return _spinTimerInterval; }
		public function set spinTimerInterval(v:int):void { _spinTimerInterval = v; 
			if (globeTouch) globeTouch.spinTimerInterval = v; }
				
		
		public function Ui3(mStage:Stage) 
		{						
			super("ui3", "userUi3");
			timeBlinkTimer = new Timer(timeBlinkInterval);

			_globeControl = true;
			globeRequestMade = false;
			
			mainStage = mStage;
			setUpLanguageButton();
			setUpGlobe();
			setUpTimer();
			setUpDiagram();
			setUpControlBar();
			
			//remove menu button
			removeChild(dict['menuBg']);			
			removeChild(dict['menuText']);	
										
			showView(1);
		}

		public function updateGlobeStatus():void
		{
			if (globeRequestMade)
				dict['globeStatus'].visible = true;
			else
				dict['globeStatus'].visible = false;
		}

		//menu button
		public function setUpMenuButton():void
		{	
			menuBtn = new TouchSprite;
			menuBtn.addChild(dict['menuBg']);
			menuBtn.addChild(dict['menuText']);			
			menuBtn.addEventListener(TouchEvent.TOUCH_DOWN, onMenuBtn);
			addChild(menuBtn);
		}
		
		//menu button
		public function setUpControlBar():void
		{
			dict['controlBar'].addEventListener(TouchEvent.TOUCH_DOWN, onControlBar);							
			dict['controlBar'].changeColor("reset", disabledColor);
			dict['controlBar'].changeColor("pause", activeColor);
			dict['controlBar'].changeColor("play", inactiveColor);		
		}
		
		
		//language button
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

		public function showLanguage(lang:String):void 
		{
			language = lang;			
			
			for each (var i:* in dict)
			{
				if (i != dict['globeControlTime'])
				{
					if (i.className == "TextLayout") 
					{
						i.showId(language+module);
						i.showId(language);
					}	
				}	
			}			
		}	
		
		
		public function setUpDiagram():void
		{
			dict['globeDiagram'].showId("center");			
		}

		public function setUpTimer():void
		{
			var controlTimerBg:AnimationTimeBg = new AnimationTimeBg;
			addChildAt(controlTimerBg, this.numChildren-1);
			controlTimerBg.x = 62;
			controlTimerBg.y = 30;
		}			
				
		
		public function setUpGlobe():void
		{
			globeTouch = new GlobeTouch(mainStage);
			addChildAt(globeTouch, this.numChildren-1);
			globeTouch.x = 355;
			globeTouch.y = -70;
			globeTouch.id = "globeTouch";
			globeTouch.loadUser("userUi3");
			globeTouch.addEventListener(GlobeRotateEvent.ROTATE, onRotate);
			
			var globeOverlay:GlobeOverlay = new GlobeOverlay;
			addChildAt(globeOverlay, this.numChildren-1);
			globeOverlay.x = 925;
			globeOverlay.y = 81;
			globeOverlay.scaleX = .91;
			globeOverlay.scaleY = .91;
			globeOverlay.alpha = 1;			
		}		
		
		
		public function showView(index:int):void 
		{
			module = index
			
			var a:XML
			var attr:XMLList;
			
			dict['globeThumb'].showId("src"+module);
			dict['header'].showId(language+module);
			dict['body'].showId(language+module);
			
			globeTouch.addEventListener(TouchEvent.TOUCH_DOWN, onFirstTouch);
			dict['globeInstruction'].addEventListener(TouchEvent.TOUCH_DOWN, onFirstTouch);
			reset();
			play();
			if (!contains(dict['globeInstruction']))
				addChild(dict['globeInstruction']);
			dict['globeInstruction'].alpha = 1;
			this.setChildIndex(dict['globeInstruction'], this.numChildren-1);
			globeTouch.showId("src"+module);
		}		
			
		public function upateGlobeControlTime(time:String):void
		{
			if (time == timeBlinkThreshold && timeBlinkTimer.running == false && timeBlinkOn == true)
			{	
				timeBlinkTimer.start();
				timeBlinkTimer.addEventListener(TimerEvent.TIMER, onBlinkTimer);				
			}
				
			dict['globeControlTime'].updateText(time);
		}
		
		private function onBlinkTimer(e:TimerEvent):void 
		{
			dict['globeControlTime'].visible = (!dict['globeControlTime'].visible);
		}
		
		public function stopBlinkTimer():void
		{
			timeBlinkTimer.stop();
			timeBlinkTimer.removeEventListener(TimerEvent.TIMER, onBlinkTimer);
			dict['globeControlTime'].visible = true;
		}		
		
		//control bar 
		
		public function axis():void 
		{		
			globeTouch.axis();			
			//dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "axis"));
		}
		
		
		public function rewind():void 
		{
			dict['controlBar'].blinkColor("rewind", activeColor, inactiveColor);			
			dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "rewind"));
		}
		
		public function play():void 
		{			
			globeTouch.play();
			dict['controlBar'].changeColor("play", activeColor);
			dict['controlBar'].changeColor("pause", inactiveColor);			
			dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "play"));
		}
		
		public function forward():void 
		{
			dict['controlBar'].blinkColor("forward", activeColor, inactiveColor);			
			dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "forward"));
		}
		
		public function pause():void 
		{
			globeTouch.pause();
			dict['controlBar'].changeColor("pause", activeColor);
			dict['controlBar'].changeColor("play", inactiveColor);			
			dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "pause"));
		}
		
		public function reset():void 
		{	
			axis();
			dict['controlBar'].blinkColor("reset", activeColor, inactiveColor);			
			dispatchEvent(new ControlBarEvent(ControlBarEvent.CONTROL_BUTTON, "reset"));
			play();
		}			
	
		
		//event handlers
		private function onControlBar(e:TouchEvent):void 
		{
			if (e.target == dict['controlBar'].btnArray[0])  rewind();
			else if (e.target == dict['controlBar'].btnArray[1])  play();
			else if (e.target == dict['controlBar'].btnArray[2])  forward();
			else if (e.target == dict['controlBar'].btnArray[3])  pause();
			else if (e.target == dict['controlBar'].btnArray[4])  reset();			
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
		
		private function onMenuBtn(e:TouchEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.MENU_RETURN));
		}
		
		private function onFirstTouch(e:TouchEvent):void
		{
			globeTouch.removeEventListener(TouchEvent.TOUCH_DOWN, onFirstTouch);
			dict['globeInstruction'].removeEventListener(TouchEvent.TOUCH_DOWN, onFirstTouch);
			TweenLite.to(dict['globeInstruction'], .5, {alpha:0, onComplete:end});
			
			function end():void
			{
				removeChild(dict['globeInstruction']);
			}
		}
		
		private function onRotate(e:GlobeRotateEvent):void
		{
			dispatchEvent(new GlobeRotateEvent(GlobeRotateEvent.ROTATE, e.rx, e.ry, e.rz));						
		}
	
	}//class
}//package