package Json
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.WeatherMd;

	public class WeatherJson extends EventDispatcher
	{
		public function WeatherJson(_url:String)
		{
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.load(new URLRequest(_url));//这里是你要获取JSON的路径
			urlLoader.addEventListener(Event.COMPLETE, decodeJSONHandler);
		}
		private function decodeJSONHandler(event:Event):void
		{
			var obj:Object = JSON.parse(URLLoader(event.target).data);
			parseSource(obj);
		}
		private var weathMd:WeatherMd;
		private function parseSource(data):void
		{
			weathMd = new WeatherMd();
//			weathMd.topTemp = data.temp1;
//			weathMd.lowTemp = data.temp2;
//			weathMd.desc = data.tmp_desc;
//			weathMd.icon = "";
			dispatchEvent(new Event("weatherOk"));
		}
		public function getWeatherInfo():WeatherMd
		{
			return weathMd;
		}
	}
}