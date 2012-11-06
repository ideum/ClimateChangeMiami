package com.ideum.miasci
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.*;
	import flash.text.*;
	
	public class MagicPlanet extends Sprite
	{
		public static var CALL_BACK:String="java call back";
		public static var SEND_FRAME_NUMBER:String="java send frame number";
		public static var SEND_ANIMATION_DATA:String="send animation data"
		
		public var rotating:Boolean;
		public var rotRate:Number;
		public var fraRate:Number;
		public var angRate:Number;
		public var currFrame:int;
		public var deg:Number=90;
		
		public var defaultFrameRate:int;
		public var minFrameRate:int;
		public var maxFrameRate:int;
		private var currentFrameRate:int;

		public function MagicPlanet()
		{		
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("JStoASviaExternalInterface", recieveJavaData);
				ExternalInterface.addCallback("JavaReturnFrameInt", get_Frame_Data);
				ExternalInterface.addCallback("JavaReturnAnimationExist", get_Animation_Data);
			}
			
			if (ExternalInterface.available) 
				ExternalInterface.call("jsfunction");
			
		}
		
		private function recieveJavaData():void
		{
			dispatchEvent(new Event(MagicPlanet.CALL_BACK));
		}
		
		public function call_Java_for_Frames():void
		{
			ExternalInterface.call("getFrame");
		}
		
		public function get_Frame_Data(r:Boolean,rr:Number,frame:int,frameRate:Number):void
		{
			rotRate=rr;
			rotating=r;
			currFrame=frame;
			fraRate=frameRate;
			dispatchEvent(new Event(MagicPlanet.SEND_FRAME_NUMBER));
		}
		
		public function get_Animation_Data(frame:Number):void
		{
			currFrame=frame;
			dispatchEvent(new Event(MagicPlanet.SEND_ANIMATION_DATA));
		}
		
		//show story teller chapter and page by string
		public function showName(chapterName:String, pageName:String):void
		{
			ExternalInterface.call("ShowName", chapterName, pageName);
		}		
		
		//show story teller chapter and page by index number
		public function showIndex(chapterNumber:int, pageNumber:int):void
		{	
			ExternalInterface.call("ShowIndex", chapterNumber, pageNumber);	
		}
		
		//reset rotation angles
		public function resetAxis():void
		{
			ExternalInterface.call("ResetAxis");
		}		
		
		//auto-rotate switch
		public function autoRotate(value:Boolean):void
		{
			if (value) rotateStart();
			else rotateStop();
		}
	
		//reset rotation angles
		public function rotateStart():void
		{
			ExternalInterface.call("RotateStart");
		}	
		
		//reset rotation angles
		public function rotateStop():void
		{
			ExternalInterface.call("RotateStop");
		}			
		
		//reset animations
		public function reset():void
		{
			setFrameRate(defaultFrameRate);
			play();			
		}
		
		//go to first frame of animation
		public function firstFrame():void
		{
			ExternalInterface.call("FirstFrame");
		}
		
		//pause animation
		public function pause():void
		{
			ExternalInterface.call("Pause");
		}
		
		//play animation
		public function play():void
		{
			ExternalInterface.call("Play");
		}
		
		//decrease frame rate
		public function rewind():void
		{
			currentFrameRate--;
			if (currentFrameRate < minFrameRate)
				currentFrameRate = minFrameRate;
			setFrameRate(currentFrameRate);
		}		

		//increase frame rate
		public function forward():void
		{
			currentFrameRate++;
			if (currentFrameRate > maxFrameRate)
				currentFrameRate = maxFrameRate;
			setFrameRate(currentFrameRate);		
		}			
		
		//set frame rate
		public function setFrameRate(rate:int):void
		{
			currentFrameRate = rate;
			ExternalInterface.call("SetFrameRate", rate);
		}
		
		//set rotation rate
		public function setRotationRate(rate:int):void
		{
			ExternalInterface.call("SetRotationRate", rate);
		}	
		
		//set rotation angles
		public function rotate(rx:int, ry:int, rz:int):void
		{			
			ExternalInterface.call("Rotate", rx, ry, rz);			
		}

		//tilt
		public function tilt(degrees:Number):void
		{
			deg=degrees;
			if (deg == 0)
				ExternalInterface.call("North");
			else if (deg == 180)
				ExternalInterface.call("South");
			else
				ExternalInterface.call("Tilt", deg);
		}
		
		//previous page
		public function prev():void
		{
			ExternalInterface.call("PreviousPage()");
		}
		
		//next page
		public function next():void
		{
			ExternalInterface.call("NextPage()");
		}
		
		
		//////////////////////////////////////////
		// External Interface Callbacks
		//////////////////////////////////////////
		public function animationExists():void
		{
			ExternalInterface.call("SetFrameToOne");
		}
		
		public function callframeRate():void
		{
			ExternalInterface.call("getFrameRate");
		}
		
		public function get rotationAngle():Number
		{
			return ExternalInterface.call("getRotationAngle");
		}
		
		public function get rotationRate():Number
		{
			return ExternalInterface.call("getRotationRate");
		}
		
		private function onStatus(e:StatusEvent):void {}				
	}
}