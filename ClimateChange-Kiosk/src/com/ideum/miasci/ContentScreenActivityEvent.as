package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class ContentScreenActivityEvent extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default ACTIVITY
		 */	
		public static const ACTIVITY:String = "ACTIVITY";
					
		
		//CONSTRUCTOR
		/**
		 * Creates a ContentScreenActivityEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ContentScreenActivityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
					
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ContentScreenActivityEvent
		 */		
		override public function clone():Event
		{
			return new ContentScreenActivityEvent(type, bubbles, cancelable);
		}		
		
		
	}//class
}//package
