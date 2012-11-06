package com.ideum.miasci
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class StatusWindow extends Sprite
	{
		private var txt:TextField = new TextField;

		public function StatusWindow()
		{
			super();
			
			txt.width = 1920;
			txt.height = 35;
			txt.background = true;
			txt.backgroundColor = 0x888888;
			txt.x = 0;
			txt.y = 0;
			
			var format:TextFormat = new TextFormat;
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 25;
			txt.defaultTextFormat = format;	
			
			addChild(txt);				
		}
		
		public function updateText(text:String):void
		{
			txt.text = text;
		}
		
	}//class
}//package