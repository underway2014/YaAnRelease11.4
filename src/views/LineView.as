package views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.loadEvents.CLoader;
	
	import models.LineItemMd;
	import models.YAConst;
	
	public class LineView extends Sprite
	{
		private var md:LineItemMd;
		public function LineView(_md:LineItemMd)
		{
			super();
			
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bg.url = md.bg;
			addChild(bg);
			var bgBorer:Shape = new Shape();
			bgBorer.graphics.beginFill(0xf6f6f6);
			bgBorer.graphics.drawRoundRect(0,0,1740,960,20,20);
			bgBorer.graphics.endFill();
			addChild(bgBorer);
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var scroller:HScroller = new HScroller(1740,930,sbar);
			contain = new Sprite();
			scroller.target = contain;
			addChild(scroller);
			scroller.y = 30;
			scroller.x = (YAConst.SCREEN_WIDTH - 1740) / 2;
			scroller.barX = 1740 + 27;
			bgBorer.x = (YAConst.SCREEN_WIDTH - 1740) / 2;
			bgBorer.y = 15;
			
//			var carr:Array = ["source/public/close.png","source/public/close.png"];
//			var closeDetailBtn:CButton = new CButton(carr,false,false);
//			closeDetailBtn.addEventListener(MouseEvent.CLICK,closeDetail);
//			closeDetailBtn.x = scroller.x + 1740 - 82;
//			closeDetailBtn.y = 40;
//			addChild(closeDetailBtn);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,closeDetail);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 84;
			backBtn.y = 20;
			
			loader = new CLoader();
			loader.load(md.detail);
			loader.addEventListener(CLoader.LOADE_COMPLETE,completeHandler);
		}
		private var loader:CLoader;
		private function completeHandler(event:Event):void
		{
			contain.addChild(loader._loader);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,setNull);
//			loader._loader.x = (YAConst.SCREEN_WIDTH - loader._loader.width) / 2;
//			loader._loader.y = 30;
			
		}
		private var contain:Sprite;
		private function closeDetail(evetn:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private function setNull(event:Event):void
		{
			loader._loader = null;
			loader = null;
		}
	}
}