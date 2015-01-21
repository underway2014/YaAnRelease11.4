package pages
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.IRButton;
	import core.filter.CFilter;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
	import models.YAConst;
	
	import views.TravelDetalView;
	
	public class TravelPage extends Sprite implements PageClear
	{
		public function TravelPage(arr:Array)
		{
			super();
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = "source/travel/bg.jpg";
			addChild(bgImg);
			
			init(arr);
		}
		public var spotsArray:Array;
		private function init(dataArr:Array):void
		{
			var contain:Sprite = new Sprite();
			addChild(contain);
			contain.x = 500;
			contain.y = 50;
			
			var skinarrN:Array = ["yj_n.png","ms_n.png","ls_n.png","hy_n.png","bx_n.png","yc_n.png","sm_n.png","tq_n.png"];
			var skinarrD:Array = ["yj_d.png","ms_d.png","ls_d.png","hy_d.png","bx_d.png","yc_d.png","sm_d.png","tq_d.png"];
			
			btnArrayUP = [];
			btnArrayDOWN = [];
			var btn:IRButton;
			for(var i:int = 0;i < 8;i++)
			{
				btn = new IRButton(["source/travel/" + skinarrN[i],"source/travel/" + skinarrD[i]],false,false);
				btn.data = i;
				if(i == 0)
				{
					btn.addEventListener("buttonOK",btnOkHandler);
				}
				btn.data = dataArr[i];
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				contain.addChild(btn);
				if(i == 2 || i==3 || i==6 || i==7)
				{
					btn.y = (i % 2) * (339 + 10) + 175;
					
				}else{
					
					btn.y = (i % 2) * (339 + 10);
				}
				btn.x = Math.floor(i / 2) * (290 + 15);
				if(i % 2 == 0)
				{
					btnArrayUP.push(btn);
				}else{
					btnArrayDOWN.push(btn);
				}
			}
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			addGlow();
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		private var btnArrayUP:Array;
		private var btnArrayDOWN:Array;
		private var timer:Timer;
		private function dispatchHandler(event:Event):void
		{
			dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
			autoMove();
		}
		private function autoMove():void
		{
			var downdis:int = 1300;
			var upDis:int = -400 - 175;
			for(var k:int = 0;k < btnArrayDOWN.length;k++)
			{
				if(k % 2 == 0)
				{
					TweenLite.from(btnArrayDOWN[k],.5,{y:downdis + 175,alpha:.5});
					TweenLite.from(btnArrayUP[k],.5,{y:upDis,alpha:.5});
				}else{
					TweenLite.from(btnArrayUP[k],.5,{y:upDis + 175,alpha:.5});
					TweenLite.from(btnArrayDOWN[k],.5,{y:downdis,alpha:.5});
				}
			}
		}
		private function addGlow():void
		{
			var glowTimer:Timer = new Timer(1000 * 30);
			glowTimer.addEventListener(TimerEvent.TIMER,beginGlowHandler);
			glowTimer.start();
		}
		private var crrentObj:Sprite;
		private function beginGlowHandler(event:TimerEvent):void
		{
			var randInt:int = Math.floor(Math.random() * 8);
			if(crrentObj)
			{
				crrentObj.filters = null;
			}
			if(randInt % 2 == 0)
			{
				crrentObj = btnArrayDOWN[randInt % 4];
			}else{
				crrentObj = btnArrayUP[randInt % 4];
			}
			crrentObj.filters = CFilter.glowFilter;
			
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
		private var bitmapData:BitmapData;
		private function btnOkHandler(event:Event):void
		{
			var cbb:IRButton = event.currentTarget as IRButton;
			bitmapData =new BitmapData(cbb.width,cbb.height,true,0x000000);   
			bitmapData.draw(cbb); 
		}
		private var detailView:TravelDetalView;
		private function clickHandler(event:MouseEvent):void
		{
			var cb:IRButton = event.currentTarget as IRButton;
			trace(cb.data , cb.mouseX,cb.mouseY);
			if(!bitmapData.getPixel32(cb.mouseX,cb.mouseY))
			{
				event.stopImmediatePropagation();
				trace("travel stop event");
				return;
			}
			trace("clickhandler");
			detailView = new TravelDetalView(cb.data);
			if(spotsArray)
			{
				detailView.hotspotMdArray = spotsArray;
			}
			addChild(detailView);
			detailView.addEventListener(Event.REMOVED_FROM_STAGE,clearDetailView);
		}
		private function clearDetailView(event:Event):void
		{
			if(detailView)
			{
				
				detailView = null;
			}
		}
		public function clearAll():void
		{
			if(detailView)
			{
				detailView.clear();
			}
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
			autoMove();
		}
	}
}