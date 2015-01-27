package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
	import models.KmjPointMd;
	import models.LinSpotNameMd;
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.YAConst;
	
	import views.KmjDetailView;
	import views.LineView;
	
	
	public class LinePage extends Sprite implements PageClear
	{
		private var lineData:LineMd;
		private var map_width:int = 1080;
		private var map_height:int = 400;
		private var alphaMask:Sprite;
		private var drag:CDrag;
		private var contain:Sprite;
		public var spotsArray:Array;
		private var nameContain:Sprite;
		private var spotContain:Sprite;
		public function LinePage(_lineData:LineMd)
		{
			super();
			
			lineData = _lineData;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = lineData.bg;
			addChild(bgImg);
			
			nameContain = new Sprite();
			addChild(nameContain);
			
			contain = new Sprite();
//			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
//			drag.target = contain;
			addChild(contain);
			
			
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			init();
			initNameButton();
			
		}
		private function initNameButton():void
		{
			var nbtn:CButton;
			nameBtnArr = [];
			for each(var nmd:LinSpotNameMd in lineData.spotsArr)
			{
				nbtn = new CButton([nmd.pic,nmd.pic],true,false);
				nbtn.data = int(nmd.data);
				nbtn.addEventListener(MouseEvent.CLICK,enterSpot);
				nameContain.addChild(nbtn);
				nameBtnArr.push(nbtn);
				randomCoor(nbtn);
			}
			
			var nameTimer:Timer = new Timer(1000 * 10);
			nameTimer.addEventListener(TimerEvent.TIMER,nameAutoMove);
			nameTimer.start();
		}
		private var nameBtnArr:Array;
		private function nameAutoMove(event:TimerEvent):void
		{
			var rd:int = Math.floor(Math.random() * nameBtnArr.length);
			var rd2:int = 0;
			if(rd > 1)
			{
				rd2 = rd -1;
			}else{
				rd2 = rd + 1;
			}
			
			var b1:CButton = nameBtnArr[rd];
			if(!b1.isMoveing && isMovingNum < 2)
			{
				singleMove(b1);
				isMovingNum++;
			}
			
			var b2:CButton = nameBtnArr[rd2];
			if(!b2.isMoveing && isMovingNum < 2)
			{
				singleMove(b2);
				isMovingNum++;
			}
			
		}
		private var scaleSpeed:Number = .1;
		private var moveDis:int = 150;
		private function singleMove(cobj:CButton):void
		{
			cobj.isMoveing = true;
			var encdScale:Number;
			var endXY:Point = new Point();
			var disScale:Number = Math.random() / 6;
			if(Math.random() > .4999)//+
			{
				encdScale = cobj.scaleX + disScale;
				endXY.x = cobj.x + disScale * moveDis;
			
			}else{
				encdScale = cobj.scaleX - disScale;
				endXY.x = cobj.x - disScale * moveDis;
			}
			var r3:Number = Math.random();
			if(r3 >= .4999)
			{
				endXY.y = cobj.y + r3 * moveDis;
			}else{
				endXY.y = cobj.y - r3 * moveDis;
			}
			if(endXY.x < 0)
			{
				endXY.x = 0;
			}else if(endXY.x > 1200 - 120)
			{
				endXY.x = 1080;
			}
			if(endXY.y > 770)
			{
				endXY.y = 770;
			}else if(endXY.y <= 380)
			{
				endXY.y = 380;
			}
			
			if(encdScale > 1.25)
			{
				encdScale = 1.25;
			}else if(encdScale < .75){
				encdScale = .75;
			}
			
			TweenLite.to(cobj,4,{scaleX:encdScale,scaleY:encdScale,alpha:encdScale,x:endXY.x,y:endXY.y,onComplete:moveOverHandler,onCompleteParams:[cobj]});
		}
		private var isMovingNum:int = 0;
		private function moveOverHandler(ocb:CButton):void
		{
			if(checkoutIsDJ(ocb))
			{
				singleMove(ocb);
			}else{
				ocb.isMoveing = false;	
				isMovingNum--;
			}
		}

		/*是否叠加到一起了，
		 * 
		*/
		private function checkoutIsDJ(nobj:CButton):Boolean//
		{
			for each(var nb:CButton in nameBtnArr)
			{
				if(nobj != nb && !nb.isMoveing)
				{
					if(nobj.hitTestObject(nb))
					{
						return true;
					}
				}
			}
			return false;
		}
		private function randomCoor(obj:Sprite):void
		{
			var scaleXY:int = 0;
			obj.x = Math.random() * (YAConst.SCREEN_WIDTH - 830) + 70;
			obj.y = Math.random() * (YAConst.SCREEN_HEIGHT - 550) + 450;
			scaleXY = int(Math.random() / 6 * 100);
			if(Math.random() > .499)
			{
				obj.alpha = obj.scaleX = obj.scaleY = 1 - scaleXY / 100.0;
				
			}else{
				obj.scaleX = obj.scaleY = 1 + scaleXY / 100.0;
			}
		}
		private var spotDetailView:KmjDetailView;
		private function enterSpot(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			trace(cb.data);
			if(spotsArray && spotsArray.length > cb.data)
			{
				var hmd:KmjPointMd = spotsArray[cb.data];
				spotDetailView = new KmjDetailView(hmd);
				spotDetailView.addEventListener(Event.REMOVED_FROM_STAGE,clearDetailView);
				spotContain.addChild(spotDetailView);
				spotContain.visible = true;
			}
		}
		private function clearDetailView(event:Event):void
		{
			if(spotDetailView)
			{
				spotDetailView = null;
			}
			spotContain.visible = false;
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
			nextBtn.y = prevBtn.y = 184;
			nextBtn.x = YAConst.SCREEN_WIDTH - 84;
			
			spotContain = new Sprite();
			addChild(spotContain);
			
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
		private var loopAtl:LoopAtlas;
		private function init():void
		{
			var sArr:Array = new Array();
			var psprite:Sprite;
			
			btnArray = [];
			var pageImg:CImage;
			var i:int = 0;
			var beginX:int = 172
			for each(var pmd:LinePageMd in lineData.pageArr)
			{
				psprite = new Sprite();
				i = 0;
				var btn:CButton;
				for each(var pimd:LineItemMd in pmd.itemArr)
				{
					btn = new CButton(pimd.skin,true,false);
					btn.x = beginX + (512 + 20) * i + 256;
					btn.y = 100 + 128;
					pimd.bg = pmd.bg;
					btn.data = pimd;
					psprite.addChild(btn);
					btn.addEventListener(MouseEvent.CLICK,clickHandler);
					i++;
					if(btnArray.length < 3)
					{
						btnArray.push(btn);
					}
				}
				sArr.push(psprite);
			}
			loopAtl = new LoopAtlas(sArr,false);
			loopAtl.size = new Point(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			contain.addChild(loopAtl);
			initPageButton();
			
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
		private var btnArray:Array;
		private var k:int = 0;
		private function autoMove():void
		{
			k = 0;
			var nbtn:CButton = btnArray[k];
			var delayT:Number = 0;
			for each(var nb:Sprite in btnArray)
			{
				delayT = k * .4;
				TweenLite.from(nb,.7,{rotationX:500,alpha:.0,x:1000,y:100,scaleX:.1,scaleY:.1,delay:delayT,onComplete:moveOver});
				k++;
			}
		}
		private function moveOver():void
		{
			trace("line move over..");
		}
		private var timer:Timer;
		private function dispatchHandler(event:Event):void
		{
			autoMove();
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
		private var detailView:LineView;
		private function clickHandler(event:MouseEvent):void
		{
			trace("line page btn click..");
			var cb:CButton = event.currentTarget as CButton;
			detailView = new LineView(cb.data);
			addChild(detailView);
			detailView.addEventListener(Event.REMOVED_FROM_STAGE,setDetailNull);
		}
		private function setDetailNull(event:Event):void
		{
			if(detailView)
			{
				detailView = null;
			}
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		public function clearAll():void
		{
			if(detailView)
			{
				detailView.parent.removeChild(detailView);
			}
			if(spotDetailView)
			{
				spotDetailView.clear();
			}
		}
		public function hide():void
		{
			loopAtl.gotoPage(0);
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
			autoMove();
		}
		
	}
}