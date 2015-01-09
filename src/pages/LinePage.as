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
	import core.baseComponent.LoopAtlas;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	import core.tween.TweenLite;
	
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.YAConst;
	
	import views.LineView;
	
	
	public class LinePage extends Sprite implements PageClear
	{
		private var lineData:LineMd;
		private var map_width:int = 1080;
		private var map_height:int = 400;
		private var alphaMask:Sprite;
		private var drag:CDrag;
		private var contain:Sprite;
		public function LinePage(_lineData:LineMd)
		{
			super();
			
			lineData = _lineData;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = lineData.bg;
			addChild(bgImg);
			
			contain = new Sprite();
//			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
//			drag.target = contain;
			addChild(contain);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 90;
			backBtn.y = 20;
			
			init();
			
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
			nextBtn.x = YAConst.SCREEN_WIDTH - 84;
			
			
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
				TweenLite.from(nb,1,{rotationX:500,alpha:.0,x:1400,y:100,scaleX:.1,scaleY:.1,delay:delayT,onComplete:moveOver});
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