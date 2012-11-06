package
{
	import com.ideum.miasci.AMFBOOL;
	import com.ideum.miasci.AMFINT;
	import com.ideum.miasci.AMFINT2;
	import com.ideum.miasci.AMFINT3;
	import com.ideum.miasci.AMFSTR;
	import com.ideum.miasci.Client;
	import com.ideum.miasci.ConnectionStatusEvent;
	import com.ideum.miasci.MagicPlanet;
	import com.ideum.miasci.ObjectMessageEvent;
	import com.ideum.miasci.Settings;
	import com.ideum.miasci.SettingsLoader;
	import com.ideum.miasci.StringMessageEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ClimateChangeMagicPlanet extends Sprite
	{
		private var settingsLoader:SettingsLoader;				
		private var client:Client;		
		private var clientId:String;
		private var ip:String;
		private var port:int;
		private var verbose:Boolean;
		private var magicPlanet:MagicPlanet;		
		private var debugText:TextField;
		
		public function ClimateChangeMagicPlanet()
		{
			super();

			//Maps the AMF class string to a local class definition					
			registerClassAlias("AMFINT", AMFINT);
			registerClassAlias("AMFINT2", AMFINT2);	
			registerClassAlias("AMFINT3", AMFINT3);						
			registerClassAlias("AMFBOOL", AMFBOOL);				
			registerClassAlias("AMFSTR", AMFSTR);
			
			//load external XML setttings
			settingsLoader = new SettingsLoader;
			settingsLoader.addEventListener(Event.INIT, onSettingsInit);
		}
		
		//xml settings files loaded
		private function onSettingsInit(e:Event):void
		{
			//network settings
			clientId = Settings.getInstance('global').data.network.@username;
			ip = Settings.getInstance('global').data.network.@ip;
			port = Settings.getInstance('global').data.network.@port;
			verbose = (Settings.getInstance('global').data.network.@verbose == "true") ? true : false;
			
			//create client connection
			client = new Client;
			client.verbose = verbose;				
			client.connect(ip, port, clientId);
			client.addEventListener(ObjectMessageEvent.OBJECT_RECEIVED, onObjectReceived);
			client.addEventListener(StringMessageEvent.STRING_RECEIVED, onStringReceived);
			client.addEventListener(ConnectionStatusEvent.CONNECTION_UPDATE, onConnectionUpdate);
			
			//prints messages to stage
			debugText = new TextField;
			debugText.width = 800;
			debugText.multiline = true;
			addChild(debugText);
			
			//create magic planet interface
			magicPlanet = new MagicPlanet;
			magicPlanet.setRotationRate(Settings.getInstance('global').data.attractMode.@rotationRate);
		}
		
		//serialized object received from server (called from client object)
		private function onObjectReceived(e:ObjectMessageEvent):void
		{
			//print message 
			if (verbose) debugText.text = e.message.toString();	
			
			//parse messages
			if (e.message.funct == "moduleSelection") moduleSelection(e.message.val);			
			else if (e.message.funct == "axis") magicPlanet.resetAxis();			
			else if (e.message.funct == "rewind") magicPlanet.rewind();
			else if (e.message.funct == "play") magicPlanet.play();
			else if (e.message.funct == "forward") magicPlanet.forward();
			else if (e.message.funct == "pause") magicPlanet.pause();
			else if (e.message.funct == "reset") magicPlanet.reset();
			else if (e.message.funct == "rotate") magicPlanet.rotate(e.message.val1, e.message.val2, e.message.val3);
			else if (e.message.funct == "autoRotate") magicPlanet.autoRotate(e.message.val);
		}

		//string received from server (called from client object)
		private function onStringReceived(e:StringMessageEvent):void
		{
			//print message
			debugText.text = e.message;
		}
		
		//parse module selection
		private function moduleSelection(module:int):void
		{
			var chapter:String;
			var page:String;
			
			if (module == 0)
			{
				chapter = Settings.getInstance('user').data.moduleDefault.@chapter;
				page = Settings.getInstance('user').data.moduleDefault.@page;
				magicPlanet.defaultFrameRate = Settings.getInstance('user').data.moduleDefault.@defaultFrameRate;
				magicPlanet.minFrameRate = Settings.getInstance('user').data.moduleDefault.@minFrameRate; 
				magicPlanet.maxFrameRate = Settings.getInstance('user').data.moduleDefault.@maxFrameRate; 				
			}
			else
			{
				chapter = Settings.getInstance('user').data['module'+module].@chapter;
				page = Settings.getInstance('user').data['module'+module].@page;
				magicPlanet.defaultFrameRate = Settings.getInstance('user').data['module'+module].@defaultFrameRate;
				magicPlanet.minFrameRate = Settings.getInstance('user').data['module'+module].@minFrameRate; 
				magicPlanet.maxFrameRate = Settings.getInstance('user').data['module'+module].@maxFrameRate;				
			}	
			
			magicPlanet.showName(chapter, page);			
			magicPlanet.resetAxis();			
			magicPlanet.play();
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
		}
		
		//this is a temporary fix for a bug in the new StoryTeller software, where you can't make quick calls to set FrameRate after showName();
		private var timer:Timer = new Timer(1000, 1);
		
		private function onComplete(e:TimerEvent):void{
			magicPlanet.setFrameRate(magicPlanet.defaultFrameRate);	
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);			
		}
		
				
		private function onConnectionUpdate(e:ConnectionStatusEvent):void
		{
			debugText.text = e.message;	
		}
		
	}//class
}//package