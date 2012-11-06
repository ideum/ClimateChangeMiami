package 
{	
	import com.ideum.miasci.AMFBOOL;
	import com.ideum.miasci.AMFINT;
	import com.ideum.miasci.AMFINT2;
	import com.ideum.miasci.AMFINT3;
	import com.ideum.miasci.AMFSTR;
	import com.ideum.miasci.Client;
	import com.ideum.miasci.ConnectionStatusEvent;
	import com.ideum.miasci.DisplayEventBool;
	import com.ideum.miasci.DisplayEventInt;
	import com.ideum.miasci.DisplayEventInt2;
	import com.ideum.miasci.DisplayEventInt3;
	import com.ideum.miasci.DisplayEventStr;
	import com.ideum.miasci.DisplayManager;
	import com.ideum.miasci.FontLoader;
	import com.ideum.miasci.ObjectMessageEvent;
	import com.ideum.miasci.Settings;
	import com.ideum.miasci.SettingsLoader;
	import com.ideum.miasci.StatusWindow;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	
	import gl.events.TouchEvent;
	
	import id.core.Application;
	import id.core.TouchSprite;

	[SWF(width="1920", height="1080", backgroundColor="0x000000", framerate="30")]
	
	public class ClimateChangeKiosk extends Application 
	{
		private var fontLoader:FontLoader;		
		private var settingsLoader:SettingsLoader;
		private var displayManager:DisplayManager;
		private var client:Client;
		private var clientId:String;
		private var ip:String;		
		private var port:int;
		private var statusWindow:StatusWindow;
		
		public function ClimateChangeKiosk() 
		{
			super();
			settingsPath = "./lib/settings/system/Application.xml";
			
			//Maps the AMF class string to a local class definition					
			registerClassAlias("AMFINT", AMFINT);
			registerClassAlias("AMFINT2", AMFINT2);
			registerClassAlias("AMFINT3", AMFINT3);						
			registerClassAlias("AMFBOOL", AMFBOOL);				
			registerClassAlias("AMFSTR", AMFSTR);			
		}

		override protected function initialize():void 
		{
			fontLoader = new FontLoader();
			settingsLoader = new SettingsLoader;
			settingsLoader.addEventListener(Event.INIT, onSettingsInit);			
		}
		
		private function onSettingsInit(e:Event):void
		{
			settingsLoader.removeEventListener(Event.INIT, onSettingsInit);	
		
			clientId = Settings.getInstance('global').data.network.@username;
			ip = Settings.getInstance('global').data.network.@ip;
			port = Settings.getInstance('global').data.network.@port;			
						
			displayManager = new DisplayManager(stage);
			displayManager.clientId = clientId;
			displayManager.addEventListener(DisplayEventInt.DISPLAY_EVENT_INT, onDisplayEventInt);		
			displayManager.addEventListener(DisplayEventInt2.DISPLAY_EVENT_INT2, onDisplayEventInt2);
			displayManager.addEventListener(DisplayEventInt3.DISPLAY_EVENT_INT3, onDisplayEventInt3);			
			displayManager.addEventListener(DisplayEventBool.DISPLAY_EVENT_BOOL, onDisplayEventBool);
			displayManager.addEventListener(DisplayEventStr.DISPLAY_EVENT_STR, onDisplayEventStr);					
			addChild(displayManager);
			
			client = new Client;
			client.verbose = true;
			client.connect(ip, port, clientId);
			client.addEventListener(ObjectMessageEvent.OBJECT_RECEIVED, onObjectReceived);
			client.addEventListener(ConnectionStatusEvent.CONNECTION_UPDATE, onConnectionUpdate);
			
			statusWindow = new StatusWindow;
		}
		
		private function onObjectReceived(e:ObjectMessageEvent):void
		{
			displayManager.clientUpdate(e.message);
		}

		private function onDisplayEventInt(e:DisplayEventInt):void
		{	
			var object:AMFINT = new AMFINT(64, clientId, e.funct, e.val);
			client.sendObject("AMFINT", object);
		}
		
		private function onDisplayEventInt2(e:DisplayEventInt2):void
		{	
			var object:AMFINT2 = new AMFINT2(64, clientId, e.funct, e.val1, e.val2);
			client.sendObject("AMFINT2", object);
		}

		private function onDisplayEventInt3(e:DisplayEventInt3):void
		{	
			var object:AMFINT3 = new AMFINT3(64, clientId, e.funct, e.val1, e.val2, e.val3);
			client.sendObject("AMFINT3", object);
		}		
		
		private function onDisplayEventBool(e:DisplayEventBool):void
		{	
			var object:AMFBOOL = new AMFBOOL(64, clientId, e.funct, e.val);
			client.sendObject("AMFBOOL", object);
		}

		private function onDisplayEventStr(e:DisplayEventStr):void
		{				
			var object:AMFSTR = new AMFSTR(64, clientId, e.funct, e.val);
			client.sendObject("AMFSTR", object);
		}
		
		private function onConnectionUpdate(e:ConnectionStatusEvent):void
		{			
			if (e.message == "READY")
			{				
				if (contains(statusWindow))
					removeChild(statusWindow);				
			}
				
			else if (e.message.search("Error") != -1)
			{
				statusWindow.updateText(e.message);
				
				if (!contains(statusWindow))
					addChild(statusWindow);
			}
		}		
		
	}//class
}//package