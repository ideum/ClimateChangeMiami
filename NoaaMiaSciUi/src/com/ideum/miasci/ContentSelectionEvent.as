package com.ideum.miasci 
{
	import flash.events.Event;
	
	public class ContentSelectionEvent extends Event 
	{	
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default CONTENT_SELECTION
		 */	
		public static const CONTENT_SELECTION:String = "CONTENT_SELECTION";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the currently selected module
		 * @default english
		 */	
		private var _module:int;
		public function get module():int { return _module; }		
		
		/**
		 * Used to access the currently selected content
		 * @default english
		 */	
		private var _content:int;
		public function get content():int { return _content; }		
		
			
		//CONSTRUCTOR
		/**
		 * Creates a ContentEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function ContentSelectionEvent(type:String, module:int, content:int, bubbles:Boolean=false, cancelable:Boolean=false):void {
			//call the super class Event
			super(type, bubbles, cancelable);

			//sets properties
			_module = module;
			_content = content;				
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns ContentEvent
		 */		
		override public function clone():Event
		{
			return new ContentSelectionEvent(type, module, content, bubbles, cancelable);
		}		
		
		
	}//class
}//package
