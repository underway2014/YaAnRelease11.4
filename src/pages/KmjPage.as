package pages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display3D.textures.CubeTexture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
	import models.KmjMd;
	import models.KmjPointDetailMd;
	import models.KmjPointMd;
	import models.YAConst;
	
	import views.KmjDetailView;
	import views.TravelDetalView;
	
	public class KmjPage extends Sprite implements PageClear
	{
		private var kmjMd:KmjMd;
		private var drag:HScroller;
		private var navagation:Sprite;
		public function KmjPage(_md:KmjMd)
		{
			super();
			
			kmjMd = _md;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = kmjMd.bg;
			addChild(bgImg);
			
			var whiteBorder:Shape = new Shape();
			whiteBorder.graphics.beginFill(0xffffff);
			whiteBorder.graphics.drawRect(0,0,1727,YAConst.SCREEN_HEIGHT - 170 + 30);
			whiteBorder.graphics.endFill();
//			addChild(whiteBorder);
			
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			drag = new HScroller(1920,YAConst.SCREEN_HEIGHT - 170,sbar);
			addChild(drag);
			drag.barX = drag.width + 32;
			var contain:Sprite = new Sprite();
			drag.target = contain;
//			drag.x = 97;
			drag.y = 40;//50
			
			whiteBorder.y = drag.y - 20;
			whiteBorder.x = drag.x;
			
			var mapImg:CImage = new CImage(1920,2977,false,false);
			mapImg.url = kmjMd.map;
			contain.addChild(mapImg);
			
			btnContain = new Sprite();
			contain.addChild(btnContain);
			
//			var explainImg:CImage = new CImage(239,137,false,false);
//			explainImg.url = "source/lookSpot/explain.png";
//			addChild(explainImg);
//			explainImg.x = 117;
//			explainImg.y = 73;
			
//			var timer:Timer = new Timer(100,1);
//			timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			timer.start();
			
			timerHandler(null);
		}
		private function timerHandler(event:TimerEvent):void
		{
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			navagation = new Sprite();
			addChild(navagation);
			navagation.x = 100;
			navagation.y = 50;
			
//			initBar();
			
			initAlphaButton();
		}
		private var items:Array = ["1.png","2.png","3.png","4.png"]
		private function initBar():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var str:String in items)
			{
				btn = new CButton(["source/lookSpot/" + str,"source/lookSpot/" + str],false,false);
				btn.addEventListener(MouseEvent.CLICK,changeCity);
				btn.x += 175 * i;
				navagation.addChild(btn);
				i++;
			}
		}
		private function changeCity(event:MouseEvent):void
		{
			trace();
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		private var btnContain:Sprite;
		private function initAlphaButton():void
		{
			
			detailSprte = new Sprite();
			detailSprte.graphics.beginFill(0x000000,.3);
			detailSprte.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			detailSprte.graphics.endFill();
			detailSprte.visible = false;
			addChild(detailSprte);
			
			var btn:CButton;
			btnArr = new Array();
			var kk:int = 0;
			var iconImg:CImage;
			var j:int = 0;
			for each(var kmd:KmjPointMd in kmjMd.pointArr)
			{
				btn = new CButton([kmd.skinArr[0],kmd.skinArr[1]],false,false);
//				btn = new CButton(kmd.skinArr,false,false);
//				btn.graphics.beginFill(0xaa0000,0.2);t
//				btn.graphics.drawRect(0,0,150,65);
//				btn.graphics.endFill();
				
				
				
				if(kmd.dir == 0)//7个区县
				{
					btn.x = kmd.pointXY.x - 28;
					btn.y = kmd.pointXY.y - 36;
					btn.data = qxdataIndexArr[j];
					btn.addEventListener(MouseEvent.CLICK,enterQX);
					j++;
				}else{
					iconImg = new CImage(43,58,false,false);
					iconImg.url = "source/lookSpot/button/icon.png";
					btnContain.addChild(iconImg);
					iconImg.x = kmd.pointXY.x - 22;
					iconImg.y = kmd.pointXY.y - 29;
					if(kmd.dir == 1)
					{
						btn.x = iconImg.x + 48;
						btn.y = iconImg.y;
					}else{
						btn.x = iconImg.x - 5;
						btn.y = iconImg.y;
						btn.addEventListener("buttonOK",buttonLoadOKHandler);
					}
					btn.data = kmd;
					btn.addEventListener(MouseEvent.CLICK,clickAlphaButton);
				}
				
				btnContain.addChild(btn);
				
//				btn.x = kmd.pointXY.x - 97;
//				btn.y = kmd.pointXY.y - 34;
//				btn.x = Math.random() * 1700 + 100;
//				btn.y = Math.random() * 900 + 50;
				if(kk == 0)
				{
					cumd = kmd.detailmd;
				}
				btnArr.push(btn);
				kk++;
			}
			autoFall();
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
		private function buttonLoadOKHandler(event:Event):void
		{
			var cb:CButton = event.currentTarget as CButton;
			cb.x -= cb.width;
		}
		private var qxdataIndexArr:Array = [0,1,2,3,4,7,6];
		private var qxdetailView:TravelDetalView;
		/*
		 *进入对应的区县 
		*/
		private function enterQX(event:MouseEvent):void
		{
			var qbtn:CButton = event.currentTarget as CButton;
			if(qbtn.data >= qxDataArr.length) return;
			qxdetailView = new TravelDetalView(qxDataArr[qbtn.data]);
			if(spotsArray)
			{
				qxdetailView.hotspotMdArray = spotsArray;
			}
			addChild(qxdetailView);
			qxdetailView.addEventListener(Event.REMOVED_FROM_STAGE,clearQXView);
			
		}
		private function clearQXView(event:Event):void
		{
			if(qxdetailView)
			{
				
				qxdetailView = null;
			}
		}
		public var spotsArray:Array;
		public var qxDataArr:Array;
		private var detailSprte:Sprite;
		private var timer:Timer;
		private function dispatchHandler(event:Event):void
		{
			dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
		}
		private function timerComplete(event:TimerEvent):void
		{
			if(timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,dispatchHandler);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
				timer = null;
			}
		}
		private var btnArr:Array;
		public function autoFall():void
		{
			for each(var btn:Sprite in btnArr)
			{
				TweenLite.from(btn,1,{y:-100,onComplete:tweenOve});
			}
		}
		private var cumd:KmjPointDetailMd;
		private function initSpotButton():void
		{
			var btn:CButton;
			var kk:int = 0;
			for each(var kmd:KmjPointMd in kmjMd.pointArr)
			{
				btn = new CButton(kmd.skinArr,false);
				btn.x = kmd.pointXY.x;
				btn.y = kmd.pointXY.y;
				if(kk == 0)
				{
					cumd = kmd.detailmd;
				}
				btn.data = kmd.detailmd;
				btnContain.addChild(btn);
				TweenLite.to(btn,1,{y:kmd.pointXY.y,delay:1,onComplete:tweenOve});
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				kk++;
			}
		}
		private var tn:int = 0;
		private function tweenOve():void
		{
			tn++;
			if(tn >= kmjMd.pointArr.length)
			{
				
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
//			var atlasPage:AtlasPage = new AtlasPage(cumd);
//			addChild(atlasPage);
		}
		private var detailView:KmjDetailView;
		private function clickAlphaButton(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			detailView = new KmjDetailView(cb.data);
			detailView.addEventListener(Event.REMOVED_FROM_STAGE,clearDetailView);
			detailSprte.addChild(detailView);
			detailSprte.visible = true;
		}
		private function clearDetailView(event:Event):void
		{
			if(detailView)
			{
				detailView = null;
			}
			detailSprte.visible = false;
		}
		public function clearAll():void
		{
			detailSprte.visible = false;
			if(qxdetailView)
			{
				qxdetailView.clear();
			}
			if(detailView)
			{
				detailView.clear();
			}
			drag.reset();
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
			autoFall();
		}
	}
}