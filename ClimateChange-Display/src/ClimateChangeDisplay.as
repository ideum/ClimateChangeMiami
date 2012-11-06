package  
{
	import com.ideum.miasci.ClientConnectionEvent;
	import com.ideum.miasci.DisplayManager;
	import com.ideum.miasci.FontLoader;
	import com.ideum.miasci.ObjectMessageEvent;
	import com.ideum.miasci.AMFINT;	
	import com.ideum.miasci.AMFINT2;
	import com.ideum.miasci.AMFINT3;	
	import com.ideum.miasci.AMFBOOL;
	import com.ideum.miasci.AMFSTR;
	import com.ideum.miasci.Server;
	import com.ideum.miasci.Settings;
	import com.ideum.miasci.SettingsLoader;
	import com.ideum.miasci.UpdateKioskEventBool;
	import com.ideum.miasci.UpdateKioskEventStr;
	import com.ideum.miasci.UpdateKioskEventInt;
	import com.ideum.miasci.UpdateKioskEventInt2;
	import com.ideum.miasci.UpdateKioskEventInt3;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	[SWF(width="1920", height="1080", backgroundColor="0x000000", framerate="30")]
	
	public class ClimateChangeDisplay extends Sprite 
	{
		private var fontLoader:FontLoader;		
		private var settingsLoader:SettingsLoader;
		private var displayManager:DisplayManager;
		private var server:Server;
		private var ip:String;		
		private var port:int;		
		private var clientNameList:Array = new Array();
		
		public function ClimateChangeDisplay() 
		{	
			super();
			//Maps the AMF class string to a local class definition					
			registerClassAlias("AMFINT", AMFINT);
			registerClassAlias("AMFINT2", AMFINT2);	
			registerClassAlias("AMFINT3", AMFINT3);									
			registerClassAlias("AMFBOOL", AMFBOOL);			
			registerClassAlias("AMFSTR", AMFSTR);			
			
			Mouse.hide();
			fontLoader = new FontLoader;
			settingsLoader = new SettingsLoader;
			settingsLoader.addEventListener(Event.INIT, onSettingsInit);
		}
		
		private function onSettingsInit(e:Event):void 
		{
			settingsLoader.removeEventListener(Event.INIT, onSettingsInit);			
			
			ip = Settings.getInstance('global').data.network.@ip;
			port = Settings.getInstance('global').data.network.@port;				
			
			displayManager = new DisplayManager;
			displayManager.addEventListener(UpdateKioskEventBool.KIOSK_UPDATE_BOOL, onUpdateKioskBool);						
			displayManager.addEventListener(UpdateKioskEventStr.KIOSK_UPDATE_STR, onUpdateKioskStr);	
			displayManager.addEventListener(UpdateKioskEventInt.KIOSK_UPDATE_INT, onUpdateKioskInt);
			displayManager.addEventListener(UpdateKioskEventInt2.KIOSK_UPDATE_INT2, onUpdateKioskInt2);	
			displayManager.addEventListener(UpdateKioskEventInt3.KIOSK_UPDATE_INT3, onUpdateKioskInt3);															
			addChild(displayManager);			
			
			var clientNameList:Array = ["Kiosk1", "Kiosk2", "Kiosk3", "MagicPlanet"];
			
			server = new Server;
			server.verbose = true;
			server.nameList = clientNameList;
			server.connect(ip, port);
			server.addEventListener(ClientConnectionEvent.CONNECTION_MADE, onClientConnectionMade);
			server.addEventListener(ObjectMessageEvent.OBJECT_RECEIVED, onObjectReceived);
		}
		
		private function onClientConnectionMade(e:ClientConnectionEvent):void
		{
			if (e.clientName == "MagicPlanet")
				displayManager.setupMagicPlanet();
		}
		
		private function onObjectReceived(e:ObjectMessageEvent):void
		{
			displayManager.clientUpdate(e.message);			
		}
		
		private function onUpdateKioskBool(e:UpdateKioskEventBool):void
		{			
			var object:AMFBOOL = new AMFBOOL(64, e.clientId, e.funct, e.val);
			server.sendObject(e.clientId, "AMFBOOL", object);						
		}

		private function onUpdateKioskStr(e:UpdateKioskEventStr):void
		{			
			var object:AMFSTR = new AMFSTR(64, e.clientId, e.funct, e.val);
			server.sendObject(e.clientId, "AMFSTR", object);						
		}
		
		private function onUpdateKioskInt(e:UpdateKioskEventInt):void
		{			
			var object:AMFINT = new AMFINT(64, e.clientId, e.funct, e.val);
			server.sendObject(e.clientId, "AMFINT", object);						
		}	
		
		private function onUpdateKioskInt2(e:UpdateKioskEventInt2):void
		{			
			var object:AMFINT2 = new AMFINT2(64, e.clientId, e.funct, e.val1, e.val2);
			server.sendObject(e.clientId, "AMFINT2", object);						
		}

		private function onUpdateKioskInt3(e:UpdateKioskEventInt3):void
		{			
			var object:AMFINT3 = new AMFINT3(64, e.clientId, e.funct, e.val1, e.val2, e.val3);
			server.sendObject(e.clientId, "AMFINT3", object);						
		}
		
	}//class
}//package