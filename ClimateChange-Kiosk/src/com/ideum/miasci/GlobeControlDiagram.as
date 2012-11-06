package com.ideum.miasci
{
	import flash.display.Sprite;
	
	public class GlobeControlDiagram extends AbstractElement
	{
		private var rect1:Sprite;
		private var rect2:Sprite;
		private var rect3:Sprite;
		private var rect4:Sprite;
		private var circle:Sprite;
		
		public var lineWidth:Number = 1.5;
		public var lineAlpha:Number = 0.5;
		public var spacing:Number = 8;
		
		public function GlobeControlDiagram()
		{
			super();
	
			rect1 = new Sprite;
			rect2 = new Sprite;
			rect3 = new Sprite;
			rect4 = new Sprite;
			circle = new Sprite;
			
			addChild(rect1);
			addChild(rect2);
			addChild(circle);
			addChild(rect3);
			addChild(rect4);
			
			reset();
		
		}
		
		public function reset():void
		{
			rect1.graphics.clear();
			rect2.graphics.clear();
			rect3.graphics.clear();
			rect4.graphics.clear();
			circle.graphics.clear();
			
			createRectangle(rect1, 33, 18);
			createRectangle(rect2, 18, 33);
			createRectangle(rect3, 18, 33);
			createRectangle(rect4, 33, 18);
			
			circle.graphics.lineStyle(lineWidth, 0xFFFFFF, lineAlpha);
			circle.graphics.drawCircle(0, 0, rect1.width-5);
			
			rect2.x = rect1.width + spacing + rect1.x;
			circle.x = rect2.width + spacing + rect2.x + circle.width/2;
			circle.y = circle.height/2 + rect1.height/2;
			rect3.x = circle.width + spacing + circle.x - circle.width/2;
			rect4.x = rect3.width + spacing + rect3.x;
			
		}		
		
		private function createRectangle(rect:Sprite, w:Number, h:Number):void
		{
			rect.graphics.lineStyle(lineWidth, 0xFFFFFF, lineAlpha);
			rect.graphics.drawRect(0, 0, w, h);			
		}

		public function fillPosition(position:String):void
		{			
			if (position == "left")
				fill(rect1);			
			else if (position == "right")
				fill(rect4);
			else if (position == "center")
			{
				fill(rect2);
				fill(rect3);
				
				var r:Number = circle.width/2;
				circle.graphics.clear();
				circle.graphics.beginFill(0xFFFFFF);
				circle.graphics.lineStyle(lineWidth, 0xFFFFFF, lineAlpha);
				circle.graphics.drawCircle(0, 0, r);
				circle.graphics.endFill();				
			}
			
			function fill(rect:Sprite):void
			{
				var w:Number = rect.width;
				var h:Number = rect.height;
				
				rect.graphics.clear();
				rect.graphics.lineStyle(lineWidth, 0xFFFFFF, lineAlpha);
				rect.graphics.beginFill(0xFFFFFF);
				rect.graphics.drawRect(0, 0, w, h);
				rect.graphics.endFill();				
			}
			
		}		
	}//class
}//package