package com.ideum.miasci
{
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class Client extends EventDispatcher
	{
		public const TYPE_AMF:int = 0;
		public const TYPE_STRING:int = 1;		
		public const TYPE_AMFINT:int = 2;
		public const TYPE_AMFINT2:int = 3;
		public const TYPE_AMFINT3:int = 4;						
		public const TYPE_AMFBOOL:int = 5;
		public const TYPE_AMFSTR:int = 6;
		
		private var _ip:String;
		public function get ip():String { return _ip; }
		public function set ip(v:String):void { _ip = v; }
		
		private var _port:int;
		public function get port():int { return _port; }
		public function set port(v:int):void { _port = v; }		

		private var _name:String;
		public function get name():String { return _name; }
		public function set name(v:String):void { _name = v; }	
		
		private var _verbose:Boolean;
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(v:Boolean):void { _verbose = v; }	
		
		private var socket:Socket;
		private var retryTimer:Timer;
		private var messageLength:int;
		private var sendReply:Boolean;
		
		
		public function Client()
		{
			messageLength = 0;
			
			//Trace output
			verbose = false;
			
			//Sends a reply back to the server when a message is received
			sendReply = false;
			
			//Create socket and attach event listeners
			socket = new Socket(); 
			socket.addEventListener(Event.CONNECT, connectionMade);
			socket.addEventListener(Event.CLOSE, connectionClosed);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketFailure);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, handshake);		
		}
		
		
		//Connect to the server
		public function connect(ip:String="127.0.0.1", port:int=8087, name:String="anonymous"):void
		{
			_ip = ip;
			_port = port;
			_name = name;
			
			retryTimer = new Timer(1000);
			retryTimer.addEventListener(TimerEvent.TIMER, connectToServer);
			retryTimer.start();				
		}
		
		
		//Connect to the server
		private function connectToServer(event:TimerEvent):void
		{
			try
			{
				//Try to connect
				socket.connect(ip, port);			
			}
			catch(e:Error)
			{
				trace(e.toString());
			}			
		}
		
		
		//Handle connect event
		private function connectionMade(e:Event):void
		{
			//Send initialization string
			socket.writeUTFBytes(name);
			socket.flush();
			
			//Stop retry timer
			retryTimer.removeEventListener(TimerEvent.TIMER, connectToServer);
			retryTimer.stop();
		}
		
		
		//Initial handshake handler
		private function handshake(e:ProgressEvent):void 
		{ 
			try
			{
				//Read UTF string from the socket
				var message:String = socket.readUTFBytes(socket.bytesAvailable);
				
				if (verbose)
					trace("Received: " + message); 
				
				//Look for targeted response
				if (message == "READY")
				{
					socket.removeEventListener(ProgressEvent.SOCKET_DATA, handshake);
					socket.addEventListener(ProgressEvent.SOCKET_DATA, dataReceived);
					dispatchEvent(new ConnectionStatusEvent(ConnectionStatusEvent.CONNECTION_UPDATE, "READY"));														
				}				
			}
			catch(e:Error)
			{
				trace(e.toString());
			}
		}			
		
		
		//Read and parse incoming data
		private function dataReceived(event:ProgressEvent):void 
		{ 				
			//Read the data from the socket
			try
			{	
				while(socket.bytesAvailable >= 4)
				{
					//If start of a new message -> read the message length header
					if (messageLength == 0)
						messageLength = socket.readUnsignedInt(); 
					
					//If the sokect contains the full message
					if (messageLength <= socket.bytesAvailable) 
					{
						//Read the message type header
						var typeFlag:int = socket.readInt(); 
						
						//Read the message based on the type
						if (typeFlag == TYPE_AMFINT) //AMF object
						{
							var dataMessageInt:AMFINT = socket.readObject() as AMFINT;
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + dataMessageInt.toString());
							
							if (sendReply)
								reply("Echo: " + dataMessageInt.toString());
							
							dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, dataMessageInt));							
						}
						else if (typeFlag == TYPE_AMFINT2) //AMF object
						{
							var dataMessageInt2:AMFINT2 = socket.readObject() as AMFINT2;
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + dataMessageInt2.toString());
							
							if (sendReply)
								reply("Echo: " + dataMessageInt2.toString());
							
							dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, dataMessageInt2));							
						}
						else if (typeFlag == TYPE_AMFINT3) //AMF object
						{
							var dataMessageInt3:AMFINT3 = socket.readObject() as AMFINT3;
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + dataMessageInt3.toString());
							
							if (sendReply)
								reply("Echo: " + dataMessageInt3.toString());
							
							dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, dataMessageInt3));							
						}						
						else if (typeFlag == TYPE_AMFBOOL) //AMF object
						{
							var dataMessageBool:AMFBOOL = socket.readObject() as AMFBOOL;
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + dataMessageBool.toString());
							
							if (sendReply)
								reply("Echo: " + dataMessageBool.toString());
							
							dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, dataMessageBool));							
						}
						else if (typeFlag == TYPE_AMFSTR) //AMF object
						{
							var dataMessageStr:AMFSTR = socket.readObject() as AMFSTR;
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + dataMessageStr.toString());
							
							if (sendReply)
								reply("Echo: " + dataMessageStr.toString());
							
							dispatchEvent(new ObjectMessageEvent(ObjectMessageEvent.OBJECT_RECEIVED, dataMessageStr));							
						}						
						else if (typeFlag == TYPE_STRING) //UTF string
						{
							var utfMessage:String = socket.readUTF();
							
							if (verbose)
								trace(socket.remoteAddress + ":" + socket.remotePort + " sent " + utfMessage);
							
							//sends a reply back to the server
							if (sendReply)
								reply("Echo: " + utfMessage);
							
							dispatchEvent(new StringMessageEvent(StringMessageEvent.STRING_RECEIVED, utfMessage));														
						}
						//finished reading this message
						messageLength = 0; 
					}
					else 
					{
						//The current message isn't complete -- wait for the socketData event and try again						
						if (sendReply)
							reply("Partial message: " + socket.bytesAvailable + " of " + messageLength);
						break;
					}
				}
			}
			catch (e:Error)
			{
				trace(e);
			}			
		}		
		
		
		//Reply
		private function reply(message:String):void
		{
			if(message != null)
			{
				socket.writeUTFBytes(message);
				socket.flush();
				if (verbose)
					trace("Sending: " + message);
			}						
		}
		
		//Send a serialized object
		public function sendObject(type:String, object:Object):void
		{
			var bytes:ByteArray = new ByteArray();
			
			//message type
			if (type == "AMFINT") 
				bytes.writeInt(TYPE_AMFINT);
			else if (type == "AMFINT2") 
				bytes.writeInt(TYPE_AMFINT2);
			else if (type == "AMFINT3") 
				bytes.writeInt(TYPE_AMFINT3);			
			else if (type == "AMFBOOL") 
				bytes.writeInt(TYPE_AMFBOOL); 
			else if (type == "AMFSTR") 
				bytes.writeInt(TYPE_AMFSTR); 
			
			bytes.writeObject(object);
			bytes.position = 0;
			
			try
			{
				//Write the headers
				socket.writeUnsignedInt(bytes.length); //message length 
				
				//Serialize the object to the socket
				socket.writeBytes(bytes);
				
				//Make sure it is sent 
				socket.flush();
				
			} 
			catch (e:Error)
			{
				trace(e.toString());
			}
			
			bytes.position = 0;
			
			if (verbose)
				trace("Sending: " + object.toString());
		}
		
		//Send a string
		public function sendString(text:String):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeInt(TYPE_STRING); //message type
			bytes.writeObject(text);
			bytes.position = 0;
			
			try
			{
				//Write the length
				socket.writeUnsignedInt(bytes.length);
				
				//Write the string to the socket
				socket.writeBytes(bytes);
				
				//Make sure it is sent
				socket.flush();
				
			} 
			catch (e:Error)
			{
				trace(e.toString());
			}
			
			trace("Sending: " + text);
		}
		
		private function connectionClosed(event:Event):void
		{
			trace("Connection closed by server.");
			reconnect();
		}
		
		private function socketFailure(error:IOErrorEvent):void
		{
			trace(error.text);
			dispatchEvent(new ConnectionStatusEvent(ConnectionStatusEvent.CONNECTION_UPDATE, error.text));														

		}
		
		private function securityError(event:SecurityErrorEvent):void
		{
			trace(event.text);
		}
		
		private function reconnect():void
		{
			if (!retryTimer.running) {
				socket.addEventListener(ProgressEvent.SOCKET_DATA, handshake);						
				retryTimer.addEventListener(TimerEvent.TIMER, connectToServer);			
				retryTimer.start();		
			}				
		}		
		
	}//class
}//package