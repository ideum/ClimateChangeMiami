package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class NewSessionEvent extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default NEW_SESSION
		 */	
		public static const NEW_SESSION:String = "NEW_SESSION";
					
		
		//CONSTRUCTOR
		/**
		 * Creates a NewSessionEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function NewSessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
					
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns NewSessionEvent
		 */		
		override public function clone():Event
		{
			return new NewSessionEvent(type, bubbles, cancelable);
		}		
		
		
	}//class
}//package
