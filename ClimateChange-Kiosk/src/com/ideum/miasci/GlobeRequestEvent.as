package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class GlobeRequestEvent extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default 
		 */	
		public static const CONTROL_GLOBE:String = "CONTROL_GLOBE";
	
		
		
		//CONSTRUCTOR
		/**
		 * 
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function GlobeRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			super(type, bubbles, cancelable);
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns 
		 */		
		override public function clone():Event
		{
			return new GlobeRequestEvent(type, bubbles, cancelable);
		}		
		
		
	}//class
}//package
