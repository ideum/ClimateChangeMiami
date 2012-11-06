package com.ideum.miasci
{
	import flash.utils.getQualifiedClassName;
	
	import id.core.TouchSprite;
	
	public class AbstractElement extends TouchSprite
	{
		private var _className:String;
		public function get className():String { return _className; }		
		
		private var _id:String;
		public function get id():String { return _id; }
		public function set id(v:String):void { _id = v; }
		
		private var _zIndex:int;
		public function get zIndex():int { return _zIndex; }
		public function set zIndex(v:int):void { _zIndex = v; }				
		
		protected var script:XML;
		protected var user:XML;
		
		public function AbstractElement()
		{
			super();
			_className = getQualifiedClassName(this);	
			_className = className.slice(className.lastIndexOf("::") + 2);			
		}
		
		public function loadScript(file:String):void
		{
			script = Settings.getInstance(file).data;
			var v:XML;
			for each (v in script[className][id].@*) 
			{
				if (this.hasOwnProperty(v.name()))
					this[v.name().toString()] = v;
			}		
		}
		
		public function loadUser(file:String):void
		{
			user = Settings.getInstance(file).data;
			var v:XML;
						
			if (user['images'][id] != undefined)
			{
				for each (v in user['images'][id].@*) 
				{				
					if (this.hasOwnProperty(v.name()))
						this[v.name().toString()] = v;
				}	
			}
		}
		
	}//class
}//package