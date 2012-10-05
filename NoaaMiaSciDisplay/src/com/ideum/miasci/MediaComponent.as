package com.ideum.miasci {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class MediaComponent extends AbstractElement {
		private var count:int = 0;
		private var mediaDictionary:Dictionary;
		private var imageTypes:RegExp;
		private var videoTypes:RegExp;
		private var lastVideo:String;
		
		public function MediaComponent() 
		{
			mediaDictionary = new Dictionary(true);
			imageTypes = /^.*\.(png|gif|jpg)$/i;  
			videoTypes = /^.*\.(mpeg-4|mp4|m4v|3gpp|mov|flv|f4v)$/i;
		}
		
		public function load(id:String, path:String):void 
		{

			if (path.search(imageTypes) >= 0) {				
				mediaDictionary[id] = new ImageElement;
				mediaDictionary[id].load(path);
			}	
			else if (path.search(videoTypes) >= 0) {
				mediaDictionary[id] = new VideoElement;
				mediaDictionary[id].load(path);
			}		
			//else
				//throw new Error("Media type for is not supported: " + path);						
			count++;			
		}
		
		public function unload(id:String):void 
		{
			if (mediaDictionary[id])
			{	
				mediaDictionary[id].unload();
				if (this.contains(mediaDictionary[id]))
					removeChild(mediaDictionary[id]);
				mediaDictionary[id] = null;
				delete mediaDictionary[id];
			}	
		}		
		
		public function showId(id:String):void 
		{
			for each (var obj:* in mediaDictionary)
			{
				if (obj == mediaDictionary[id]) {
					addChild(obj);
										
					if (obj is VideoElement) {
						if (mediaDictionary[lastVideo])
							mediaDictionary[lastVideo].back();							
						obj.play();
						lastVideo = id;
					}	
				}	
			}			
		}
		
	}//class
}//package