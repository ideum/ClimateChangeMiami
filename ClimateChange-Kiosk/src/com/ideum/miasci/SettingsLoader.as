package com.ideum.miasci {
	import com.ideum.miasci.Settings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SettingsLoader extends EventDispatcher {
		
		public function SettingsLoader(){
			var fileCount:int = 11;
			var filesLoaded:int = 0;
			Settings.getInstance("global").loadSettings("./lib/settings/system/Global.xml");
			Settings.getInstance("global").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("ui1").loadSettings("./lib/settings/system/Ui1.xml");
			Settings.getInstance("ui2").loadSettings("./lib/settings/system/Ui2.xml");
			Settings.getInstance("ui3").loadSettings("./lib/settings/system/Ui3.xml");
			Settings.getInstance("ui4").loadSettings("./lib/settings/system/Ui4.xml");
			Settings.getInstance("ui1").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("ui2").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("ui3").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("ui4").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userUi1").loadSettings("./lib/settings/user/UserUi1.xml");
			Settings.getInstance("userUi2").loadSettings("./lib/settings/user/UserUi2.xml");
			Settings.getInstance("userUi3").loadSettings("./lib/settings/user/UserUi3.xml");
			Settings.getInstance("userUi4").loadSettings("./lib/settings/user/UserUi4.xml");
			Settings.getInstance("userUi1").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userUi2").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userUi3").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userUi4").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("controlBar").loadSettings("./lib/settings/system/UiControlBar.xml");
			Settings.getInstance("controlBar").addEventListener(Settings.INIT, onSettingsInit);
			Settings.getInstance("userControlBar").loadSettings("./lib/settings/user/UserUiControlBar.xml");
			Settings.getInstance("userControlBar").addEventListener(Settings.INIT, onSettingsInit);
			
			function onSettingsInit(e:Event):void {	
				filesLoaded++;
				e.target.removeEventListener(Settings.INIT, onSettingsInit);
				if (fileCount == filesLoaded)
					dispatchEvent(new Event(Event.INIT, true, true));
			}
		}
		
	}//class
}//package