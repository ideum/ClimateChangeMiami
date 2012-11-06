package com.ideum.miasci {
	import com.ideum.miasci.ImageElement; ImageElement;
	import com.ideum.miasci.ImageElementArray; ImageElementArray;
	import com.ideum.miasci.TextLayout; TextLayout;	
	import com.ideum.miasci.ShapeElement; ShapeElement;
	import com.ideum.miasci.ControlBar; ControlBar;
	import com.ideum.miasci.GlobeControlDiagram; GlobeControlDiagram;	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import id.core.TouchSprite;

	public class AbstractDisplay extends TouchSprite {
		public var dict:Dictionary = new Dictionary(true);
		public var user:XML;
		public var script:XML;

		public function AbstractDisplay(file1:String, file2:String) {
			
			var objectId:String;
			var className:String;
			var classNode:XML;
			var classTmp:Class;
			var objectNode:XML;
		
			script = Settings.getInstance(file1).data;
			
			if (file2)
				user = Settings.getInstance(file2).data;
			
			for each (classNode in script.*) 
			{
				className = "com.ideum.miasci.";
				className = className + classNode.name();
								
				for each (objectNode in classNode.*) 
				{
					objectId = objectNode.name();
					classTmp = getDefinitionByName(className) as Class;
					dict[objectId] = new classTmp;
					dict[objectId].id = objectId;
					dict[objectId].loadScript(file1);
					if (file2)
						dict[objectId].loadUser(file2);
					addChild(dict[objectId]);										
				}
			}
		}
		
		public function sortZindex(container:*):void {
			var i:int;
			var childList:Array = new Array();
			i = container.numChildren;
			while(i--) {
				childList[i] = container.getChildAt(i);
			}
			childList.sortOn("zIndex");
			i = container.numChildren;
			while(i--) {
				if (childList[i] != container.getChildAt(i))
					container.setChildIndex(childList[i], i);	
			}
		}
		
		
		
	}//class
}//package