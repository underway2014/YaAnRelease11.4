package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.interfaces.PageClear;
	import core.loadEvents.CLoader;
	import core.loadEvents.Cevent;
	
	import models.TelMd;
	import models.YAConst;
	
	public class TelPage extends Sprite implements PageClear
	{
		private var md:TelMd;
		private var imgContain:Sprite;
		public function TelPage(_md:TelMd)
		{
			super();
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false);
			bg.url = md.bg;
			addChild(bg);
			
			
			
//			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
//			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,sbar);
//			addChild(hscroll);
//			hscroll.barX = YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN;
//			imgContain = new Sprite();
//			hscroll.target = imgContain;
			
//			var loader:CLoader = new CLoader();
//			loader.load(md.url);
//			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			
			var img:CImage;
			var i:int = 0;
			var imgArr:Array = new Array();
			for each(var url:String in md.contentArr)
			{
				img = new CImage(1666,869,false,false);
				img.url = url;
				imgArr.push(img);
			}
			
			loop = new LoopAtlas(imgArr,false);
			loop.size = new Point(1666,869);
			loop.x = (YAConst.SCREEN_WIDTH - loop.size.x) / 2;
			loop.y = 50;
			addChild(loop);
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 90;
			backBtn.y = 20;
			this.dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
			initPageButton();
		}
		private var loop:LoopAtlas;
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			addChild(nextBtn);
			addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 90 - 88) / 2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 90;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loop.next();
			}else{
				loop.prev();
			}
		}
		
		private function okHandler(event:Event):void
		{
			var el:CLoader = event.currentTarget as CLoader;
			imgContain.addChild(el._loader);
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		public function clearAll():void
		{
			loop.gotoPage(0);
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