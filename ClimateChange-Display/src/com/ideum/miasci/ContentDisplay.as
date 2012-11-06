package com.ideum.miasci 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;
	
	
	public class ContentDisplay extends AbstractDisplay 
	{
		public var content:int;
		public var module:int;
		
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }
		
		
		private var currentCaption:int;		
		private var captionTimer:Timer;
		private var captionTimerInterval:int;
		private var currentLogo:int;				
		private var logo:Array = new Array;
		private var useCustomAttract:Boolean = false;
		
		public function ContentDisplay()
		{
			super("horizontalDisplay", "userHorizontalDisplay");
			_language = "english";	
		}
		
		//setup custom attract screen
		public function setupCustomAttract():void
		{
			useCustomAttract = true;
			captionTimerInterval = 10000;
			loadDefaultImages();
			setUpCaption();
			setUpLogo();
		}

		//display objects are auto-added from xml, so must remove if not needed
		public function removeCustomAttract():void
		{
			useCustomAttract = false;			
			removeChild(dict['caption1']);
			removeChild(dict['caption2']);
			removeChild(dict['caption3']);
			removeChild(dict['caption4']);
			removeChild(dict['caption5']);
			removeChild(dict['caption6']);
			removeChild(dict['earth']);			
			removeChild(dict['logoMiaSci']);
			removeChild(dict['logoNoaa']);
		}		
		
		//displays local content selection
		public function show(module:int, content:int):void 
		{
			this.module = module;
			this.content = content;	
			
			if (module == 0 && content == 0)
			{
				captionTimer.start();				
				dict['displayMedia'].visible = false;
				dict['description'].visible = false;	
				dict['earth'].visible = true;
				dict['logoMiaSci'].visible = true;		
				dict['logoNoaa'].visible = true;				
			}
			else
			{
				if (useCustomAttract)
				{	
					captionTimer.stop();				
					dict['earth'].visible = false;
					dict['logoMiaSci'].visible = false;		
					dict['logoNoaa'].visible = false;
					dict['displayMedia'].visible = true;
					dict['description'].visible = true;
				}
				
				var tmp:String = module + "-" + content;
				dict['description'].showId(language+tmp);
				dict['displayMedia'].visible = true;
				dict['displayMedia'].showId("src"+tmp);				
			}
			
		}
		
		//loads a set of images (based on module number) 
		public function loadSet(set:int):void
		{
			var attr:String;
			
			for each (var a:XML in user.media.displayMedia.@*) 
			{
				attr = a.name();
							
				if (attr.search("-1") == -1 && attr.search("-2") == -1) //already loaded first and second of sets
				{						
					dict['displayMedia'].unload(attr);

					if (attr.search("src" + set + "-") >= 0) 
						dict['displayMedia'].load(attr, a);
				}	
			}
						
			//clean up unloads
			//System.gc();
		}
		
		//loads first of all sets (so something is shown while the rest of the set is loading)
		public function loadFirstOfSets():void
		{
			var attr:String;
			
			for each (var a:XML in user.media.displayMedia.@*) 
			{	
				attr = a.name();
				if (attr.search("-1") != -1)
					dict['displayMedia'].load(attr, a);
			}
		}
		
		//loads second of all sets (added later at client request - left shows #1 & right shows #2)
		public function loadSecondOfSets():void
		{
			var attr:String;
			
			for each (var a:XML in user.media.displayMedia.@*) 
			{	
				attr = a.name();
				if (attr.search("-2") != -1)
					dict['displayMedia'].load(attr, a);
			}
		}		
		
		public function showLanguage(language:String):void 
		{
			_language = language;
			var tmp:String = module + "-" + content;
			dict['description'].showId(language+tmp);
		}
		
		
		
		//attract screen
		private function loadDefaultImages():void
		{			
			dict['earth'].load(user.images.earth.@src);	
			dict['logoMiaSci'].load(user.images.logoMiaSci.@src);		
			dict['logoNoaa'].load(user.images.logoNoaa.@src);					
		}
		
		
		private function setUpCaption():void
		{			
			currentCaption = 1;
			var num:int;
			
			for (var i:int=1; i<6; i++)
			{
				num = i+1;
				dict['caption'+num].alpha = 0;
			}
			
			captionTimer = new Timer(captionTimerInterval);
			captionTimer.addEventListener(TimerEvent.TIMER, onCaptionTimer);
			captionTimer.start();				
		}
		
		public function showCaption(i:int):void
		{			
			if (i > 6) 
				i = 1;	
			
			TweenLite.to(dict['caption'+i], 1, {alpha:1});	
			TweenLite.to(dict['caption' +currentCaption], 1, {alpha:0});
			currentCaption = i;
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
		
		//event handlers		
		private function onCaptionTimer(e:TimerEvent):void
		{
			showCaption(currentCaption+1);
			showLogo(currentLogo+1);
		}
		
		
	}//class
}//package