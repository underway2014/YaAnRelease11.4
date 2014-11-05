package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	
	import models.AtlaMd;
	import models.EatFoodMd;
	import models.YAConst;
	
	import views.BusinessView;
	import views.FoodStreetView;
	import views.FoodView;
	
	
	public class FoodPage extends Sprite implements PageClear
	{
		private var eatmd:EatFoodMd;
		public function FoodPage(_md:EatFoodMd)
		{
			super();
			
			eatmd = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false);
			addChild(bg);
			bg.url = eatmd.bg;
			
			
			initButton();
			
		}
		private function timerYcHandler(event:TimerEvent):void
		{
		}
		private var contentSprite:Sprite;
		private var beginX:int = 0;
		private function initButton():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var arr:Array in eatmd.btnArr)
			{
				btn = new CButton(arr,false,false);
				btn.data =i;
//				btn.data =eatmd.beginIndexArr[i];
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.x = beginX + i * 640;
				addChild(btn);
				i++;
			}
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			backBtn.y = 30;
			
			contentSprite = new Sprite();
//			contentSprite.visible = false;
			addChild(contentSprite);
//			initPageButton();
			
			tjbackBtn = new CButton(barr,false);
			tjbackBtn.addEventListener(MouseEvent.CLICK,loopAtlbackHandler);
//			contentSprite.addChild(tjbackBtn);
			tjbackBtn.x = 30;
			tjbackBtn.y = 700;
			
			
			
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
		private var tjbackBtn:CButton;
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
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			contentSprite.addChild(nextBtn);
			contentSprite.addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 118) / 2 - 118 /2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 116;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAtl.next();
			}else{
				loopAtl.prev();
			}
		}
		private function timerHandler(event:TimerEvent):void
		{
			var imgArr:Array = new Array();
			var img:CImage;
			var pageSprite:Sprite;
			var i:int = 0;
			for each(var amd:AtlaMd in eatmd.altArr)
			{
				pageSprite = new Sprite();
				img = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
				img.url = amd.url;
				imgArr.push(pageSprite);
				pageSprite.addChild(img);
				img.y = 70;
				img.x = 157 + (i % 3) * (505 + 30);
				i++;
			}
			loopAtl = new LoopAtlas(imgArr,false);
			contentSprite.addChildAt(loopAtl,0);
		}
		private var loopAtl:LoopAtlas;
		private var foodstreetView:FoodStreetView;
		private var businessView:BusinessView;
		private var foodView:FoodView;
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			switch(cb.data)
			{
				case 0:
					if(!foodstreetView)
					{
						foodstreetView = new FoodStreetView(eatmd.foodStreetMd);
						contentSprite.addChild(foodstreetView);
					}else{
						foodstreetView.visible = true;
					}
					
					break;
				case 1:
					if(!foodView)
					{
						foodView = new FoodView(eatmd.foodMd);
						contentSprite.addChild(foodView);
					}else{
						foodView.visible = true;
					}
					break;
				case 2:
					if(!businessView)
					{
						businessView = new BusinessView(eatmd.businessMd);
						contentSprite.addChild(businessView);
					}else{
						businessView.visible = true;
					}
					break;
				
			}
			
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		private function loopAtlbackHandler(event:MouseEvent):void
		{
			if(contentSprite)
			{
				contentSprite.visible = false;
			}
		}
		public function clearAll():void
		{
			if(businessView)
			{
				contentSprite.removeChild(businessView);
				businessView = null;
			}
			if(foodstreetView)
			{
				contentSprite.removeChild(foodstreetView);
				foodstreetView = null;
			}
			if(foodView)
			{
				contentSprite.removeChild(foodView);
				foodView = null;
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