package com.ideum.miasci
{
	import flash.display.Sprite;
	import flash.text.engine.*;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.edit.SelectionFormat;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	public class TextLayout extends AbstractElement
	{	
		private var textFormat:TextLayoutFormat;
		private var configuration:Configuration;
		private var textFlow:TextFlow;
		private var container:ContainerController;
		
		private var _font:String;
		public function get font():String { return _font; }
		public function set font(v:String):void { _font = v; }
		
		private var _color:int;
		public function get color():int { return _color; }
		public function set color(v:int):void { _color = v; }	
		
		private var _cWidth:Number;
		public function get cWidth():Number { return _cWidth; }
		public function set cWidth(v:Number):void { _cWidth = v; }		

		private var _cHeight:Number;
		public function get cHeight():Number { return _cHeight; }
		public function set cHeight(v:Number):void { _cHeight = v; }
		
		private var _filter:String;
		public function set filter(v:String):void { 			
			_filter = v;
			switch (v) {
				case "glow":					
					if (!glowFilter)
						glowFilter = new TextGlowFilter;
					this.filters = glowFilter.filter;
					break;
			}
		}
		
		public function get filter():String { return _filter; }		
		public var glowFilter:TextGlowFilter;
		
		public function TextLayout()
		{
			super();		
			_cWidth = 500;
			_cHeight = 1000;
			textFormat = new TextLayoutFormat;
			XML.ignoreWhitespace = true;
			
			configuration = new Configuration;
			configuration.textFlowInitialFormat = textFormat;
			textFlow = new TextFlow;

		}

		override public function loadScript(file:String):void
		{
			script = Settings.getInstance(file).data;
			var v:XML;
			var v2:XML;
			for each (v in script[className][id].@*) 
			{
				if (this.hasOwnProperty(v.name()))
					this[v.name().toString()] = v;				
				else if (textFormat.hasOwnProperty(v.name()))
					textFormat[v.name().toString()] = v;	
			}
			for each (v in script[className][id]['glowFilter'].@*) 
			{
				this.glowFilter[v.name().toString()] = v;
				this.filters = glowFilter.filter;	
			}				
		}		

		override public function loadUser(file:String):void
		{			
			user = Settings.getInstance(file).data;	
			
			if ((user['text'][id]) != undefined)		
				var txt:String = user['text'][id].*[0].name();
			
			if ((user['text'][id][txt]) != undefined)
			{				
				var root:XML = <TextFlow xmlns='http://ns.adobe.com/textLayout/2008'>{user['text'][id][txt].*}</TextFlow>;
				textFormat.color = this.color;
				configuration.textFlowInitialFormat = textFormat;
				textFlow = TextConverter.importToFlow(root, TextConverter.TEXT_LAYOUT_FORMAT, configuration);
				textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
				textFlow.fontFamily = this.font;
			}
			
			container = new ContainerController(this, cWidth, cHeight);			
			textFlow.flowComposer.addController(container);		
			textFlow.flowComposer.updateAllControllers();			
		}
		
		public function showId(textId:String):void
		{			
			if ((user['text'][id][textId]) != undefined)
			{
				var root:XML = <TextFlow xmlns='http://ns.adobe.com/textLayout/2008'>{user['text'][id][textId].*}</TextFlow>;
				textFormat.color = this.color;
				configuration.textFlowInitialFormat = textFormat;
				textFlow = TextConverter.importToFlow(root, TextConverter.TEXT_LAYOUT_FORMAT, configuration);
				textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
				textFlow.fontFamily = this.font;
				textFlow.flowComposer.removeController(container);		
				textFlow.flowComposer.addController(container);		
				textFlow.flowComposer.updateAllControllers();	
			}			
		}
		
		public function updateText(val:String):void
		{			
			var root:XML = <TextFlow xmlns='http://ns.adobe.com/textLayout/2008'>{val}</TextFlow>;
			textFormat.color = this.color;
			configuration.textFlowInitialFormat = textFormat;
			textFlow = TextConverter.importToFlow(root, TextConverter.TEXT_LAYOUT_FORMAT, configuration);
			textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			textFlow.fontFamily = this.font;
			textFlow.flowComposer.removeController(container);		
			textFlow.flowComposer.addController(container);		
			textFlow.flowComposer.updateAllControllers();				
		}		
		
	}//class
}//package