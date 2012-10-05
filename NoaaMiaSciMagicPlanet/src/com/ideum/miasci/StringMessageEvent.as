package com.ideum.miasci
{
	import flash.events.Event;
	
	public class  StringMessageEvent extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default STRING_RECEIVED
		 */	
		public static const STRING_RECEIVED:String = "STRING_RECEIVED";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the client message
		 * @default null
		 */	
		private var _message:String;
		public function get message():String { return _message; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a StringMessageEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function StringMessageEvent(type:String, message:String=null, bubbles:Boolean=false, cancelable:Boolean=false):void 
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
		 * @returns StringMessageEvent
		 */		
		override public function clone():Event
		{
			return new StringMessageEvent(type, _message, bubbles, cancelable);
		}		
		
		
	}//class
}//package