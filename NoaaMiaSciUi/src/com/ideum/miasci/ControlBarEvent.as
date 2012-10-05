package com.ideum.miasci {
	import flash.events.Event;
	
	public class ControlBarEvent extends Event {
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default FILE_LOADED
		 */	
		public static const CONTROL_BUTTON:String = "CONTROL_BUTTON";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the current language selection
		 * @default english
		 */	
		private var _button:String;
		public function get button():String { return _button; }		
		
			
		//CONSTRUCTOR
		/**
		 * Creates a LanguageEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ControlBarEvent(type:String, button:String="", bubbles:Boolean=false, cancelable:Boolean=false):void {
			//call the super class Event
			super(type, bubbles, cancelable);

			//sets language property
			_button = button;				
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns LanguageEvent
		 */		
		override public function clone():Event{
			return new ControlBarEvent(type, _button, bubbles, cancelable);
		}		
		
		
	}//class
}//package
