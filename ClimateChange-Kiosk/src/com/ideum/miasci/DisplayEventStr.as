package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class DisplayEventStr extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default DISPLAY_EVENT_STR
		 */	
		public static const DISPLAY_EVENT_STR:String = "DISPLAY_EVENT_STR";
			
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to public properties
		 * @default 
		 */	
		private var _funct:String;
		public function get funct():String { return _funct; }			

		private var _val:String;
		public function get val():String { return _val; }
		
		
		//CONSTRUCTOR
		/**
		 * Creates a DisplayEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function DisplayEventStr(type:String, funct:String="", val:String="", bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets properties
			_funct = funct;
			_val = val;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ChangeViewEvent
		 */		
		override public function clone():Event
		{
			return new DisplayEventStr(type, funct, val, bubbles, cancelable);
		}		
		
		
	}//class
}//package
