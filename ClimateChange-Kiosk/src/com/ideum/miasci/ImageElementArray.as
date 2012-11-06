package com.ideum.miasci {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class ImageElementArray extends AbstractElement {		
		public var imageElement:ImageElement;
		public var count:int = 0;
		private var imageArray:Array;
		private var imageDictionary:Dictionary;
		
		public function ImageElementArray() { 
			imageArray = new Array;
			imageDictionary = new Dictionary(true);
		}
		
		public function load(imageId:String, path:String):void 
		{
			imageElement = new ImageElement;
			imageElement.src = path;			
			imageArray.push(imageElement);
			imageDictionary[imageId] = imageElement;
			count++;
		}
		
		public function showIndex(num:int):void 
		{
			for (var i:int=0; i<count; i++) 
			{
				if (i == num)
					addChild(imageArray[i]);
				else 
				{
					if (this.contains(imageArray[i]))
						removeChild(imageArray[i]);
				}
			}
		}
		
		public function showId(imageId:String):void 
		{
			for each (var i:* in imageDictionary) 
			{
				if (i == imageDictionary[imageId])
					addChild(i);
				else {
					if (this.contains(i))
						removeChild(i);
				}
			}
		}

		override public function loadScript(file:String):void
		{
			script = Settings.getInstance(file).data;
			var v:XML;
			for each (v in script[className][id].@*) 
			{
				if (this.hasOwnProperty(v.name()))
					this[v.name().toString()] = v;
				else
					//load all
					this.load(v.name().toString(), v);
				
				//show first in set
				if (v.name() == "src" || v.name() == "src1" ||  v.name() == "src1-1")
					this.showId(v.name());
			}
			
		}		
		
		override public function loadUser(file:String):void
		{
			user = Settings.getInstance(file).data;	
			
			if (user['images'][id].@*[0] != undefined)
			{	
				var img:String = user['images'][id].@*[0].name();
				var v:XML;
				for each (v in user['images'][id].@*) 
				{	
										//load all
					this.load(v.name().toString(), v);			
					//show first in set
					if (v.name() == "src" || v.name() == "src1" ||  v.name() == "src1-1")
						this.showId(v.name());				
				}
			}
		}		
		
	}//class
}//package