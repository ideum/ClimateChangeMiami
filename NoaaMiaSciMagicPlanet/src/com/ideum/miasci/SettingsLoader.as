package com.ideum.miasci 
{
	import com.ideum.miasci.Settings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SettingsLoader extends EventDispatcher 
	{	
		public function SettingsLoader() 
		{
			var fileCount:int = 2;
			var filesLoaded:int = 0;
			Settings.getInstance("global").loadSettings("./lib/settings/system/Global.xml");
			Settings.getInstance("global").addEventListener(Settings.INIT, onSettingsInit);		
			Settings.getInstance("user").loadSettings("./lib/settings/user/User.xml");
			Settings.getInstance("user").addEventListener(Settings.INIT, onSettingsInit);	
			
			function onSettingsInit(e:Event):void 
			{	
				filesLoaded++;
				e.target.removeEventListener(Settings.INIT, onSettingsInit);
				if (fileCount == filesLoaded)
					dispatchEvent(new Event(Event.INIT, true, true));
			}
		}
		
	}//class
}//package