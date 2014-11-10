package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.baseComponent.CImage;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
	import models.KmjMd;
	import models.KmjPointDetailMd;
	import models.KmjPointMd;
	import models.YAConst;
	
	import views.KmjDetailView;
	
	public class KmjPage extends Sprite implements PageClear
	{
		private var kmjMd:KmjMd;
		private var drag:CDrag;
		private var navagation:Sprite;
		public function KmjPage(_md:KmjMd)
		{
			super();
			
			kmjMd = _md;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = kmjMd.bg;
			addChild(bgImg);
			
			drag = new CDrag(1727,YAConst.SCREEN_HEIGHT - 50);
			addChild(drag);
			var contain:Sprite = new Sprite();
			drag.target = contain;
			drag.x = 97;
			drag.y = 50;
			
			var mapImg:CImage = new CImage(1727,2693,false,false);
			mapImg.url = kmjMd.map;
			contain.addChild(mapImg);
			
			btnContain = new Sprite();
			contain.addChild(btnContain);
			
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
			backBtn.x = YAConst.SCREEN_WIDTH - 90;
			backBtn.y = 20;
			
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
			for each(var kmd:KmjPointMd in kmjMd.pointArr)
			{
				btn = new CButton([kmd.skinArr[0],kmd.skinArr[0]],false,false);
//				btn = new CButton(kmd.skinArr,false,false);
//				btn.graphics.beginFill(0xaa0000,0.2);
//				btn.graphics.drawRect(0,0,150,65);
//				btn.graphics.endFill();
				btnContain.addChild(btn);
				btn.x = kmd.pointXY.x;
				btn.y = kmd.pointXY.y;
//				btn.x = Math.random() * 1700 + 100;
//				btn.y = Math.random() * 900 + 50;
				if(kk == 0)
				{
					cumd = kmd.detailmd;
				}
				btn.data = kmd.detailmd;
				btnArr.push(btn);
				btn.addEventListener(MouseEvent.CLICK,clickAlphaButton);
				kk++;
			}
			autoFall();
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
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
			detailView = new KmjDetailView(cumd);
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
			if(detailView && detailView.parent)
			{
				detailView.parent.removeChild(detailView);
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