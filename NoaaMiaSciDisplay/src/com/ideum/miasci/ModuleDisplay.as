package com.ideum.miasci 
{
	public class ModuleDisplay extends AbstractDisplay 
	{
		private var _language:String;
		public function get language():String { return _language; }
		public function set language(v:String):void { _language = v; }
		
		private var _id:int;
		public function get id():int { return _id; }
		public function set id(v:int):void { _id = v; }
		
		//for live weather
		private var dateCalculator:DateCalculator;
		private var textLayout:TextLayout;
		
		public function ModuleDisplay()
		{
			super("verticalDisplay", "userVerticalDisplay");
			_language = "english";
						
			//for live weather
			dateCalculator = new DateCalculator;
			textLayout = new TextLayout;
		}
		
		public function show(id:int):void 
		{
			_id = id;

			if (id == 4)
			{	
				generateDate();
				dict['liveWeatherStart'].visible = true;
				dict['liveWeatherEnd'].visible = true;
				dict['dateSpacer'].visible = true;
			}
			else 
			{
				dict['liveWeatherStart'].visible = false;
				dict['liveWeatherEnd'].visible = false;
				dict['dateSpacer'].visible = false;				
			}
			
			if (id == 0)
				dict['displayImage'].showId("default");	
			else
				dict['displayImage'].showId("src"+id+"-"+language);				
		}
		
		public function showLanguage(language:String):void 
		{
			_language = language;
			if (id == 0)
				dict['displayImage'].showId("default");				
			else
				dict['displayImage'].showId("src"+id+"-"+language);			
		}	
		
		//generate dates for live weather
		private function generateDate():void
		{			
			dict['liveWeatherStart'].updateText(dateCalculator.getTwoWeeksAgoDate());
			dict['liveWeatherEnd'].updateText(dateCalculator.getCurrentDate());
		}
		
	}//class
}//package