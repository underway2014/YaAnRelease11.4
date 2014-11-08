package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
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
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,sbar);
			addChild(hscroll);
			hscroll.barX = YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN;
			imgContain = new Sprite();
			hscroll.target = imgContain;
			
//			var loader:CLoader = new CLoader();
//			loader.load(md.url);
//			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			
			var img:CImage;
			var i:int = 0;
			for each(var url:String in md.contentArr)
			{
				img = new CImage(YAConst.SCREEN_WIDTH,2160,false,false);
				img.url = url;
				imgContain.addChild(img);
				img.y = i * YAConst.SCREEN_HEIGHT;
				i++;
			}
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			backBtn.y = 30;
			this.dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
		
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