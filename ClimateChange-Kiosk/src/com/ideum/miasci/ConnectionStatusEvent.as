package com.ideum.miasci
{
	import flash.events.Event;
	
	public class ConnectionStatusEvent extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default CONNECTION_UPDATE
		 */	
		public static const CONNECTION_UPDATE:String = "CONNECTION_UPDATE";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the message
		 * @default null
		 */	
		private var _message:String;
		public function get message():String { return _message; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a ConnectionStatusEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ConnectionStatusEvent(type:String, message:String=null, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets language property
			_message = message;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ConnectionStatusEvent
		 */		
		override public function clone():Event
		{
			return new ConnectionStatusEvent(type, _message, bubbles, cancelable);
		}		
		
		
	}//class
}//package
