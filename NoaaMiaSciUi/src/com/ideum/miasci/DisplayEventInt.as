package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class DisplayEventInt extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default DISPLAY_EVENT_INT
		 */	
		public static const DISPLAY_EVENT_INT:String = "DISPLAY_EVENT_INT";
			
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to public properties
		 * @default 
		 */	
		private var _funct:String;
		public function get funct():String { return _funct; }			

		private var _val:int;
		public function get val():int { return _val; }
		
		
		//CONSTRUCTOR
		/**
		 * Creates a DisplayEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function DisplayEventInt(type:String, funct:String="", val:int=0, bubbles:Boolean=false, cancelable:Boolean=false):void 
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
			return new DisplayEventInt(type, funct, val, bubbles, cancelable);
		}		
		
		
	}//class
}//package
