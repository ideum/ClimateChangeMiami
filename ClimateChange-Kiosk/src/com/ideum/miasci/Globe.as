package com.ideum.miasci
{
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import id.core.TouchSprite;
	
	public class Globe extends AbstractElement
	{
		protected var sphere:Sphere;
		
		protected var scene:Scene3D;
		protected var view:View3D;
		protected var camera:Camera3D;
		private var ctr:ObjectContainer3D;
		
		protected var canDrag:Boolean=false;	
		protected var mainStage:*;
		
		private var videoMaterial:VideoMaterial;
		private var bitmapMaterial:BitmapFileMaterial;
		
		private var bitmapMaterials:Dictionary;
		private var bitmapCount:int = 0;
		
		public var rx:Number;
		public var ry:Number;
		public var rz:Number;
		
		protected var spinTimer:Timer;
		public var spinInc:Number = -.875;
		
		private var _spinTimerInterval:int = 60;
		public function get spinTimerInterval():int { return _spinTimerInterval; }
		public function set spinTimerInterval(v:int):void { _spinTimerInterval = v;
			if (spinTimer) spinTimer.delay = v; }
		
		
		public var spinning:Boolean = false;
		public var playing:Boolean = false;
		
		public function Globe(stage:*)
		{
			super();
			
			mainStage = stage;
			mainStage.addEventListener(Event.RESIZE, onStageResize);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			spinTimer = new Timer(spinTimerInterval);
			spinTimer.addEventListener(TimerEvent.TIMER, onSpinTimer);
			bitmapMaterials = new Dictionary(true);
			
			scene = new Scene3D;
			camera = new Camera3D;	
			view = new View3D();
			addChild(view);
			
			ctr = new ObjectContainer3D();
			view.scene.addChild(ctr);						
			
			view.x = mainStage.stageWidth / 2;
			view.y = mainStage.stageHeight / 2;
		}
		
		
		public function showId(val:String):void
		{
			sphere.material = bitmapMaterials[val];
			rx = 0;
			ry = 90;
		}
		
		
		public function load(imageId:String, path:String):void 
		{	
			bitmapMaterials[imageId] = new BitmapFileMaterial(path);
			bitmapMaterials[imageId].smooth = true;
			bitmapCount++;
			
			if (bitmapCount == 1)
			{
				sphere = new Sphere({material:bitmapMaterials[imageId], radius:400, segmentsH:45, segmentsW:45});
				ctr.addChild(sphere);
			}			
		}
		

		public function rotateXTo(a:Number):void
		{
			if (a > 90)
				a = 90;
			else if (a < -90)
				a = -90;
			
			ctr.rotationX = a;
			rx = a;
		}
		
		
		public function rotateYTo(a:Number):void
		{
			a = a % 360;	
			
			sphere.rotateTo(0, a-270, 0);
			ry = a;
			dispatchEvent(new GlobeRotateEvent(GlobeRotateEvent.ROTATE, rx, ry, rz));																				
		}
		
		
		private function onSpinTimer(e:TimerEvent):void
		{
			if (playing)
				spin();
		}
		
		
		private function onEnterFrame(e:Event):void
		{
			render();
		}
		
		
		//render call
		private function render():void 
		{
			view.render();
			onPostRender();			
		}
		
		//abstract method
		protected function onPostRender():void {}		
		
		
		
		//spin on y-axis
		public function spin():void
		{
			ry += spinInc;
			rotateYTo(ry);
		}
		
		
		public function stopSpin():void
		{
			spinTimer.stop();
			spinning = false;						
		}
		
		
		//control interface
		public function axis():void
		{
			stopSpin();			
			rx = 0;
			ry = 90;
			rotateXTo(rx);
			rotateYTo(ry);		
		}		
		
		public function play():void
		{
			playing = true;
			spinTimer.start();
			spinning = true;
		}
		
		public function pause():void
		{
			playing = false;
			spinTimer.stop();
			spinning = false;			
		}
		
		
		//resize
		private function onStageResize(event: Event): void
		{
			view.width = mainStage.stageWidth;
			view.height = mainStage.stageHeight;
		}
		
		
		//script loaders
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
		
		
		
		
		public function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number 
		{
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}		
		
			
		
	}//class
}//package