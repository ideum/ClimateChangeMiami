package com.ideum.miasci {
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class TextElement extends TextField {
		public var format:TextFormat = new TextFormat();
		public var zIndex:int = 0;
		public var id:String;
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
				
		private var _align:String;
		public function set align(v:String):void { 
			switch (v) {
				case "center":
				format.align = TextFormatAlign.CENTER;
				setFormat();
				break;
				case "left":
					format.align = TextFormatAlign.LEFT;
					setFormat();
					break;
				case "right":
					format.align = TextFormatAlign.RIGHT;
					setFormat();
					break;
				case "justify":
					format.align = TextFormatAlign.JUSTIFY;
					setFormat();
					break;
			}
		}
		public function get align():String { return format.align; }

		private var _blockIndent:Object;
		public function set blockIndent(v:Object):void { format.blockIndent = v; setFormat(); }
		public function get blockIndent():Object { return format.blockIndent; }
		
		private var _bold:Object;
		public function set bold(v:Object):void { format.bold = v; setFormat(); }
		public function get bold():Object { return format.bold; }		

		private var _bullet:Object;
		public function set bullet(v:Object):void { format.bullet = v; setFormat(); }
		public function get bullet():Object { return format.bullet; }			

		private var _color:Object;
		public function set color(v:Object):void { format.color = v; setFormat(); }
		public function get color():Object { return format.color; }			
		
		private var _font:String;
		public function set font(v:String):void { format.font = v; setFormat(); }
		public function get font():String { return format.font; }	

		private var _indent:Object;
		public function set indent(v:Object):void { format.indent = v; setFormat(); }
		public function get indent():Object { return format.indent }			
		
		private var _italic:Object;
		public function set italic(v:Object):void { format.italic = v; setFormat(); }
		public function get italic():Object { return format.italic }		

		private var _kerning:Object;
		public function set kerning(v:Object):void { format.kerning = v; setFormat(); }
		public function get kerning():Object { return format.kerning }

		private var _leading:Object;
		public function set leading(v:Object):void { format.leading = v; setFormat(); }
		public function get leading():Object { return format.leading }			
		
		private var _leftMargin:Object;
		public function set leftMargin(v:Object):void { format.leftMargin = v; setFormat(); }
		public function get leftMargin():Object { return format.leftMargin }			
		
		private var _letterSpacing:Object;
		public function set letterSpacing(v:Object):void { format.letterSpacing = v; setFormat(); }
		public function get letterSpacing():Object { return format.letterSpacing }					

		private var _rightMargin:Object;
		public function set rightMargin(v:Object):void { format.rightMargin = v; setFormat(); }
		public function get rightMargin():Object { return format.rightMargin }				

		private var _size:Object;
		public function set size(v:Object):void { format.size = v; setFormat(); }
		public function get size():Object { return format.size }	
		
		private var _tabStops:Array;
		public function set tabStops(v:Array):void { format.tabStops = v; setFormat(); }
		public function get tabStops():Array { return format.tabStops }	

		private var _target:String;
		public function set target(v:String):void { format.target = v; setFormat(); }
		public function get target():String { return format.target }

		private var _underline:Object;
		public function set underline(v:Object):void { format.underline = v; setFormat(); }
		public function get underline():Object { return format.underline }			

		private var _url:String;
		public function set url(v:String):void { format.url = v; setFormat(); }
		public function get url():String { return format.url }
						
		public function TextElement() {
			super();
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.selectable = false;
			this.multiline = true;
			this.wordWrap = true;
			this.width = 100;
			format.font = "Berthold Akzidenz Grotesk BE Light Condensed";
			format.size = 15;
			format.color = 0x000000;
			format.leading = 0;
			format.letterSpacing = 0;
			setFormat();
		}
		
		public function setFormat():void {
			this.defaultTextFormat = format;		
		}	
		
		public function setFilter():void {
			this.filters = glowFilter.filter;	
		}

		
	}//class
}//package
