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
	
	import models.ActiveItemDetailMd;
	import models.YAConst;
	
	public class ActiveDetailView extends Sprite
	{
		public var SELF_WIDTH:int = 1690;
		public var SELF_HEIGHT:int = 930;
		private var md:ActiveItemDetailMd;
		public function ActiveDetailView(_md:ActiveItemDetailMd)
		{
			super();
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bg.url = md.bg;
			addChild(bg);
			
			var hcontain:Shape = new Shape();
			hcontain.graphics.beginFill(0xf6f6f6);
			hcontain.graphics.drawRoundRect(0,0,SELF_WIDTH,SELF_HEIGHT + 30,20,20);
			hcontain.graphics.endFill();
			this.addChild(hcontain);
			hcontain.y = 15;
			hcontain.x = (YAConst.SCREEN_WIDTH - SELF_WIDTH) / 2;
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var hscroll:HScroller = new HScroller(SELF_WIDTH,SELF_HEIGHT,sbar);
			detailcontent = new Sprite();
			hscroll.target = detailcontent;
			hscroll.barX = SELF_WIDTH + 30;
			hscroll.y = 30;
			hscroll.x = (YAConst.SCREEN_WIDTH - SELF_WIDTH) / 2;
			addChild(hscroll);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 90;
			backBtn.y = 20;
			
			var loader:CLoader = new CLoader();
			loader.load(md.content);
			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
		}
		private function closeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private var detailcontent:Sprite;
		private function okHandler(event:Event):void
		{
			var l:CLoader = event.currentTarget as CLoader;
			detailcontent.addChild(l._loader);
		}
	}
}