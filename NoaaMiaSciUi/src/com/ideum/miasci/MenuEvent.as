package com.ideum.miasci {
	import flash.events.Event;
	
	public class MenuEvent extends Event {
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default MENU_RETURN
		 */	
		public static const MENU_RETURN:String = "MENU_RETURN";	
		
			
		//CONSTRUCTOR
		/**
		 * Creates a MenuEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void {
			//call the super class Event
			super(type, bubbles, cancelable);			
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns MenuEvent
		 */		
		override public function clone():Event {
			return new MenuEvent(type, bubbles, cancelable);
		}		
		
		
	}//class
}//package
