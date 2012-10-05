package com.ideum.miasci {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class Settings implements IEventDispatcher {
		static private var instance:Settings;
		private var eventDispatcher:EventDispatcher;
		private var _isLoaded:Boolean;
		public function get isLoaded():Boolean { return _isLoaded; }
		private var urlLoader:URLLoader;
		static public const INIT:String = "init";
		static private var instances:Dictionary = new Dictionary;
		public var data:XML;
		
		public function Settings(enforcer:SingletonEnforcer) {
			eventDispatcher = new EventDispatcher();
			_isLoaded = false;
		}
		
		public function loadSettings(url:String):void {
			var urlRequest:URLRequest = new URLRequest(url);
			urlLoader = new URLLoader;
			urlLoader.addEventListener(Event.COMPLETE, onXMLDataLoaded);
			urlLoader.load(urlRequest);
		}
		
		public function onXMLDataLoaded(e:Event):void {
			data = XML(urlLoader.data);
			_isLoaded = true;
			dispatchEvent(new Event(Settings.INIT, true, true));
		}
		
		public static function getInstance(key:*):Settings {
			if (instances[key] == null)
				Settings.instances[key] = new Settings(new SingletonEnforcer());
			return Settings.instances[key];
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, weakRef:Boolean=false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return eventDispatcher.dispatchEvent(e);
		}
		
		public function hasEventListener(type:String):Boolean {
			return eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
		
	}//class
}//package

class SingletonEnforcer {}
