package pages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.baseComponent.LoopAtlas;
	import core.interfaces.PageClear;
	import core.loadEvents.CLoader;
	import core.loadEvents.Cevent;
	
	import models.WldItemMd;
	import models.WldMd;
	import models.YAConst;
	
	public class WldPage extends Sprite implements PageClear
	{
		private var md:WldMd;
		private var contain:Sprite;
		public function WldPage(_md:WldMd)
		{
			super();
			md = _md;
			
			contain = new Sprite();
			
			var img:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			img.url = md.background;
			this.addChild(img);
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN,YAConst.SCREEN_HEIGHT - 150);
//			hscroll.target = contain;
			hscroll.x = 200;
//			addChild(hscroll);
			addChild(contain);
			contain.x = 200;
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 84;
			backBtn.y = 20;
			
//			var timer:Timer = new Timer(100,1);
//			timer.addEventListener(TimerEvent.TIMER,timerYcHandler);
//			timer.start();
			
			detailSprite = new Sprite();
			addChild(detailSprite);
			imgContain = new Sprite();
//			detailSprite.addChild(imgContain);
			scroller = new HScroller(1690,905,sbar);
			scroller.target = imgContain;
			scroller.barX = 1574 + 67;
			var detailBg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			detailBg.url = "source/play/detail/bg.jpg";
			detailSprite.addChild(detailBg);
			var dbg:Shape = new Shape();
			dbg.graphics.beginFill(0xffffff,1);
			dbg.graphics.drawRoundRect(0,-15,1574,905 + 30,20,20);
			dbg.graphics.endFill();
			detailSprite.addChild(dbg);
			detailSprite.visible = false;
			detailSprite.addChild(scroller);
			dbg.x = scroller.x = 177;
			dbg.y = scroller.y = 35;
//			
//			var carr:Array = ["source/public/close.png","source/public/close.png"];
//			var closeBtn:CButton = new CButton(carr,false,false);
//			closeBtn.addEventListener(MouseEvent.CLICK,closeDetail);
//			detailSprite.addChild(closeBtn);
//			closeBtn.x = 1574 + 177 - 72 + 35;
//			closeBtn.y = 0;
			
//			var arr1:Array = ["source/public/back_up.png","source/public/back_up.png"];
			closeDetailBtn = new CButton(arr,false);
			closeDetailBtn.addEventListener(MouseEvent.CLICK,closeDetail);
			detailSprite.addChild(closeDetailBtn);
			closeDetailBtn.x = YAConst.SCREEN_WIDTH - 84;
			closeDetailBtn.y = 20;
//			closeDetailBtn.visible = false;
			
//			detailSprite.x = 115;
//			detailSprite.y = 50;
			
			initContent();
		}
		private var closeDetailBtn:CButton;
		private var scroller:HScroller;
		private function timerYcHandler(event:TimerEvent):void
		{
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		private var beginY:int = 70;
		private var radius:int = 10;
		private function initContent():void
		{
			var btn:CButton;
			var i:int = 0;
			var lineShape:Shape = new Shape();
			lineShape.graphics.lineStyle(2,0xffffff);
			for each(var wmd:WldItemMd in md.itemArr)
			{
				btn = new CButton(wmd.skinsArr,false,false);
				btn.addEventListener(MouseEvent.CLICK,enterDetailHandler);
				btn.data = wmd.url;
				contain.addChild(btn);
				if(i % 2 == 0)
				{
					btn.x = 485;
				}else{
					btn.x = 910;
				}
				btn.y = i * 135 + beginY;
				i++;
				if(i < md.itemArr.length)
				{
					lineShape.graphics.moveTo(892,(i - 1) * 135 + beginY + 72 + 10);
					lineShape.graphics.lineTo(892,i * 135 + 72 + beginY - 10);
				}
			}
			contain.addChild(lineShape);
			
			var cirShape:CImage;
			for(var n:int = 0;n < i;n++)
			{
				cirShape = new CImage(19,19,false,false);
				cirShape.url = "source/public/playCircle.png";
//				cirShape.graphics.beginFill(0xffffff);
//				cirShape.graphics.drawCircle(0,0,radius);
//				cirShape.graphics.endFill();
				contain.addChild(cirShape);
				cirShape.x = 882;
				cirShape.y = beginY + 72 + n * 135 - 10;
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
		private var loopAlt:LoopAtlas;
		private var detailSprite:Sprite;
		private var imgContain:Sprite;
		private var loader:CLoader;
		private function enterDetailHandler(event:MouseEvent):void
		{
			
			var cb:CButton = event.currentTarget as CButton;
			loader = new CLoader();
			loader.load(cb.data);
			loader.addEventListener(CLoader.LOADE_COMPLETE,completeHandler);
		}
		private function completeHandler(event:Event):void
		{
			detailSprite.visible = true;
			imgContain.addChild(loader._loader);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,detailNull);
			scroller.reset();
		}
		private function closeDetail(event:MouseEvent):void
		{
			detailSprite.visible = false;
			while(imgContain.numChildren)
			{
				imgContain.removeChildAt(0);
			}
		}
		private function detailNull(event:Event):void
		{
			if(loader)
			{
				if(loader._loader)
				{
					loader._loader = null;
				}
				loader = null;
			}
		}
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			contain.addChild(nextBtn);
			contain.addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 118) / 2 - 118 /2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 116;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAlt.next();
			}else{
				loopAlt.prev();
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			var tb:CButton = event.currentTarget as CButton;
			var view:PictureFlowPage = new PictureFlowPage(tb.data);
			addChild(view);
		}
		public function clearAll():void
		{
			while(imgContain.numChildren)
			{
				imgContain.removeChildAt(0);
			}
			if(detailSprite)
			{
				detailSprite.visible = false;
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