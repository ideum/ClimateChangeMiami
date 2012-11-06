package com.ideum.miasci
{
	public class KioskProxy
	{
		private var _clientId:String;
		public function get clientId():String { return _clientId; }
		public function set clientId(v:String):void { _clientId = v; }

		private var _display:int;
		public function get display():int { return _display; }
		public function set display(v:int):void { _display = v; }		

		private var _module:int;
		public function get module():int { return _module; }
		public function set module(v:int):void { _module = v; }
		
		private var _content:int;
		public function get content():int { return _content; }
		public function set content(v:int):void { _content = v; }

		private var _contentDisplay:String;
		public function get contentDisplay():String { return _contentDisplay; }
		public function set contentDisplay(v:String):void { _contentDisplay = v; }
		
		private var _globeControl:Boolean;
		public function get globeControl():Boolean { return _globeControl; }
		public function set globeControl(v:Boolean):void { _globeControl = v; }

		private var _globeAvailable:Boolean;
		public function get globeAvailable():Boolean { return _globeAvailable; }
		public function set globeAvailable(v:Boolean):void { _globeAvailable = v; }

		private var _globeRequest:Boolean;
		public function get globeRequest():Boolean { return _globeRequest; }
		public function set globeRequest(v:Boolean):void { _globeRequest = v; }	
		
		private var _globeRequestMade:Boolean;
		public function get globeRequestMade():Boolean { return _globeRequestMade; }
		public function set globeRequestMade(v:Boolean):void { _globeRequestMade = v; }		
		
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }
		
		public function KioskProxy(clientId:String, contentDisplay:String)
		{
			_clientId = clientId;
			_contentDisplay = contentDisplay;
		}
		
	}//class
}//package