package com.ideum.miasci 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import id.core.TouchSprite;
	
	public class ImageElement extends AbstractElement 
	{	
		private var _src:String;
		public function set src(v:String):void { _src = v; load(_src); }
		public function get src():String { return _src; }
	
		private var loader:Loader;
		public var bitmap:Bitmap;	
		
		public function ImageElement() 
		{
			loader = new Loader;
			bitmap = new Bitmap;
		}
		
		public function load(path:String):void 
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest(path));			
		}
		
		private function onComplete(e:Event):void 
		{
			bitmap = Bitmap(loader.content);
			addChild(bitmap);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function unload():void {
			loader.unloadAndStop();
			if (bitmap) {
				bitmap.bitmapData.dispose();
				if (this.contains(bitmap))
					removeChild(bitmap);
				bitmap = null;
			}	
			
		}			
		
	}//class
}//package