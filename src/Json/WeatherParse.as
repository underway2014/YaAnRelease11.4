package Json
{
	
	import models.WeatherMd;

	/**
	 *解析XM 
	 * @author Administrator
	 * 
	 */
	public class WeatherParse
	{
		public function WeatherParse()
		{
		}
		private static const SAMPLE:String = "city";
		private static const CLASS:String = "class";
		public static function parse(node:XML):Object
		{
			var o:Object = null;
			o = new WeatherMd();
//			trace("00000====",node);
//			trace("1111======",node.name(),node.children());
			for each(var x:XML in node.attributes())
			{
//				trace("xxxxxxxx==",x.name(),x);
				if(x.name() == "cityname" || x.name() == "stateDetailed" || x.name() == "windState" || x.name() == "tem1" || x.name() == "tem2")
				{
					o[String(x.name())] = x;
				}
			}
			return o;
		}
	}
}
