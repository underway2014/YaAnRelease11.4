package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.date.CDate;
	import core.interfaces.PageClear;
	
	import models.AtlaMd;
	import models.ButtonMd;
	import models.HomeMD;
	import models.PublicMd;
	import models.WeatherMd;
	import models.YAConst;
	
	import views.VideoView;
	
	public class HomePage extends Sprite implements PageClear
	{
		private var contentSprite:Sprite;
		private var loopAtlas:LoopAtlas;
		public static const HOME_LOOP_PLAYOVER:String = "homeloopplayover";
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
						btn = new CButton(bmd.skinArr,true,false);
						btn.data = bmd.data;
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
			loopAtlas.addEventListener(LoopAtlas.PLAY_OVER,loopPlayOver);
			
			initPageButton();
			
			videoContain = new Sprite();
			videoContain.visible = false;
			addChild(videoContain);
			videoContain.graphics.beginFill(0x000000,.7);
			videoContain.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			videoContain.graphics.endFill();
			
		}
		private function loopPlayOver(event:Event):void
		{
			trace("get loop play over event");
			dispatchEvent(new Event(HOME_LOOP_PLAYOVER));
		}
		private var videoContain:Sprite;
		private var tianqiImg:CImage;
		public function addWeatherInfo(md:WeatherMd):void
		{
			
			if(tianqiImg)
			{
				var tqimg:CImage = new CImage(120,110,true,false);
				tqimg.url = md.icon;
				tianqiImg.addChild(tqimg);
				tqimg.x = 200;
				tqimg.y = 200;
				
				var wformat:TextFormat = new TextFormat(null,30,0x5b554d,null);
				var temTxt:TextField = new TextField();
				temTxt.text = md.tem1 + "~" + md.tem2 + "℃";
				temTxt.width = 200;
				tianqiImg.addChild(temTxt);
				temTxt.setTextFormat(wformat);
				temTxt.x = tqimg.x + 120 + 20;
				temTxt.y = tqimg.y;
				
				
				var wformat2:TextFormat = new TextFormat(null,25,0x5b554d,null);
				var dayField:TextField = new TextField();
				dayField.text = CDate.getData();
				dayField.width = 160;
				tianqiImg.addChild(dayField);
				dayField.setTextFormat(wformat2);
				dayField.x = tqimg.x + 120 + 20;
				dayField.y = tqimg.y + 40;
				
				var wformat3:TextFormat = new TextFormat(null,20,0x5b554d,null);
				var weekField:TextField = new TextField();
				weekField.x = tqimg.x + 120 + 20;
				weekField.text = CDate.getWeek();
				weekField.y = tqimg.y + 70;
				weekField.setTextFormat(wformat3);
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
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 90 - 88) / 2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 90;
			
			
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
		private var videoView:VideoView;
		//首页图片点击
		private function enterHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
//			var cdata:DataEvent = new DataEvent(DataEvent.CLICK);
//			cdata.data = cb.data;
//			this.dispatchEvent(cdata);
			videoContain.visible = true;
			videoView = new VideoView();
			videoView.videoName = "雅安宣传片欣赏";
//			videoView.loop = true;
			videoView.addEventListener(Event.REMOVED_FROM_STAGE,clearVideo);
			videoView.addEventListener(VideoView.VIDEO_PLAY_OVER,playOverHandler);
			videoView.url = cb.data;
			videoContain.addChild(videoView); 
			videoView.x = 448;
			videoView.y = 100;
		}
		private function playOverHandler(event:Event):void
		{
			clearVideo(null);
			videoView = null;
		}
		private function clearVideo(event:Event):void
		{
//			videoView.clear();
//			videoContain.visible = false;
		}
		private var imgArr:Array;
		private function next():void
		{
			
			
		}
		public function loopReset():void
		{
			loopAtlas.gotoPage(0);
		}
		public function clearAll():void
		{
			if(videoView)
			{
				videoContain.visible = false;
				videoView.clear();
			}
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