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
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.YAConst;
	
	
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
			
			contain = new Sprite();
			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			drag.target = contain;
			addChild(drag);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			
			init();
			
		}
		private function init():void
		{
			var pageImg:CImage;
			var i:int = 0;
			for each(var pmd:LinePageMd in lineData.pageArr)
			{
				pageImg = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
				pageImg.url = pmd.bg;
				pageImg.x = YAConst.SCREEN_WIDTH * i;
				contain.addChild(pageImg);
				var btn:CButton;
				for each(var pimd:LineItemMd in pmd.itemArr)
				{
					btn = new CButton(pimd.skin,false,false);
					btn.x = pimd.coordXY.x;
					btn.y = pimd.coordXY.y;
					pageImg.addChild(btn);
					btn.addEventListener(MouseEvent.CLICK,clickHandler);
				}
				i++;
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
		private function clickHandler(event:MouseEvent):void
		{
			trace("line page btn click..");
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		public function clearAll():void
		{
			
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