package com.ideum.miasci
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class AMFINT2 implements IExternalizable 
	{
		private static var count:int = 0;
		
		public var messageId:int = 0;
		public var clientId:String = "";
		public var funct:String = "";
		public var val1:int = 0;		
		public var val2:int = 0;		
		
		private var padding:ByteArray;
		private var data:int=0;
		
		public function AMFINT2(objectSize:Number=40, clientId:String="", funct:String="", val1:int=0, val2:int=0)
		{
			registerClassAlias("AMFINT2", AMFINT2);
			
			this.clientId = clientId;
			this.funct = funct;
			this.val1 = val1;
			this.val2 = val2;
			
			messageId = AMFINT2.count++;
			var rawPadding:Number = objectSize - 4 - clientId.length - funct.length  - 4 - 4 - 4 - 4;
			padding = createPadding(rawPadding >= 0 ? rawPadding : 0);
		}
		
		public function toString():String
		{
			return "messageId=" + messageId + 
				", clientId=" + clientId + 
				", funct= " + funct + 
				", val1= " + val1 + 
				", val2= " + val2 + 				
				", padding= " + padding.length + " bytes";
		}
		
		//IExternalizable interface implementation
		public function writeExternal(output:IDataOutput):void
		{
			output.writeInt(messageId);
			output.writeUTF(clientId);
			output.writeUTF(funct);
			output.writeInt(val1);
			output.writeInt(val2);			
			output.writeInt(padding.length); //write byte array size
			output.writeBytes(padding);
		}
		
		public function readExternal(input:IDataInput):void
		{
			messageId = input.readInt();
			clientId = input.readUTF();
			funct = input.readUTF();
			val1 = input.readInt();
			val2 = input.readInt();			
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