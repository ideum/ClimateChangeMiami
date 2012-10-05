package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class DisplayEventInt2 extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default DISPLAY_EVENT_INT2
		 */	
		public static const DISPLAY_EVENT_INT2:String = "DISPLAY_EVENT_INT2";
			
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to public properties
		 * @default 
		 */	
		private var _funct:String;
		public function get funct():String { return _funct; }			

		private var _val1:int;
		public function get val1():int { return _val1; }
		
		private var _val2:int;
		public function get val2():int { return _val2; }
		
		//CONSTRUCTOR
		/**
		 * Creates a DisplayEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function DisplayEventInt2(type:String, funct:String="", val1:int=0, val2:int=0, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets properties
			_funct = funct;
			_val1 = val1;
			_val2 = val2;							
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ChangeViewEvent
		 */		
		override public function clone():Event
		{
			return new DisplayEventInt2(type, funct, val1, val2, bubbles, cancelable);
		}		
		
		
	}//class
}//package
