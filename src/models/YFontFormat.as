package models
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class YFontFormat
	{
		public function YFontFormat()
		{
		}
		public static var normalSize:int = 24;
		
//		public static var mainTitle:TextFormat = new TextFormat(null,30,0x000000,true,null,null,null,null,TextFormatAlign.CENTER,null,null,null,-5);//
		public static var mainTitle:TextFormat = new TextFormat(null,34,0x000000,true);//
		public static var mainDsc:TextFormat = new TextFormat(null,normalSize,0x000000,null,null,null,null,null,null,null,null,normalSize * 2,10);
	
		public static var modeTitle:TextFormat = new TextFormat(null,30,0x000000,true);
	
		public static var kmjRecomendTitle:TextFormat = new TextFormat(null,28,0xffffff,true,null,null,null,null,TextFormatAlign.CENTER);
	
		public static var kmjRecomendDsc:TextFormat = new TextFormat(null,normalSize,null,null,null,null,null,null,null,null,normalSize * 2,10);
		
		public static var kmjRecomendOther:TextFormat = new TextFormat(null,normalSize,0xffffff);
		
		
	}
}