package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CTextButton;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import models.RouteItemMd;
	
	public class RouteListView extends Sprite
	{
		private var dataArr:Array;
		public function RouteListView(_arr:Array)
		{
			super();
			dataArr = _arr;
			
			initBg();
		}
		private function initBg():void
		{
			
			initList();
		}
		private var group:Group = new Group();
		private function initList():void
		{
			var btn:CTextButton;
			var i:int;
			for each(var md:RouteItemMd in dataArr)
			{
				btn = new CTextButton(["source/line/lineButton/3.png","source/line/lineButton/4.png"],false);
				btn.text = md.name;
				btn.data = md;
				btn.y = 50 * i;
				addChild(btn);
				i++;
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				group.add(btn);
			}
			group.addEventListener(Cevent.SELECT_CHANGE,slectHandler);
//			group.selectById(0);
		}
		private function clickHandler(event:MouseEvent):void
		{
			var sb:CTextButton = event.currentTarget as CTextButton;
			group.selectByItem(sb);
		}
		private function slectHandler(event:Event):void
		{
			var cb:CTextButton = group.getCurrentObj() as CTextButton;
			var dataEvent:DataEvent = new DataEvent(DataEvent.CLICK);
			dataEvent.data = cb.data;
			this.dispatchEvent(dataEvent);
		}
		public function reset():void
		{
			group.selectById(0);
		}
	}
}