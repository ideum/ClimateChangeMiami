package com.ideum.miasci
{
	import flash.events.Event;
	
	public class  ObjectMessageEvent extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default OBJECT_RECEIVED
		 */	
		public static const OBJECT_RECEIVED:String = "OBJECT_RECEIVED";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the client message
		 * @default null
		 */	
		private var _message:Object = new Object;
		public function get message():Object { return _message; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a ObjectMessageEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ObjectMessageEvent(type:String, message:Object=null, bubbles:Boolean=false, cancelable:Boolean=false):void 
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
		 * @returns ObjectMessageEvent
		 */		
		override public function clone():Event
		{
			return new ObjectMessageEvent(type, _message, bubbles, cancelable);
		}		
		
		
	}//class
}//package
