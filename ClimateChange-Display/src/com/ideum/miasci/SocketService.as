package com.ideum.miasci
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class SocketService extends EventDispatcher
	{
		public const TYPE_AMF:int = 0;
		public const TYPE_STRING:int = 1;		
		public const TYPE_AMFINT:int = 2;
		public const TYPE_AMFINT2:int = 3;		
		public const TYPE_AMFINT3:int = 4;				
		public const TYPE_AMFBOOL:int = 5;
		public const TYPE_AMFSTR:int = 6;
		
		private var _closed:Boolean;
		public function get closed():Boolean { return socket.connected; }		

		private var _verbose:Boolean;
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(v:Boolean):void { _verbose = v; }	
				
		private var socket:Socket;
		private var messageLength:int;
		
		private var sendReply:Boolean;
		
		public var name:String;
		public var nameList:Array;
	
		public function SocketService(socket:Socket)
		{
			messageLength = 0;
			nameList = new Array;

			//Trace output
			verbose = false;
			
			//Sends a reply back to the client when a message is received
			sendReply = false;
			
			this.socket = socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, handshake);
			socket.addEventListener(Event.CLOSE, onClientClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			if (verbose)			
				trace("Connected to " + socket.remoteAddress + ":" + socket.remotePort);		
		}
		
		//Initial handshake handler
		private function handshake(event:ProgressEvent):void
		{
			socket = event.target as Socket;
			
			//Read the message from the socket
			var message:String = socket.readUTFBytes(socket.bytesAvailable);
			if (verbose)
				trace("Received: " + message);
			if(message == "<policy-file-request/>")
			{
				var policy:String = '<cross-domain-policy><allow-access-from domain="*" to-ports="8087" /></cross-domain-policy>\x00';
				socket.writeUTFBytes(policy);
				socket.flush();
				socket.close();
				if (verbose)
					trace("Sending policy: " + policy);
			} 
			
			else
			{
				for (var i:int=0; i<nameList.length; i++)
				{	
					if (message == nameList[i])
					{
						name = nameList[i];
						socket.removeEventListener(ProgressEvent.SOCKET_DATA, handshake);
						socket.addEventListener(ProgressEvent.SOCKET_DATA, dataReceived);
						socket.writeUTFBytes("READY");
						socket.flush();
						
						dispatchEvent(new HandshakeEvent(HandshakeEvent.HANDSHAKE_COMPLETE, name));																										
					}
				}	
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
		
		//client connection close
		private function onClientClose(event:Event):void
		{
			var socket:Socket = event.target as Socket;
			if (verbose)
				trace("Connection to client " + socket.remoteAddress + ":" + socket.remotePort + " closed.");
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		//io error
		private function onIOError(errorEvent:IOErrorEvent):void
		{
			trace("IOError: " + errorEvent.text);
			socket.close();
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
			
			if (verbose)		
				trace("Sending: " + text);
		}		
	}//class
}//package