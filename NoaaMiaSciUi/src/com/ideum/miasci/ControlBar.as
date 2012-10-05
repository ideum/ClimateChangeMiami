package com.ideum.miasci 
{
	import com.ideum.miasci.AbstractDisplay;
	
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	
	import id.core.TouchSprite;
		
	public class ControlBar extends AbstractDisplay 
	{		
		public var button:String;
		public var btnArray:Array = new Array(6);
		public var id:String;
		public var className:String = "ControlBar";
		private var colorTransform:ColorTransform;
		
		public function ControlBar() {
			super("controlBar", "userControlBar");
			this.blobContainerEnabled = true;
					
			setChildIndex(dict['background'], 0);
			var x:Number;
			var w:Number;
			
			for (var i:int; i<5; i++) {
				if (i == 0) {
					x = 56;
					w = dict['spacer1'].x - x;
				}
				else if (i == 1) {
					x = dict['spacer1'].x + 5;
					w = dict['spacer2'].x - x;
				}
				else if (i == 2) {
					x = dict['spacer2'].x + 5;
					w = dict['spacer3'].x - x;
				}
				else if (i == 3) {
					x = dict['spacer3'].x + 5;
					w = dict['spacer4'].x - x;
				}
				else if (i == 4) {
					x = dict['spacer4'].x + 5;
					w = 112;
				}

				btnArray[i] = new TouchSprite;
				btnArray[i].blobContainerEnabled = true;
				btnArray[i].graphics.beginFill(0xFFFFFF, 0);
				btnArray[i].graphics.drawRect(x, 10, w, 65);
				btnArray[i].graphics.endFill();
				addChild(btnArray[i]);
			}
			
			colorTransform = new ColorTransform;		
		}
		
		
		public function changeColor(name:String, color:uint):void
		{
			colorTransform.color = color;				
			dict[name].transform.colorTransform = colorTransform;
		}	
		
		private var blinkTimer:Timer = new Timer(200, 1);
		public function blinkColor(name:String, color1:uint, color2:uint):void
		{			
			colorTransform.color = color1;				
			dict[name].transform.colorTransform = colorTransform;
			
			blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, end)
			blinkTimer.start();
			
			function end(e:TimerEvent):void
			{
				colorTransform.color = color2;
				dict[name].transform.colorTransform = colorTransform;				
			}
		}		
		
		public function loadScript(file:String):void
		{
			script = Settings.getInstance(file).data;
			var v:XML;
			for each (v in script[className][id].@*) 
			{
				if (this.hasOwnProperty(v.name()))
					this[v.name().toString()] = v;
			}		
		}
		
		public function loadUser(file:String):void {}
		
	}//class
}//package