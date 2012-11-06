package com.ideum.miasci 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
		
	public class VideoElement extends Sprite
	{
		private var _src:String;
		public function get src():String { return _src; }
		public function set src(v:String):void { _src = v; }		
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var video:Video;
		private var videoObject:Object;
		private var firstTime:Boolean;
		
		public function VideoElement()
		{
			super();
			firstTime = true;
			nc = new NetConnection;			
			videoObject = new Object;
		}
		
		public function load(path:String):void 
		{
			_src = path;
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)			
			nc.connect(null);						
		}		

		public function unload():void 
		{
			if (nc) {
				nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)			
				nc.close();
				//nc = null;
			}
			if (ns) {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onVideoStatus);			
				ns.close();
				//ns.dispose();
				//ns = null;
			}
			
			//if (videoObject){
			//	videoObject = null;;
			//}
		}			
		
		private function netStatusHandler(e:NetStatusEvent):void 
		{
			switch (e.info.code) 
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video: " + _src);
					break;
			}
		}
		
		private function connectStream():void 
		{
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onVideoStatus);
			
			var customClient:Object = new Object;			
			customClient.onMetaData = metaDataHandler;		
			ns.client = customClient;
			
			video = new Video();
			video.attachNetStream(ns);
			
			ns.play(_src);
		}		
		
		private function onVideoStatus(e:Object):void
		{
			if (e.info.code == "NetStream.Play.Start")
			{
				back();
			}
				
			else if (e.info.code == "NetStream.Seek.Notify")
			{
			}
				
			else if (e.info.code == "NetStream.Play.Stop")
			{
				ns.seek(0);
				ns.resume();				
			}
				
			else if (e.info.code == "NetStream.Play.NoSupportedTrackFound")
			{
				trace("Video not supported: "  + _src);
			}
		}		
		
		private function metaDataHandler(info:Object):void
		{
			if(firstTime) 
			{					
				video.width = video.videoWidth;
				video.height = video.videoHeight;
				
				addChild(video);
				
				width = video.width;
				height = video.height;
				firstTime = false;
			}
			
			videoObject = info;			
		}
		
		public function play():void
		{
			ns.resume();
		}
		
		public function pause():void
		{
			ns.pause();
		}
		
		public function back():void
		{
			ns.seek(0);
			ns.pause();
		}
		
		public function forward():void
		{
			ns.seek(ns.time+2);
		}		
		
	}//class
}//package