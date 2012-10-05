package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class ModuleSelectionEvent extends Event 
	{
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default MODULE_SELECTION
		 */	
		public static const MODULE_SELECTION:String = "MODULE_SELECTION";

		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Content selection
		 * @default 1
		 */	
		private var _module:int;
		public function get module():int { return _module; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a ModuleSelectionEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ModuleSelectionEvent(type:String, module:int=1, bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);

			//sets selection property
			_module = module;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ModuleSelectionEvent
		 */		
		override public function clone():Event
		{
			return new ModuleSelectionEvent(type, module, bubbles, cancelable);
		}		
		
		
	}//class
}//package
