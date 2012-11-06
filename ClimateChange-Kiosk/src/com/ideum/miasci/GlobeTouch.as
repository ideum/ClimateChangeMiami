package com.ideum.miasci
{
	import away3d.core.math.Quaternion;
	import away3d.core.math.Vector3DUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.ui.Mouse;
	
	import gl.events.*;
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class GlobeTouch extends Globe 
	{		
		private var intialPointX:Number = 0;		
		private var intialPointY:Number = 0;		
		
		public function GlobeTouch(stage:*)
		{
			mainStage = stage;
			super(mainStage);
			this.addEventListener(TouchEvent.TOUCH_DOWN, onTouchDown);
		}
		
		private function onTouchDown(e:TouchEvent):void
		{
			stopSpin();
			intialPointX = (ry - e.localX / 2 * -.25);	
			intialPointY = (rx - e.localY / 2 * .25);
			mainStage.addEventListener(TouchEvent.TOUCH_UP, onTouchUp);
			this.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		}				
		
		private function onTouchMove(e:TouchEvent):void
		{
			var X:Number = Math.floor(intialPointX + e.localX / 2 * -.25);	
			var Y:Number = Math.floor(intialPointY + e.localY / 2 * .25);			
			rotateXTo(Y);
			rotateYTo(X);
		}
		
		private function onTouchUp(e:TouchEvent):void
		{
			e.stopPropagation();
			this.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);							
			mainStage.removeEventListener(TouchEvent.TOUCH_UP, onTouchUp);		
		}		
		
	}//class
}//package