package com.ideum.miasci {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class ImageElement extends AbstractElement {
		private var loader:Loader;
		private var bitmap:Bitmap;
		
		private var _src:String;
		public function set src(v:String):void { _src = v; }
		public function get src():String { return _src; }
		
		public function ImageElement() {
			loader = new Loader;
		}	
		
		public function load(path:String):void {
			bitmap = new Bitmap;			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest(path));	
		}
		
		private function onComplete(e:Event):void {
			bitmap = Bitmap(loader.content);
			addChild(bitmap);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function unload():void {
			loader.unloadAndStop();
			if (bitmap) {
				if (bitmap.bitmapData)
					bitmap.bitmapData.dispose();
				if (this.contains(bitmap))
					removeChild(bitmap);
				bitmap = null;
			}	
		}		
		
	}//class
}//package