package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class  UpdateKioskEventBool extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default MESSAGE_RECEIVED
		 */	
		public static const KIOSK_UPDATE_BOOL:String = "KIOSK_UPDATE_BOOL";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * 
		 * @default null
		 */	
		private var _clientId:String;
		public function get clientId():String { return _clientId; }			
		
		private var _funct:String;
		public function get funct():String { return _funct; }		

		private var _val:Boolean;
		public function get val():Boolean { return _val; }	

		
		//CONSTRUCTOR
		/**
		 * Creates a UpdateKioskEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function UpdateKioskEventBool(type:String, clientId:String="", funct:String="", val:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false):void 
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
			return new UpdateKioskEventBool(type, _clientId, _funct, _val, bubbles, cancelable)
		}		
		
		
	}//class
}//package
