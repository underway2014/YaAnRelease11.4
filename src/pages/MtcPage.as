package pages
{
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.interfaces.PageClear;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import models.MtcItemMd;
	import models.MtcMd;
	import models.YAConst;
	
	import views.MtcSonView;
	
	public class MtcPage extends Sprite implements PageClear
	{
		private var md:MtcMd;
		public function MtcPage(_md:MtcMd)
		{
			super();
			
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			bg.url = md.bg;
			addChild(bg);
			
			btnSprite = new Sprite();
			btnSprite.x = 100;
			btnSprite.y = 178;
			addChild(btnSprite);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			
			sonSprite = new Sprite();
			addChild(sonSprite);
			sonSprite.y = btnSprite.y;
			grandSonSprite = new Sprite();
			addChild(grandSonSprite);
			blackMask = new Shape();
			blackMask.graphics.beginFill(0x000000,.8);
			blackMask.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			blackMask.graphics.endFill();
			grandSonSprite.addChild(blackMask);
			grandSonSprite.visible = false;
//			var timer:Timer = new Timer(100,1);
//			timer.addEventListener(TimerEvent.TIMER,timerYcHandler);
//			timer.start();å
			init();
		}
		private var sonSprite:Sprite;
		private var grandSonSprite:Sprite;
		private var blackMask:Shape;
		private function timerYcHandler(event:TimerEvent):void
		{
		}
		private var btnSprite:Sprite;
		private var group:Group = new Group();
		private function init():void
		{
			var btn:CButton;
			var i:int = 0;
			var line:Shape;
			for each(var imd:MtcItemMd in md.itemArr)
			{
				btn = new CButton(imd.skin,false);
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				group.add(btn);
				btn.data = imd;
				btn.y = i * 156;
				btnSprite.addChild(btn);
				i++;
			}
//			group.selectById(0);
			group.addEventListener(Cevent.SELECT_CHANGE,slectHandler);
			dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
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
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			group.selectByItem(cb);
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		private var mtcSonView:MtcSonView;
		private var arrowShape:Shape;
		private function slectHandler(event:Event):void
		{
			if(!arrowShape)
			{
				arrowShape = new Shape();
				arrowShape.graphics.beginFill(0xffffff);
				arrowShape.graphics.moveTo(0,0);
				arrowShape.graphics.lineTo(15,-10);
				arrowShape.graphics.lineTo(15,10);
				arrowShape.graphics.lineTo(0,0);
				arrowShape.graphics.endFill();
				sonSprite.addChild(arrowShape);
			}
			
			var ccb:CButton = group.getCurrentObj() as CButton;
			if(mtcSonView)
			{
				if(mtcSonView.parent)
				{
					mtcSonView.parent.removeChild(mtcSonView);
				}
			}
			// son view
			var mmd:MtcItemMd = ccb.data;
			mtcSonView = new MtcSonView(mmd);
			mtcSonView.addEventListener(DataEvent.CLICK,showDetailHandler);
			mtcSonView.addEventListener(Event.REMOVED_FROM_STAGE,sonViewNull);
			sonSprite.addChild(mtcSonView);
			mtcSonView.x = btnSprite.x + 353 + 30;
			
			arrowShape.visible = true;
			arrowShape.x = mtcSonView.x - 20;
			
			var len:int = mmd.itemArr.length;
			var cuId:int = group.getCurrentId();
			var leftC:int = cuId * 156 + 156 / 2;
			arrowShape.y = leftC;
			
			var rHeight:int = len * 104;
			
			var yy:int = leftC - rHeight / 2;
			
			mtcSonView.y = yy;
		}
		/**
		 *show grandson content 
		 * @param event
		 * 
		 */		
		private function showDetailHandler(event:DataEvent):void
		{
			grandSonSprite.visible = true;
			detailImg = new CImage(1575,830,false,false);
			detailImg.y = (YAConst.SCREEN_HEIGHT - 90 - 830) / 2;
			detailImg.x = (YAConst.SCREEN_WIDTH - 1575) / 2;
			detailImg.url = event.data;
			grandSonSprite.addChild(detailImg);
			detailImg.addEventListener(Event.REMOVED_FROM_STAGE,setDetialNull);
			var carr:Array = ["source/public/close.png","source/public/close.png"];
			var closeDetailBtn:CButton = new CButton(carr,false,false);
			closeDetailBtn.addEventListener(MouseEvent.CLICK,closeGrandView);
			grandSonSprite.addChild(closeDetailBtn);
			closeDetailBtn.x = detailImg.x + 1575 - 82;
			closeDetailBtn.y = 10;
		}
		private var detailImg:CImage;
		private function closeGrandView(event:MouseEvent):void
		{
			grandSonSprite.visible = false;
			if(!detailImg) return;
			if(detailImg.parent)
			{
				detailImg.parent.removeChild(detailImg);
			}
		}
		private function setDetialNull(event:Event):void
		{
			if(detailImg)
			{
				detailImg = null;
			}
		}
		private function sonViewNull(event:Event):void
		{
			if(mtcSonView)
			{
				mtcSonView = null;
			}
		}
		public function clearAll():void
		{
			closeGrandView(null);
			if(mtcSonView && mtcSonView.parent)
			{
				mtcSonView.parent.removeChild(mtcSonView);
			}
			if(arrowShape)
			{
				arrowShape.visible = false;
			}
			group.selectById(-1);
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