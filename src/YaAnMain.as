package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import Json.ParseJSON;
	import Json.WeatherXmlLoader;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.CSprite;
	import core.interfaces.PageClear;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import models.HomeMD;
	import models.KmjMd;
	import models.KmjPointMd;
	import models.WeatherMd;
	import models.YAConst;
	
	import pages.ActivePage;
	import pages.AtlasPage;
	import pages.FoodPage;
	import pages.HomePage;
	import pages.KmjPage;
	import pages.LinePage;
	import pages.MtcPage;
	import pages.TelPage;
	import pages.WldPage;
	
	import views.CMapView;
	
	[SWF(width="1920",height="1080",frameRate="30")]
	public class YaAnMain extends Sprite
	{
		public function YaAnMain()
		{
//			Mouse.hide();
//			this.addEventListener(MouseEvent.RIGHT_CLICK,doNothing);
//			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,doNothing);
//			this.addEventListener(MouseEvent.RIGHT_MOUSE_UP,doNothing);
			initData();
			
			this.addEventListener(Cevent.PAGEINIT_COMPLETE,pageInitComplete);
		}
		private var json:ParseJSON;
		private var weatherData:WeatherXmlLoader
		private function initData():void
		{
			json = new ParseJSON("source/yaAn.json");
			json.addEventListener(ParseJSON.LOAD_COMPLETE,dateOkHandler);
			
			var weatherTimer:Timer = new Timer(500,1);
			weatherTimer.addEventListener(TimerEvent.TIMER_COMPLETE,getWeather);
			weatherTimer.start();
		}
		private function doNothing(event:MouseEvent):void
		{
			
		}
		private function getWeather(event:TimerEvent):void
		{
//			http://www.weather.com.cn/data/cityinfo/101271701.html
			
//			http://flash.weather.com.cn/wmaps/xml/sichuan.xml

			weatherData = new WeatherXmlLoader();
			weatherData.loader("http://flash.weather.com.cn/wmaps/xml/sichuan.xml");
			weatherData.addEventListener(WeatherXmlLoader.LOADER_COMPLETE,weathHandler);
		}
		private var weatherName:Array = ["晴","space","space","阵雨","小雨","中雨","大雨","小雪","中雪","大雪","沙","霾","雾","尘","多云","阴"];
		private var weatherKey:Array = ["雨","雪","沙","尘"];
		private function weathHandler(event:Event):void
		{
			var md:WeatherMd = weatherData.getDataByName("雅安") as WeatherMd;
			if(!md)
			{
				md = weatherData.getDataByUrl(101271701) as WeatherMd;//101271701 代表雅安
			}
			trace("weather = ",md.cityname,md.stateDetailed);
			var index:int = 0;
			var isGet:Boolean = false;
			for each(var nstr:String in weatherName)
			{
				index++;
				if(nstr == md.stateDetailed || md.stateDetailed.indexOf(nstr) != -1)
				{
					isGet = true;
					break;
				}
			}
			if(!isGet)
			{
				index = 16;
			}
			md.icon = "source/weather/" + index + ".png";
			
			setWeatherIcon(md);
		}
		private function setWeatherIcon(md:WeatherMd):void
		{
			home.addWeatherInfo(md);
		}
		private function dateOkHandler(event:Event):void
		{
			initHomeUI();
		}
		private var home:HomePage;
		private function initHomeUI():void
		{
			var homeArr:Vector.<HomeMD> = json.getHomeData();
			home = new HomePage(homeArr);
			home.addEventListener(DataEvent.CLICK,enterHandler);
			addChild(home);
			
			
			
			btnContain = new Sprite();
//			btnContain.y = 15;
//			btnContain.graphics.beginFill(0x0,.2);
//			btnContain.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,60);
//			btnContain.graphics.endFill();
//			 var hline:Shape = new Shape();
//			 hline.graphics.beginFill(0xffc125,.8);
//			 hline.graphics.drawRect(0,56,YAConst.SCREEN_WIDTH,4);
//			 hline.graphics.endFill();
//			 btnContain.addChild(hline);
			modeContain = new Sprite();
			addChild(modeContain);
			
			btnContain.y = 990;
			addChild(btnContain);
			topContain = new Sprite();
			addChild(topContain);
//			initGuideButton();
			initNavigation();
			
			var maskshape:Shape = new Shape();
			maskshape.graphics.beginFill(0xaa0000);
			maskshape.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			maskshape.graphics.endFill();
			this.addChild(maskshape);
			this.mask = maskshape;
			
			this.addEventListener("backHome",backHomeHandler);
		}
		private var modeContain:Sprite;
		private var btnContain:Sprite;
		private var btnNameArr:Array = ["赏景点","看攻略","尝美食","玩乐地","有活动","买特产","查交通","电话簿"];
		private var homeBtnArr:Array = ["1.png","2.png","3.png","4.png","5.png","6.png","7.png","8.png"];
		private var homeBtnArrd:Array = ["1_d.png","2_d.png","3_d.png","4_d.png","5_d.png","6_d.png","7_d.png","8_d.png"];
		private var group:Group = new Group();
		
		private function initNavigation():void
		{
			var btn:CButton;
			var mainPath:String = "source/home/btn/";
			var benginX:int = 0;
			var i:int = 0;
			var lineImg:CImage;
			for each(var str:String in homeBtnArr)
			{
				btn = new CButton([mainPath + str,mainPath + homeBtnArrd[i]],false,true);
				btn.addEventListener("buttonOK",relayOutHandler);
				btnContain.addChild(btn);
				btn.x = benginX + i * 240;
//				btn.y = 968;
				btn.data = i;
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				group.add(btn);
//				lineImg = new CImage(1,72,false,false);
//				lineImg.url = "source/public/" + "line.png";
//				btnContain.addChild(lineImg);
				i++;
//				lineImg.x = benginX + i * 240;
//				lineImg.y = 20;
			}
			group.addEventListener(Cevent.SELECT_CHANGE,changeHandler);
		}
		private function clickHandler(event:MouseEvent):void
		{
			var btn:CButton =  event.currentTarget as CButton;
			group.selectByItem(btn);
		}
		private var nm:int;
		private function relayOutHandler(event:Event):void
		{
			var cb:CButton = event.currentTarget as CButton;
			trace("cb.width = " + cb.width + "cb.data = " + cb.data);
			cb.width = 240;
			nm++;
			trace("cb.width = " + cb.width + "  nm = " + nm);
		}
		private function initGuideButton():void
		{
			var txt:TextField;
			var i:int = 0;
			var tContain:CSprite;
			var format:TextFormat = new TextFormat(null,20,0xffffff,true);
			for each(var str:String in btnNameArr)
			{
				tContain = new CSprite();
				tContain.data = i;
				txt = new TextField();
				txt.mouseEnabled = txt.selectable = false;
				txt.text = str;
				txt.setTextFormat(format);
				tContain.x = i * 80 + 100;
				tContain.addEventListener(MouseEvent.CLICK,clickHandler);
				tContain.addChild(txt);
				btnContain.addChild(tContain);
				i++;
			}
		}
		private var linePage:LinePage;
		private var kmjPage:KmjPage;
		private var mapView:CMapView;
		private var wldPage:WldPage;
		private var mtcPage:MtcPage;
		private var activePage:ActivePage;
		private var telPage:TelPage;
		private var foodPage:FoodPage;
		private var currentMode:PageClear;
		private var willShowMode:PageClear;
		private function changeHandler(event:Event):void
		{
			var t:CButton = group.getCurrentObj() as CButton;
			switch(t.data)
			{
				case YAConst.SJD:
					if(!kmjPage)
					{
						kmjPage = new KmjPage(json.getKmjData());
						modeContain.addChild(kmjPage);
						willShowMode = kmjPage;
					}else{
						if(currentMode && currentMode != kmjPage)
						kmjPage.autoFall();
						clear(kmjPage);
					}
					break;
				case YAConst.KGL:
					if(!linePage)
					{
						linePage = new LinePage(json.getLineData());
						modeContain.addChild(linePage);
						willShowMode = linePage;
					}else{
						clear(linePage);
					}
					break;
				case YAConst.CMS:
					if(!foodPage)
					{
						foodPage = new FoodPage(json.getFoodData());
						modeContain.addChild(foodPage);
						willShowMode = foodPage;
					}else{
						clear(foodPage);
					}
					break;
				case YAConst.WLD:
					if(!wldPage)
					{
						wldPage = new WldPage(json.getWldData());
						modeContain.addChild(wldPage);
						willShowMode = wldPage;
					}else{
						clear(wldPage);
					}
					break;
				case YAConst.YHD:

					if(!activePage)
					{
						activePage = new ActivePage(json.getActiveData());
						modeContain.addChild(activePage);
						willShowMode = activePage;
					}else{
						clear(activePage);
					}
					break;
				case YAConst.MTC:
					if(!mtcPage)
					{
						mtcPage = new MtcPage(json.getMctData());
						modeContain.addChild(mtcPage);
						willShowMode = mtcPage;
					}else{
						clear(mtcPage);
					}
					break;
				case YAConst.CJT:
					if(!mapView)
					{
						mapView = new CMapView(new Point(103.0119,29.9848),new Point(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT),14);
						modeContain.addChild(mapView);
						willShowMode = mapView;
					}else{
						clear(mapView);
					}
					break;
				case YAConst.DHB:
					if(!telPage)
					{
						telPage = new TelPage(json.getTelData());
						modeContain.addChild(telPage);
						willShowMode = telPage;
					}else{
						clear(telPage);
					}
					
					break;
			}
		}
		private function backHomeHandler(event:Event):void
		{
			group.selectById(-1);
		}
		private function pageOkHandler(event:Event):void
		{
			var xx:Sprite = new Sprite();
			trace("page ok");
		}
		private function telok(event:Event):void
		{
			var xx:Sprite = new Sprite();
			trace("tel ok");
		}
		private var isExist:Boolean = false;
		private function clear(ss:PageClear):void
		{
			home.clearAll();
			var citem:PageClear;
			for(var k:int = 0;k < modeContain.numChildren;k++)
			{
				citem = modeContain.getChildAt(k) as PageClear;
				citem.clearAll();
				if(citem == ss)
				{
					citem.show();
				}else{
					citem.hide();
				}
				
			}
		}
		private function pageInitComplete(event:Event):void
		{
			trace("get init.");
			if(currentMode)
			{
				currentMode.hide();
				currentMode.clearAll();
			}
			currentMode = willShowMode;
		}
		private function enterHandler(event:DataEvent):void
		{
			trace(event.data[0],event.data[1]);
			if(event.data.length < 1) return;
			getDataById([event.data[0],event.data[1]]);
		}
		private var topContain:Sprite;
		private var kmjMd:KmjMd;
		private var kmjView:AtlasPage;
		private function getDataById(arr:Array):*
		{
			while(topContain.numChildren)
			{
				topContain.removeChildAt(0);
			}
			switch(arr[0])
			{
				case YAConst.MODE_SJD://赏景点
					if(!kmjMd)
					{
						kmjMd = json.getKmjData();
					}
					var atmd:KmjPointMd = kmjMd.pointArr[arr[1]];
//					kmjView = new AtlasPage(atmd.detailmd);
					kmjView.addEventListener(Event.REMOVED_FROM_STAGE,clearKmjHandler);
					topContain.addChild(kmjView);
					break;
				case YAConst.MODE_KGL://看攻略
					break;
				case YAConst.MODE_CMS://尝美食
					break;
				case YAConst.MODE_WLD://玩乐地
					break;
				case YAConst.MODE_YHD://有活动
					break;
				case YAConst.MODE_MTC://买特产
					break;
				case YAConst.MODE_CJT://查交通
					break;
				case YAConst.MODE_DHB:
					break;
				default:
					return;
			}
		}
		private function clearKmjHandler(event:Event):void
		{
			if(kmjView)
			{
				kmjView = null;
				trace('clear..');
			}
		}
	}
}