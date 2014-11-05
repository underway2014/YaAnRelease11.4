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
	import core.interfaces.PageClear;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	
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
			btnSprite.y = 140;
			addChild(btnSprite);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			
//			var timer:Timer = new Timer(100,1);
//			timer.addEventListener(TimerEvent.TIMER,timerYcHandler);
//			timer.start();å
			init();
		}
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
				btn.y = i * 167;
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
		private function slectHandler(event:Event):void
		{
			var ccb:CButton = group.getCurrentObj() as CButton;
			if(mtcSonView)
			{
				if(mtcSonView.parent)
				{
					mtcSonView.parent.removeChild(mtcSonView);
				}
			}
			
			mtcSonView = new MtcSonView(ccb.data);
			mtcSonView.addEventListener(Event.REMOVED_FROM_STAGE,sonViewNull);
			addChild(mtcSonView);
			mtcSonView.x = btnSprite.x + 353 + 30;
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
			if(mtcSonView && mtcSonView.parent)
			{
				this.removeChild(mtcSonView);
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