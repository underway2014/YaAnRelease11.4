package Json
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.ActiveItemDetailMd;
	import models.ActiveItemMd;
	import models.ActiveMd;
	import models.AtlaMd;
	import models.BusinessMd;
	import models.ButtonMd;
	import models.EatFoodMd;
	import models.FoodMd;
	import models.FoodStreetMd;
	import models.HomeMD;
	import models.InfoMd;
	import models.KMJDetailplayMd;
	import models.KMJWalkLineMd;
	import models.KmjMd;
	import models.KmjPointDetailMd;
	import models.KmjPointMd;
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.MtcItemDetalMd;
	import models.MtcItemMd;
	import models.MtcMd;
	import models.PointMd;
	import models.PublicMd;
	import models.TelMd;
	import models.WldItemDetailMd;
	import models.WldItemMd;
	import models.WldMd;
	

	public class ParseJSON extends EventDispatcher
	{
		
		public static const LOAD_COMPLETE:String = "load_complete";
		
		private const HOME:String = "HOME";
		private const KMJ:String = "KMJ";
		private const WLD:String = "WLD";
		private const ROUTE:String = "ROUTE";
		private const MAP:String = "MAP";
		private var type:int;
		/**
		 * 
		 * @param path
		 * @param _type !0 parseInfo else  
		 * 
		 */		
		public function ParseJSON(path:String,_type:int = 0)
		{
			type = _type;
			loadJson(path);
		}
		public function loadJson(path:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,jsonLoadOkHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		private function jsonLoadOkHandler(event:Event):void
		{
			var obj:Object = JSON.parse(URLLoader(event.target).data);
			parseSource(obj);
		}
		private var homeDataArr:Vector.<HomeMD> = new Vector.<HomeMD>;
		private var activeArr:Array = new Array();
		private var lineMd:LineMd;
		private var wldMd:WldMd;
		private var kmjMd:KmjMd;
		private var mtcMd:MtcMd;
		private var activeMd:ActiveMd;
		private var eatfood:EatFoodMd;
		private var telMd:TelMd;
		private var allSpotsArr:Vector.<PointMd> = new Vector.<PointMd>;
		private function parseSource(data):void
		{
			//首页
			var homeMd:HomeMD;
			for each(var hObj:Object in data.HOME)
			{
				homeMd = new HomeMD();
				homeMd.name = hObj.name;
				homeMd.type = hObj.type;
				homeMd.picArr = new Array();
				var picmd:AtlaMd;
				for each(var pobj:Object in hObj.pictures)
				{
					picmd = new AtlaMd();
					picmd.url = pobj.url;
					picmd.btnArr = new Array();
					if(pobj.buttons && pobj.buttons != "" && pobj.buttons != "null")
					{
						var btnMd:ButtonMd;
						for each(var bobj:Object in pobj.buttons)
						{
							btnMd = new ButtonMd();
							btnMd.skinArr = bobj.skin;
							btnMd.id = bobj.id;
							picmd.btnArr.push(btnMd);
							btnMd.coordXY = new Point();
							if(bobj.coord.length > 1)
							{
								btnMd.coordXY.x = bobj.coord[0];
								btnMd.coordXY.y = bobj.coord[1];
							}
						}
					}
					homeMd.picArr.push(picmd);
				}
				homeDataArr.push(homeMd);
			}
			//all spots
			var aPointMd:PointMd;
			for each(var amd:Object in data.ALLSPOTS)
			{
				aPointMd = new PointMd();
				aPointMd.name = amd.name;
				aPointMd.pointXY = new Point(amd.coordX,amd.coordY);
				aPointMd.audioUrl = amd.audio;
				aPointMd.background = amd.background;
				aPointMd.atlasArr = new Array();
				var atmd:AtlaMd;
				for each(var aobj:Object in amd.atlas)
				{
					atmd = new AtlaMd();
					atmd.name = aobj.name;
					atmd.url = aobj.url;
					aPointMd.atlasArr.push(atmd);
				}
				allSpotsArr.push(aPointMd);
			}
			
			
			//好线路
			lineMd = new LineMd();
			var lineData:Object = data.LINE;
			lineMd.bg = lineData.background;
			lineMd.desc = lineData.desc;
			lineMd.pageArr = new Array();
			var pageMd:LinePageMd;
			for each(var obj:Object in lineData.page)
			{
				pageMd = new LinePageMd();
				pageMd.name = obj.name;
				pageMd.bg = obj.background;
				pageMd.itemArr = new Array();
				var lineItemMd:LineItemMd;
				for each(var iobj:Object in obj.items)
				{
					lineItemMd = new LineItemMd();
					lineItemMd.name = iobj.name;
					lineItemMd.skin = iobj.skin;
					lineItemMd.coordXY = new Point();
					lineItemMd.coordXY.x = iobj.coordXY[0];
					lineItemMd.coordXY.y = iobj.coordXY[1];
					lineItemMd.detail = iobj.detail;
					pageMd.itemArr.push(lineItemMd);
				}
				lineMd.pageArr.push(pageMd);
			}
			
			///玩乐地
			wldMd = new WldMd();
			var wldData:Object = data.WLD;
			wldMd.name = wldData.name;
			wldMd.background = wldData.background;
			wldMd.itemArr = new Array();
			var wlditemMd:WldItemMd;
			for each(var po:Object in wldData.items)
			{
				wlditemMd = new WldItemMd();
				wlditemMd.name = po.name;
				wlditemMd.url = po.url;
				wlditemMd.skinsArr = po.skin;
				
				wlditemMd.detailArr = new Array();
				var dMd:WldItemDetailMd;
				for each(var dobj:Object in po.detail)
				{
					dMd = new WldItemDetailMd();
					dMd.name = dobj.name;
					dMd.url = dobj.url;
					dMd.coordXY = new Point();
					dMd.coordXY.x = dobj.coordXY[0];
					dMd.coordXY.y = dobj.coordXY[1];
					dMd.skin = dobj.skin;
//					wlditemMd.skinsArr.push(dobj.skin);
					wlditemMd.detailArr.push(dMd);
				}
				
				wldMd.itemArr.push(wlditemMd);
			}
			
			//赏景点
			kmjMd = new KmjMd();
			var kmjData:Object = data.SJD;
			kmjMd.name = kmjData.name;
			kmjMd.map = kmjData.map;
			kmjMd.bg = kmjData.background;
			kmjMd.explain = kmjData.explain;
			kmjMd.pointArr = new Array();
			var kmjSpotMd:KmjPointMd;
			var currType:int = 0;
			var x:int = 0;
			for each(var ko:Object in kmjData.points)
			{
				kmjSpotMd = new KmjPointMd();
				kmjSpotMd.name = ko.name;
				kmjSpotMd.pointXY = new Point(ko.coordX,ko.coordY);
				kmjSpotMd.skinArr = ko.skin;
				kmjSpotMd.detailmd = new KmjPointDetailMd();
				kmjSpotMd.detailmd.headArr = ko.detail.head;
				kmjSpotMd.detailmd.name = ko.detail.name;
				kmjSpotMd.detailmd.bg = ko.detail.background;
				kmjSpotMd.detailmd.desc = ko.detail.desc;
				
				if(i > 0)
				{
					kmjMd.pointArr.push(kmjSpotMd);
					continue;
				}
//				kmjMd.pointArr.push(kmjSpotMd);
//				continue;
				//景区美食推荐
				kmjSpotMd.detailmd.recomend = new Array();
				var pbmd:PublicMd;
				for each(var remd:Object in ko.detail.recomend)
				{
					pbmd = new PublicMd();
					pbmd.icon = remd.icon;
					pbmd.name = remd.name;
					pbmd.desc = remd.desc;
					pbmd.other = remd.other;
					kmjSpotMd.detailmd.recomend.push(pbmd);
				}
				
				//游玩体验
				var tiyanObj:Object = ko.detail.play;
				kmjSpotMd.detailmd.play = new KMJDetailplayMd();
				kmjSpotMd.detailmd.play.title = tiyanObj.title;
				kmjSpotMd.detailmd.play.desc = tiyanObj.desc;
				kmjSpotMd.detailmd.play.items = new Array();
				var tyMd:PublicMd;
				for each(var tyO:Object in tiyanObj.items)
				{
					tyMd = new PublicMd();
					tyMd.title = tyO.title;
					tyMd.icon = tyO.icon;
					tyMd.desc = tyO.desc;
					kmjSpotMd.detailmd.play.items.push(tyMd);
				}
				
				//步行线路
				kmjSpotMd.detailmd.walkLine = new Array();
				var bxMd:KMJWalkLineMd;
				for each(var bxo:Object in ko.detail.walkLine)
				{
					bxMd = new KMJWalkLineMd();
					bxMd.cost = bxo.cost;
					bxMd.desc = bxo.dsc;
					bxMd.time = bxo.time;
					bxMd.icon = bxo.icon;
					bxMd.name = bxo.name;
					kmjSpotMd.detailmd.walkLine.push(bxMd);
				}
				
				//info 
				kmjSpotMd.detailmd.info = new InfoMd();
				kmjSpotMd.detailmd.info.icon = ko.detail.info.icon;
				kmjSpotMd.detailmd.info.desc = ko.detail.info.desc;
				
				
				kmjMd.pointArr.push(kmjSpotMd);
				
				x++;
				var i:int = 0;
				i++;
				if(i > 0)
				{
//					break;
				}
			}
			
			
			//买特产
			var mtcData:Object = data.MTC;
			mtcMd = new MtcMd();
			mtcMd.bg = mtcData.background;
			mtcMd.itemArr = new Array();
			
			var mtcItemMd:MtcItemMd;
			for each(var mtc:Object in mtcData.items)
			{
				mtcItemMd = new MtcItemMd();
				mtcItemMd.name = mtc.name;
				mtcItemMd.skin = mtc.skin;
				mtcItemMd.itemArr = new Array();
				
				var mdetalMd:MtcItemDetalMd;
				for each(var ide:Object in mtc.items)
				{
					mdetalMd = new MtcItemDetalMd();
					mdetalMd.skin = ide.skin;
					mdetalMd.detail = ide.detail;
					
					mtcItemMd.itemArr.push(mdetalMd);
				}
				mtcMd.itemArr.push(mtcItemMd);
			}
			
			
			///活动
			var actData:Object = data.ACTIVITY;
			activeMd = new ActiveMd();
			activeMd.name = actData.name;
			activeMd.bg = actData.background;
			activeMd.itemArr = new Array();
			
			var acitem:ActiveItemMd;
			for each(var aco:Object in actData.items)
			{
				acitem = new ActiveItemMd();
				acitem.name = aco.name;
				acitem.desc = aco.desc;
				acitem.label = aco.label;
				acitem.content = aco.detail;
				acitem.coordXY = new Point();
				acitem.coordXY.x = aco.coordXY[0];
				acitem.coordXY.y = aco.coordXY[1];
				acitem.son = new ActiveItemDetailMd();
				acitem.son.bg = aco.son.background;
				acitem.son.content = aco.son.content;
				activeMd.itemArr.push(acitem);
			}
			
			// 吃美食
			
			var eatData:Object = data.EATFOOD;
			eatfood = new EatFoodMd();
			eatfood.bg = eatData.background;
			eatfood.dsc = eatData.desc;
			eatfood.btnArr = new Array();
			eatfood.altArr = new Array();
			eatfood.beginIndexArr = new Array();
			
			//美食街
			var foodstreetData:Object = eatData.footstreet;
			eatfood.btnArr.push(foodstreetData.skin);
			eatfood.foodStreetMd = new FoodStreetMd();
			eatfood.foodStreetMd.bg = foodstreetData.background;
			eatfood.foodStreetMd.itemArr = new Array();
			var altmd:AtlaMd;
			var num:int = 0;
			eatfood.beginIndexArr.push(num);
			for each(var imd:Object in foodstreetData.items)
			{
				altmd = new AtlaMd();
				altmd.url = imd.picture;
				eatfood.foodStreetMd.itemArr.push(altmd);
				num++;
			}
			trace("num = ",num);
			eatfood.beginIndexArr.push(num);
			
			//美食
			var foodData:Object = eatData.food;
			eatfood.btnArr.push(foodData.skin);
			eatfood.foodMd = new FoodMd();
			eatfood.foodMd.bg = foodData.background;
			eatfood.foodMd.itemArr = new Array();
			for each(var fmd:Object in foodData.items)
			{
				altmd = new AtlaMd();
//				altmd.name = fmd.name;
//				altmd.desc = fmd.dsc;
				altmd.url = fmd.picture;
				eatfood.foodMd.itemArr.push(altmd);
				num++;
			}
			trace("num2 = ",num);
			eatfood.beginIndexArr.push(num);
			
			
			//商业
			var busData:Object = eatData.business;
			eatfood.btnArr.push(busData.skin);
			eatfood.businessMd = new BusinessMd();
			eatfood.businessMd.bg = busData.background;
			eatfood.businessMd.itemArr = new Array();
			for each(var bo:Object in busData.items)
			{
				altmd = new AtlaMd();
				altmd.url = bo.picture;
				eatfood.businessMd.itemArr.push(altmd);
			}
			
			// 电话簿
			
			telMd = new TelMd();
			var telData:Object = data.TEL;
			telMd.name = telData.name;
			telMd.contentArr = telData.content;
			telMd.dsc = telData.desc;
			
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("json load wrong!");
		}
		public function getHomeData():Vector.<HomeMD>
		{
			return homeDataArr;
		}
		public function getLineData():LineMd
		{
			return lineMd;
		}
		public function getWldData():WldMd
		{
			return wldMd;
		}
		public function getKmjData():KmjMd
		{
			return kmjMd;
		}
		public function getFoodData():EatFoodMd
		{
			return eatfood;
		}
		public function getActiveData():ActiveMd
		{
			return activeMd;
		}
		public function getTelData():TelMd
		{
			return telMd;
		}
		public function getMctData():MtcMd
		{
			return mtcMd;
		}
	}
}