package com.ideum.miasci {
	import flash.events.Event;
	
	public class GlobeRotateEvent extends Event {
		
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default FILE_LOADED
		 */	
		public static const ROTATE:String = "ROTATE";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * 
		 * @default english
		 */	
		private var _rx:int;
		public function get rx():int { return _rx; }		
		
		private var _ry:int;
		public function get ry():int { return _ry; }		
		
		private var _rz:int;
		public function get rz():int { return _rz; }	
		
		
		//CONSTRUCTOR
		/**
		 * Creates a GlobeRotateEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function GlobeRotateEvent(type:String, rx:int=0, ry:int=0, rz:int=0, bubbles:Boolean=false, cancelable:Boolean=false):void {
			//call the super class Event
			super(type, bubbles, cancelable);

			//sets language property
			_rx = rx;
			_ry = ry;
			_rz = rz;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns LanguageEvent
		 */		
		override public function clone():Event {
			return new GlobeRotateEvent(type, _rx, _ry, _rz, bubbles, cancelable);
		}		
		
		
	}//class
}//package
