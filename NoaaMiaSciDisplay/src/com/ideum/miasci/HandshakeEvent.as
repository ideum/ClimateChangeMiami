package com.ideum.miasci
{
	import flash.events.Event;
	
	public class  HandshakeEvent extends Event 
	{
		//PUBLIC PROPERTIES (STATIC CONST)
		/**
		 * Event constant
		 * @default MESSAGE_RECEIVED
		 */	
		public static const HANDSHAKE_COMPLETE:String = "HANDSHAKE_COMPLETE";
		
		
		//PUBLIC PROPERTIES (READ)
		/**
		 * Used to access the client message
		 * @default null
		 */	
		private var _clientName:String = new String;
		public function get clientName():String { return _clientName; }		
		
		
		//CONSTRUCTOR
		/**
		 * Creates a HandshakeEvent object and sets property defaults
		 * @param type 
		 * @param bubbles
		 * @param cancelelable
		 * @return none
		 */		
		public function HandshakeEvent(type:String, clientName:String="", bubbles:Boolean=false, cancelable:Boolean=false):void 
		{
			//call the super class Event
			super(type, bubbles, cancelable);
			
			//sets language property
			_clientName = clientName;
		}
		
		
		//PUBLIC PROPERTIES
		/**
		 * Overrides Event's clone method
		 * @param none
		 * @returns HandshakeEvent
		 */		
		override public function clone():Event
		{
			return new HandshakeEvent(type, _clientName, bubbles, cancelable);
		}		
		
		
	}//class
}//package
