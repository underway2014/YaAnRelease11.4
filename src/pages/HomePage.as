package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.date.CDate;
	import core.interfaces.PageClear;
	import core.loadEvents.DataEvent;
	
	import models.AtlaMd;
	import models.ButtonMd;
	import models.HomeMD;
	import models.WeatherMd;
	import models.YAConst;
	
	public class HomePage extends Sprite implements PageClear
	{
		private var contentSprite:Sprite;
		private var loopAtlas:LoopAtlas;
		public function HomePage(arr:Vector.<HomeMD>)
		{
			super();
			
			contentSprite = new Sprite();
//			addChild(contentSprite);
			initContent(arr);
		}
		private function initContent(dataArr:Vector.<HomeMD>):void
		{
			var i:int = 0;
			var img:CImage;
			imgArr = new Array();
			var btn:CButton;
			for each(var md:HomeMD in dataArr)
			{
				for each(var pmd:AtlaMd in md.picArr)
				{
					img = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
					img.url = pmd.url;
					for each(var bmd:ButtonMd in pmd.btnArr)
					{
						btn = new CButton(bmd.skinArr,false,false);
						btn.data = [md.type,bmd.id];
						btn.addEventListener(MouseEvent.CLICK,enterHandler);
						img.addChild(btn);
						btn.x = bmd.coordXY.x;
						btn.y = bmd.coordXY.y;
					}
					if(md.type == "tq")//天气
					{
						tianqiImg = img;
					}
					imgArr.push(img);
				}
				
				i++;
			}
			loopAtlas = new LoopAtlas(imgArr,true);
//			loopAtlas.addEventListener(DataEvent.CLICK,enterHandler);
			addChild(loopAtlas);
			
			initPageButton();
		}
		private var tianqiImg:CImage;
		public function addWeatherInfo(md:WeatherMd):void
		{
			
			if(tianqiImg)
			{
				var tqimg:CImage = new CImage(120,120,true,false);
				tqimg.url = md.icon;
				tianqiImg.addChild(tqimg);
				tqimg.x = 300;
				tqimg.y = 300;
				
				var dayField:TextField = new TextField();
				dayField.text = CDate.getData();
				tianqiImg.addChild(dayField);
				dayField.x = 200;
				
				var weekField:TextField = new TextField();
				weekField.text = CDate.getWeek();
				tianqiImg.addChild(weekField);
			}
		}
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			addChild(nextBtn);
			addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 118) / 2 - 118 /2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 116;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAtlas.next();
			}else{
				loopAtlas.prev();
			}
		}
		//首页图片点击
		private function enterHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			var cdata:DataEvent = new DataEvent(DataEvent.CLICK);
			cdata.data = cb.data;
			this.dispatchEvent(cdata);
		}
		private var imgArr:Array;
		private function next():void
		{
			
			
		}
		public function clearAll():void
		{
			
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
		}
	}
}