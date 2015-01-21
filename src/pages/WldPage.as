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
	import core.tween.TweenLite;
	
	import models.WldItemMd;
	import models.WldMd;
	import models.YAConst;
	
	public class WldPage extends Sprite implements PageClear
	{
		private var md:WldMd;
		private var contain:Sprite;
		private var moveLineContain:Sprite;
		public function WldPage(_md:WldMd)
		{
			super();
			md = _md;
			
			contain = new Sprite();
			moveLineContain = new Sprite();
			
			var img:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			img.url = md.background;
			this.addChild(img);
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN,YAConst.SCREEN_HEIGHT - 150);
//			hscroll.target = contain;
			hscroll.x = 200;
//			addChild(hscroll);
			addChild(contain);
			addChild(moveLineContain);
			moveLineContain.x = 200;
			contain.x = 200;
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
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
			closeDetailBtn.x = YAConst.BACKBUTTONX;
			closeDetailBtn.y = YAConst.BACKBUTTONY;
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
			btnArray = [];
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
				btn.alpha = 0;
				btnArray.push(btn);
			}
			moveLineContain.addChild(lineShape);
			
			var cirShape:CImage;
			for(var n:int = 0;n < i;n++)
			{
				cirShape = new CImage(19,19,false,false);
				cirShape.url = "source/public/playCircle.png";
				moveLineContain.addChild(cirShape);
				cirShape.x = 882;
				cirShape.y = beginY + 72 + n * 135 - 10;
			}
			
			lineMask = new Shape();
			lineMask.graphics.beginFill(0xaa0000,.3);
			lineMask.graphics.drawRect(0,0,30,1080);
			lineMask.graphics.endFill();
			lineMaskBeginY = beginY + 72 - 1080 -10 + 20;
			trace("init lineMaskBeginY = ",lineMaskBeginY);
			lineMask.y = lineMaskBeginY;
			lineMask.x = 880 + 200;
			this.addChild(lineMask);
			moveLineContain.mask = lineMask;
//			moveLineContain.mask 
			
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
		private var lineMaskBeginY:int;
		private var btnArray:Array;
		private var lineMask:Shape;
		private function autoMove():void
		{
			moveHandler();
		}
		private var cn:int = 0;
		private function moveHandler():void
		{
			if(cn >= btnArray.length || isHiden)
			{
				return;
			}
			var bobj:Sprite = btnArray[cn];
//			bobj.filters = CFilter.shadowFilter;
			bobj.alpha = 1;
			var bx:int = (cn % 2) == 0 ? (-400):(1930);
			TweenLite.from(bobj,.3,{x:bx,onComplete:moveOverHandler});
		}
		private function moveOverHandler():void
		{
			var cb:Sprite = btnArray[cn];
//			cb.filters = null;
			var ly:int = lineMask.y + 135;
			TweenLite.to(lineMask,.3,{y:ly,onComplete:lineMoveOver});
			cn++;
			moveHandler();
		}
		private function lineMoveOver():void
		{
			
		}
		private var timer:Timer;
		private function dispatchHandler(event:Event):void
		{
			dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
			autoMove();
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
		private var isHiden:Boolean = false;
		public function hide():void
		{
			this.visible = false;
			trace("hide lineMaskBeginY = ",lineMaskBeginY);
			
			for each(var oo:Sprite in btnArray)
			{
				oo.alpha = 0;
			}
			isHiden = true;
		}
		public function show():void
		{
			lineMask.y = lineMaskBeginY;
			isHiden = false;
			cn = 0;
			this.visible = true;
			autoMove();
		}
	}
}