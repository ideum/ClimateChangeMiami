package com.ideum.miasci {
	import flash.events.Event;
	
	public class LanguageEvent extends Event {
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default FILE_LOADED
		 */	
		public static const LANGUAGE_CHANGE:String = "LANGUAGE_CHANGE";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the current language selection
		 * @default english
		 */	
		private var _language:String;
		public function get language():String { return _language; }		
		
			
		//CONSTRUCTOR
		/**
		 * Creates a LanguageEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function LanguageEvent(type:String, language:String="english", bubbles:Boolean=false, cancelable:Boolean=false):void {
			//call the super class Event
			super(type, bubbles, cancelable);

			//sets language property
			_language = language;				
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns LanguageEvent
		 */		
		override public function clone():Event{
			return new LanguageEvent(type, _language, bubbles, cancelable);
		}		
		
		
	}//class
}//package
