package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	
	import models.MtcItemDetalMd;
	import models.MtcItemMd;
	
	public class MtcSonView extends Sprite
	{
		private var md:MtcItemMd;
		public function MtcSonView(_md:MtcItemMd)
		{
			super();
			
			md = _md;
			
			var nameImg:CImage = new CImage(489,66,true,false);
			nameImg.url = md.name;
			addChild(nameImg);
			
			initList();
		}
		private function initList():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var dmd:MtcItemDetalMd in md.itemArr)
			{
				btn = new CButton(dmd.skin,false,true);
				btn.data = dmd.detail;
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.y = i * 155 + 66;
				addChild(btn);
				i++;
				group.add(btn);
			}
			group.addEventListener(Cevent.SELECT_CHANGE,slectHandler);
//			group.
		}
		private var group:Group = new Group();
		private var detailImg:CImage;
		
		private function slectHandler(event:Event):void
		{
			if(detailImg)
			{
				if(detailImg.parent)
				{
					detailImg.parent.removeChild(detailImg);
				}
			}
			var ccb:CButton = group.getCurrentObj() as CButton;
			detailImg = new CImage(604,781,true,false);
			detailImg.url = ccb.data;
			detailImg.addEventListener(Event.REMOVED_FROM_STAGE,detailNull);
			addChild(detailImg);
			detailImg.x = 489 + 30;
		}
		private function detailNull(event:Event):void
		{
			if(detailImg)
			{
				detailImg = null;
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			group.selectByItem(cb);
		}
	}
}