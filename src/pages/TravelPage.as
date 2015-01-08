package pages
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CImage;
	import core.baseComponent.IRButton;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	
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
			}
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
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
		}
	}
}