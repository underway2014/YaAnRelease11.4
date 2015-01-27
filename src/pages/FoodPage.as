package pages
{
	import com.Rippler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.effect.Rippler;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
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
		private var shapeArray:Array;
		private function initButton():void
		{
			var btn:CButton;
			var i:int = 0;
			btnArray = [];
			shapeArray = [];
			var maskShape:Shape
			for each(var arr:Array in eatmd.btnArr)
			{
				btn = new CButton(arr,false,false);
				btn.data =i;
//				btn.data =eatmd.beginIndexArr[i];
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.addEventListener("buttonOK",btnOkHandler);
				btn.x = beginX + i * 640;
				addChild(btn);
				btnArray.push(btn);
				maskShape = new Shape();
				maskShape.graphics.beginFill(0x000000,.5);
				maskShape.graphics.drawRect(0,0,640,1080);
				maskShape.graphics.endFill();
				maskShape.x = beginX + i * 640;
				shapeArray.push(maskShape);
//				addChild(maskShape);
				
				i++;
			}
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			contentSprite = new Sprite();
//			contentSprite.visible = false;
			addChild(contentSprite);
//			initPageButton();
			
			tjbackBtn = new CButton(barr,false);
			tjbackBtn.addEventListener(MouseEvent.CLICK,loopAtlbackHandler);
//			contentSprite.addChild(tjbackBtn);
			tjbackBtn.x = 30;
			tjbackBtn.y = 700;
			
			this.addEventListener("foodback",childHide);
			
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
//			autoMove();
			alphaChange();
		}
		private var count:int = 0;
		private function btnOkHandler(event:Event):void
		{
			count++;
			if(count < 3) return;
			var bdata:BitmapData = new BitmapData(1920,1080);
			bdata.draw(this);
			bitmap = new Bitmap(bdata);
			addChild(bitmap);
			rippler = new core.effect.Rippler(bitmap,60,2);
			this.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
			
			autoWaterTimer = new Timer(5000);
			autoWaterTimer.addEventListener(TimerEvent.TIMER,waterHandler);
			autoWaterTimer.start();
		}
		private function waterHandler(event:TimerEvent):void
		{
			if(ctimer) return;
				var ax:Number = Math.random() * 1500 + 100;
				var ay:Number = Math.random() * 700 + 100;
				var vx:Number = Math.random()*4 + 1;
				var vy:Number = Math.random()*4 + 1;
				var len:int = 2 + Math.random() * 30;
				xyarr = [];
				var vdir:int = 1;
				if(Math.random() > .49)
				{
					vdir = -1;
				}
				var hdir:int = 1;
				if(Math.random() > .49)
				{
					hdir = -1;
				}
				
			for(var k:int = 0;k < len;k++)
			{
				var arr:Array = new  Array(ax + hdir*k*vx*vx*vx,ay +vdir*k*vy*vy*vy);
				vdir += Math.random()*vdir;
				hdir += Math.random()*hdir;
				xyarr.push(arr);
			}
			var delayT:int = Math.random() * 300 + 100;
			ctimer = new Timer(delayT,xyarr.length);
			ctimer.addEventListener(TimerEvent.TIMER,haha);
			ctimer.addEventListener(TimerEvent.TIMER_COMPLETE,coverH);
			ctimer.start();
			
				
		}
		private var xyarr:Array;
		private var ctimer:Timer;
		private function haha(event:TimerEvent):void
		{
			trace("ctimer.currentCount=",ctimer.currentCount);
			waterMove(xyarr[ctimer.currentCount - 1][0],xyarr[ctimer.currentCount - 1][1]);
		}
		private function coverH(event:TimerEvent):void
		{
			if(ctimer)
			ctimer = null;
		}
		private var autoWaterTimer:Timer;
		private var bitmap:Bitmap;
		private var rippler:core.effect.Rippler
		private function handleMouseMove(event : MouseEvent) : void
		{
			// the ripple point of impact is size 20 and has alpha 1
			waterMove(this.mouseX, this.mouseY);
		}
		private function waterMove(wx:Number,wy:Number):void
		{
//			trace(this.mouseX,this.mouseY);
			rippler.drawRipple(wx, wy, 20, 1);
		}
		private function alphaChange():void
		{
			var kk:int = 0;
			for each(var os:Shape in shapeArray)
			{
				TweenLite.to(os,1,{delay:kk,alpha:0});
				kk += .8;
			}
		}
		private var btnArray:Array;
		private function autoMove():void
		{
			var n:int = 0;
			var delayT:Number = 0;
			for each(var ob:Sprite in btnArray)
			{
				delayT = n * .4;
				TweenLite.to(ob,1,{x:2000,delay:delayT});
				n++;
			}
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
		private function childHide(event:Event):void
		{
			if(bitmap)
			{
				bitmap.visible = true;
			}
		}
		private var loopAtl:LoopAtlas;
		private var foodstreetView:FoodStreetView;
		private var businessView:BusinessView;
		private var foodView:FoodView;
		private function clickHandler(event:MouseEvent):void
		{
			if(bitmap)
			{
				bitmap.visible = false;
			}
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
			if(bitmap)
			{
				bitmap.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
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
			if(bitmap)
			{
				bitmap.visible = false;
			}
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
			if(bitmap)
			{
				bitmap.visible = false;
			}
		}
		public function show():void
		{
			for each(var os:Shape in shapeArray)
			{
				os.alpha = .5;
			}
//			autoMove();
			this.visible = true;
			alphaChange();
			if(bitmap)
			{
				bitmap.visible = true;
			}
		}
	}
}