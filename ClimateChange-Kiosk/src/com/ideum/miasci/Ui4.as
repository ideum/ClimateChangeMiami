package com.ideum.miasci 
{
	import Ui3.AnimationTimeBg;
	
	import com.ideum.miasci.AbstractDisplay;
	import com.ideum.miasci.ContentSelectionEvent;
	import com.ideum.miasci.GlobeRequestEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class Ui4 extends AbstractDisplay 
	{
		public var display:int = 4;
		public var module:int = 1;
		public var globeAvailable:Boolean = false;	
		public var globeRequest:Boolean = false;
		
		private var _content:int = 1;
		public function get content():int { return _content; }
		public function set content(v:int):void { _content = v; }		
		
		private var contentBtns:Dictionary;
		
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }				
		
		private var languageBtn:TouchSprite;
		private var controlGlobeBtn:TouchSprite;
		private var colorTransform:ColorTransform;
		private var dropShadow:DropShadowFilter;
		private var bevel:BevelFilter;
		private var whiteGlow:GlowFilter;
		private var activeGlow:GlowFilter;
		private var thumbFiltersActive:Array;
		private var thumbFiltersInactive:Array;
		private var currentTimeString:String;
		
		private var timeBlinkTimer:Timer;	
		public var timeBlinkOn:Boolean = true;				
		public var timeBlinkThreshold:String = "0:05";
		
		private var _timeBlinkInterval:int = 250;
		public function get timeBlinkInterval():int { return _timeBlinkInterval; }
		public function set timeBlinkInterval(v:int):void { _timeBlinkInterval = v; 
			if (timeBlinkTimer) timeBlinkTimer.delay = v; }		
		
		private var screen:String = "left";
				
		private var contentCycleTimer:Timer;
		private var _contentCycleInterval:int = 1000;
		public function get contentCycleInterval():int { return _contentCycleInterval; }
		public function set contentCycleInterval(v:int):void { _contentCycleInterval = v * 1000; 
			if (contentCycleTimer) contentCycleTimer.delay =  v * 1000; }				
		
		private var mainStage:Stage;
		
		public function Ui4(mStage:Stage) 
		{						
			super("ui4", "userUi4");
			
			mainStage = mStage;
			mainStage.addEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);
			
			timeBlinkTimer = new Timer(timeBlinkInterval);
			contentCycleTimer = new Timer(contentCycleInterval);
			
			setUpFilters();
			setUpLanguageButton();
			setUpControlGlobeBtn();
			setUpContentBtns();
			setUpGlobeBg();
			setUpDiagram();
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
			content++;
			if (content > 6)
				content = 1;
			showContent(content);			
		}
		
		private function onTouchDown(e:TouchEvent):void
		{
			dispatchEvent(new ContentScreenActivityEvent(ContentScreenActivityEvent.ACTIVITY));	
		}
		
		private function setUpDiagram():void
		{
			var position:String = Settings.getInstance('global').data.network.@position;
			if (position == "left" || position == "right") {
				dict['globeDiagram'].showId(position);	
				screen = position;
			}	
		}
		
		
		public function changeDiagram(pos:String):void
		{
			screen = pos;
			if (pos == "left" || pos == "right")
				dict['globeDiagram'].showId(pos);
		}		
		
		
		//content buttons
		public function setUpContentBtns():void
		{
			contentBtns = new Dictionary(true);
			colorTransform = new ColorTransform;			
			
			thumbFiltersActive = new Array(activeGlow, dropShadow, bevel);
			thumbFiltersInactive = new Array(dropShadow, bevel);			
			
			for (var i:int=1; i<=6; i++)
			{
				removeChild(dict['displayBg'+i]);
				removeChild(dict['displayImageThumb'+i]);
				removeChild(dict['thumbText'+i]);
				
				contentBtns['contentBtn'+i] = new TouchSprite;
				contentBtns['contentBtn'+i].addChild(dict['displayBg'+i]);
				contentBtns['contentBtn'+i].addChild(dict['displayImageThumb'+i]);
				contentBtns['contentBtn'+i].addChild(dict['thumbText'+i]);
				
				dict['displayImageThumb'+i].filters = thumbFiltersInactive;				
				addChild(contentBtns['contentBtn'+i]);
				contentBtns['contentBtn'+i].addEventListener(TouchEvent.TOUCH_DOWN, onContentBtn);	
			}
			
			dict['displayImagePreview'].filters = new Array(whiteGlow, dropShadow);
			showView(1);
		}		
		
		
		public function showView(num:int):void 
		{
			module = num;
			if (screen == "left")			
				content = 1;
			else 
				content = 2;
						
			if (!globeRequest)
				showGlobeBtn();
			else
				showGlobeStatus();
			
			dict['globeThumb'].showId('src'+module);
			dict['header'].showId(language+module);
			
			for (var i:int=1; i<=6; i++)
			{	
				dict['thumbText'+i].showId(language+module+'-'+i);
				dict['displayImageThumb'+i].showId('src'+module+'-'+i);	
			}
			
			showContent(content);
		}	
		
		
		private function showGlobeBtn():void
		{
			dict['globeDiagram'].x = script['ImageElementArray']['globeDiagram'].@x;	
			dict['globeStatus'].visible = false;			
			dict['controlTheGlobe'].visible = true;
			dict['controlGlobeBg'].visible = true;				
		}
		
		
		private function showGlobeStatus():void
		{
			dict['controlTheGlobe'].visible = false;
			dict['controlGlobeBg'].visible = false;
			dict['globeStatus'].visible = true;						
		}
		
		
		//change content buttons and premodule image/text
		public function showContent(val:int):void 
		{	
			content = val;
			
			//update content buttons
			dict['displayImageThumb'+content].filters = thumbFiltersActive;
			dict['displayBg'+content].showId('src2');
			colorTransform.color = script['TextLayout']['thumbText1'].@color;
			dict['thumbText'+content].transform.colorTransform = colorTransform;
			
			for (var i:int=1; i<=6; i++) 
			{
				if (i != content) 
				{
					dict['displayBg'+i].showId('src1');
					colorTransform.color = script['TextLayout']['thumbText2'].@color;
					dict['thumbText'+i].transform.colorTransform = colorTransform;
					dict['displayImageThumb'+i].filters = thumbFiltersInactive;
				}
			}
			
			//display premodule
			dict['displayImagePreview'].showId('src'+module+'-'+content);			
			dict['previewText'].showId(language+module+'-'+content);			
			dict['footnote'].showId(language+module+'-'+content);
			
			dispatchEvent(new ContentSelectionEvent(ContentSelectionEvent.CONTENT_SELECTION, module, content));
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
			dict['nowPlaying'].showId(language);
			dict['header'].showId(language+module);
			dict['displayInstructions'].showId(language);
			dict['languageText'].showId(language);
			dict['footnote'].showId(language+module+'-'+content)
			dict['controlTheGlobe'].showId(language);			
			dict['globeStatus'].showId(language);				
			
			dict['previewText'].showId(language+module+'-'+content)
			
			for (var j:int=1; j<=6; j++)
			{
				dict['thumbText'+j].showId(language+module+'-'+j);
			}
			
			upateGlobeControlTime(currentTimeString);
		}
		
		
		//
		public function setUpControlGlobeBtn():void
		{
			removeChild(dict['controlGlobeBg']);			
			removeChild(dict['controlTheGlobe']);
			controlGlobeBtn = new TouchSprite;
			controlGlobeBtn.addChild(dict['controlGlobeBg']);			
			controlGlobeBtn.addChild(dict['controlTheGlobe']);
			controlGlobeBtn.addEventListener(TouchEvent.TOUCH_DOWN, onControlGlobeBtn);
			addChild(controlGlobeBtn);
		}
		
		//globe thumb
		public function setUpGlobeBg():void
		{
			var globeBg:AnimationTimeBg = new AnimationTimeBg;
			addChildAt(globeBg, this.numChildren-1);
			globeBg.x = 62;
			globeBg.y = 31;
		}	
		
		
		//timer
		public function upateGlobeControlTime(time:String):void
		{			
			if (time == timeBlinkThreshold && timeBlinkTimer.running == false && timeBlinkOn == true)
			{	
				timeBlinkTimer.start();
				timeBlinkTimer.addEventListener(TimerEvent.TIMER, onBlinkTimer);				
			}
			
			var str:String;
			
			if (language == "english")
				str = user['text']['timeStatus']['english']['p'];
			else 
				str = user['text']['timeStatus']['alt']['p'];
			
			str = str.split("0:00").join(time);
			
			dict['timeStatus'].updateText(str);
			
			dict['globeControlTime'].updateText(time);
			
			currentTimeString = time;
		}
		
		
		private function onBlinkTimer(e:TimerEvent):void 
		{
			dict['globeControlTime'].visible = (!dict['globeControlTime'].visible);
			dict['timeStatus'].visible = (!dict['timeStatus'].visible);
		}		
		
		
		public function stopBlinkTimer():void
		{
			timeBlinkTimer.stop();
			timeBlinkTimer.removeEventListener(TimerEvent.TIMER, onBlinkTimer);
			dict['globeControlTime'].visible = true;
			dict['timeStatus'].visible = true;		
		}
		
		
		//filters
		public function setUpFilters():void
		{
			dropShadow = new DropShadowFilter;						
			bevel = new BevelFilter;			
			whiteGlow = new GlowFilter;
			activeGlow = new GlowFilter;
			
			dropShadow.distance = 12;
			dropShadow.angle = 127;
			dropShadow.color = 0x000000;
			dropShadow.alpha = .5;
			dropShadow.blurX = 10;
			dropShadow.blurY = 10;
			dropShadow.strength = 1;
			dropShadow.quality = 15;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;
			dropShadow.quality = BitmapFilterQuality.HIGH;
			
			bevel.distance = 1;
			bevel.angle = 45;
			bevel.highlightColor = 0x000000;
			bevel.highlightAlpha = 0.5;
			bevel.shadowColor = 0x000000;
			bevel.shadowAlpha = 0.5;
			bevel.blurX = 3;
			bevel.blurY = 3;
			bevel.strength = 1;
			bevel.quality = BitmapFilterQuality.HIGH;
			bevel.type = BitmapFilterType.INNER;
			bevel.knockout = false;		
			
			whiteGlow.alpha = 1;
			whiteGlow.blurX = 2;
			whiteGlow.blurY = 2;
			whiteGlow.color = 0xFFFFFFF;
			whiteGlow.inner = true;
			whiteGlow.knockout = false;
			whiteGlow.strength = 255;
			
			activeGlow.alpha = 1;
			activeGlow.blurX = 2;
			activeGlow.blurY = 2;
			activeGlow.color = 0xFFDF7F;
			activeGlow.inner = true;
			activeGlow.knockout = false;
			activeGlow.strength = 255;			
			
		}	
		
		//event handlers
		private function onLanguageBtn(e:TouchEvent):void
		{
			if (language == "english")
				language = "alt";
			else 
				language = "english";
			dispatchEvent(new LanguageEvent(LanguageEvent.LANGUAGE_CHANGE, language));
			showLanguage(language);		
		}
		
		private function onControlGlobeBtn(e:TouchEvent):void
		{
			globeRequest = true;
			showGlobeStatus();			
			dispatchEvent(new GlobeRequestEvent(GlobeRequestEvent.CONTROL_GLOBE));
		}
		
		private function onContentBtn(e:TouchEvent):void 
		{			
			switch (e.currentTarget) 
			{
				case contentBtns['contentBtn1']: content = 1; break;
				case contentBtns['contentBtn2']: content = 2; break;
				case contentBtns['contentBtn3']: content = 3; break;
				case contentBtns['contentBtn4']: content = 4; break;
				case contentBtns['contentBtn5']: content = 5; break;
				case contentBtns['contentBtn6']: content = 6; break;
			}
			showContent(content);
		}
		
	}//class
}//package