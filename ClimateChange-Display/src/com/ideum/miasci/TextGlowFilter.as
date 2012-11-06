package com.ideum.miasci {
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class TextGlowFilter {
		private var glow:GlowFilter = new flash.filters.GlowFilter;
		
		public var filter:Array = [];

		private var _alpha:Number;
		public function set alpha(v:Number):void { filter[0].alpha = v};
		public function get alpha():Number { return filter[0].alpha };		
		
		private var _blurX:Number;
		public function set blurX(v:Number):void { filter[0].blurX = v};
		public function get blurX():Number { return filter[0].blurX };
		
		private var _blurY:Number;
		public function set blurY(v:Number):void { filter[0].blurY = v };
		public function get blurY():Number { return filter[0].blurY };
		
		private var _color:uint;
		public function set color(v:uint):void { filter[0].color = v };
		public function get color():uint { return filter[0].color };
		
		private var _inner:Boolean;
		public function set inner(v:Boolean):void { filter[0].inner = v };
		public function get inner():Boolean { return filter[0].inner };
		
		private var _knockout:Boolean;
		public function set knockout(v:Boolean):void { filter[0].knockout = v };
		public function get knockout():Boolean { return filter[0].knockout };
		
		private var _quality:String;
		public function set quality(v:String):void { 
			_quality == v;
			if (v == "low")
				filter[0].quality = BitmapFilterQuality.LOW;
			else if (v == "medium")
				filter[0].quality = BitmapFilterQuality.MEDIUM; 
			else if (v == "high")
				filter[0].quality = BitmapFilterQuality.HIGH;
		}
		public function get quality():String { return quality; };
		
		private var _strength:Number;
		public function set strength(v:Number):void { filter[0].strength = v };
		public function get strength():Number { return filter[0].strength };
		
		public function TextGlowFilter() {
			filter.push(glow);
		}
		
	}//class
}//package