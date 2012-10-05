package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class  UpdateKioskEventInt3 extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default KIOSK_UPDATE_INT3
		 */	
		public static const KIOSK_UPDATE_INT3:String = "KIOSK_UPDATE_INT3";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * 
		 * @default null
		 */	
		private var _clientId:String;
		public function get clientId():String { return _clientId; }			
		
		private var _funct:String;
		public function get funct():String { return _funct; }		
		
		private var _val1:int;
		public function get val1():int { return _val1; }	
		
		private var _val2:int;
		public function get val2():int { return _val2; }	

		private var _val3:int;
		public function get val3():int { return _val3; }
		
		
		//CONSTRUCTOR
		/**
		 * Creates a UpdateKioskEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function UpdateKioskEventInt3(type:String, clientId:String="", funct:String="", val1:int=0, val2:int=0, val3:int=0, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets properties
			_clientId = clientId
			_funct = funct;
			_val1 = val1;
			_val2 = val2;
			_val3 = val3;						
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns UpdateKioskEvent
		 */		
		override public function clone():Event
		{
			return new UpdateKioskEventInt3(type, _clientId, _funct, _val1, _val2, _val3, bubbles, cancelable)
		}		
		
		
	}//class
}//package
