package com.ideum.miasci {
	import com.ideum.miasci.Settings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SettingsLoader extends EventDispatcher {
		
		public function SettingsLoader() {
			var fileCount:int = 5;
			var filesLoaded:int = 0;
			Settings.getInstance("global").loadSettings("./lib/settings/system/Global.xml");
			Settings.getInstance("global").addEventListener(Settings.INIT, onSettingsInit);			
			Settings.getInstance("horizontalDisplay").loadSettings("./lib/settings/system/HorizontalDisplay.xml");
			Settings.getInstance("horizontalDisplay").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userHorizontalDisplay").loadSettings("./lib/settings/user/UserHorizontalDisplay.xml");
			Settings.getInstance("userHorizontalDisplay").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("verticalDisplay").loadSettings("./lib/settings/system/VerticalDisplay.xml");
			Settings.getInstance("verticalDisplay").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userVerticalDisplay").loadSettings("./lib/settings/user/UserVerticalDisplay.xml");
			Settings.getInstance("userVerticalDisplay").addEventListener(Settings.INIT, onSettingsInit);
			
			function onSettingsInit(e:Event):void {	
				filesLoaded++;
				e.target.removeEventListener(Settings.INIT, onSettingsInit);
				if (fileCount == filesLoaded)
					dispatchEvent(new Event(Event.INIT, true, true));
			}
		}
		
	}//class
}//package