package com.ideum.miasci
{
	import flash.display.Sprite;
	
	public class DateCalculator extends Sprite
	{
		private var date:Date;
		
		public function DateCalculator()
		{
			date = new Date;
		}
		
		
		public function getCurrentDate():String
		{			
			var month:String;
			var suffix:String;
			
			month = getMonthAbbreviation(date.month);
			suffix = getNumberSuffix(date.date);					
			var dateString:String = month + " " + date.date + suffix;
			
			return dateString;
		}
		
		
		public function getTwoWeeksAgoDate():String
		{	
			var oldDate:Date = new Date();
			oldDate.time = date.time - 86400 * 1000 * 14;
			
			var month:String;
			var suffix:String;
			
			month = getMonthAbbreviation(oldDate.month);						
			suffix = getNumberSuffix(oldDate.date);					
			var dateString:String = month + " " + oldDate.date + suffix;
			
			return dateString;
		}
		
		
		public function getMonthAbbreviation(num:int):String
		{
			var month:String = "";
			
			switch (num) 
			{
				case 0: month = "JAN"; break;
				case 1: month = "FEB"; break;
				case 2: month = "MAR"; break;
				case 3: month = "APR"; break;
				case 4: month = "MAY"; break;
				case 5: month = "JUN"; break;
				case 6: month = "JUL"; break;
				case 7: month = "AUG"; break;
				case 8: month = "SEP"; break;
				case 9: month = "OCT"; break;
				case 10: month = "NOV"; break;
				case 11: month = "DEC"; break;					
			}
			
			return month;
		}
		
		
		public function getNumberSuffix(num:int):String
		{
			if (num == 0) return "";
			if (Math.floor(num / 10) % 10 === 1) return "th";
			
			num %= 10;
			if (num > 3 || num === 0) return "th";
			if (num === 1) return "st";
			if (num === 2) return "nd";
			return "rd";
		}
		
	}//class
}//package