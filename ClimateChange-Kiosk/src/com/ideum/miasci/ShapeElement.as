package com.ideum.miasci 
{
	import flash.display.Shape;
	
	public class ShapeElement extends AbstractElement 
	{		
		private var _type:String;
		public function set type(v:String):void { _type = v; draw(); }
		public function get type():String { return _type; }
		
		private var _color:uint;
		public function set color(v:uint):void { _color = v; draw(); }
		public function get color():uint { return _color; }
		
		private var _lineWidth:Number;
		public function set lineWidth(v:Number):void { _lineWidth = v; draw(); }
		public function get lineWidth():Number { return _lineWidth; }
		
		private var _length:Number;
		public function set length(v:Number):void { _length = v; draw(); }
		public function get length():Number { return _length; }	
		
		private var _filter:String;
		public function set filter(v:String):void { _filter = v; }
		public function get filter():String { return _filter; }	
		
		public function ShapeElement() {
			super();
			_type = "line";
			_color = 0xFFFFFF;
			_lineWidth = 1;
			_length = 100;
			draw();
		}
		
		public function draw():void {
			if (type == "line") {
				this.graphics.lineStyle(lineWidth, color);
				this.graphics.moveTo(0, 0); 
				this.graphics.lineTo(0, length);
			}	
		}
	}
}