package com.ideum.miasci 
{	
	public class FontLoader 
	{		
		[Embed(source = './lib/fonts/OpenSans-Bold.ttf', 
		fontFamily="OpenSansBold",
		embedAsCFF = 'true')]
		public var OpenSansBold:Class;			
		
		[Embed(source = './lib/fonts/OpenSans-Regular.ttf', 
		fontFamily="OpenSansRegular",
		embedAsCFF = 'true')]
		public var OpenSansRegular:Class;		
		
		[Embed(source = './lib/fonts/OpenSans-Light.ttf', 
		fontFamily="OpenSansLight",
		embedAsCFF = 'true')]
		public var OpenSanLight:Class;	
		
		[Embed(source = './lib/fonts/nobile.ttf', 
		fontFamily="Nobile",
		embedAsCFF = 'true')]
		public var Nobile:Class;	
				
		public function FontLoader(){}
		
	}//class
}//package
