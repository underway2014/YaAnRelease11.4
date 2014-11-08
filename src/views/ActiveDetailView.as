package views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
//			this.graphics.beginFill(0xffffff);
//			this.graphics.drawRect(
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bg.url = md.bg;
			addChild(bg);
			
			var hcontain:Sprite = new Sprite();
//			hcontain.graphics.beginFill(0xffffff);
//			hcontain.graphics.drawRect(0,-10,SELF_WIDTH,SELF_HEIGHT);
//			hcontain.graphics.endFill();
			this.addChild(hcontain);
			hcontain.y = 30;
			hcontain.x = (YAConst.SCREEN_WIDTH - SELF_WIDTH) / 2;
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var hscroll:HScroller = new HScroller(SELF_WIDTH,SELF_HEIGHT,sbar);
			hscroll.barX = SELF_WIDTH + 30;
//			hscroll.y = 10;
			hcontain.addChild(hscroll);
//			hscroll.x = (YAConst.SCREEN_WIDTH - SELF_WIDTH) / 2;
//			hscroll.y = 50;
			content = new Sprite();
			hscroll.target = content;
			
			var topWiteShape:Shape = new Shape();
			topWiteShape.graphics.beginFill(0xaa0000,.4);
			topWiteShape.graphics.drawRect(0,0,SELF_WIDTH,15);
			topWiteShape.graphics.endFill();
			addChild(topWiteShape);
			hcontain.addChild(topWiteShape);
			
			var closeImage:CImage = new CImage(66,58,true,false);
			closeImage.url = "source/public/close.png";
			addChild(closeImage);
			closeImage.x = SELF_WIDTH - closeImage.width;
			closeImage.y = 5;
			closeImage.addEventListener(MouseEvent.CLICK,closeHandler);
			
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
		private var content:Sprite;
		private function okHandler(event:Event):void
		{
			var l:CLoader = event.currentTarget as CLoader;
			content.addChild(l._loader);
		}
	}
}