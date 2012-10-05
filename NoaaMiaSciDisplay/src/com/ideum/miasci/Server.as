package com.ideum.miasci
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	public class Server extends EventDispatcher
	{
		private var serverSocket:ServerSocket;
		private var socketService:SocketService;
		private var clientSockets:Array = new Array();
		private var clientNames:Dictionary = new Dictionary(true);

		private var _ip:String;
		public function get ip():String { return _ip; }
		public function set ip(v:String):void { _ip = v; }
		
		private var _port:int;
		public function get port():int { return _port; }
		public function set port(v:int):void { _port = v; }			
		
		private var _verbose:Boolean;
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(v:Boolean):void { _verbose = v; }	
		
		public var nameList:Array = new Array;
			
		public function Server()
		{
			//Trace output
			verbose = false;			
			
			// Create the server socket
			serverSocket = new ServerSocket;
			
			// Add the event listener
			serverSocket.addEventListener(Event.CONNECT, connectHandler);
			serverSocket.addEventListener(Event.CLOSE, onClose);
		}
		
		public function addToNameList(name:String):void
		{
			nameList.push(name);
		}
		
		//Bind
		public function connect(ip:String="127.0.0.1", port:int=8087):void
		{
			try
			{	
				_ip = ip;
				_port = port;
				
				serverSocket.bind(port, ip);
				
				// Listen for connections
				serverSocket.listen();
				if (verbose)
					trace("Listening on " + serverSocket.localPort);
			}
			catch(e:Error)
			{
				trace(e);
			}			
		}
		
		
		public function connectHandler(e:ServerSocketConnectEvent):void
		{
			//The socket is provided by the event object
			socketService = new SocketService(e.socket);
			socketService.verbose = verbose;
			socketService.nameList = nameList;
			socketService.addEventListener(HandshakeEvent.HANDSHAKE_COMPLETE, onHandshakeComplete);

			//maintain a reference to prevent premature garbage collection
			clientSockets.push(socketService);
		}
		
		
		private function onHandshakeComplete(e:HandshakeEvent):void
		{			
			clientNames[e.clientName] = socketService;	
			
			socketService.removeEventListener(HandshakeEvent.HANDSHAKE_COMPLETE, onHandshakeComplete);			
			socketService.addEventListener(Event.CLOSE, onClientClose);
			socketService.addEventListener(ObjectMessageEvent.OBJECT_RECEIVED, onObjectReceived);
			socketService.addEventListener(StringMessageEvent.STRING_RECEIVED, onStringReceived);			
			
			dispatchEvent(new ClientConnectionEvent(ClientConnectionEvent.CONNECTION_MADE, e.clientName));																
		}
		
		//Send a serialized object to to a specific client or use all
		public function sendObject(clientName:String="all", type:String="", object:Object=null):void
		{
			if (clientName == "all")
			{
				for (var i:int=0; i<clientSockets.length; i++)
				{	
					clientSockets[i].sendObject(object);
				}
			}
			
			else
			{
				if (clientNames[clientName])
					clientNames[clientName].sendObject(type, object);			
			}
		}
		

		//Send a string
		public function sendString(text:String):void
		{
			socketService.sendString(text);
		}
		
		public function onObjectReceived(e:ObjectMessageEvent):void
		{
			dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, e.message));														
		}

		public function onStringReceived(e:StringMessageEvent):void
		{
			dispatchEvent(new StringMessageEvent(StringMessageEvent.STRING_RECEIVED, e.message));
		}
		
		private function onClientClose(e:Event):void
		{
			//Nullify references to closed sockets
			for each(var servicer:SocketService in clientSockets)
			{
				if (servicer.closed) servicer = null;
			}
		}
		
		
		private function onClose(e:Event):void
		{
			trace("Server socket closed by OS.");
		}
		
	}//class
}//package