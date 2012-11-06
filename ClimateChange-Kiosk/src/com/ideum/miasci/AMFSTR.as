package com.ideum.miasci
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class AMFSTR implements IExternalizable 
	{
		private static var count:int = 0;
		
		public var messageId:int = 0;
		public var clientId:String = "";
		public var funct:String = "";
		public var val:String = "";		
		
		private var padding:ByteArray;
		private var data:int=0;
		
		public function AMFSTR(objectSize:Number=40, clientId:String="", funct:String="", val:String="")
		{
			registerClassAlias("AMFSTR", AMFSTR);
			
			this.clientId = clientId;
			this.funct = funct;
			this.val = val;
			
			messageId = AMFSTR.count++;
			var rawPadding:Number = objectSize - 4 - clientId.length - funct.length - val.length - 4 - 4;
			padding = createPadding(rawPadding >= 0 ? rawPadding : 0);
		}
		
		public function toString():String
		{
			return "messageId=" + messageId + 
				", clientId=" + clientId + 
				", funct= " + funct + 
				", val= " + val + 
				", padding= " + padding.length + " bytes";
		}
		
		//IExternalizable interface implementation
		public function writeExternal(output:IDataOutput):void
		{
			output.writeInt(messageId);
			output.writeUTF(clientId);
			output.writeUTF(funct);
			output.writeUTF(val);
			output.writeInt(padding.length); //write byte array size
			output.writeBytes(padding);
		}
		
		public function readExternal(input:IDataInput):void
		{
			messageId = input.readInt();
			clientId = input.readUTF();
			funct = input.readUTF();
			val = input.readUTF();
			var temp:int = input.readInt(); //read byte array size
			input.readBytes(padding, 0, temp);
		}
		
		private function createPadding(size:Number):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			for(var i:uint = 0; i < size; i++)
			{
				ba.writeByte(0xff);
			}
			return ba;
		}
		
	}//class
}//package