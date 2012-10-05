package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class  UpdateKioskEventStr extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default KIOSK_UPDATE_INT
		 */	
		public static const KIOSK_UPDATE_STR:String = "KIOSK_UPDATE_STR";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * 
		 * @default null
		 */	
		private var _clientId:String;
		public function get clientId():String { return _clientId; }			
		
		private var _funct:String;
		public function get funct():String { return _funct; }		

		private var _val:String;
		public function get val():String { return _val; }	

		
		//CONSTRUCTOR
		/**
		 * Creates a UpdateKioskEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function UpdateKioskEventStr(type:String, clientId:String="", funct:String="", val:String="", bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets properties
			_clientId = clientId
			 _funct = funct;
			 _val = val;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns UpdateKioskEvent
		 */		
		override public function clone():Event
		{
			return new UpdateKioskEventStr(type, _clientId, _funct, _val, bubbles, cancelable)
		}		
		
		
	}//class
}//package
