package com.ideum.miasci
{
	import flash.events.Event;
	
	public class  ClientConnectionEvent extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default CONNECTION_MADE
		 */	
		public static const CONNECTION_MADE:String = "CONNECTION_MADE";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the client name
		 * @default null
		 */	
		private var _clientName:String;
		public function get clientName():String { return _clientName; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a ClientConnectionEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ClientConnectionEvent(type:String, clientName:String=null, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets language property
			_clientName = clientName;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ClientConnectionEvent
		 */		
		override public function clone():Event
		{
			return new ClientConnectionEvent(type, _clientName, bubbles, cancelable);
		}		
		
		
	}//class
}//package
